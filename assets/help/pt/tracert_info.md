# O que é um Traceroute?

O ecrã "Traceroute", cheio de endereços IP a passar e de números em milissegundos, pode parecer incrivelmente intimidante.

Mas, despido do jargão informático, um traceroute é, na verdade, uma das ferramentas mais simples e elegantes da internet.

## 1. A analogia: o rastreador de encomendas postais

Imagine que vive em Roma, Itália, e quer enviar uma carta física a um amigo em Nova Iorque, EUA.

A sua carta não se teletransporta magicamente através do Atlântico. Em vez disso, faz uma viagem:

1. Começa nos correios do seu bairro.
2. É carregada num camião para um centro de triagem regional em Roma.
3. É transportada de avião para um centro aeroportuário internacional em Londres.
4. Atravessa o oceano até um posto alfandegário em Nova Iorque.
5. Vai para uma estação de entrega local em Manhattan.
6. Por fim, chega a casa do seu amigo.

No mundo digital, sempre que visita um site (como Google, Netflix ou o seu blogue favorito), o seu telemóvel envia milhões de pequenos envelopes digitais chamados "pacotes" pelo mundo inteiro.

Tal como a sua carta, estes pacotes não se teletransportam. Saltam de um computador físico (chamado router) para outro até chegarem ao destino.

  💡 O Traceroute é simplesmente um "rastreador de encomendas digital". Revela a lista exata dos "correios" (routers) onde os seus dados pararam no caminho até ao destino, e exatamente quantos milissegundos demoraram a passar por cada paragem.

## 2. Porque precisamos disto?

Se a sua encomenda não chegar a Nova Iorque, ou se demorar três semanas a chegar, um rastreador de envios normal diz-lhe exatamente onde as coisas correram mal (por exemplo, "retida na alfândega em Londres").

Um traceroute faz exatamente o mesmo pela sua ligação à internet. É usado para resolver dois mistérios principais:

### A. "Onde é que a ligação se está a quebrar?"

Se um site se recusa a carregar, será o seu Wi-Fi de casa que está avariado? Será o seu fornecedor de serviços de internet (ISP) que está com uma falha? Ou será que o servidor do site está completamente em baixo?

Um traceroute mostra-lhe exatamente onde o caminho fica às escuras. Se as paragens chegarem ao número 3 (o seu ISP) e depois tudo o que se segue for uma linha em branco, sabe que a internet está avariada mesmo à porta do seu fornecedor.

### B. "Porque é que a minha ligação está tão lenta?"

Se um jogo está com lag ou um vídeo está a fazer buffer, um traceroute pode medir o tempo de viagem (chamado latência ou ping) até cada paragem do caminho.

Se as paragens 1 a 5 demoram uns rápidos 15 milissegundos, mas a paragem 6 salta de repente para 300 milissegundos, encontrou o router exato que causa o estrangulamento.

## 3. Como funciona?

Quando envia um pacote de dados para a internet, os routers ao longo do caminho estão incrivelmente ocupados. Não têm tempo de escrever "recebi este pacote!" e enviar-lhe uma mensagem de volta. Limitam-se a encaminhá-lo o mais rápido possível.

Então, como é que o seu telemóvel obriga estes routers a identificarem-se? Com um truque astuto de "sem combustível".

Cada pacote de dados tem um contador oculto chamado TTL (Time to Live). Pense no TTL como um depósito de combustível digital. Sempre que o pacote passa por um router, esse router subtrai 1 ao depósito. Se o depósito chegar a zero ($0$), o router é obrigado pelas regras da internet a destruir o pacote e a enviar uma mensagem de volta ao seu telemóvel dizendo: "Lamento, o seu pacote ficou sem combustível no meu endereço!"

O traceroute explora esta regra de forma sistemática:

* Paragem 1: o seu telemóvel envia um pacote com 1 unidade de combustível. Chega ao router Wi-Fi de sua casa. O router subtrai 1. O depósito está agora a 0. O router descarta o pacote e envia uma mensagem de erro ao seu telemóvel. Bingo! A paragem 1 (o seu router de casa) acabou de se identificar.
* Paragem 2: o seu telemóvel envia um novo pacote com 2 unidades de combustível. Passa pelo router de casa (baixando para 1 de combustível) e chega ao centro local do seu fornecedor de internet. O centro subtrai 1. O combustível está agora a 0. O centro descarta o pacote e envia uma mensagem de erro. Bingo! A paragem 2 acabou de se identificar.
* Paragem 3: o seu telemóvel envia um pacote com 3 unidades de combustível...

O seu telemóvel repete este processo, aumentando o limite de combustível em 1 de cada vez, até o pacote ter finalmente combustível suficiente para chegar ao destino real. Ao recolher todas as mensagens de erro de "sem combustível", o seu telemóvel consegue reconstruir um mapa perfeito e sequencial de toda a viagem.


## O que é um "nó oculto" (* * *)?

Por vezes, um passo do seu traceroute aparece como * * * ou "nó oculto", sem nome.
Não entre em pânico — isto não significa que a sua internet esteja avariada! Muitas grandes empresas, redes governamentais e firewalls de segurança desativam deliberadamente as suas funções de "relatório de erros". Quando o seu pacote fica sem combustível dentro do sistema deles, deitam-no silenciosamente ao lixo sem lhe enviar de volta a mensagem de erro "sem combustível". Os seus dados continuam a passar em segurança, apenas preferem viajar de forma anónima por motivos de segurança!
