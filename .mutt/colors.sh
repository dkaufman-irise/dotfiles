#!/bin/bash
# $Id$
# outputs color information for mutt depending on whether we're in a standard or 256 color term

if [[ "$(tput colors)" =~ "256" ]]; then
	\cat ~/.mutt/colors-256
else
	\cat ~/.mutt/colors
fi
