for ip in $(cat my-config.json | jq values[] -r); do rsync -r . root@$ip:/root/flannel_multi_node_cluster; done
