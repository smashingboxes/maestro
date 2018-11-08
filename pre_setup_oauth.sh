#!/usr/bin/env bash

USER_CONFIG_DEFAULTS="CLIENT_ID=\"\"\nCLIENT_SECRET=\"\"\nUSER=\"\"\nPLAYLIST=\"\"";
USER_CONFIG_FILE="${HOME}/.shpotify.cfg";
if ! [[ -f "${USER_CONFIG_FILE}" ]]; then
    touch "${USER_CONFIG_FILE}";
    echo -e "${USER_CONFIG_DEFAULTS}" > "${USER_CONFIG_FILE}";
fi
source "${USER_CONFIG_FILE}";

if [ ! -f userinfo.py ]; then
    create_file=$(python3 create_file.py $USER $CLIENT_ID $CLIENT_SECRET $PLAYLIST);
    echo $create_file
else
    echo "Userinfo file exists already"
fi

user_cache_file=".cache-"$USER
if [ ! -f $user_cache_file ]; then
    get_token=$(python3 get_token.py)
    echo $get_token
else
    echo "You should already have a token"
fi