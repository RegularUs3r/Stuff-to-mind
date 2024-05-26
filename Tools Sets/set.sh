#!/bin/bash

blue='\033[0;104m'
red='\033[1;91m'
nc='\033[0m'

sudo mkdir tmp-downloads
user=$(cat /etc/passwd | grep sh$ | grep "home" | cut -d ':' -f 1)
sudo apt-get update -y

echo -e "${blue}${red}Installing latest golang version${nc}"
sudo apt-get remove golang-go -y
sudo apt-get autoremove -y
sudo wget -q https://go.dev/dl/go1.21.5.linux-amd64.tar.gz -O /home/$user/tmp-downloads/go.tar.gz
sudo tar -C /usr/local/bin/. -xzf /home/$user/tmp-downloads/go.tar.gz
#rm  /home/$user/tmp-downloads/go.tar.gz
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
sudo wget -q https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz -O /home/$user/tmp-downloads/ngrok.tgz
sudo tar -C /home/$user/tmp-downloads/ -xzf /home/$user/tmp-downloads/ngrok.tgz
sudo chmod +x /home/$user/tmp-downloads/ngrok && sudo mv /home/$user/tmp-downloads/ngrok /usr/local/bin/.
sudo mv /home/$user/tmp-downloads/ngrok /usr/local/bin/.
#rm /home/$user/tmp-downloads/ngrok.tgz
sudo -u $user bash -c "/usr/local/bin/ngrok config add-authtoken 2U7i1R4Xskpv2qcL28SPTztfqPv_4PFqD2mQk4Urd33DypbFr"

echo -e "${blue}${red}Installing latest BurpSuite version${nc}"
sudo apt-get remove burpsuite -y
sudo apt-get autoremove -y
sudo wget -q 'https://portswigger-cdn.net/burp/releases/download?product=pro&version=2023.11.1.3&type=Linux' -O /home/$user/tmp-downloads/burp.sh
chmod +x /home/$user/tmp-downloads/burp.sh
/home/$user/tmp-downloads/./burp.sh
#sudo rm /home/$user/tmp-downloads/burp.sh

echo -e "${blue}${red}Installing python2 & pip2${nc}"
sudo apt-get install python2 -y
sudo wget -q https://bootstrap.pypa.io/pip/2.7/get-pip.py -O /home/$user/tmp-downloads/pip2.py
sudo python2 /home/$user/tmp-downloads/pip2.py
sudo rm /home/$user/tmp-downloads/pip2.py

echo -e "${blue}${red}Installing JQ${nc}"
sudo apt-get install jq -y
echo -e "${blue}${red}Setting up tmux${nc}"
echo 'set -g prefix C-a' >> .tmux.conf
echo 'set -g history-limit 10000' >> .tmux.conf
echo 'set-window-option -g mode-keys vi' >> .tmux.conf

sudo rm -rf tmp-downloads