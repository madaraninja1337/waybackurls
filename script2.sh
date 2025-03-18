#!/usr/bin/env bash

# Inicializando variáveis
F=""
D=""
PN=1  # Página inicial padrão
PM=1  # Página final padrão

# Parsing manual dos argumentos
while [[ $# -gt 0 ]]; do
    case "$1" in
        -f) F="$2"; shift 2;;
        -d) D="$2"; shift 2;;
        -pn) PN="$2"; shift 2;;
        -pm) PM="$2"; shift 2;;
        *) echo "Uso: $0 -f <arquivo> -d <dominio> -pn <pagina inicial> -pm <pagina final>"; exit 1;;
    esac
done

# Se apenas o domínio for passado, mostra o número de páginas disponíveis
if [[ -n "$D" && -z "$F" && -z "$PN" && -z "$PM" ]]; then
    curl -s "http://web.archive.org/cdx/search/cdx?url=*.$D/*&collapse=urlkey&showNumPages=true"
    exit 0
fi

# Verifica se os argumentos obrigatórios foram passados
if [[ -z "$F" || -z "$D" || -z "$PN" || -z "$PM" ]]; then
    echo "Uso: $0 -f <arquivo> -d <dominio> -pn <pagina inicial> -pm <pagina final>"
    exit 1
fi

# Garante que a última página seja maior ou igual à primeira
if [[ "$PM" -lt "$PN" ]]; then
    echo "Erro: A última página (-pm) não pode ser menor que a primeira (-pn)."
    exit 1
fi

echo "🔎 Buscando URLs de $D das páginas $PN até $PM..."

# Loop sobre as páginas dentro do intervalo
for (( P=PN; P<=PM; P++ )); do
    echo "📄 Baixando página $P..."
    curl -s "http://web.archive.org/cdx/search/cdx?url=*.$D/*&output=txt&fl=original&limit=100000&page=$P" >> "$F"
done

echo "✅ Busca concluída! Resultados salvos em '$F'."
