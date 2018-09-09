# Development of embedded software for ACC audio decoding

Oriented by the Prof. Dr. Ricardo Jacobi, for the PIBIC 2012/2013

Technologies used: FPGAs with Verilog and C.

## Introdução

Foi recebido a propriedade intelectual de um ótimo processador, o BA22-DE, para que possamos testar sua performance para o algoritimo de decodificação de áudio AAC feito pela equipe da UnB. O processador foi recebido pronto apenas para a simulação, ou seja, não sintetizável. Durante o trabalho foi feito um estudo de sua arquitetura e, com base no código para simulação, foi elaborada uma arquitetura básica para a síntese do BA22-DE em uma placa com FPGA.

No futuro, espera ser possível utilizar a estratégia de co-design de Hardware e Software em sistemas embarcados para substituir o processador NIOS II pelo BA22 como processador de propósito geral.

## Metodologia

O primeiro passo para o desenvolvimento deste projeto foi realizar a simulação do funcionamento do processador para observar o comportamento dos sinais gerados pelo sistema, a leitura da documentação e o estudo do código não sintetizável já existente. Foi possível realizar um profiling de que módulos estavam sendo ativados com a execução de um algorítimo simples, através do estudo dos sinais gerados, assim identificando os módulos indispensáveis ao design e que deveriam ser implementados para síntese.
Estes foram feitos utilizando a linguagem Verilog HDL.

O entendimento da documentação do BA22-DE foi essencial, uma vez que esse se trata de uma caixa-preta, da qual não temos acesso ao código fonte de seu design.

A simulação do sistema também foi de grande utilidade, por ser tanto um ponto de partida como um norteador do sistema final. Simular o sistema também é muito mais rápido do que realizar a síntese para teste em FPGA.

## Resultados

O sistema foi prototificado na placa de desenvolvimento DE2-115, que possui uma FPGA Altera Cyclone IV E, modelo EP4CE115F29C. Foi executado com sucesso o código de teste na placa com FPGA no processador BA22-DE sintetizado com a arquitetura básica proposta.

O resultado da síntese mostrou que o sistema desenvolvido utiliza 17.413 elementos lógicos, 3758 registros, 18 pinos, 1.361.984 bits de memória interna, 8 multiplicadores de 9 bits e nenhum PLL.

## Discussão/Conclusão

Neste trabalho desenvolveu-se uma arquitetura em hardware para a síntese do processador de embebidos BA22-DE. Optou-se por uma metodologia com utilização de um design para simulação para realizar um profiling do que seria necessário para o funcionamento do processador. O sistema desenvolvido foi prototificado em uma FPGA. Os resultados mostram que o objetivo foi alcançado.

Cabe mencionar que este é apenas o primeiro passo para viabilizar a decodificação de áudio AAC em tempo real no processador BA22-DE e após isso, substituir o processador NIOS II pelo BA22 para utilizar o processador BA22 como uma solução de co-design com o decodificador de áudio AAC.

## Palavras-chave
FPGA; AAC Decoder; BA22; Embedded Processor; RISC

## Colaboradores
Renato Coral Sampaio
