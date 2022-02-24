import os
from datetime import *
import xml.etree.ElementTree as ET

def xmlChecker(file, validation_xml=None):
    returnlist = []
    tree = ET.parse(file)
    root = tree.getroot()
    namespace = {
        'ns2' : 'http://www.idainfront.se/schema/archive-2.1-custom',
        'None'  : 'http://www.idainfront.se/schema/archive-2.2',
    }  
    
    # Hämtar datum i xml-filen och jämför med inputdatum 
    try:
        time_tag = datetime.strptime((root.find('ns2:date', namespace).text), '%Y-%m-%d')
    except:
        namespace ={'ns2' : 'http://www.idainfront.se/schema/archive-2.0-custom'}
        time_tag = datetime.strptime((root.find('ns2:date',namespace).text), '%Y-%m-%d')
    
    if time_tag < checkBackTime:
        return returnlist
    
    # Om filen är en 'fgs_valideringskvitto' kollar den valideringsstatus
    if (validation_xml == True) and (root.find('*/ns2:status', namespace).text == 'not valid'):
        returnlist.append(f"VALIDERINGSFEL!: {root.find('*/ns2:error', namespace).text} {root.find('*/ns2:Id', namespace).text}")
        return returnlist
    elif validation_xml == True:
        return returnlist

    # Jämför antalet objekt med antalet lyckade aktioner om det inte är == så lägger den till vilken fil som felet finns i 
    # Skickar alltid tillbaka antalet objekt och antalet lyckade.
    total_in_batch = int(root.find('ns2:TotalBatchSize', namespace).text)
    successful_objects = int(root.find('ns2:ItemsInReceipt', namespace).text)
    returnlist = [total_in_batch, successful_objects]
    if total_in_batch != successful_objects:
        felfil = root.find('ns2:correlationId',namespace).text
        returnlist.append(felfil)
    return returnlist

# Hämtar cwd + input för hur långt bak i tiden skriptet ska granska kvitton.
#inputtime = '1900-01-01'
inputtime = input('Skriv slutdatum (YYYY-MM-DD):\n> ')
checkBackTime = datetime.strptime(inputtime, '%Y-%m-%d' )
cwd = os.getcwd()

# Variabler och listor för att räkna ut resultatet + sammanställa fel.
total_to_archive = 0
successful_to_archive = 0
total_to_validation = 0
successful_validations = 0
errors = []
validation_error_list = []

# Går igenom kataloger och filer - fokuserar bara på valideringskvittot + arkivering och konvertering (lyckade)
for root, dirs, files in os.walk(cwd):
    print(f'Arbetar med {root}')
    for name in files:
        if name == 'Arkiveringskvitto_lyckade.xml':
            filepath = os.path.join(root, name)
            results_from_archive = xmlChecker(filepath)
            # Om listan inte är tom adderas antalet objekt i paketet + lyckade
            if len(results_from_archive):
                total_to_archive += results_from_archive[0]
                successful_to_archive += results_from_archive[1]
            # Om listan innehåller tre värden (dvs det finns ett fel lägger den felet i error-listan)
            if (len(results_from_archive) == 3) and (results_from_archive[2] not in errors):
                errors.append(results_from_archive[2])

        # Fungerar på samma sätt som ovan fast andra variabler.
        if name == 'Konverteringskvitto_lyckade.xml':
            filepath = os.path.join(root, name)
            results_from_archive = xmlChecker(filepath)
            if len(results_from_archive):
                total_to_validation += results_from_archive[0]
                successful_validations += results_from_archive[1]
            if (len(results_from_archive) == 3) and (results_from_archive[2] not in errors):
                errors.append(results_from_archive[2])
        
        if name == 'fgs_valideringskvitto.xml':
            filepath = os.path.join(root, name)
            results_from_archive = xmlChecker(filepath, True)
            # Om valideringen har gått fel lägger den till fel + vilken fil som är berörd
            if len(results_from_archive):
                validation_error_list.append(results_from_archive[0])
            
            
            
# Printar ut resultatet
printspace = '*'*25
print(f'''\nRESULTAT\n{printspace}\nTotalt antal objekt som skulle arkiveras: {total_to_archive}\nLyckade arkiveringar: {successful_to_archive}
Totalt antal objekt till validering: {total_to_validation}\nLyckade valideringar: {successful_validations}\n{printspace}''')

if len(errors) > 0:
    print("Följande paket innehöll fel:")
    print(errors, end='\n\n')

if len(validation_error_list) > 0:
    print('Följande XML-filer gick inte vidare till validering:')
    print(validation_error_list, end='\n\n')