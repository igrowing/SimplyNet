# Che cos'è una scansione delle porte (Port Scan)?

Come fanno gli hacker o gli esperti di sicurezza a trovare i punti di vulnerabilità di un dispositivo?

Lo fanno usando uno strumento chiamato scansione delle porte (Port Scan).

## 1. L'analogia: un edificio protetto con 65.536 porte

Immagina un enorme edificio di uffici o un complesso residenziale sicuro.

* L'Host (l'indirizzo IP o dominio) è l'indirizzo stradale dell'edificio. Ti porta al cancello principale.
* Una volta dentro, l'edificio ha esattamente 65.536 porte numerate (chiamate Porte).
* Dietro ogni porta c'è un'attività o un servizio specifico. Ad esempio, dietro la Porta 80 c'è un gestore di siti web, e dietro la Porta 554 c'è un flusso di telecamere di sicurezza.

  💡 Una scansione delle porte è come una guardia di sicurezza che cammina lungo i corridoi, bussa alle porte e controlla quali sono aperte, chiuse a chiave o completamente abbandonate.

Se una porta è Aperta, significa che dietro di essa c'è un servizio attivo in ascolto di connessioni. Se è Chiusa, la porta è bloccata e non c'è nessuno all'interno.

## 2. Scegliere il bersaglio: porte note (Well-Known) vs intervallo personalizzato

Puoi scegliere quali "porte" controllare:

### A. Porte note (controllo dell'atrio principale)

Delle 65.536 porte possibili, la stragrande maggioranza è vuota. Per impostazione predefinita, internet riserva le prime 1.024 porte a servizi standard e ufficiali.

* Porta 80: siti web standard (HTTP)
* Porta 443: siti web sicuri (HTTPS)
* Porta 21: condivisione file (FTP)
* Porta 22: controllo remoto sicuro (SSH)
* Come ti aiuta: scansionare le porte note è come controllare solo gli atri principali e le banchine di carico dell'edificio. È incredibilmente veloce (richiede solo un paio di secondi) e copre il 99% delle cose che un utente normale cerca.

### B. Intervallo definito dall'utente (cercare in ogni stanza)

A volte, app personalizzate, dispositivi smart-home o telecamere si nascondono dietro numeri di porta insoliti (come la Porta 8080 o la Porta 32400) per rimanere fuori dalla vista.

* Come ti aiuta: puoi dire all'app di scansionare un intervallo personalizzato—ad esempio dalla Porta 1 alla Porta 2048. L'app busserà diligentemente a ognuna di quelle porte, una dopo l'altra, per trovare servizi nascosti.

## 3. I protocolli: TCP vs UDP

Le "porte" di un computer parlano due lingue diverse. A seconda delle tue impostazioni, l'app busserà usando stili diversi:

### 1. TCP (la stretta di mano cortese)

TCP (Transmission Control Protocol) è il protocollo più comune su internet. È progettato per la massima accuratezza (100%).

* Lo stile del bussare: l'app bussa alla porta, aspetta che qualcuno apra, gli stringe la mano, dice "Ciao!" e poi se ne va educatamente.
* Analogia: come inviare una raccomandata. È estremamente affidabile per confermare se qualcuno è in casa, ma la "stretta di mano" richiede una frazione di secondo per completarsi.

### 2. UDP (il lancio della cartolina)

UDP (User Datagram Protocol) è progettato per la pura velocità, spesso usato per streaming video in diretta o giochi online.

* Lo stile del bussare: l'app lancia una cartolina attraverso la fessura della posta e ascolta per un istante per vedere se qualcuno all'interno risponde gridando. Non aspetta di stringere la mano.
* Analogia: come lanciare un aeroplanino di carta oltre una recinzione. È incredibilmente veloce, ma se nessuno risponde è più difficile essere sicuri al 100% se la stanza è vuota o se hanno semplicemente ignorato il tuo aeroplanino.

## 4. Perché una scansione ampia richiede così tanto tempo?

*"Perché la mia scansione ci mette così tanto?"* La risposta è semplice matematica!

* Se scansioni le porte note usando solo TCP, l'app controlla circa 60 porte. Finisce in un lampo.
* Se estendi l'intervallo da 1 a 10.000 e selezioni sia TCP che UDP, l'app deve fisicamente eseguire **20.000** bussate individuali (**10.000** per TCP e **10.000** per UDP).

Poiché l'app deve attendere una minuscola frazione di secondo a ogni porta per vedere se un dispositivo risponde (per non perdere una telecamera o un router che risponde lentamente), controllare decine di migliaia di porte richiede pazienza.

Per risparmiare tempo, inizia sempre prima con una scansione delle porte "note"! Esegui scansioni personalizzate ad ampio intervallo solo se stai cercando un dispositivo nascosto molto specifico sulla tua rete.
