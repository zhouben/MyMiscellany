# .bashrc
export LM_LICENSE_FILE=8897@shlacgflx01,8897@shlacgflx02,8897@shlacgflx03
export CSCOPE_EDITOR=vim
export PATH=/usr/local/bin:$PATH
echo set arm license path to $LM_LICENSE_FILE
alias bo='cd /local/charleszhou/boreas-fw/'
alias b1='cd /local/charleszhou/b1'
alias hh='cd /local/charleszhou'
alias fw='cd /local/charleszhou/fwrepo/'
alias d1='du -h --max-depth=1'
alias sc='screen -r'
alias psc='ps -au|grep 1165850'
alias ta='tmux attach'
alias lc='cd /local/charleszhou/'
alias ho='cd firmware/apps/sabrepro/host_io'
alias vs='cd firmware/apps/sabrepro/vs'
alias be='cd firmware/apps/sabrepro/be_unittest'
alias ff=_ff

# find specific file for specifc pattern
function _ff
{
	if [ "$1" == "" ]; then
		return
	fi
	if [ "$2" == "" ]; then
		return
	fi
	echo "$1"
	echo $2
	find ./ -name "$1"|xargs grep $2
}

# the following is from jacob relles

#PATH=~/local/bin:${PATH}
#PS1="\e[1;34m[\e[m\e[0;31m\u\e[m@\e[1;32m\h\e[m \W\e[1;34m]\e[m\$"
NC='\[\e[m\]' # No Color
WHITE='\[\e[1;37m\]'
BLACK='\[\e[0;30m\]'
BLUE='\[\e[0;34m\]'
L_BLUE='\[\e[0;34m\]'
GREEN='\[\e[0;32m\]'
L_GREEN='\[\e[1;32m\]'
CYAN='\[\e[0;36m\]'
L_CYAN='\[\e[1;36m\]'
RED='\[\e[0;31m\]'
L_RED='\[\e[1;31m\]'
PURPLE='\[\e[0;35m\]'
L_PURPLE='\[\e[1;35m\]'
BROWN='\[\e[0;33m\]'
YELLOW='\[\e[1;33m\]'
GRAY='\[\e[0;30m\]'
L_GRAY='\[\e[0;37m\]'

#PS1="${NC}\n${CYAN}[${RED}\u${NC}@${L_GREEN}\h ${L_PURPLE}\w${CYAN}] (${WHITE}\T${CYAN})${NC}\n\! ${CYAN}\$${NC} "

#export ARMLMD_LICENSE_FILE=/home/jrelles/samba/license.dat
#export MAXCORE_HOME=/tools/fw/Fast_Models/FastModelsTools_8.3
#export PVLIB_HOME=/tools/fw/Fast_Models/FastModelsPortfolio_8.3

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

function _cdws {
  cd ~/samba
  if [ ! "$1" == "" ]; then
    cd $1
  fi
}


function detachall {
	attached=`screen -ls | grep Attached | sed -e "s/\..*//" -e "s/[ \t]*//"`
	for process in $attached; do
		screen -d $process
	done
}

function getscreen {
	detached=`screen -ls | grep Detached | sed -e "s/\..*//" -e "s/[ \t]*//"`
	count=`echo -ne $detached | wc -w`
	echo $count
	if [ $count -ne 0 ]; then
		echo "Detached = $detached"
		process=`echo "$detached" | head -1`
		echo "Process = $process"
		screen -S $process -p 0 -X stuff "`echo $'\cz'`"
		screen -S $process -p 0 -X stuff "export DISPLAY=$DISPLAY`echo -ne '\015'`"
		screen -S $process -p 0 -X stuff "test \`jobs | wc -l\` -eq 0 || fg`echo -ne '\015'`"
		screen -R $process
	else
		screen -RR -S jrelles
	fi
}

function _premerge {
  # get a list of conflicted files
  #changes=`git diff --stat --name-only origin/master`
  gitroot=`git rev-parse --show-cdup`
  conflicts=`git diff --name-only --diff-filter=U`
  # checkout the different versions for merging
  for filename in $conflicts; do
    rname="$gitroot""$filename"
    echo "conflict found $rname"
    git checkout --ours "$rname"
    mv "$rname" "$rname"".ours"
    git checkout --theirs "$rname"
    git mergetool "$rname" "$rname"".ours"
    echo "merged $rname, when happy with changes, run \"cleanmerge\""
    git add "$rname"
  done
}

function _cleanmerge {
  # get a list of conflicted files
  gitroot=`git rev-parse --show-cdup`
  find "$gitroot" -name "*.ours" -type f -delete
}

function _gitrename {
  for file in ${@:3}; do
    if [ ! "$file" == "${file/$1/$2}" ]; then
      printf "%-20s -> %s\n" $file ${file/$1/$2}
      git mv $file ${file/$1/$2}
    fi
  done
}


function hexformat {
  hexdump -v -e '"%08_ax:" 4 " %08x" " "' -e '16/1 "%_p" "\n"' $1
}

function _nanohex {
  tmpfile="/tmp/""$$"".hex"
  hexformat $1 > $tmpfile
  nano $tmpfile
  cat $tmpfile | xxd -r | hexformat | xxd -r > $1
  rm -f $tmpfile
}

function _vihex {
  tmpfile="/tmp/""$$"".hex"
  hexformat $1 > $tmpfile
  vi $tmpfile
  cat $tmpfile | xxd -r | hexformat | xxd -r > $1
  rm -f $tmpfile
}

function swapendian {
	objcopy -I binary -O binary --reverse-bytes=4 $1 $2
}

function bytedump {
  hexdump -v -e '1/1 "%02x\n"' $1 > $2
}

function genpfx {
  name=${1%.*}
  openssl genrsa -des3 -out $name.key 2048
  openssl req -new -key $name.key -out $name.csr
  openssl x509 -req -days 365 -in $name.csr -signkey $name.key -out $name.crt
  openssl pkcs12 -inkey $name.key -in $name.crt -export -out $name.pfx
}

function pem2pfx {
  openssl pkcs12 -inkey $1 -in $2 -export -out $(1:.pem=.pfx)
}

function striptws {
	files=`git diff @{u} --name-only`
	for file in ${files}; do
		sed -i 's/[ \t\r]*$//' "${file}"
	done
}

function _stripws {
  files=`find $1 -name win -prune -o -name external -prune -o -name obj -prune -o -name halptr -prune -o -name "*.map" -prune -o -exec grep -IcHl -e " $" {} \;`
  for file in ${files}; do
      perl -p -i -e "s/[ \t]*$//g" ${file}
      printf "%s\n" $file
  done
}

function _runrepeat {
	echo "repeating $1 times..."
	repeats=`seq $1`
	for i in ${repeats}; do ${@:2}; if [ $? -ne 0 ]; then break; fi; done
}

function argtest(){
	for i in `seq $#`; do
		arg="\"${@:$i:1}\""
		printf "%s %s %s" $arg
	done
}

function retry {
	RET=1
	until [ ${RET} -eq 0 ]; do
		${@:1}
	    RET=$?
	    sleep 1
	done
}

function replaceall {
	filenames=`grep -lnr --exclude-dir=obj --exclude-dir=*/.* --exclude-dir=bin "$1" .`
	printf "%s\n" $filenames
	sed -i "s/$1/$2/g" $filenames
}

function _grepall {
	grep -nriHI --color=auto $1 .
}

function _jira {
  if [ "$1" == "" ]; then
    return
  fi
  branch=`git branch -r | grep 'CASS'|  grep $1`
  count=`printf "${branch}\n" | wc -w`
  if [ $count -ne 1 ]; then
	printf "$count Ambiguous jira match:\n${branch}\n"
	return
  fi
  echo "Switching to branch ${branch}"
  git checkout ${branch/origin\//}
}

function g {
	branch=`git branch | grep ^\* | sed -e 's/* //g'`
	case $1 in
		push)
			(set -x; git push origin $branch)
			;;
		*)
			(set -x; git ${@:2})
			;;
	esac
}

#disable putty CTL-S annoyance
stty ixany
stty ixoff -ixon
stty erase '^?'

# User specific aliases and functions
alias ll='ls -l'
alias startvnc='vncserver -depth 24 -geometry 1920x1080'
alias mkws='git clone ssh://stash.micron.com:7999/boreas/boreas-fw.git'
alias jira=_jira
alias gr=_grepall
alias premerge=_premerge
alias cleanmerge=_cleanmerge
alias cleangit='git clean -f'
alias cdws=_cdws
alias fixperm='chmod -R -c -x+X'
alias ignore='git update-index --assume-unchanged'
alias unignore='git update-index --no-assume-unchanged'
alias showignored='git ls-files -v | grep -e "^[a-z]"'
alias nanohex=_nanohex
alias vihex=_vihex
alias stripws=_stripws
alias gitrename=_gitrename
alias gitreset='git clean -f -x -d `git rev-parse --show-cdup`'
alias genpem='openssl genrsa -des3 -out private.pem 2048'
alias runrepeat=_runrepeat
alias fixcopyright='sed -i -e "s/Copyright\([^-]\+[0-9]\{4\}\)-\([0-9]\{4\}\)/Copyright\1-2015/" -e "s/Copyright\([^-]\+\)\([0-9]\{4\}\)\([^-]\)/Copyright\1\2-2015\3/"'
alias waves='c /tools/cadence/incisive/14.20.008/tools/simvision/bin/64bit/simvision waves.shm'


