# terraform
terraform code that provides a VPC and an auto scaling group for a simple web site

## La 'big picture'
Dans un VPC dédié à l'environnement qui nous intéresse (DEV|TST|ACC|PRD), nous avons créé :

- une instance EC2 dédiée à l'administration :
  - disposant d'accès sans restriction sur les services AWS (policy 'Administrator Access');
  - accessible en SSH uniquement depuis l'adresse IP que nous utilisons pour accéder à internet;
  - qu'il vaut mieux éteindre lorsque nous ne l'utilisons pas.

- Décrire l'ELB
  - les diffrnets load-balancers proposés par AWS
  - Décrire l'ALB : notions de 'listeners' et de 'target groups' (reprendre le schéma de la page AWS)
  - Le certificat TLS est porté par l'ALB -> mentionner le service Certificate Manager

- l'instance d'admin est importante car nous restreignons l'accès SSH des webservers à cette instance.
  Donc il faut la créer avant l'auto scaling group.
  Ce qui n'empêche pas de l'éteindre si nous n'en avons pas besoin.

## prerequis

### topics SNS
- codeascode-<env>

 ### Copie du code Ansible nécessaire à l'installation des webservers dans le bucket S3

    cd ~/Documents/dev/github/
    if [ ! -d code-as-code ]; then
      git clone https://github.com/papaFrancky/code-as-code.git
    fi
    cd code-as-code
    aws s3 sync . s3://demo-infra-s3-bucket/webservers/ --exclude ".git/*" --exclude "*/.terraform/*" --delete


## TODO

- readme (pas complet du tout)
- [WIP] notifications SNS
- reprendre la grosse image et redéfinir ce que l'on souhaite exactement :
- tests de charge : hey -n 1000 -c 200 -z 10m  -m GET https://www-dev.codeascode.net/


# SIEGE
sudo rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
sudo yum install siege
siege -b -c 150 https://dev.codeascode.net/phpinfo.php
