aws s3 sync . s3://demo-infra-s3-bucket/admin/ --exclude ".git/*" --exclude "*/.terraform/*" --delete
