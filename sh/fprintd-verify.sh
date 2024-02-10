#!/bin/bash

export SUDO_ERROR=""
export FPRINTD_ERROR=""

function check_sudo(){
	if ( `sudo -nv` );then
		echo 'use sudo'
		export SUDO_ERROR=""
	else
		export SUDO_ERROR="true"
	fi
}

function check_fprintd(){
	FPRINTD_WHICH=$(find / -name 'fprintd-verify' -type f -exec echo {} \;)
	echo "${FPRINTD_WHICH}"
	if [ -n "${FPRINTD_WHICH}" ];then
		echo 'fprintd-verify found'
		export FPRINTD_ERROR=""
	else
		export FPRINTD_ERROR="true"
	fi
}

check_sudo
check_fprintd

function fprint_verify(){
	sudo pkill -9 fprintd-verify
	export FPRINT_VERIFY_STATUS=$(sudo fprintd-verify | grep '(done)' | tr -d '\n' | tr -d '\r')
	export FPRINT_VERIFY_ERROR=''
	echo "${FPRINT_VERIFY_STATUS}"
	if [ -z "${FPRINT_VERIFY_STATUS}" ];then
		exit
	else
		export FPRINT_VERIFY_NO_MATCH="$(printf "$FPRINT_VERIFY_STATUS" | grep 'verify-no-match' | tr -d '\n' | tr -d '\r' | tr -d ' ' | tr -d '\t')"
		export FPRINT_VERIFY_MATCH="$(printf "$FPRINT_VERIFY_STATUS" | grep 'verify-match' | tr -d '\n' | tr -d '\r' | tr -d ' ' | tr -d '\t')"
		echo $FPRINT_VERIFY_MATCH
		echo $FPRINT_VERIFY_NO_MATCH
		if [ -z "$(printf "$FPRINT_VERIFY_MATCH" | grep done)" ];then
			echo 'verify-no-match'
			fprint_verify
		fi
		if [ -z "$(printf "$FPRINT_VERIFY_NO_MATCH" | grep done)" ];then
			echo 'verify-match'
			sudo loginctl unlock-sessions
		fi
	fi
}
if [ -z "${SUDO_ERROR}" ];then
	if [ -z "${FPRINTD_ERROR}" ];then
		while ( true );do
			fprint_verify
		done &
	else
		echo fprint
	fi
else
	echo sudo
fi
