# Co je ping?

Přemýšleli jste někdy, co se děje, když váš počítač nebo telefon „pingne“ web? Nebo proč vás technická podpora vždy žádá, abyste spustili „ping test“, když se internet zpomalí?

Navzdory technicky znějícímu názvu je ping tím nejjednodušším diagnostickým nástrojem v celé počítačové síti. Zde je vysvětlení srozumitelné každému: co to je, co to dělá a jak to funguje v naší aplikaci.

## 1. Přirovnání: ponorkový sonar (neboli ozvěna)

Pojem „ping“ ve skutečnosti pochází z technologie ponorkového sonaru.

Představte si ponorku plující v temném oceánu. Aby zjistila, zda je poblíž hora nebo jiná loď, vyšle do vody zvukový impuls — hlasité „Ping!“.

Pokud zvuk narazí na nějaký objekt, odrazí se zpět jako ozvěna.

Změřením doby, za kterou se ozvěna vrátí, dokáže ponorka přesně vypočítat, jak daleko je objekt vzdálený.

Pokud se žádná ozvěna nevrátí, ponorka ví, že tam venku nic není.

V digitálním světě dělá váš telefon přesně to samé. Vyšle drobný digitální impuls do jiného počítače nebo na web a čeká, až tento počítač impuls odrazí zpět.

## 2. Proč jej potřebujeme?

Ping vám pomáhá odpovědět na tři zásadní otázky ohledně vašeho připojení:

### A. „Je ten počítač zapnutý a připojený?“ (Dostupnost)

Pokud pingnete zařízení (například chytrou televizi, router nebo google.com) a ono odpoví ozvěnou, víte, že je zapnuté a připojené k síti. Pokud ping selže, zařízení je buď vypnuté, kabel je odpojený, nebo provoz blokuje firewall.

### B. „Jak rychlé je moje připojení?“ (Latence)

Doba, za kterou váš ping absolvuje cestu tam a zpět, se měří v milisekundách (ms).

* 1 až 20 ms: bleskurychlé (skvělé pro online hraní nebo videohovory).
* 20 až 100 ms: dobré, běžná rychlost prohlížení.
* Přes 150 ms: pomalé, trhané nebo zpožděné.

### C. „Je moje připojení stabilní?“ (Ztráta paketů a jitter)

Když hodíte tenisák na zeď 10krát, čekáte, že se 10krát odrazí zpět.

* Pokud web pingnete 50krát a vrátí se jen 45 pingů, máte 10% ztrátu paketů. To znamená, že vaše připojení je nestabilní a data se během přenosu ztrácejí.
* Pokud některé pingy trvají 10 ms, ale jiné 500 ms, máte vysoký jitter, což znamená, že vaše připojení je nekonzistentní.

## 3. IP, název hostitele a FQDN: jak adresovat svůj cíl

Když aplikaci řeknete, aby něco pingla, musíte jí sdělit, kam má impuls poslat. Můžete zadat tři různé typy adres:

### 1. IP adresa (GPS souřadnice)

IP (Internet Protocol) adresa je posloupnost čísel, například 192.168.1.1 nebo 142.250.190.46.

* Co to je: je to přesná, fyzická adresa počítače v síti. Počítače rozumějí pouze IP adresám.
* Přirovnání: představte si to jako přesné souřadnice zeměpisné šířky a délky domu. Je to velmi přesné, ale pro lidi těžko zapamatovatelné.

### 2. Název hostitele (přátelská přezdívka)

Název hostitele je jednoduché, pro člověka čitelné jméno přiřazené jednomu zařízení v místní síti, například MyLaptop, OfficePrinter nebo LivingRoomSpeaker.

* Co to je: je to místní přezdívka. Doma můžete telefonu říct, aby pingl OfficePrinter, a váš router tuto přezdívku přeloží na její IP adresu.
* Přirovnání: je to jako říct „mámin pokoj“ nebo „kuchyně“. U vás doma to funguje perfektně, ale když přijdete do cizího domu a řeknete „Běž do máminého pokoje“, nebudou vědět, který pokoj máte na mysli.

### 3. FQDN (úplná poštovní adresa)

FQDN znamená Fully Qualified Domain Name (plně kvalifikovaný název domény). Příklady zahrnují www.google.com, mail.yahoo.com nebo support.apple.com.

* Co to je: je to úplný, oficiální, jednoznačný název serveru na globálním internetu. Protože obsahuje jak konkrétní přezdívku hostitele (www), tak registrovanou doménu (google.com), nepanuje žádná nejistota o tom, o kterém počítači na světě mluvíte.
* Přirovnání: představte si to jako úplnou mezinárodní poštovní adresu včetně jména, ulice, města a země. Je jedinečná a funguje odkudkoli na světě.

## 4. Speciální funkce nástroje Ping

Když používáte nástroj Ping, máte úplnou kontrolu nad tím, jak test probíhá:

* Přizpůsobte si, jak dlouho pingovat (počet): místo nekonečného pingování nebo pevně daného testu můžete přesně určit, kolikrát pingnout (například 10, 50 nebo 100krát). To vám umožní spustit dlouhodobý test stability po dobu několika minut a zjistit, zda vaše Wi-Fi netrpí občasnými výpadky, když se přesunete do jiné místnosti.
* Kdykoli přerušit (tlačítko Stop): pokud jste spustili test stability se 100 pingy, ale okamžitě jste zaznamenali vysokou ztrátu paketů nebo chybové záznamy, nemusíte sedět a čekat, až test skončí. Kdykoli můžete stisknout Stop. Naše aplikace okamžitě přeruší síťový proces na pozadí, zastaví vybíjení baterie a ihned spočítá konečné průměrné statistiky z pingů, které se stihly dokončit.
