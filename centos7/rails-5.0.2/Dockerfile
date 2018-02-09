FROM centos:7
LABEL maintainer="Jorge Luis"

ENV container docker

RUN yum update -y glibc-common

RUN yum -y install systemd

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
    systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;\
    rm -f /lib/systemd/system/anaconda.target.wants/*;

RUN yum install -y sudo passwd openssh-server openssh-clients tar screen crontabs && \
    yum install -y strace telnet perl libpcap bc patch ntp dnsmasq unzip pax nano && \
    yum install -y automake autoconf gcc gcc-c++ make openssl-devel bison git && \
    yum install -y libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel && \
    yum install -y curl which gzip bzip2 zip which && \
    yum install -y mariadb-devel postgresql-libs postgresql-devel && \
    yum install -y yum-utils libtool sqlite sqlite-devel && \
    yum install -y kernel-headers --disableexcludes=all && \
    curl --silent --location https://rpm.nodesource.com/setup_8.x | bash - &&\
    yum install -y nodejs && \
    curl -o /etc/yum.repos.d/yarn.repo https://dl.yarnpkg.com/rpm/yarn.repo && \
    yum install -y yarn && \
    yum clean all

##########################################################################
# add epel repository
RUN yum install -y epel-release
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN rpm --import https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7
# for old "service"
RUN yum install -y initscripts
# install imagemagik to paperclip
RUN yum install -y ImageMagick ImageMagick-devel

RUN (rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm; \
     yum install -y puppet puppet-server puppetserver facter hiera lsyncd sshpass)

# install ngnix
RUN rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
RUN yum install -y nginx

RUN echo "root:root" | chpasswd

ADD ./start.sh /start.sh
RUN mkdir /var/run/sshd

RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' 

RUN chmod 755 /start.sh

RUN ./start.sh

USER www-data

#install rvm, ruby and rails
#RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
#RUN /bin/bash -l -c "curl -L get.rvm.io | bash -s stable"
#RUN /bin/bash -l -c "source ~/.rvm/scripts/rvm"
#RUN /bin/bash -l -c "rvm requirements"
#RUN /bin/bash -l -c "rvm install 2.4"
#RUN /bin/bash -l -c "echo 'gem: --no-ri --no-rdoc' > ~/.gemrc"
#RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"
#RUN /bin/bash -l -c "gem install rails -v 5.0.2"

USER root

#settings docker container 
EXPOSE 22
EXPOSE 3000
EXPOSE 80
EXPOSE 81

VOLUME [ "/sys/fs/cgroup" ]

ENTRYPOINT ["/usr/sbin/sshd", "-D"]
