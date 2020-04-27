#include "protheus.ch"

//--------------------------------------------------------------
/*/{Protheus.doc} TK271LEG
Description //Define a Lengenda das Rotinas (TeleMarketing, Televendas e Telecobranca)
@param xParam Parameter //Opção da pasta selecionada (1=TeleMarketing, 2=Televendas e 3=Telecobranca)
@return xRet Return //array com as legendas definidas
@author  - Alexis Duarte
@since 03/01/2019 /*/
//--------------------------------------------------------------
User Function TK271LEG(cPasta)

	Local aArea := getArea()
	Local cOpcao := cPasta
	Local aCores := {}

    Do Case
        Case cOpcao == "1" //Telemarketing                
            aCores := { {"BR_AZUL"		,"Atendimento Planejado" },;    //"Atendimento Planejado" --> Padrão
                        {"BR_VERMELHO" 	,"Atendimento Pendente" },;     //"Atendimento Pendente" --> Padrão
                        {"BR_VERDE"		,"Atendimento Encerrado" },;	//"Atendimento Encerrado" --> Padrão
                        {"BR_PRETO"		,"Atendimento Cancelado" },;	//"Atendimento Cancelado" --> Padrão
                        {"BR_AMARELO"   ,"Em Andamento"  },;            //"Em Andamento" --> Customizado Komfort
                        {"BR_LARANJA"   ,"Visita Tecnica"},;	        //"Visita Tec" --> Customizado Komfort
                        {"BR_PINK"      ,"Devolucao"},;	                //"Devolucao" --> Customizado Komfort
                        {"BR_BRANCO"    ,"Retorno"},;	                //"Retorno" --> Customizado Komfort
                        {"BR_VIOLETA"   ,"Troca Autorizada"},;          //"Troca Aut" --> Customizado Komfort
                        {"BR_CINZA"		,"Compartilhamento" },;		    //"Compartilhamento" --> Padrão
                        {"BR_AZUL_CLARO","Email Fabricante"},;		    //"Compartilhamento" --> Padrão
                        {"BR_VERDE_ESCURO","Foto/Vídeo"},;              // Foto/Vídeo --> Customizado Komfort
                        {"BR_MARRON","Canc/Bloqueado"},;                 // Canc/Bloqueado --> Customizado Komfort
                        {"BR_MARRON_OCEAN","Canc/Liberado"}}            // Canc/Liberado --> Customizado Komfort

        Case cOpcao == "2" //Televendas
            aCores := { {"BR_MARRON"  	,"Atendimento" },;  //"Atendimento" --> Padrão
                        {"BR_AZUL"		,"Orçamento" },;	//"Orçamento" --> Padrão
                        {"BR_VERDE"    	,"Faturamento" },;	//"Faturamento" --> Padrão
                        {"BR_VERMELHO" 	,"NF.Emitida" },;   //"NF.Emitida" --> Padrão
                        {"BR_PRETO"    	,"Cancelado" }} 	//"Cancelado" --> Padrão

        Case cOpcao == "3" //Telecobranca
            aCores := {{"BR_AZUL"   	,"Atendimento"},;	//"Atendimento" --> Padrão
                       {"BR_VERDE"  	,"Cobrança"},;		//"Cobrança" --> Padrão
                       {"BR_VERMELHO"   ,"Encerrado"},;		//"Encerrado" --> Padrão
                       {"BR_CINZA"  	,"Cancelado" }}		//"Cancelado" --> Padrão
    EndCase
        
    restArea(aArea)

Return aCores