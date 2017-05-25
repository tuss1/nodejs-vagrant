#!/usr/bin/env bash
# Options
packages=$(echo "$1")
npmsave=$(echo "$2")
npmsavedev=$(echo "$3")
swapsize=$(echo "$4")
timezone=$(echo "$5")
domain=$(echo "$6")
name=$(echo "$6")

# System configuration
if ! grep --quiet "swapfile" /etc/fstab; then
  fallocate -l ${swapsize}M /swapfile
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  echo '/swapfile none swap defaults 0 0' >> /etc/fstab
fi

# Configuring timezone
echo ${timezone} | sudo tee /etc/timezone
sudo dpkg-reconfigure --frontend noninteractive tzdata

# Configuring server software
sudo update-locale LC_ALL="C"
sudo dpkg-reconfigure locales

sudo apt-get update
#sudo apt-get upgrade -y
sudo apt-get install -y ${packages}

# install nodejs
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - && sudo apt-get install -y nodejs

#inits npm
mkdir /var/www/project
cd /var/www/project
npm -y init

# install npm packages
npm install --save --no-bin-links ${npmsave}
npm install --save-dev --no-bin-links ${npmsavedev}

# create nginx config
if [ ! -f /etc/nginx/sites-enabled/${domain} ]; then
    cp /var/www/vhost.conf.dist /var/www/vhost.conf
    sudo ln -s /var/www/vhost.conf /etc/nginx/sites-enabled/${domain}
fi

# Configuring application
sudo service nginx restart
