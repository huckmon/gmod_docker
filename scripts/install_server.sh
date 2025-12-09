#!/usr/bin/env bash

install_dir="/data/"
mod_dir="${install_dir}steamapps/workshop/content/$app_id"

install_cmd=" +force_install_dir ${install_dir} +login $STEAMUSER +app_update $app_id"

app_id="4020"
a=1
modfile="/data/modlist.txt"
mod_cmd="" # stores command for mods
mods_loaded="false"
mod_download_prefix="+workshop_download_item $app_id "


echo "|--- checking if $(pwd)/modfile.txt exists ---|"

if [ -f "modlist.txt" ]; then
    modfile_lines=`wc -l < $modfile`
    while [ $a -lt `expr $modfile_lines + 1` ]
    do
        current_line="$(sed -n ${a}p $modfile | grep -E -o '[0-9]+')"
        mod_param="$mod_cmd $mod_download_prefix$current_line"
        mod_cmd=$mod_param
        a=`expr $a + 1`
    done
    mods_loaded="true"
else
    echo "|--- No modlist found, installing normally ---|"
fi

if [ $mods_loaded == "true" ]; then
    echo "|--- Installing server and addons - steamcmd $install_cmd$mod_cmd ---|"
    su srcds_run "steamcmd $install_cmd$mod_cmd +quit"
else
    echo "|--- Installing server - steamcmd $install_cmd ---|"
    su srcds_run "steamcmd $install_cmd +quit"
fi

# run server
exec "/start_server.sh"
