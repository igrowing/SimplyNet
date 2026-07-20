# O que é um Ping?

Já se perguntou o que acontece quando o seu computador ou telemóvel "faz ping" a um site? Ou porque é que o suporte técnico pede sempre para executar um "teste de ping" quando a internet fica lenta?

Apesar do nome de som técnico, o ping é a ferramenta de diagnóstico mais simples de toda a rede informática. Aqui está um guia em linguagem simples sobre o que é, o que faz e como funciona na nossa app.

## 1. A analogia: o sonar do submarino (ou eco)

O termo "Ping" vem, na verdade, da tecnologia de sonar dos submarinos.

Imagine um submarino a flutuar no oceano escuro. Para ver se há uma montanha ou outro navio nas proximidades, emite um pulso sonoro — um forte "Ping!" — para dentro da água.

Se o som atingir um objeto, volta como um eco.

Medindo quanto tempo o eco demora a regressar, o submarino consegue calcular exatamente a que distância está o objeto.

Se nenhum eco voltar, o submarino sabe que não há nada lá fora.

No mundo digital, o seu telemóvel faz exatamente o mesmo. Envia um pequeno pulso digital para outro computador ou site e espera que esse computador devolva o pulso.

## 2. Porque precisamos disto?

O ping ajuda-o a responder a três perguntas essenciais sobre a sua ligação:

### A. "Aquele computador está ligado e conectado?" (Disponibilidade)

Se fizer ping a um dispositivo (como a sua smart TV, o router ou google.com) e ele responder, sabe que está ligado e conectado à rede. Se o ping falhar, ou o dispositivo está desligado, o cabo está desconectado, ou uma firewall está a bloquear o tráfego.

### B. "Qual é a velocidade da minha ligação?" (Latência)

O tempo que o ping demora a fazer a viagem de ida e volta é medido em milissegundos (ms).

* 1 a 20 ms: super rápido (ótimo para jogos online ou videochamadas).
* 20 a 100 ms: bom, velocidade de navegação normal.
* Acima de 150 ms: lento, com atraso ou latência.

### C. "A minha ligação é estável?" (Perda de pacotes e Jitter)

Se atirar uma bola de ténis contra uma parede 10 vezes, espera que ela ressalte 10 vezes.

* Se fizer ping a um site 50 vezes e apenas 45 pings voltarem, tem 10% de perda de pacotes (Packet Loss). Isto significa que a sua ligação está instável e há dados a perderem-se no caminho.
* Se alguns pings demorarem 10 ms mas outros demorarem 500 ms, tem um Jitter elevado, ou seja, a sua ligação é inconsistente.

## 3. IP, Hostname e FQDN: como endereçar o seu alvo

Quando diz à nossa app para fazer ping a algo, tem de lhe indicar para onde enviar o pulso. Pode escrever três tipos diferentes de endereços:

### 1. Endereço IP (as coordenadas GPS)

Um endereço IP (Internet Protocol) é uma sequência de números, como 192.168.1.1 ou 142.250.190.46.

* O que é: é o endereço exato e físico de um computador na rede. Os computadores só entendem endereços IP.
* Analogia: pense nisto como as coordenadas exatas de latitude e longitude de uma casa. É muito preciso, mas muito difícil de memorizar para as pessoas.

### 2. Hostname (a alcunha amigável)

Um Hostname é um nome simples e legível atribuído a um único dispositivo numa rede local, como MyLaptop, OfficePrinter ou LivingRoomSpeaker.

* O que é: é uma alcunha local. Dentro de casa, pode dizer ao telemóvel para fazer ping a OfficePrinter, e o router traduz essa alcunha para o seu endereço IP.
* Analogia: é como dizer "o quarto da mãe" ou "a cozinha". Funciona perfeitamente dentro da sua casa, mas se for a casa de um estranho e disser "vai ao quarto da mãe", ele não saberá que quarto quer dizer.

### 3. FQDN (o endereço postal completo)

FQDN significa Fully Qualified Domain Name (nome de domínio totalmente qualificado). Exemplos incluem www.google.com, mail.yahoo.com ou support.apple.com.

* O que é: é o nome completo, oficial e inequívoco de um servidor na internet global. Como contém tanto a alcunha específica do host (www) como o domínio registado (google.com), não há qualquer confusão sobre de que computador na terra está a falar.
* Analogia: pense nisto como um endereço postal internacional completo, incluindo Nome, Rua, Cidade e País. É único e funciona a partir de qualquer lugar do mundo.

## 4. Funcionalidades especiais da ferramenta Ping

Quando usa a ferramenta Ping, tem controlo total sobre como o teste é executado:

* Personalize a duração do Ping (Contagem): em vez de fazer ping indefinidamente ou executar um teste fixo, pode especificar exatamente quantas vezes fazer ping (por exemplo, 10, 50 ou 100 vezes). Isto permite executar um teste de estabilidade a longo prazo ao longo de vários minutos, para ver se o seu Wi-Fi sofre quebras intermitentes quando se desloca para outra divisão.
* Cancele a qualquer momento (botão Parar): se iniciou um teste de estabilidade de 100 pings mas reparou imediatamente numa perda de pacotes elevada ou em registos de erro, não tem de ficar à espera que o teste termine. Pode carregar em Parar a qualquer momento. A nossa app corta instantaneamente o processo de rede em segundo plano, para o consumo da bateria e calcula de imediato as estatísticas médias finais dos pings que conseguiram concluir.
