#include 'protheus.ch'
#include 'parmtype.ch'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ KMSACA11º Autor ³ Marcio Nunes     º Data ³  12/03/2019    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºCadastro de comissão vendedores - Alerado para MBROWSE                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 															  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

user function KMSACA12()
		
Local aCores := {{'ZK4->ZK4_STATUS == "1"','BR_VERMELHO'},{'ZK4->ZK4_STATUS == "2"','BR_VERDE'},{'ZK4->ZK4_STATUS == "3"','BR_PRETO'},{'ZK4->ZK4_STATUS == "4"','BR_AZUL'},{'ZK4->ZK4_STATUS == "5"','BR_AMARELO'},{'ZK4->ZK4_STATUS == "6"','BR_VIOLETA'},{'ZK4->ZK4_STATUS == "7"','BR_LARANJA'},{'ZK4->ZK4_STATUS == "8"','BR_BRANCO'}}

Private cCadastro     := "Agendamento Tecnico"
Private cString          := "ZK4"                                                                                                       
Private aRotina          := {{'Procurar','AxPesqui',0,1},;
{'Visualisar','AxVisual',0,2},;
{'Incluir','AxInclui',0,3},;
{'Alterar','AxAltera',0,4},;
{'Excluir','U_KMEXCLU()',0,5},;
{'Legenda', 'U_LEGCA12()',0,6}}
dbSelectArea("ZK4")
dbSetOrder(1)
ZK4->(dbGoTop())
MBrowse(6,1,22,75,cString,,,,,,aCores)

Return(.T.)  

User Function LEGCA12()

   aLegenda := { {'BR_VERMELHO',	"Pendente" },;
                 {'BR_VERDE',    	"Resolvido"},;
                 {'BR_PRETO',    	"Ñ Resolvido"},; 
                 {'BR_AZUL',		"Conserto"},;
                 {'BR_AMARELO',		"Visita"},;
                 {'BR_VIOLETA',		"Reincidência"},;
                 {'BR_LARANJA',		"Ausente"},;
                 {'BR_BRANCO',		"Indefirido"}}
                 
   BRWLEGENDA( cCadastro, "Legenda", aLegenda )

Return(.T.)


/*/
+------------------------------------------------------------------------------
 Descrição     | Função de validação de Exclusão para a AXCADASTRO()  
 Autor: Wellington Raul Pinto
 Data: 04/04/2019
+------------------------------------------------------------------------------
/*/

User Function KMEXCLU()

	Local lRet      := .F.
	local cUserEst := SUPERGETMV("KH_AGETEC", .T., "000779|000478|000695|000455")
	Local aAreaZK4 := ZK4->(GetArea())
	Local cCodigo := ZK4->ZK4_COD
	
	if __cUserid $ cUserEst
		lRet := .T.
		DbSelectArea('ZK4')
	    ZK4->(DbSetOrder(1)) //ZK4_FILIAL + ZK4_COD
	    ZK4->(DbGoTop())
	    //Se conseguir posicionar no agendamento Técnico
	    If ZK4->(DbSeek(xFilial('ZK4') +cCodigo ))
	        AxDeleta('ZK4', ZK4->(RecNo()), 5)
	    EndIf
	     
	    RestArea(aAreaZK4)
	else
		MsgInfo("Você não possuí permissão para executar está função!!")
	endif

Return lRet