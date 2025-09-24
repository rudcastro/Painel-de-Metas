# Projeto Power BI: Painel Interativo de Metas

#### Aluno: Rud Wengensurica de Castro https://github.com/rudcastro
#### Orientador: Anderson Nascimento 


Trabalho apresentado ao curso [BI MASTER](https://ica.puc-rio.ai/bi-master) como pré-requisito para conclusão de curso e obtenção de crédito na disciplina "Projetos de Sistemas Inteligentes de Apoio à Decisão".

- [Link para o código] https://github.com/rudcastro/Painel-de-Metas

- [Link para a monografia](https://Projeto_Interativo_Metas.pdf)

---

### Resumo

Este documento detalha o desenvolvimento de um painel interativo de metas utilizando a ferramenta Power BI, com o objetivo primordial de oferecer uma plataforma visual para o acompanhamento e análise de desempenho em diversas áreas e funções organizacionais. A implementação deste painel visa otimizar a monitorização do cumprimento de metas, promover a tomada de decisões baseada em dados e aprimorar a gestão estratégica por meio de uma interface acessível e rica em informações. A metodologia empregada englobou etapas críticas de transformação e modelagem de dados, bem como a criação de medidas e Key Performance Indicators (KPIs) robustos para garantir a precisão e a relevância das análises. A solução se destaca pela integração de dados de sistemas legados (Oracle PROTHEUS) e fontes modernas (SharePoint), demonstrando uma arquitetura flexível e escalável, pensada para o ambiente dinâmico de uma organização jurídica.


### 1. Introdução

Este projeto consiste no desenvolvimento de um Painel Interativo de Metas utilizando o Microsoft Power BI. O objetivo principal é fornecer à organização uma ferramenta visual e dinâmica para o acompanhamento e análise do desempenho em diversas áreas-chave, substituindo processos manuais e dispersos de coleta e análise de dados.

Problema Resolvido: Fragmentação de dados, relatórios estáticos, dificuldade na identificação proativa de desvios e oportunidades de desempenho.

Solução: Unificação de dados de múltiplas fontes em um painel interativo que oferece insights rápidos e acionáveis, promovendo a tomada de decisões baseada em dados e aprimorando a gestão estratégica.

Tecnologias Envolvidas:
   Power BI: Para ETL (Power Query), Modelagem (Power Pivot) e Visualização (Power View).
   Oracle Database (PROTHEUS): Como fonte primária de dados transacionais via Views (`V_PROTHEUS_BI_NOTAS_EMITIDAS`, `V_PROTHEUS_BI_TIME_SHEETS`, etc.).
   Microsoft SharePoint: Para armazenamento de arquivos de metas e dados complementares (`Meta.xlsx`, `BI_Marketing.xlsx`, `Despesas.xlsx`, etc.).
   PostgreSQL: Para dados específicos de equipes (`public.c_equipes`).

Benefícios Principais:
   Monitoramento proativo e preciso de metas financeiras, operacionais, comerciais e de marketing.
   Suporte à tomada de decisão estratégica e ágil.
   Aumento da transparência e engajamento da equipe.
   Otimização da alocação de recursos.

### 2. Modelagem

 arquitetura da solução baseia-se na integração de dados de fontes diversas, passando por um rigoroso processo de preparação e estruturação no Power BI.

### Fluxo de Dados
1.  Extração: Coleta de dados de Oracle (via Views), SharePoint (arquivos Excel) e PostgreSQL.
2.  Transformação (Power Query): Aplicação de regras de negócio, padronização e limpeza dos dados, incluindo:
       Alteração de tipos de dados (ex: `date`, `Int64.Type`).
       Substituição de valores (ex: "LLM" por "PUC" para uniformizar identificadores de sócios).
       Remoção de registros irrelevantes (ex: certas `car_dsc` em `TabelaTS`, contratos "[PROSP]").
       Criação de colunas auxiliares (ex: `Data Formatada`, `Mês/Ano`).
       Tratamento de erros e valores nulos para garantir a qualidade dos dados.
3.  Carregamento e Modelagem (Power Pivot):
       Os dados transformados são carregados no modelo de dados do Power BI.
       Estrutura dimensional (Star/Snowflake Schema) com tabelas de fato (ex: `Notas Emitidas`, `Despesas`, `TabelaTS`) e tabelas de dimensão.
       Dimensões Chave:
           `public v_kincaid_profissionais_bi`: Centraliza as informações dos sócios/profissionais, conectando-se a diversas tabelas de metas e atividades.
           `Calendario`: Dimensão de tempo para análises temporais flexíveis (ano, mês, dia).
       Relacionamentos: Estabelecimento de relacionamentos `One-to-Many` entre dimensões e fatos, garantindo a correta propagação de filtros e a integridade referencial. Relacionamentos inativos são utilizados para cenários específicos de cálculo via DAX (`USERELATIONSHIP`).

### 3. Resultados

O projeto culmina em um painel Power BI interativo que oferece uma visão abrangente e detalhada do desempenho da organização, com base em mais de 20 tabelas de dados e um conjunto robusto de medidas e KPIs.

### Análises Disponíveis
   Metas Financeiras: Faturamento anual/mensal, despesas anuais/mensais, rentabilidade por sócio.
   Metas Operacionais: Horas trabalhadas (totais e mensais), custo por hora trabalhada.
   Metas Comerciais/Marketing: Prospecção e conversão de clientes, gestão de contratos, rankings, associações, eventos e publicações.
   Metas Pessoais: Acompanhamento de metas de desenvolvimento individual dos sócios.

### KPIs e Medidas Desenvolvidos
Um extenso conjunto de medidas DAX foi criado para fornecer insights precisos, incluindo:
   `Meta Anual Total`, `Despesas Totais`, `Horas Trabalhadas Totais`.
   `Cumprimento de Meta`, `Percentual de Cumprimento da Meta Anual/Mensal`.
   `Meta de Faturamento por Profissional`, `Índice de Rentabilidade por Sócio`.
   `Taxa de Conversão de Prospectos`, `Custo Operacional por Meta`.
   `Meta Acumulada Faturamento Anual`, `Meta Horas Trabalhadas Anual`.
   `KPI Desempenho` (Meta Atingida/Não Atingida).

### Interatividade e Visualização
O painel permite aos usuários:
   Navegar entre diferentes seções de análise (faturamento, despesas, marketing, etc.).
   Filtrar dados por dimensões como ano, mês, sócio, equipe, tipo de despesa, etc., utilizando segmentadores.
   Interagir com os visuais através de filtros cruzados e funcionalidades de drill-down e drill-through para explorar detalhes.
   Visualizar tendências (gráficos de linha), comparações (gráficos de barra) e status (cartões e KPIs com indicadores visuais).

### 4. Conclusões

O Painel Interativo de Metas em Power BI representa um salto qualitativo na gestão de desempenho da organização. Ele transforma uma vasta quantidade de dados dispersos em informações inteligíveis e acionáveis, capacitando a liderança a tomar decisões mais rápidas e eficazes.

Impacto:
   Melhor visibilidade e compreensão do desempenho em relação às metas.
   Agilidade na identificação de desvios e oportunidades.
   Fomento a uma cultura de desempenho e transparência.

Desafios Enfrentados:
   Garantia da qualidade e consistência dos dados de múltiplas fontes.
   Complexidade na criação de medidas DAX robustas para cenários de negócios específicos.
   Integração de sistemas heterogêneos.

Próximos Passos e Melhorias Sugeridas:

   Expansão da Segurança em Nível de Linha (RLS) para todos os perfis de usuários.
   Implementação de alertas e notificações automatizadas sobre o status das metas.
   Integração com ferramentas de colaboração e exploração de análises preditivas simples.
   Coleta de feedback dos usuários para melhorias contínuas no painel.
---

Matrícula: 231.101.099

Pontifícia Universidade Católica do Rio de Janeiro

Curso de Pós Graduação Business Intelligence Master 2023.2
