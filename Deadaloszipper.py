# Skript för att zippa alla kataloger i en mapp enligt strukturen:
# zipfil --> mapp med namnet på ursprungskatalogen --> Innehåll.
import os
import shutil

# arbetskatalogen
cwd = os.getcwd()
print(cwd)

# Kollar om det finns en tempdir katalog i cwd annars skapas det.
test = os.path.exists(f'{cwd}/tempdir')
if test == False:
    os.mkdir(f'{cwd}/tempdir')

# Räknar objekten i mappen och lägger i en variabel samt skapar iterationsvariabel för nedräkning.
objects = len([name for name in os.listdir('.')])
done = 0


# Gör jobbet! Rullar igenom alla objekt i mappen och zippar alla mappar till egna zipfiler enligt bestämd struktur.
# Tar bort filerna i temp efter varje iteration. 
for i in os.listdir(cwd):
    done += 1
    print(f'Jobbar med {done}/{objects} objekt')
    if (os.path.isdir(i)) and (i != 'tempdir'):
        path = os.path.join(cwd, i)
        destinationpath = f'{cwd}/tempdir/{i}'
        zippath = f'{cwd}/tempdir'
        shutil.copytree(i, destinationpath)
        shutil.make_archive(i,'zip', zippath)
        shutil.rmtree(destinationpath)