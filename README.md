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

## Partie 3 : Sécurité du conteneur et durcissement SSH
3.1 Manipulations :

Modifier le port SSH :

Édite /etc/ssh/sshd_config :
```bash
sed -i 's/#Port 22/Port 2222/' /etc/ssh/sshd_config
systemctl restart sshd
```

Bloquer tous les ports à l’aide d’un pare-feu logiciel (UFW) :

```bash
ufw default deny incoming
ufw allow 2222/tcp
ufw enable
```

3.2 Autre moyen d’augmenter la sécurité :

Utiliser une authentification par clés SSH au lieu de mots de passe.
## Partie 4 : Scripting Bash
4.1 Script Bash pour connexion SSH :
```bash
#!/bin/bash
ssh -p 2222 wilder@<IP_du_conteneur>
```

4.2 Analyse du script CPU :
Ce que fait le script :

Vérifie si l'utilisation CPU dépasse un seuil (95%).
Si oui, envoie un email à une adresse spécifique.
Code :

```bash
MAX=95
EMAIL=wilder@email.sh
USE=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage ""}')
if [ $USE -gt $MAX ]; then
  echo "Percent used: $USE" | mail -s "Running out of CPU power" $EMAIL
fi
```

4.3 Wilder peut-il installer des paquets comme Apache ou Nginx ?

Non. L'utilisateur "wilder" n'a pas les droits super utilisateur (sudo) nécessaires pour installer des paquets.

## Partie 5 : Questions théoriques

Infrastructure as Code (IaC) : Gestion des infrastructures à l'aide de fichiers de configuration.

Docker est-il une nécessité ? : Non, mais il est très utile pour les conteneurs légers et reproductibles.

Pipeline CI/CD : Ensemble automatisé de processus pour l'intégration et le déploiement continus.

Outil pour gérer des configurations à distance : Ansible.

Scalabilité : Capacité d'une infrastructure à s'adapter aux variations de charge.

Rôle principal d’un DevOps : Automatiser, déployer et surveiller les infrastructures.

Plateforme pour pipelines CI/CD : GitLab CI/CD, Jenkins.

Environnements avant production : Développement, intégration, test.

Intégration continue (CI) : Test et validation automatique de chaque modification de code.

Provisionning : Déploiement automatisé de ressources.


