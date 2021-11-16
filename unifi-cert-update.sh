#!/bin/sh
UNIFI_CERT_DIR="/data/unifi-core/config"
UNIFI_CERT="unifi-core.crt"
UNIFI_KEY="unifi-core.key"

echo "backing up installed certificate"
mv ${UNIFI_CERT_DIR}/${UNIFI_CERT} ${UNIFI_CERT_DIR}/${UNIFI_CERT}.1
mv ${UNIFI_CERT_DIR}/${UNIFI_KEY} ${UNIFI_CERT_DIR}/${UNIFI_KEY}.1

echo "installing new certificate"
cp ${UNIFI_CERT} ${UNIFI_CERT_DIR}/${UNIFI_CERT}
cp ${UNIFI_KEY} ${UNIFI_CERT_DIR}/${UNIFI_KEY}

echo "changing ownership of unifi certificate"
chmod 644 ${UNIFI_CERT_DIR}/${UNIFI_CERT}
chmod 644 ${UNIFI_CERT_DIR}/${UNIFI_KEY}

echo "restarting unifi container to activate new certificate"
unifi-os restart

echo "cleaning up..."
rm unifi-*