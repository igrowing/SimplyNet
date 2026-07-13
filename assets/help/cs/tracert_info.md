# Co je traceroute?

Obrazovka „Traceroute“ plná ubíhajících IP adres a milisekundových čísel může působit neuvěřitelně zastrašujícím dojmem.

Ale zbavíte-li ji počítačového žargonu, je traceroute ve skutečnosti jedním z nejjednodušších a nejelegantnějších nástrojů na internetu.

## 1. Přirovnání: sledování poštovní zásilky

Představte si, že žijete v Římě v Itálii a chcete poslat fyzický dopis příteli v New Yorku v USA.

Váš dopis se přes Atlantik magicky neteleportuje. Místo toho se vydá na cestu:

1. Začíná na vaší místní poště ve čtvrti.
2. Naloží se na náklaďák do regionálního třídicího centra v Římě.
3. Odletí do mezinárodního leteckého uzlu v Londýně.
4. Přeletí přes oceán do celního zařízení v New Yorku.
5. Zamíří do místní doručovací stanice na Manhattanu.
6. Nakonec dorazí do domu vašeho přítele.

V digitálním světě pokaždé, když navštívíte web (jako Google, Netflix nebo váš oblíbený blog), váš telefon posílá po celém světě miliony drobných digitálních obálek zvaných „pakety“.

Stejně jako váš dopis se ani tyto pakety neteleportují. Přeskakují z jednoho fyzického počítače (zvaného router) na druhý, dokud nedorazí do cíle.

  💡 Traceroute je jednoduše „digitální sledování zásilky“. Odhalí přesný seznam „pošt“ (routerů), na kterých se vaše data cestou do cíle zastavila, a přesně kolik milisekund trvalo projít každou zastávkou.

## 2. Proč jej potřebujeme?

Pokud vaše zásilka nedorazí do New Yorku nebo pokud jí to tam trvá tři týdny, standardní sledování zásilek vám přesně řekne, kde se něco pokazilo (např. „Uvízlo na celnici v Londýně“).

Traceroute dělá přesně totéž pro vaše internetové připojení. Používá se k vyřešení dvou hlavních záhad:

### A. „Kde se připojení přerušuje?“

Pokud se web odmítá načíst, je porouchaná vaše domácí Wi-Fi? Má váš poskytovatel internetu (ISP) výpadek? Nebo server webu úplně spadl?

Traceroute vám přesně ukáže, kde cesta zhasne. Pokud se zastávky dostanou k číslu 3 (váš ISP) a poté je vše následující prázdný řádek, víte, že internet je porouchaný přímo na prahu vašeho poskytovatele.

### B. „Proč je moje připojení tak pomalé?“

Pokud hra seká nebo se video načítá, traceroute dokáže změřit dobu cesty (zvanou latence nebo ping) ke každé jednotlivé zastávce na trase.

Pokud zastávky 1 až 5 trvají svižných 15 milisekund, ale zastávka 6 náhle vyskočí na 300 milisekund, našli jste přesně ten router, který způsobuje úzké hrdlo.

## 3. Jak to funguje?

Když vyšlete paket dat do internetu, routery po cestě jsou neuvěřitelně vytížené. Nemají čas psát „přijal jsem tento paket!“ a posílat vám zprávu zpět. Prostě jej předají dál co nejrychleji.

Jak tedy váš telefon donutí tyto routery, aby se identifikovaly? Pomocí chytrého triku „došlo palivo“.

Každý paket dat má na sobě skryté počítadlo zvané TTL (Time to Live). Představte si TTL jako digitální palivovou nádrž. Pokaždé, když paket projde routerem, tento router odečte 1 z palivové nádrže. Pokud palivová nádrž dosáhne nuly ($0$), je router podle pravidel internetu povinen paket zničit a poslat vašemu telefonu zprávu: „Promiňte, vaší zásilce došlo palivo na mé adrese!“

Traceroute tohoto pravidla systematicky využívá:

* Zastávka 1: Váš telefon pošle paket s 1 jednotkou paliva. Dorazí k vašemu domácímu Wi-Fi routeru. Router odečte 1. Palivová nádrž je nyní 0. Router paket zahodí a pošle chybovou zprávu zpět vašemu telefonu. Bingo! Zastávka 1 (váš domácí router) se právě identifikovala.
* Zastávka 2: Váš telefon pošle nový paket s 2 jednotkami paliva. Projde vaším domácím routerem (klesne na 1 palivo) a dorazí k místnímu uzlu vašeho poskytovatele internetu. Uzel odečte 1. Paliva je nyní 0. Uzel paket zahodí a pošle chybovou zprávu. Bingo! Zastávka 2 se právě identifikovala.
* Zastávka 3: Váš telefon pošle paket s 3 jednotkami paliva...

Váš telefon tento proces opakuje a pokaždé zvýší limit paliva o 1, dokud paket konečně nemá dost paliva, aby dorazil do skutečného cíle. Sesbíráním všech chybových zpráv „došlo palivo“ dokáže váš telefon zrekonstruovat dokonalou, sekvenční mapu celé cesty.


## Co je „skrytý uzel“ (* * *)?

Někdy se krok ve vašem traceroute zobrazí jako * * * nebo „Skrytý uzel“ bez názvu.
Nepanikařte — neznamená to, že váš internet je porouchaný! Mnoho velkých firem, vládních sítí a bezpečnostních firewallů své funkce „hlášení chyb“ záměrně vypíná. Když vašemu paketu dojde palivo uvnitř jejich systému, tiše jej zahodí do koše, aniž by vám poslaly chybu „došlo palivo“. Vaše data i tak bezpečně projdou, jen dávají přednost anonymnímu cestování z bezpečnostních důvodů!
