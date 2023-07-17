#!/bin/bash

FCITX=("fcitx" "fcitx5")
for _fcitx_bin in "${FCITX[@]}";do
        FCITX_BIN=`which ${_fcitx_bin}`
        if [ "${FCITX_BIN}" != "" ];then
                export GTK_IM_MODULE=${_fcitx_bin}
                export QT_IM_MODULE=${_fcitx_bin}
                export XMODIFIERS=@im=${_fcitx_bin}
                FCITX_PROCESS=`ps -A | grep ${_fcitx_bin}`
                if [ -n "${FCITX_PROCESS}" ];then
                        echo "${IM} is already running"
                else
                        echo "Running ${IM} with nohup"
                        nohup ${IM} >/dev/null 2>&1 &
                fi
                break
        fi
done
