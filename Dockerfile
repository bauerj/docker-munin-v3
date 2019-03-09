FROM phusion/baseimage:0.11
MAINTAINER Johann Bauer "https://bauerj.eu"

# Install dependencies
RUN apt-get update && apt-get install -y wget tar libssl-dev gzip make perl rrdtool gcc librrds-perl libexpat1-dev libhttp-server-simple-cgi-prefork-perl libio-string-perl libxml-dumper-perl unzip && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Perl dependencies
RUN yes | cpan Module::Build
# Install munin
RUN cd /tmp && wget https://github.com/munin-monitoring/munin/archive/2.999.11.zip && unzip 2.999.11.zip && cd /tmp/munin-2.999.11 && perl Build.PL && ./Build installdeps && ./Build && ./Build install && cd && rm /tmp/munin-2.999.11 -r

RUN useradd munin

# Initialize directories and sample config
RUN (mkdir -p /var/run/munin && chown -R munin:munin /var/run/munin); mkdir -p /var/lib/munin/; chown munin /var/lib/munin/ -R

# Munin config
ADD munin.conf /usr/local/etc/munin/munin.conf

# HTTP server
ADD run.sh /etc/service/munin/run

# munin-cron
ADD cron-entry /etc/cron.d/munin

# munin-cron will run on container start. Otherwise we would get an error message while trying to access the Web UI
ADD startup /etc/my_init.d/munin

VOLUME /var/lib/munin /var/log/munin /usr/local/etc/munin/munin-conf.d

CMD ["/sbin/my_init"]
