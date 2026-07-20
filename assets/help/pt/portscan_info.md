# O que é uma verificação de portas (Port Scan)?

Como é que os hackers ou os especialistas em segurança encontram os pontos vulneráveis de um dispositivo?

Fazem-no usando uma ferramenta chamada verificação de portas (Port Scan).

## 1. A analogia: um edifício seguro com 65.536 portas

Imagine um enorme edifício de escritórios ou um complexo residencial seguro.

* O Host (o endereço IP ou domínio) é a morada do edifício. Leva-o até ao portão principal.
* Uma vez lá dentro, o edifício tem exatamente 65.536 portas numeradas (chamadas Portas).
* Atrás de cada porta há um negócio ou serviço específico. Por exemplo, atrás da Porta 80 está um gestor de sites, e atrás da Porta 554 está uma transmissão de câmara de segurança.

  💡 Uma verificação de portas é como um segurança a percorrer os corredores, a bater às portas e a verificar quais estão abertas, trancadas ou completamente abandonadas.

Se uma porta estiver Aberta, significa que há um serviço a correr ativamente atrás dela, à escuta de ligações. Se estiver Fechada, a porta está trancada e não há ninguém lá dentro.

## 2. Escolher o alvo: portas conhecidas (Well-Known) vs. intervalo personalizado

Pode escolher que "portas" quer verificar:

### A. Portas conhecidas (verificar o átrio principal)

Das 65.536 portas possíveis, a grande maioria está vazia. Por predefinição, a internet reserva as primeiras 1.024 portas para serviços padrão e oficiais.

* Porta 80: sites padrão (HTTP)
* Porta 443: sites seguros (HTTPS)
* Porta 21: partilha de ficheiros (FTP)
* Porta 22: controlo remoto seguro (SSH)
* Como o ajuda: verificar as portas conhecidas é como verificar apenas os átrios principais e as docas de carga do edifício. É incrivelmente rápido (demora apenas alguns segundos) e cobre 99% do que um utilizador normal procura.

### B. Intervalo definido pelo utilizador (procurar em todas as salas)

Por vezes, apps personalizadas, dispositivos de casa inteligente ou câmaras escondem-se atrás de números de porta invulgares (como a Porta 8080 ou a Porta 32400) para passarem despercebidos.

* Como o ajuda: pode dizer à app para verificar um intervalo personalizado — por exemplo, da Porta 1 à Porta 2048. A app bate diligentemente a cada uma dessas portas, uma após a outra, para encontrar serviços ocultos.

## 3. Os protocolos: TCP vs. UDP

As "portas" de um computador falam duas línguas diferentes. Consoante as suas definições, a app bate usando estilos diferentes:

### 1. TCP (o aperto de mão cortês)

O TCP (Transmission Control Protocol) é o protocolo mais comum na internet. É concebido para 100% de precisão.

* O estilo de bater: a app bate à porta, espera que alguém a abra, aperta-lhe a mão, diz "Olá!" e depois sai educadamente.
* Analogia: como enviar uma carta registada. É extremamente fiável para confirmar se alguém está em casa, mas o "aperto de mão" demora uma fração de segundo a concluir.

### 2. UDP (o atirar do postal)

O UDP (User Datagram Protocol) é concebido para velocidade pura, muitas vezes usado para transmissões de vídeo em direto ou jogos online.

* O estilo de bater: a app atira um postal pela ranhura do correio e escuta por um instante para ver se alguém lá dentro responde aos gritos. Não espera para apertar a mão.
* Analogia: como atirar um avião de papel por cima de uma cerca. É incrivelmente rápido, mas se ninguém responder é mais difícil ter 100% de certeza se a sala está vazia ou se apenas ignoraram o seu avião de papel.

## 4. Porque é que uma verificação grande demora tanto tempo?

*"Porque é que a minha verificação está a demorar tanto?"* A resposta é matemática simples!

* Se verificar as portas conhecidas usando apenas TCP, a app verifica cerca de 60 portas. Termina num instante.
* Se alargar o intervalo de 1 a 10.000 e selecionar TCP e UDP, a app tem fisicamente de realizar **20.000** batidas individuais (**10.000** para TCP e **10.000** para UDP).

Como a app tem de esperar uma minúscula fração de segundo em cada porta para ver se um dispositivo responde (para não perder uma câmara ou um router de resposta lenta), verificar dezenas de milhares de portas exige paciência.

Para poupar tempo, comece sempre primeiro com uma verificação de portas "conhecidas"! Só execute verificações personalizadas de intervalo alargado se estiver à procura de um dispositivo oculto muito específico na sua rede.
