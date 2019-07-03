#ldap+sssd+sudo客户端配置脚本
apt-get install -y sssd libpam-sss libnss-sss nscd

tee /etc/sssd/sssd.conf <<EOF > /dev/null
[nss]
filter_groups = root
filter_users = root
reconnection_retries = 3

[pam]
reconnection_retries = 3

[sssd]
config_file_version = 2
reconnection_retries = 3
sbus_timeout = 30
services = nss, pam, sudo
domains = example.com

[domain/example.com]
#With this as false, a simple "getent passwd" for testing won't work. You must do getent passwd user@domain.com
enumerate = false
cache_credentials = true

autofs_provider = ldap
ldap_schema = rfc2307 

id_provider = ldap
auth_provider = ldap
chpass_provider = ldap

ldap_uri = ldap://
ldap_search_base = dc=example,dc=com

access_provider = ldap
ldap_access_filter = memberOf=cn=DB,ou=department,dc=example,dc=com

sudo_provider = ldap
ldap_sudo_search_base = ou=proxy,ou=SUDOers,dc=example,dc=com

ldap_id_use_start_tls = true
ldap_tls_cacertdir = /etc/ssl/certs
ldap_tls_cacert = /etc/ssl/certs/ca_server.pem

#This parameter requires that the DC present a completely validated certificate chain. If you're testing or don't care, use 'allow' or 'never'.
ldap_tls_reqcert = demand

ldap_user_search_base = ou=web,ou=users,dc=example,dc=com
ldap_group_search_base = ou=groups,dc=example,dc=com
EOF


chown root:root /etc/sssd/sssd.conf
chmod 600 /etc/sssd/sssd.conf
service sssd restart
service nscd restart
systemctl restart systemd-logind
echo 'session optional        pam_mkhomedir.so skel=/etc/skel umask=077' >> /etc/pam.d/common-session
