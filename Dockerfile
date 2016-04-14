FROM phusion/baseimage:0.9.18
CMD ["/sbin/my_init"]

RUN apt-get update && apt-get -y upgrade && apt-get clean

ENV homedir /home/ebotv3-web
RUN apt-get -y install curl git php5-cli php5-mysql libapache2-mod-php5 unzip && apt-get clean

RUN mkdir ${homedir} && curl -L https://github.com/deStrO/eBot-CSGO-Web/archive/master.zip >> ${homedir}/master.zip && unzip -d ${homedir} ${homedir}/master.zip && ln -s ${homedir}/eBot-CSGO-Web-master ${homedir}/ebot-csgo-web && cd ${homedir}/ebot-csgo-web && cp config/app_user.yml.default config/app_user.yml

RUN a2enmod rewrite

RUN sed -i 's/192.168.1.1/172.17.0.1/g' $homedir/ebot-csgo-web/config/app_user.yml

RUN sed -i 's@#RewriteBase /@RewriteBase /ebot-csgo@g' $homedir/ebot-csgo-web/web/.htaccess

COPY ebotv3.conf /etc/apache2/conf-enabled/ebotv3.conf

WORKDIR $homedir/ebot-csgo-web

# script to prepare ebot
RUN mkdir -p /etc/my_init.d
ADD prepare_ebot.sh /etc/my_init.d/prepare_ebot.sh

# create rundir
RUN mkdir /etc/service/apache
ADD run_apache.sh /etc/service/apache/run
RUN chmod +x /etc/service/apache/run

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
