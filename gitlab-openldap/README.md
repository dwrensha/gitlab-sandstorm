# Set up an OpenLDAP server for GitLab development

This is an attempt to set up an OpenLDAP server for GitLab development.

## Getting it running

On OS X, first run `brew install openldap`.

There are issues with the syntax in `bootstrap.ldif` and slapadd 2.4.28, see
https://gitlab.com/gitlab-org/gitlab-development-kit/issues/17 .

```bash
make # bootstrap LDAP server to run out of slapd.d
./run-slapd # stays attached in the current terminal
```

## Repopulate the database
```
make clean default
```

## Configuring gitlab

in gitlab.yml do the following;

```yaml
ldap:
  enabled: true
  servers:
    main:
      label: LDAP
      host: 127.0.0.1
      port: 3890
      uid: 'uid'
      method: 'plain' # "tls" or "ssl" or "plain"
      base: 'dc=example,dc=com'
      user_filter: ''
      group_base: 'ou=groups,dc=example,dc=com'
      admin_group: ''
```

alternative database (just using a different base)

```yaml
ldap:
  enabled: true
  servers:
    alt:
      label: LDAP-alt
      host: 127.0.0.1
      port: 3891
      uid: 'uid'
      method: 'plain' # "tls" or "ssl" or "plain"
      base: 'dc=example-alt,dc=com'
      user_filter: ''
      group_base: 'ou=groups,dc=example-alt,dc=com'
      admin_group: ''
```

*Note:* We don't use a bind user for this setup, keeping it as simple as possible

# TODO

- integrate into the development kit
- figure out how to detect the location of `slapd`; on OS X there is `/usr/libexec/slapd`.
