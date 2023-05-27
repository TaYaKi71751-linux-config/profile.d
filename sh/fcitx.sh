#!/bin/bash

FCITX_ARR=( "fcitx" "fcitx5" )
IM=""

for FCITX in ${FCITX_ARR[@]};do
	FCITX_PATH=`which ${FCITX}`
	if [ -n "${FCITX_PATH}" ];then
		IM="${FCITX}"
		break
	else
		continue
	fi
done

if [ -n "${IM}" ];then
	echo "Using ${IM} as Input Method"
	export GTK_IM_MODULE=${IM}
	export QT_IM_MODULE=${IM}
	export XMODIFIERS=@im=${IM}
	IM_PROCESS=`ps -A | grep ${IM}`
	if [ -n "${IM_PROCESS}" ];then
		echo "${IM} is already running"
	else
		echo "Running ${IM} with nohup"
		nohup ${IM} >/dev/null 2>&1 &
	fi
else
	echo "fcitx or fcitx5 is not exists"
fi
