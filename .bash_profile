# .bash_profile
#  $Id$
#
# This file is read each time a login shell is started.
# It holds all aliases, functions, shopts, and environment variables, as well as setting a colorful prompt.
#
#
##### Command Aliases / Functions #####

# Shell Interaction Aliases  - stuff that makes dealing with the shell easier

# shows only directories, in alphabetical order
	alias lsd='ls | grep \/ | sort'

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
	alias ssh='ssh -C'

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

# datacrow is a personal library/database app.  datacrow.net
	alias datacrow="java -Xmx256m -jar ~/apps/datacrow/datacrow.jar"

# mutt doesn't like UTF-8 for some reason.
# Disabling this - I think I've finally gotten mutt/vim/et. al. to all play nicely with UTF8
#	alias mutt="LC_ALL=C LANG=C mutt"

# subversion - add all unignored new files to the repo
#        alias aa="for x in $(svn st | grep ^? | awk '{ print $NF }'); do svn add $x; done"

# daily journal entry in txtfiles vimwiki
	alias daily="vim ~/txtfiles/daily/$(date +%d-%b-%Y).wiki"

# tmux detact/attach
	alias tmda="tmux det; tmux att"

# weather
	alias weather="curl --silent 'http://xml.weather.yahoo.com/forecastrss?p=15210&u=f' | grep -E '(Current Conditions:|F<BR)' | tail -n 1 | cut -d'<' -f 1"

# if using telnet, set term to xterm because old systems don't have screen-256color terminfo
	alias telnet='TERM=xterm telnet'
#
# Functions
#
# greps the running process list for the value of $1
psgrep() {
	local name=$1
	ps -ef | grep "${name}" | sed '$d'
	unset $name
}

# find the Property name for autoprops with pekwm
propstring () {
	echo -n 'Property '
	xprop WM_CLASS | sed 's/.*"\(.*\)", "\(.*\)".*/= "\1,\2" {/g'
	echo '}'
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

##### End of Aliases / Functions #####

##### Environment Variables #####
# safe tmpdir
	export TMPDIR=/${HOME}/tmp/
	export TMP=${TMPDIR}

# inputrc
	export INPUTRC=~/.inputrc

# IRC defaults
	export IRCNICK=$USER

# it's 2010 - time to use UTF-8 locales.
	export LANG="en_US.UTF-8"
	export LC_CTYPE="en_US.UTF-8"

# IMAP Server default (used by mutt)
	export IMAPSERVER=example.com

# set our LS_COLORS 
	export LS_COLORS="di=38;5;27:ln=36;40:so=1;;40:pi=33;40:ex=32;40:bd=35;40:cd=1;;40:su=32;41:sg=33;46:tw=0;44:ow=33;44:"

# set highlight color for GREP
	export GREP_COLOR='1;30;43'

# export History options, to ignore certain repetitive commands
	export HISTIGNORE="&:[bf]g:exit:fortune:clear:cl:history:cat *:dict *:which *:rm *:rmdir *:shred *:man *:apropos *:sudo rm *:sudo cat *:mplayer *:source *:. *:gojo *:mutt"

# keep only one copy of any given command in our history, ignoring duplicates and lines beginning with a space
	export HISTCONTROL=erasedups:ignoreboth

# give me timestamps in my history
	#export HISTTIMEFORMAT='%F %T '

# HISTSIZE is the number of history lines to keep in RAM - I'll take a million.
	unset HISTFILESIZE
	export HISTSIZE=1000000

# fix PATH
#	PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:$HOME/bin:.

# Preferred text editor.  vim, of course.
	export EDITOR='vim'


##### End of Environment Variables #####

##### Shell-Specific Options #####
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


# no core files
ulimit -S -c 0

# Uncomment this to create hostname-based customizations, sourced based on hostname.
#[ -f ${HOME}/.bash_profile.$(hostname -s) ] && source ${HOME}/.bash_profile.$(hostname -s)

# simple test of $HOME - if $HOME contains /Users then this is an osx machine, fix Linuxisms above.
[[ "${HOME}" == "/Users/"* ]] && ( [ -f "${HOME}/.bash_profile.osx" ] && source ${HOME}/.bash_profile.osx)

##### Drawing our prompt #####

# the value of PROMPT_COMMAND gets executed by bash prior to displaying the prompt.  Unset this now, because we're going to use it later.
unset PROMPT_COMMAND

##### Color Definitions (commands to set text colors) #####
ResetColours="$(tput sgr0)"

Black="$(tput setaf 0)"
DarkGrey="$(tput bold ; tput setaf 0)"
BlackBG="$(tput setab 0)"

Red="$(tput setaf 1)"
LightRed="$(tput bold ; tput setaf 1)"
RedBG="$(tput setab 1)"

Green="$(tput setaf 2)"
LightGreen="$(tput bold ; tput setaf 2)"
GreenBG="$(tput setab 2)"

Yellow="$(tput setaf 3)"
BrightYellow="$(tput bold ; tput setaf 3)"
YellowBG="$(tput setab 3)"

Blue="$(tput setaf 4)"
BrightBlue="$(tput bold ; tput setaf 4)"
BlueBG="$(tput setab 4)"

Purple="$(tput setaf 5)"
PurpleBG="$(tput setab 5)"
Pink="$(tput bold ; tput setaf 5)"

Cyan="$(tput setaf 6)"
BrightCyan="$(tput bold ; tput setaf 6)"
CyanBG="$(tput setab 6)"

LightGrey="$(tput setaf 7)"
White="$(tput bold ; tput setaf 7)"
LightGreyBG="$(tput setab 7)"

##### End of Color Definitions #####

##### User defined Variables. #####
# Set User Chosen Colours Here:

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
##### End User Settings #####

##### Priviliged User Prompt #####
# This changes the username color for "other" users
case $USER in
	root)
		UNC="${Red}"
		PromptColor="${Red}"
		;;
esac
##### End of Root Prompt

##### Set some Useful Variables #####
##### End of Useful Vars #####

##### Begin Function Definitons #####

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
	echo -e -n "${DarkGrey}$(hr)[Exit "
	if [ "$EXIT" -gt "0" ]; then
		echo -n "${Red}${EXIT}${ResetColours}"
	else
		echo -n "${Green}${EXIT}${ResetColours}"
	fi
}

# function hg_prompt_info {
# if [ -d "${PWD}/.hg" ] || [[ "${PWD}" == *"${HOME}"* ]]; then
# 	echo -n "${UC1}­["
# 	hg prompt "${DarkGrey}☿ ${ResetColours}${Green}{rev}${Pink}{status|modified}${ResetColours}${Cyan}{status|unknown}${ResetColours}${Yellow}{update}${ResetColours}" 2>/dev/null
# 	echo -n "${UC1}]${ResetColours}"
# elif [ -d ${HOME}/.hg -a "${PWD/$HOME}" = "$PWD" ]; then
# 	hg prompt "${DarkGrey}☿ ${ResetColours}${Green}{rev}${Pink}{status|modified}${ResetColours}${Cyan}{status|unknown}${ResetColours}${Yellow}{update}${ResetColours}" 2>/dev/null
# 	echo -n "${UC1}]${ResetColours}"
# fi
# }


##### End Function Definitons #####


##### Export Prompt #####
export PROMPT_COMMAND="lastexit; echo -n '${UC1}]${ResetColours}'"

# uncomment this and the hg_prompt_info function above to get mercurial info in your prompt
#PS1="\[${UC1}\]­[\[${UNC}\]\u\[${UC1}\]@\[${UC4}\]\h\[${UC1}\]:\[${UC2}\]\w\[${UC1}\]]\$(hg_prompt_info)\[${UC1}\]­[\$(load_info)\[${UC1}\]]-\[${UC1}\][\[${UC3}\]\$(date +%R)\[\[${ResetColours}\]${UC1}\]]\[${ResetColours}\]\n\[${PromptColor}\]⚛\[${ResetColours}\] "

# prompt does not include mercurial info
PS1="\[${UC1}\]­[\[${UNC}\]\u\[${UC1}\]@\[${UC4}\]\h\[${UC1}\]:\[${UC2}\]\w\[${UC1}\]]\[${UC1}\]­[\$(load_info)\[${UC1}\]]-\[${UC1}\][\[${UC3}\]\$(date +%R)\[\[${ResetColours}\]${UC1}\]]\[${ResetColours}\]\n\[${PromptColor}\]⚛\[${ResetColours}\] "

PS2="\[${UC1}\]--\[${ResetColours}\]"
##### End of Export Prompt #####

##### START bash completion -- do not remove this line #####
[ -f /etc/bash_completion ] && source /etc/bash_completion
##### END bash completion -- do not remove this line #####


##########################
# End of .bash_profile	 #
##########################
