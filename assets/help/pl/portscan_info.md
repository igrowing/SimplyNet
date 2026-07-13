# Czym jest skanowanie portów?

Jak hakerzy lub eksperci ds. bezpieczeństwa znajdują na urządzeniu słabe punkty?

Robią to za pomocą narzędzia zwanego skanowaniem portów.

## 1. Analogia: zabezpieczony budynek z 65 536 drzwiami

Wyobraź sobie ogromny, zabezpieczony budynek biurowy lub kompleks mieszkalny.

* Host (adres IP lub domena) to adres pocztowy budynku. Doprowadza Cię do bramy głównej.
* W środku budynek ma dokładnie 65 536 ponumerowanych drzwi (zwanych portami).
* Za każdymi drzwiami znajduje się konkretna firma lub usługa. Na przykład za drzwiami 80 siedzi zarządca strony internetowej, a za drzwiami 554 jest strumień z kamery monitoringu.

  💡 Skanowanie portów jest jak ochroniarz przechodzący korytarzami, pukający do drzwi i sprawdzający, które są otwarte, zamknięte lub całkowicie opuszczone.

Jeśli drzwi są otwarte, oznacza to, że za nimi aktywnie działa usługa nasłuchująca połączeń. Jeśli są zamknięte, drzwi są zaryglowane i nikogo nie ma w środku.

## 2. Wybór celu: dobrze znane porty a zakres własny

Możesz wybrać, które „drzwi” chcesz sprawdzić:

### A. Dobrze znane porty (sprawdzanie głównego holu)

Spośród 65 536 możliwych drzwi zdecydowana większość jest pusta. Domyślnie internet rezerwuje pierwsze 1024 drzwi dla standardowych, oficjalnych usług.

* Drzwi 80: standardowe strony internetowe (HTTP)
* Drzwi 443: bezpieczne strony internetowe (HTTPS)
* Drzwi 21: udostępnianie plików (FTP)
* Drzwi 22: bezpieczne zdalne sterowanie (SSH)
* Jak Ci to pomaga: skanowanie dobrze znanych portów jest jak sprawdzenie tylko głównych holi i ramp załadunkowych budynku. Jest niesamowicie szybkie (zajmuje zaledwie kilka sekund) i obejmuje 99% tego, czego szuka zwykły użytkownik.

### B. Zakres zdefiniowany przez użytkownika (przeszukiwanie każdego pokoju)

Czasami własne aplikacje, urządzenia inteligentnego domu lub kamery ukrywają się za nietypowymi numerami drzwi (jak drzwi 8080 lub drzwi 32400), aby pozostać niewidocznymi.

* Jak Ci to pomaga: możesz kazać aplikacji przeskanować własny zakres — na przykład od drzwi 1 do drzwi 2048. Aplikacja sumiennie zapuka do każdych z tych drzwi, jedne po drugich, aby znaleźć ukryte usługi.

## 3. Protokoły: TCP a UDP

„Drzwi” komputera mówią dwoma różnymi językami. W zależności od Twoich ustawień aplikacja będzie pukać na różne sposoby:

### 1. TCP (uprzejmy uścisk dłoni)

TCP (Transmission Control Protocol) to najpopularniejszy protokół w internecie. Został zaprojektowany dla 100% dokładności.

* Styl pukania: aplikacja puka do drzwi, czeka, aż ktoś otworzy, ściska mu dłoń, mówi „Cześć!”, a następnie grzecznie odchodzi.
* Analogia: jak wysłanie listu poleconego. Jest niezwykle niezawodne w potwierdzaniu, czy ktoś jest w domu, ale „uścisk dłoni” trwa ułamek sekundy.

### 2. UDP (rzuć pocztówkę i biegnij)

UDP (User Datagram Protocol) został zaprojektowany dla czystej szybkości, często używany do transmisji wideo na żywo lub gier online.

* Styl pukania: aplikacja wrzuca pocztówkę przez szczelinę na listy i przez ułamek sekundy nasłuchuje, czy ktoś w środku odkrzyknie. Nie czeka na uścisk dłoni.
* Analogia: jak przerzucenie papierowego samolotu przez płot. Jest niesamowicie szybkie, ale jeśli nikt nie odkrzyknie, trudniej mieć 100% pewność, czy pokój jest pusty, czy po prostu zignorowano Twój samolocik.

## 4. Dlaczego duże skanowanie zajmuje tyle czasu?

*„Dlaczego moje skanowanie trwa tak długo?”* Odpowiedź to prosta matematyka!

* Jeśli skanujesz dobrze znane porty tylko przez TCP, aplikacja sprawdza około 60 drzwi. Kończy w mgnieniu oka.
* Jeśli rozszerzysz zakres od 1 do 10 000 i wybierzesz zarówno TCP, jak i UDP, aplikacja musi fizycznie wykonać **20 000** pojedynczych puknięć (**10 000** dla TCP i **10 000** dla UDP).

Ponieważ aplikacja musi przy każdych drzwiach zaczekać maleńki ułamek sekundy, aby sprawdzić, czy urządzenie odpowie (aby nie przeoczyć wolno reagującej kamery lub routera), sprawdzenie dziesiątek tysięcy drzwi wymaga cierpliwości.

Aby zaoszczędzić czas, zawsze zaczynaj od skanowania „dobrze znanych” portów! Skanowanie własne o szerokim zakresie uruchamiaj tylko wtedy, gdy polujesz na bardzo konkretne, ukryte urządzenie w swojej sieci.
