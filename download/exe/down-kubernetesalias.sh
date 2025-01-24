
#!/bin/bash

# 检查 containerd 是否已安装
if command -v containerd &> /dev/null; then
    echo "containerd 已安装"
else
    echo "containerd 未安装"
    exit 0
fi    

# 默认容器镜像名称
kubernetesalias_VERSION="v20250124"

# 如果有参数传入，则使用传入的容器镜像名称；否则使用默认值
if [ -n "$1" ]; then
    kubernetesalias_VERSION="$1"

fi

echo "使用的容器镜像名称为: $kubernetesalias_VERSION"

mkdir kubernetesalias

function containerd_down_kubernetesalias(){
    echo containerd_down_kubernetesalias
    ctr i pull registry.cn-hangzhou.aliyuncs.com/huisebug/kubernetesalias:${kubernetesalias_VERSION}
    ctr run --rm  --mount type=bind,src=$(pwd)/kubernetesalias,dst=/tmp,options=rbind:rw registry.cn-hangzhou.aliyuncs.com/huisebug/kubernetesalias:${kubernetesalias_VERSION} kubernetesalias sh -c 'cp -rf /usr/local/bin/* /tmp/'

}
function chmod_kubernetesalias(){
    chmod +x kubernetesalias/*
    cp -rf kubernetesalias/* /usr/bin/
}

containerd_down_kubernetesalias && chmod_kubernetesalias