#/bin/bash
buckets="private classified covert underground sensitive confidential special hidden obscure invisible"

for buck in $buckets; do
    aws s3 ls --profile fpasswd s3://$buck.metropolistransit 2>tmp.txt
    if [ "$?" == "0" ]; then
        echo "[+] Found $buck.metropolistransit - authenticated"
    fi
    cat tmp.txt | grep "AccessDenied" >/dev/null 2>&1 && echo "[+] Found $buck.metropolistransit - authenticated"

    aws s3 ls --profile fpasswd s3://metropolistransit.$buck 2>tmp.txt
    if [ "$?" == "0" ]; then
        echo "[+] Found metropolistransit.$buck - authenticated"
    fi
    cat tmp.txt | grep "AccessDenied" >/dev/null 2>&1 && echo "[+] Found metropolistransit.$buck - authenticated"

    aws s3 ls --no-sign-request s3://$buck.metropolistransit 2>tmp.txt
     if [ "$?" == "0" ]; then
        echo "[+] Found $buck.metropolistransit - unauthenticated"
    fi
    cat tmp.txt | grep "AccessDenied" >/dev/null 2>&1 && echo "[+] Found $buck.metropolistransit - unauthenticated"

    aws s3 ls --no-sign-request s3://metropolistransit.$buck 2>tmp.txt
    if [ "$?" == "0" ]; then
        echo "[+] Found metropolistransit.$buck - unauthenticated"
    fi
    cat tmp.txt | grep "AccessDenied" >/dev/null 2>&1 && echo "[+] Found metropolistransit.$buck - unauthenticated"


done

rm tmp.txt
