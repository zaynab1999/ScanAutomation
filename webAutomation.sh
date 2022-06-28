#!/bin/bash
# Usage
Usage() {
    echo -e "$green
Usage: ./script.sh [-p/--program] scanweb.sh [-f/--file] targets.txt "$end
    exit 1
}
# Function
get_subdomains() {
    echo -e $red"[+]"$end $bold"Get Subdomains"$end
    folder=$program-$(date '-I')
    mkdir $folder && cd $folder   
    findomain -q -f ~/$file -r -u findomain_domains.txt
    cat ~/$file | assetfinder --subs-only >>assetfinder_domains.txt
    amass enum -df ~/$file -passive -o ammas_passive_domains.txt
    subfinder -dL ~/$file -o subfinder_domains.txt
    sort -u *_domains.txt -o subdomains.txt
    cat subdomains.txt | rev | cut -d . -f 1-3 | rev | sort -u | tee root_subdomains.txt
    cat *.txt | sort -u >domains.txt
    find . -type f -not -name 'domains.txt' -delete
}
get_alive() {
    echo -e $red"[+]"$end $bold"Get Alive"$end 
    cat domains.txt | httprobe -c 50 -t 3000 >alive.txt
    cat alive.txt
}
get_nmap() {
    echo -e $red"[+]"$end $bold"Get Nmap"$end   
    mkdir nmap
    cd nmap
    sudo cp ../alive.txt ../nmap
    sudo sed 's/.*\///' alive.txt > alive2.txt
    nmap -v -iL alive2.txt -oA test
    ~/Downloads/Tools/nmap-parse-output/./nmap-parse-output test.xml http-ports >nmap-results.txt
    awk '!seen[$0]++' nmap-results.txt >alive-final.txt
    cp alive-final.txt ../../$folder
    cd ..
}
get_paths() {
    echo -e $red"[+]"$end $bold"Get Paths"$end   
    current_path=$(pwd)
    mkdir dirsearch
    touch alive-paths.txt
    for host in $(cat alive-final.txt); do
        dirsearch_file=$(echo $host | sed -E 's/[\.|\/|:]+/_/g').txt
        python3 ~/Downloads/Tools/dirsearch/dirsearch.py -t 50 -u $host -w ~/Downloads/Tools/dirsearch/db/dicc.txt,/usr/share/wordlists/dirb/common.txt,/usr/share/wordlists/dirb/big.txt -o dirsearch/alive-paths.txt | grep Target && tput sgr0
    done
    grep -R '200' dirsearch/alive-paths.txt > dirsearch/status200.txt 2>/dev/null
    grep -R '301' dirsearch/alive-paths.txt > dirsearch/status301.txt 2>/dev/null
    grep -R '302' dirsearch/alive-paths.txt > dirsearch/status302.txt 2>/dev/null
    grep -R '400' dirsearch/alive-paths.txt > dirsearch/status400.txt 2>/dev/null
    grep -R '401' dirsearch/alive-paths.txt > dirsearch/status401.txt 2>/dev/null
    grep -R '403' dirsearch/alive-paths.txt > dirsearch/status403.txt 2>/dev/null
    grep -R '404' dirsearch/alive-paths.txt > dirsearch/status404.txt 2>/dev/null
    grep -R '405' dirsearch/alive-paths.txt > dirsearch/status405.txt 2>/dev/null
    grep -R '500' dirsearch/alive-paths.txt > dirsearch/status500.txt 2>/dev/null
    grep -R '503' dirsearch/alive-paths.txt > dirsearch/status503.txt 2>/dev/null
    find dirsearch/ -size 0 -delete
    sed -r 's/.{13}//' dirsearch/status200.txt | tee dirsearch/status200.txt
    sed -r 's/.{13}//' dirsearch/status301.txt | tee dirsearch/status301.txt
    sed -r 's/.{13}//' dirsearch/status302.txt | tee dirsearch/status302.txt
    sed -r 's/.{13}//' dirsearch/status400.txt | tee dirsearch/status400.txt
    sed -r 's/.{13}//' dirsearch/status401.txt | tee dirsearch/status401.txt
    sed -r 's/.{13}//' dirsearch/status403.txt | tee dirsearch/status403.txt
    sed -r 's/.{13}//' dirsearch/status404.txt | tee dirsearch/status404.txt
    sed -r 's/.{13}//' dirsearch/status405.txt | tee dirsearch/status405.txt
    sed -r 's/.{13}//' dirsearch/status500.txt | tee dirsearch/status500.txt
    sed -r 's/.{13}//' dirsearch/status503.txt | tee dirsearch/status503.txt
}
get_scans() {
    echo -e $red"[+]"$end $bold"Get scan Nuclei"$end   
    faraday-cli auth
    faraday-cli workspace select mainrecon
    faraday-cli nuclei -l dirsearch/status200.txt
    echo -e $red"[+]"$end $bold"Get scan OWASP ZAP"$end
mkdir zap
    i=1
    for target in $(cat dirsearch/status200.txt); do
        /usr/share/zaproxy/./zap.sh -cmd -quickurl $target -quickprogress -quickout ~/Desktop/mainRecon/$folder/zap/output$i.xml
        faraday-cli tool report ~/Desktop/mainRecon/$folder/zap/output$i.xml
        let "i+=1"
    done
    echo -e $red"[+]"$end $bold"Get scan BurpSuite"$end
    httpx -silent -no-color -http-proxy httpx://127.0.0.1:8080 -follow-redirects -l dirsearch/status200.txt
}
program=False
file=False
list=(
    get_subdomains
    get_alive
    get_nmap
    get_paths
    get_scans
)
while [ -n "$1" ]; do
    case "$1" in
    -p | --program)
        program=$2
        shift
        ;;
    -f | --file)
        file=$2
        shift  ;;
    *)
        echo -e $red"[-]"$end "Unknown Option: $1"
        Usage
        ;;
    esac
    shift
done
[[ $program == "False" ]] && [[ $file == "False" ]] && {
    echo -e $red"[-]"$end "Argument: -p/--program & -f/--file is Required"
    Usage
}
(
    get_subdomains
    get_alive
    get_nmap
    get_paths
    get_scans
    get_aquatone    
)



