#!/bin/bash
set -e

echo "=== 1. Installing prerequisites ==="
apt-get update
apt-get install -y apt-transport-https ca-certificates curl gnupg

echo "=== 2. Setting up Docker GPG key and repository ==="
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu jammy stable" > /etc/apt/sources.list.d/docker.list

echo "=== 3. Installing Docker Engine ==="
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "=== 4. Starting and enabling Docker service ==="
systemctl start docker
systemctl enable docker

echo "=== 5. Downloading and Installing kubectl ==="
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/kubectl

echo "=== 6. Installing Minikube ==="
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64

echo "=== 7. Starting Minikube with Docker driver (Root Force Mode) ==="
minikube start --driver=docker --force

echo "=== Setup Complete! ==="
echo "Run 'kubectl get nodes' to verify your cluster status."
