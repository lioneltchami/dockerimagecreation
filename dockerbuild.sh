#!/bin/bash

#Author: Apoti Eri (Lionel)

echo "Are you working on centos or ubuntu?"
read plat

if [ ${plat} = centos ]
then
yum install docker -y
fi

if [ ${plat} = ubuntu ]
then
apt-get install docker -y
fi

echo -e "What is your name please?"
read name


echo -e "\nWhat base image do you prefer? (centos, ubuntu, alpine)\n"
read base

echo -e "what version do you want please? (latest)?\n"
read v

echo -e "What name do you want to give to the folder which is going to be  copy of this container on your system?\n"
read vol

echo -e "Do you want to have a port exposed? Which one please?(numbers only please)\n"
read p

echo -e "What programs or applications do you want install? (vim, httpd, curl, wget, docker, finger? (please separate them with space)\n"
read app

echo -e "What is the name of that file or directory you want to copy into the image? NB: Please make sure that you are running this script in                                                                                                                                                                                                                                                                                                                                 the same directory where that file or folder is found\n"
read c


if [ ${base} = centos ]
then
sleep 3
echo -e "Building a ${base} image, version ${v} with port ${p} opened and installing ${app}.\n"
sleep 3
echo -e "FROM ${base}:${v}\nMAINTAINER ${name}\nRUN yum update -y\nRUN yum install ${app} -y\nRUN systemctl enable httpd\nRUN systemctl start                                                                                                                                                                                                                                                                                                                                 httpd\nCOPY ./${c} /var/www/html\nEXPOSE ${p}\nCMD apachectl -D FOREGROUND" > dockerfile
fi

if [ ${base} = alpine ]
then
sleep 3
echo -e "Building a ${base} image, version ${v} with port ${p} opened and installing ${app}.\n"
sleep 3
echo -e "FROM ${base}:${v}\nMAINTAINER ${name}\nRUN apk update\nRUN apk add ${app}\nRUN systemctl enable httpd\nRUN systemctl start httpd\nCOP                                                                                                                                                                                                                                                                                                                                Y ./${c} /usr/local/apache2/htdocs\nEXPOSE ${p}\nCMD apachectl -D FOREGROUND" > dockerfile
fi

if [ ${base} = ubuntu ]
then
sleep 3
echo -e "Building a ${base} image, version ${v} with port ${p} opened and installing ${app}.\n"
sleep 3
echo -e "FROM ${base}:${v}\nMAINTAINER ${name}\nRUN apt-get update -y\nRUN apt-get install ${app} -y\nRUN systemctl enable httpd\nRUN systemct                                                                                                                                                                                                                                                                                                                                l start httpd\nCOPY ./${c} /usr/local/apache2/htdocs\nEXPOSE ${p}\nCMD apachectl -D FOREGROUND" > dockerfile
fi

#systemctl enable httpd
#systemctl start httpd

docker build -t ${name}/${base}-httpd .

docker push ${name}/${base}-httpd

docker run -itv ${v}:/var/www/html -p 97 ${name}/${base}-httpd bash

if [ $? = 0 ]
then
echo "Successfully created"
rm -rf dockerfile
sleep 1
echo "Yaaaaaaay a don chop beans"
else
echo "Docker image creation failed"
fi
