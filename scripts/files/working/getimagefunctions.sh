#!/bin/env bash
# Copyright 2017-2018 by SDRausty. All rights reserved.  🌎 🌍 🌏 🌐 🗺
# Hosted sdrausty.github.io/TermuxArch courtesy https://pages.github.com
# https://sdrausty.github.io/TermuxArch/README has info about this project. 
# https://sdrausty.github.io/TermuxArch/CONTRIBUTORS Thank you for your help.  
# _STANDARD_="function name" && STANDARD="variable name" are under construction.
################################################################################

_FTCHIT_() {
	_GETMSG_
 	_PRINT_DOWNLOADING_FTCHIT_ 
	if [[ "$dm" = aria2c ]];then
		aria2c -c -Z http://"$CMIRROR$path$file".md5 http://"$CMIRROR$path$file"
	elif [[ "$dm" = axel ]];then
		axel http://"$CMIRROR$path$file".md5 
		axel http://"$CMIRROR$path$file"
	elif [[ "$dm" = lftp ]] ; then
		lftpget -c http://"$CMIRROR$path$file".md5 http://"$CMIRROR$path$file"
	elif [[ "$dm" = wget ]];then 
		wget "$DMVERBOSE" -c --show-progress -N http://"$CMIRROR$path$file".md5 http://"$CMIRROR$path$file" 
	else
		curl "$DMVERBOSE" -C - --fail --retry 4 -OL http://"$CMIRROR$path$file".md5 -O http://"$CMIRROR$path$file" 
	fi
}

_FTCHSTND_() {
	FSTND=1
	_GETMSG_
	_PRINTCONTACTING_ 
	if [[ "$dm" = aria2c ]];then
		aria2c "$CMIRROR" | tee /dev/fd/1 > "$TAMPDIR/global2localmirror"
		_FMIRROR_
		aria2c -c -m 4 -Z http://"$NLCMIRROR$path$file".md5 http://"$NLCMIRROR$path$file"
	elif [[ "$dm" = axel ]];then
		axel "$CMIRROR" | tee /dev/fd/1 > "$TAMPDIR/global2localmirror"
		_FMIRROR_
		axel http://"$CMIRROR$path$file".md5 
		axel http://"$CMIRROR$path$file"
	elif [[ "$dm" = lftp ]] ; then
		lftpget "$CMIRROR" | tee /dev/fd/1 > "$TAMPDIR/global2localmirror"
		_FMIRROR_
		lftpget -c http://"$CMIRROR$path$file".md5 http://"$CMIRROR$path$file"
	elif [[ "$dm" = wget ]];then 
		wget -v -O/dev/null "$CMIRROR" 2>"$TAMPDIR/global2localmirror"
		_FMIRROR_
		wget "$DMVERBOSE" -N --show-progress "$NLCMIRROR$path$file".md5 
		wget "$DMVERBOSE" -c --show-progress "$NLCMIRROR$path$file" 
	else
		curl -v "$CMIRROR" 2>"$TAMPDIR/global2localmirror"
		_FMIRROR_
		curl "$DMVERBOSE" -C - --fail --retry 4 -OL "$NLCMIRROR$path$file".md5 -O "$NLCMIRROR$path$file"
	fi
}

_FMIRROR_() {
	NLCMIRROR="$(grep Location "$TAMPDIR/global2localmirror" | awk {'print $3'})" 
	_PRINTDONE_ 
	_PRINTDOWNLOADINGFTCH_ 
}

_GETIMAGE_() {
	_PRINTDOWNLOADINGX86_ 
	_GETMSG_
	if [[ "$dm" = aria2c ]];then
		aria2c http://"$CMIRROR$path$file".md5 
		_ISX86_
		aria2c -c http://"$CMIRROR$path$file"
	elif [[ "$dm" = axel ]];then
		axel http://"$CMIRROR$path$file".md5 
		_ISX86_
		axel http://"$CMIRROR$path$file"
	elif [[ "$dm" = lftp ]] ; then
		lftpget http://"$CMIRROR$path"md5sums.txt
		_ISX86_
		lftpget -c http://"$CMIRROR$path$file"
	elif [[ "$dm" = wget ]];then 
		wget "$DMVERBOSE" -N --show-progress http://"$CMIRROR$path"md5sums.txt
		_ISX86_
		wget "$DMVERBOSE" -c --show-progress http://"$CMIRROR$path$file" 
	else
		curl "$DMVERBOSE" --fail --retry 4 -OL http://"$CMIRROR$path"md5sums.txt
		_ISX86_
		curl "$DMVERBOSE" -C - --fail --retry 4 -OL http://"$CMIRROR$path$file" 
	fi
}

_GETMSG_() {
 	if [[ "$dm" = axel ]] || [[ "$dm" = lftp ]];then
 		printf "\\n\\e[1;32m%s\\n\\n""The chosen download manager \`$dm\` is being implemented: curl (command line tool and library for transferring data with URLs) alternative https://github.com/curl/curl chosen:  DONE"
	fi
}

_ISX86_() {
	if [[ "$CPUABI" = "$CPUABIX86" ]];then
		file="$(grep i686 md5sums.txt | awk {'print $2'})"
	else
		file="$(grep boot md5sums.txt | awk {'print $2'})"
	fi
	sed '2q;d' md5sums.txt > "$file".md5
	rm md5sums.txt
	_PRINTDOWNLOADINGX86TWO_ 
}

## EOF
