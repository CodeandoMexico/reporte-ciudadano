FROM phusion/passenger-ruby22
MAINTAINER "Mikesaurio & Miguel Angel Gordian"

ENV HOME /root

CMD ["/sbin/my_init"]
RUN bash -lc 'rvm install ruby-2.2.5'
RUN bash -lc 'rvm --default use ruby-2.2.5'


USER app
RUN bash -lc 'rvm --default use ruby-2.2.5'
WORKDIR /home/app/urbem
ADD . /home/app/urbem
ADD docker/urbem.conf /etc/nginx/sites-enabled/
ADD docker/00_app_env.conf /etc/nginx/conf.d/
ADD docker/urbem-env.conf /etc/nginx/main.d/
ADD docker/database.yml /home/app/urbem/config/database.yml
RUN gem install bundler
RUN bundle install

USER root
RUN rm -f /etc/service/nginx/down
RUN rm /etc/nginx/sites-enabled/default
RUN chown -R app:app /home/app/urbem
RUN ln -sf /proc/self/fd /dev/

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
