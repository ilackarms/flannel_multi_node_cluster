#!/usr/bin/env bash
set -xe
source common.sh

yum -y install flannel
cat > /etc/sysconfig/flanneld <<EOF
# Flanneld configuration options

# etcd url location.  Point this to the server where etcd runs
FLANNEL_ETCD="http://${MASTER:-10.8.29.123}:2379"

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
