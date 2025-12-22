#!/usr/bin/bash


# Bases de dados dos eventos e contactos

ARQ_Eventos="eventos.db"
ARQ_Contactos="contactos.db"



# Funções auxiliares
get_numero_por_id() {
    sed -n "${1}p" "$ARQ_Contactos" | cut -d '|' -f2
}


validar_data() {
    date -d "$1" +%Y-%m-%d >/dev/null 2>&1
    return $?
}


validar_hora() {
    [[ "$1" =~ ^([01]?[0-9]|2[0-3]):[0-5][0-9]$ ]]
    return $?
}


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
        read -p "Enter para continuar..."
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
        read -p "Enter para continuar..."
        return
    fi

    # mostra o contacto a remover e pede confirmação
    contato=$(sed -n "${id}p" "$ARQ_Contactos")
    echo "Vai remover: $(echo "$contato" | sed 's/|/ - /')'"
    read -p "Confirmar remoção? (s/n): " conf
    [[ "$conf" != "s" ]] && { echo "Cancelado."; }
    read -p "Pressione 'Enter' para continuar..."
    clear
    return
    

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

# Função para adicionar eventos
adicionar_evento() {
    clear
    echo " --- Adicionar Evento ---"

    echo "Nome do evento:"; read nome_evento
    [[ -z "$nome_evento" ]] && return

    echo "Descrição do evento:"; read descricao_evento
    [[ -z "$descricao_evento" ]] && return

    while true; do
        echo "Data (YYYY-MM-DD):"; read data
        validar_data "$data" && break
        echo "Data inválida! Tente novamente."
    done

    
    while true; do
        echo "Hora (HH:MM):"; read hora
        validar_hora "$hora" && break
        echo "Hora inválida! Tente novamente."
    done

    # Adicionar contactos ao evento
    contatos=""
    contatos_txt=""

    echo "Adicionar contatos? (s/n)"; read esc

    # Loop para adicionar contactos
    if [[ "$esc" == "s" ]]; then
         while true; do
            clear
            echo "--- Adicionar Contatos ao Evento ---"
            echo "1) Da lista"
            echo "2) Novo número"
            echo "3) Finalizar"
            read -p "Escolha: " op

            case $op in
                 1)
                    echo "--- Lista Telefónica ---"
                    echo "ID. -  Nome   -   Número"
                    echo "-------------------------"

                    nl -w2 -s". " "$ARQ_Contactos" | sed 's/|/ - /'

                    read -p "ID do contato: " idc

                    linha=$(sed -n "${idc}p" "$ARQ_Contactos")
                    nome=$(echo "$linha" | cut -d'|' -f1)
                    num=$(echo "$linha" | cut -d'|' -f2)


                    if [[ -n "$num" ]]; then
                        contatos+="$num "
                        contatos_txt+="$nome, "
                    fi
                    ;;

                2)
                    read -p "Novo número (9XXXXXXXX): " novo
                    if ! [[ "$novo" =~ ^9[0-9]{8}$ ]]; then
                        echo "Número inválido."
                        read -p "Enter para continuar..."
                        continue
                    fi
                    contatos+="$novo "
                    contatos_txt+="Novo($novo), "
                    ;;

                3) 
                    break ;;
                    *) echo "Opção inválida";;
            esac
        done
    fi


    echo "Confirmar guardar evento?"
    echo "Data: $data"
    echo "Hora: $hora"
    echo "Evento: $nome_evento"
    echo "Descrição: $descricao_evento"
    echo "Contactos: ${contatos_txt%, }"

    # Confirmar guardar evento
    read -p "Confirmar (s/n): " conf
    [[ "$conf" != "s" ]] && { echo "Cancelado."; clear ;return; }

    # Guarda o evento no arquivo
    echo "$data|$hora|$nome_evento|$descricao_evento|$contatos" >> "$ARQ_Eventos"
    echo "Evento guardado!"
    read -p "Enter para continuar..."
    clear
}

# Função para consultar eventos
consultar_eventos() {
    clear
    echo "--- Eventos Registados ---"
    if [[ ! -s "$ARQ_Eventos" ]]; then
        echo "Sem eventos."
    else
        nl -w2 -s". " "$ARQ_Eventos" | sed 's/|/ - /g'
    fi
    read -p "Enter para continuar..."
    clear
}


clear
menu_principal