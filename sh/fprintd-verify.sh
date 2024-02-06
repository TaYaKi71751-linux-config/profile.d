#!/bin/bash

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
			loginctl unlock-sessions
			exit
		fi
	fi
}
while [ true ];do
	fprint_verify
done &
