# Czym jest ping?

Czy zastanawiałeś się kiedyś, co dzieje się, gdy Twój komputer lub telefon „pinguje” stronę internetową? Albo dlaczego pomoc techniczna zawsze prosi o uruchomienie „testu ping”, gdy internet zwalnia?

Mimo technicznie brzmiącej nazwy ping jest najprostszym narzędziem diagnostycznym w całej sieci komputerowej. Oto wyjaśnienie prostym językiem: czym jest, co robi i jak działa w naszej aplikacji.

## 1. Analogia: sonar okrętu podwodnego (czyli echo)

Termin „ping” w rzeczywistości pochodzi z technologii sonaru okrętów podwodnych.

Wyobraź sobie okręt podwodny płynący w ciemnym oceanie. Aby sprawdzić, czy w pobliżu jest góra lub inny statek, wysyła w wodę impuls dźwiękowy — głośne „Ping!”.

Jeśli dźwięk trafi w jakiś obiekt, odbija się z powrotem jako echo.

Mierząc, ile czasu zajmuje powrót echa, okręt podwodny może dokładnie obliczyć, jak daleko znajduje się obiekt.

Jeśli echo nie wraca, okręt podwodny wie, że nic tam nie ma.

W świecie cyfrowym Twój telefon robi dokładnie to samo. Wysyła maleńki cyfrowy impuls do innego komputera lub strony i czeka, aż ten komputer odeśle impuls z powrotem.

## 2. Dlaczego go potrzebujemy?

Ping pomaga odpowiedzieć na trzy kluczowe pytania dotyczące Twojego połączenia:

### A. „Czy ten komputer jest włączony i podłączony?” (Dostępność)

Jeśli spingujesz urządzenie (np. telewizor smart, router lub google.com) i odeśle echo, wiesz, że jest włączone i podłączone do sieci. Jeśli ping się nie powiedzie, urządzenie jest wyłączone, kabel jest odłączony albo ruch blokuje zapora sieciowa.

### B. „Jak szybkie jest moje połączenie?” (Opóźnienie)

Czas, jaki zajmuje pingowi podróż w obie strony, mierzy się w milisekundach (ms).

* 1 do 20 ms: błyskawicznie (świetne do gier online lub rozmów wideo).
* 20 do 100 ms: dobre, normalna prędkość przeglądania.
* Ponad 150 ms: wolno, z lagami lub opóźnieniami.

### C. „Czy moje połączenie jest stabilne?” (Utrata pakietów i jitter)

Jeśli rzucisz piłką tenisową w ścianę 10 razy, spodziewasz się, że odbije się 10 razy.

* Jeśli spingujesz stronę 50 razy, a wróci tylko 45 pingów, masz 10% utraty pakietów. To oznacza, że Twoje połączenie jest niestabilne, a dane gubią się po drodze.
* Jeśli niektóre pingi trwają 10 ms, a inne 500 ms, masz wysoki jitter, co oznacza, że połączenie jest niespójne.

## 3. IP, nazwa hosta i FQDN: jak zaadresować cel

Kiedy każesz aplikacji coś spingować, musisz jej wskazać, dokąd wysłać impuls. Możesz wpisać trzy różne rodzaje adresów:

### 1. Adres IP (współrzędne GPS)

Adres IP (Internet Protocol) to ciąg liczb, np. 192.168.1.1 lub 142.250.190.46.

* Czym jest: to dokładny, fizyczny adres komputera w sieci. Komputery rozumieją tylko adresy IP.
* Analogia: pomyśl o tym jak o dokładnych współrzędnych geograficznych (szerokości i długości) domu. Jest bardzo dokładny, ale ludziom trudno go zapamiętać.

### 2. Nazwa hosta (przyjazny pseudonim)

Nazwa hosta to prosta, czytelna dla człowieka nazwa przypisana pojedynczemu urządzeniu w sieci lokalnej, np. MyLaptop, OfficePrinter lub LivingRoomSpeaker.

* Czym jest: to lokalny pseudonim. W domu możesz kazać telefonowi spingować OfficePrinter, a router przetłumaczy ten pseudonim na jego adres IP.
* Analogia: to jak powiedzieć „pokój mamy” lub „kuchnia”. W Twoim domu działa doskonale, ale jeśli pójdziesz do obcego domu i powiesz „Idź do pokoju mamy”, nie będą wiedzieć, o który pokój chodzi.

### 3. FQDN (pełny adres pocztowy)

FQDN oznacza Fully Qualified Domain Name (w pełni kwalifikowaną nazwę domeny). Przykłady to www.google.com, mail.yahoo.com lub support.apple.com.

* Czym jest: to pełna, oficjalna, jednoznaczna nazwa serwera w globalnym internecie. Ponieważ zawiera zarówno konkretny pseudonim hosta (www), jak i zarejestrowaną domenę (google.com), nie ma żadnych wątpliwości, o którym komputerze na świecie mówisz.
* Analogia: pomyśl o tym jak o pełnym międzynarodowym adresie pocztowym, zawierającym imię, ulicę, miasto i kraj. Jest unikatowy i działa z dowolnego miejsca na świecie.

## 4. Specjalne funkcje narzędzia Ping

Kiedy używasz narzędzia Ping, masz pełną kontrolę nad tym, jak przebiega test:

* Dostosuj czas pingowania (liczba): zamiast pingować w nieskończoność lub uruchamiać ustalony test, możesz dokładnie określić, ile razy pingować (na przykład 10, 50 lub 100 razy). Pozwala to przeprowadzić długoterminowy test stabilności trwający kilka minut, aby sprawdzić, czy Twoje Wi-Fi cierpi na sporadyczne zaniki, gdy przechodzisz do innego pokoju.
* Przerwij w dowolnej chwili (przycisk Stop): jeśli uruchomiłeś test stabilności ze 100 pingami, ale od razu zauważyłeś wysoką utratę pakietów lub błędy w dziennikach, nie musisz siedzieć i czekać na zakończenie testu. Możesz w każdej chwili nacisnąć Stop. Nasza aplikacja natychmiast przerwie proces sieciowy w tle, zatrzyma zużycie baterii i od razu obliczy końcowe średnie statystyki z pingów, które zdążyły się zakończyć.
