#!/bin/bash
blue='\033[0;104m'
red='\033[1;91m'


echo "${blue} ${red}Installing usefull tools"

sudo apt update -y

echo "${blue} ${red}Preparing /opt dir for seclists"
sudo mkdir /opt/sec

echo "${blue} ${red}Git cloning it into /opt/sec"
sudo git clone https://github.com/danielmiessler/SecLists /opt/sec


echo "${blue} ${red}Installing Evil-winrm"
sudo gem install winrm winrm-fs colorize stringio && sudo gem install evil-winrm


echo "${blue} ${red}Installing CrackMapExec - cme"
sudo python3 -m pip install pipx && sudo pipx ensurepath && sudo apt-get install python3-venv && pipx install crackmapexec


echo "${blue} ${red}Getting imapckets ready!!"
sudo git clone https://github.com/SecureAuthCorp/impacket.git /opt/impacket
sudo pip3 install -r /opt/impacket/requirements.txt
sudo python3 ./setup.py install
###MIND THIS => pip install impacket==0.9.22
   

echo "${blue} ${red}Installing FFUF"
sudo apt install ffuf -y

echo "${blue} ${red}Installing Feroxbuster"
sudo apt install feroxbuster -y


echo "${blue} ${red}Installing exploitdb"
sudo apt install exploitdb -y

### To compile windows privesc exploits written in C
echo "${blue} ${red}Installing required 'thing' to compile windows c programs"
sudo apt install mingw-w64 -y

echo "${blue} ${red}Installing JQ"
sudo apt install jq -y

echo "${blue} ${red}Installing GPP crack password tool!"
#GPP stands for "Group Policy Preferences File"
sudo apt install gpp-decrypt

echo"${blue} ${red}Installing mount stuff - to moung shares"
sudo apt-get install cifs-utils -y
sudo apt-get install libguestfs-tools -y

echo "Installing rlwrap for good reverse shell"
sudo apt install rlwrap -y

echo "Installing python2 and pip2"
sudo apt install python2 -y
curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
sudo python2 get-pip.py

sudo apt update -y