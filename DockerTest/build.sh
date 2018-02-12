#!/bin/bash 


prefix="hicoin"
declare -A apps
#[broker]="./src/Hosts/Hicoin.EQueue.MessageBroker"
apps=([test]="./DockerTest")


if [ "$1" =  "" ] 
then
	echo '编译所有项目'
else
	echo '只编译 $1'
	apps=([$1]=apps[$1])
fi

for app in $(echo ${!apps[*]})
do
    echo "$app : ${apps[$app]}"

    echo --------------开始编译 $app----------------

    docker build -t $prefix:$app.build-${BUILD_NUMBER} -f ${apps[$app]}/Dockerfile .

    echo --------------添加TAG----------------

    docker tag $prefix:$app.build-${BUILD_NUMBER} $REGISTRY_API/$prefix:$app.build-${BUILD_NUMBER}

    echo --------------推送到仓库----------------

    docker push $REGISTRY_API/$prefix:$app.build-${BUILD_NUMBER}

    echo --------------删除本地镜像----------------

    docker rmi $prefix:$app.build-${BUILD_NUMBER}

    docker rmi $REGISTRY_API/$prefix:$app.build-${BUILD_NUMBER}
done
