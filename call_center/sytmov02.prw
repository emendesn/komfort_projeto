#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#Include "Ap5Mail.Ch"
#Include "xmlxfun.ch"
#INCLUDE "JPEG.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SYTMOV02 บ Autor ณ LUIZ EDUARDO F.C.  บ Data ณ  19/09/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ PESQUISA ESTOQUE DE UM PRODUTO NAS OUTRAS FILIAIS          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ KOMFORT HOUSE                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
USER FUNCTION SYTMOV02()

Local cQry      := ""
Local aButtons	:= {}
Local cARZMST   := GetMv("MV_ARZMST",,"") // ARMAZENS DE MOSTRUARIO
Local oOk	 	:= LoadBitMap(GetResources(), "LBOK")
Local oNo	 	:= LoadBitMap(GetResources(), "LBNO")
Local oTelEst, oPnlSup, oPnlInf, oFnt

Private aProdutos := {}
Private oBrw

IF MsgYesNo("Deseja Consultar Estoque do Produto -  [" + ALLTRIM(oGetD2:AARRAY[oGetD2:NAT,7]) + "  /  " + ALLTRIM(oGetD2:AARRAY[oGetD2:NAT,3]) + "] em outras Lojas???","Confirma?")
	cQry := " SELECT B2_FILIAL, B2_COD, B2_LOCAL, B2_LOCALIZ, (B2_QATU - (B2_RESERVA + B2_QPEDVEN)) AS SALDO FROM " + RETSQLNAME("SB2")
	//cQry += " WHERE B2_FILIAL <> ' ' " // SO TRAZER OS SALDOS DOS PRODUTOS DA MESMA EMPRESA (REGRA DE ACORDO COM A LUCIANA) - 24.08.2017
	cQry += " WHERE LEFT(B2_FILIAL,2) = '" + LEFT(CFILANT,2) + "' "
	cQry += " AND D_E_L_E_T_ = ' ' "
	cQry += " AND B2_COD = '" + oGetD2:AARRAY[oGetD2:NAT,7] + "' "
	cQry += " AND (B2_QATU - (B2_RESERVA + B2_QPEDVEN)) > 0 "
	
	If Select("TCM") > 0
		TCM->(DbCloseArea())
	EndIf
	
	cQry := ChangeQuery(cQry)
	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQry),"TCM",.F.,.T.)
	
	TCM->(DbGoTop())
	While TCM->(!EOF())
		IF TCM->B2_LOCAL $ cARZMST
			aAdd( aProdutos , {.F. , TCM->B2_FILIAL , TCM->B2_COD , ALLTRIM(oGetD2:AARRAY[oGetD2:NAT,3])  , TCM->B2_LOCAL + " - " + TCM->B2_LOCALIZ , TCM->SALDO , 0 , TCM->B2_LOCAL, TCM->B2_FILIAL , .T.} )
		EndIF
		TCM->(DbSkip())
	EndDo
	
	IF Len(aProdutos) > 0
		DEFINE FONT oFnt NAME "ARIAL" SIZE 0,-20 BOLD
		DEFINE MSDIALOG oTelEst TITLE "Consulta Estoque em Outras Filiais" FROM 0,0 TO 620,950 OF oMainWnd PIXEL
		
		oPnlSup:=TPanel():New(0, 0, '', oTelEst, NIL, .T., .F., NIL, NIL, 0,30, .T., .F. )
		oPnlSup:NCLRPANE := 14803406
		oPnlSup:Align:=CONTROL_ALIGN_TOP
		
		@ 008,010 Say "Produto : " + ALLTRIM(oGetD2:AARRAY[oGetD2:NAT,7]) + "     -     " + ALLTRIM(oGetD2:AARRAY[oGetD2:NAT,3]) + "     Cor: " + ALLTRIM(oGetD2:AARRAY[oGetD2:NAT,2]) Size 500,030 FONT oFnt Pixel Of oPnlSup
		
		oPnlInf:=TPanel():New(000,000, '', oTelEst, NIL, .T., .F., NIL, NIL, 000,000, .T., .F. )
		oPnlInf:Align:=CONTROL_ALIGN_ALLCLIENT
		
		oBrw:= TwBrowse():New(000,000,000,000,,{"","Loja","C๓digo","Descri็ใo","Armazem","Saldo","Qtde.Venda"},,oPnlInf,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		oBrw:SetArray(aProdutos)
		oBrw:bLine		:= { || {	IIF(aProdutos[oBrw:nAt,1],oOk,oNo),;
		aProdutos[oBrw:nAt,2],;
		aProdutos[oBrw:nAt,3],;
		aProdutos[oBrw:nAt,4],;
		aProdutos[oBrw:nAt,5],;
		Transform(aProdutos[oBrw:nAt,6],PesqPict('SB2','B2_QATU')),;
		Transform(aProdutos[oBrw:nAt,7],PesqPict('SB2','B2_QATU'))}}
		oBrw:Align:=CONTROL_ALIGN_ALLCLIENT
		oBrw:bLDblClick := {|| ( aProdutos[oBrw:nAt,1] := !aProdutos[oBrw:nAt,1] , IF(aProdutos[oBrw:nAt,1] , SELECQTD() , ) , oBrw:Refresh() ) }
		
		ACTIVATE MSDIALOG oTelEst ON INIT EnchoiceBar( oTelEst, { || VLDSAIDA() , oTelEst:End() } , { || oTelEst:End() },, aButtons)
	Else
		MsgAlert("A Busca Nใo Retornou Nenhuma Informa็ใo!!!")
	EndIF
EndIF

RETURN()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SELECQTD บ Autor ณ LUIZ EDUARDO F.C.  บ Data ณ  19/09/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ SELECIONA A QUANTIDADE E VALIDA AS INFORMACOES             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
STATIC FUNCTION SELECQTD()

Local oDlgqtde
Local nQtde := 1

DEFINE MSDIALOG oDlgqtde TITLE "Digite a Quantidade" FROM 0,0 TO 100,235 OF oMainWnd PIXEL

oDlgqtde:NCLRPANE := 14803406

@ 008,010 Say "Digite a Quantidade" Size 500,030 Pixel Of oDlgqtde
@ 006,060 MSGET nQtde 	PICTURE PesqPict("SB2",'B2_QATU') OF oDlgqtde PIXEL SIZE 050,010 VALID (IF(nQtde > aProdutos[oBrw:nAt,6] ,(MsgInfo("Quantidade Acima da Permitida!!!"),aProdutos[oBrw:nAt,7] := aProdutos[oBrw:nAt,6],nQtde := 1,oDlgqtde:REFRESH()),))

@ 027, 005 BUTTON "&Ok"			SIZE 50,15 OF oDlgqtde PIXEL ACTION {|| aProdutos[oBrw:nAt,7] := nQtde , oBrw:Refresh() , oDlgqtde:End()  }
@ 027, 060 BUTTON "&CANCELAR" 	SIZE 50,15 OF oDlgqtde PIXEL ACTION {|| oDlgqtde:End()  }

ACTIVATE MSDIALOG oDlgqtde CENTERED

RETURN()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SELECQTD บ Autor ณ LUIZ EDUARDO F.C.  บ Data ณ  19/09/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ SELECIONA A QUANTIDADE E VALIDA AS INFORMACOES             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
STATIC FUNCTION VLDSAIDA()

IF MsgYesNo("Deseja realmente selecionar estes produtos com saldos de outras lojas?","Confirma?")	
	For nX:=1 To Len(aProdutos)		
		IF aProdutos[nX,1]
			aAdd( aRegs2 , {.T. , oGetD2:AARRAY[oGetD2:NAT,2] , oGetD2:AARRAY[oGetD2:NAT,3] , oGetD2:AARRAY[oGetD2:NAT,4] , aProdutos[nX,7] , 0 , oGetD2:AARRAY[oGetD2:NAT,7] , aProdutos[nX,8] , aProdutos[nX,9] , aProdutos[nX,10] , aProdutos[nX,5]} )
		EndIF		
	Next	
EndIF                   

aSort(aRegs2,,,{|x,y| x[1] > y[1]})

oGetD2:AARRAY := aRegs2 
oGetD2:Refresh()

RETURN()