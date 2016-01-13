FROM ubuntu:14.04
MAINTAINER Daniel Guerra
RUN dpkg --add-architecture i386
RUN apt-get -yy update \
&& apt-get -y install --no-install-recommends wget libx11-6 libx11-xcb1 libfontconfig1 supervisor xvfb x11vnc software-properties-common openbox xterm\
&& add-apt-repository ppa:wine/wine-builds \
&& apt-get -yy update \
&& apt-get -y install winehq-devel \
&& cd /bin \
&& wget http://www.slsknet.org/SoulseekQT/Windows/SoulseekQt-2015-6-12.exe \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN addgroup soulseek
RUN useradd -m -g soulseek soulseek
EXPOSE 5900
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD menu.xml /etc/xdg/openbox/menu.xml
ADD install /usr/bin/soulseek_install
ADD soulseek /usr/bin/soulseek
RUN chown soulseek:soulseek /usr/bin/soulseek*
ADD winetricks /home/soulseek/winetricks
RUN chown soulseek:soulseek /home/soulseek/winetricks
ENV WINEPREFIX /home/soulseek/.wine
ENV WINEARCH win32
ENV DISPLAY :1
#USER soulseek
#RUN /home/soulseek/winetricks --unattended soulseek
#USER root
ADD start /bin/start
CMD ["/bin/start"]
