# Checkpoint 1 - Wild Code School

## Partie 1 : Script bash pour proxmox

```bash
soltutions/lxc_container_create.sh
```

## Partie 2 : Gestion des utilisateurs, groupes et droits
2.1 Commandes et manipulations :

Créer l'utilisateur "wilder" sans privilèges :

```bash
useradd -m -d /home/wilder -s /bin/bash wilder
groupadd wilder
usermod -aG wilder wilder
```

Créer le répertoire /home/share et donner les droits à "wilder" :

```bash
mkdir /home/share
chmod 770 /home/share
chown :wilder /home/share
```

Créer le fichier passwords.txt accessible en lecture/écriture par "wilder" sans chown :

```bash
touch /home/share/passwords.txt
setfacl -m u:wilder:rw /home/share/passwords.txt
```

Créer le groupe "share" et ajouter les utilisateurs :

```bash
groupadd share
usermod -aG share wilder
usermod -aG share $(whoami)
```

Attribuer les permissions au groupe "share" :

```bash
chmod -R g+rw /home/share
chmod g+s /home/share
```

Chiffrer le répertoire /home/share :

```bash
apt install ecryptfs-utils
mount -t ecryptfs /home/share /home/share
```

Personnaliser la session de l'utilisateur "wilder" : Ajoute le message suivant dans /home/wilder/.bashrc :

```bash
echo "=============================" >> /home/wilder/.bashrc
echo " -- Bienvenue cher Wilder --" >> /home/wilder/.bashrc
echo "=============================" >> /home/wilder/.bashrc
echo "- Hostname............: $(hostname)" >> /home/wilder/.bashrc
echo "- Disk Space..........: $(df -h / | tail -1 | awk '{print $4}')" >> /home/wilder/.bashrc
echo "- Memory used.........: $(free -m | grep Mem | awk '{print $3 " MB"}')" >> /home/wilder/.bashrc
```

2.2 Adresse IP du conteneur

Utilise la commande suivante pour obtenir l'adresse IP du conteneur :
```bash
lxc-info -n 127 | grep "IP:"
```

