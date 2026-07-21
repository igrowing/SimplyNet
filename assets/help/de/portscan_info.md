# Was ist ein Port-Scan?

Wie finden Hacker oder Sicherheitsexperten Schwachstellen auf einem Gerät?

Sie tun dies mit einem Werkzeug namens Port-Scan.

## 1. Die Analogie: ein gesichertes Gebäude mit 65.536 Türen

Stell dir ein riesiges, gesichertes Bürogebäude oder einen Wohnkomplex vor.

* Der Host (die IP-Adresse oder Domain) ist die Straßenadresse des Gebäudes. Sie bringt dich zum Haupttor.
* Einmal drinnen, hat das Gebäude genau 65.536 nummerierte Türen (Ports genannt).
* Hinter jeder Tür befindet sich ein bestimmtes Geschäft oder ein bestimmter Dienst. Zum Beispiel steht hinter Tür 80 ein Website-Verwalter, und hinter Tür 554 ein Überwachungskamera-Stream.

  💡 Ein Port-Scan ist wie ein Sicherheitswächter, der durch die Flure geht, an die Türen klopft und prüft, welche offen, verschlossen oder komplett verlassen sind.

Ist eine Tür Offen, bedeutet das, dass dahinter ein Dienst aktiv läuft und auf Verbindungen wartet. Ist sie Geschlossen, ist die Tür verriegelt und niemand ist drinnen.

## 2. Ziel auswählen: bekannte Ports (Well-Known) vs. benutzerdefinierter Bereich

Du kannst wählen, welche "Türen" du überprüfen möchtest:

### A. Bekannte Ports (die Haupthalle überprüfen)

Von den 65.536 möglichen Türen sind die allermeisten leer. Standardmäßig reserviert das Internet die ersten 1.024 Türen für standardisierte, offizielle Dienste.

* Tür 80: Standard-Websites (HTTP)
* Tür 443: sichere Websites (HTTPS)
* Tür 21: Dateifreigabe (FTP)
* Tür 22: sichere Fernsteuerung (SSH)
* Wie es dir hilft: Das Scannen der bekannten Ports ist wie das Überprüfen nur der Haupthallen und Laderampen des Gebäudes. Es ist unglaublich schnell (dauert nur ein paar Sekunden) und deckt 99 % dessen ab, wonach ein normaler Nutzer sucht.

### B. Benutzerdefinierter Bereich (jeden Raum durchsuchen)

Manchmal verstecken sich benutzerdefinierte Apps, Smart-Home-Geräte oder Kameras hinter ungewöhnlichen Türnummern (wie Tür 8080 oder Tür 32400), um unauffällig zu bleiben.

* Wie es dir hilft: Du kannst der App sagen, sie soll einen benutzerdefinierten Bereich scannen – zum Beispiel von Tür 1 bis Tür 2048. Die App klopft gewissenhaft an jede einzelne dieser Türen, eine nach der anderen, um versteckte Dienste zu finden.

## 3. Die Protokolle: TCP vs. UDP

Die "Türen" eines Computers sprechen zwei verschiedene Sprachen. Je nach deinen Einstellungen klopft die App in unterschiedlichen Stilen:

### 1. TCP (der höfliche Handschlag)

TCP (Transmission Control Protocol) ist das häufigste Protokoll im Internet. Es ist auf 100 % Genauigkeit ausgelegt.

* Der Klopfstil: Die App klopft an die Tür, wartet, bis jemand öffnet, schüttelt die Hand, sagt "Hallo!" und geht dann höflich wieder.
* Analogie: Wie das Senden eines Einschreibens. Es ist äußerst zuverlässig, um zu bestätigen, ob jemand zu Hause ist, aber der "Handschlag" braucht einen Sekundenbruchteil zum Abschluss.

### 2. UDP (der Postkartenwurf)

UDP (User Datagram Protocol) ist auf reine Geschwindigkeit ausgelegt und wird oft für Live-Videostreams oder Online-Gaming verwendet.

* Der Klopfstil: Die App wirft eine Postkarte durch den Briefschlitz und lauscht einen Sekundenbruchteil, ob jemand drinnen zurückruft. Sie wartet nicht auf einen Handschlag.
* Analogie: Wie ein Papierflieger, den man über einen Zaun wirft. Es ist unglaublich schnell, aber wenn niemand zurückruft, ist es schwerer, zu 100 % sicher zu sein, ob der Raum leer ist oder ob sie deinen Papierflieger einfach ignoriert haben.

## 4. Warum dauert ein großer Scan so lange?

*"Warum dauert mein Scan so lange?"* Die Antwort ist einfache Mathematik!

* Wenn du die bekannten Ports nur mit TCP scannst, prüft die App etwa 60 Türen. Sie ist blitzschnell fertig.
* Wenn du den Bereich von 1 bis 10.000 erweiterst und sowohl TCP als auch UDP auswählst, muss die App physisch **20.000** einzelne Klopfvorgänge durchführen (**10.000** für TCP und **10.000** für UDP).

Da die App an jeder Tür einen winzigen Sekundenbruchteil warten muss, um zu sehen, ob ein Gerät antwortet (um keine langsam reagierende Kamera oder keinen Router zu verpassen), erfordert das Überprüfen von Zehntausenden Türen Geduld.

Um Zeit zu sparen, beginne immer zuerst mit einem Scan der "bekannten" Ports! Führe benutzerdefinierte Scans mit großem Bereich nur aus, wenn du nach einem ganz bestimmten, versteckten Gerät in deinem Netzwerk suchst.
