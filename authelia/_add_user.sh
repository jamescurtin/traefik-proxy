#!/usr/bin/env bash

ldapadd -x -c -D "cn=admin,dc=example,dc=org" -w $(cat /run/secrets/ldap-admin) -f /tmp/ldapadd.ldif -H ldap://authelia-openldap
