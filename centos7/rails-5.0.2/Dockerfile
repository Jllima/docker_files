FROM centos:7.4.1708
LABEL maintainer="Jorge Luis"

RUN yum update -y glibc-common


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
RUN rpm -Uvh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN rpm --import https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7


RUN (rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm; \
     yum install -y puppet puppet-server puppetserver facter hiera lsyncd sshpass)

RUN echo "root:root" | chpasswd

ADD ./start.sh /start.sh
RUN mkdir /var/run/sshd

RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' 

RUN chmod 755 /start.sh

EXPOSE 22
EXPOSE 3000
EXPOSE 80
EXPOSE 81

RUN mkdir /projects
VOLUME /projects

RUN ./start.sh

USER user

#install rvm, ruby and rails
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
RUN /bin/bash -l -c "curl -L get.rvm.io | bash -s stable"
RUN /bin/bash -l -c "source ~/.rvm/scripts/rvm"
RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install 2.4"
RUN /bin/bash -l -c "echo 'gem: --no-ri --no-rdoc' > ~/.gemrc"
RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"
RUN /bin/bash -l -c "gem install rails -v 5.0.2"

USER root

ENTRYPOINT ["/usr/sbin/sshd", "-D"]
