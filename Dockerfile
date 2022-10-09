FROM centos:centos7
ENV LS_DOMAIN='localhost' \
	LS_ALIASES='*' \
	TZ="Europe/Warsaw"

ARG LSWS_VERSION='6.0.12'
ARG PHP_VERSION='lsphp74'	
ARG LSDIR='/usr/local/lsws'

COPY ./ /app
RUN yum install http://rpms.litespeedtech.com/centos/litespeed-repo-1.3-1.el7.noarch.rpm \
	https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm \
	epel-release -q -y \
	&& yum install --disablerepo=pgdg15 curl openssl lsws mysql postgresql13 wget procps which initscripts -yq
RUN yum install --disablerepo=pgdg15 $PHP_VERSION $PHP_VERSION-common $PHP_VERSION-mysqlnd $PHP_VERSION-opcache $PHP_VERSION-soap $PHP_VERSION-sodium \
    	$PHP_VERSION-curl $PHP_VERSION-imagick $PHP_VERSION-redis $PHP_VERSION-memcached $PHP_VERSION-intl \
	$PHP_VERSION-json $PHP_VERSION-xml $PHP_VERSION-gd $PHP_VERSION-pgsql $PHP_VERSION-pdo  $PHP_VERSION-bcmath \
	$PHP_VERSION-zip $PHP_VERSION-imap $PHP_VERSION-ioncube -y --skip-broken \
	&& echo 'admin:$1$g4eM/m2X$ZZvEWHUtNfBKghPQr/05l0' > ${LSDIR}/admin/conf/htpasswd \
	&& curl -o ${LSDIR}/conf/trial.key http://license.litespeedtech.com/reseller/trial.key \
	&& chmod +x /usr/local/lsws/admin/misc/ -R \
	&& /usr/local/lsws/admin/misc/create_admin_keypair.sh \
	&& /usr/local/lsws/admin/misc/lsup.sh -f -v ${LSWS_VERSION} \
	&& ln -sf ${LSDIR}/$PHP_VERSION/bin/lsphp $LSDIR/fcgi-bin/lsphp \
	&& ln -fs /app/docker.xml ${LSDIR}/conf/templates/docker.xml \
	&& ln -fs /app/httpd_config.xml ${LSDIR}/conf/httpd_config.xml \
	&& rm -fr /var/cache/yum 

EXPOSE 7080
ENTRYPOINT [ "bash", "/app/entrypoint.sh"]
