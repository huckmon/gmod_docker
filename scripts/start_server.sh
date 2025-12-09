#!/usr/bin/env bash

install_dir="/data/"
mod_dir="${install_dir}steamapps/workshop/content/$app_id"


# steamcmd start command args
app_id="4020"
a=1
modfile="/data/modlist.txt"
mod_cmd="" # stores command for mods
mods_loaded="false"
mod_prefix="-mod=\"$mod_dir/"
mod_param=""
server_file="srcds_run"
start_cmd_prefix_small="${install_dir}$server_file -game $GAMEMODE +maxplayers $MAXPLAYERS +map $MAP"

cd /data

#check if a user to run the server has been listed
if ["$AUTHKEY" -ne "" ]; then
    start_cmd_prefix="$start_cmd_prefix_small +sv_setsteamaccount $AUTHKEY"
else
    start_cmd_prefix="$start_cmd_prefix_small"
fi

if ["$WORKSHOP_PLAYLIST_ID" -ne "" ]; then
    start_cmd_prefix=$start_cmd_prefix + "+host_workshop_collection $WORKSHOP_PLAYLIST_ID"
fi

start_cmd_suffix="-noSound -netlog"

echo "|--- checking if $(pwd)/modlist.txt exists ---|"
if [ -f "modlist.txt" ]; then
    modfile_lines=`wc -l < $modfile`
    while [ $a -lt `expr $modfile_lines + 1` ]
    do
        current_line="$(sed -n ${a}p $modfile | grep -E -o '[0-9]+')"
        mod_param="$mod_cmd $mod_prefix$current_line\""
        mod_cmd=$mod_param
        a=`expr $a + 1`
    done
    mods_loaded="true"
    mod_cmd="${mod_cmd} "
else
    echo "|--- No modlist found, starting normally ---|"
fi

# This needs editing to remove arma
if [ $mods_loaded == "true" ]; then
    echo "|--- Starting Gmod server with addons - $start_cmd_prefix$mod_cmd$start_cmd_suffix"
    exec su srcds_run "$start_cmd_prefix$mod_cmd$start_cmd_suffix"
else
    echo "|--- Starting Gmod server - $start_cmd_prefix$start_cmd_suffix"
    exec su srcds_run "$start_cmd_prefix$start_cmd_suffix"
fi
