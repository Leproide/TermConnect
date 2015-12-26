#!/bin/bash
#
#    TermConnect - The easiest way to connect to wireless
#    Copyright (C) 2015-2016
#    Script by Leprechaun
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#1
#    E-Mail: leproide@paranoici.org
#    PGP: https://pgp.mit.edu/pks/lookup?op=get&search=0x8FF24099181CE01E

# -------------------------------------------------------------------------------
clear
tput setaf 3; tput bold;
echo '___________                  _________                                     __ '
echo '\__    ___/__________  _____ \_   ___ \  ____   ____   ____   ____   _____/  |_' 
echo '  |    |_/ __ \_  __ \/     \/    \  \/ /  _ \ /    \ /    \_/ __ \_/ ___\   __\'
echo '  |    |\  ___/|  | \/  Y Y  \     \___(  <_> )   |  \   |  \  ___/\  \___|  |'
echo '  |____| \___  >__|  |__|_|  /\______  /\____/|___|  /___|  /\___  >\___  >__| ' 
echo '             \/            \/        \/            \/     \/     \/     \/    '
tput setaf 1; tput bold;
echo -e "\n					The easiest way to connect to wireless"

#Inizio script
tput setaf 4; tput bold;
echo -e "\n\nVisualizzo gli adattatori di rete WiFi..."
tput setaf 7; tput bold;
ifconfig | grep "wl" -A 1
tput setaf 4; tput bold;
echo -e "\nQuale wlan vuoi utilizzare? (default wlan0)"
tput setaf 7; tput bold;
read wadapter
if [ -z "$wadapter" ]; then
wadapter=wlan0
fi
tput setaf 4; tput bold;
echo -e "\nNome della rete?"
tput setaf 7; tput bold;
read ssid
tput setaf 4; tput bold;
echo -e "\nPassword della rete?"
tput setaf 7; tput bold;
read passphrase
clear
tput setaf 4; tput bold; echo "Mi connetto alla rete con SSID:" $ssid "Password:" $passphrase "su interfaccia" $wadapter

ip link set $wadapter down || { tput setaf 1; tput bold; echo -e "\nErrore: Qualcosa è andato storto..." ; exit 1; }
iwconfig $wadapter mode Managed || { tput setaf 1; tput bold; echo -e "\nErrore: Qualcosa è andato storto..." ; exit 1; }
ip link set $wadapter up || { tput setaf 1; tput bold; echo -e "\nErrore: Qualcosa è andato storto..." ; exit 1; }

killall wpa_supplicant || { tput setaf 1; tput bold; echo -e "\nErrore: Qualcosa è andato storto..." ; exit 1; }

wpa_supplicant -B -i $wadapter -dd -c <(wpa_passphrase $ssid $passphrase) || { tput setaf 1; tput bold; echo -e "\nErrore: Qualcosa è andato storto..." ; exit 1; }
clear
tput setaf 2; tput bold;
dhcpcd $wadapter && iwconfig $wadapter || { tput setaf 1; tput bold; echo -e "\nErrore: Qualcosa è andato storto..." ; exit 1; }
