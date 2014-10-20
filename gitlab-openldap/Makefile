gitlab_openldap_root = $(shell pwd)

default: slapd.d/bootstrap contents alt_contents

contents: slapd.d/schema slapd.d/example-com
alt_contents: slapd.d/schema slapd.d/alt-example-com

slapd.d:
	mkdir slapd.d
	chmod 700 slapd.d

slapd.d/bootstrap: sbin/slapadd slapd.d
	sbin/slapadd -n 0 -F slapd.d < bootstrap.ldif
	touch $@

slapd.d/schema: sbin/slapadd
	sbin/slapadd -b 'cn=config' -F slapd.d < etc/openldap/schema/core.ldif
	sbin/slapadd -b 'cn=config' -F slapd.d < etc/openldap/schema/cosine.ldif
	sbin/slapadd -b 'cn=config' -F slapd.d < etc/openldap/schema/inetorgperson.ldif
	sbin/slapadd -b 'cn=config' -F slapd.d < etc/openldap/schema/nis.ldif
	touch $@

slapd.d/example-com: sbin/slapadd
	sbin/slapadd -b 'dc=example,dc=com' -F slapd.d < frontend.example.com.ldif
	touch $@

slapd.d/alt-example-com: sbin/slapadd
	sbin/slapadd -b 'dc=example-alt,dc=com' -F slapd.d < frontend.alt.example.com.ldif
	touch $@

clean:
	rm -rf slapd.d

openldap-2.4.40:
	curl -O ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/openldap-2.4.40.tgz
	tar zxf openldap-2.4.40.tgz

sbin/slapadd: openldap-2.4.40
	cd openldap-2.4.40 && ./configure --prefix=${gitlab_openldap_root} --enable-bdb=no --enable-hdb=no
	cd openldap-2.4.40 && make -j 2 install
