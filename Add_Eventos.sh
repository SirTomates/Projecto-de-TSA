#!/usr/bin/bash


# Bases de dados dos eventos e contactos

ARQ_Eventos="eventos.db"
ARQ_Contactos="contactos.db"







# Menu principal do script onde o utilizador ira navegar 

menu_principal() {

    clear

    while true; do
        echo "===================================="
        echo "           MENU PRINCIPAL"
        echo "===================================="
        echo "1) Adicionar evento"
        echo "2) Consultar eventos"
        echo "3) Listar contatos"
        echo "4) Sair"
        read -p "Opção: " op

        case $op in
            1) adicionar_evento ;;
            2) consultar_eventos ;;
            3) listar_contatos ;;
            4) clear && exit ;;
            *) clear && echo "Opção inválida";;
        esac
    done
}


# Funcao para adicionar contactos

adicionar_contato() {

    # Solicita o nome e número do contacto
    echo "- Nome do novo contacto =>"; read nome
        if [ -z "$nome" ]; then
            return
        fi
    echo "- Número do contacto (<9 dígitos, começando por 9)=>"; read num
        if [ -z "$num" ]; then
            return
        fi
   
   # Validação (Portugal – 9 dígitos começando por 9)
    if ! [[ "$num" =~ ^9[0-9]{8}$ ]]; then
        clear
        echo "************************";
        echo "    Número invalido ";
        echo "************************";
       return
    fi
    # Pede confirmação antes de guardar
    echo "Deseja guardar o contacto $nome | $num ?(s/n)"; read conf
    [[ "$conf" != "s" ]] && { echo "Cancelado."; return; }

    echo "$nome|$num" >> "$ARQ_Contactos"
    clear
    echo "Contato guardado."

}

remover_contato() {

    echo "Digite o número do ID contacto a remover: "
    read id

    # procura o id na lista e verifica se exite
    total=$(wc -l < "$ARQ_Contactos")
    if [[ "$id" -lt 1 || "$id" -gt "$total" ]]; then
        clear 
        echo "************************"
        echo "      ID inválido."
        echo "|           -           |"
        return
    fi

    # mostra o contacto a remover e pede confirmação
    contato=$(sed -n "${id}p" "$ARQ_Contactos")
    echo "Vai remover: $(echo "$contato" | sed 's/|/ - /')'"
    read -p "Confirmar remoção? (s/n): " conf
    [[ "$conf" != "s" ]] && { echo "Cancelado."; return; }

    # remove o contacto
    sed -i "${id}d" "$ARQ_Contactos"
    echo "============================="
    echo "Contacto removido com sucesso."

    clear
}


# Funcao para listar contactos
listar_contatos() {
   
    clear
   
    # Loop para mostrar a lista de contactos e opções
    while true; do
        echo "--- Lista Telefónica ---"
        echo "ID. -  Nome   -   Número"
        echo "-------------------------"

        nl -w2 -s". " "$ARQ_Contactos" | sed 's/|/ - /'
        echo ""
        echo "-------------------------"
        echo ""
        echo "1) Remover contacto"
        echo "2) Adicionar contacto"
        echo "3) Voltar ao menu principal"
        read -p "Opção: " op

        case $op in
            1) remover_contato ;;
            2) adicionar_contato ;;
            3) clear && return ;;
            *) clear && echo "Opção inválida";;
        esac
    done
    echo ""

    clear
}

adicionar_evento() {
    clear
    echo " --- Adicionar Evento ---"
    echo "Insira a descrição do evento:"
    read descricao
    echo "Insira a data do evento (DD/MM/AAAA):"
    read data
    echo "Insira a hora do evento (HH:MM):"
    read hora



    
}


clear
menu_principal