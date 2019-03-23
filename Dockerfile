FROM alpine
LABEL "pl.scrlk"="Scroll-Lock"

ENV AUTHORIZED_KEYS ""

ADD ./entrypoint.sh /usr/local/bin/
COPY ./sshd_config /etc/ssh/sshd_config

RUN apk add --no-cache --update openssh

RUN addgroup docker \
  && adduser -D -G docker -h /home/docker -s /bin/false docker \
  && echo "docker:docker" | chpasswd

WORKDIR /home/docker
RUN mkdir .ssh \
 && chmod 700 .ssh \
 && touch .ssh/authorized_keys \
 && chmod 600 .ssh/authorized_keys \
 && chown -R docker:docker .

ENTRYPOINT [ "sh", "/usr/local/bin/entrypoint.sh" ]
CMD [ "/usr/sbin/sshd", "-D", "-e" ]
EXPOSE 22
