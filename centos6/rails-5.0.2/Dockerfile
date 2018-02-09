FROM centos:6.7
LABEL maintainer="Jorge Luis"

##########################################################################
### update glibc-common for locale files
RUN yum update -y glibc-common

##########################################################################
# all yum installations here
RUN yum install -y sudo passwd openssh-server openssh-clients tar && \
    yum install -y screen crontabs strace telnet perl libpcap bc patch ntp dnsmasq unzip pax nano && \
    yum install -y automake autoconf gcc gcc-c++ make openssl-devel bison git && \
    yum install -y libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel && \
    yum install -y curl which gzip bzip2 zip which && \
    yum install -y mariadb-devel postgresql-libs postgresql-devel && \
    yum install -y yum-utils libtool sqlite sqlite-devel && \
    yum install -y kernel-headers --disableexcludes=all && \
    yum install -y nginx && \
    curl --silent --location https://rpm.nodesource.com/setup_8.x | bash - &&\
    yum install -y nodejs && \
    curl -o /etc/yum.repos.d/yarn.repo https://dl.yarnpkg.com/rpm/yarn.repo && \
    yum install -y yarn && \
    yum clean all

##########################################################################
# add epel repository
RUN rpm -Uvh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

# install imagemagik to paperclip
RUN yum install -y ImageMagick ImageMagick-devel

RUN (rpm -Uvh https://yum.puppetlabs.com/el/6/products/i386/puppetlabs-release-6-7.noarch.rpm; \
     yum install -y puppet puppet-server puppetserver facter hiera lsyncd sshpass)

# start sshd to generate host keys, patch sshd_config and enable yum repos
RUN (service sshd start; \
     sed -i 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config; \
     sed -i 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config; \
     sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config; \
     sed -i 's/enabled=0/enabled=1/' /etc/yum.repos.d/CentOS-Base.repo)

RUN (mkdir -p /root/.ssh/; \
     echo "StrictHostKeyChecking=no" > /root/.ssh/config; \
     echo "UserKnownHostsFile=/dev/null" >> /root/.ssh/config)

##########################################################################
# passwords 
RUN echo "root:password" | chpasswd

#########################################################################
# create user and add sudoers
ADD ./start.sh /start.sh
RUN chmod 755 /start.sh
RUN ./start.sh

########################################################################
USER www-data

#install rvm, ruby and rails
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
RUN /bin/bash -l -c "curl -L get.rvm.io | bash -s stable"
RUN /bin/bash -l -c "source ~/.rvm/scripts/rvm"
RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install 2.4"
RUN /bin/bash -l -c "echo 'gem: --no-ri --no-rdoc' > ~/.gemrc"
RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"
RUN /bin/bash -l -c "gem install rails -v 5.0.2"

#######################################################################

USER root

# config ngnix
#RUN service ngnix start

#########################################################################
# ports
EXPOSE 22
EXPOSE 3000
EXPOSE 80
EXPOSE 81

CMD service crond start; /usr/sbin/sshd -D
