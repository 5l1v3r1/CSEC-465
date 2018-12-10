from __future__ import print_function
import requests

WORDLIST = ["private", "classified", "covert", "underground", "sensitive", "confidential", "special", "hidden", "obscure", "invisible"]

URL1 = "http://{}.metropolistransit.s3.amazonaws.com"
URL2 = "http://metropolistransit.{}.s3.amazonaws.com"
NOTEXIST = "The specified bucket does not exist"
FOUND = "[+] Found {}"

def main():
    for w in WORDLIST:
        print("{}.metropolistransit".format(w))
        print("metropolistransit.{}".format(w))
        r = requests.get(URL1.format(w))
        if NOTEXIST not in r.text:
            print(FOUND.format(URL1.format(w)))
        r = requests.get(URL2.format(w))
        if NOTEXIST not in r.text:
            print(FOUND.format(URL2.format(w)))

if __name__ == '__main__':
    main()
