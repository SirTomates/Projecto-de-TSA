#!/usr/bin/bash


# Bases de dados dos eventos e contactos

ARQ_Eventos="eventos.db"
ARQ_Contactos="contactos.db"







# Menu principal do script onde o utilizador ira navegar 

menu_principal() {
    while true; do
        echo "===================================="
        echo "           MENU PRINCIPAL"
        echo "===================================="
        echo "1) Adicionar evento"
        echo "2) Consultar eventos"
        echo "3) Adicionar contato"
        echo "4) Listar contatos"
        echo "5) Sair"
        read -p "Opção: " op

        case $op in
            1) adicionar_evento ;;
            2) consultar_eventos ;;
            3) adicionar_contato ;;
            4) listar_contatos ;;
            5) exit ;;
            *) echo "Opção inválida";;
        esac
    done
}


# Funcao para adicionar contactos

adicionar_contato() {

    echo "- Nome do novo contacto =>"; read nome
        if [ -z "$nome" ]; then
            menu_principal
        fi
    echo "- Número do contacto =>"; read num
        if [ -z "$num" ]; then
            menu_principal
        fi
   
    if ! [[ "$num" =~ ^9[0-9]{8}$ ]]; then
        echo "************************";
        echo "    Número invalido ";
        echo "************************";
        $nome=null
        adicionar_contato
    fi

    echo "Deseja guardar o contacto?(s/n)"; read conf
    [[ "$conf" != "s" ]] && { echo "Cancelado."; return; }

    echo "$nome|$numero" >> "$ARQ_Contactos"
    echo "Contato guardado."

     clear
}

listar_contatos() {
    echo "--- Lista Telefónica ---"
    nl -w2 -s". " "$ARQ_Contactos" | sed 's/|/ - /'
}


clear
menu_principal