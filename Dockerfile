FROM centos:centos6
MAINTAINER Seiji Toyama <seijit@me.com>

ENV LANG en_US.UTF-8
ENV LC_ALL C

RUN rpm -Uvh http://ftp-srv2.kddilabs.jp/Linux/distributions/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm \
  && yum -y upgrade 

RUN yum -y groupinstall "Development Tools"
RUN yum -y install --enablerepo=centosplus\
   libxml2-devel zlib-devel openssl-devel libxslt libxslt-devel libffi-devel\
   readline-devel gdbm-devel bzip2-devel ncurses-devel sqlite-devel tk-devel wget ntp\
   yum -y clean all

RUN wget http://python.org/ftp/python/2.7.5/Python-2.7.5.tar.bz2 && tar xf Python-2.7.5.tar.bz2 \
  && cd Python-2.7.5 && ./configure --prefix=/usr/local && make && make altinstall
RUN wget http://pypi.python.org/packages/source/d/distribute/distribute-0.6.43.tar.gz && tar xf distribute-0.6.43.tar.gz\
  && cd distribute-0.6.43 && /usr/local/bin/python2.7 setup.py install && /usr/local/bin/easy_install-2.7 virtualenv && /usr/local/bin/virtualenv-2.7 --distribute mitmproxy\
  && source mitmproxy/bin/activate
RUN ln -s /usr/local/bin/python2.7 /usr/local/bin/python
RUN cd && wget https://bootstrap.pypa.io/get-pip.py && python get-pip.py
RUN pip install mitmproxy

EXPOSE 8080

CMD ["/usr/local/bin/mitmproxy"]
