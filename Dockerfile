FROM ubuntu:16.04
MAINTAINER Gemma Hoad <ghoad@sfu.ca>

# Install packages then remove cache package list information
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get -yq install openssh-client \
    apache2 \
    curl \
    wget \
    build-essential \
    net-tools \
    librpc-xml-perl \
    bioperl \
    ncbi-blast+-legacy \
    nano \
    libf2c2 \
    apache2-dev \
    libapache-singleton-perl \
    libjson-rpc-perl \
    cron \
    cpanminus

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get -y install supervisor && apt-get clean && rm -rf /var/lib/apt/lists/*

ADD conf/supervisord.conf /etc/supervisor/conf.d/

# Add extra perl module where no Ubuntu package exists
RUN cpan Bio::DB::Taxonomy

# Manually set the apache environment variables in order to get apache to work immediately.
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

WORKDIR /usr/local/src

# create folder to store output
RUN mkdir -p /tmp/psortm 

WORKDIR /usr/local/src

RUN echo '/usr/local/lib64' >>/etc/ld.so.conf

RUN wget http://www.psort.org/download/docker/pft2.3.4.docker64bit.tar.gz && tar zxvf pft2.3.4.docker64bit.tar.gz && cp pftools/pfscan /usr/local/bin/

RUN wget http://www.psort.org/download/libpsortb-1.0.tar.gz && tar zxvf libpsortb-1.0.tar.gz && cd libpsortb-1.0 && ./configure && make && make install && ldconfig

RUN wget http://www.psort.org/download/bio-tools-psort-all.3.0.4.tar.gz && tar zxvf bio-tools-psort-all.3.0.4.tar.gz

WORKDIR /usr/local/src/bio-tools-psort-all

RUN wget http://www.psort.org/download/docker/psortb.defaults

RUN perl Makefile.PL && make && make install && cp -r psort /usr/local/psortb

RUN a2enmod cgid && wget http://www.psort.org/download/docker/apache.conf.fragment && cat apache.conf.fragment >> /etc/apache2/apache2.conf

WORKDIR /usr/local/src

RUN wget http://www.psort.org/download/docker/apache-svm.tar.gz && tar zxvf apache-svm.tar.gz && cd apache-svm && make && cp svmloc.conf /etc/apache2/conf-available/

RUN wget http://www.psort.org/download/docker/apache-psort.conf && cp apache-psort.conf /etc/apache2/conf-available/

RUN wget http://www.psort.org/download/docker/apache-psortm.tar.gz && tar zxvf apache-psortm.tar.gz && cp apache-psortm/startup.pl startup.pl 

RUN cd apache-psortm && crontab delete_old_files.cron && perl Makefile.PL && make && make install

RUN cd /etc/apache2/conf-enabled/ && ln -s ../conf-available/svmloc.conf && ln -s ../conf-available/apache-psort.conf

RUN wget http://www.psort.org/download/docker/Request.pm && cp Request.pm /usr/share/perl5/Apache/Singleton/Request.pm

RUN wget http://www.psort.org/download/docker/CGI-FastTemplate-1.09.tar.gz && tar zxvf CGI-FastTemplate-1.09.tar.gz && cd CGI-FastTemplate-1.09 && perl Makefile.PL && make && make install

RUN cd /var/www/html && wget http://www.psort.org/download/docker/psortm-web.tar.gz && tar zxvf psortm-web.tar.gz && cp -r psortm-web/* ./ && wget http://www.psort.org/download/docker/taxon_predictor.tar.gz && tar xvf taxon_predictor.tar.gz

# Clean up a little
RUN rm -r pft2.3.4.docker64bit.tar.gz libpsortb-1.0.tar.gz libpsortb-1.0 bio-tools-psort-all.3.0.4.tar.gz bio-tools-psort-all apache-psortm.tar.gz apache-svm.tar.gz CGI-FastTemplate-1.09.tar.gz /var/www/html/psortm-web.tar.gz /var/www/html/taxon_predictor.tar.gz

# set the timezone - it is printed to a log for large sequence submissions
RUN rm /etc/localtime && ln -s /usr/share/zoneinfo/Canada/Pacific /etc/localtime

WORKDIR /usr/local/src/apache-psortm

# Configure the web server so it doesn't timeout upon restart
RUN chmod +x start_apache.sh && mv /etc/init.d/apache2 /etc/init.d/apache2.orig && sed -e "s/20/60/g" < /etc/init.d/apache2.orig > /etc/init.d/apache2

# Expose the web service to the world
EXPOSE 80

ADD conf/run.sh /opt/
RUN chmod +x /opt/run.sh
CMD ["/opt/run.sh"]

