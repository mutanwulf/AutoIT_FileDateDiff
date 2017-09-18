# AutoIT FileDateDiff
Dieses Programm vergleicht anhand des Änderunsgdatum Dateien miteinander und gibt eine Meldung aus sobald es eine unterschiedliche Datei gibt.

Es ist in AutoIT Scriptsprache geschrieben und in eine Windows-EXE umgewandelt.

Einstellungen werden über die *config.ini* gemacht. Aufbau der INI-Datei mit Parameter wie folgt:

**[config]**

- **localFile=***c:\FileCheck\test.ini* 
  Die erste Datei oder Dateien die getestet werden sollen. Dateitrennzeichen ist das **,** (Komma)
- **netFile=***C:\FileCheck\testnet.ini**  
  Die zweite Datei...
- **server=**IP  
  IP/HOSTNAME welche angepingt werden soll, bevor ein Check ausgeführt wird (z.B bei Netzlaufwerken)
- **checks=**3  
  Wie oft soll geprüft werden bevor abgegbrochen wird
- **waittime=**10  
  Wie lange soll zwischen den Prüfungen gewartet werden
- **checktyp=**0  
  Dieser Typ beschreibt das Argument welches geprüft wird:  
   0   Änderunsgdatum/zeit der Datei  
   1   Erstellungsdatum/zeit der Datei  
   2   Letzter Zugriff auf die Datei  
- **displaysame=**0   
  Soll auch die Meldung bei gleichen Dateien ausgegeben werden (1 für ausgeben)

