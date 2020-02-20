aws s3 sync . s3://<s3_buket>/webservers/ --exclude ".git/*" --exclude "*/.terraform/*" --delete

