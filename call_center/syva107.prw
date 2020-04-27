#include "Protheus.ch"

#DEFINE DESCONTO 2

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SYVA107  บAutor  ณ SYMM CONSULTORIA   บ Data ณ  23/04/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFaz a validacao do desconto no total da venda               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTMKA271                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function SYVA107()

Local lRet 			:= .T.																			// Indica o retorno da funcao
Local lConfirma		:= .F.																			// Indica se o usuario confirmou ou nao o descto
Local nPerDesc	 	:= 0																			// Percentual de Desconto
Local nVlrDesc		:= 0																			// Valor do desconto
Local nX			:= 0																			// Usada em lacos For...Next
Local nVlrAux 		:= 0																			// Usada para totalizar o valor das parcelas
Local nVlrMerc		:= 0																			// Valor total das mercadorias
Local nIpiLiq		:= 0																			// Valor do IPI Liquido
Local nPosProd		:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_PRODUTO"})							// Posicao da codigo do produto
Local nPosQtda  	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_QUANT"})							// Posicao da quantidade
Local nPosVrUnit	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_VRUNIT"})							// Posicao do Valor unitario
Local nPosValDesc	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_VALDESC"})							// Posicao do valor de desconto
Local nPosVlItem	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_VLRITEM"})							// Posicao do Valor Total do Item

Local oDlgDesconto																					// Objeto de montagem de desconto no total
Local oPerDesc																						// Objeto para receber o desconto percentual no total
Local oVlrDesc																						// Objeto para receber o desconto em valor no total
Local oDesconto																						// Instancia o objeto que fara o desconto

Local nValTot		:= 0																			// Variavel utilizada para guardar o valor total da venda antes do desconto
Local nValSol		:= 0																			// Recebe o Valor total da substitui็ใo tributแria
Local nVlrDescBkp	:= 0																			// Valor Backup do desconto
Local nVlrComp		:= 0																			// compara valor para atualizar aPgtos
Local lExibeTela	:= .T.																			// Indica se a tela de desconto sera exibida
Local lMvAjstDes 	:= SuperGetMV( "MV_LJAJDES",,.F. )												// Verifica parametro ajuste de desconto no total da venda
Local nX

nDecimais 			:= MsDecimais(1)

If nFolder <> 2
   MsgAlert("Esta rotina deve ser acessada somente no Televendas.","Aten็ใo")
   Return .F.
Endif

If Empty(aCols[n][nPosProd]) .OR. aCols[n][nPosVrUnit] == 0
	Return .F.
EndIf


For nX := 1 To Len(aCols)
	If aCols[nX][nPosValDesc] > 0
		MsgStop("Desconto nใo permitido, jแ existem desconto no(s) iten(s) deste pedido.","Aten็ใo")				
		Return .F.
	Endif
Next

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณinicializa o objeto de desconto. 					 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oDesconto := Desconto():New()

DEFINE MSDIALOG oDlgDesconto FROM 0,0 TO 113,285 TITLE "Desconto no Total da Venda" PIXEL
@ 6, 04 BITMAP RESOURCE "DISCOUNT" OF oDlgDesconto PIXEL SIZE 32,32 ADJUST When .F. NOBORDER
@ 04, 40 TO 38, 140 PIXEL OF oDlgDesconto

@ 11, 45 SAY "% Desconto" PIXEL OF oDlgDesconto
@ 21, 45 MSGET oPerDesc VAR nPerDesc 	SIZE 35,10 ;
OF oDlgDesconto PICTURE "@E 99.99" RIGHT PIXEL ;
VALID IIf( nPerDesc < 0, ( MsgStop("Valor nใo permitido para esse campo."), .F. ), .T. )

oPerDesc:bLostFocus := { || lOk := U_SYVM106(nPerDesc,"UB_VLRITEM") , If( lOk , ( nVlrDesc := Round((aValores[1] * nPerDesc) / 100 , nDecimais ) , oVlrDesc:Refresh(), lConfirma := .T.) , ( .F. , nPerDesc := 0 , oPerDesc:SetFocus() , oPerDesc:Refresh()  ) ) }

@ 11, 87 SAY "Vlr.Desconto"	PIXEL OF oDlgDesconto
@ 21, 87 MSGET oVlrDesc VAR nVlrDesc SIZE 50,10 OF oDlgDesconto PICTURE "@E 999,999,999.99" RIGHT PIXEL WHEN .F. VALID IIf( nVlrDesc < 0, ( MsgStop("Valor nใo permitido para esse campo."), .F. ), .T. ) .AND. ;
IIf( nVlrDesc >= aValores[1], ( MsgStop("O valor do desconto ้ maior ou igual ao valor da venda, favor verificar!"	), .F. ), .T. )

oVlrDesc:bLostFocus := { || nPerDesc := Round((nVlrDesc * 100) / aValores[1] , nDecimais ) , oPerDesc:Refresh(), lConfirma := .T. }

DEFINE SBUTTON FROM 40, 083 TYPE 1 ENABLE OF oDlgDesconto ACTION (lConfirma := .T., oDlgDesconto:End()) PIXEL

DEFINE SBUTTON FROM 40, 113 TYPE 2 ENABLE OF oDlgDesconto ACTION ((lConfirma := .F., 	nPerDesc := 0, nVlrDesc:= 0), oDlgDesconto:End()) PIXEL

ACTIVATE MSDIALOG oDlgDesconto CENTERED

If lConfirma

	aValores[DESCONTO] := 0

	aValores[DESCONTO] := nVlrDesc
	
	Tk273RodImposto("NF_DESCONTO",aValores[DESCONTO])
	
	// Atualiza o rodape
	Tk273Refresh()
	Eval(bFolderRefresh)
	Eval(bRefresh)

EndIf

Return lRet