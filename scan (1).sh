#!/bin/bash

#Banner
sudo figlet ocdNetScan
sudo /bin/systemctl start nessusd.service
#######################################################################################################
################################### Alive Hosts #######################################################
echo "Enter Password : "
read -s password
read -p "Enter Project name  : " project
faraday-cli workspace create $project
faraday-cli workspace select $project
echo -e $red"[+]"$end $bold"Getting alive hosts"$end
cd /home/kali/Desktop/
mkdir scan-output
cd scan-output
nmap -sP $1 | awk '/is up/ {print up}; {gsub (/\(|\)/,""); up = $NF}' | tee alive.txt > /dev/null 2>&1
echo -e $green"[+]"$end $bold"Alive hosts are available in alive.txt"$end

########################################################################################################
################################### Nessus Scan ########################################################  
python3 /home/kali/Desktop/Nessus.py & > /dev/null 2>&1
echo -e $red"[+]"$end $bold"Scan finished!"$end


#######################################################################################################
################################### Nmap Scripts ######################################################
#echo -e $red"[+]"$end $bold"Running Nmap Scripts..."$end
#sudo nmap -sV --script=vuln -iL /home/kali/Desktop/scan-output/alive.txt | tee nmap_vuln_scan.txt > /dev/null 2>&1
#echo -e $green"[+]"$end $bold"Done! check nmap_vuln_scan.txt"

#######################################################################################################
################################### Full port scan ####################################################
mkdir /home/kali/Desktop/scan-output/Alive_full_port_scan
mkdir /home/kali/Desktop/scan-output/open_ports
echo -e $red"[+]"$end $bold"Running a full port scan"$end
for i in $( cat /home/kali/Desktop/scan-output/alive.txt ); do
	sudo  nmap -sS -p- $i | tee /home/kali/Desktop/scan-output/Alive_full_port_scan/$i > /dev/null 2>&1
	grep "open" /home/kali/Desktop/scan-output/Alive_full_port_scan/$i >> /home/kali/Desktop/scan-output/open_ports/$i
done
echo -e $red"[+]"$end $bold"Done! check open-ports directory!"$end

#######################################################################################################
################################### Nuclei Scan #######################################################
sleep 5
touch /home/kali/Desktop/scan-output/nuclei-targets.txt
echo -e $red"[+]"$end $bold"Nuclei scan..."$end
sudo python3 /home/kali/Desktop/nuclei-targets.py
for line in $(cat /home/kali/Desktop/scan-output/nuclei-targets.txt); do
	faraday-cli nuclei -u $line > /dev/null 2>&1
done  
echo -e $red"[+]"$end $bold"Done! check faraday at http://localhost:5985/#/workspaces "$end
             











      