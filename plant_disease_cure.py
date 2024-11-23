import requests
from bs4 import BeautifulSoup
import json

# URL to scrape
url = "https://agritech.tnau.ac.in/org_farm/orgfarm_hortidiseases.html"

# Fetch the HTML content
response = requests.get(url)
soup = BeautifulSoup(response.content, 'html.parser')

# Initialize a list to hold disease data
disease_data = []

# Find all the disease sections (each section starts with a <strong> tag)
plant_sections = soup.find_all('p',align='left')
print(plant_sections[0])

count=1
for section in plant_sections:
    if 'Diseases' in section.get_text():
        print(str(count)+":",section)
        count+=1

""" one=False
for section in disease_sections:
    disease_name = section.text.strip()  # Disease name
    disease_info = {}  # Dictionary to hold details for the current disease

    
    if(not one):
        print("disease",disease_name)
        one=True

    # Get the symptoms
    symptoms = section.find_next('p').find_next('div').find('ul')
    if symptoms:
        disease_info['symptoms'] = [li.text.strip() for li in symptoms.find_all('li')]
    
    # Get the mode of spread and survival
    mode_of_spread = symptoms.find_next('p', string='Mode  of spread and survival')
    if mode_of_spread:
        spread_list = mode_of_spread.find_next('div').find('ul')
        if spread_list:
            disease_info['mode_of_spread'] = [li.text.strip() for li in spread_list.find_all('li')]
    
    # Get the management practices
    management = mode_of_spread.find_next('p', string='Management')
    if management:
        management_list = management.find_next('div').find('ul')
        if management_list:
            disease_info['management'] = [li.text.strip() for li in management_list.find_all('li')]
    
    # Add the disease info to the list
    disease_data.append({
        'disease_name': disease_name,
        'details': disease_info
    })

# Save the extracted data to a JSON file
with open('apple_diseases.json', 'w') as json_file:
    json.dump(disease_data, json_file, indent=4)

print("Data scraped and saved to apple_diseases.json")


 """