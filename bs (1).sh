#!/bin/bash
faraday-cli workspace create alpha
faraday-cli workspace select alpha
for line in $(cat /home/kali/Desktop/target.txt); do
	faraday-cli nuclei -u $line 
done  
echo -e $red"[+]"$end $bold"Done! check faraday at http://localhost:5985/#/workspaces "$end
             
