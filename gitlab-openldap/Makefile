default: slapd.d/bootstrap contents alt_contents

contents: slapd.d/schema slapd.d/example-com
alt_contents: slapd.d/schema slapd.d/alt-example-com

slapd.d:
	mkdir slapd.d
	chmod 700 slapd.d

slapd.d/bootstrap: slapd.d
	slapadd -n 0 -F slapd.d < bootstrap.ldif
	touch $@

slapd.d/schema:
	curl 'http://www.openldap.org/devel/gitweb.cgi?p=openldap.git;a=blob_plain;f=servers/slapd/schema/core.ldif;hb=HEAD' | slapadd -b 'cn=config' -F slapd.d
	curl 'http://www.openldap.org/devel/gitweb.cgi?p=openldap.git;a=blob_plain;f=servers/slapd/schema/cosine.ldif;hb=HEAD' | slapadd -b 'cn=config' -F slapd.d
	curl 'http://www.openldap.org/devel/gitweb.cgi?p=openldap.git;a=blob_plain;f=servers/slapd/schema/inetorgperson.ldif;hb=HEAD' | slapadd -b 'cn=config' -F slapd.d
	curl 'http://www.openldap.org/devel/gitweb.cgi?p=openldap.git;a=blob_plain;f=servers/slapd/schema/nis.ldif;hb=HEAD' | slapadd -b 'cn=config' -F slapd.d
	touch $@

slapd.d/example-com:
	slapadd -b 'dc=example,dc=com' -F slapd.d < frontend.example.com.ldif
	touch $@

slapd.d/alt-example-com:
	slapadd -b 'dc=example-alt,dc=com' -F slapd.d < frontend.alt.example.com.ldif
	touch $@

clean:
	rm -rf slapd.d
