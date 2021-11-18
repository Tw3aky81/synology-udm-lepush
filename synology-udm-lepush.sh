#!/bin/sh

########################################################################################################################
# VARIABLES
########################################################################################################################
FORCE_RENEW=0
SYNO_CERT_DIR="/usr/syno/etc/certificate/_archive"
UNIFI_CERT="unifi-core.crt"
UNIFI_KEY="unifi-core.key"
BASE_DIR=$(dirname "$0")
. ${BASE_DIR}/unifi-host.conf

########################################################################################################################
# PARAMETER HANDLING
########################################################################################################################
for i in "$@"
do
    case $i in
        --force-renew)
            FORCE_RENEW=1
        ;;
        *)
            # unknown option
        ;;
    esac
    shift
done


########################################################################################################################
# PUSH SCRIPT
########################################################################################################################
for current_domain_cert in ${SYNO_CERT_DIR}/*; do
  if [ -d ${current_domain_cert} ] && [ -f ${current_domain_cert}/cert.pem ]; then
		openssl x509 -in ${current_domain_cert}/cert.pem -text | grep DNS:${UNIFI_HOSTNAME} > /dev/null 2>&1
		domain_found=$?
		if [ "${domain_found}" = "0" ]; then

			# time of last file change, seconds since Epoch
			last_change_cert_key=$(stat -c %Y ${current_domain_cert}/ECC-privkey.pem)

            if [ -f ${UNIFI_KEY} ]; then
            	last_change_unifi_cert_key=$(stat -c %Y ${UNIFI_KEY})
			else
				last_change_unifi_cert_key=0
			fi

			if [ ${last_change_unifi_cert_key} -le ${last_change_cert_key} ] || [ $FORCE_RENEW = 1 ]; then

				echo "unifi ssl certificate is outdated... updating from domain certificate"
				# copy certs locally to keep track what's on UDM
				cp ${current_domain_cert}/ECC-privkey.pem ${UNIFI_KEY}
				cp ${current_domain_cert}/ECC-fullchain.pem ${UNIFI_CERT}
				cp ${BASE_DIR}/unifi-cert-update.sh unifi-cert-update.sh
				# initiate remote commands
				scp unifi-* root@${UNIFI_HOSTNAME}:. >/dev/null 2>&1
				ssh root@${UNIFI_HOSTNAME} ./unifi-cert-update.sh

			else
				echo "nothing to do, unifi ssl certificate is same or newer than the domain ssl certificate"
			fi
            # Exit on first hit of $UNIFI_HOSTNAME
            exit 0
        fi
	fi
done

echo "no valid certificate found for given hostname"
exit 1