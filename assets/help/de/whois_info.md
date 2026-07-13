# Was ist "Who Is" und DNS-Auflösung?

Hast du dich jemals gefragt, wem eine Website wie google.com eigentlich gehört? Oder wie dein Handy allein anhand einer Webadresse automatisch den richtigen Computer auf der anderen Seite der Welt findet?

Wenn du das Who-Is...-Werkzeug verwendest, ziehst du den Vorhang vor dem Verwaltungsverzeichnis des Internets zurück. Es nutzt drei Hauptfunktionen, um eine beliebige Domain oder IP-Adresse zu untersuchen.

## 1. Was ist WHOIS? (Das digitale Grundbuch)

Jeder Website-Name (wie deinewebsite.com) ist ein Stück digitales Grundeigentum. Genau wie beim Kauf eines echten Hauses oder der Zulassung eines Autos kannst du eine Domain nicht anonym besitzen, ohne sie zu registrieren.

WHOIS (wörtlich die Frage *"Wer ist für diese Domain verantwortlich?"*) ist eine riesige, öffentliche Datenbank, die die Eigentümerangaben jedes registrierten Domainnamens und jeder IP-Adresse auf der Erde erfasst.

### Die Analogie: die Zulassungsstelle oder das Grundbuchamt

Wenn du ein Kennzeichen bei der Zulassungsstelle nachschlägst, erhältst du einen Eintrag darüber, wem das Auto gehört, wann es zugelassen wurde und wie man den Besitzer kontaktiert. Eine WHOIS-Suche macht genau dasselbe für eine Website.

### Welche Informationen zeigt sie dir?

* Der Registrant: der Name der Person oder des Unternehmens, das die Domain gekauft hat. (Hinweis: Viele Privatpersonen nutzen "Datenschutz"-Dienste, um ihre privaten Adressen zu verbergen, aber die Angaben des Hosting-Unternehmens bleiben sichtbar).
* Wichtige Daten: genau wann der Website-Name zum ersten Mal gekauft wurde, wann er zuletzt aktualisiert wurde und – am wichtigsten – wann er abläuft.
* Der Registrar: der digitale "Laden", in dem der Besitzer die Domain gekauft hat (wie GoDaddy, Namecheap oder Google Domains).

## 2. Was ist DNS-Auflösung? (Das Telefonbuch des Internets)

Computer sind unglaublich gut im Rechnen, aber schlecht mit Sprachen. Sie verstehen keine Namen wie `netflix.com`. Um miteinander zu sprechen, verwenden sie numerische Koordinaten, sogenannte IP-Adressen (wie `142.250.190.46`).

Menschen hingegen sind gut mit Namen, aber schlecht darin, sich zufällige Zahlenfolgen zu merken.

**Die DNS-Auflösung (Domain Name System)** ist die Brücke zwischen diesen beiden Welten. Sie übersetzt einen menschenfreundlichen Namen in eine computerfreundliche Zahl.

### Die Analogie: die Kontakte-App deines Handys

Wenn du deinen Freund Alex anrufen willst, merkst du dir nicht seine zehnstellige Telefonnummer. Du tippst einfach auf "Alex" in deiner Kontaktliste, und dein Handy übersetzt diesen Namen automatisch in die numerische Telefonnummer und wählt sie.

* DNS ist die globale Kontaktliste für das gesamte Internet. * Wenn du in unserer App eine Domain suchst, läuft die DNS-Auflösung sofort im Hintergrund und sagt dir: "Hey, google.com ist derzeit unter der Telefonnummer 142.250.190.46 erreichbar."

## 3. Was ist die umgekehrte Auflösung? (Digitale Anrufer-ID)

Aber was passiert, wenn du die Nummer (die IP-Adresse) hast und den Namen (die Website) wissen willst? Hier kommt die umgekehrte Auflösung ins Spiel (auch bekannt als Reverse DNS oder PTR-Lookup).

Wenn ein fremder Computer versucht, sich mit deinem Heimnetzwerk zu verbinden, oder wenn du eine seltsame IP-Adresse in deinen Netzwerkprotokollen siehst, kannst du diese IP-Adresse in unser Werkzeug einfügen. Die App fragt das globale Verzeichnis: "Welcher Website-Name ist für diese bestimmte Nummer registriert?"

### Die Analogie: Anrufer-ID (oder umgekehrte Rufnummernsuche)

Wenn dein Handy klingelt und eine unbekannte Nummer wie `1-800-555-0199` anzeigt, zögerst du vielleicht mit dem Abheben. Aber wenn die Anrufer-ID deines Handys diese Nummer übersetzt und **"Apple Support"** anzeigt, weißt du sofort, wer anruft.

* Die umgekehrte Auflösung ist die Anrufer-ID für Internetadressen.
* Sie ermöglicht es dir, eine anonyme, einschüchternde Nummer wie `172.217.16.142` wieder in einen freundlichen, erkennbaren Namen wie `google.com` zu übersetzen.

## Zusammenfassung des "Who Is..."-Werkzeugs

Durch die Kombination dieser drei Funktionen gibt dir unser Werkzeug eine vollständige "Hintergrundüberprüfung" jedes digitalen Ziels:

1. Die DNS-Auflösung nennt dir die IP-Adresse (die "Telefonnummer") eines Website-Namens.
2. Die umgekehrte Auflösung nennt dir den Website-Namen (die "Anrufer-ID") einer mysteriösen IP-Adresse.
3. WHOIS nennt dir den tatsächlichen rechtlichen Eigentümer, den Registrar und die Ablaufdaten dieses Eigentums.
