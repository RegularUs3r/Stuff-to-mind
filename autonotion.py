from selenium import webdriver
from selenium.webdriver.firefox.options import Options
from selenium.webdriver.firefox.service import Service
from webdriver_manager.firefox import GeckoDriverManager
from selenium.common.exceptions import WebDriverException
from selenium import webdriver
from urllib3 import disable_warnings
from warnings import filterwarnings
from time import sleep
import requests
import argparse
import pandas as pd


notion_page_id = []
intel_list = []
for_comparision = []
uniqs_for_notion = []

def initialize():
     filterwarnings("ignore", category=DeprecationWarning)
     disable_warnings()
     auth = "<INTEGRATION-SECRET-KEY>"
     b_url = "https://api.notion.com"

     parser = argparse.ArgumentParser()
     parser.add_argument("-t", "--target-list", dest="target_list", metavar="", required=True)
     parser.add_argument("-db", "--db-id", dest="db_id", metavar="", required=True, help="DB-ID like => d0a4c82704a444bab884a14e3088ade4")
     parser.add_argument("-x", "--proxy", metavar="")
     parser.add_argument("-o", "--output-dir", dest="output_dir", metavar="", required=True, help="Full system path between quotes")
     parser.add_argument("-ng", "--ngrok-server", dest="ngrok_server", metavar="", required=True, help="Ngrok server like 2d5e-138-59-121-19.ngrok-free.app")
     args = parser.parse_args()
     target_list = args.target_list
     db_id = args.db_id
     proxy = args.proxy
     output_dir = args.output_dir
     ngrok_server = args.ngrok_server
     
     
     
     
     
     df = pd.read_excel(target_list, usecols=['IFA', 'FQDN', 'Company', 'IP'])
     for columsn, rows in df.iterrows():
          for_comparision.append(rows.to_list())
          if "mobile" in str(rows.to_list()[0]) or "MOBILE" in str(rows.to_list()[0]):
               pass
          else:
               if rows.to_list()[1] not in uniqs_for_notion:
                    uniqs_for_notion.append(rows.to_list()[2])
     if proxy:
          proxy = {"https": proxy}
     else:
          proxy = None

     headers = {"Authorization": "Bearer " + auth, "Content-Type": "application/json", "Notion-Version": "2022-06-28"}
     create_entries(db_id, headers, proxy, b_url, output_dir, ngrok_server)




def create_entries(db_id, headers, proxy, b_url, output_dir, ngrok_server):
     #data = {"properties":{"Name":{"name":"Target"}}}
     data = {"properties":{"Name":{"name":"Target"},"IFA":{"rich_text":{}},"Company":{"rich_text":{}},"Status":{"rich_text":{}} ,"Priority":{"rich_text":{}} ,"Observation":{"rich_text":{}} ,"FQDN":{"rich_text":{}} ,"IP":{"rich_text":{}} ,"Test Results":{"rich_text":{}} ,"Analyst Database":{"rich_text":{}}}}
     re = requests.patch(b_url+"/v1/databases/"+db_id, headers=headers, json=data, verify=False, proxies=proxy)
     for data in uniqs_for_notion:
          data={"parent": {"database_id": f"{db_id}"}, "properties": {"Target": {"title": [{"text": {"content": f"{data}"}}]}}}
          re = requests.post(b_url+"/v1/pages", headers=headers, json=data, verify=False, proxies=proxy)
     foothold_targets(db_id, headers, proxy, b_url, output_dir, ngrok_server)


def foothold_targets(db_id, headers, proxy, b_url, output_dir, ngrok_server):
     data = {"page_size":500}
     re = requests.post(b_url+f"/v1/databases/{db_id}/query", json=data, headers=headers, verify=False, proxies=proxy).json()
     for _ in re['results']:
          page_id = _['id']
          target = _['properties']['Target']['title'][0]['text']['content']
          intel= f"{page_id}*{target}"
          intel_list.append(intel)
     options = Options()
     options.add_argument("--headless")
     service = Service(executable_path=GeckoDriverManager().install())
     bot = webdriver.Firefox(service=service, options=options)
     for stuff in intel_list:
          page_id, target = stuff.split("*")
          parsed_name = target.replace(".","-")
          try:
               try:
                    bot.get(f"http://{target}")
                    sleep(3) 
                    bot.save_screenshot(f"{output_dir}{parsed_name}.png")
               except:
                    bot.get(f"https://{target}")
                    sleep(3) 
                    bot.save_screenshot(f"{output_dir}{parsed_name}.png")
          except WebDriverException:
               bot.save_screenshot(f"{output_dir}{parsed_name}.png")
          if page_id in stuff:
               data = {"children":[{"object":"block","type":"image","image":{"type":"external","external":{"url":f"https://{ngrok_server}/{parsed_name}.png"}}}]}
               re = requests.patch(b_url+f"/v1/blocks/{page_id}/children", json=data, headers=headers, verify=False, proxies=proxy)
          for more in for_comparision:
               if str(target) in str(more):
                    ifa = str(more[0]) 
                    ip = str(more[1])
                    fqdn = str(more[2])
                    company = str(more[3])
                    data = {"properties":{"IFA":{"rich_text":[{"type":"text","text":{"content":f"{ifa}","link":None},"annotations":{"bold":False,"italic":False,"strikethrough":False,"underline":False,"code":False,"color":"default"}}]},"Company":{"rich_text":[{"type":"text","text":{"content":f"{company}","link":None},"annotations":{"bold":False,"italic":False,"strikethrough":False,"underline":False,"code":False,"color":"default"}}]},"IP":{"rich_text":[{"type":"text","text":{"content":f"{ip}","link":None},"annotations":{"bold":False,"italic":False,"strikethrough":False,"underline":False,"code":False,"color":"default"}}]},"FQDN":{"rich_text":[{"type":"text","text":{"content":f"{fqdn}","link":None},"annotations":{"bold":False,"italic":False,"strikethrough":False,"underline":False,"code":False,"color":"default"}}]}}}
                    re = requests.patch(b_url+"/v1/pages/"+page_id, json=data, headers=headers, verify=False, proxies=proxy)



initialize()  



