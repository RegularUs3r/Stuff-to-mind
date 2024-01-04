#!/bin/bash

blue='\033[0;104m'
red='\033[1;91m'
nc='\033[0m'

user=$(cat /etc/passwd | grep sh$ | grep "home" | cut -d ':' -f 1)
sudo apt-get update -y

echo -e "${blue}${red}Installing latest golang version${nc}"
sudo apt-get remove golang-go -y
sudo apt-get autoremove -y
wget -q https://go.dev/dl/go1.21.5.linux-amd64.tar.gz -O /home/$user/Downloads/go.tar.gz
sudo tar -C /usr/local/bin/. -xzf /home/$user/Downloads/go.tar.gz
rm  /home/$user/Downloads/go.tar.gz
echo "export PATH=/usr/local/bin/go/bin:$PATH" >> /home/$user/.bashrc
source /home/$user/.bashrc

echo -e "${blue}${red}Installing HTTPX${nc}"
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest

echo -e "${blue}${red}Installing SUBFINDER${nc}"
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest


echo -e "${blue}${red}Installing FFUF${nc}"
go install github.com/ffuf/ffuf/v2@latest
sudo mv /home/$user/go/bin/* /usr/local/bin/

echo -e "${blue}${red}Installing EXPLOITDB${nc}"
sudo git clone https://gitlab.com/exploit-database/exploitdb.git /usr/local/bin/exploitdb
echo "export PATH=/usr/local/bin/exploitdb:$PATH" >> /home/$user/.bashrc
source /home/$user/.bashrc

echo -e "${blue}${red}Installing MLOCATE${nc}"
sudo apt-get install mlocate -y
echo -e "${blue}${red}Updating DB${nc}"
sudo updatedb

echo -e "${blue}${red}Cloning SecLists${nc}"
sudo git clone https://github.com/danielmiessler/SecLists.git /opt/sec

echo -e "${blue}${red}Installing NGROK${nc}"
wget -q https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz -O /home/$user/Downloads/ngrok.tgz
tar -C /home/$user/Downloads/ -xzf /home/$user/Downloads/ngrok.tgz
chmod +x /home/$user/Downloads/ngrok
rm /home/$user/Downloads/ngrok.tgz
sudo -u $user bash -c "/home/$user/Downloads/ngrok config add-authtoken 2U7i1R4Xskpv2qcL28SPTztfqPv_4PFqD2mQk4Urd33DypbFr"

echo -e "${blue}${red}Installing latest BurpSuite version${nc}"
sudo apt-get remove burpsuite -y
sudo apt-get autoremove -y
wget -q 'https://portswigger-cdn.net/burp/releases/download?product=pro&version=2023.11.1.3&type=Linux' -O /home/$user/Downloads/burp.sh
chmod +x /home/$user/Downloads/burp.sh
/home/$user/Downloads/./burp.sh
sudo rm /home/$user/Downloads/burp.sh

echo -e "${blue}${red}Installing python2 & pip2${nc}"
sudo apt-get install python2 -y
sudo wget -q https://bootstrap.pypa.io/pip/2.7/get-pip.py -O /home/$user/Downloads/pip2.py
sudo python2 /home/$user/Downloads/pip2.py
sudo rm /home/$user/Downloads/pip2.py

echo -e "${blue}${red}Installing JQ${nc}"
sudo apt-get install jq -y
echo -e "${blue}${red}Setting up tmux${nc}"
echo 'set -g prefix C-a' >> .tmux.conf
echo 'set -g history-limit 10000' >> .tmux.conf
echo 'set-window-option -g mode-keys vi' >> .tmux.conf
