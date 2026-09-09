// FeriadosBrasileiros
// Retorna uma tabela com todos os feriados entre os anos informados,
// incluindo feriados nacionais, estaduais/municipais e móveis (baseados na Páscoa).
//
// Parâmetros:
//  anoInicial (number) - Primeiro ano de referência (ex: 2025)
//  anoFinal   (number) - Último ano de referência (ex: 2034)
//
// Retorno: Table com colunas [Data, Feriado]
(anoInicial as number, anoFinal as number) as table =>
let

    // Lista de anos entre anoInicial e anoFinal (inclusive)
    anos = List.Numbers(anoInicial, anoFinal - anoInicial + 1),

    // Calcula os feriados de um único ano
    FeriadosDeAno = (y as number) as table =>
        let
            // Cálculo da Páscoa, base para os feriados móveis.
            // Algoritmo Anônimo Gregoriano, conforme
            // https://en.wikipedia.org/wiki/Date_of_Easter

            a = Number.Mod(y, 19),                              // Posição no ciclo de Metônico
            b = Number.RoundDown(y / 100),                      // Século
            c = Number.Mod(y, 100),                             // Ano dentro do século
            d = Number.RoundDown(b / 4),                        // Quociente da correção secular
            e = Number.Mod(b, 4),                               // Resto da correção secular
            f = Number.RoundDown((b + 8) / 25),                 // Correção do ciclo lunar
            g = Number.RoundDown((b - f + 1) / 3),              // Ajuste adicional do ciclo lunar
            h = Number.Mod((19 * a + b - d - g + 15), 30),      // Epacta (lua cheia eclesiástica)
            i = Number.RoundDown(c / 4),                        // Quociente do ajuste bissexto do século
            k = Number.Mod(c, 4),                               // Resto do ajuste bissexto do século
            l = Number.Mod((32 + 2 * e + 2 * i - h - k), 7),    // Domingo após a lua cheia
            m = Number.RoundDown((a + 11 * h + 22 * l) / 451),  // Correção final do calendário
            n = Number.RoundDown((h + l - 7 * m + 114) / 31),   // Mês da Páscoa
            o = Number.Mod((h + l - 7 * m + 114), 31),          // Dia da Páscoa (0 a 30)
            pascoa = #date(y, n, o + 1),                        // Data da Páscoa (o dia começa em 0, por isso o +1)

            // Feriados municipais e estaduais.
            // Ajuste a lista conforme o município ou estado desejado.
            Feriados_Municipais_Estaduais = {
                [Data = #date(y, 7, 9), Feriado = "Revolução Constitucionalista"] // SP
            },

            // Feriados nacionais, com datas fixas definidas por lei federal
            Feriados_Nacionais = {
                [Data = #date(y, 1, 1), Feriado = "Ano Novo"],
                [Data = #date(y, 4, 21), Feriado = "Tiradentes"],
                [Data = #date(y, 5, 1), Feriado = "Dia do Trabalho"],
                [Data = #date(y, 9, 7), Feriado = "Dia da Independência"],
                [Data = #date(y, 10, 12), Feriado = "Nossa Sra. Aparecida"],
                [Data = #date(y, 11, 2), Feriado = "Finados"],
                [Data = #date(y, 11, 15), Feriado = "Proclamação da República"],
                [Data = #date(y, 11, 20), Feriado = "Consciência Negra"],
                [Data = #date(y, 12, 25), Feriado = "Natal"]
            },

            // Feriados móveis, calculados em relação à Páscoa
            Feriados_Moveis = {
                [Data = Date.AddDays(pascoa, -47), Feriado = "Carnaval"],          // 47 dias antes
                [Data = Date.AddDays(pascoa, -2),  Feriado = "Paixão de Cristo"],  // Sexta-feira Santa
                [Data = pascoa,                    Feriado = "Domingo de Páscoa"],
                [Data = Date.AddDays(pascoa, 60),  Feriado = "Corpus Christi"]     // 60 dias depois
            },

            // Une as três listas e converte em tabela [Data, Feriado]
            Resultado_Ano = Table.FromRecords(
                Feriados_Municipais_Estaduais & Feriados_Nacionais & Feriados_Moveis
            )
        in
            Resultado_Ano,

    // Aplica a função a cada ano da lista e concatena o resultado
    Resultado = Table.Combine(List.Transform(anos, each FeriadosDeAno(_)))

in
    Resultado
