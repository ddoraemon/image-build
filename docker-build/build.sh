#!/usr/bin/env bash
set -euo pipefail
set -x

echo "当前基础构建镜像版本为 ---> ${VERSION}"

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
use_cache=true
dockerfile="Dockerfile"

# 架构开关
declare -A arch_map=( ["arm64"]=false ["amd64"]=false )

while getopts "axplr:t:c:" opt; do
  case "$opt" in
    a) arch_map["arm64"]=true ;;
    x) arch_map["amd64"]=true ;;
    p) push=true ;;
    l) latest=true ;;
    f) dockerfile="$OPTARG" ;;
    r) repo="$OPTARG" ;;
    t) tag="$OPTARG" ;;
    c) use_cache="$OPTARG" ;;
    *) echo "Usage: $0 [-a] [-x] [-p] [-l] [-f dockerfile] [-r repo] [-t tag] [-c use_cache]"; exit 1 ;;
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

  local cache_flag=""
  if [ "$use_cache" = "false" ]; then
    cache_flag="--no-cache"
  fi

  if [ "$push" != true ]; then
    docker buildx build --platform=linux/${arch} -f ${repo}/${dockerfile} --build-arg VERSION=${tag} -t registry.cn-hangzhou.aliyuncs.com/rotigue/${repo}:${image_tag} --provenance=false --sbom=false ${cache_flag} ./${repo}
  else
    docker buildx build --platform=linux/${arch} -f ${repo}/${dockerfile} --build-arg VERSION=${tag} -t registry.cn-hangzhou.aliyuncs.com/rotigue/${repo}:${image_tag} --provenance=false --sbom=false ${cache_flag} --push ./${repo}
  fi
}

# 构建选中的架构
for arch in "${!arch_map[@]}"; do
  if ${arch_map[$arch]}; then
    build_and_push "$arch"
  fi
done
