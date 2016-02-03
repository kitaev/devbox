#!/bin/sh

URL=$1
TARGET=$2
BRANCH=$3

if [ -e "${TARGET}" ]; then
    echo "$TARGET" already exists
    exit 0;
fi

# add host to known hosts
PROTOCOL="$(echo "$URL" | sed -e 's/\([^:/]*\):\/\/\([^@]*@\)\?\([^:/]*\).*/\1/')"
HOST="$(echo "$URL" | sed -e 's/\([^:/]*\):\/\/\([^@]*@\)\?\([^:/]*\).*/\3/')"

if [ "$PROTOCOL" = "ssh" ]; then
    echo "Adding $HOST to the list of known hosts"
    [ -e ~/.ssh/known_hosts ] || touch ~/.ssh/known_hosts
    ssh-keyscan -t rsa,dsa "$HOST" 2>&1 | sort -u - ~/.ssh/known_hosts > ~/.ssh/tmp_hosts
    mv ~/.ssh/tmp_hosts ~/.ssh/known_hosts
fi

/bin/sh -c "git clone $URL $TARGET"
if [ -n "${BRANCH}" ]; then
    /bin/sh -c "git -C $TARGET checkout $BRANCH"
fi
