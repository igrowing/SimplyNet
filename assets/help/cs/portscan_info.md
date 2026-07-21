# Co je skenování portů?

Jak hackeři nebo bezpečnostní experti nacházejí na zařízení zranitelná místa?

Dělají to pomocí nástroje zvaného skenování portů.

## 1. Přirovnání: zabezpečená budova s 65 536 dveřmi

Představte si obrovskou, zabezpečenou kancelářskou budovu nebo bytový komplex.

* Hostitel (IP adresa nebo doména) je poštovní adresa budovy. Dovede vás k hlavnímu vchodu.
* Uvnitř má budova přesně 65 536 očíslovaných dveří (nazývaných porty).
* Za každými dveřmi je konkrétní firma nebo služba. Například za dveřmi 80 sedí správce webu a za dveřmi 554 je stream z bezpečnostní kamery.

  💡 Skenování portů je jako ostraha, která prochází chodbami, klepe na dveře a kontroluje, které jsou otevřené, zamčené nebo úplně opuštěné.

Pokud jsou dveře otevřené, znamená to, že za nimi aktivně běží služba a naslouchá připojením. Pokud jsou zavřené, dveře jsou zamčené a nikdo není uvnitř.

## 2. Výběr cíle: dobře známé porty vs. vlastní rozsah

Můžete si vybrat, které „dveře“ chcete zkontrolovat:

### A. Dobře známé porty (kontrola hlavní haly)

Z 65 536 možných dveří je naprostá většina prázdná. Ve výchozím nastavení internet rezervuje prvních 1024 dveří pro standardní, oficiální služby.

* Dveře 80: standardní weby (HTTP)
* Dveře 443: zabezpečené weby (HTTPS)
* Dveře 21: sdílení souborů (FTP)
* Dveře 22: zabezpečené vzdálené ovládání (SSH)
* Jak vám to pomáhá: skenování dobře známých portů je jako kontrola pouze hlavních hal a nakládacích ramp budovy. Je neuvěřitelně rychlé (trvá jen pár sekund) a pokrývá 99 % toho, co běžný uživatel hledá.

### B. Uživatelsky definovaný rozsah (prohledání každé místnosti)

Někdy se vlastní aplikace, zařízení chytré domácnosti nebo kamery skrývají za neobvyklými čísly dveří (jako dveře 8080 nebo dveře 32400), aby zůstaly mimo dohled.

* Jak vám to pomáhá: aplikaci můžete zadat, aby prohledala vlastní rozsah — například od dveří 1 po dveře 2048. Aplikace pečlivě zaklepe na každé z těchto dveří, jedny po druhých, aby našla skryté služby.

## 3. Protokoly: TCP vs. UDP

„Dveře“ počítače mluví dvěma různými jazyky. V závislosti na vašem nastavení bude aplikace klepat různými způsoby:

### 1. TCP (zdvořilé podání ruky)

TCP (Transmission Control Protocol) je nejběžnější protokol na internetu. Je navržen pro 100% přesnost.

* Styl klepání: aplikace zaklepe na dveře, počká, až někdo otevře, potřese mu rukou, řekne „Ahoj!“ a poté zdvořile odejde.
* Přirovnání: jako poslání doporučeného dopisu. Je extrémně spolehlivé pro potvrzení, zda je někdo doma, ale „podání ruky“ trvá zlomek sekundy.

### 2. UDP (hoď pohlednici a běž)

UDP (User Datagram Protocol) je navržen pro čistou rychlost, často se používá pro živé videopřenosy nebo online hraní.

* Styl klepání: aplikace prohodí pohlednici poštovní štěrbinou a na zlomek sekundy naslouchá, zda někdo uvnitř zakřičí zpět. Nečeká na podání ruky.
* Přirovnání: jako přehození papírové vlaštovky přes plot. Je to neuvěřitelně rychlé, ale pokud nikdo nezakřičí zpět, je těžší si být na 100 % jistý, zda je místnost prázdná, nebo vaši vlaštovku jen ignorovali.

## 4. Proč rozsáhlé skenování zabere tolik času?

*„Proč mi skenování trvá tak dlouho?“* Odpověď je jednoduchá matematika!

* Pokud skenujete dobře známé porty pouze přes TCP, aplikace zkontroluje asi 60 dveří. Skončí bleskově.
* Pokud rozšíříte rozsah od 1 do 10 000 a vyberete TCP i UDP, aplikace musí fyzicky provést **20 000** jednotlivých zaklepání (**10 000** pro TCP a **10 000** pro UDP).

Protože aplikace musí u každých dveří počkat drobný zlomek sekundy, aby zjistila, zda zařízení odpoví (aby nepřehlédla pomalu reagující kameru nebo router), kontrola desítek tisíc dveří vyžaduje trpělivost.

Chcete-li ušetřit čas, vždy začněte skenováním „dobře známých“ portů! Vlastní skenování se širokým rozsahem spouštějte, jen když ve své síti pátráte po velmi konkrétním, skrytém zařízení.
