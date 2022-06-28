import os
Directory = "/home/kali/Desktop/scan-output/open_ports/"
for filename in os.listdir(Directory):
    f = os.path.join(Directory, filename)
    file2 = open(f, 'r')
    Lines = file2.readlines()
    text = ""
    for line in Lines:
        line = line.removesuffix("\n")
        if line[-4:] == "http":
            text += "http://" + \
                Directory.split("/")[-1]+ filename +":"+(line.split("/"))[0]+("\n")
            file1 = open(r"/home/kali/Desktop/scan-output/nuclei-targets.txt", 'a')
            file1.writelines(text)
            file1.close()
        elif line[-5:] == "https":
            text += "https://" + \
                Directory.split("/")[-1]+filename+":"+(line.split("/"))[0]+("\n")
            file1 = open(r"/home/kali/Desktop/scan-output/nuclei-targets.txt", 'a')
            file1.writelines(text)
            file1.close()









      
