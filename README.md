# terraform
terraform code that provides a VPC and an auto scaling group for a simple web site


### Copie du code Ansible nécessaire à l'installation des webservers dans le bucket S3

    cd ~/Documents/dev/github/
    if [ ! -d code-as-code ]; then
      git clone https://github.com/papaFrancky/code-as-code.git
    fi
    cd code-as-code
    aws s3 sync . s3://demo-infra-s3-bucket/webservers/ --exclude ".git/*" --exclude "*/.terraform/*" --delete



## TODO

- readme (pas complet du tout)
- page html : renvoie dans l'onglet l'ip du serveur. devrait renvoyer www-{env}
- prod : créer un alias dns www.domain au lieu de www-prd.domain
- load-balancer : passer à un mode plus récent
- https
