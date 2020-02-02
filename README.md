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
- prod : créer un alias dns www.domain au lieu de www-prd.domain
- notifications SNS
- reprendre la grosse image et redéfinir ce que l'on souhaite exactement :
  * webserver : pas de mise à jour DNS
  * pas besoin de nom DNS depuis le vpc
