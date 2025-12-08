#!/usr/bin/bash


//Menu principal do script onde o utilizador ira navegar 

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