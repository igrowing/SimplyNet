# Czym jest traceroute?

Ekran „Traceroute” pełen przewijających się adresów IP i liczb milisekundowych może wyglądać niesamowicie onieśmielająco.

Ale pozbawiony komputerowego żargonu traceroute jest w rzeczywistości jednym z najprostszych i najbardziej eleganckich narzędzi w internecie.

## 1. Analogia: śledzenie przesyłki pocztowej

Wyobraź sobie, że mieszkasz w Rzymie we Włoszech i chcesz wysłać papierowy list do znajomego w Nowym Jorku w USA.

Twój list nie teleportuje się magicznie przez Atlantyk. Zamiast tego wyrusza w podróż:

1. Zaczyna na lokalnej poczcie w Twojej dzielnicy.
2. Zostaje załadowany na ciężarówkę do regionalnego centrum sortowania w Rzymie.
3. Zostaje przewieziony samolotem do międzynarodowego węzła lotniczego w Londynie.
4. Przelatuje nad oceanem do urzędu celnego w Nowym Jorku.
5. Trafia do lokalnej stacji doręczeń na Manhattanie.
6. W końcu dociera do domu Twojego znajomego.

W świecie cyfrowym za każdym razem, gdy odwiedzasz stronę internetową (jak Google, Netflix lub Twój ulubiony blog), Twój telefon wysyła po całym świecie miliony maleńkich cyfrowych kopert zwanych „pakietami”.

Tak jak Twój list, te pakiety się nie teleportują. Przeskakują z jednego fizycznego komputera (zwanego routerem) na drugi, aż dotrą do celu.

  💡 Traceroute to po prostu „cyfrowe śledzenie przesyłki”. Ujawnia dokładną listę „urzędów pocztowych” (routerów), na których zatrzymały się Twoje dane w drodze do celu, oraz dokładnie ile milisekund zajęło przejście przez każdy przystanek.

## 2. Dlaczego go potrzebujemy?

Jeśli Twoja przesyłka nie dotrze do Nowego Jorku lub jeśli zajmie jej to trzy tygodnie, standardowy tracker przesyłek dokładnie powie Ci, gdzie coś poszło nie tak (np. „Utknęło na cle w Londynie”).

Traceroute robi dokładnie to samo dla Twojego połączenia internetowego. Służy do rozwiązania dwóch głównych zagadek:

### A. „Gdzie połączenie się przerywa?”

Jeśli strona odmawia załadowania, czy to Twoje domowe Wi-Fi jest zepsute? Czy Twój dostawca internetu (ISP) ma awarię? A może serwer strony całkowicie się zawiesił?

Traceroute pokazuje dokładnie, gdzie trasa gaśnie. Jeśli przystanki dochodzą do numeru 3 (Twój ISP), a potem wszystko po nim to pusty wiersz, wiesz, że internet jest zepsuty tuż na progu Twojego dostawcy.

### B. „Dlaczego moje połączenie jest tak wolne?”

Jeśli gra laguje lub wideo się buforuje, traceroute może zmierzyć czas podróży (zwany opóźnieniem lub pingiem) do każdego pojedynczego przystanku po drodze.

Jeśli przystanki od 1 do 5 zajmują szybkie 15 milisekund, ale przystanek 6 nagle skacze do 300 milisekund, znalazłeś dokładnie ten router, który powoduje wąskie gardło.

## 3. Jak to działa?

Kiedy wysyłasz pakiet danych w internet, routery po drodze są niesamowicie zajęte. Nie mają czasu pisać „otrzymałem ten pakiet!” i odsyłać Ci wiadomości. Po prostu przekazują go dalej tak szybko, jak to możliwe.

Jak więc Twój telefon zmusza te routery, aby się przedstawiły? Za pomocą sprytnej sztuczki „brak paliwa”.

Każdy pakiet danych ma na sobie ukryty licznik zwany TTL (Time to Live). Pomyśl o TTL jak o cyfrowym baku z paliwem. Za każdym razem, gdy pakiet przechodzi przez router, ten router odejmuje 1 z baku. Jeśli bak osiągnie zero ($0$), router jest zgodnie z zasadami internetu zobowiązany zniszczyć pakiet i odesłać do Twojego telefonu wiadomość: „Przepraszam, Twojej przesyłce skończyło się paliwo pod moim adresem!”

Traceroute systematycznie wykorzystuje tę zasadę:

* Przystanek 1: Twój telefon wysyła pakiet z 1 jednostką paliwa. Dociera do Twojego domowego routera Wi-Fi. Router odejmuje 1. Bak paliwa wynosi teraz 0. Router odrzuca pakiet i odsyła komunikat o błędzie do Twojego telefonu. Bingo! Przystanek 1 (Twój domowy router) właśnie się przedstawił.
* Przystanek 2: Twój telefon wysyła nowy pakiet z 2 jednostkami paliwa. Przechodzi przez Twój domowy router (spada do 1 paliwa) i dociera do lokalnego węzła Twojego dostawcy internetu. Węzeł odejmuje 1. Paliwa jest teraz 0. Węzeł odrzuca pakiet i odsyła komunikat o błędzie. Bingo! Przystanek 2 właśnie się przedstawił.
* Przystanek 3: Twój telefon wysyła pakiet z 3 jednostkami paliwa...

Twój telefon powtarza ten proces, zwiększając limit paliwa o 1 za każdym razem, aż pakiet w końcu ma dość paliwa, aby dotrzeć do rzeczywistego celu. Zbierając wszystkie komunikaty o błędzie „brak paliwa”, Twój telefon jest w stanie odtworzyć doskonałą, sekwencyjną mapę całej podróży.


## Czym jest „ukryty węzeł” (* * *)?

Czasami krok w Twoim traceroute pojawi się jako * * * lub „Ukryty węzeł” bez nazwy.
Nie panikuj — to nie oznacza, że Twój internet jest zepsuty! Wiele dużych firm, sieci rządowych i zapór bezpieczeństwa celowo wyłącza swoje funkcje „zgłaszania błędów”. Gdy Twojemu pakietowi skończy się paliwo w ich systemie, po cichu wyrzucają go do kosza, nie odsyłając Ci błędu „brak paliwa”. Twoje dane i tak bezpiecznie przechodzą, oni po prostu wolą podróżować anonimowo ze względów bezpieczeństwa!
