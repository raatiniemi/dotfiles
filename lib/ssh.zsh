#!/bin/zsh
ssh_home="$HOME/.ssh/";

if [ -f "$ssh_home/known_hosts" ]; then
	hosts=(`awk '{print $1}' $ssh_home/known_hosts | tr ',' ' '`);
fi;

if [ -f "$ssh_home/config" ]; then
	hosts=($hosts `grep ^Host $ssh_home/config|sed s/Host\ //|egrep -v '^\*$'`);
fi;

if [ -n "$hosts" ]; then
	zstyle ':completion:*:hosts' hosts $hosts
fi;
unset hosts;
