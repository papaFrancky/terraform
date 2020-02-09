# terraform

## Introduction

Source: https://github.com/papaFrancky/terraform.git

Ce repository tire son nom de l'outil d'Infrastructure As Code (IAC) développé par la société [HashiCorp](https://www.hashicorp.com/): [terraform](https://www.terraform.io/).

Le présent code permet pour l'environnement (\<env\>) [DEV|TST|ACC|PRD] choisi la création :
* d'un VPC nommé \<env\>;
* d'une instance EC2 dédiée à l'administration et utilisée comme un 'Jump Host';
* d'un Load-Balancer Applicatif (ALB);
* d'un Auto Scaling Group (ASG) permettant le déploiement de serveurs web.



## La 'big picture'

![big picture](presentation/images/terraform.alb-asg.png)
Dans un VPC dédié à l'environnement qui nous intéresse (DEV|TST|ACC|PRD), nous avons créé :

### Le VPC

Un VPC sera créé pour chacun des environnements suivants:
Environnement|Développement|Tests|Acceptance|Production
---|---|---|---|---
\<env\>|dev|tst|acc|prd

Chaque VPC sera constitué de 2 subnets de types public et privé, tous 2 répartis sur les 3 Availability Zones (AZ) que compte la région Paris :
* Public subnet : nous créerons donc 3 subnets (un par AZ) avec des plages d'adresses IP qui ne se recouvrent pas et dont la table de routage aura pour passerelle par défaut une 'Internet Gateway' (internet facing);
* Private subnet : à l'instar du 'public subnet', il comptera lui aussi 3 subnets répartis chacun sur une AZ distincte et avec des plages d'adresses IP distinctes. La différence réside dans le fait que la passerelle par défaut de leur table de routage respective sera une NAT gateway qui leur sera propre.

Veuillez noter que la création du subnet de type privé est optionnelle dnas la mesure où elle a pour but d'héberger les middlewares et/ou backends ne devant pas être exposés directement à internet (comme les bases de données par exemple). Notre code se contente ici de déployer des instances dans le subnet public aussi pouvons-nous nous en passer, ce qui est préférable car les NAT gateways ont un coût non négligeable.

Si vous souhaitez créer le subnet privé, il vous suffit de renommer le fichier *'modules/vpc/private-subnet.tf.disabled'* en *'modules/vpc/private-subnet.tf'*.

vpc|region|availability zone|subnet type|subnet|cidr|gateway|internet facing
---|---|---|---|---|---|---|---
\<env\>|eu-west-3|eu-west-3a|public|\<env\>-public-eu-west-3a|10.0.101.0/24|\<env\>|yes
\<env\>|eu-west-3|eu-west-3b|public|\<env\>-public-eu-west-3b|10.0.102.0/24|\<env\>|yes
\<env\>|eu-west-3|eu-west-3c|public|\<env\>-public-eu-west-3c|10.0.103.0/24|\<env\>|yes
\<env\>|eu-west-3|eu-west-3a|private|\<env\>-private-eu-west-3a|10.0.201.0/24|\<env\>-eu-west-3a|no
\<env\>|eu-west-3|eu-west-3b|private|\<env\>-private-eu-west-3b|10.0.202.0/24|\<env\>-eu-west-3b|no
\<env\>|eu-west-3|eu-west-3c|private|\<env\>-private-eu-west-3c|10.0.203.0/24|\<env\>-eu-west-3c|no

 


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

# DEMO SCALING UP et SCALING DOWN
Se loguer sur les instances dev-webservers et lancer un

    yes > /dev/null &
    top
Faire monter la CPU sur les 2 instances jusqu'à déclencher l'alarme.
