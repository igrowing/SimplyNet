# O que é o "Who Is" e a resolução DNS?

Já se perguntou quem é realmente o dono de um site como google.com? Ou como é que o seu telemóvel encontra automaticamente o computador certo do outro lado do mundo apenas a partir de um endereço web?

Quando usa a ferramenta Who Is..., está a puxar a cortina que esconde o diretório administrativo da internet. Ela usa três funções principais para investigar qualquer domínio ou endereço IP.

## 1. O que é o WHOIS? (O registo predial digital)

Cada nome de site (como oseusite.com) é uma parcela de imóvel digital. Tal como comprar uma casa física ou registar um carro, não pode possuir um domínio de forma anónima sem o registar.

O WHOIS (literalmente perguntar *"Quem é responsável por este domínio?"*) é uma enorme base de dados pública que regista os detalhes de propriedade de cada nome de domínio e endereço IP registados no planeta.

### A analogia: a conservatória ou o registo predial

Quando consulta uma matrícula na conservatória do registo automóvel, obtém um registo de quem é o dono do carro, quando foi registado e como o contactar. Uma pesquisa WHOIS faz exatamente o mesmo por um site.

### Que informação lhe mostra?

* O Registante (Registrant): o nome da pessoa ou empresa que comprou o domínio. (Nota: muitas pessoas usam serviços de "proteção de privacidade" para ocultar as suas moradas pessoais, mas os detalhes da empresa de alojamento continuarão visíveis).
* Datas importantes: exatamente quando o nome do site foi comprado pela primeira vez, quando foi atualizado pela última vez e — o mais importante — quando expira.
* O Registrador (Registrar): a "loja" digital onde o dono comprou o domínio (como GoDaddy, Namecheap ou Google Domains).

## 2. O que é a resolução DNS? (A lista telefónica da internet)

Os computadores são incrivelmente bons em matemática, mas péssimos em línguas. Não entendem nomes como `netflix.com`. Para falarem uns com os outros, usam coordenadas numéricas chamadas endereços IP (como `142.250.190.46`).

As pessoas, por outro lado, são ótimas com nomes mas péssimas a memorizar sequências aleatórias de números.

**A resolução DNS (Domain Name System)** é a ponte entre estes dois mundos. Traduz um nome amigável para as pessoas num número amigável para o computador.

### A analogia: a app de contactos do seu telemóvel

Quando quer ligar ao seu amigo Alex, não memoriza o número de telefone de 10 dígitos. Basta tocar em "Alex" na sua lista de contactos e o telemóvel traduz automaticamente esse nome no número telefónico e liga.

* O DNS é a lista de contactos global de toda a internet. * Quando pesquisa um domínio na nossa app, a resolução DNS corre instantaneamente em segundo plano e diz-lhe: "Olha, o google.com está atualmente a operar no número de telefone 142.250.190.46."

## 3. O que é a resolução inversa? (Identificação de chamadas digital)

Mas o que acontece se tiver o número (o endereço IP) e quiser saber o nome (o site)? É aqui que entra a resolução inversa (também conhecida como DNS inverso ou pesquisa PTR).

Se um computador estranho estiver a tentar ligar-se à sua rede doméstica, ou se vir um endereço IP esquisito nos registos da sua rede, pode colar esse endereço IP na nossa ferramenta. A app pergunta ao diretório global: "Que nome de site está registado para este número específico?"

### A analogia: identificação de chamadas (ou pesquisa telefónica inversa)

Se o seu telemóvel tocar e mostrar um número desconhecido como `1-800-555-0199`, pode hesitar em atender. Mas se a identificação de chamadas do seu telemóvel traduzir esse número e mostrar **"Apple Support"**, sabe imediatamente quem está a ligar.

* A resolução inversa é a identificação de chamadas dos endereços de internet.
* Permite-lhe traduzir um número anónimo e intimidante como `172.217.16.142` de volta para um nome amigável e reconhecível como `google.com`.

## Resumo da ferramenta "Who Is..."

Ao combinar estas três funções, a nossa ferramenta oferece-lhe uma "verificação de antecedentes" completa de qualquer alvo digital:

1. A resolução DNS diz-lhe o endereço IP (o "número de telefone") do nome de um site.
2. A resolução inversa diz-lhe o nome do site (a "identificação de chamadas") de um endereço IP misterioso.
3. O WHOIS diz-lhe o verdadeiro dono legal, o registrador e as datas de expiração dessa propriedade.
