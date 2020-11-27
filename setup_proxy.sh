#!/bin/bash

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
MAGENTA='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
Color_Off="\033[0m"

#  checking sudo
# ==========================
if [ $EUID != 0 ]; then
    printf "${RED} run as: sudo ./setup_proxy.sh \n"
    exit
fi
# ==========================

clear
printf "${GREEN}     ____          _        _            _____                          \n"
printf "${YELLOW}    / __ \        (_)      | |          |  __ \                         \n"
printf "${BLUE}   | |  | | _   _  _   ___ | | __ _   _ | |__) |_ __  ___ __  __ _   _  \n"
printf "${MAGENTA}   | |  | || | | || | / __|| |/ /| | | ||  ___/| '__|/ _ \\\ \/ /| | | | \n"
printf "${CYAN}   | |__| || |_| || || (__ |   < | |_| || |    | |  | (_) |>  < | |_| | \n"
printf "${RED}    \___\_\ \__,_||_| \___||_|\_\ \__, ||_|    |_|   \___//_/\_\ \__, | \n"
printf "${GREEN}                                   __/ |                          __/ | \n"
printf "${YELLOW}                                  |___/                          |___/  \n"


USERNAME=""
printf "${BLUE}\n  Enter linux username: ${Color_Off}"
read -r USERNAME

# ==================================================================================================================
#               						Adding proxy_on proxy_off functions
# ==================================================================================================================
printf  "${BLUE} \n  Adding proxy_on proxy_off functions to bashrc zshrc ${Color_Off}"

echo '' >> /home/${USERNAME}/.bashrc
echo 'proxy_on(){' >> /home/${USERNAME}/.bashrc
echo "	sudo sed -e '/h/ s/^#*//' -i /etc/environment /etc/apt/apt.conf.d/proxy.conf ~/.curlrc ~/.wgetrc" >> /home/${USERNAME}/.bashrc
echo '}' >> /home/${USERNAME}/.bashrc

echo '' >> /home/${USERNAME}/.bashrc
echo 'proxy_off(){' >> /home/${USERNAME}/.bashrc
echo "	sudo sed -e '/h/ s/^#*/#/' -i /etc/environment /etc/apt/apt.conf.d/proxy.conf ~/.curlrc ~/.wgetrc" >> /home/${USERNAME}/.bashrc
echo '}' >> /home/${USERNAME}/.bashrc

if [ ! -f /home/${USERNAME}/.zshrc ]; then
 	echo '' >> /home/${USERNAME}/.zshrc
	echo 'proxy_on(){' >> /home/${USERNAME}/.zshrc
	echo "	sudo sed -e '/h/ s/^#*//' -i /etc/environment /etc/apt/apt.conf.d/proxy.conf" >> /home/${USERNAME}/.zshrc
	echo '}' >> /home/${USERNAME}/.zshrc

	echo '' >> /home/${USERNAME}/.zshrc
	echo 'proxy_off(){' >> /home/${USERNAME}/.zshrc
	echo "	sudo sed -e '/h/ s/^#*/#/' -i /etc/environment /etc/apt/apt.conf.d/proxy.conf" >> /home/${USERNAME}/.zshrc
	echo '}' >> /home/${USERNAME}/.zshrc

	echo '' >> /home/${USERNAME}/.zshrc
fi

printf "${BLUE}"
for i in {1..4}
do
	sleep 0.1
	printf "."
done
printf "${GREEN} Done!\n${Color_Off}"
# ==================================================================================================================


# ==================================================================================================================
#               								Adding Commented Proxy
# ==================================================================================================================
echo -e ${RED}
echo "  +-----------------------------+"
echo "  | Reading Proxy Login details |"
echo "  +-----------------------------+" 
echo -e ${Color_Off}

PROXY_USER=""
PROXY_PASSWD=""

printf "  Enter proxy username: "
read -r PROXY_USER
printf "  Enter proxy password: "
read -r PROXY_PASSWD


printf "${BLUE} \n  Adding Commented Proxy to apt and /etc/environment ${Color_Off}"

sudo echo '' >> /etc/environment
sudo echo 'http_proxy="http://'${PROXY_USER}':'${PROXY_PASSWD}'@172.16.0.1:3128/"' >> /etc/environment
sudo echo 'https_proxy="http://'${PROXY_USER}':'${PROXY_PASSWD}'@172.16.0.1:3128/"' >> /etc/environment
sudo echo 'ftp_proxy="http://'${PROXY_USER}':'${PROXY_PASSWD}'@172.16.0.1:3128/"' >> /etc/environment
sudo echo 'HTTP_PROXY="http://'${PROXY_USER}':'${PROXY_PASSWD}'@172.16.0.1:3128/"' >> /etc/environment
sudo echo 'HTTPS_PROXY="http://'${PROXY_USER}':'${PROXY_PASSWD}'@172.16.0.1:3128/"' >> /etc/environment
sudo echo 'FTP_PROXY="http://'${PROXY_USER}':'${PROXY_PASSWD}'@172.16.0.1:3128/"' >> /etc/environment
sudo echo 'no_proxy=localhost,127.0.0.1,*.my.lan.domain' >> /etc/environment
sudo echo 'NO_PROXY=localhost,127.0.0.1,*.my.lan.domain' >> /etc/environment

sudo echo '' >> /etc/apt/apt.conf.d/proxy.conf
sudo echo 'Acquire::http::proxy "http://'${PROXY_USER}':'${PROXY_PASSWD}'@172.16.0.1:3128";' >> /etc/apt/apt.conf.d/proxy.conf
sudo echo 'Acquire::http::proxy "http://'${PROXY_USER}':'${PROXY_PASSWD}'@172.16.0.1:3128";' >> /etc/apt/apt.conf.d/proxy.conf
sudo echo 'Acquire::http::proxy "http://'${PROXY_USER}':'${PROXY_PASSWD}'@172.16.0.1:3128";' >> /etc/apt/apt.conf.d/proxy.conf

# =============================================
#            Checking if using WSL2
# =============================================
if uname -r | grep microsoft >> /dev/null; then
	echo "" >> /home/${USERNAME}/.curlrc
	echo 'proxy="http://'${PROXY_USER}':'${PROXY_PASSWD}'@172.16.0.1:3128/"' >> /home/${USERNAME}/.curlrc

	echo "" >> /home/${USERNAME}/.wgetrc
	echo 'http_proxy = http://'${PROXY_USER}':'${PROXY_PASSWD}'@172.16.0.1:3128/' >> /home/${USERNAME}/.wgetrc
	echo 'https_proxy = http://'${PROXY_USER}':'${PROXY_PASSWD}'@172.16.0.1:3128/' >> /home/${USERNAME}/.wgetrc
	echo 'ftp_proxy = http://'${PROXY_USER}':'${PROXY_PASSWD}'@172.16.0.1:3128/' >> /home/${USERNAME}/.wgetrc
fi
# =============================================


printf "${BLUE}"
for i in {1..4}
do
	sleep 0.1
	printf "."
done
printf "${GREEN} Done!\n${Color_Off}"
# ==================================================================================================================

echo -e ${RED}
echo "  +----------------------------------------+"
echo "  |  reboot system to apply proxy settings |"
echo "  +----------------------------------------+"
echo -e ${Color_Off}