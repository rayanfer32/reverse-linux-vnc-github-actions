
#!/bin/bash
# install rustdesk
wget https://github.com/rustdesk/rustdesk/releases/download/1.4.4/rustdesk-1.4.4-x86_64.deb
sudo apt install -fy ./rustdesk*.deb
sudo rustdesk --password $VNC_PASSWORD@rust69
# sudo systemctl start rustdesk
rustdesk --get-id
nohup rustdesk &
sleep 10s