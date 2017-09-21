#!/usr/bin/env bash
set -xe
source common.sh

configure_etcd fed-master
configure_kubernetes

systemctl enable etcd
systemctl start etcd

etcdctl --endpoints=http://fed-master:2379 set /coreos.com/network/config < flannel-config.json

for SERVICES in etcd kube-apiserver kube-controller-manager kube-scheduler; do
    systemctl restart $SERVICES
    systemctl enable $SERVICES
    systemctl status $SERVICES
done

kubectl create -f ./fed-node.json
