# Czym jest „Who Is” i rozwiązywanie DNS?

Czy zastanawiałeś się kiedyś, kto właściwie jest właścicielem strony takiej jak google.com? Albo jak Twój telefon automatycznie znajduje właściwy komputer po drugiej stronie świata tylko na podstawie adresu internetowego?

Kiedy używasz narzędzia Who Is..., odsłaniasz kurtynę nad administracyjnym katalogiem internetu. Do badania dowolnej domeny lub adresu IP wykorzystuje ono trzy główne funkcje.

## 1. Czym jest WHOIS? (Cyfrowa księga wieczysta)

Każda nazwa strony (jak yourwebsite.com) to kawałek cyfrowej nieruchomości. Podobnie jak przy kupnie fizycznego domu lub rejestracji samochodu, nie możesz posiadać domeny anonimowo bez jej zarejestrowania.

WHOIS (dosłownie pytanie *„Kto odpowiada za tę domenę?”*) to ogromna, publiczna baza danych, która rejestruje szczegóły własności każdej zarejestrowanej nazwy domeny i adresu IP na świecie.

### Analogia: wydział komunikacji lub rejestr nieruchomości

Kiedy sprawdzasz tablicę rejestracyjną w wydziale komunikacji, otrzymujesz zapis, kto jest właścicielem samochodu, kiedy został zarejestrowany i jak się z nim skontaktować. Wyszukiwanie WHOIS robi dokładnie to samo dla strony internetowej.

### Jakie informacje Ci pokazuje?

* Rejestrujący (registrant): imię osoby lub nazwa firmy, która kupiła domenę. (Uwaga: wiele osób korzysta z usług „ochrony prywatności”, aby ukryć swoje domowe adresy, ale dane firmy hostingowej nadal będą widoczne.)
* Ważne daty: kiedy dokładnie nazwa strony została po raz pierwszy kupiona, kiedy była ostatnio aktualizowana i — co najważniejsze — kiedy wygasa.
* Rejestrator: cyfrowy „sklep”, w którym właściciel kupił domenę (jak GoDaddy, Namecheap lub Google Domains).

## 2. Czym jest rozwiązywanie DNS? (Książka telefoniczna internetu)

Komputery są niesamowicie dobre w matematyce, ale beznadziejne w językach. Nie rozumieją nazw takich jak `netflix.com`. Aby rozmawiać ze sobą, używają współrzędnych liczbowych zwanych adresami IP (jak `142.250.190.46`).

Ludzie z kolei świetnie radzą sobie z nazwami, ale beznadziejnie z zapamiętywaniem losowych ciągów cyfr.

**Rozwiązywanie DNS (Domain Name System)** to most między tymi dwoma światami. Tłumaczy przyjazną dla człowieka nazwę na przyjazną dla komputera liczbę.

### Analogia: aplikacja kontaktów w Twoim telefonie

Kiedy chcesz zadzwonić do znajomego Alexa, nie zapamiętujesz jego 10-cyfrowego numeru telefonu. Po prostu stukasz „Alex” na liście kontaktów, a telefon automatycznie tłumaczy tę nazwę na numeryczny numer telefonu i go wybiera.

* DNS to globalna lista kontaktów dla całego internetu. * Kiedy wyszukujesz domenę w naszej aplikacji, rozwiązywanie DNS natychmiast działa w tle, mówiąc Ci: „Hej, google.com działa obecnie pod numerem telefonu 142.250.190.46”.

## 3. Czym jest rozwiązywanie odwrotne? (Cyfrowa identyfikacja dzwoniącego)

Ale co się dzieje, jeśli masz numer (adres IP) i chcesz poznać nazwę (stronę)? Tu wkracza rozwiązywanie odwrotne (znane też jako odwrotny DNS lub zapytanie PTR).

Jeśli jakiś dziwny komputer próbuje połączyć się z Twoją siecią domową albo jeśli widzisz dziwny adres IP w dziennikach sieci, możesz wkleić ten adres IP do naszego narzędzia. Aplikacja zapyta globalny katalog: „Jaka nazwa strony jest zarejestrowana pod tym konkretnym numerem?”

### Analogia: identyfikacja dzwoniącego (lub odwrotne wyszukiwanie numeru)

Jeśli Twój telefon dzwoni i pokazuje nieznany numer taki jak `1-800-555-0199`, możesz wahać się przed odebraniem. Ale jeśli identyfikacja dzwoniącego przetłumaczy ten numer i wyświetli **„Pomoc Apple”**, natychmiast wiesz, kto dzwoni.

* Rozwiązywanie odwrotne to identyfikacja dzwoniącego dla adresów internetowych.
* Pozwala przetłumaczyć anonimowy, onieśmielający numer taki jak `172.217.16.142` z powrotem na przyjazną, rozpoznawalną nazwę taką jak `google.com`.

## Podsumowanie narzędzia „Who Is...”

Łącząc te trzy funkcje, nasze narzędzie daje Ci pełne „sprawdzenie” dowolnego cyfrowego celu:

1. Rozwiązywanie DNS podaje Ci adres IP („numer telefonu”) nazwy strony.
2. Rozwiązywanie odwrotne podaje Ci nazwę strony („identyfikacja dzwoniącego”) tajemniczego adresu IP.
3. WHOIS podaje Ci rzeczywistego prawnego właściciela, rejestratora i daty wygaśnięcia tej „nieruchomości”.
