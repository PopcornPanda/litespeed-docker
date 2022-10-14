#!/bin/bash
LSDIR='/usr/local/lsws'

if [ ! -z "${LS_SERIAL}" ]; then
	echo ${LS_SERIAL} > ${LSDIR}/conf/serial.no
fi

if [ -z "$(ls -A -- "${LSDIR}/conf/")" ]; then
	cp -R ${LSDIR}/.conf/* ${LSDIR}/conf/
fi
if [ -z "$(ls -A -- "${LSDIR}/admin/conf/")" ]; then
	cp -R ${LSDIR}/admin/.conf/* ${LSDIR}/admin/conf/
fi
if [ ! -e ${LSDIR}/conf/serial.no ]; then
    rm -f ${LSDIR}/conf/trial.key*
    wget -P ${LSDIR}/conf/ http://license.litespeedtech.com/reseller/trial.key
else
	rm -f ${LSDIR}/conf/license.key*
	${LSDIR}/bin/lshttpd -r
fi

chown lsadm:lsadm ${LSDIR}/conf/ -R
chown lsadm:lsadm ${LSDIR}/admin/conf/ -R

if [ ! -z "${CAPTCHA_SITE}" ] && [ ! -z "${CAPTCHA_SECRET}" ]; then
	CAPTCHA_ENABLED=1
fi
sed -i "s/CAPTCHA_ENABLED/${CAPTCHA_ENABLED}/;s/CAPTCHA_SECRET/${CAPTCHA_SECRET}/;s/CAPTCHA_SITE/${CAPTCHA_SITE}/;s/CAPTCHA_LEVEL/${CAPTCHA_LEVEL}/;s/CAPTCHA_TRIES/${CAPTCHA_TRIES}/" ${LSDIR}/conf/templates/docker.xml

sed -i "s/LS_DOMAIN/${LS_DOMAIN}/;s/LS_ALIASES/${LS_ALIASES}/" ${LSDIR}/conf/httpd_config.xml
sed -i "s/lsphpver/${PHP_VERSION}/;s/LS_USER/${LS_USER}/" ${LSDIR}/conf/templates/docker.xml
sed -i 's=<enableCoreDump>1</enableCoreDump>=<enableCoreDump>0</enableCoreDump>=' /usr/local/lsws/admin/conf/admin_config.xml
mkdir -p /var/www/vhosts/${LS_DOMAIN}/{html,logs,certs}
groupadd -g ${LS_GID} ${LS_USERNAME}
useradd ${LS_USERNAME} -u ${LS_UID} -g ${LS_GID} -m -s /usr/sbin/nologin
chown ${LS_UID}:${LS_GID} /var/www/vhosts/${LS_DOMAIN}/ -R
echo "${ADMIN_USER}:$(/usr/local/lsws/admin/fcgi-bin/admin_php5 -q /usr/local/lsws/admin/misc/htpasswd.php ${ADMIN_PASS})" > /usr/local/lsws/admin/conf/htpasswd

/usr/local/lsws/bin/lswsctrl start
$@
while true; do
	if ! ${LSDIR}/bin/lswsctrl status | grep 'litespeed is running with PID *' > /dev/null; then
		break
	fi
	sleep 60
done
