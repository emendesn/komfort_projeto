#include "protheus.ch"

//--------------------------------------------------------------
/*/{Protheus.doc} TK271LEG
Description //Define a Lengenda das Rotinas (TeleMarketing, Televendas e Telecobranca)
@param xParam Parameter //Op��o da pasta selecionada (1=TeleMarketing, 2=Televendas e 3=Telecobranca)
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
            aCores := { {"BR_AZUL"		,"Atendimento Planejado" },;    //"Atendimento Planejado" --> Padr�o
                        {"BR_VERMELHO" 	,"Atendimento Pendente" },;     //"Atendimento Pendente" --> Padr�o
                        {"BR_VERDE"		,"Atendimento Encerrado" },;	//"Atendimento Encerrado" --> Padr�o
                        {"BR_PRETO"		,"Atendimento Cancelado" },;	//"Atendimento Cancelado" --> Padr�o
                        {"BR_AMARELO"   ,"Em Andamento"  },;            //"Em Andamento" --> Customizado Komfort
                        {"BR_LARANJA"   ,"Visita Tecnica"},;	        //"Visita Tec" --> Customizado Komfort
                        {"BR_PINK"      ,"Devolucao"},;	                //"Devolucao" --> Customizado Komfort
                        {"BR_BRANCO"    ,"Retorno"},;	                //"Retorno" --> Customizado Komfort
                        {"BR_VIOLETA"   ,"Troca Autorizada"},;          //"Troca Aut" --> Customizado Komfort
                        {"BR_CINZA"		,"Compartilhamento" },;		    //"Compartilhamento" --> Padr�o
                        {"BR_AZUL_CLARO","Email Fabricante"},;		    //"Compartilhamento" --> Padr�o
                        {"BR_VERDE_ESCURO","Foto/V�deo"},;              // Foto/V�deo --> Customizado Komfort
                        {"BR_MARRON","Canc/Bloqueado"},;                 // Canc/Bloqueado --> Customizado Komfort
                        {"BR_MARRON_OCEAN","Canc/Liberado"}}            // Canc/Liberado --> Customizado Komfort

        Case cOpcao == "2" //Televendas
            aCores := { {"BR_MARRON"  	,"Atendimento" },;  //"Atendimento" --> Padr�o
                        {"BR_AZUL"		,"Or�amento" },;	//"Or�amento" --> Padr�o
                        {"BR_VERDE"    	,"Faturamento" },;	//"Faturamento" --> Padr�o
                        {"BR_VERMELHO" 	,"NF.Emitida" },;   //"NF.Emitida" --> Padr�o
                        {"BR_PRETO"    	,"Cancelado" }} 	//"Cancelado" --> Padr�o

        Case cOpcao == "3" //Telecobranca
            aCores := {{"BR_AZUL"   	,"Atendimento"},;	//"Atendimento" --> Padr�o
                       {"BR_VERDE"  	,"Cobran�a"},;		//"Cobran�a" --> Padr�o
                       {"BR_VERMELHO"   ,"Encerrado"},;		//"Encerrado" --> Padr�o
                       {"BR_CINZA"  	,"Cancelado" }}		//"Cancelado" --> Padr�o
    EndCase
        
    restArea(aArea)

Return aCores