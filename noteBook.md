# ubuntu installation block, and remove the rubbish
> example for apt install maven, but report error on 'The package mysql-community-server-core-dbgsym needs to be reinstalled, but I can't find an archive for it.'
```
dpkt --audit
dpkg --remove --force-remove-reinstreq mysql-community-server-core-dbgsym
apt autoremove
apt autoclean
apt update
apt --fix-broken install

now apt install maven is ok
```

# install docker in ubuntu system
1. Update the package index:
```
apt update
apt install -y apt-transport-https ca-certificates curl software-properties-common
```
2. Add Docker's official GPG key and repository:
```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```
3. install docker
```
sudo apt update
sudo apt install -y docker.io
docker --version
```
## in China, google is blocked. we need change APT source,
> add china mirror
```
insert following lines at front line of /etc/apt/sources.list

deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-security main restricted universe multiverse
```
> update apt
```
apt update
apt upgrade -y
```

# Pull an All-in-One Kubernetes Image
> all in one
```
docker pull alpine/k8s
```
>
>>  for China
```
docker pull registry.cn-hangzhou.aliyuncs.com/rancher/k3s
```
>>
> launch docer
```
docker run --rm -d \
  --privileged \
  --name k8s-all-in-one \
  -p 6443:6443 \
  -p 80:80 \
  -p 443:443 \
  rancher/k3s

docker ps   ##check running container
```

