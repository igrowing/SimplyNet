# Che cos'è "Who Is" e la risoluzione DNS?

Ti sei mai chiesto chi possiede davvero un sito web come google.com? O come fa il tuo telefono a trovare automaticamente il computer giusto dall'altra parte del mondo partendo solo da un indirizzo web?

Quando usi lo strumento Who Is..., stai scostando la tenda sull'elenco amministrativo di internet. Utilizza tre funzioni principali per investigare qualsiasi dominio o indirizzo IP.

## 1. Che cos'è WHOIS? (Il catasto digitale)

Ogni nome di un sito web (come iltuosito.com) è una porzione di proprietà immobiliare digitale. Proprio come comprare una casa fisica o immatricolare un'auto, non puoi possedere un dominio in modo anonimo senza registrarlo.

WHOIS (letteralmente chiedere *"Chi è responsabile di questo dominio?"*) è un enorme database pubblico che registra i dettagli di proprietà di ogni nome di dominio e indirizzo IP registrato sulla Terra.

### L'analogia: la motorizzazione o il catasto immobiliare

Quando cerchi una targa alla motorizzazione (DMV), ottieni un registro di chi possiede l'auto, quando è stata immatricolata e come contattare il proprietario. Una ricerca WHOIS fa esattamente la stessa cosa per un sito web.

### Quali informazioni ti mostra?

* Il Registrante (Registrant): il nome della persona o azienda che ha acquistato il dominio. (Nota: molte persone usano servizi di "protezione della privacy" per nascondere gli indirizzi di casa, ma i dettagli dell'azienda di hosting saranno comunque visibili).
* Date importanti: esattamente quando il nome del sito è stato acquistato per la prima volta, quando è stato aggiornato l'ultima volta e—cosa più importante—quando scade.
* Il Registrar: il "negozio" digitale dove il proprietario ha acquistato il dominio (come GoDaddy, Namecheap o Google Domains).

## 2. Che cos'è la risoluzione DNS? (La rubrica telefonica di internet)

I computer sono incredibilmente bravi in matematica, ma pessimi con le lingue. Non capiscono nomi come `netflix.com`. Per parlare tra loro, usano coordinate numeriche chiamate indirizzi IP (come `142.250.190.46`).

Gli esseri umani, invece, sono bravi con i nomi ma pessimi nel memorizzare stringhe casuali di numeri.

**La risoluzione DNS (Domain Name System)** è il ponte tra questi due mondi. Traduce un nome facile per l'uomo in un numero facile per il computer.

### L'analogia: l'app Contatti del tuo telefono

Quando vuoi chiamare il tuo amico Alex, non memorizzi il suo numero di telefono a 10 cifre. Tocchi semplicemente "Alex" nella tua lista contatti e il telefono traduce automaticamente quel nome nel numero telefonico numerico e lo compone.

* Il DNS è la lista contatti globale per tutta internet. * Quando cerchi un dominio nella nostra app, la risoluzione DNS viene eseguita istantaneamente in background e ti dice: "Ehi, google.com attualmente opera al numero di telefono 142.250.190.46."

## 3. Che cos'è la risoluzione inversa? (L'ID chiamante digitale)

Ma cosa succede se hai il numero (l'indirizzo IP) e vuoi conoscere il nome (il sito web)? È qui che entra in gioco la risoluzione inversa (nota anche come DNS inverso o lookup PTR).

Se uno strano computer sta cercando di connettersi alla tua rete domestica, o se vedi uno strano indirizzo IP nei log della rete, puoi incollare quell'indirizzo IP nel nostro strumento. L'app chiederà all'elenco globale: "Quale nome di sito web è registrato per questo numero specifico?"

### L'analogia: l'ID chiamante (o ricerca telefonica inversa)

Se il telefono squilla e mostra un numero sconosciuto come `1-800-555-0199`, potresti esitare a rispondere. Ma se l'ID chiamante del telefono traduce quel numero e mostra **"Supporto Apple"**, sai subito chi sta chiamando.

* La risoluzione inversa è l'ID chiamante per gli indirizzi internet.
* Ti permette di tradurre un numero anonimo e intimidatorio come `172.217.16.142` in un nome amichevole e riconoscibile come `google.com`.

## Riepilogo dello strumento "Who Is..."

Combinando queste tre funzioni, il nostro strumento ti offre un completo "controllo dei precedenti" su qualsiasi bersaglio digitale:

1. La risoluzione DNS ti dice l'indirizzo IP (il "numero di telefono") di un nome di sito web.
2. La risoluzione inversa ti dice il nome del sito web (l'"ID chiamante") di un misterioso indirizzo IP.
3. WHOIS ti dice il vero proprietario legale, il registrar e le date di scadenza di quella proprietà.
