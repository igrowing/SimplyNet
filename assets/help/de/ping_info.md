# Was ist ein Ping?

Hast du dich jemals gefragt, was passiert, wenn dein Computer oder Handy eine Website "anpingt"? Oder warum der technische Support dich immer bittet, einen "Ping-Test" durchzuführen, wenn das Internet langsam ist?

Trotz des technisch klingenden Namens ist ein Ping das einfachste Diagnosewerkzeug im gesamten Computer-Networking. Hier ist eine leicht verständliche Anleitung dazu, was er ist, was er tut und wie er in unserer App funktioniert.

## 1. Die Analogie: das U-Boot-Sonar (oder Echo)

Der Begriff "Ping" stammt eigentlich aus der Sonartechnik von U-Booten.

Stell dir ein U-Boot vor, das im dunklen Ozean treibt. Um zu sehen, ob ein Berg oder ein anderes Schiff in der Nähe ist, sendet es einen Schallimpuls – ein lautes "Ping!" – ins Wasser.

Trifft der Schall auf ein Objekt, kommt er als Echo zurück.

Indem es misst, wie lange das Echo zum Zurückkehren braucht, kann das U-Boot genau berechnen, wie weit das Objekt entfernt ist.

Kommt kein Echo zurück, weiß das U-Boot, dass dort draußen nichts ist.

In der digitalen Welt macht dein Handy genau dasselbe. Es sendet einen winzigen digitalen Impuls an einen anderen Computer oder eine Website und wartet darauf, dass dieser Computer den Impuls zurücksendet.

## 2. Warum brauchen wir das?

Ping hilft dir, drei entscheidende Fragen zu deiner Verbindung zu beantworten:

### A. "Ist dieser Computer eingeschaltet und verbunden?" (Verfügbarkeit)

Wenn du ein Gerät anpingst (z. B. deinen Smart-TV, deinen Router oder google.com) und es antwortet, weißt du, dass es eingeschaltet und mit dem Netzwerk verbunden ist. Schlägt der Ping fehl, ist entweder das Gerät ausgeschaltet, das Kabel abgezogen oder eine Firewall blockiert den Datenverkehr.

### B. "Wie schnell ist meine Verbindung?" (Latenz)

Die Zeit, die dein Ping für den Hin- und Rückweg braucht, wird in Millisekunden (ms) gemessen.

* 1 bis 20 ms: blitzschnell (ideal für Online-Gaming oder Videoanrufe).
* 20 bis 100 ms: gut, normale Surfgeschwindigkeit.
* Über 150 ms: langsam, ruckelig oder verzögert.

### C. "Ist meine Verbindung stabil?" (Paketverlust & Jitter)

Wenn du einen Tennisball zehnmal gegen eine Wand wirfst, erwartest du, dass er zehnmal zurückspringt.

* Wenn du eine Website 50 Mal anpingst und nur 45 Pings zurückkommen, hast du 10 % Paketverlust (Packet Loss). Das bedeutet, dass deine Verbindung instabil ist und Daten unterwegs verloren gehen.
* Wenn einige Pings 10 ms brauchen, andere aber 500 ms, hast du hohen Jitter, was bedeutet, dass deine Verbindung inkonsistent ist.

## 3. IP, Hostname und FQDN: Wie du dein Ziel adressierst

Wenn du unserer App sagst, sie soll etwas anpingen, musst du ihr mitteilen, wohin der Impuls gesendet werden soll. Du kannst drei verschiedene Arten von Adressen eingeben:

### 1. IP-Adresse (die GPS-Koordinaten)

Eine IP-Adresse (Internet Protocol) ist eine Zahlenfolge wie 192.168.1.1 oder 142.250.190.46.

* Was sie ist: Dies ist die exakte, physische Adresse eines Computers im Netzwerk. Computer verstehen nur IP-Adressen.
* Analogie: Stell sie dir wie die exakten Breiten- und Längengrad-Koordinaten eines Hauses vor. Sie ist hochpräzise, aber für Menschen sehr schwer zu merken.

### 2. Hostname (der freundliche Spitzname)

Ein Hostname ist ein einfacher, menschenlesbarer Name, der einem einzelnen Gerät in einem lokalen Netzwerk zugewiesen wird, z. B. MyLaptop, OfficePrinter oder LivingRoomSpeaker.

* Was er ist: Es ist ein lokaler Spitzname. Zu Hause kannst du deinem Handy sagen, es soll OfficePrinter anpingen, und dein Router übersetzt diesen Spitznamen in dessen IP-Adresse.
* Analogie: Stell es dir vor wie "Mamas Zimmer" oder "die Küche". Bei dir zu Hause funktioniert das perfekt, aber wenn du bei einem Fremden zu Hause bist und sagst "geh in Mamas Zimmer", weiß derjenige nicht, welches Zimmer du meinst.

### 3. FQDN (die vollständige Postanschrift)

FQDN steht für Fully Qualified Domain Name (vollständig qualifizierter Domainname). Beispiele sind www.google.com, mail.yahoo.com oder support.apple.com.

* Was er ist: Dies ist der vollständige, offizielle, eindeutige Name eines Servers im globalen Internet. Da er sowohl den spezifischen Host-Spitznamen (www) als auch die registrierte Domain (google.com) enthält, gibt es null Verwirrung darüber, von welchem Computer auf der Erde du sprichst.
* Analogie: Stell ihn dir wie eine vollständige internationale Postanschrift vor, mit Name, Straße, Stadt und Land. Er ist eindeutig und funktioniert von überall auf der Welt.

## 4. Besondere Funktionen des Ping-Werkzeugs

Wenn du das Ping-Werkzeug verwendest, hast du die volle Kontrolle darüber, wie der Test abläuft:

* Passe die Ping-Dauer an (Anzahl): Statt endlos zu pingen oder einen festen Test auszuführen, kannst du genau angeben, wie oft gepingt werden soll (z. B. 10, 50 oder 100 Mal). So kannst du über mehrere Minuten einen Langzeit-Stabilitätstest durchführen, um zu sehen, ob dein WLAN unter zeitweisen Aussetzern leidet, wenn du in einen anderen Raum gehst.
* Jederzeit abbrechen (Stopp-Taste): Wenn du einen Stabilitätstest mit 100 Pings gestartet, aber sofort hohen Paketverlust oder Fehlerprotokolle bemerkt hast, musst du nicht warten, bis der Test fertig ist. Du kannst jederzeit auf Stopp drücken. Unsere App beendet sofort den Netzwerkprozess im Hintergrund, stoppt den Akkuverbrauch und berechnet umgehend die endgültigen Durchschnittswerte der Pings, die tatsächlich abgeschlossen wurden.
