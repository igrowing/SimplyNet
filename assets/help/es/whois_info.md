# ¿Qué es "Who Is" y la resolución DNS?

¿Alguna vez te has preguntado quién es realmente el propietario de un sitio web como google.com? ¿O cómo tu teléfono encuentra automáticamente el ordenador correcto al otro lado del mundo solo con una dirección web?

Cuando usas la herramienta Who Is..., estás descorriendo la cortina del directorio administrativo de internet. Utiliza tres funciones principales para investigar cualquier dominio o dirección IP.

## 1. ¿Qué es WHOIS? (El registro de la propiedad digital)

Cada nombre de un sitio web (como tusitioweb.com) es una parcela de bienes inmuebles digitales. Al igual que comprar una casa física o matricular un coche, no puedes poseer un dominio de forma anónima sin registrarlo.

WHOIS (literalmente preguntar *"¿Quién es responsable de este dominio?"*) es una enorme base de datos pública que registra los detalles de propiedad de cada nombre de dominio y dirección IP registrados en el planeta.

### La analogía: la DGT o el registro de la propiedad

Cuando buscas una matrícula en la Dirección General de Tráfico (DGT), obtienes un registro de quién es el propietario del coche, cuándo se matriculó y cómo contactar con él. Una búsqueda WHOIS hace exactamente lo mismo con un sitio web.

### ¿Qué información te muestra?

* El Registrante (Registrant): el nombre de la persona o empresa que compró el dominio. (Nota: muchas personas usan servicios de "protección de privacidad" para ocultar sus direcciones particulares, pero los datos de la empresa de hosting seguirán siendo visibles).
* Fechas importantes: exactamente cuándo se compró por primera vez el nombre del sitio web, cuándo se actualizó por última vez y, lo más importante, cuándo caduca.
* El Registrador (Registrar): la "tienda" digital donde el propietario compró el dominio (como GoDaddy, Namecheap o Google Domains).

## 2. ¿Qué es la resolución DNS? (La guía telefónica de internet)

Los ordenadores son increíblemente buenos con las matemáticas, pero pésimos con los idiomas. No entienden nombres como `netflix.com`. Para hablar entre sí, usan coordenadas numéricas llamadas direcciones IP (como `142.250.190.46`).

Las personas, en cambio, son buenas con los nombres pero pésimas memorizando cadenas aleatorias de números.

**La resolución DNS (Domain Name System)** es el puente entre estos dos mundos. Traduce un nombre amigable para las personas en un número amigable para el ordenador.

### La analogía: la app de contactos de tu teléfono

Cuando quieres llamar a tu amigo Alex, no memorizas su número de teléfono de 10 dígitos. Simplemente tocas "Alex" en tu lista de contactos y tu teléfono traduce automáticamente ese nombre al número telefónico y lo marca.

* El DNS es la lista de contactos global de todo internet. * Cuando buscas un dominio en nuestra app, la resolución DNS se ejecuta instantáneamente en segundo plano y te dice: "Oye, google.com opera actualmente en el número de teléfono 142.250.190.46."

## 3. ¿Qué es la resolución inversa? (El identificador de llamadas digital)

Pero ¿qué ocurre si tienes el número (la dirección IP) y quieres saber el nombre (el sitio web)? Ahí es donde entra la resolución inversa (también conocida como DNS inverso o búsqueda PTR).

Si un ordenador extraño intenta conectarse a tu red doméstica, o si ves una dirección IP rara en los registros de tu red, puedes pegar esa dirección IP en nuestra herramienta. La app preguntará al directorio global: "¿Qué nombre de sitio web está registrado para este número específico?"

### La analogía: el identificador de llamadas (o búsqueda telefónica inversa)

Si tu teléfono suena y muestra un número desconocido como `1-800-555-0199`, quizá dudes en contestar. Pero si el identificador de llamadas de tu teléfono traduce ese número y muestra **"Soporte de Apple"**, sabes al instante quién llama.

* La resolución inversa es el identificador de llamadas para las direcciones de internet.
* Te permite traducir un número anónimo e intimidante como `172.217.16.142` de nuevo a un nombre amigable y reconocible como `google.com`.

## Resumen de la herramienta "Who Is..."

Al combinar estas tres funciones, nuestra herramienta te ofrece una "comprobación de antecedentes" completa de cualquier objetivo digital:

1. La resolución DNS te dice la dirección IP (el "número de teléfono") del nombre de un sitio web.
2. La resolución inversa te dice el nombre del sitio web (el "identificador de llamadas") de una dirección IP misteriosa.
3. WHOIS te dice el verdadero propietario legal, el registrador y las fechas de caducidad de esa propiedad.
