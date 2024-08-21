#!/bin/bash

if [ $# -ne 3 ]; then
    echo "Usage: $0 username password group_name"
    exit 1
fi

USERNAME=$1
PASSWORD=$2
GROUP_NAME=$3

GID=$(ldapsearch -x -b "ou=groups,dc=tomasruiz,dc=jmir" -H ldap://10.110.34.10 "cn=$GROUP_NAME" | \
      awk -F": " '/gidNumber:/{print $2}')

if [ -z "$GID" ]; then
    echo "Error: Group '$GROUP_NAME' not found in LDAP."
    exit 1
fi

UID=$(ldapsearch -x -b "ou=users,dc=tomasruiz,dc=jmir" -H ldap://10.110.34.10 | \
      awk -F": " '/uidNumber:/{print $2}' | sort -n | tail -1)
NEXT_UID=$((UID + 1))

case $GID in
    1001) HOME_DIR="/home/professors/$USERNAME" ;;
    1002) HOME_DIR="/home/alumnes/$USERNAME" ;;
    *) echo "Error: Unsupported GID '$GID'. Only 1001 (professors) and 1002 (students) are allowed." ; exit 1 ;;
esac

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


# rm -f $LDIF_FILE
