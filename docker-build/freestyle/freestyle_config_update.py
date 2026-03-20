# -*- coding: utf-8 -*-
# @Author   : 完皓
# @Time     : 2024/6/3 10:45
# @File     : freestyle_config_update
import yaml
import requests
import os
import time
import sys


def log_print(msg):
    print("%s %s" % (time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time())), msg))
    sys.stdout.flush()


class FreestyleConfig:

    def __init__(self):
        self.config_file = "/home/admin/app/freestyle/config/config.yaml"
        self.config = yaml.safe_load(open(self.config_file).read())

    def get_external_controller_port(self):
        return self.config["external-controller"].split(":")[1]

    def get_secret(self):
        return self.config["secret"]

    def reload_config(self, config_file=None):
        if config_file is None:
            config_file = self.config_file

        res = requests.put("http://127.0.0.1:{}/configs".format(self.get_external_controller_port()), headers={
            "Content-Type": "application/json",
            "Authorization": "Bearer {}".format(self.get_secret())
        }, json={"path": config_file})
        log_print("重新加载配置返回: {}".format(res.status_code))

    def update_config(self, update, node_list):
        if "all" in node_list:
            self.config = update
        else:
            for node in node_list:
                self.config[node] = update[node]

        with open(self.config_file, "w") as fp:
            fp.write(yaml.dump(self.config, allow_unicode=True, default_flow_style=False))

        self.reload_config()


def get_subscribe_config():
    url = os.environ.get("SUB_URL")
    resp = requests.get(url, headers={"User-Agent": "ClashX/1.96.2 (com.west2online.ClashX; build:1.96.2; macOS 14.5.0) Alamofire/5.6.2"})
    config = yaml.safe_load(resp.text)
    log_print("下载配置成功")
    return config


if __name__ == '__main__':
    fresh = os.environ.get("FRESH")
    log_print("start")
    interval = int(os.environ.get("INTERVAL", "3600"))
    node_list = os.environ.get("NODE", "proxies,proxy-groups,rules")
    current_config = FreestyleConfig()
    while True:
        if "true" == fresh:
            log_print("即将更新配置")
            sub_config = get_subscribe_config()
            current_config.update_config(sub_config, node_list.split(","))
        time.sleep(interval)

