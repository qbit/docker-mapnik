# Mapnik for Docker

FROM ubuntu:latest
MAINTAINER Aaron Bieber <qbit@deftly.net>

ENV LANG C.UTF-8
RUN update-locale LANG=C.UTF-8

# Update and upgrade system
RUN apt-get -qq update && apt-get -qq --yes upgrade

# Essential stuffs
RUN apt-get -qq install --yes \
  apg \
  build-essential \
  openssh-server \
  sudo \
  software-properties-common \
  postgresql-9.4-postgis-2.1 \
  postgresql-9.4 \
  mapnik-utils \
  python-mapnik2 \
  libmapnik2.2 \
  libmapnik2-dev

# TileStache and dependencies
#RUN ln -s /usr/lib/x86_64-linux-gnu/libz.so /usr/lib
#RUN cd /tmp/ && curl --insecure -Os https://raw.githubusercontent.com/pypa/pip/master/contrib/get-pip.py && python get-pip.py
#RUN apt-get install python-pil
#RUN pip install -U modestmaps simplejson werkzeug tilestache --allow-external PIL --allow-unverified PIL
#RUN mkdir -p /etc/tilestache
#COPY etc/run_tilestache.py /etc/tilestache/


# Uwsgi
#RUN pip install uwsgi
#RUN mkdir -p /etc/uwsgi/apps-enabled
#RUN mkdir -p /etc/uwsgi/apps-available
#COPY etc/uwsgi_tilestache.ini /etc/uwsgi/apps-available/tilestache.ini
#RUN ln -s /etc/uwsgi/apps-available/tilestache.ini /etc/uwsgi/apps-enabled/tilestache.ini

# Supervisor
#RUN pip install supervisor
#RUN echo_supervisord_conf > /etc/supervisord.conf && printf "[include]\\nfiles = /etc/supervisord/*" >> /etc/supervisord.conf
#RUN mkdir -p /etc/supervisord
#COPY etc/supervisor_uwsgi.ini /etc/supervisord/uwsgi.ini
#COPY etc/supervisor_inet.conf /etc/supervisord/inet.conf
#COPY etc/init_supervisord /etc/init.d/supervisord
#RUN chmod +x /etc/init.d/supervisord

#COPY etc/nginx_site.conf /etc/nginx/sites-available/site.conf
#RUN ln -s /etc/nginx/sites-available/site.conf /etc/nginx/sites-enabled/
#RUN rm /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# SSH config
RUN mkdir /var/run/sshd
RUN mkdir -p /root/.ssh
RUN cp authorized_keys /root/.ssh/authorized_keys
RUN echo 'root:'`apg -q -n1` | chpasswd
# SSH login fix. Otherwise user is kicked off after login
# RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

EXPOSE 22 80

ENV HOST_IP `ifconfig | grep inet | grep Mask:255.255.255.0 | cut -d ' ' -f 12 | cut -d ':' -f 2`

ADD start.sh /
RUN chmod +x /start.sh

CMD ["/start.sh"]
