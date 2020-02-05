FROM menloperk/java8:latest

CMD ["/sbin/my_init"]

RUN mkdir -p /etc/my_init.d; mkdir -p /home/boomi

#allow for symbolic linking
RUN chmod o+w /usr/local/bin
COPY start.sh /etc/my_init.d
COPY atom /home/boomi
COPY startatom.sh /home/boomi
COPY attachatom.sh /home/boomi
COPY detachatom.sh /home/boomi
COPY deleteatom.sh /home/boomi

EXPOSE 9090

RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Define working directory
WORKDIR /home/boomi
