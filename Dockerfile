FROM phusion/passenger-ruby22
MAINTAINER "Mikesaurio & Miguel Angel Gordian"

ENV HOME /root

CMD ["/sbin/my_init"]
RUN ruby-switch --set ruby2.2

USER app
WORKDIR /home/app/urbem

ADD . /home/app/urbem
ADD docker/urbem.conf /etc/nginx/sites-enabled/
ADD docker/00_app_env.conf /etc/nginx/conf.d/
ADD docker/urbem-env.conf /etc/nginx/main.d/
ADD docker/database.yml /home/app/urbem/config/database.yml

USER root
RUN bundle install
RUN rm -f /etc/service/nginx/down
RUN rm /etc/nginx/sites-enabled/default

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
