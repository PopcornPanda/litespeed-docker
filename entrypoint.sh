#!/bin/bash
LSDIR='/usr/local/lsws'

if [ -z "$(ls -A -- "${LSDIR}/conf/")" ]; then
	cp -R ${LSDIR}/.conf/* ${LSDIR}/conf/
fi
if [ -z "$(ls -A -- "${LSDIR}/admin/conf/")" ]; then
	cp -R ${LSDIR}/admin/.conf/* ${LSDIR}/admin/conf/
fi
if [ ! -e ${LSDIR}/conf/serial.no ] && [ ! -e ${LSDIR}/conf/license.key ]; then
    rm -f ${LSDIR}/conf/trial.key*
    wget -P ${LSDIR}/conf/ http://license.litespeedtech.com/reseller/trial.key
fi

chown lsadm:lsadm ${LSDIR}/conf/ -R
chown lsadm:lsadm ${LSDIR}/admin/conf/ -R

sed -i "s/LS_DOMAIN/${LS_DOMAIN}/;s/LS_ALIASES/${LS_ALIASES}/" ${LSDIR}/conf/httpd_config.xml
sed -i "s/lsphpver/${PHP_VERSION}/" ${LSDIR}/conf/templates/docker.xml
mkdir -p /var/www/vhosts/${LS_DOMAIN}/{html,logs,certs}
useradd app-runner -u ${LS_UID} -g ${LS_GID} -m -s /usr/sbin/nologin
chown ${LS_UID}:${LS_GID} /var/www/vhosts/${LS_DOMAIN}/ -R

/usr/local/lsws/bin/lswsctrl start
$@
while true; do
	if ! ${LSDIR}/bin/lswsctrl status | grep 'litespeed is running with PID *' > /dev/null; then
		break
	fi
	sleep 60
done