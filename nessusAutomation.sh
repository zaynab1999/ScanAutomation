from webdriver_manager.chrome import ChromeDriverManager
from selenium import webdriver
from selenium.webdriver.common.by import By
import time
import os
import sys

Directory = "/home/kali/Desktop/scan-output/"
filename = "alive.txt"
f = os.path.join(Directory, filename)
file2 = open(f, 'r')
Lines = file2.readlines()
#with open("/home/kali/Desktop/" + name + "/alive.txt ", "r") as f:	
targets = f.readlines()
driver = webdriver.Chrome(ChromeDriverManager().install())
#driver.quit()
driver.maximize_window()
driver.implicitly_wait(180000)
url = "https://kali:8834/#/"
name ="scan"
driver.get(url)
driver.find_element(By.XPATH,"//*[@id=\"details-button\"]").click()
driver.find_element(By.XPATH,"//*[@id=\"proceed-link\"]").click()
driver.find_element(By.XPATH,"/html/body/div/form/div[1]/input").click()
driver.find_element(By.XPATH,"/html/body/div/form/div[1]/input").send_keys("nessus")
driver.find_element(By.XPATH,"/html/body/div/form/div[2]/input").click()
driver.find_element(By.XPATH,"/html/body/div/form/div[2]/input").send_keys("nessus")
driver.find_element(By.XPATH,"/html/body/div/form/button").click()
driver.find_element(By.XPATH,"//*[@id=\"titlebar\"]/a[1]/i").click()
driver.find_element(By.XPATH,"//*[@id=\"content\"]/section/div[1]/div[2]/div[2]/a[2]/i").click()
driver.find_element(By.XPATH,"//*[@id=\"editor-tab-view\"]/div/div[1]/section/div[1]/div[1]/div[1]/div[1]/div/input").click()
driver.find_element(By.XPATH,"//*[@id=\"editor-tab-view\"]/div/div[1]/section/div[1]/div[1]/div[1]/div[1]/div/input").send_keys(name)
driver.find_element(By.XPATH,"//*[@id=\"editor-tab-view\"]/div/div[1]/section/div[1]/div[1]/div[1]/div[5]/div/textarea").send_keys(Lines)
driver.find_element(By.XPATH,"//*[@id=\"editor-tab-view\"]/div/aside/ul/li[2]/span").click()
driver.find_element(By.XPATH,"//*[@id=\"editor-tab-view\"]/div/aside/ul/li[2]/ul/li[2]").click()
driver.find_element(By.XPATH,"//*[@id=\"editor-tab-view\"]/div/div[1]/section/div[5]/div[1]/div[1]/div[2]/div/input").clear()
driver.find_element(By.XPATH,"//*[@id=\"editor-tab-view\"]/div/div[1]/section/div[5]/div[1]/div[1]/div[2]/div/input").send_keys("1-65535")
driver.find_element(By.XPATH,"//*[@id=\"content\"]/section/form/div[2]/span").click()
driver.find_element(By.XPATH,"//*[@id=\"DataTables_Table_0\"]/tbody/tr/td[9]/i").click()
time.sleep(5)
driver.find_element(By.XPATH,"//*[@id=\"DataTables_Table_0\"]/tbody/tr/td[3]").click()
driver.find_element(By.XPATH,"//*[@id=\"export\"]/span").click()
driver.find_element(By.XPATH,"//*[@id=\"export\"]/ul/li[2]").click()
driver.find_element(By.XPATH,"//*[@id=\"modal-inside\"]/div[1]/div[2]/div[1]/input").send_keys("nessus")
driver.find_element(By.XPATH,"//*[@id=\"export-save\"]").click()
