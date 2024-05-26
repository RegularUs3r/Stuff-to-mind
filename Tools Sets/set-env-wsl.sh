!/bin/bash

blue='\033[0;104m'
red='\033[1;91m'
nc='\033[0m'

sudo mv /var/lib/apt/lists ~/ && sudo apt-get install mlocate wget ffuf nmap wafw00f tmux python3 make python3-pip jq libssl-dev libncurses5-dev libsqlite3-dev libreadline-dev libtk8.6 libgdm-dev libdb4o-cil-dev libpcap-dev vim git -y && wget https://www.python.org/ftp/python/2.7.13/Python-2.7.13.tar.xz && tar xf Python-2.7.13.tar.xz && sudo ./Python-2.7.13/configure && sudo make && sudo make install && wget https://bootstrap.pypa.io/pip/2.7/get-pip.py && sudo python2 get-pip.py

echo -e "${blue}${red}Installing bunch of tool${nc}"
sudo apt-get install mlocate wget ffuf nmap wafw00f tmux python3 make python3-pip jq libssl-dev libncurses5-dev libsqlite3-dev libreadline-dev libtk8.6 libgdm-dev libdb4o-cil-dev libpcap-dev vim git -y

echo -e "${blue}${red}Installing python2${nc}"


echo -e "${blue}${red}Setting up PIP2${nc}"




user=$(cat /etc/passwd | grep sh$ | grep "home" | cut -d ':' -f 1) && wget -q https://go.dev/dl/go1.21.5.linux-amd64.tar.gz -O go.tar.gz && sudo tar -C /usr/local/bin/. -xzf go.tar.gz && echo "export PATH=/usr/local/bin/go/bin:$PATH" >> /home/$user/.bashrc && source /home/$user/.bashrc
echo -e "${blue}${red}Installing latest golang version${nc}"


echo "export PATH=/usr/local/bin/go/bin:$PATH" >> /home/$user/.bashrc
source /home/$user/.bashrc

echo -e "${blue}${red}Installing HTTPX${nc}"
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest

echo -e "${blue}${red}Installing SUBFINDER${nc}"
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

echo -e "${blue}${red}Cloning SecLists${nc}"
sudo git clone https://github.com/danielmiessler/SecLists.git /opt/sec

echo -e "${blue}${red}Installing NGROK${nc}"
wget -q https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz -O /home/$user/Downloads/ngrok.tgz
tar -C /home/$user/Downloads/ -xzf /home/$user/Downloads/ngrok.tgz
chmod +x /home/$user/Downloads/ngrok
rm /home/$user/Downloads/ngrok.tgz
sudo -u $user bash -c "/home/$user/Downloads/ngrok config add-authtoken 2U7i1R4Xskpv2qcL28SPTztfqPv_4PFqD2mQk4Urd33DypbFr"

echo -e "${blue}${red}Setting up tmux${nc}"
echo 'set -g prefix C-a' >> .tmux.conf
echo 'set -g history-limit 10000' >> .tmux.conf
echo 'set-window-option -g mode-keys vi' >> .tmux.conf