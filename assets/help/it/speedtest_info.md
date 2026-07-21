# Test di velocità

SimplyNet misura la tua connessione internet trasferendo dati da e verso un server di test e cronometrandoli. Vengono riportati tre numeri:

- **Download** — quanto velocemente i dati raggiungono il tuo dispositivo, in Mbps. Più alto è, meglio è.
- **Upload** — quanto velocemente il tuo dispositivo invia i dati, in Mbps. Più alto è, meglio è.
- **Ping** — il ritardo di andata e ritorno verso il server, in millisecondi. Più basso è,
  meglio è.

## Scegliere un provider

Il menu a tendina sotto il pulsante **Avvia test** seleziona quale backend di test viene
usato.

## Confronto dei servizi di test di velocità

| Caratteristica | Cloudflare (predefinito) | Ookla |
|---|---|---|
| Obiettivo di misurazione | Velocità di navigazione web reale | Capacità teorica assoluta della linea |
| Stato privacy | 100% anonimo. Nessun tracciamento | Raccoglie IP, posizione e dati del dispositivo |
| Metodo tecnico | Download progressivo a flusso singolo | Saturazione della rete a più flussi |
| Ideale per | Valutare le prestazioni internet quotidiane | Verificare le velocità pubblicizzate dall'ISP |

### Tramite Cloudflare (predefinito)

Utilizza gli endpoint pubblici `speed.cloudflare.com` di Cloudflare. Non è richiesto alcun account o consenso aggiuntivo, e non vengono condivisi identificatori personali oltre alle normali informazioni che qualsiasi richiesta a un sito web trasporta (come il tuo indirizzo IP, necessario per consegnare la risposta).

Questa è l'opzione consigliata per la maggior parte degli utenti.

### Tramite Ookla

Utilizza la rete di server globale speedtest.net di Ookla, la stessa infrastruttura dietro il noto servizio Speedtest. I server Ookla sono gestiti da terze parti in tutto il mondo, quindi un test si connette al server più vicino e raggiungibile.

Poiché questo coinvolge server di terze parti, la scelta di Ookla richiede il tuo consenso la prima volta. **Ookla raccoglie e condivide il tuo indirizzo IP, gli identificatori del dispositivo e i dati sulla posizione.** La tua scelta viene memorizzata così non ti verrà chiesto di nuovo; puoi tornare a Cloudflare in qualsiasi momento.

Quando Ookla è attivo, il pulsante **Avvia test** diventa ambra per ricordarti che è in uso un backend di terze parti. Cloudflare ripristina il pulsante blu.

## Suggerimenti per risultati accurati

- Esegui il test su Wi-Fi o dati mobili a seconda di cosa vuoi misurare.
- Chiudi le altre app che potrebbero usare la rete.
- Esegui il test alcune volte — i risultati variano con le condizioni della rete e il carico del server.
- I collegamenti ad altissima velocità possono essere limitati dal dispositivo o dal metodo di test piuttosto che dalla tua connessione effettiva.

## Privacy

I risultati sono memorizzati solo sul tuo dispositivo sotto **Misurazioni precedenti**. Puoi cancellarli in qualsiasi momento dalla sezione cronologia. SimplyNet non carica i tuoi risultati da nessuna parte.
