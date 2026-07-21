# Test prędkości

SimplyNet mierzy Twoje połączenie internetowe, przesyłając dane do serwera testowego i z powrotem oraz mierząc czas. Podawane są trzy liczby:

- **Pobieranie** — jak szybko dane docierają do Twojego urządzenia, w Mb/s. Więcej znaczy lepiej.
- **Wysyłanie** — jak szybko Twoje urządzenie wysyła dane na zewnątrz, w Mb/s. Więcej znaczy lepiej.
- **Ping** — opóźnienie podróży w obie strony do serwera, w milisekundach. Mniej znaczy
  lepiej.

## Wybór dostawcy

Lista rozwijana pod przyciskiem **Rozpocznij test** wybiera, który silnik testowy
zostanie użyty.

## Porównanie usług testu prędkości

| Cecha | Cloudflare (domyślnie) | Ookla |
|---|---|---|
| Cel pomiaru | Rzeczywista prędkość przeglądania internetu | Bezwzględna teoretyczna przepustowość łącza |
| Status prywatności | 100% anonimowo. Zero śledzenia | Zbiera IP, lokalizację i dane urządzenia |
| Metoda techniczna | Progresywne pobieranie jednym strumieniem | Nasycenie sieci wieloma strumieniami |
| Idealny do | Oceny codziennej wydajności internetu | Weryfikacji prędkości reklamowanych przez dostawcę |

### Przez Cloudflare (domyślnie)

Używa publicznych punktów końcowych Cloudflare `speed.cloudflare.com`. Nie jest wymagane konto ani dodatkowa zgoda, a poza normalnymi informacjami, które niesie każde żądanie strony (jak Twój adres IP, potrzebny do dostarczenia odpowiedzi), nie są udostępniane żadne identyfikatory osobowe.

To zalecana opcja dla większości użytkowników.

### Przez Ookla

Używa globalnej sieci serwerów Ookla speedtest.net — tej samej infrastruktury, która stoi za znaną usługą Speedtest. Serwery Ookla są obsługiwane przez podmioty zewnętrzne na całym świecie, więc test łączy się z tym serwerem, który jest najbliżej i osiągalny.

Ponieważ dotyczy to serwerów zewnętrznych, wybór Ookla prosi za pierwszym razem o Twoją zgodę. **Ookla zbiera i udostępnia Twój adres IP, identyfikatory urządzenia oraz dane o lokalizacji.** Twój wybór jest zapamiętywany, więc nie zostaniesz zapytany ponownie; w każdej chwili możesz wrócić do Cloudflare.

Gdy aktywna jest Ookla, przycisk **Rozpocznij test** zmienia kolor na bursztynowy jako przypomnienie, że używany jest silnik zewnętrzny. Cloudflare przywraca niebieski przycisk.

## Wskazówki dla dokładnych wyników

- Testuj przez Wi-Fi lub dane komórkowe, w zależności od tego, co chcesz zmierzyć.
- Zamknij inne aplikacje, które mogą korzystać z sieci.
- Uruchom test kilka razy — wyniki zmieniają się w zależności od warunków sieci i obciążenia serwera.
- Bardzo szybkie łącza mogą być ograniczone raczej przez urządzenie lub metodę testu niż przez Twoje rzeczywiste połączenie.

## Prywatność

Wyniki są przechowywane wyłącznie na Twoim urządzeniu w sekcji **Poprzednie pomiary**. Możesz je w każdej chwili wyczyścić w sekcji historii. SimplyNet nigdzie nie przesyła Twoich wyników.
