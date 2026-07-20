# Test rychlosti

SimplyNet měří vaše internetové připojení tím, že přenáší data na testovací server a zpět a měří čas. Uvádí se tři čísla:

- **Stahování** — jak rychle data dorazí do vašeho zařízení, v Mb/s. Vyšší je lepší.
- **Odesílání** — jak rychle vaše zařízení odesílá data ven, v Mb/s. Vyšší je lepší.
- **Ping** — zpoždění cesty tam a zpět k serveru, v milisekundách. Nižší je
  lepší.

## Výběr poskytovatele

Rozevírací nabídka pod tlačítkem **Spustit test** vybírá, jaký testovací backend
se použije.

## Porovnání služeb testu rychlosti

| Vlastnost | Cloudflare (výchozí) | Ookla |
|---|---|---|
| Cíl měření | Reálná rychlost prohlížení webu | Absolutní teoretická kapacita linky |
| Stav soukromí | 100% anonymní. Žádné sledování | Sbírá IP, polohu a údaje o zařízení |
| Technická metoda | Progresivní stahování jedním proudem | Zahlcení sítě více proudy |
| Ideální pro | Posouzení každodenního výkonu internetu | Ověření rychlostí inzerovaných poskytovatelem |

### Přes Cloudflare (výchozí)

Používá veřejné koncové body Cloudflare `speed.cloudflare.com`. Není vyžadován žádný účet ani další souhlas a nesdílejí se žádné osobní identifikátory nad rámec běžných informací, které nese každý požadavek na web (například vaše IP adresa, potřebná k doručení odpovědi).

Toto je doporučená možnost pro většinu uživatelů.

### Přes Ookla

Používá globální síť serverů Ookla speedtest.net — stejnou infrastrukturu, která stojí za známou službou Speedtest. Servery Ookla provozují třetí strany po celém světě, takže se test připojí k tomu serveru, který je nejblíže a dostupný.

Protože to zahrnuje servery třetích stran, výběr Ookla si při prvním použití vyžádá váš souhlas. **Ookla sbírá a sdílí vaši IP adresu, identifikátory zařízení a údaje o poloze.** Vaše volba se zapamatuje, takže nebudete znovu dotazováni; kdykoli se můžete vrátit k Cloudflare.

Když je aktivní Ookla, tlačítko **Spustit test** zežloutne jako připomínka, že se používá backend třetí strany. Cloudflare obnoví modré tlačítko.

## Tipy pro přesné výsledky

- Testujte přes Wi-Fi nebo mobilní data podle toho, co chcete měřit.
- Zavřete ostatní aplikace, které mohou využívat síť.
- Spusťte test několikrát — výsledky se liší podle podmínek sítě a zatížení serveru.
- Velmi rychlé linky mohou být omezeny spíše zařízením nebo metodou testu než vaším skutečným připojením.

## Soukromí

Výsledky se ukládají pouze ve vašem zařízení pod položkou **Předchozí měření**. Kdykoli je můžete vymazat v sekci historie. SimplyNet vaše výsledky nikam nenahrává.
