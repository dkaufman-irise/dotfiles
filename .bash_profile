# .bash_profile
#  $Id$
#
# This file is read each time a login shell is started.
# It holds all aliases, functions, shopts, and environment variables, as well as setting a colorful prompt.
#
# do nothing if not an interactive shell
[ -z "$PS1" ] && return

# remove any current prompt settings
unset PROMPT_COMMAND

##### Color Definitions (commands to set text colors) #####
ResetColours="$(tput sgr0)"

Black="$(tput setaf 0)"
DarkGrey="$(tput bold ; tput setaf 0)"

BlackBG="$(tput setab 0)"
BrightBlackBG="$(tput bold; tput setab 0)"

Red="$(tput setaf 1)"
LightRed="$(tput bold ; tput setaf 1)"

RedBG="$(tput setab 1)"
LightRedBG="$(tput bold; tput setab 1)"

Green="$(tput setaf 2)"
LightGreen="$(tput bold ; tput setaf 2)"

GreenBG="$(tput setab 2)"
LightGreenBG="$(tput bold; tput setab 2)"

Brown="$(tput setaf 3)"
Yellow="$(tput bold ; tput setaf 3)"

BrownBG="$(tput setab 3)"
YellowBG="$(tput bold; tput setab 3)"

Blue="$(tput setaf 4)"
BrightBlue="$(tput bold ; tput setaf 4)"

BlueBG="$(tput setab 4)"
BrightBlueBG="$(tput bold; tput setab 4)"

Purple="$(tput setaf 5)"
PurpleBG="$(tput setab 5)"

Pink="$(tput bold ; tput setaf 5)"
PinkBG="$(tput bold ; tput setab 5)"

Cyan="$(tput setaf 6)"
BrightCyan="$(tput bold ; tput setaf 6)"

CyanBG="$(tput setab 6)"
BrightCyanBG="$(tput bold ; tput setab 6)"

LightGrey="$(tput setaf 7)"
White="$(tput bold ; tput setaf 7)"

LightGreyBG="$(tput setab 7)"
WhiteBG="$(tput bold ; tput setab 7)"

##### Set User Chosen Colours Here #####

# brackets, parentheses, separators
UC1="${DarkGrey}"

# color of current working directory
UC2="${Blue}"

# prompt timestamp color
UC3="${LightGrey}"

# hostname color
UC4="${Purple}"

# display username in this colour
UNC="${Green}"

# display prompt in this color
PromptColor="${DarkGrey}"

# Warning colour for low load
WC1="${Green}"

# Medium Load
WC2="${Yellow}"

# High Load
WC3="${Red}"
##### End of Color Definitions #####


##### Shell Options #####
#correct spelling errors in cd pathnames
shopt -s cdspell
#multi-line commands appended to history as single-line, for ease of editing
shopt -s cmdhist
#extended file-globbing
shopt -s extglob
#appends history entries rather than overwriting them.
shopt -s histappend
# includes dotfiles in tab-completion
shopt -s dotglob
# always update windowsize after each command
shopt -s checkwinsize
# if a bare directory is typed as a command, cd to it instead
shopt -s autocd
# ls -F style markers for tab-completed items
set visible-stats on
##### End of Shell-Specific Options #####
#
#
#####  Aliases #####

# shows only directories, in alphabetical order
	alias lsd='ls -alF --color | grep \/ | sort'

# always list in color, tagged for type, human readable sizes
	alias ls='ls -h --color -F --time-style long-iso'

# convert permissions to octal - http://www.shell-fu.org/lister.php?id=205
	alias lo='ls -l | sed -e 's/--x/1/g' -e 's/-w-/2/g' -e 's/-wx/3/g' -e 's/r--/4/g' -e 's/r-x/5/g' -e 's/rw-/6/g' -e 's/rwx/7/g' -e 's/---/0/g' | column -t'

# get an ordered list of subdirectory sizes - http://www.shell-fu.org/lister.php?id=275
	alias dux='du -sk ./* | sort -n | awk '\''BEGIN{ pref[1]="K"; pref[2]="M"; pref[3]="G";} { total = total + $1; x = $1; y = 1; while( x > 1024 ) { x = (x + 1023)/1024; y++; } printf("%g%s\t%s\n",int(x*10)/10,pref[y],$2); } END { y = 1; while( total > 1024 ) { total = (total + 1023)/1024; y++; } printf("Total: %g%s\n",int(total*10)/10,pref[y]); }'\'''

# tree!
	alias tree="ls -R | grep \":$\" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/ /' -e 's/-/|/'"

# uncomment the following if you find it useful and install vimpager into your path somewhere like ~/bin
# Use vi as our normal file PAGER.
#	export PAGER="vimpager"

# assign value of less to our $PAGER
#	alias less='${PAGER}'

# use vim (invoked as view) as our Man file Pager - see alias section above
#	export MANPAGER="${HOME}/bin/vimpager"

# use vim (invoked as view) as our man file pager - this gives us syntax highlighted man pages! - See MANPAGER env var
#	alias man='man -P "$MANPAGER"'

# syntax-highlighted cat, if pygmentize is installed
	[ -x $(which pygmentize) ] && alias dog='pygmentize -O style=native -f console256 -g'

# turn on compression and forward X by default
	alias ssh='ssh -C -Y'

# we have a dual core processor, don't we? let's run concurrent make jobs...
	alias make='make -j3'

	# I'm lazy - one-stop installation of source packages (which we really shouldn't be doing in 2014, we have package managers for a reason)
	alias build='./configure && make && sudo make install'

# one stop iso burning
	alias burn='cdrecord -tao dev=/dev/scd0 driveropts=burnfree'

# colorize grep
	alias grep='grep --color'

# generate changelog from RCS logs
	alias cl="LC_ALL=C rcs2log -R -v -h ${HOSTNAME} | fmt > ChangeLog"

# history file - popular commands, for future aliases
	alias histpop='cut -f1 -d" " .bash_history | sort | uniq -c | sort -nr | head -n 30'

# subversion - add all unignored new files to the repo
#        alias aa="for x in $(svn st | grep ^? | awk '{ print $NF }'); do svn add $x; done"

# tmux detact/attach
	alias tmda="tmux det; tmux att"

# weather
	alias weather="curl --silent 'http://xml.weather.yahoo.com/forecastrss?p=15210&u=f' | grep -E '(Current Conditions:|F<BR)' | tail -n 1 | cut -d'<' -f 1"

# if using telnet, set term to xterm because old systems don't have screen-256color terminfo
	alias telnet='TERM=xterm telnet'
#
# Functions
##### Begin Function Definitons #####

# show only nonempty, noncommented lines from a file
	trim() {
		local file="${1}"
		egrep -v "^#" "${file}" | grep -v ^$
	}

# Calculates and sets up Load
function load_info {
	#load average
	local avg="$(\cat /proc/loadavg)"
	local load="${avg%% *}"

	#convert to percentage
	local load100=$(echo -e "scale=0 \n ${load}/0.01 \n quit \n" | bc)
	local output # ='\253\273'

	#visual indication of load, by color and symbol
	if [ "$load100" -gt "200" ]; then
		# very high load: show the numeric value in WC3
		DC="${WC3}"
		output="${load}"
	elif [ "$load100" -gt "150" ]; then
		# high load - WC3
		DC="${WC3}"
		output=${load}
	elif [ "$load100" -gt "100" ]; then
		# medium load - WC2
		DC="${WC2}"
		output=${load}
	else
		DC="${WC1}"
		output=${load}
	fi

	#  print the output:
	echo -en "${DC}${output}"
	echo -en "${ResetColours}"
}

function lastexit() {  # outputs the color-coded value of $?
	EXIT=$?
	echo -e -n "${UC1}$(hr)┌[Exit "
	if [ "$EXIT" -eq "0" ]; then
		echo -n "${Green}${EXIT}${ResetColours}"
	else
		echo -n "${Red}${EXIT}${ResetColours}"
	fi
}

# calling hg root is too slow
#function find_hg_root() {
#	CWD="${PWD}"
#    while [ "${PWD}" != "/" ];
#	do
#      [ -f ${PWD}/.hg/dirstate ] && export HG_ROOT="${PWD}/.hg" && cd "${CWD}" && return 0
#	cd ..
#	done
#	cd "${CWD}"
#	return 1
#}

function repo_prompt_info {
	if git status -s &>/dev/null; then
		echo -n "${UC1}­[${DARKGREY} ${ResetColours}"
		BRANCH="$(git branch | grep ^\* | awk '{ print $NF }')"
		if $(git status | grep -q "modified:"); then
			echo -n "${Red}${BRANCH}${ResetColours}"
		else
			echo -n "${Green}${BRANCH}${ResetColours}"
		fi
		echo -n "${UC1}]${ResetColours}"
	# elif find_hg_root; then
	# 	hg_branch=$(cat "$HG_ROOT/branch" 2>/dev/null || hg branch)
	# 	echo -n "${UC1}­["${DarkGrey}☿ ${ResetColours}${Blue}"$hg_branch${ResetColours}${DarkGrey}:${ResetColours}"
	# 	hg prompt "${Green}{rev}${Pink}{status|modified}${ResetColours}${Cyan}{status|unknown}${ResetColours}${Yellow}{update}${ResetColours}" 2>/dev/null
	# 	echo -n "${UC1}]${ResetColours}"
	fi
}

# calculator!  requires bc
? () { echo "$*" | bc -l; }

# random alphanumeric password
randpass() {
	local chars=$1
	strings /dev/urandom | grep -o '[[:alnum:]]' | head -n $chars | tr -d '\n'; echo
	unset chars
}

# googone - rm's files previously extracted from a tarball
googone() {
	local TARB="${1}"
	tar -tf ${TARB} | xargs rm -r &>/dev/null
}

# frequency of words in a stream of text/file
freq() {
	 awk '{for (x=1;x<=NF;x++) print $x}' $1 | sed -e 's/,//g' -e 's/;//g' -e 's/"//g' -e 's/://g' -e s/\'//g | sort | uniq -c | sort -nr
}

function hr() {
	PATTERN="${1:-─}";
	for ((x=0; x<$COLUMNS; x++)); do
		echo -n "${PATTERN}"
	done
}
# used in prompt to change tmux buffer titles to hostname -s
title() {
	printf "\033k$1\033\\"
}
##### End of Aliases / Functions #####

##### keybindings for vi-mode #####
set -o vi
bind -m vi-command ".":insert-last-argument
bind -m vi-insert "\C-l.":clear-screen
bind -m vi-insert "\C-a.":beginning-of-line
bind -m vi-insert "\C-e.":end-of-line
bind -m vi-insert "\C-w.":backward-kill-word
bind -m vi-insert "\C-u.":backward-kill-line
bind -m vi-insert "\C-k.":kill-line
##### end of keybindings for vi-mode #####

##### Environment Variables #####
# safe tmpdir
#	export TMPDIR=/${HOME}/tmp/
#	export TMP=${TMPDIR}

# inputrc
	export INPUTRC=~/.inputrc

# IRC defaults
	export IRCNICK=$USER

# it's 20XX - time to use UTF-8 locales.
	export LANG="en_US.UTF-8"
	export LC_CTYPE="en_US.UTF-8"

# LS_COLORS - handy table
#   FG Color     BG  Color     Other FG Color     Other BG Colors
#   30  Black    40  BlackBG   90   Dark Grey     100  Dark GreyBG
#   31  Red      41  RedBG     91   Light Red     101  Light RedBG
#   32  Green    42  GreenBG   92   Light Green   102  Light GreenBG
#   33  Orange   43  OrangeBG  93   Yellow        103  YellowBG
#   34  Blue     44  BlueBG    94   Light Blue    104  Light BlueBG
#   35  Purple   45  PurpleBG  95   Light Purple  105  Light PurpleBG
#   36  Cyan     46  CyanBG    96   Turquoise
#   37  Grey     47  GreyBG    97   White
#
    export LS_COLORS="di=34;40:ln=36;40;4:so=35;40:pi=1;35;40:ex=1;32;40:bd=1;33;41:cd=1;33;40:su=37;41:sg=0;41:or=93;4:or=31;1:tw=32;44:ow=0;44:"
#                  dir┘        │          │        │          │          │          │          │        │       │        │       │       │
#                       symlink┘          │        │          │          │          │          │        │       │        │       │       │
#                                   socket┘        │          │          │          │          │        │       │        │       │       │
#                                   named pipe/FIFO┘          │          │          │          │        │       │        │       │       │
#                                                   executable┘          │          │          │        │       │        │       │       │
#                                                            block device┘          │          │        │       │        │       │       │
#                                                                   character device┘          │        │       │        │       │       │
#                                                                                   setuid file┘        │       │        │       │       │
#                                                                                            setgid file┘       │        │       │       │
#                                                                                                 broken symlink┘        │       │       │
#                                                                                                  missing symlink target┘       │       │
#                                                                                              dir other writeable, no sticky bit┘       │
#                                                                                                      dir other writeable, no sticky bit┘

# set highlight color for GREP
	export GREP_COLOR='1;30;43'

# export History options, to ignore certain repetitive commands
export HISTIGNORE="&:[bf]g:exit:fortune:clear:cl:history:cat *:dict *:which *:rm *:rmdir *:shred *:man *:apropos *:sudo rm *:sudo cat *:mplayer *:source *:. *:gojo *:mutt:*AWS*:file *"

# keep only one copy of any given command in our history, ignoring duplicates and lines beginning with a space
	export HISTCONTROL=erasedups:ignoreboth

# give me timestamps in my history
	#export HISTTIMEFORMAT='%F %T '

# HISTSIZE is the number of history lines to keep in RAM - I'll take a million.
	unset HISTFILESIZE
	export HISTSIZE=1000000

# fix PATH
	PATH=/usr/local/java/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:$HOME/bin:/opt/aws/bin

# Default windowmanager for startx command
	export WINDOWMANAGER='/usr/bin/xmonad'

# Use vi as our normal file PAGER.
	export PAGER="vimpager"

# use vim (invoked as view) as our Man file Pager - see alias section above
	export MANPAGER="${HOME}/bin/vimpager"

# Preferred text editor.  vim, of course.  Emacs is for heathens.
	export EDITOR='vim'

# env for VIM templates
	export VIMTEMPLATES='${HOME}/.vim/templates/'

	# mail notification (disable)
#	export MAIL=${HOME}/mail/inbox
	unset MAILCHECK


##### End of Environment Variables #####

##### Other environment settings #####
# no core files
ulimit -S -c 0

# mkdir for .viminfo outside of NFS to try and avoid unwriteable error
mkdir -p /var/tmp/${USER} >&/dev/null

##### START bash completion -- do not remove this line #####
[ -f /etc/bash_completion ] && source /etc/bash_completion
##### END bash completion -- do not remove this line #####

##### Export Prompt #####

# Priviliged User Prompt
# This changes the username color for "other" users
case $USER in
	root)
		UNC="${Red}"
		PromptColor="${Red}"
		;;
esac
##### End of Root Prompt #####

export PROMPT_COMMAND="lastexit; title $(hostname -s); echo -n '${UC1}]${ResetColours}'"

PS1="\[${UC1}\]­[\[${ResetColours}\]\[${UNC}\]\u\[${ResetColours}\]\[${UC1}\]@\[${ResetColours}\]\[${UC4}\]\h\[${ResetColours}\]\[${UC1}\]:\[${ResetColours}\]\[${UC2}\]\w\[${ResetColours}\]\[${UC1}\]]\[${ResetColours}\]\$(repo_prompt_info)\[${UC1}\]­[\[${ResetColours}\]\$(load_info)\[${UC1}\]]-\[${UC1}\][\[${ResetColours}\]\[${UC3}\]\$(TZ="Pacific/Honolulu" date +%R)\[\[${ResetColours}\]${UC1}\]]\[${ResetColours}\]\n\[${PromptColor}\]└⚛\[${ResetColours}\] "

PS2="\[${UC1}\]--\[${ResetColours}\]"
##### End of Export Prompt #####

# source any local customizations, based on hostname. ensure we always exit 0
[ -f ${HOME}/.bash_profile.$(hostname -s) ] && source ${HOME}/.bash_profile.$(hostname -s) || (echo > /dev/null)

##### End of .bash_profile	 #####
