# Prueba de velocidad

SimplyNet mide tu conexión a internet transfiriendo datos hacia y desde un servidor de prueba y cronometrándolos. Se informan tres números:

- **Descarga** — la rapidez con la que los datos llegan a tu dispositivo, en Mbps. Cuanto más alto, mejor.
- **Subida** — la rapidez con la que tu dispositivo envía datos, en Mbps. Cuanto más alto, mejor.
- **Ping** — el retardo de ida y vuelta hasta el servidor, en milisegundos. Cuanto más bajo,
  mejor.

## Elegir un proveedor

El menú desplegable bajo el botón **Iniciar prueba** selecciona qué backend de prueba se
usa.

## Comparación de servicios de prueba de velocidad

| Característica | Cloudflare (predeterminado) | Ookla |
|---|---|---|
| Objetivo de la medición | Velocidad real de navegación web | Capacidad teórica absoluta de la línea |
| Estado de privacidad | 100% anónimo. Sin seguimiento | Recopila IP, ubicación y datos del dispositivo |
| Método técnico | Descarga progresiva de flujo único | Saturación de red de múltiples flujos |
| Ideal para | Evaluar el rendimiento diario de internet | Verificar las velocidades anunciadas por el ISP |

### Mediante Cloudflare (predeterminado)

Utiliza los endpoints públicos `speed.cloudflare.com` de Cloudflare. No se requiere ninguna cuenta ni consentimiento adicional, y no se comparte ningún identificador personal más allá de la información normal que lleva cualquier solicitud a un sitio web (como tu dirección IP, necesaria para entregar la respuesta).

Esta es la opción recomendada para la mayoría de los usuarios.

### Mediante Ookla

Utiliza la red global de servidores speedtest.net de Ookla, la misma infraestructura detrás del conocido servicio Speedtest. Los servidores de Ookla son operados por terceros en todo el mundo, por lo que una prueba se conecta al servidor más cercano y accesible.

Como esto implica servidores de terceros, elegir Ookla solicita tu consentimiento la primera vez. **Ookla recopila y comparte tu dirección IP, los identificadores del dispositivo y los datos de ubicación.** Tu elección se recuerda para que no se te vuelva a preguntar; puedes volver a Cloudflare en cualquier momento.

Cuando Ookla está activo, el botón **Iniciar prueba** se vuelve ámbar como recordatorio de que se está usando un backend de terceros. Cloudflare restaura el botón azul.

## Consejos para resultados precisos

- Realiza la prueba por Wi-Fi o datos móviles según lo que quieras medir.
- Cierra otras apps que puedan estar usando la red.
- Ejecuta la prueba varias veces — los resultados varían con las condiciones de la red y la carga del servidor.
- Los enlaces de muy alta velocidad pueden estar limitados por el dispositivo o el método de prueba en lugar de por tu conexión real.

## Privacidad

Los resultados se almacenan solo en tu dispositivo, en **Mediciones anteriores**. Puedes borrarlos en cualquier momento desde la sección de historial. SimplyNet no sube tus resultados a ningún sitio.
