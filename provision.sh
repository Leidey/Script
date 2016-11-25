#!/bin/bash

echo "****** Provisioning virtual machine... ******"

echo "****** Installing Nginx and Python Dependencies ******"

cd /vagrant

sudo apt-get install -y python-software-properties
sudo add-apt-repository ppa:nginx/stable
echo "****** Updating******"
sudo apt-get update -y
echo "****** Ending update ******"
sudo apt-get install -y python3-pip python3-dev
echo "****** Installing Nginx ******"
sudo apt-get install -y nginx

echo "****** Nginx Status ******"
service nginx status

echo "****** Logging Virtual Environment ******"

cd 
cd /vagrant/MyFlaskApp
source myflaskappenv/bin/activate

echo "****** Installing Pip, Gunicorn and Python Dependencies ******"
sudo apt-get install -y python-pip
sudo pip install flask gunicorn
sudo ufw allow 5000
#python MyFlaskApp.py &
#gunicorn --bind 0.0.0.0:5000 wsgi:app

echo "****** Deactivating Virtual Environment ******"
deactivate

cd****** Installing Pip, Gunicorn and Python Dependencies ******


echo "****** Creating Systemd Unit File: MyFlaskApp.service ******"
sudo apt-get install -y systemd-services

cat << EOF | sudo tee /etc/systemd/system/MyFlaskApp.service

[Unit]
Description=Gunicorn instance to serve MyFlaskApp
After=network.target

[Service]
User=vngrs
Group=www-data
WorkingDirectory=/home/vngrs/vagrant/MyFlaskApp
Environment="PATH=/home/vngrs/vagrant/MyFlaskApp/myflaskappenv/bin"
ExecStart=/home/vngrs/vagrant/MyFlaskApp/myflaskappenv/bin/gunicorn --workers 3 --bind unix:MyFlaskApp.sock -m 007 wsgi:app

[Install]
WantedBy=multi-user.target
EOF


echo "****** Start and Enable Systemctl ******"
sudo systemctl start MyFlaskApp
sudo systemctl enable MyFlaskApp

echo "****** Creating File in Nginx Sites-available ******"
cat << EOF | sudo tee /etc/nginx/sites-available/MyFlaskApp

server {
	listen 8080;
	server_name _;

	location / {
		include proxy_params;
		proxy_pass http://127.0.0.1:5000;
	}
}
EOF

echo "****** Copying File from Sites-available to Sites-enabled ******"
sudo ln -sf /etc/nginx/sites-available/MyFlaskApp /etc/nginx/sites-enabled/

cd
cd /etc/nginx

echo "****** Test Nginx ******"
sudo nginx -t
sudo systemctl restart nginx
sudo ufw delete allow 5000
sudo ufw allow 'Nginx Full'

echo "****** Completed provisioning virtual machine! ******"

#cd 
#cd /vagrant/MyFlaskApp
#python MyFlaskApp.py &


cd 
cd /vagrant/MyFlaskApp
source myflaskappenv/bin/activate

gunicorn --bind 0.0.0.0:5000 wsgi:app





