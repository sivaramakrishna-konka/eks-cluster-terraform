#!/bin/bash
# REGION=ap-south-1
# NAME=dev-eks

# echo "Install required packages"
# dnf install git tmux tree -y

# echo "Installing kubectl"
# curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.32.0/2024-12-20/bin/linux/amd64/kubectl
# chmod +x kubectl
# sudo mv kubectl /usr/local/bin

# echo "Installing kubens and kubectx"
# sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
# sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
# sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens

# echo "installing k9s"
# curl -sS https://webinstall.dev/k9s | bash

# echo "Get Caller Identity"
# aws sts get-caller-identity

# echo "Update the kubeconfig"
# aws eks update-kubeconfig --region $REGION --name $NAME
#!/bin/bash
REGION=ap-south-1
NAME=dev-eks
USER_HOME=/home/ec2-user

echo "Check disk space"
df -h /

echo "Install required packages (requires sudo)"
sudo dnf install git tmux tree -y || true

echo "Installing kubectl"
if ! command -v kubectl &> /dev/null; then
    curl -sS -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.32.0/2024-12-20/bin/linux/amd64/kubectl
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/
fi

echo "Installing kubens and kubectx"
if [ ! -d /opt/kubectx ]; then
    sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
    sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
    sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens
    sudo chmod -R +x /opt/kubectx
    sudo chown -R ec2-user:ec2-user /opt/kubectx
fi

echo "Installing k9s"
# Create and set permissions for ec2-user's .local/bin
sudo mkdir -p ${USER_HOME}/.local/bin
sudo chown ec2-user:ec2-user ${USER_HOME}/.local ${USER_HOME}/.local/bin
sudo chmod 755 ${USER_HOME}/.local ${USER_HOME}/.local/bin
# Try webinstall.dev with retries
if [ ! -f ${USER_HOME}/.local/bin/k9s ]; then
    for i in {1..3}; do
        echo "Attempt $i to install k9s via webinstall.dev"
        sudo -u ec2-user bash -c "curl -sS https://webinstall.dev/k9s | bash" && break
        sleep 5
    done
    # Fallback to direct GitHub download if webinstall fails
    if [ ! -f ${USER_HOME}/.local/bin/k9s ]; then
        echo "Falling back to direct k9s download"
        sudo -u ec2-user bash -c "curl -sSL https://github.com/derailed/k9s/releases/download/v0.32.5/k9s_Linux_amd64.tar.gz | tar -xz -C ${USER_HOME}/.local/bin k9s"
        sudo chmod +x ${USER_HOME}/.local/bin/k9s
    fi
fi

echo "Ensure .local/bin is in PATH"
if ! grep -q "${USER_HOME}/.local/bin" ${USER_HOME}/.bashrc; then
    echo "export PATH=\${PATH}:${USER_HOME}/.local/bin" >> ${USER_HOME}/.bashrc
fi

echo "Add alias k='kubectl'"
if ! grep -q "alias k='kubectl'" ${USER_HOME}/.bashrc; then
    echo "alias k='kubectl'" >> ${USER_HOME}/.bashrc
fi

echo "Get Caller Identity"
aws sts get-caller-identity

echo "Update the kubeconfig for ec2-user"
sudo mkdir -p ${USER_HOME}/.kube
sudo chown ec2-user:ec2-user ${USER_HOME}/.kube
aws eks update-kubeconfig --region $REGION --name $NAME --kubeconfig ${USER_HOME}/.kube/config
sudo chown ec2-user:ec2-user ${USER_HOME}/.kube/config
sudo chmod 600 ${USER_HOME}/.kube/config

echo "Setup complete for ec2-user!"