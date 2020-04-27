#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TMKBARLA  ºAutor  ³Eduardo Patriani    º Data ³  20/01/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Faz a chamada da tela de consulta de produtos               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TMKBARLA(aBtnLat,aTitles)

Local aArea := GetArea()

Public __cxOper := SUA->UA_OPER

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Desabilita o campo Desconto no Rodape do Atendimento³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lDesconto 	:= .F.

//If TkGetTipoAte() $ "2|5"
//	aTitles[1] 	:= "SAC"
Aadd(aBtnLat,{"DEPENDENTES"	,&("{||	U_SYVA103() }" 	)  ,"Consulta Produto(s)"} )
//Aadd(aBtnLat,{"BUDGETY"		,&("{||	U_SYVA107() }" 	)  ,"Descontos"} ) //dESABILITADO POR #CMG20180607 - Desconto era aplicado no total e não tinha validação
Aadd(aBtnLat,{"BMPVISUAL"	,&("{||	U_SYVM108() }" 	)  ,"Consula Estoque(s)"} )
Aadd(aBtnLat,{"SIMULACA"	,&("{||	U_LANCRA()  }" 	)  ,"Gera RA's"} )
Aadd(aBtnLat,{"CONTAINR"	,&("{||	U_SYTM001() }" 	)  ,"Consulta RA's do Cliente"} )
Aadd(aBtnLat,{"S4WB005N"	,&("{||	U_SYTMOV04()}" 	)  ,"Busca Itens do Pedido"} )
Aadd(aBtnLat,{"ATALHO"		,&("{||	U_SYTMWF02(1)}"	)  ,"Reenvia WF"} )
//Endif

/*
If TkGetTipoAte() $ "1"
aTitles[1] 	:= "SAC"
Aadd(aBtnLat,{"S4WB005N"	,&("{||	U_SYTMOV04()}	" )  ,"Busca Itens do Pedido"} )
Aadd(aBtnLat,{"ATALHO"		,&("{||	U_SYTMWF02(1)}	" )  ,"Reenvia WF"} )
Endif
*/      

AAdd(aButBar,{"S4WB016N",{||U_KHPRDISP()},"Produtos Disponiveis","Produtos Disponiveis",,})	//"Help"  
AAdd(aButBar,{"S4WB016N",{||U_KMSACA01()},"Observação Atendimento SAC <F11>","Observação Atendimento SAC <F11>",,})	//"Help"     
AAdd(aButBar,{"S4WB016N",{||U_ANEXOSAC()},"ANEXOS CHAMADOS <F12>","ANEXOS CHAMADOS <F12>",,})	//"Help"
AAdd(aButBar,{"S4WB016N",{||U_KHPOSV01()},"PESQUISA DE SATISFAÇÃO DO CLIENTE <F6>",,})	//"Help"

If !Empty(AllTrim(SUA->UA_NUMSC5))                           

	AAdd(aButBar,{"S4WB016N",{||U_KMFINA01(SUA->UA_NUMSC5)},"Reimprimi Boleto","Reimprimi Boleto",,})

EndIf

SetKey( K_CTRL_I , { || U_KHPOSV01() } )
SetKey( VK_F11 , { || U_KMSACA01() } )
SetKey( VK_F12 , { || MsDocument('SUC', SUC->(RecNo()),4) } )

//Incluido atalho F4 para pesquisa e consulta de saldo dos produtos
SetKey( VK_F4 , { || U_KHF3B1() } )

RestArea(aArea)

Return(aBtnLat)                         


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³TkConhecimento   ³Autor  ³ Vendas Clientes ³ Data ³ 20/05/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Chamada do botão do banco de conhecimento.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CALL CENTER						                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER Function ANEXOSAC()

Local aRotBack := aClone(aRotina)							// Backup do vetor aRotina
Local aSArea   := GetArea()									// Backup da area atual
Local cAtend   := ""										// Atendimento
Local cEntidade:= ""										// Entidade
Local cChave   := ""										// Chave de busca
Local cCodCont := ""										// Codigo do contato
Local cOperador:= ""										// Codigo do operador
Local cCliente := ""										// Codigo do cliente
Local cLoja    := ""										// Loja do cliente
Local aSavAhead:= Iif(Type("aHeader")=="A",aHeader,{})		// Backup do aheader
Local aSavAcol := Iif(Type("aCols")=="A",aCols,{})			// Backup do acols
Local nSavN    := Iif(Type("aCols")=="A",n,0)				// Backup do numero da linha atual
Local lRet     := .T.										// Retorno da funcao
Local nIndEnt  := 1											// 	Indice da Entidade

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Altera n para getdados do banco de conhecimento.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
n:=1                       

MsDocument('SUC', SUC->(RecNo()),4)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a Integridade dos Dados                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet
	aHeader := aSavAHead
	aCols   := aSavaCol
	n       := nSavN
Endif

aRotina := {}
aRotina := aClone(aRotBack)
RestArea(aSArea)

Return .T.