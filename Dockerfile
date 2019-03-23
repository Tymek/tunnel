FROM alpine
LABEL "pl.scrlk"="Scroll-Lock"

ENV AUTHORIZED_KEYS ""

RUN apk add --no-cache --update \
  openrc \
  openssh
RUN rc-update add sshd default
RUN sed -i 's/^#GatewayPorts no/GatewayPorts yes/' /etc/ssh/sshd_config
COPY ./sshd_config /etc/ssh/sshd_config

RUN addgroup docker \
  && adduser -D -G docker -h /home/docker -s /bin/false docker

WORKDIR /home/docker
RUN mkdir .ssh \
 && chmod 700 .ssh \
 && touch .ssh/authorized_keys \
 && chmod 600 .ssh/authorized_keys \
 && chown -R docker:docker .

COPY ./server.sh /usr/local/bin/

VOLUME [ "/srv" ]

ENTRYPOINT ["server.sh"]
CMD ["/usr/sbin/sshd","-D"]

EXPOSE 22

# Match User tunusr
#   PermitOpen 127.0.0.1:12345 (?)
#   AllowTcpForwarding yes
#   X11Forwarding no
#   AllowAgentForwarding no
#   ForceCommand /bin/false
