# ¿Qué es un escaneo de puertos (Port Scan)?

¿Cómo encuentran los hackers o los expertos en seguridad los puntos vulnerables de un dispositivo?

Lo hacen usando una herramienta llamada escaneo de puertos (Port Scan).

## 1. La analogía: un edificio protegido con 65.536 puertas

Imagina un enorme edificio de oficinas o un complejo residencial seguro.

* El Host (la dirección IP o dominio) es la dirección postal del edificio. Te lleva hasta la puerta principal.
* Una vez dentro, el edificio tiene exactamente 65.536 puertas numeradas (llamadas Puertos).
* Detrás de cada puerta hay un negocio o servicio específico. Por ejemplo, detrás de la Puerta 80 hay un gestor de sitios web, y detrás de la Puerta 554 hay una transmisión de cámaras de seguridad.

  💡 Un escaneo de puertos es como un guardia de seguridad que recorre los pasillos, llama a las puertas y comprueba cuáles están abiertas, cerradas o completamente abandonadas.

Si una puerta está Abierta, significa que hay un servicio activo detrás escuchando conexiones. Si está Cerrada, la puerta está bloqueada y no hay nadie dentro.

## 2. Elegir tu objetivo: puertos conocidos (Well-Known) vs. rango personalizado

Puedes elegir qué "puertas" quieres comprobar:

### A. Puertos conocidos (comprobar el vestíbulo principal)

De las 65.536 puertas posibles, la gran mayoría están vacías. Por defecto, internet reserva las primeras 1.024 puertas para servicios estándar y oficiales.

* Puerta 80: sitios web estándar (HTTP)
* Puerta 443: sitios web seguros (HTTPS)
* Puerta 21: compartición de archivos (FTP)
* Puerta 22: control remoto seguro (SSH)
* Cómo te ayuda: escanear los puertos conocidos es como comprobar solo los vestíbulos principales y los muelles de carga del edificio. Es increíblemente rápido (tarda solo un par de segundos) y cubre el 99% de lo que busca un usuario normal.

### B. Rango definido por el usuario (buscar en cada habitación)

A veces, apps personalizadas, dispositivos de hogar inteligente o cámaras se esconden detrás de números de puerta inusuales (como la Puerta 8080 o la Puerta 32400) para pasar desapercibidos.

* Cómo te ayuda: puedes decirle a la app que escanee un rango personalizado, por ejemplo, de la Puerta 1 a la Puerta 2048. La app llamará diligentemente a cada una de esas puertas, una tras otra, para encontrar servicios ocultos.

## 3. Los protocolos: TCP vs. UDP

Las "puertas" de un ordenador hablan dos idiomas diferentes. Según tu configuración, la app llamará usando estilos diferentes:

### 1. TCP (el apretón de manos cortés)

TCP (Transmission Control Protocol) es el protocolo más común en internet. Está diseñado para una precisión del 100%.

* El estilo de llamada: la app llama a la puerta, espera a que alguien la abra, le da la mano, dice "¡Hola!" y luego se marcha educadamente.
* Analogía: como enviar una carta certificada. Es extremadamente fiable para confirmar si alguien está en casa, pero el "apretón de manos" tarda una fracción de segundo en completarse.

### 2. UDP (el lanzamiento de la postal)

UDP (User Datagram Protocol) está diseñado para la velocidad pura, a menudo usado para transmisiones de vídeo en directo o juegos en línea.

* El estilo de llamada: la app lanza una postal por la ranura del correo y escucha durante un instante para ver si alguien dentro responde a gritos. No espera a dar la mano.
* Analogía: como lanzar un avión de papel por encima de una valla. Es increíblemente rápido, pero si nadie responde es más difícil estar 100% seguro de si la habitación está vacía o simplemente ignoraron tu avión de papel.

## 4. ¿Por qué un escaneo grande tarda tanto tiempo?

*"¿Por qué mi escaneo tarda tanto?"* ¡La respuesta es matemática sencilla!

* Si escaneas los puertos conocidos usando solo TCP, la app comprueba unas 60 puertas. Termina en un instante.
* Si amplías el rango de 1 a 10.000 y seleccionas TCP y UDP, la app tiene que realizar físicamente **20.000** llamadas individuales (**10.000** para TCP y **10.000** para UDP).

Como la app tiene que esperar una minúscula fracción de segundo en cada puerta para ver si un dispositivo responde (para no perderse una cámara o router de respuesta lenta), comprobar decenas de miles de puertas requiere paciencia.

Para ahorrar tiempo, ¡empieza siempre con un escaneo de puertos "conocidos"! Ejecuta escaneos personalizados de amplio rango solo si estás buscando un dispositivo oculto muy específico en tu red.
