# terraform
terraform code that provides a VPC and an auto scaling group for a simple web site

## La 'big picture'
Dans un VPC dédié à l'environnement qui nous intéresse (DEV|TST|ACC|PRD), nous avons créé :

- une instance EC2 dédiée à l'administration :
  - disposant d'accès sans restriction sur les services AWS (policy 'Administrator Access');
  - accessible en SSH uniquement depuis l'adresse IP que nous utilisons pour accéder à internet;
  - qu'il vaut mieux éteindre lorsque nous ne l'utilisons pas.
 
 ### Copie du code Ansible nécessaire à l'installation des webservers dans le bucket S3

    cd ~/Documents/dev/github/
    if [ ! -d code-as-code ]; then
      git clone https://github.com/papaFrancky/code-as-code.git
    fi
    cd code-as-code
    aws s3 sync . s3://demo-infra-s3-bucket/webservers/ --exclude ".git/*" --exclude "*/.terraform/*" --delete


## TODO

- readme (pas complet du tout)
- [WIP] prod : créer un alias dns www.domain au lieu de www-prd.domain
- notifications SNS
- reprendre la grosse image et redéfinir ce que l'on souhaite exactement :
  * [WIP] webserver : pas de mise à jour DNS
  * [WIP] pas besoin de nom DNS depuis le vpc
- proposer le type d'instance pour les webservers au niveau des environnements de développement et non donner une valeur par défaut au niveau du module.
- tests de charge : hey -n 1000 -c 200 -z 10m  -m GET https://www-dev.codeascode.net/



04/02/2020

  - Sans IP publique dans le subnet public, les instances webservers ne communiquent pas avec l'extérieur. 
    Tenter de les démarrer sur le subnet privé.
  
  - la destruction du load-balancer se traduit toujours par 300s d'attente avant de détruire les instances de l'auto-scaling.
    Comment changer cela ?

