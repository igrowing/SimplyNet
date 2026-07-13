# Co je „Who Is“ a překlad DNS?

Přemýšleli jste někdy, kdo vlastně vlastní web jako google.com? Nebo jak váš telefon automaticky najde ten správný počítač na druhém konci světa jen z webové adresy?

Když použijete nástroj Who Is..., odhrnujete oponu administrativního adresáře internetu. Ke zkoumání libovolné domény nebo IP adresy používá tři hlavní funkce.

## 1. Co je WHOIS? (Digitální katastr nemovitostí)

Každý název webu (jako yourwebsite.com) je kus digitální nemovitosti. Stejně jako při koupi fyzického domu nebo registraci auta nemůžete doménu vlastnit anonymně, aniž byste ji zaregistrovali.

WHOIS (doslova otázka *„Kdo je za tuto doménu zodpovědný?“*) je rozsáhlá, veřejná databáze, která eviduje údaje o vlastnictví každého registrovaného doménového jména a IP adresy na světě.

### Přirovnání: registr vozidel nebo katastr nemovitostí

Když si vyhledáte SPZ v registru vozidel, získáte záznam o tom, kdo auto vlastní, kdy bylo zaregistrováno a jak vlastníka kontaktovat. Vyhledávání WHOIS dělá přesně totéž pro web.

### Jaké informace vám ukáže?

* Držitel (registrant): jméno osoby nebo firmy, která doménu koupila. (Poznámka: mnoho jednotlivců používá služby „ochrany soukromí“, aby skryli své domácí adresy, ale údaje hostingové společnosti budou stále viditelné.)
* Důležitá data: kdy přesně byl název webu poprvé koupen, kdy byl naposledy aktualizován a — nejdůležitější — kdy vyprší.
* Registrátor: digitální „obchod“, kde vlastník doménu koupil (jako GoDaddy, Namecheap nebo Google Domains).

## 2. Co je překlad DNS? (Telefonní seznam internetu)

Počítače jsou neuvěřitelně chytré v matematice, ale hrozné v jazyce. Nerozumějí názvům jako `netflix.com`. Aby spolu mohly komunikovat, používají číselné souřadnice zvané IP adresy (jako `142.250.190.46`).

Lidé jsou naopak skvělí na jména, ale hrozní v zapamatování náhodných řetězců čísel.

**Překlad DNS (Domain Name System)** je mostem mezi těmito dvěma světy. Překládá pro člověka příjemné jméno na pro počítač příjemné číslo.

### Přirovnání: aplikace kontaktů ve vašem telefonu

Když chcete zavolat příteli Alexovi, nezapamatováváte si jeho desetimístné telefonní číslo. Prostě ťuknete na „Alex“ ve svém seznamu kontaktů a telefon toto jméno automaticky přeloží na číselné telefonní číslo a vytočí je.

* DNS je globální seznam kontaktů pro celý internet. * Když v naší aplikaci vyhledáte doménu, překlad DNS okamžitě běží na pozadí a říká vám: „Hele, google.com aktuálně funguje na telefonním čísle 142.250.190.46.“

## 3. Co je zpětný překlad? (Digitální identifikace volajícího)

Ale co se stane, pokud máte číslo (IP adresu) a chcete znát jméno (web)? Zde přichází na řadu zpětný překlad (známý také jako reverzní DNS nebo dotaz PTR).

Pokud se nějaký podivný počítač pokouší připojit k vaší domácí síti nebo pokud vidíte divnou IP adresu v protokolech své sítě, můžete tuto IP adresu vložit do našeho nástroje. Aplikace se zeptá globálního adresáře: „Jaké jméno webu je zaregistrováno na tomto konkrétním čísle?“

### Přirovnání: identifikace volajícího (nebo zpětné vyhledání telefonu)

Pokud vám zazvoní telefon a zobrazí neznámé číslo jako `1-800-555-0199`, možná budete váhat, zda ho zvednout. Ale pokud identifikace volajícího toto číslo přeloží a zobrazí **„Podpora Apple“**, okamžitě víte, kdo volá.

* Zpětný překlad je identifikace volajícího pro internetové adresy.
* Umožňuje přeložit anonymní, zastrašující číslo jako `172.217.16.142` zpět na přátelské, rozpoznatelné jméno jako `google.com`.

## Shrnutí nástroje „Who Is...“

Kombinací těchto tří funkcí vám náš nástroj poskytne kompletní „prověrku“ libovolného digitálního cíle:

1. Překlad DNS vám sdělí IP adresu („telefonní číslo“) názvu webu.
2. Zpětný překlad vám sdělí název webu („identifikace volajícího“) záhadné IP adresy.
3. WHOIS vám sdělí skutečného zákonného vlastníka, registrátora a data vypršení této „nemovitosti“.
