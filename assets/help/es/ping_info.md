# ¿Qué es un Ping?

¿Alguna vez te has preguntado qué ocurre cuando tu ordenador o teléfono "hace ping" a un sitio web? ¿O por qué el soporte técnico siempre te pide que ejecutes una "prueba de ping" cuando internet va lento?

A pesar de su nombre técnico, el ping es la herramienta de diagnóstico más sencilla de toda la informática de redes. Aquí tienes una guía en lenguaje claro sobre qué es, qué hace y cómo funciona en nuestra app.

## 1. La analogía: el sónar del submarino (o eco)

El término "Ping" proviene en realidad de la tecnología de sónar de los submarinos.

Imagina un submarino flotando en el océano oscuro. Para ver si hay una montaña u otro barco cerca, emite un pulso de sonido —un fuerte "¡Ping!"— hacia el agua.

Si el sonido golpea un objeto, rebota como un eco.

Al medir cuánto tarda el eco en volver, el submarino puede calcular exactamente a qué distancia está el objeto.

Si no vuelve ningún eco, el submarino sabe que no hay nada ahí fuera.

En el mundo digital, tu teléfono hace exactamente lo mismo. Envía un pequeño pulso digital a otro ordenador o sitio web y espera a que ese ordenador devuelva el pulso.

## 2. ¿Por qué lo necesitamos?

El ping te ayuda a responder tres preguntas fundamentales sobre tu conexión:

### A. "¿Está ese ordenador encendido y conectado?" (Disponibilidad)

Si haces ping a un dispositivo (como tu smart TV, tu router o google.com) y responde, sabes que está encendido y conectado a la red. Si el ping falla, o bien el dispositivo está apagado, el cable está desconectado, o un firewall está bloqueando el tráfico.

### B. "¿Qué velocidad tiene mi conexión?" (Latencia)

El tiempo que tarda tu ping en hacer el viaje de ida y vuelta se mide en milisegundos (ms).

* De 1 a 20 ms: rapidísimo (ideal para juegos en línea o videollamadas).
* De 20 a 100 ms: bueno, velocidad de navegación normal.
* Más de 150 ms: lento, con retardo o demora.

### C. "¿Es estable mi conexión?" (Pérdida de paquetes y Jitter)

Si lanzas una pelota de tenis contra una pared 10 veces, esperas que rebote 10 veces.

* Si haces ping a un sitio web 50 veces y solo vuelven 45 pings, tienes un 10% de pérdida de paquetes (Packet Loss). Esto significa que tu conexión es inestable y se están perdiendo datos por el camino.
* Si algunos pings tardan 10 ms pero otros tardan 500 ms, tienes un Jitter alto, lo que significa que tu conexión es inconsistente.

## 3. IP, Hostname y FQDN: cómo indicar tu objetivo

Cuando le dices a nuestra app que haga ping a algo, tienes que indicarle a dónde enviar el pulso. Puedes escribir tres tipos diferentes de direcciones:

### 1. Dirección IP (las coordenadas GPS)

Una dirección IP (Internet Protocol) es una secuencia de números, como 192.168.1.1 o 142.250.190.46.

* Qué es: es la dirección exacta y física de un ordenador en la red. Los ordenadores solo entienden direcciones IP.
* Analogía: piénsalo como las coordenadas exactas de latitud y longitud de una casa. Es muy preciso, pero muy difícil de memorizar para las personas.

### 2. Hostname (el apodo amistoso)

Un Hostname es un nombre sencillo y legible asignado a un único dispositivo en una red local, como MyLaptop, OfficePrinter o LivingRoomSpeaker.

* Qué es: es un apodo local. Dentro de tu casa puedes decirle al teléfono que haga ping a OfficePrinter y tu router traducirá ese apodo a su dirección IP.
* Analogía: es como decir "la habitación de mamá" o "la cocina". Funciona perfectamente dentro de tu casa, pero si vas a casa de un desconocido y dices "ve a la habitación de mamá", no sabrá a qué habitación te refieres.

### 3. FQDN (la dirección postal completa)

FQDN significa Fully Qualified Domain Name (nombre de dominio completo). Algunos ejemplos son www.google.com, mail.yahoo.com o support.apple.com.

* Qué es: es el nombre completo, oficial e inequívoco de un servidor en internet global. Como contiene tanto el apodo específico del host (www) como el dominio registrado (google.com), no hay ninguna confusión sobre a qué ordenador del planeta te refieres.
* Analogía: piénsalo como una dirección postal internacional completa, con Nombre, Calle, Ciudad y País. Es único y funciona desde cualquier parte del mundo.

## 4. Funciones especiales de la herramienta Ping

Cuando usas la herramienta Ping, tienes control total sobre cómo se ejecuta la prueba:

* Personaliza la duración del Ping (Recuento): en lugar de hacer ping indefinidamente o ejecutar una prueba fija, puedes especificar exactamente cuántas veces hacer ping (por ejemplo, 10, 50 o 100 veces). Esto te permite ejecutar una prueba de estabilidad a largo plazo durante varios minutos, para ver si tu Wi-Fi sufre cortes intermitentes cuando te mueves a otra habitación.
* Cancela en cualquier momento (botón Detener): si iniciaste una prueba de estabilidad de 100 pings pero enseguida notaste una alta pérdida de paquetes o registros de error, no tienes que quedarte esperando a que termine la prueba. Puedes pulsar Detener en cualquier momento. Nuestra app cortará al instante el proceso de red en segundo plano, detendrá el consumo de batería y calculará de inmediato las estadísticas medias finales de los pings que sí lograron completarse.
