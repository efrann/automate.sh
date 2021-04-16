#!/bin/bash

mkdir /workspaces/$1
amass enum -passive -norecursive -noalts -d $1 -config <directory>/amass-config.ini | httprobe | anew /workspaces/$1/$1-subdomains.txt
subfinder -d $1 | httprobe | anew /workspaces/$1/$1-subdomains.txt
assetfinder -subs-only $1 | httprobe | anew /workspaces/$1/$1-subdomains.txt

nuclei -l /workspaces/$1/$1-subdomains.txt -severity low,medium,high,critical -t <directory>/nuclei-templates/ -no-color -c 200 | anew /workspaces/$1/$1-nuclei.txt

dirsearch --url-list /workspaces/$1/$1-subdomains.txt -e all --wordlists <directory>/special-wordlist.txt -x 402,403,402,500,529,404 -i 200 --full-url --plain-text-report=/workspaces/$1/$1-dirsearch.txt
