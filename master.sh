#!/usr/bin/env bash
set -xe
source common.sh
etcdctl set /coreos.com/network/config < flannel-config.json
