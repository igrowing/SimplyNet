# Teste de velocidade

O SimplyNet mede a sua ligação à internet transferindo dados de e para um servidor de teste e cronometrando-os. São apresentados três números:

- **Download** — a rapidez com que os dados chegam ao seu dispositivo, em Mbps. Quanto mais alto, melhor.
- **Upload** — a rapidez com que o seu dispositivo envia dados, em Mbps. Quanto mais alto, melhor.
- **Ping** — o atraso de ida e volta até ao servidor, em milissegundos. Quanto mais baixo,
  melhor.

## Escolher um fornecedor

O menu suspenso por baixo do botão **Iniciar teste** seleciona qual o backend de teste que é
usado.

## Comparação dos serviços de teste de velocidade

| Característica | Cloudflare (predefinição) | Ookla |
|---|---|---|
| Objetivo da medição | Velocidade real de navegação web | Capacidade teórica absoluta da linha |
| Estado de privacidade | 100% anónimo. Sem rastreio | Recolhe IP, localização e dados do dispositivo |
| Método técnico | Download progressivo de fluxo único | Saturação de rede de múltiplos fluxos |
| Ideal para | Avaliar o desempenho diário da internet | Verificar as velocidades anunciadas pelo ISP |

### Via Cloudflare (predefinição)

Usa os endpoints públicos `speed.cloudflare.com` da Cloudflare. Não é necessária conta nem consentimento adicional, e nenhum identificador pessoal é partilhado além da informação normal que qualquer pedido a um site transporta (como o seu endereço IP, necessário para entregar a resposta).

Esta é a opção recomendada para a maioria dos utilizadores.

### Via Ookla

Usa a rede global de servidores speedtest.net da Ookla — a mesma infraestrutura por detrás do conhecido serviço Speedtest. Os servidores da Ookla são operados por terceiros em todo o mundo, por isso um teste liga-se ao servidor mais próximo e acessível.

Como isto envolve servidores de terceiros, escolher a Ookla pede o seu consentimento na primeira vez. **A Ookla recolhe e partilha o seu endereço IP, identificadores do dispositivo e dados de localização.** A sua escolha é memorizada para não voltar a ser questionado; pode voltar à Cloudflare a qualquer momento.

Quando a Ookla está ativa, o botão **Iniciar teste** fica âmbar como lembrete de que está em uso um backend de terceiros. A Cloudflare restaura o botão azul.

## Dicas para resultados precisos

- Faça o teste por Wi-Fi ou dados móveis, consoante o que quer medir.
- Feche outras apps que possam estar a usar a rede.
- Execute o teste algumas vezes — os resultados variam com as condições da rede e a carga do servidor.
- Ligações de velocidade muito alta podem ser limitadas pelo dispositivo ou pelo método de teste, e não pela sua ligação real.

## Privacidade

Os resultados são guardados apenas no seu dispositivo, em **Medições anteriores**. Pode apagá-los a qualquer momento na secção do histórico. O SimplyNet não carrega os seus resultados para nenhum lado.
