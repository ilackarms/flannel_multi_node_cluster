#!/usr/bin/env bash
set -xe
source common.sh

configure_etcd fed-node
configure_kubernetes

yum -y install flannel
cat > /etc/sysconfig/flanneld <<EOF
# Flanneld configuration options

# etcd url location.  Point this to the server where etcd runs
FLANNEL_ETCD="http://fed-master:2379"

# etcd config key.  This is the configuration key that flannel queries
# For address range assignment
FLANNEL_ETCD_KEY="/coreos.com/network"

# Any additional options that you want to pass
FLANNEL_OPTIONS=""
EOF

systemctl enable flanneld
systemctl stop docker
set +e
ip link delete docker0
set -e
systemctl start flanneld
systemctl start docker

for SERVICES in kube-proxy kubelet docker; do
    systemctl restart $SERVICES
    systemctl enable $SERVICES
    systemctl status $SERVICES
done
