#!/bin/sh

/usr/bin/ssh-keygen -A

for f in /etc/ssh/*_key*
do
  mv -n $f /srv/
  rm $f
done

for f in /srv/*_key*
do
  cp $f /etc/ssh/
  chmod 600 /etc/ssh/$(basename $f)
done

echo ${AUTHORIZED_KEYS} > /home/docker/.ssh/authorized_keys

if [ ! -d "/var/run/sshd" ]; then
  mkdir -p /var/run/sshd
fi

exec "$@"
