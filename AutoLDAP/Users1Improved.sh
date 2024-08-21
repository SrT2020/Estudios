#!/bin/bash

if [ $# -ne 3 ]; then
    echo "Usage: $0 username password gid"
    exit 1
fi

USERNAME=$1
PASSWORD=$2
GID=$3

case $GID in
    1001) HOME_DIR="/home/professors/$USERNAME" ;;
    1002) HOME_DIR="/home/alumnes/$USERNAME" ;;
    *) echo "Invalid GID. Please use 1001 for professors or 1002 for students." ; exit 1 ;;
esac

UID=$(ldapsearch -x -b "ou=users,dc=tomasruiz,dc=jmir" -H ldap://10.110.34.10 | \
      awk -F": " '/uidNumber:/{print $2}' | sort -n | tail -1)
NEXT_UID=$((UID + 1))

LDIF_FILE="${USERNAME}.ldif"
cat > $LDIF_FILE <<EOL
dn: cn=$USERNAME,ou=users,dc=tomasruiz,dc=jmir
cn: $USERNAME
sn: $USERNAME
objectClass: person
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: top
uid: $USERNAME
uidNumber: $NEXT_UID
gidNumber: $GID
homeDirectory: $HOME_DIR
loginShell: /bin/bash
EOL

ldapadd -H ldap://10.110.34.10 -x -D "cn=admin,dc=tomasruiz,dc=jmir" -w alumne -f $LDIF_FILE
ldappasswd -H ldap://10.110.34.10 -s $PASSWORD -x -D "cn=admin,dc=tomasruiz,dc=jmir" -W "cn=$USERNAME,ou=users,dc=tomasruiz,dc=jmir"

# Clean up the LDIF file
# rm -f $LDIF_FILE
