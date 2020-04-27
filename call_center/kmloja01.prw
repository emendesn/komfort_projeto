#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#Include "Ap5Mail.Ch"
#Include "xmlxfun.ch"
#INCLUDE "JPEG.CH"

#DEFINE ENTER (Chr(13)+Chr(10)) //#AFD20180525.n
#DEFINE cAlert4 "ATENวรO !!!"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ KMLOJA01 บ Autor ณ LUIZ EDUARDO F.C.  บ Data ณ 14/02/2018  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ TELA DE FECHAMENTO DE CAIXA                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ KOMFORT HOUSE                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
USER FUNCTION KMLOJA01()

Local aSize		:= MsAdvSize()
Local aPosObj   := {}
Local aObjects  := {}
Local aInfo     := {}
Local cPerg	 	:= Padr("KMLOJA01",10)
Local nOpc		:= 0
Local oFont1 	:= TFont():New("Tahoma",,018,,.T.,,,,,.F.,.F.)
Local oLogo
Local nI		:=0
Private aRegs1 	 := {}
Private aHead2 	 := {}
Private aCols2	 := {}
Private oGetD1
Private oGetD2
Private aHead3 	 := {}
Private aCols3	 := {}
Private oGetD3
Private aButtons := {}
Private oOk	 	 := LoadBitMap(GetResources(), "LBOK")
Private oNo	 	 := LoadBitMap(GetResources(), "LBNO")
Private oTela, oPanel1, oPanel2
Private nVlrTot  := 0
Private nVlrRA   := 0
Private nVlrCR   := 0
Private nVlrCX   := 0
Private nVlrConf := 0
Private nRecSL4
Private nRecSC5
Private nRecSE1
Private cMensagem:= ""
Private lVldAne:=SuperGetMV("KH_VLDANEX")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Faz o calculo automatico de dimensoes de objetos     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aObjects := {}
AAdd( aObjects, { 100, 100, .T., .F. } )
AAdd( aObjects, { 070, 100, .F., .T. } )
AAdd( aObjects, { 100, 015, .T., .F. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )
aPosObj[1][3] := 230

AjustaSx1(cPerg)
While .T.
	IF !Pergunte(cPerg,.T.)
		Return
	Else
		If MV_PAR01 <> cFilAnt
			Aviso("","Nใo ้ permitido selecionar uma Filial diferente da Filial Logada.",{"OK"})
		Else
			Exit
		EndIF
	EndIF
EndDO

FwMsgRun( ,{|| FILDADOS()   }, , "Filtrando Dados, por favor aguarde..." )

If Len(aRegs1) > 0
	
	CarregaVdas()
	
	DEFINE FONT oFnt NAME "ARIAL" SIZE 0,-12 BOLD
	DEFINE MSDIALOG oTela FROM 0,0 TO aSize[6],aSize[5] TITLE "Tela de Fechamento de Caixa" Of oMainWnd PIXEL
	
	// TRAZ O LOGO DA KOMFORT HOSUE
	@ 005,005 JPEG oLogo FILE "modelos\logo.jpg" SIZE  010,010 OF oTela PIXEL NOBORDER
	oLogo:LAUTOSIZE    := .F.
	oLogo:LSTRETCH     := .T.
	
	oFWLayerItens:= FwLayer():New()
	oFWLayerItens:Init(oTela,.T.)
	
	//If Len(aCols2) > 0
	
	oFWLayerItens:addLine("PEDIDOS", 35, .F.)
	oFWLayerItens:addCollumn( "COL1",100,.F.,"PEDIDOS")
	oFWLayerItens:addWindow ( "COL1","WIN1","Pedidos",100,.T.,.F.,,"PEDIDOS")
	
	oPanel1:= oFWLayerItens:GetWinPanel("COL1","WIN1","PEDIDOS")
	
	oGetD1				:= TwBrowse():New(0,0,0,0,,{"Conferido?","Filial","Pedido","Or็amento","Cliente","Nome Cliente","Parcelas","Dt.Emissใo","Vendedor","Nome Vendedor","Valor"},,oPanel1,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oGetD1:Align        := CONTROL_ALIGN_ALLCLIENT
	oGetD1:lColDrag		:= .T.
	oGetD1:SetArray(aRegs1)
	oGetD1:bLine		:= { || {	IIF(aRegs1[oGetD1:nAt,1],oOk,oNo),;
	ALLTRIM(aRegs1[oGetD1:nAt,2]),;
	ALLTRIM(aRegs1[oGetD1:nAt,3]),;
	ALLTRIM(aRegs1[oGetD1:nAt,4]),;
	ALLTRIM(aRegs1[oGetD1:nAt,5]),;
	ALLTRIM(aRegs1[oGetD1:nAt,6]),;
	ALLTRIM(Transform(aRegs1[oGetD1:nAt,7],"@E 999")),;
	ALLTRIM(DTOC(STOD(aRegs1[oGetD1:nAt,8]))),;
	ALLTRIM(aRegs1[oGetD1:nAt,9]),;
	ALLTRIM(aRegs1[oGetD1:nAt,10]),;
	ALLTRIM(Transform(aRegs1[oGetD1:nAt,11],PesqPict('SE1','E1_VALOR')))}}
	
	//oGetD1:bLDblClick 	:= { || ( VLRCONFE() , aRegs1[oGetD1:nAt,1] := !aRegs1[oGetD1:nAt,1] , oGetD1:Refresh() )}//#AFD20180525.o
	//oGetD1:bHeaderClick	:= { || AEval(aRegs1,{|x| x[1]:= !x[1]}), oGetD1:Refresh()}//#AFD20180525.o
	oGetD1:bLDblClick 	:= { || ( VLRCONFE() , aRegs1[oGetD1:nAt,1] := !aRegs1[oGetD1:nAt,1] , oGetD1:Refresh(), iif(aRegs1[oGetD1:nAt,1]==.T.,vldNSU(),) )}//#AFD20180525.n
	oGetD1:bHeaderClick	:= { || AEval(aRegs1,{|x| x[1]:= !x[1]}), oGetD1:Refresh(),vldNSU2()}//#AFD20180525.n
	oGetD1:bChange		:= { || CarregaSL4(aRegs1[oGetD1:nAt]) }
	
	oFWLayerItens:addLine("CONSULTA", 35, .F.)
	oFwLayerItens:addCollumn( "COL1", 50, .F. , "CONSULTA")
	oFwLayerItens:addCollumn( "COL2", 50, .F. , "CONSULTA")
	
	oFwLayerItens:addWindow(  "COL1", "WIN1", "Formas de Pagamentos"	, 100, .T., .F., , "CONSULTA")
	oFwLayerItens:addWindow(  "COL2", "WIN2", "Fechamento do Dia"		, 100, .T., .T., , "CONSULTA")
	
	oPanel2:= oFWLayerItens:GetWinPanel("COL1","WIN1","CONSULTA")
	
	oGetD2:= TwBrowse():New(0,0,0,0,, {"Or็amento","Dt.Or็amento","Forma de Pagamento","Valor Parcela","NSU"},,oPanel2,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
	oGetD2:SetArray(aCols2)
	oGetD2:bLine := {|| { 	aCols2[oGetD2:nAt,01] ,;
	aCols2[oGetD2:nAt,02] ,;
	aCols2[oGetD2:nAt,03] ,;
	Transform(aCols2[oGetD2:nAt,04],PesqPict('SE1','E1_VALOR')) ,;
	aCols2[oGetD2:nAt,05] }}
	oGetD2:Align:= CONTROL_ALIGN_ALLCLIENT
	oGetD2:bLDblClick 	:= { || telaNSU() }		//#AFD20180525.n
	
	oPanel3:= oFWLayerItens:GetWinPanel("COL2","WIN2","CONSULTA")
	
	oGetD3:=MsNewGetDados():New(0,0,0,0,0,"Allwaystrue","AllWaysTrue","",,,Len(aCols3),,,,oPanel3,@aHead3,@aCols3)
	oGetD3:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	
	oFWLayerItens:addLine("TOTAL", 15, .F.)
	oFwLayerItens:addCollumn( "COL1", 100, .F. , "TOTAL")
	oFwLayerItens:addWindow(  "COL1", "WIN1", ""	, 100, .T., .F., , "TOTAL")
	
	oPanel4:= oFWLayerItens:GetWinPanel("COL1","WIN1","TOTAL")
	
	@ 005,010 SAY "Total Pedidos"	OF oPanel4 PIXEL SIZE 038,010
	@ 004,040 MSGET nVlrTot 	PICTURE PesqPict('SUA','UA_VLRLIQ') WHEN .F. OF oPanel4 FONT oFont1 PIXEL SIZE 070,010 HASBUTTON
	
	@ 005,130 SAY "Total RA" OF oPanel4 PIXEL SIZE 060,010
	@ 004,190 MSGET nVlrRA 	PICTURE PesqPict('SUA','UA_VLRLIQ') WHEN .F. OF oPanel4 FONT oFont1 PIXEL SIZE 070,010 HASBUTTON
	
	@ 005,280 SAY "Cr้dito de RA" 	OF oPanel4 PIXEL SIZE 038,010
	@ 004,320 MSGET nVlrCR 	PICTURE PesqPict('SUA','UA_VLRLIQ') WHEN .F. OF oPanel4 FONT oFont1 PIXEL SIZE 070,010 HASBUTTON
	
	nVlrCX := nVlrTot + nVlrRA - nVlrCR
	@ 005,420 SAY "Total do Caixa" 	OF oPanel4 PIXEL SIZE 038,010
	@ 004,460 MSGET nVlrCX	PICTURE PesqPict('SUA','UA_VLRLIQ') WHEN .F. OF oPanel4 FONT oFont1 PIXEL SIZE 070,010 HASBUTTON
	
	@ 005,550 SAY "Valor Conferido"	OF oPanel4 PIXEL SIZE 038,010
	@ 004,590 MSGET oVlrConf VAR nVlrConf PICTURE PesqPict('SUA','UA_VLRLIQ') WHEN .F. OF oPanel4 FONT oFont1 PIXEL SIZE 070,010 HASBUTTON
	
	FwMsgRun( ,{|| CarregaSL4(aRegs1[oGetD1:nAt]) }, , "Filtrando Dados, por favor aguarde..." )
	
	
	ACTIVATE MSDIALOG oTela CENTERED ON INIT ( EnchoiceBar(oTela,{|| nOpc := 1 , oTela:End()  }, {||  nOpc := 0 , oTela:End() },,aButtons) )
	
Else
	MsgStop("Nใo existem pedidos para o fechamento do caixa.","Aten็ใo")
	Return
EndIF

If nOpc==1
	
	If MsgYesNO("Confirma o fechamento do Caixa ?","Aten็ใo")
		
		Begin Transaction
		
		FwMsgRun( ,{|| A107Grava(aRegs1,MV_PAR01,MV_PAR02,MV_PAR03) }, , "Por favor aguarde, conferindo os pedidos..." )
		
		End Transaction
		
	Endif
	
Endif

RETURN()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AjustaSx1บAutor  ณ SYMM Consultoria	 บ Data ณ  22/12/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria Perguntas na SX1 atraves da funcao PUTSX1().          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function AjustaSx1(cPerg)

Local aPergunta := {}
Local i
Local aAreaBKP := GetArea()

Aadd(aPergunta,{cPerg,"01","Filial ?"			,"MV_CH01" ,"C",004,00,"G","MV_PAR01",""     ,""      ,""			,"","",""	,""   	})
Aadd(aPergunta,{cPerg,"02","Data de ?" 			,"MV_CH02" ,"D",008,00,"G","MV_PAR02",""     ,""      ,""			,"","",""	,""		})
Aadd(aPergunta,{cPerg,"03","Data at้ ?" 		,"MV_CH03" ,"D",008,00,"G","MV_PAR03",""     ,""      ,""			,"","",""	,""		})
Aadd(aPergunta,{cPerg,"04","Tipo Pedido"  		,"MV_CH04" ,"N",001,00,"C","MV_PAR04","Pedido Nใo Conferido","Pedido Conferido","Ambos"	,"","",""	,""   	})

dbSelectArea("SX1")

SX1->(dbSetOrder(1))

For i := 1 To Len(aPergunta)
	SX1->(RecLock("SX1",!dbSeek(aPergunta[i,1]+aPergunta[i,2])))
	SX1->X1_GRUPO 		:= aPergunta[i,1]
	SX1->X1_ORDEM		:= aPergunta[i,2]
	SX1->X1_PERGUNT		:= aPergunta[i,3]
	SX1->X1_VARIAVL		:= aPergunta[i,4]
	SX1->X1_TIPO		:= aPergunta[i,5]
	SX1->X1_TAMANHO		:= aPergunta[i,6]
	SX1->X1_DECIMAL		:= aPergunta[i,7]
	SX1->X1_GSC			:= aPergunta[i,8]
	SX1->X1_VAR01		:= aPergunta[i,9]
	SX1->X1_DEF01		:= aPergunta[i,10]
	SX1->X1_DEF02		:= aPergunta[i,11]
	SX1->X1_DEF03		:= aPergunta[i,12]
	SX1->X1_DEF04		:= aPergunta[i,13]
	SX1->X1_DEF05		:= aPergunta[i,14]
	SX1->X1_F3			:= aPergunta[i,15]
	SX1->(MsUnlock())
Next i

RestArea(aAreaBKP)

RETURN()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FILDADOS บ Autor ณ LUIZ EDUARDO F.C.  บ Data ณ 14/02/2018  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ FILTRA OS DADOS DA ROTINA                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
STATIC FUNCTION FILDADOS()

Local cQuery := ""

cQuery := " SELECT C5_XCONPED, C5_MSFIL, C5_XDESCFI, C5_NUM, C5_NUMTMK, C5_CLIENTE, C5_LOJACLI, A1_NOME, "
cQuery += " ISNULL((SELECT COUNT(E1_PARCELA) FROM SE1010 (NOLOCK) WHERE D_E_L_E_T_='' AND E1_PEDIDO=C5_NUM AND E1_MSFIL=C5_MSFIL GROUP BY E1_PEDIDO),0)  E1_PARCELA,  "
cQuery += " ISNULL((SELECT COUNT(AC9_CODOBJ) FROM AC9010 AC9 JOIN ACB010 ACB ON AC9_CODOBJ=ACB_CODOBJ WHERE AC9.D_E_L_E_T_='' AND ACB.D_E_L_E_T_='' AND ACB_FILIAL='' AND SUBSTRING(AC9_CODENT,1,6)=C5_CLIENTE AND SUBSTRING(AC9_CODENT,7,2)=C5_LOJACLI),0) AS ANEX,"
cQuery += " ISNULL((SELECT COUNT(C6_ITEM) FROM " + RETSQLNAME("SC6")
cQuery += " (NOLOCK) SC6 JOIN SB1010 (NOLOCK) SB1 ON SC6.C6_PRODUTO=SB1.B1_COD WHERE SC6.C6_MSFIL='"+cFilAnt+"'  AND SB1.B1_XACESSO <>'1' AND SC6.C6_FILIAL = SC5.C5_FILIAL AND SC6.D_E_L_E_T_ = ' ' AND SC6.C6_NUM = SC5.C5_NUM AND SC5.C5_EMISSAO BETWEEN '" + DTOS(MV_PAR02) + "' AND '" + DTOS(MV_PAR03) + "'),0) AGREG,
cQuery += " ( "
cQuery += " SELECT COUNT(*) FROM " + RETSQLNAME("SL4")
cQuery += " (NOLOCK) WHERE L4_FILIAL = C5_MSFIL "
cQuery += " AND D_E_L_E_T_ = ' ' "
cQuery += " AND L4_NUM = C5_NUMTMK "
cQuery += " ) AS PARCELAS, "
cQuery += " C5_EMISSAO, C5_VEND1, "
cQuery += " A3_NOME, (SELECT SUM(C6_VALOR) FROM " + RETSQLNAME("SC6")
cQuery += " (NOLOCK) WHERE C6_FILIAL = C5_FILIAL "
cQuery += " AND D_E_L_E_T_ = ' ' "
cQuery += " AND C6_NUM = C5_NUM) AS VALOR, UA_PEDPEND "
cQuery += " FROM " + RETSQLNAME("SC5") + " (NOLOCK) SC5 "
cQuery += " INNER JOIN " + RETSQLNAME("SA3") + " (NOLOCK) SA3 ON A3_COD = C5_VEND1 "
cQuery += " INNER JOIN " + RETSQLNAME("SA1") + " (NOLOCK) SA1 ON A1_COD = C5_CLIENTE "
cQuery += " AND A1_LOJA = C5_LOJACLI "
cQuery += " INNER JOIN " + RETSQLNAME("SUA") + " (NOLOCK) SUA ON UA_NUM = C5_NUMTMK "
cQuery += " AND UA_FILIAL = C5_MSFIL "
cQuery += " WHERE C5_FILIAL <> ' ' "
cQuery += " AND A3_FILIAL = '" + XFILIAL("SA3") + "' "
cQuery += " AND A1_FILIAL = '" + XFILIAL("SA1") + "' "
cQuery += " AND SC5.D_E_L_E_T_ = ' ' "
cQuery += " AND SA3.D_E_L_E_T_ = ' ' "
cQuery += " AND SA1.D_E_L_E_T_ = ' ' "
cQuery += " AND C5_NUMTMK <> ' ' "
cQuery += " AND C5_MSFIL = '" + MV_PAR01 + "' "
cQuery += " AND C5_EMISSAO BETWEEN '" + DTOS(MV_PAR02) + "' AND '" + DTOS(MV_PAR03) + "'"
cQuery += " AND UA_FILIAL <> ' ' "
cQuery += " AND SC5.D_E_L_E_T_ = ' ' "
cQuery += " AND SUA.D_E_L_E_T_ = ' ' " //#CMG20180622.n
IF MV_PAR04 == 1	//#CMG20180628.n
	cQuery += " AND C5_XCONPED <> '1' "
ElseIF MV_PAR04 == 2	//#CMG20180628.n
	cQuery += " AND C5_XCONPED = '1' "
EndIF

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

While TRB->(!EOF())
	aAdd( aRegs1, { IIF(TRB->C5_XCONPED == "1" , .T. , .F.),; 	// 1 - FLAG QUE IRA MOSTRAR SE O PEDIDO JA FOI CONFERIDO OU NAO
	TRB->C5_MSFIL + " / " + TRB->C5_XDESCFI,;  	// 2 - LOJA DE ORIGEM
	TRB->C5_NUM,;                              		// 3 - NUMERO DO PEDIDO
	TRB->C5_NUMTMK,;                           		// 4 - NUMERO DO ORCAMENTO
	TRB->C5_CLIENTE + " - " + TRB->C5_LOJACLI,;    // 5 - CLIENTE
	TRB->A1_NOME,;                               	// 6 - NOME DO CLIENTE
	TRB->PARCELAS,;                               	// 7 - QUANTIDADE DE PARCELAS
	TRB->C5_EMISSAO,;                             	// 8 - DATA DE EMISSAO
	TRB->C5_VEND1,;                               	// 9 - CODIGO DO VENDEDOR
	TRB->A3_NOME,;                                	// 10 - NOME DO VENDEDOR
	TRB->VALOR,;									// 11 - VALOR
	IIf(TRB->UA_PEDPEND=="1","Em Aguardar",IIf(TRB->UA_PEDPEND=="2","Pendencia Financeira",IIf(TRB->UA_PEDPEND=="3","Pedido Conferido",IIf(TRB->UA_PEDPEND=="4","Pedido Normal","Em Aguardar Conferido")))),;
	TRB->E1_PARCELA,;
	TRB->ANEX,;
	TRB->AGREG})
	
	IF TRB->C5_XCONPED == "1"
		nVlrConf += TRB->VALOR
	EndIF

	TRB->(DbSkip())

EndDo

cQuery := " SELECT E1_01VALCX, E1_MSFIL, E1_XDESCFI, E1_NUM AS NUMERO, E1_PREFIXO AS NUMTMK, E1_CLIENTE, E1_LOJA, "
cQuery += " E1_NOMCLI, ( "
cQuery += " SELECT COUNT(*) FROM " + RETSQLNAME("SE1") + " SE1RA "
cQuery += " WHERE SE1RA.E1_FILIAL = '" + XFILIAL("SE1") + "' "
cQuery += " AND SE1RA.E1_PREFIXO = SE1.E1_PREFIXO "
cQuery += " AND SE1RA.E1_NUM = SE1.E1_NUM "
cQuery += " AND SE1RA.E1_TIPO <> 'RA' "
cQuery += " AND SE1RA.D_E_L_E_T_ = ' ' ) "
cQuery += " AS PARCELAS, E1_EMISSAO, '' AS CODVEND, E1_USRNAME, E1_VALOR "
cQuery += " FROM " + RETSQLNAME("SE1") + " SE1 "
cQuery += " WHERE SE1.E1_FILIAL = '" + XFILIAL("SE1") + "' "
cQuery += " AND SE1.D_E_L_E_T_ = ' ' "
cQuery += " AND SE1.E1_TIPO = 'RA' "
cQuery += " AND E1_MSFIL = '" + MV_PAR01 + "' "
cQuery += " AND E1_EMISSAO BETWEEN '" + DTOS(MV_PAR02) + "' AND '" + DTOS(MV_PAR03) + "'"
IF MV_PAR04 == 1
	cQuery += " AND E1_01VALCX <> '1' "
ElseIF MV_PAR04 == 2
	cQuery += " AND E1_01VALCX = '1' "
EndIF

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

While TRB->(!EOF())
	aAdd( aRegs1, { IIF(TRB->E1_01VALCX == "1" , .T. , .F.),; 	// 1 - FLAG QUE IRA MOSTRAR SE O PEDIDO JA FOI CONFERIDO OU NAO
	TRB->E1_MSFIL + " / " + TRB->E1_XDESCFI,;  	// 2 - LOJA DE ORIGEM
	TRB->NUMERO,;                              		// 3 - NUMERO DO PEDIDO
	TRB->NUMTMK,;                           		// 4 - NUMERO DO ORCAMENTO
	TRB->E1_CLIENTE + " - " + TRB->E1_LOJA,;    	// 5 - CLIENTE
	TRB->E1_NOMCLI,;                               	// 6 - NOME DO CLIENTE
	TRB->PARCELAS,;                               	// 7 - QUANTIDADE DE PARCELAS
	TRB->E1_EMISSAO,;                             	// 8 - DATA DE EMISSAO
	TRB->CODVEND,;                               	// 9 - CODIGO DO VENDEDOR
	TRB->E1_USRNAME,;                              	// 10 - NOME DO VENDEDOR
	TRB->E1_VALOR,;									// 11 - VALOR TOTAL DO PEDIDO
	"RA"  } )
	
	IF TRB->E1_01VALCX == "1"
		nVlrConf += TRB->E1_VALOR
	EndIF
	
	TRB->(DbSkip())
EndDo

aSort(aRegs1,,,{ |x,y| y[8] > x[8] } )

RETURN()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ A107Gravaบ Autor ณ LUIZ EDUARDO F.C.  บ Data ณ 14/02/2018  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ GRAVA AS INFORMACOES NOS PEDIDOS/RA                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function A107Grava(aRegs1,MV_PAR01,MV_PAR02,MV_PAR03)

Local nI 		:= 0
Loca nToC5		:= 0
Local nToE1		:= 0
Local cLocDep 	:= GetMv("MV_SYLOCDP",,"100001")
Local cAlias 	:= GetNextAlias()
Local cAliUc	:= GetNextAlias()
Local cAliSe1   := GetNextAlias()
Local cAliPeC	:= GetNextAlias()
Local nOpcao 	:= ""
Local cQueUc    := ""
Local cQse1		:= ""
Local Msg 		:= ""
Local cQuSc5	:= ""
Local aCance    := {}
Local aTitCa	:= {}
Local aPedCon   := {}
Local aPenden   := {}
Local cUser := RetCodUsr() //Retorna o Codigo do Usuario
Local cNamUser := UsrRetName( cUser )//Retorna o nome do usuario 
Local lRet:= .T.



For nI := 1 To Len(aRegs1)
	
	//Tratamento para o Ticket 8201
	//If aRegs1[nI,13] <> aRegs1[nI,7]
	//	msgAlert("O Caixa nใo serแ fechado porque existe(m) pedido(s) sem tํtulo no financeiro. Por favor exclua e refaca o pedido : "+ aRegs1[nI,3], "ATENวรO")
	//	Return
	//Endif
	//If lVldAne
	If aRegs1[nI,12] <> 'RA' 
		If aRegs1[nI,15] > 0
			If Empty(aRegs1[nI,14])
				msgAlert("O Caixa nใo serแ fechado porque nใo existe anexo no pedido para o cliente: "+ aRegs1[nI,5], "ATENวรO")
				Return
			Endif
			If aRegs1[nI,14] < 2
				msgAlert("O Caixa nใo serแ fechado porque nใo existe quantidade suficiente de anexos para o cliente: "+ aRegs1[nI,5], "ATENวรO")
				Return
			Endif
		Endif
	Endif
	//Endif
Next nI

	
	//Tratamento para bloquar o fechamento do caixa caso a loja tenha chamando de cancela substituํ em aberto
	
	cQueUc := CRLF + "   SELECT DISTINCT UC_CODIGO AS CHAMADO,C5_NUM AS PEDIDO,A1_COD AS CODIGO,A1_NOME AS NOME    "
	cQueUc += CRLF + "   FROM SUD010(NOLOCK)  SUD "
	cQueUc += CRLF + "   INNER JOIN SUC010(NOLOCK)  SUC ON UC_FILIAL = UD_FILIAL AND UC_CODIGO = UD_CODIGO "
	cQueUc += CRLF + "   INNER JOIN SC5010(NOLOCK)  SC5 ON UC_01PED = C5_MSFIL+C5_NUM "
	cQueUc += CRLF + "   INNER JOIN SA1010(NOLOCK)  SA1 ON A1_COD + A1_LOJA = UC_CHAVE "
	cQueUc += CRLF + "   WHERE UD_FILIAL = '' "
	cQueUc += CRLF + "   AND UC_FILIAL = '' "
	cQueUc += CRLF + "   AND UC_STATUS <> '3 ' "	
	cQueUc += CRLF + "   AND SUD.D_E_L_E_T_ = ' ' "
	cQueUc += CRLF + "   AND SUC.D_E_L_E_T_ = ' ' "
	cQueUc += CRLF + "   AND UD_ASSUNTO = '000009'"
	cQueUc += CRLF + "   AND UC_DATA < GETDATE() - 2"
	cQueUc += CRLF + "   AND UC_MSFIL = '"+cFilAnt+"'
	
	PlsQuery(cQueUc,cAliUc)
	DbSelectArea(cAliUc)
	(cAliUc)->(DbGoTop())
	
	While (cAliUc)->(!Eof())
		Aadd(aCance,{(cAliUc)->CHAMADO,;
					(cAliUc)->PEDIDO,;
					(cAliUc)->CODIGO,;
					(cAliUc)->NOME})
		(cAliUc)->(dbSkip())
	End
		(cAliUc)->(dbCloseArea())
		
	If len(aCance) == 0
	
	Else
		for nY := 1 to len(aCance)
			Msg := "O Caixa nใo serแ fechado porque Existem chamados de Cancela Substituํ em aberto." + CRLF
			Msg += "Em Caso de Duvidas entre em contato com o Regional da sua loja." + CRLF
			Msg += "Chamado:"+ aCance[nY][1] + CRLF
			Msg += "Pedido:"+ aCance[nY][2] + CRLF
			Msg += "Codigo Cliente:"+ aCance[nY][3] + CRLF
			Msg += "Nome Cliente:"+ aCance[nY][4] + CRLF
			msgAlert(Msg ,cAlert4)	
		next nY	
		Return
   EndIf
   //  Fim tratamento cancela substituํ em aberto

   // Tratamento para verificar os titulos gerados pelo cancela substituํ  que ainda nใo foram utilizados 
        cQse1 := CRLF + "  SELECT DISTINCT UC_CODIGO AS CHAMADO, E1_NUM AS TITULO,A1_COD AS CODIGO, A1_NOME AS NOME "
		cQse1 += CRLF + "  FROM SUD010(NOLOCK)  SUD "
		cQse1 += CRLF + "  INNER JOIN SUC010(NOLOCK)  SUC ON UC_FILIAL = UD_FILIAL AND UC_CODIGO = UD_CODIGO "
		cQse1 += CRLF + "  INNER JOIN SE1010(NOLOCK) SE1 ON UC_CODIGO = E1_01SAC AND E1_XPEDORI = RIGHT(RTRIM(UC_01PED),6) "
		cQse1 += CRLF + "  INNER JOIN SC5010(NOLOCK) SC5 ON RIGHT(RTRIM(UC_01PED),6) = C5_NUM "
		cQse1 += CRLF + "  INNER JOIN SA1010(NOLOCK)  SA1 ON A1_COD + A1_LOJA = UC_CHAVE "
		cQse1 += CRLF + "  WHERE UD_FILIAL = '' "
		cQse1 += CRLF + "  AND E1_SALDO > 0 "
		cQse1 += CRLF + "  AND UC_FILIAL = '' " 
		cQse1 += CRLF + "  AND SUD.D_E_L_E_T_ = ' ' "
		cQse1 += CRLF + "  AND SUC.D_E_L_E_T_ = ' ' "
		cQse1 += CRLF + "  AND SE1.D_E_L_E_T_ = ' ' "
		cQse1 += CRLF + "  AND UD_ASSUNTO = '000009' "
		cQse1 += CRLF + "  AND UD_SOLUCAO IN ('000145','000146') "
		cQse1 += CRLF + "  AND UC_CODIGO NOT IN (SELECT C5_01SAC FROM  SC5010(NOLOCK) WHERE D_E_L_E_T_ = '') "
		cQse1 += CRLF + "  AND UC_MSFIL = '"+cFilAnt+"' "
		cQse1 += CRLF + "  AND E1_EMISSAO < GETDATE() -1 " // regra de 1 dia par utiliza็ใo de cr้dito solicitado por Isaias - chamado: 14979

	 PlsQuery(cQse1,cAliSe1)
	 DbSelectArea(cAliSe1)
	(cAliSe1)->(DbGoTop())

	While (cAliSe1)->(!Eof())
		Aadd(aTitCa,{(cAliSe1)->CHAMADO,;
					(cAliSe1)->TITULO,;
					(cAliSe1)->CODIGO,;		
					(cAliSe1)->NOME})
		(cAliSe1)->(dbSkip())
	End
		(cAliSe1)->(dbCloseArea())
		
	If len(aTitCa) == 0
	
	Else 
		for nr := 1 to len(aTitCa)
			Msg := "O Caixa nใo serแ fechado porque Existem Titulos em aberto" + CRLF
			Msg += "Esse Titulo deve ser Utilizado na gera็ใo de um novo Pedido" + CRLF
			Msg += "Chamado:"+ aTitCa[nr][1] + CRLF
			Msg += "Titulo:"+ aTitCa[nr][2] + CRLF
			Msg += "Codigo Cliente:"+ aTitCa[nr][3] + CRLF
			Msg += "Nome Cliente:"+ aTitCa[nr][4] + CRLF
			msgAlert(Msg ,cAlert4)	
		next nr 
		Return
	EndIf
     //  Fim tratamento para verificar os titulos gerados pelo cancela substituํ 
     
     //tratamento para a trava no fechamento de caixa financeiro 
     cQuSc5 := CRLF + " SELECT C5_NUM, C5_CLIENTE, C5_EMISSAO "
     cQuSc5 += CRLF + " FROM SC5010(NOLOCK) SC5 "
     cQuSc5 += CRLF + " INNER JOIN SUA010(NOLOCK) SUA ON C5_NUMTMK = UA_NUM AND C5_MSFIL = UA_FILIAL  "
     cQuSc5 += CRLF + " WHERE C5_MSFIL = '"+cFilAnt+"'  "
     cQuSc5 += CRLF + " AND C5_CLIENTE <> '000001' "  	
     cQuSc5 += CRLF + " AND C5_EMISSAO BETWEEN '" + DTOS(MV_PAR02) + "' AND '" + DTOS(MV_PAR03) + "'"
     cQuSc5 += CRLF + " AND SC5.D_E_L_E_T_ = ''  "
     cQuSc5 += CRLF + " AND SUA.D_E_L_E_T_ ='' "
     cQuSc5 += CRLF + " ORDER BY C5_NUM "
     
     PlsQuery(cQuSc5,cAliPeC)
	 DbSelectArea(cAliPeC)
	(cAliPeC)->(DbGoTop())
	
	
	While (cAliPeC)->(!Eof())
		Aadd(aPedCon,{(cAliPeC)->C5_NUM,;
					(cAliPeC)->C5_CLIENTE,;
					(cAliPeC)->C5_EMISSAO})
		(cAliPeC)->(dbSkip())
	End
		(cAliPeC)->(dbCloseArea())
		
		for na := 1 to len(aPedCon)
			nToC5 := fConfFin(aPedCon[na][1])
			nToE1 := fOnfE1(aPedCon[na][1],aPedCon[na][3],aPedCon[na][2])
			If ! nToC5 <= nToE1
				Msg := "O Caixa nใo serแ fechado porque Existem Divergencia entre o pedido e o financeiro" + CRLF
				Msg += "Esse pedido deve ser cancelado e lan็ado novamente" + CRLF
				Msg += "Pedido:"+ aPedCon[na][1] + CRLF
				Msg += "Cliente:"+ aPedCon[na][2] + CRLF
				msgAlert(Msg ,cAlert4)	
				Return	
			EndIf
			aPenden := fVanexo(aPedCon[na][3],cFilAnt)
			If aPenden [1][2]
				Msg := "Existem pedidos com forma de pagamento R$ que nใo possuem Anexo de Pagamento" + CRLF
				Msg += "ศ necessแrio informar o CTR e anexar o comprovante do dep๓sito" + CRLF
				Msg += "Pedido:"+ aPenden[1][1] + CRLF
				Msg += "Cliente:"+ aPenden[1][3] + CRLF
				msgAlert(Msg ,cAlert4)	
				Return	
			EndIf	
		next na

For nI := 1 To Len(aRegs1)
	
	If Alltrim(UPPER(aRegs1[nI,12]))=="PEDIDO NORMAL"
		nOpcao := "3"
	ElseIf Alltrim(UPPER(aRegs1[nI,12]))=="EM AGUARDAR"
		nOpcao := "5"
	ElseIf Alltrim(UPPER(aRegs1[nI,12]))=="RA"
		nOpcao := "99"
	Endif
	
	If aRegs1[nI,1] .AND. nOpcao <> "99"
		
		SUA->( DbSetOrder(1) )
		If SUA->( DbSeek( LEFT(aRegs1[nI,2],4) + aRegs1[nI,4] ) )
			Reclock("SUA",.F.)
			iif(SC5->C5_PEDPEND <> "2",SUA->UA_PEDPEND := nOpcao,)
			Msunlock()
		Endif
		
		SC5->(DbSetOrder(1))
		If SC5->(DbSeek(xFilial("SC5")+aRegs1[nI,3]))
			Reclock("SC5",.F.)
			iif(SC5->C5_PEDPEND <> "2",SC5->C5_PEDPEND := nOpcao,)
			SC5->C5_XCONPED := "1" // MARCA O PEDIDO COMO CONFERIDO - LUIZ EDUARDO F.C. - 01.02.2018
			SC5->C5_XCONFER :=  cNamUser
			Msunlock()
			
			SC6->(DbSetOrder(1))
			If SC6->(DbSeek(xFilial("SC6")+aRegs1[nI,3]))
				While SC6->(!Eof()) .And. SC6->C6_FILIAL+SC6->C6_NUM==xFilial("SC6")+aRegs1[nI,3]
					Reclock("SC6",.F.)
					iif(SC6->C6_PEDPEND <> "2",SC6->C6_PEDPEND := nOpcao,)
					Msunlock()
					SC6->(DbSkip())
				End
			Endif
		Endif
		
		cQuery := ""
		cQuery := "SELECT R_E_C_N_O_ RECSE1 FROM "+RetSqlName("SE1")+" SE1 (NOLOCK) WHERE E1_PREFIXO = 'PED' AND E1_NUM = '"+aRegs1[nI,3]+"' AND E1_CLIENTE = '"+LEFT(aRegs1[nI,5],6)+"' AND E1_LOJA = '"+RIGHT(ALLTRIM(aRegs1[nI,5]),2)+"' AND E1_NUMSUA = '"+aRegs1[nI,4]+"' AND D_E_L_E_T_ = ' ' "
		
		cQuery := ChangeQuery(cQuery)
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
		
		
		(cAlias)->(DbGotop())
		While (cAlias)->(!Eof())
			
			DbSelectArea("SE1")
			DbGoto((cAlias)->RECSE1)
			RecLock("SE1",.F.)
			SE1->E1_PEDPEND := "1"
			Msunlock()
			(cAlias)->(DbSkip())
		End
		(cAlias)->( dbCloseArea() )
	Else
		IF aRegs1[nI,1]
			
			cQuery := ""
			cQuery += " SELECT R_E_C_N_O_ RECSE1 FROM " + RETSQLNAME("SE1") + " SE1 (NOLOCK) "
			cQuery += " WHERE E1_FILIAL = '" + XFILIAL("SE1") + "' "
			cQuery += " AND D_E_L_E_T_ = ' ' "
			cQuery += " AND E1_PREFIXO = '" + aRegs1[nI,4] + "' "
			cQuery += " AND E1_NUM = '" + aRegs1[nI,3] + "' "
			cQuery += " AND E1_EMISSAO = '" + aRegs1[nI,8] + "' "
			cQuery += " AND E1_TIPO = 'RA' "
			cQuery += " AND E1_CLIENTE = '" + LEFT(aRegs1[nI,5],6) + "' "
			
			cQuery := ChangeQuery(cQuery)
			DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
			
			(cAlias)->(DbGotop())
			While (cAlias)->(!Eof())
				
				DbSelectArea("SE1")
				DbGoto((cAlias)->RECSE1)
				RecLock("SE1",.F.)
				SE1->E1_01VALCX	:= "1"
				Msunlock()
				(cAlias)->(DbSkip())
			End
			(cAlias)->( dbCloseArea() )
			
			
		EndIF
	Endif
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Se o produto for encomenda gera Solicitacao de compra   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If aRegs1[nI,1]// Pedido selecionado
		U_KMCOMA05(aRegs1[nI,3],MV_PAR01)
	Endif
	
Next nI

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSYVM107   บAutor  ณMicrosiga           บ Data ณ  06/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CarregaSL4()

Local cQuery := ""
Local cAlias := GetNextAlias()
Local nNumPed
aCols2 := {}

If aRegs1[oGetD1:nAt,12] == "RA"
	cQuery := " SELECT E1_NUM, E1_VENCTO, E1_TIPO , E1_VALOR, E1_CARTAUT, E1_01NOOPE  FROM SE1010 "
	cQuery += " WHERE E1_FILIAL = ' ' "
	cQuery += " AND D_E_L_E_T_ = ' ' "
	cQuery += " AND E1_TIPO <> 'RA' "
	cQuery += " AND E1_NUM = '" + aRegs1[oGetD1:nAt,3] + "' "
	cQuery += " AND E1_PREFIXO = '" + aRegs1[oGetD1:nAt,4] + "' "
	cQuery += " AND E1_EMISSAO = '" + aRegs1[oGetD1:nAt,8] + "' "
	cQuery += " AND E1_MSFIL = '" + LEFT(aRegs1[oGetD1:nAt,2],4) + "' "
	
	If Select("TRB") > 0
		TRB->(DbCloseArea())
	EndIf
	
	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
	
	TRB->(DbGotop())
	While TRB->(!Eof())
		AAdd( aCols2 , { TRB->E1_NUM, TRB->E1_VENCTO, TRB->E1_TIPO + " - " + TRB->E1_01NOOPE, E1_VALOR, E1_CARTAUT } )
		TRB->(DbsKIP())
	End
	TRB->( dbCloseArea() )
	
	//Tratamento para evitar error log.//Data de emissao do RA diferente da data de emissใo da condi็ใo de pagto.
	if len(aCols2) == 0
		msgAlert("Condi็ใo de pagamento nใo encontrada para o RA: "+ aRegs1[oGetD1:nAt,3]+". Por favor entre em contato com o departamento Financeiro." ,"ATENวรO")
		AAdd( aCols2 , { "", ctod("//"), "XX", 0, "" } )
	endif
	
Else
	//	cQuery += " SELECT L4_NUM,L4_DATA,L4_FORMA,L4_VALOR,L4_XFORFAT, L4_AUTORIZ"//#AFD20180525.o
	cQuery += " SELECT L4_NUM,L4_DATA,L4_FORMA,L4_VALOR,L4_XFORFAT, L4_AUTORIZ, R_E_C_N_O_ AS RECNOSL4"//#AFD20180525.n
	cQuery += " FROM "+RetSqlName("SL4")+" SL4 "
	cQuery += " WHERE
	cQuery += " L4_FILIAL = '" + LEFT(aRegs1[oGetD1:nAt,02],4) + "' "
	cQuery += " AND L4_NUM = '" + aRegs1[oGetD1:nAt,04] + "' "
	cQuery += " AND L4_ORIGEM = 'SIGATMK' "
	cQuery += " AND SL4.D_E_L_E_T_= '' "
	cQuery += " ORDER BY L4_XFORFAT,L4_FORMA "
	
	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
	
	(cAlias)->(DbGotop())
	nRecSL4:=0
	cMensagem:=""
	While (cAlias)->(!Eof())
		AAdd( aCols2 , { (cAlias)->L4_NUM, (cAlias)->L4_DATA, (cAlias)->L4_FORMA, (cAlias)->L4_VALOR, (cAlias)->L4_AUTORIZ, (cAlias)->RECNOSL4 } )//#AFD20180525.n
		nRecSL4++
		
		(cAlias)->(DbsKIP())
	EndDO
	(cAlias)->( dbCloseArea() )
EndIF

oGetD2:AARRAY:= aCols2
oGetD2:Refresh()

oTela:REFRESH()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSYVM107   บAutor  ณMicrosiga           บ Data ณ  06/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CarregaVdas()

Local cQuery  := ""
Local cString := "'"
Local cRA     := "'"
Local cPre    := "'"
Local cAlias  := GetNextAlias()
Local nPos    := 0

DbSelectArea("SL4")
Aadd(aHead3,{RetTitle('L4_FORMA')	,'FORMA' 	, PesqPict('SL4','L4_FORMA')	,TamSx3('L4_FORMA')[1]	,X3Decimal('L4_FORMA' )	,'','','C','','',''})
Aadd(aHead3,{'Valor'				,'VALOR'	, PesqPict('SL4','L4_VALOR')	,TamSx3('L4_VALOR')[1]	,X3Decimal('L4_VALOR')	,'','','N','','',''})
Aadd(aHead3,{''						,'VAZIO'	, "@!"							,0						,0						,'','','C','','',''})

aCols3 := {}

For nX:=1 To Len(aRegs1)
	IF aRegs1[nX,12] == "RA"
		cRA  += aRegs1[nX,03]+"','"
		cPre += aRegs1[nX,04]+"','"
	Else
		cString += aRegs1[nX,4]+"','"
	EndIF
Next

cString := LEFT(cString,LEN(cString)-2)
cRA 	:= LEFT(cRA,LEN(cRA)-2)
cPre 	:= LEFT(cPre,LEN(cPre)-2)

IF !EMPTY(cString)
	cQuery += " SELECT L4_FORMA, SUM(L4_VALOR) L4_VALOR "
	cQuery += " FROM "+RetSqlName("SL4")+" SL4 "
	cQuery += " WHERE
	cQuery += " L4_FILIAL = '"+Mv_Par01+"' "
	cQuery += " AND L4_NUM IN ("+cString+") "
	cQuery += " AND L4_ORIGEM = 'SIGATMK' "
	cQuery += " AND SL4.D_E_L_E_T_= '' "
	cQuery += " GROUP BY L4_FORMA "
	cQuery += " ORDER BY L4_FORMA "
	
	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
	
	(cAlias)->(DbGotop())
	While (cAlias)->(!Eof())
		
		AAdd( aCols3 , { (cAlias)->L4_FORMA,(cAlias)->L4_VALOR , "" , .F. } )
		
		nVlrTot += (cAlias)->L4_VALOR
		
		IF ALLTRIM((cAlias)->L4_FORMA) == "CR"
			nVlrCR += (cAlias)->L4_VALOR
		EndIF
		
		(cAlias)->(DbsKIP())
	End
	(cAlias)->( dbCloseArea() )
EndIF

IF !EMPTY(cRA)
	cQuery := ""
	cQuery += " SELECT E1_TIPO, SUM(E1_VALOR) VALOR FROM " + RETSQLNAME("SE1")
	cQuery += " WHERE E1_FILIAL = '" + XFILIAL("SE1") + "' "
	cQuery += " AND D_E_L_E_T_ = ' ' "
	cQuery += " AND E1_TIPO <> 'RA' "
	cQuery += " AND E1_MSFIL = '" + MV_PAR01 + "' "
	cQuery += " AND E1_EMISSAO BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
	cQuery += " AND E1_NUM IN ("+cRA+") "
	cQuery += " AND E1_PREFIXO IN ("+cPre+") "
	cQuery += " GROUP BY E1_TIPO "
	
	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
	
	(cAlias)->(DbGotop())
	While (cAlias)->(!Eof())
		nPos := Ascan(aCols3,{|x| Alltrim(x[1]) == ALLTRIM((cAlias)->E1_TIPO)})
		
		If nPos > 0
			aCols3[nPos,2] := aCols3[nPos,2] + (cAlias)->VALOR
		Else
			AAdd( aCols3 , { (cAlias)->E1_TIPO,(cAlias)->VALOR , "" , .F. } )
		EndIF
		
		nVlrRA += (cAlias)->VALOR
		
		(cAlias)->(DbsKIP())
	End
	
	(cAlias)->( dbCloseArea() )
EndIF


Return
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VLRCONFE บ Autor ณ LUIZ EDUARDO F.C.  บ Data ณ 15/02/2018  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ ATUALIZA O VALOR CONFERIDO                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
STATIC FUNCTION VLRCONFE()

IF aRegs1[oGetD1:nAt,1]
	nVlrConf := nVlrConf - aRegs1[oGetD1:nAt,11]
Else
	nVlrConf := nVlrConf + aRegs1[oGetD1:nAt,11]
EndIF

oVlrConf:Refresh()

RETURN()


/*----------------------------------------------------------------/
@{Protheus.doc} vldNSU()
@Fun็ใo utilizada para validar a sele็ใo da linha posicinado
@author Alexis Duarte
@utilizacao Komfort House
@since 25/05/2018
/-----------------------------------------------------------------*/
Static Function vldNSU()

Local aArea := getArea()
Local cTitulo := "ATENวรO !!!"
Local cTexto := ""

for nx := 1 to len(oGetD2:AARRAY)
	if empty(oGetD2:AARRAY[nx][5]) .and. alltrim(oGetD2:AARRAY[nx][3]) $ "XX|CC|CD"
		
		cTexto := "Existe itens no pedido "+ aRegs1[oGetD1:nAt,3] +" Que estใo sem o NSU."+ENTER
		cTexto += "Para prosseguir com o fechamento, realize o preenchimento do campo."
		
		aRegs1[oGetD1:nAt,1] := !aRegs1[oGetD1:nAt,1]
		oGetD1:Refresh()
		exit
	endif
next nx

if !empty(cTexto)
	msgalert(cTexto, cTitulo)
endif

restArea(aArea)

Return

/*----------------------------------------------------------------/
@{Protheus.doc} vldNSU2()
@Fun็ใo utilizada para validar a sele็ใo no cabe็alho,
utilizado para selecionar todas as linhas
@author Alexis Duarte
@utilizacao Komfort House
@since 25/05/2018
/-----------------------------------------------------------------*/
Static Function vldNSU2()

Local aArea := getArea()
Local cTitulo := "ATENวรO !!!"
Local cTexto := ""

for ny := 1 to len(oGetD1:AARRAY)
	oGetD1:nAt := ny
	CarregaSL4()
	for nx := 1 to len(oGetD2:AARRAY)
		if empty(oGetD2:AARRAY[nx][5]) .and. alltrim(oGetD2:AARRAY[nx][3]) $ "CC|CD"
			
			cTexto += "Existe itens no pedido "+ oGetD1:AARRAY[ny][3] +" Que estใo sem o NSU."+ENTER
			
			oGetD1:AARRAY[ny][1] := !oGetD1:AARRAY[ny][1]
			oGetD1:Refresh()
			exit
		endif
	next nx
next ny

if !empty(cTexto)
	cTexto += "Para prosseguir com o fechamento, realize o preenchimento do campo."
	msgalert(cTexto, cTitulo)
endif

restArea(aArea)

Return

/*----------------------------------------------------------------/
@{Protheus.doc} telaNSU()
@Tela para o preenchimento do NSU
@author Alexis Duarte
@utilizacao Komfort House
@since 25/05/2018
/-----------------------------------------------------------------*/
Static Function telaNSU()

Local lHabilita := .T.
Local oDlg
Local oAutor
Local oCheckBox			//#RVC20180903.n
Local oCard4			//#RVC20180903.n
Local oFlag				//#RVC20180903.n
Local cTitNSU	:= "Preenchimento do NSU"
//	Local cAutor	:= Space(GetSx3Cache("E1_NSUTEF","X3_TAMANHO"))

Private lCheckBox	:= .F.																							//#RVC20180903.n
Private cAutor		:= Space(GetSx3Cache("E1_NSUTEF","X3_TAMANHO"))													//#RVC20180903.n
Private cCard4		:= Space(GetSx3Cache("E1_XNCART4","X3_TAMANHO"))												//#RVC20180903.n
Private cFlag		:= Space(GetSx3Cache("E1_XFLAG","X3_TAMANHO"))													//#RVC20180903.n
Private cTipo 		:= alltrim(oGetD2:AARRAY[oGetD2:nAt][3])														//#RVC20180903.n
Private aFlag		:= {"","MASTERCARD", "VISA", "ELO", "AMERICAN EXPRESS", "HIPER", "HIPERCARD", "ALELO","OUTROS"}	//#RVC20180903.n


if !(alltrim(oGetD2:AARRAY[oGetD2:nAt][3]) $ "CC|CD")
	msgAlert("Op็ใo disponivel somente para (CC e CD).","ATENวรO")
	Return
endif

//#RVC20180913.bo
/*	//#RVC20180904.bn
if !Empty(oGetD2:AARRAY[oGetD2:nAt][5])
Return
endIf
//#RVC20180904.en */
//#RVC20180913.eo

//Inicio da cria็ใo da tela para o preenchimento do NSU
DEFINE MSDIALOG oDlg FROM 10,20 TO 150,300 TITLE cTitNSU PIXEL STYLE DS_MODALFRAME

@05,10 SAY "Autorizacao" OF oDlg PIXEL
@05,57 MSGET oAutor  VAR cAutor Picture "@!"  SIZE 60,8 PIXEL OF oDlg When lHabilita VALID U_VLDIGNSU(cAutor)

//#RVC20180904.bn
@20,10 SAY "Cartใo(4 Ult. Dig.)" OF oDlg PIXEL
@20,57 MSGET oCard4  VAR cCard4 Picture "@!"  SIZE 60,8 PIXEL OF oDlg WHEN If(cTipo$"CC|CD",lHabilita,.F.) VALID U_VLDCARD(cCARD4)

@35,10 SAY "Bandeira" OF oDlg PIXEL
@35,57 MSCOMBOBOX oFlag VAR cFlag ITEMS aFlag SIZE 60,8 PIXEL OF oDlg WHEN If(cTipo$"CC|CD",lHabilita,.F.) VALID !Empty(cFlag)

//	@50,10 CHECKBOX oCheckBox VAR lCheckBox PROMPT "Aplicar p/ todas" SIZE 90,10 OF oDlg PIXEL WHEN If(cTipo$"CC|CD|BOL|BST",lHabilita,.F.)		//#RVC20181017.o
@50,10 CHECKBOX oCheckBox VAR lCheckBox PROMPT "Aplicar p/ todas" SIZE 90,10 OF oDlg PIXEL WHEN If(cTipo$"CC|BOL|BST",lHabilita,.F.)		//#RVC20181017.n
//#RVC20180904.en

//Confirmacao - Botao de Ok
//	DEFINE SBUTTON FROM 50,075 TYPE 1 ACTION {|| gravaNSU(cAutor), oDlg:end()} ENABLE OF oDlg																							//#RVC20180903.o
DEFINE SBUTTON FROM 50,075 TYPE 1 ACTION {|| IIf(IF(cTipo$"CC|CD",(!Empty(cAutor)) .AND. (!Empty(cCard4)) .AND. (!Empty(cFlag)) ,.T.),(gravaNSU(), oDlg:end()),NIL)} ENABLE OF oDlg	//#RVC20180903.n
DEFINE SBUTTON FROM 50,105 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg

// Desabilita a tecla ESC
oDlg:LESCCLOSE := .F.

ACTIVATE MSDIALOG oDlg CENTER

Return

/*----------------------------------------------------------------/
@{Protheus.doc} telaNSU()
@Atualiza o dados do NSU na tabela SL4
@author Alexis Duarte
@utilizacao Komfort House
@since 25/05/2018
/-----------------------------------------------------------------*/
//Static Function gravaNSU(cNSU)
Static Function gravaNSU()

Local aArea 	:= getArea()
Local nLinD2 	:= oGetD2:nAt
Local cObs		:= ""
Local cNumSL4	:= ""	//#RVC20180904.n
Local cForma	:= ""	//#RVC20180904.n
Local cAdm		:= ""	//#RVC20180904.n
Local nVlr		:= 0	//#RVC20180904.n

dbselectArea("SL4")

dbgoto(oGetD2:AARRAY[nLinD2][6])

cNumSL4 := SL4->L4_NUM						//#RVC20180904.n
cForma	:= SL4->L4_FORMA					//#RVC20180904.n
cFlag 	+= PADL(Alltrim(SL4->L4_XPARC),3)	//#RVC20180904.n
cAdm	:= SL4->L4_ADMINIS					//#RVC20180904.n
nVlr	:= SL4->L4_VALOR					//#RVC20180904.n
cObs 	:= alltrim(SL4->L4_OBS)


If alltrim(SL4->L4_FORMA) $ "CD|CC"		//#RVC20180903.n
	if empty(alltrim(SL4->L4_AUTORIZ))
		cObs := UPPER(cAdm)				//#RVC20180904.n
		nPos := len(cObs) - 1
		cObs := substr(cObs,1,nPos)
	else
		nPos := at("|",cObs)-1
		cObs := substr(cObs,1,nPos)
	endif
Endif

If lCheckBox
	SL4->(dbSetOrder(1))
	SL4->(dbGoTop())
	If SL4->(DbSeek(xFilial("SL4") + cNumSL4))
		While SL4->(!EOF()) .AND. SL4->L4_FILIAL + SL4->L4_NUM == xFilial("SL4") + cNumSL4
			If SL4->L4_ADMINIS == cAdm .AND. SL4->L4_FORMA == cForma .AND. SL4->L4_VALOR == nVlr
				SL4->(recLock("SL4",.F.))
				SL4->L4_ADMINIS := cObs
				SL4->L4_AUTORIZ := cAutor
				SL4->L4_OBS 	:= UPPER(cObs) + "|" + cAutor + "|" + cTipo + "|" + cCard4 + "|" + UPPER(Alltrim(cFlag))
				SL4->L4_COMP	:= "111"
				SL4->(msUnlock())
				SL4->(DbSkip())
				
				CarregaSL4()
				
			Else
				SL4->(DbSkip())
			EndIf
		Enddo
		SL4->(dbCloseArea())
	EndIf
Else
	SL4->(recLock("SL4",.F.))
	SL4->L4_ADMINIS := cObs
	SL4->L4_AUTORIZ := cAutor
	//		SL4->L4_OBS := (UPPER(cObs) + "|" + UPPER(cNSU) + "|" + substr(SL4->L4_FORMA,1,3) + SL4->L4_XPARC)		  //#RVC20180903.o
	SL4->L4_OBS := UPPER(cObs) + "|" + cAutor + "|" + cTipo + "|" + cCard4 + "|" + UPPER(Alltrim(cFlag))	  //#RVC20180903.n
	SL4->L4_COMP	:= "111"																				  //#RVC20180903.n
	SL4->(msUnlock())
	
	SL4->(dbCloseArea())
EndIf

//Atualiza as informa็๕es de Cartใo na SL4	 //#RVC20180905.n
U_TMKVSL4(cNumSL4)

//Atualiza as informa็๕es de Cartใo no Tํtulo //#RVC20180905.n
AtuSE1(cNumSL4)

oGetD2:Refresh()

apMsgInfo("NSU atualizado com sucesso!!","SUCCESS")

restArea(aArea)

Return

/*----------------------------------------------------------------/
@{Protheus.doc} AtuSE1(cNumSL4)
@Atualiza o dados do NSU na tabela SE1
@author Rafael Cruz
@utilizacao Komfort House
@since 05/09/2018
/-----------------------------------------------------------------*/
Static Function AtuSE1(cNumSL4)

Local aVencto	:= {}
Local aTitulo	:= {}
Local aTaxas	:= {}
Local cQuery	:= ""
Local nI		:= ""
Local _aArea	:= GetArea()	//#RVC20180913.n

If SELECT("TSL4") > 0
	TSL4->(DbCloseArea())
EndIf

cQuery += " SELECT * "
cQuery += " FROM "+RetSqlName("SL4")+" SL4 "
cQuery += " WHERE
cQuery += " L4_FILIAL = '" + xFilial("SL4") + "' "
cQuery += " AND L4_NUM = '" + cNumSL4 + "' "
cQuery += " AND L4_FORMA IN ('CC','CD') "
cQuery += " AND L4_ORIGEM = 'SIGATMK' "
cQuery += " AND SL4.D_E_L_E_T_= '' "
//	cQuery += " ORDER BY R_E_C_N_O_, L4_XFORFAT,L4_FORMA "	//#RVC20180917.o
cQuery += " ORDER BY R_E_C_N_O_ "						//#RVC20180917.n

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TSL4",.T.,.T.)

While TSL4->(!Eof())
	AAdd( aVencto , { TSL4->L4_AUTORIZ,;
	TSL4->L4_XPARNSU,;
	TSL4->L4_XNCART4,;
	TSL4->L4_XFLAG})
	TSL4->(DbsKIP())
End
TSL4->(dbCloseArea())

If SELECT("TSE1") > 0
	TSE1->(DbCloseArea())
EndIf

cQuery := ""
cQuery += " SELECT * "
cQuery += " FROM "+RetSqlName("SE1")+" SE1 "
cQuery += " WHERE
cQuery += " E1_FILIAL = '" + xFilial("SE1") + "' "
cQuery += " AND E1_TIPO IN ('CC','CD') "
cQuery += " AND E1_NUMSUA = '" + cNumSL4 + "' "
cQuery += " AND SE1.D_E_L_E_T_= '' "
cQuery += " ORDER BY R_E_C_N_O_ "

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TSE1",.T.,.T.)

TSE1->(DbGotop())
While TSE1->(!Eof())
	AAdd( aTitulo , { TSE1->R_E_C_N_O_ } )
	TSE1->(DbsKIP())
End
TSE1->(dbCloseArea())

If SELECT("TSE2") > 0
	TSE2->(DbCloseArea())
EndIf

cQuery := ""
cQuery += " SELECT * "
cQuery += " FROM "+RetSqlName("SE2")+" SE2 "
cQuery += " WHERE
cQuery += " E2_FILIAL = '" + xFilial("SE2") + "' "
cQuery += " AND E2_TIPO IN ('CC','CD') "
cQuery += " AND E2_01NUMRA = '" + cNumSL4 + "' "
cQuery += " AND SE2.D_E_L_E_T_= '' "
cQuery += " ORDER BY R_E_C_N_O_ "

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TSE2",.T.,.T.)

TSE2->(DbGotop())
While TSE2->(!Eof())
	AAdd( aTaxas , { TSE2->R_E_C_N_O_ } )
	TSE2->(DbsKIP())
End
TSE2->(dbCloseArea())


//#RVC20180913.bn
If Len(aTitulo) <> Len(aVencto)
	MsgStop("Hแ inconsist๊ncia(s) no(s) dado(s)." + Chr(13) + Chr(10) +" " + Chr(13) + Chr(10) + "Contate o Administrador do Sistema","Forma de Pagamento")
	RETURN
EndIf
//#RVC20180913.en

dbSelectArea("SE1")
For nI := 1 to Len(aVencto)
	dbGoto(aTitulo[nI][1])
	SE1->(recLock("SE1",.F.))
	SE1->E1_NSUTEF 	:= aVencto[nI,1]
	SE1->E1_DOCTEF	:= aVencto[nI,1]
	SE1->E1_XPARNSU := aVencto[nI,2]
	SE1->E1_XNCART4	:= aVencto[nI,3]
	SE1->E1_XFLAG	:= aVencto[nI,4]
	SE1->(msUnlock())
Next
SE1->(dbCloseArea())

if !Empty(aTaxas)
	dbSelectArea("SE2")
	For nI := 1 to Len(aVencto)
		dbGoto(aTaxas[nI][1])
		SE2->(recLock("SE2",.F.))
		SE2->E2_XNSUTEF	:= aVencto[nI,1]
		SE2->E2_XPARNSU := aVencto[nI,2]
		SE2->E2_XNCART4	:= aVencto[nI,3]
		SE2->E2_XFLAG	:= aVencto[nI,4]
		SE2->(msUnlock())
	Next
	SE2->(dbCloseArea())
endIf

RestArea(_aArea)//#RVC20180913.n
MsUnLockAll()	//#RVC20180913.n
Return


Static function fConfFin(_cNuSc)
Local nFret		:= 0
Local nDesps	:= 0
Local nProdut   := 0
Local _TotPe	:= 0
Local cAliasc  := GetNextAlias()
Local  cQuSc5  := ""
Local aPedRet := {}

  	 cQuSc5 := CRLF + " SELECT C5_FRETE , C5_DESPESA ,C6_PRCVEN,C6_QTDVEN "
     cQuSc5 += CRLF + " FROM SC5010(NOLOCK) SC5 "
     cQuSc5 += CRLF + " INNER JOIN SUA010(NOLOCK) SUA ON C5_NUMTMK = UA_NUM AND C5_MSFIL = UA_FILIAL  "
     cQuSc5 += CRLF + " INNER JOIN SC6010(NOLOCK) SC6 ON SC6.D_E_L_E_T_ = '' AND C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM "
    // cQuSc5 += CRLF + " WHERE C5_MSFIL = '"+cFilAnt+"'  "
     cQuSc5 += CRLF + " WHERE C5_CLIENTE <> '000001' "  	
     //cQuSc5 += CRLF + " AND C5_EMISSAO BETWEEN '" + DTOS(MV_PAR02) + "' AND '" + DTOS(MV_PAR03) + "'"
     cQuSc5 += CRLF + " AND SC6.C6_NUM = '"+_cNuSc+"' "
     cQuSc5 += CRLF + " AND SC5.D_E_L_E_T_ = ''  "
     cQuSc5 += CRLF + " AND SUA.D_E_L_E_T_ ='' "
     cQuSc5 += CRLF + " AND SC6.D_E_L_E_T_ ='' "
     cQuSc5 += CRLF + " ORDER BY C5_NUM "

     PlsQuery(cQuSc5,cAliasc)
	 DbSelectArea(cAliasc)
	(cAliasc)->(DbGoTop())
	
	
	While (cAliasc)->(!Eof())
		Aadd(aPedRet,{(cAliasc)->C5_FRETE,;
					  (cAliasc)->C5_DESPESA,;
					  (cAliasc)->C6_PRCVEN,;
					  (cAliasc)->C6_QTDVEN})
		(cAliasc)->(dbSkip())
	End
		(cAliasc)->(dbCloseArea())
		
		for nx := 1 to len(aPedRet)
			nFret := aPedRet[nx][1]
			nDesps := aPedRet[nx][2]
			nProdut += (aPedRet[nx][3]*aPedRet[nx][4])
		next nx
		
     _TotPe := nFret + nDesps + nProdut


Return _TotPe

Static function fOnfE1(_cNumP,_dDatEm,_cClie)

Local nToE1 := 0
Local cQery := ""
Local cQeRa := ""
Local cQeNcc := ""
Local aConE1 := {}
Local aConRa := {}
Local aConNcc := {}
Local cAliE1 := GetNextAlias()
Local cAliRa := GetNextAlias()
Local cAliNcc := GetNextAlias()
	
	cQery := CRLF + " SELECT  CASE WHEN SUM(E1_VALOR) IS NULL THEN 0 ELSE SUM(E1_VALOR) END  TOTAL FROM SE1010(NOLOCK) "
	//cQery += CRLF + " WHERE E1_CLIENTE = '"+_cClie+"' "
	cQery += CRLF + " WHERE E1_NUM = '"+_cNumP+"' "
	cQery += CRLF + " AND E1_EMISSAO = '"+ DTOS(_dDatEm) +"' "
	cQery += CRLF + " AND D_E_L_E_T_ = '' "
	cQery += CRLF + " AND E1_TIPO <> 'RA' "
	
	PlsQuery(cQery,cAliE1)
	 DbSelectArea(cAliE1)
	(cAliE1)->(DbGoTop())
	
	While (cAliE1)->(!Eof())
		Aadd(aConE1,{(cAliE1)->TOTAL})
		(cAliE1)->(dbSkip())
	End
		(cAliE1)->(dbCloseArea())
	
	nToE1 := aConE1[1][1]
	
	cQeRa := CRLF + " 	SELECT  CASE WHEN SUM(E1_VALOR) IS NULL THEN 0 ELSE SUM(E1_VALOR) END  TOTALRA FROM SE1010(NOLOCK) "
	cQeRa += CRLF + " 	WHERE E1_PEDIDO = '"+_cNumP+"' "
	cQeRa += CRLF + " 	AND E1_BAIXA = '"+ DTOS(_dDatEm) +"' "
	cQeRa += CRLF + " 	AND D_E_L_E_T_ = '' "
	PlsQuery(cQeRa,cAliRa)
	 DbSelectArea(cAliRa)
	(cAliRa)->(DbGoTop())
	While (cAliRa)->(!Eof())
		Aadd(aConRa,{(cAliRa)->TOTALRA})
		(cAliRa)->(dbSkip())
	End
		(cAliRa)->(dbCloseArea())
	nToE1 += aConRa[1][1]
	
	cQeNcc := CRLF + "  SELECT  CASE WHEN SUM(E1_VALOR) IS NULL THEN 0 ELSE SUM(E1_VALOR) END  TOTALRA FROM SE1010(NOLOCK) "
	cQeNcc += CRLF + "  WHERE E1_CLIENTE = '"+_cClie+"' "
	cQeNcc += CRLF + "  AND E1_BAIXA = '"+ DTOS(_dDatEm) +"' "
	cQeNcc += CRLF + "  AND E1_TIPO IN ('NCC','RA') "
	cQeNcc += CRLF + "  AND D_E_L_E_T_ = '' "
	
	PlsQuery(cQeNcc,cAliNcc)
	 DbSelectArea(cAliNcc)
	(cAliNcc)->(DbGoTop())
	While (cAliNcc)->(!Eof())
		Aadd(aConNcc,{(cAliNcc)->TOTALRA})
		(cAliNcc)->(dbSkip())
	End
		(cAliNcc)->(dbCloseArea())
	nToE1 += aConNcc[1][1]
	

Return nToE1



Static function fVanexo(_dEmis,_cfil)

Local dDtEmi 
Local cQuSc5 := ""
Local cQuery := ""
Local lVane := .F.
Local aAnex := {}
Local aPend := {{"",lVane}}
Local aFalAn := {}
Local cAliaNe := GetNextAlias()
Local cAliSc5 := GetNextAlias()

dDtEmi := dtos(_dEmis-2)


cQuery += CRLF + "SELECT E1_XCTR,E1_XCTR1,E1_XCTR2, E1_NUM, E1_CLIENTE, E1_XANEXO FROM SE1010 (NOLOCK) "
cQuery += CRLF + "WHERE E1_MSFIL = '"+_cfil+"'  "
cQuery += CRLF + "AND E1_TIPO = 'R$' "
cQuery += CRLF + "AND E1_EMISSAO BETWEEN '20200101' AND '"+dDtEmi+"' "
cQuery += CRLF + "AND D_E_L_E_T_ = ' ' " 

PlSquery(cQuery,cAliaNe)


while (cAliaNe)->(!EOF())
Aadd(aAnex,{(cAliaNe)->E1_XCTR,;
			(cAliaNe)->E1_XCTR1,;
			(cAliaNe)->E1_XCTR2,;
			(cAliaNe)->E1_NUM,;
			(cAliaNe)->E1_CLIENTE,;
			(cAliaNe)->E1_XANEXO})
	(cAliaNe)->(DbSkip())
End
	(cAliaNe)->(DbCloseArea())
	
	If Len(aAnex) > 0
		for nx := 1 to len((aAnex))
			if (EMPTY(aAnex[nx][1]) .and. EMPTY(aAnex[nx][2]) .and. EMPTY(aAnex[nx][3])) .or. EMPTY(aAnex[nx][6])
			lVane := .T.
			Aadd(aFalAn,{aAnex[nx][4],lVane,aAnex[nx][5]})
			return aFalAn			
			EndIf 
		next nx
	EndIf



return aPend






