import sip
import re
import os
import datetime
from shutil import copy, make_archive


''' Används för att skapa (preIngest) sip-paket av VIVA-exporter. De genererade paketen kan därefter droppas rätt in i massIngesten i iipax.
    Skriptet letar efter ".zip"-filer i den aktuella katalogen och struntar i eventuella övriga filtyper.
    OBS! Skriptet använder sig av en separat SIP-modul (modifierad) så den måste finnas på plats för att koden ska fungera. 
'''


regex = re.compile(r'(^.+)(\.[a-zA-Z0-9]+$)')
cwd = os.getcwd()

xmlNamespace = {
    None  : 'http://www.idainfront.se/schema/archive-2.2',
    'ns2' : 'http://www.idainfront.se/schema/archive-2.0-custom'
}

producer = 'Borås socialtjänst'
system = 'Vivaexport'

date = datetime.datetime.now()
strdate = date.strftime("%Y-%m-%d_%H:%M")
strdatehour = date.strftime("%Y-%m-%d %H:%M")
strdatehourforfile = date.strftime("%Y-%m-%d_%H_%M")



# Skriver filen till output
outPath = os.path.join(os.getcwd(), 'out')
os.makedirs(outPath, exist_ok=True)

arende = 'vivaexport'

arendePath = os.path.join(outPath, re.sub(r'[åäöÅÄÖ]', r'', arende))
arendePathDoc = os.path.join(arendePath, 'doc')
os.makedirs(arendePathDoc)

# Skapar SIP
xmlSip = sip.ArchiveXML(f'Export från Viva {strdatehour}', 'digitalt_objekt', producer, system, namespace=xmlNamespace)
xmlSip.addAttribute('beskrivning',f'Export från Viva {strdate} i sin ursprungliga form.')
xmlSip.addAttribute('handling_typ','Export från Viva')
xmlSip.addAttribute('secrecy', '20')
xmlSip.addAttribute('pul_personal_secrecy', '20')
xmlSip.addAttribute('other_secrecy', '20')



# Skapar filer
for entry in os.scandir(cwd):
    if entry.is_file() and entry.name.lower().endswith('.zip'):
        xmlSip.addFile(entry.name,entry.name,'20', '20', '20')
        print(entry.name)
        filepath = os.path.join(entry)
        copy(filepath, arendePathDoc)

    else:
        print(f'Hoppar över {entry}')

# Skriver xml och zippar iipax-sip
xmlSip.write(arendePath)
make_archive(f'Exportpaket_{strdatehourforfile}','zip',outPath)