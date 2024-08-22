#!/bin/bash

blue='\033[0;104m'
red='\033[1;91m'
nc='\033[0m'
user=$(cat /etc/passwd | grep sh$ | grep "home" | cut -d ':' -f 1)

echo -e "${blue}${red}Setting new PATH${nc}"
sed -i "s|export.*||g" /home/$user/.bashrc

sudo apt update -y
sudo mkdir tmp-downloads

echo -e "${blue}${red}Installing latest golang version${nc}"
sudo apt-get remove golang-go -y
sudo apt-get autoremove -y
sudo wget -q https://go.dev/dl/go1.21.5.linux-amd64.tar.gz -O /home/$user/tmp-downloads/go.tar.gz
sudo tar -C /usr/local/bin/. -xzf /home/$user/tmp-downloads/go.tar.gz
sudo rm  /home/$user/tmp-downloads/go.tar.gz
echo "export PATH=/usr/local/bin/go/bin:$PATH" | sed 's| |\\ |g; s|(|\\(|g; s|)|\\)|g; s|export\\ |export |g' >> /home/$user/.bashrc
source /home/$user/.bashrc

echo -e "${blue}${red}Installing FFUF${nc}"
sudo apt install ffuf -y

echo -e "${blue}${red}Installing EXPLOITDB${nc}"
sudo apt install exploitdb


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
sudo rm /home/$user/tmp-downloads/ngrok.tgz
sudo -u $user bash -c "/usr/local/bin/ngrok config add-authtoken 2U7i1R4Xskpv2qcL28SPTztfqPv_4PFqD2mQk4Urd33DypbFr"

echo -e "${blue}${red}Uninstalling BurpSuite${nc}"
sudo apt-get remove burpsuite -y
sudo apt-get autoremove -y
#sudo wget -q 'https://portswigger-cdn.net/burp/releases/download?product=community&version=2023.11.1.3&type=Linux' -O /home/$user/tmp-downloads/burp.sh
#sudo chmod +x /home/$user/tmp-downloads/burp.sh
#sudo /home/$user/tmp-downloads/./burp.sh
#sudo rm /home/$user/tmp-downloads/burp.sh

echo -e "${blue}${red}Installing JQ${nc}"
sudo apt-get install jq -y
echo -e "${blue}${red}Setting up tmux${nc}"
echo 'set -g prefix C-a' >> .tmux.conf
echo 'set -g history-limit 10000' >> .tmux.conf
echo 'set-window-option -g mode-keys vi' >> .tmux.conf
echo 'set-option -g default-command $SHELL' >> .tmux.conf

sudo rm -rf tmp-downloads
sudo apt update -y
