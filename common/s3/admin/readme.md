aws s3 sync . s3://<s3_bucket>/admin/ --exclude ".git/*" --exclude "*/.terraform/*" --delete

