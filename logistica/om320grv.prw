#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#Include "Ap5Mail.Ch"
#Include "xmlxfun.ch"
#INCLUDE "JPEG.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ OM320GRV º Autor ³ LUIZ EDUARDO F.C.  º Data ³  29/06/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ PONTO DE ENTRADA NA CONFIRMACAO DO RETORNO DA CARGA        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ KOMFORT HOUSE                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER FUNCTION OM320GRV()

local cAlias   := GetNextAlias()
Local cQuery   := ""
Local lGrava   := .F.
Local aButtons := {}
Local aTermos  := {}
Local oOk 	   := LoadBitmap( GetResources(), "CHECKED" )
Local oNo 	   := LoadBitmap( GetResources(), "UNCHECKED" )
Local cCarga := SF2->F2_CARGA
Local oDlg, oLogo, oFnt, oBrwLocal, oFnt2



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FILTRA OS TERMOS DE RETIRA  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SF2->(RecLock("SF2",.F.))
SF2->F2_DTENTR  := dDataBase
SF2->(MsUnlock())


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FILTRA OS TERMOS DE RETIRA  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := " SELECT '' AS NOTA, '' AS DT_EMISNF, ZK0_PEDORI, '' AS DT_EMISPED, ZK0_CLI, ZK0_LJCLI, A1_NOME, "
cQuery += " A1_END, A1_BAIRRO, A1_EST, A1_CEP, A1_MUN, A1_COMPLEM, A1_DDD, A1_TEL, A1_TEL2, A1_XTEL3, "
cQuery += " ZK0_COD, ZK0_PROD, ZK0_DESCRI, ZK0_NUMSAC, ZK0_DATA, ZK0_MSFIL FROM " + RETSQLNAME("ZK0") + " ZK0 "
cQuery += " INNER JOIN " + RETSQLNAME("SA1") + " SA1 ON A1_COD = ZK0_CLI "
cQuery += " AND A1_LOJA = ZK0_LJCLI "
cQuery += " WHERE ZK0_FILIAL = '" + XFILIAL("ZK0") + "' "
cQuery += " AND A1_FILIAL = '" + XFILIAL("SA1") + "' "
cQuery += " AND ZK0.D_E_L_E_T_ = ' ' "
cQuery += " AND SA1.D_E_L_E_T_ = ' ' "
cQuery += " AND ZK0_STATUS = '2' "
cQuery += " AND ZK0_CARGA = '" + cCarga + "' "

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

TRB->(DbGoTop())
While TRB->(!EOF())
	aAdd( aTermos , {	.T. ,ALLTRIM(POSICIONE("SC5",1,XFILIAL("SC5") + SUBSTR(TRB->ZK0_PEDORI,5,7),"C5_NOTA")) + " - " + ALLTRIM(POSICIONE("SC5",1,XFILIAL("SC5") + SUBSTR(TRB->ZK0_PEDORI,5,7),"C5_SERIE")),;
	TRB->DT_EMISNF, TRB->ZK0_PEDORI, ALLTRIM(POSICIONE("SC5",1,XFILIAL("SC5") + TRB->ZK0_PEDORI,"C5_EMISSAO")), TRB->ZK0_CLI, TRB->ZK0_LJCLI, TRB->A1_NOME, TRB->A1_END,;
	TRB->A1_BAIRRO, TRB->A1_EST, TRB->A1_CEP, TRB->A1_MUN, TRB->A1_COMPLEM, TRB->A1_DDD, TRB->A1_TEL, TRB->A1_TEL2, TRB->A1_XTEL3, TRB->ZK0_COD, TRB->ZK0_PROD, TRB->ZK0_DESCRI,;
	TRB->ZK0_NUMSAC, TRB->ZK0_DATA, TRB->ZK0_MSFIL} )
	TRB->(DbSkip())
EndDo    

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

IF Len(aTermos) > 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ MONTA A TELA COM AS INFORMACOES DETALHADAS DO PRODUTO SELECIONADO ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DEFINE FONT oFnt  NAME "ARIAL" SIZE 0,-12 BOLD
	DEFINE FONT oFnt2 NAME "ARIAL" SIZE 0,-18 BOLD
	DEFINE MSDIALOG oDlg FROM 0,0 TO 500,900 TITLE "Amarração CARGA X TERMO RETIRA - OM200OK" Of oMainWnd PIXEL STYLE DS_MODALFRAME STATUS
	
	// TRAZ O LOGO DA KOMFORT
	@ 035,010 JPEG oLogo FILE "modelos\logo.jpg" SIZE  010,010 OF oDlg PIXEL NOBORDER
	oLogo:LAUTOSIZE    := .F.
	oLogo:LSTRETCH     := .T.
	
	@ 050,100 SAY "Selecione os Termos de Retira que Foram Finalizados" SIZE 400,10 FONT oFnt2 PIXEL OF oDlg
	
	oBrw:= TWBrowse():New(075,005,440,165,,{"","Nota Fiscal","Ped.Original","Cód.Cliente","Cliente","Endereço","CEP","Complemento","Tel.Contato","Termo Retira","Cód.Produto","Produto","Número Chamado"},,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oBrw:SetArray(aTermos)
	oBrw:bLine := {|| { If(aTermos[oBrw:nAt,1],oOk,oNo)	,;
	aTermos[oBrw:nAt,2] ,;
	aTermos[oBrw:nAt,4] ,;
	aTermos[oBrw:nAt,6] + "-" + aTermos[oBrw:nAt,7] ,;
	aTermos[oBrw:nAt,8] ,;
	aTermos[oBrw:nAt,9] + " , " + aTermos[oBrw:nAt,10] + " , " + aTermos[oBrw:nAt,13] + " - " + aTermos[oBrw:nAt,11]	,;
	aTermos[oBrw:nAt,12] ,;
	aTermos[oBrw:nAt,14] ,;
	" ( " + aTermos[oBrw:nAt,15] + " ) " + aTermos[oBrw:nAt,16] + " / " + aTermos[oBrw:nAt,17] + " / " + aTermos[oBrw:nAt,18] ,;
	aTermos[oBrw:nAt,19] ,;
	aTermos[oBrw:nAt,20] ,;
	aTermos[oBrw:nAt,21] ,;
	aTermos[oBrw:nAt,22] }}
	
	oBrw:bLDblClick := {|| ( aTermos[oBrw:nAt,1] := !aTermos[oBrw:nAt,1] , oBrw:Refresh() ) }
	
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg, { || lGrava := .T. , oDlg:End() } , { || lGrava := .F. , oDlg:End() },, aButtons)
	
	IF lGrava
		IF MsgYesNo("Deseja confirmar as informações abaixo?","YESNO")
			For nX:=1 To Len(aTermos)
				IF aTermos[nX,1]
					DbSelectArea("ZK0")
					ZK0->(DbSetOrder(1))
					ZK0->(DbGoTop())
					IF ZK0->(DbSeek(xFilial("ZK0") + aTermos[nX,19]))
						ZK0->(RecLock("ZK0",.F.))
						ZK0->ZK0_STATUS := "3"
						ZK0->ZK0_DTRET  := dDataBase
						ZK0->(MsUnlock())
					EndIF
				Else
					DbSelectArea("ZK0")
					ZK0->(DbSetOrder(1))
					ZK0->(DbGoTop())
					IF ZK0->(DbSeek(xFilial("ZK0") + aTermos[nX,19]))
						ZK0->(RecLock("ZK0",.F.))
						ZK0->ZK0_STATUS := "4"
						ZK0->ZK0_DTRET  := dDataBase
						ZK0->(MsUnlock())
					EndIF
				EndIF
			Next
		EndIF
	EndIF
	
EndIF

cQuery := ""

cQuery := "SELECT SD2.D2_PEDIDO, SD2.D2_ITEMPV, SD2.D2_COD "
cQuery += "FROM "+RetSqlName("SF2")+" SF2, " +RetSqlName("SD2")+" SD2 "
cQuery += "WHERE "
cQuery += "SF2.F2_FILIAL = '"+xFilial("SF2")+"' AND "
cQuery += "SF2.F2_CARGA  = '"+DAK->DAK_COD+"' AND "
cQuery += "SF2.F2_SEQCAR = '"+DAK->DAK_SEQCAR+"' AND "
cQuery += "SF2.D_E_L_E_T_= ' ' AND "
cQuery += "SD2.D2_FILIAL ='"+xFilial("SF2")+"' AND "
cQuery += "SD2.D2_DOC = SF2.F2_DOC AND "
cQuery += "SD2.D2_SERIE = SF2.F2_SERIE AND "
cQuery += "SD2.D2_CLIENTE = SF2.F2_CLIENTE AND "
cQuery += "SD2.D2_LOJA = SF2.F2_LOJA AND "
cQuery += "SD2.D_E_L_E_T_=' ' "

cQuery    := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

dbselectarea(cAlias)
While !Eof()
	//Altera status para entregue
	//ATUALIÇÃO DE STATUS DO PEDIDO - TIPO 6 - oSt9 - "BR_PRETO" "Entregue ao Cliente"
	U_SYTMOV15((cAlias)->D2_PEDIDO, (cAlias)->D2_ITEMPV,(cAlias)->D2_COD ,"6")
	
	dbselectarea(cAlias)
	(cAlias)->(dbskip())
enddo

dbCloseArea()

RETURN(.T.)
