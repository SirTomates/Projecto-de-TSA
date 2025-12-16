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
            return
        fi
    echo "- Número do contacto =>"; read num
        if [ -z "$num" ]; then
            return
        fi
   
   # Validação (Portugal – 9 dígitos começando por 9)
    if ! [[ "$num" =~ ^9[0-9]{8}$ ]]; then
        echo "************************";
        echo "    Número invalido ";
        echo "************************";
       return
    fi

    echo "Deseja guardar o contacto?(s/n)"; read conf
    [[ "$conf" != "s" ]] && { echo "Cancelado."; return; }

    echo "$nome|$num" >> "$ARQ_Contactos"
    echo "Contato guardado."

     clear
}

listar_contatos() {
    echo "--- Lista Telefónica ---"
    echo "ID. -  Nome   -   Número"
    echo "-------------------------"

    nl -w2 -s". " "$ARQ_Contactos" | sed 's/|/ - /'
    echo ""
    echo "-------------------------"
    echo "Deseja remover algum contacto? (s/n)"
    read resp


    if [[ "$resp" == "s" ]]; then
    read -p "Digite o número do ID contacto a remover: " id

    # procura o id na lista e verifica se exite
    total=$(wc -l < "$ARQ_Contactos")
    if [[ "$id" -lt 1 || "$id" -gt "$total" ]]; then
    echo "ID inválido."
    return
    
    fi

    # mostra o contacto a remover e pede confirmação
    contato=$(sed -n "${id}p" "$ARQ_Contactos")
    echo "Vai remover: $(echo "$contato" | sed 's/|/ - /')'"
    read -p "Confirmar remoção? (s/n): " conf
    [[ "$conf" != "s" ]] && { echo "Cancelado."; return; }

    # remove o contacto
    sed -i "${id}d" "$ARQ_Contactos"
    echo "Contacto removido com sucesso."
    fi

}


clear
menu_principal