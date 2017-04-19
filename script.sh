#!/bin/bash

echo "Provisioning platform"

echo "Installing essential software"

yum -y update

yum -y install wget curl net-tools git nginx meld python2.7 python-pip yum-utils

 yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

yum -y install docker-ce

usermod -G docker vagrant

service docker start

echo "Now deploying containers"

echo "Registry"

docker ps | grep registry

if [[ $? -ne 0 ]];then
	docker run -d -p 5000:5000 --restart always --name registry registry:2
fi

echo "Jenkins"
docker ps | grep jenkins

if [[ $? -ne 0 ]];then
	docker run -d -p 8080:8080 -p 50000:50000 --restart always --privileged -v /var/run/docker.sock:/var/run/docker.sock:rw \
       -v $(which docker):/bin/docker -e JENKINS_OPTS="--prefix=/jenkins" jenkins
fi

DOCKER_CONTAINER=$(docker ps | grep jenkins | awk '{print $1}')
echo "Jenkins Password:"
docker exec $DOCKER_CONTAINER cat /var/jenkins_home/secrets/initialAdminPassword

# Nexus

echo "Nexus"

docker ps | grep nexus

if [[ $? -ne 0 ]];then
        docker run -d -p 8081:8081 --restart always sonatype/nexus:latest
        echo "Nexus deployed. Use admin / admin123 to login on port 8081"
fi

# Sonarqube
echo "Sonarqube"

docker ps | grep sonar

if [[ $? -ne 0 ]];then
	docker run -d -p 9000:9000 -p 9092:9092 sonarqube
fi

# HAProxy

if ! [[ -d /vagrant/haproxy ]];then
mkdir /vagrant/haproxy
fi

echo "HAProxy frontend" > /vagrant/haproxy/200.http
docker run --privileged -d --net=host -v /vagrant/haproxy:/usr/local/etc/haproxy/ -p 80:80 haproxy


echo "Done"
