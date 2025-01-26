#ubuntu installation block, and remove the rubbish
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
