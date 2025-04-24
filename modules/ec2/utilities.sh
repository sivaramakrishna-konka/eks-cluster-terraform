#!/bin/bash

echo "Install required packages"
dnf install git tmux tree -y

echo "Installing kubectl"
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.32.0/2024-12-20/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin

echo "Installing kubens and kubectx"
sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens

echo "installing k9s"
curl -sS https://webinstall.dev/k9s | bash