#/bin/bash
buckets="private classified covert underground sensitive confidential special hidden obscure invisible"

for buck in $buckets; do
    echo $buck
    aws s3 ls --profile fpasswd s3://$buck.metropolistransit
    aws s3 ls --profile fpasswd s3://metropolistransit.$buck
    aws s3 ls --no-sign-request s3://$buck.metropolistransit
    aws s3 ls --no-sign-request s3://metropolistransit.$buck
done
