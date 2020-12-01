Dockerfile:

===============================================
FROM ubuntu

RUN export DEBIAN_FRONTEND=noninteractive && \
apt-get update && apt full-upgrade -y && \
apt-get install nginx aptitude -y && \
aptitude install php-fpm -y

==============================================

docker build -t hiro/nginxphp .
