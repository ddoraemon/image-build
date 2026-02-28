#!/bin/bash
set -e

if [ -f "./pre_build.sh" ]; then
    source ./pre_build.sh
else
    # 如果没有定义，给个空函数，避免报错
    before_build() { :; }
    pre_build() { :; }

fi

repo=""
tag=""
push=false
latest=false

# 架构开关
declare -A arch_map=( ["arm64"]=false ["amd64"]=false )

while getopts "axplr:t:f:" opt; do
  case "$opt" in
    a) arch_map["arm64"]=true ;;
    x) arch_map["amd64"]=true ;;
    p) push=true ;;
    l) latest=true ;;
    r) repo="$OPTARG" ;;
    t) tag="$OPTARG" ;;
    *) echo "Usage: $0 [-a] [-x] [-p] [-l] [-r repo] [-t tag]"; exit 1 ;;
  esac
done

# 检查必填参数
if [ -z "$repo" ]; then
    echo "Error: -r (repo) is required"
    exit 1
fi

if [ -z "$tag" ]; then
    echo "Error: -t (tag) is required"
    exit 1
fi

# 如果都没选，则默认都构建并推送
if ! ${arch_map["arm64"]} && ! ${arch_map["amd64"]} && [ "$push" != true ]; then
  arch_map["arm64"]=true
  arch_map["amd64"]=true
  push=true
  latest=true
fi

if [ -f "./${repo}/pre_build.sh" ]; then
    source ./${repo}/pre_build.sh
else
    # 如果没有定义，给个空函数，避免报错
    before_build() { :; }
    pre_build() { :; }

fi

before_build

# 构建函数
build_and_push() {
  local arch="$1"
  local image_tag="${tag}-${arch}"

  echo "Building $arch image..."
  pre_build "$arch"

  docker buildx build --platform=linux/${arch} -f ${repo}/Dockerfile -t registry.cn-hangzhou.aliyuncs.com/rotigue/${repo}:${image_tag} --provenance=false --sbom=false --push .
}

# 构建选中的架构
for arch in "${!arch_map[@]}"; do
  if ${arch_map[$arch]}; then
    build_and_push "$arch"
  fi
done

# 创建 manifest
if [ "$push" = true ]; then
  rm -rf ~/.docker/manifests
  mkdir -p ~/.docker/manifests

  manifest_arches=()
  registry_manifest_arches=()
  for arch in "${!arch_map[@]}"; do
    if ${arch_map[$arch]}; then
      manifest_arches+=( "rotigue/${repo}:${tag}-${arch}" )
      registry_manifest_arches+=( "registry.cn-hangzhou.aliyuncs.com/rotigue/${repo}:${tag}-${arch}" )
    fi
  done

  echo "Creating and pushing manifest for tag $tag..."
  docker manifest create rotigue/${repo}:${tag} "${manifest_arches[@]}"
  docker manifest push rotigue/${repo}:${tag}

  docker manifest create registry.cn-hangzhou.aliyuncs.com/rotigue/${repo}:${tag} "${registry_manifest_arches[@]}"
  docker manifest push registry.cn-hangzhou.aliyuncs.com/rotigue/${repo}:${tag}

  if [ "$latest" = true ]; then
    echo "Creating and pushing manifest for latest..."
    docker manifest create rotigue/${repo}:latest "${manifest_arches[@]}"
    docker manifest push rotigue/${repo}:latest

    docker manifest create registry.cn-hangzhou.aliyuncs.com/rotigue/${repo}:latest "${registry_manifest_arches[@]}"
    docker manifest push registry.cn-hangzhou.aliyuncs.com/rotigue/${repo}:latest
  fi
fi
