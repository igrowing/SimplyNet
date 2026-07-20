# Che cos'è un Ping?

Ti sei mai chiesto cosa succede quando il tuo computer o telefono "pinga" un sito web? O perché l'assistenza tecnica ti chiede sempre di eseguire un "test del ping" quando internet va lento?

Nonostante il nome dal suono tecnico, il ping è lo strumento diagnostico più semplice in tutto il networking informatico. Ecco una guida in parole povere su cos'è, cosa fa e come funziona nella nostra app.

## 1. L'analogia: il sonar del sottomarino (o eco)

Il termine "Ping" deriva in realtà dalla tecnologia sonar dei sottomarini.

Immagina un sottomarino che galleggia nell'oceano buio. Per vedere se c'è una montagna o un'altra nave nelle vicinanze, emette un impulso sonoro—un forte "Ping!"—nell'acqua.

Se il suono colpisce un oggetto, rimbalza indietro come un'eco.

Misurando quanto tempo impiega l'eco a tornare, il sottomarino può calcolare esattamente quanto è lontano l'oggetto.

Se non torna alcuna eco, il sottomarino sa che non c'è nulla là fuori.

Nel mondo digitale, il tuo telefono fa esattamente la stessa cosa. Invia un piccolo impulso digitale a un altro computer o sito web e aspetta che quel computer restituisca l'impulso.

## 2. Perché ne abbiamo bisogno?

Il ping ti aiuta a rispondere a tre domande fondamentali sulla tua connessione:

### A. "Quel computer è acceso e connesso?" (Disponibilità)

Se pinghi un dispositivo (come la tua smart TV, il router o google.com) e questo risponde, sai che è acceso e connesso alla rete. Se il ping fallisce, il dispositivo è spento, il cavo è scollegato oppure un firewall sta bloccando il traffico.

### B. "Quanto è veloce la mia connessione?" (Latenza)

Il tempo che impiega il ping a compiere il viaggio di andata e ritorno si misura in millisecondi (ms).

* Da 1 a 20 ms: velocissimo (ottimo per giochi online o videochiamate).
* Da 20 a 100 ms: buono, velocità di navigazione normale.
* Oltre 150 ms: lento, con lag o ritardi.

### C. "La mia connessione è stabile?" (Perdita di pacchetti e Jitter)

Se lanci una pallina da tennis contro un muro 10 volte, ti aspetti che rimbalzi indietro 10 volte.

* Se pinghi un sito web 50 volte e tornano solo 45 ping, hai il 10% di perdita di pacchetti (Packet Loss). Significa che la tua connessione è instabile e i dati si perdono lungo il percorso.
* Se alcuni ping impiegano 10 ms ma altri 500 ms, hai un Jitter elevato, cioè la tua connessione è incoerente.

## 3. IP, Hostname e FQDN: come indirizzare il tuo bersaglio

Quando dici alla nostra app di pingare qualcosa, devi indicarle dove inviare l'impulso. Puoi digitare tre diversi tipi di indirizzi:

### 1. Indirizzo IP (le coordinate GPS)

Un indirizzo IP (Internet Protocol) è una sequenza di numeri, come 192.168.1.1 o 142.250.190.46.

* Cos'è: è l'indirizzo esatto e fisico di un computer nella rete. I computer capiscono solo gli indirizzi IP.
* Analogia: pensalo come le esatte coordinate di latitudine e longitudine di una casa. È molto preciso, ma difficilissimo da memorizzare per gli esseri umani.

### 2. Hostname (il soprannome amichevole)

Un Hostname è un nome semplice e leggibile assegnato a un singolo dispositivo su una rete locale, come MyLaptop, OfficePrinter o LivingRoomSpeaker.

* Cos'è: è un soprannome locale. In casa puoi dire al telefono di pingare OfficePrinter e il router tradurrà quel soprannome nel suo indirizzo IP.
* Analogia: è come dire "la stanza della mamma" o "la cucina". Funziona perfettamente in casa tua, ma se vai a casa di uno sconosciuto e dici "vai nella stanza della mamma", non capirà quale stanza intendi.

### 3. FQDN (l'indirizzo postale completo)

FQDN sta per Fully Qualified Domain Name (nome di dominio completo). Alcuni esempi sono www.google.com, mail.yahoo.com o support.apple.com.

* Cos'è: è il nome completo, ufficiale e inequivocabile di un server su internet globale. Poiché contiene sia il soprannome host specifico (www) sia il dominio registrato (google.com), non c'è alcuna confusione su quale computer al mondo tu stia parlando.
* Analogia: pensalo come un indirizzo postale internazionale completo, con Nome, Via, Città e Paese. È unico e funziona da qualunque parte del mondo.

## 4. Funzioni speciali dello strumento Ping

Quando usi lo strumento Ping hai il pieno controllo su come viene eseguito il test:

* Personalizza la durata del Ping (Conteggio): invece di pingare all'infinito o eseguire un test fisso, puoi specificare esattamente quante volte pingare (ad esempio 10, 50 o 100 volte). Questo ti permette di eseguire un test di stabilità a lungo termine per diversi minuti, per vedere se il tuo Wi-Fi soffre di cadute intermittenti quando ti sposti in un'altra stanza.
* Interrompi in qualsiasi momento (pulsante Stop): se hai avviato un test di stabilità da 100 ping ma hai subito notato un'elevata perdita di pacchetti o log di errore, non devi aspettare che il test finisca. Puoi premere Stop in qualsiasi momento. La nostra app interromperà immediatamente il processo di rete in background, fermerà il consumo della batteria e calcolerà subito le statistiche medie finali dei ping che sono riusciti a completarsi.
