# Geschwindigkeitstest

SimplyNet misst deine Internetverbindung, indem es Daten zu und von einem Testserver überträgt und die Zeit stoppt. Drei Werte werden angezeigt:

- **Download** — wie schnell Daten dein Gerät erreichen, in Mbit/s. Höher ist besser.
- **Upload** — wie schnell dein Gerät Daten sendet, in Mbit/s. Höher ist besser.
- **Ping** — die Umlaufverzögerung zum Server, in Millisekunden. Niedriger ist
  besser.

## Einen Anbieter wählen

Das Dropdown-Menü unter der Schaltfläche **Test starten** wählt aus, welches Test-Backend
verwendet wird.

## Vergleich der Geschwindigkeitstest-Dienste

| Merkmal | Cloudflare (Standard) | Ookla |
|---|---|---|
| Messziel | Reale Web-Browsing-Geschwindigkeit | Absolute theoretische Leitungskapazität |
| Datenschutzstatus | 100 % anonym. Kein Tracking | Erfasst IP, Standort und Gerätedaten |
| Technische Methode | Progressiver Download mit einem Stream | Netzwerksättigung mit mehreren Streams |
| Ideal für | Bewertung der täglichen Internetleistung | Überprüfung der vom ISP beworbenen Geschwindigkeiten |

### Über Cloudflare (Standard)

Verwendet die öffentlichen `speed.cloudflare.com`-Endpunkte von Cloudflare. Es ist kein Konto oder zusätzliche Zustimmung erforderlich, und es werden keine persönlichen Identifikatoren über die normalen Informationen hinaus geteilt, die jede Website-Anfrage mit sich bringt (wie deine IP-Adresse, die zum Liefern der Antwort benötigt wird).

Dies ist die empfohlene Option für die meisten Nutzer.

### Über Ookla

Verwendet das globale speedtest.net-Servernetzwerk von Ookla – dieselbe Infrastruktur hinter dem bekannten Speedtest-Dienst. Ookla-Server werden von Drittanbietern weltweit betrieben, sodass ein Test sich mit dem nächstgelegenen und erreichbaren Server verbindet.

Da hierbei Server von Drittanbietern beteiligt sind, fragt die Wahl von Ookla beim ersten Mal nach deiner Zustimmung. **Ookla erfasst und teilt deine IP-Adresse, Gerätekennungen und Standortdaten.** Deine Wahl wird gespeichert, sodass du nicht erneut gefragt wirst; du kannst jederzeit zu Cloudflare zurückwechseln.

Wenn Ookla aktiv ist, wird die Schaltfläche **Test starten** bernsteinfarben, als Erinnerung daran, dass ein Backend eines Drittanbieters verwendet wird. Cloudflare stellt die blaue Schaltfläche wieder her.

## Tipps für genaue Ergebnisse

- Teste über WLAN oder mobile Daten, je nachdem, was du messen möchtest.
- Schließe andere Apps, die möglicherweise das Netzwerk nutzen.
- Führe den Test mehrmals durch — die Ergebnisse variieren je nach Netzwerkbedingungen und Serverlast.
- Sehr schnelle Verbindungen können durch das Gerät oder die Testmethode begrenzt sein und nicht durch deine tatsächliche Verbindung.

## Datenschutz

Die Ergebnisse werden nur auf deinem Gerät unter **Frühere Messungen** gespeichert. Du kannst sie jederzeit im Verlaufsbereich löschen. SimplyNet lädt deine Ergebnisse nirgendwohin hoch.
