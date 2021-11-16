# synology-udm-lepush
Automate update of LetsEncrypt certs on UDM or UDM Pro from Synology DSM.

## Initial setup on your Synology NAS
1. log in via SSH on your NAS with your admin user 
2. create/exchange SSH-key for root with your UDM/UDM Pro device
3. clone git repo or create a folder to put the scripts when downloading as a tarball
4. edit __`unifi-host.conf`__ with the FQDN for your UDM/UDM Pro device. Must be the same as in your certificate.
5. add a scheduled task to run daily on a time you see fit
6. forget about manually updating your cert on your UDM/UDM Pro

> **_NOTE:_** Be aware that this task will reboot the unifi-os container on your UDM when certificates are deemed out of sync.

# Contrib
Based on jboxberger's gitlab [import-syno-cert](https://github.com/jboxberger/synology-gitlab-jboxberger/blob/master/src/scripts/import-syno-cert) script.
