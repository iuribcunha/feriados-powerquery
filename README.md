# Feriados Brasileiros — Power Query (M)

Função em M Language que gera uma tabela com todos os feriados brasileiros entre dois anos. Cobre feriados nacionais, estaduais/municipais e os móveis (Carnaval, Páscoa, etc.).

---

## O que faz

Recebe um intervalo de anos e retorna uma tabela com as colunas `Data` (date) e `Feriado` (text), ordenada cronologicamente.

```
FeriadosBrasileiros(2025, 2030)
```

## Como usar

1. Abra o **Power Query Editor** (Power BI ou Excel)
2. Crie uma nova consulta em branco
3. Cole o código e renomeie para `FeriadosBrasileiros`
4. Chame a função passando o ano inicial e final:

```powerquery
= FeriadosBrasileiros(2025, 2034)
```

## Feriados incluídos

**Fixos (nacionais):** Ano Novo, Tiradentes, Dia do Trabalho, Independência, Nossa Sra. Aparecida, Finados, Proclamação da República, Consciência Negra e Natal.

**Fixos (estaduais/municipais):** Por padrão inclui a Revolução Constitucionalista (SP, 09/07). Para adicionar ou trocar, edite o registro `Feriados_Municipais_Estaduais` no código.

**Móveis (calculados pela Páscoa):** Carnaval (Páscoa − 47), Paixão de Cristo (Páscoa − 2), Domingo de Páscoa e Corpus Christi (Páscoa + 60).

O cálculo da Páscoa segue o [Algoritmo Anônimo Gregoriano](https://en.wikipedia.org/wiki/Date_of_Easter).

## Como personalizar

Para adicionar um feriado municipal, insira um registro na lista `Feriados_Municipais_Estaduais`:

```powerquery
Feriados_Municipais_Estaduais = {
    [Data = #date(y, 07, 09), Feriado = "Revolução Constitucionalista"],
    [Data = #date(y, 01, 25), Feriado = "Aniversário de São Paulo"]
},
```

## Código

O arquivo `feriados.m` contém a implementação completa. A estrutura é:

1. Gera a lista de anos no intervalo
2. Para cada ano, calcula a Páscoa
3. Monta as listas de feriados fixos e móveis
4. Concatena tudo e converte em tabela

---

*Algoritmo da Páscoa: [Wikipedia — Date of Easter](https://en.wikipedia.org/wiki/Date_of_Easter)*
