#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FWBROWSE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออหอออออออัออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ  SYVM107		บAutor  ณEduardo Patrianiบ Data ณ 05/06/2014  บฑฑ
ฑฑฬออออออออออุออออออออออออออสอออออออฯออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela de Fechamento de Caixa.                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SYVM107()

U_KMLOJA01()
            
/*
Local nX,nY,nPos
Local aPosObj   	:= {}
Local aObjects  	:= {}
Local aSize     	:= {}
Local aInfo     	:= {}
Local aButtons 		:= {}
Local cPerg			:= Padr("SYVM107A",10)
Local oFont1 		:= TFont():New("Tahoma",,018,,.T.,,,,,.F.,.F.)
Local nOpc			:= 0
Local oDlg
Local oPanel1
Local oPanel2
Local oFwLayerRes
Local cAlias
Local cQuery

Local bMarkOne 	 := &("{ || If(Alltrim(UPPER(aRegs1[oTela01:nAt,9]))$'PEDIDO NORMAL|EM AGUARDAR',aRegs1[oTela01:nAt,1]:= !aRegs1[oTela01:nAt,1],aRegs1[oTela01:nAt,1]:=.F.) , A107VLD1(aRegs1,@oVlrConf) , oTela01:Refresh() } ")

Private cDirImp	 := "\DEBUG\"
Private aHead1 	 := {"","Filial","Numero","Pedido de Venda","Ped Linha 02","Cliente","Loja","Razao Social","Pendencias","Cond.Pgto","Condi็ใo","Parcelas","Emissใo","Cod.Vendedor","Nome Vendedor","Valor Bruto","Frete","Valor Liquido","Valor Original"}
Private aRegs1	 :=	{{.F.,"","","","","","","","","","","","","","",0,0,0,0}}
Private oGetD1
Private oTela01

Private aHead2 	 := {}
Private aCols2	 := {}
Private oGetD2

Private aHead3 	 := {}
Private aCols3	 := {}
Private oGetD3

Private oOk	 	:= LoadBitMap(GetResources(), "LBOK")
Private oNo	 	:= LoadBitMap(GetResources(), "LBNO")

Private aAux 	:= {}
Private aBkp 	:= {}

Private cString	:= ""
Private nSubTot	:= 0
Private nVlrCanc:= 0
Private nVlrTot	:= 0
Private nVlrCred:= 0

Private nVlrConf:= 0
Private oVlrConf 

Private cARQLOG	:= cDirImp+"SYVM107_"+cEmpAnt+"_"+cFilAnt+".LOG"

MakeDir(cDirImp) // Cria diretorio de DEBUG caso nao exista

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

CarregaSUA()

If Empty(cString)
	MsgStop("Nใo existem pedidos para o fechamento do caixa.","Aten็ใo")
	Return
Endif

CarregaSL4()
CarregaVdas()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCarrega os creditos de todos os clientes                               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cAlias := GetNextAlias()
cQuery := " SELECT SUM(E1_SALDO) E1_SALDO FROM "+RetSqlName("SE1")+" SE1 (NOLOCK) WHERE E1_FILIAL = '"+Mv_Par01+"' AND E1_EMISSAO >= '"+Dtos(Mv_Par02)+"' AND E1_EMISSAO <= '"+Dtos(Mv_Par03)+"' AND E1_STATUS = 'A' AND E1_TIPO = 'NCC' AND E1_SALDO > 0 AND D_E_L_E_T_ <> '*'  "
cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

(cAlias)->(DbGotop())
While (cAlias)->(!Eof())
	nVlrCred += (cAlias)->E1_SALDO
	(cAlias)->(DbsKIP())
End
(cAlias)->( dbCloseArea() )

DEFINE FONT oFonteMemo 	NAME "Arial" SIZE 0,-15 BOLD

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Faz o calculo automatico de dimensoes de objetos     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aSize := MsAdvSize()

aObjects := {}
AAdd( aObjects, { 100, 100, .T., .F. } )
AAdd( aObjects, { 070, 100, .F., .T. } )
AAdd( aObjects, { 100, 015, .T., .F. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )
aPosObj[1][3] := 230

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta Dialogo.		                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DEFINE MSDIALOG oDlg TITLE "Fechamento do Caixa - "+Dtoc(Mv_Par02) FROM 0,0 TO aSize[6],aSize[5] OF oMainWnd PIXEL

//??????????????????????????????????????????????????????????????????????????????????????????????????????????
//? Dados do Folder 1 (Cabecalho do Pedido).		        												?
//???????????????????????????????????????????????????????????????????????????????????????????????????????????
oPanelCabec		  := TPanel():New(0, 0, '', oDlg, NIL, .T., .F., NIL, NIL, 0,0, .T., .F. )
oPanelCabec:Align := CONTROL_ALIGN_TOP

oFWLayerItens:= FwLayer():New()
oFWLayerItens:Init(oDlg,.T.)

oFWLayerItens:addLine("PEDIDOS", 35, .F.)         
oFWLayerItens:addCollumn( "COL1",100,.F.,"PEDIDOS")
oFWLayerItens:addWindow ( "COL1","WIN1","Pedidos",100,.T.,.F.,,"PEDIDOS")

oPanel1:= oFWLayerItens:GetWinPanel("COL1","WIN1","PEDIDOS")

oGetD1				:= TwBrowse():New(0,0,0,0,,aHead1,,oPanel1,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oGetD1:Align        := CONTROL_ALIGN_ALLCLIENT
oGetD1:lColDrag		:= .T.
oGetD1:SetArray(aRegs1)
oGetD1:bLine		:= { || {	IIF(aRegs1[oGetD1:nAt,1],oOk,oNo),;
									aRegs1[oGetD1:nAt,2],;
									aRegs1[oGetD1:nAt,3],;
									aRegs1[oGetD1:nAt,4],;
									aRegs1[oGetD1:nAt,5],;
									aRegs1[oGetD1:nAt,6],;
									aRegs1[oGetD1:nAt,7],;
									aRegs1[oGetD1:nAt,8],;
									aRegs1[oGetD1:nAt,9],;
									aRegs1[oGetD1:nAt,10],;
									aRegs1[oGetD1:nAt,11],;
									aRegs1[oGetD1:nAt,12],;
									aRegs1[oGetD1:nAt,13],;
									aRegs1[oGetD1:nAt,14],;
									aRegs1[oGetD1:nAt,15],;
									Transform(aRegs1[oGetD1:nAt,16],PesqPict('SUA','UA_VALBRUT')),;
									Transform(aRegs1[oGetD1:nAt,17],PesqPict('SUA','UA_FRETE')),;
									Transform(aRegs1[oGetD1:nAt,18],PesqPict('SUA','UA_VLRLIQ')),;
									Transform(aRegs1[oGetD1:nAt,19],PesqPict('SUA','UA_VLRLIQ'))}}


oGetD1:bLDblClick 	:= { || If(Alltrim(UPPER(aRegs1[oGetD1:nAt,9]))$"PEDIDO NORMAL|EM AGUARDAR",aRegs1[oGetD1:nAt,1]:= !aRegs1[oGetD1:nAt,1],aRegs1[oGetD1:nAt,1]:=.F.) , A107VLD1(aRegs1,@oVlrConf) , oGetD1:Refresh()}
//oGetD1:bLDblClick 	:= { || aRegs1[oGetD1:nAt,1]:= !aRegs1[oGetD1:nAt,1],oGetD1:Refresh()}
oGetD1:bHeaderClick	:= { || AEval(aRegs1,{|x| x[1]:= !x[1]}), oGetD1:Refresh()}
oGetD1:bChange		:= { || MudaPedido(@aCols2,oGetD1:AARRAY[oGetD1:NAT][3]),oGetD1:Refresh() }


oFWLayerItens:addLine("CONSULTA", 35, .F.)
oFwLayerItens:addCollumn( "COL1", 50, .F. , "CONSULTA")
oFwLayerItens:addCollumn( "COL2", 50, .F. , "CONSULTA")

oFwLayerItens:addWindow(  "COL1", "WIN1", "Formas de Pagamentos"	, 100, .T., .F., , "CONSULTA")
oFwLayerItens:addWindow(  "COL2", "WIN2", "Fechamento do Dia"		, 100, .T., .T., , "CONSULTA")

oPanel2:= oFWLayerItens:GetWinPanel("COL1","WIN1","CONSULTA")

oGetD2:=MsNewGetDados():New(0,0,0,0,0,"Allwaystrue","AllWaysTrue","",,,Len(aCols2),,,,oPanel2,@aHead2,@aCols2)
oGetD2:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFaco backup para trabalhar com a propriedade BChangeณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aBkp := aClone(oGetD2:aCols)

oPanel3:= oFWLayerItens:GetWinPanel("COL2","WIN2","CONSULTA")

oGetD3:=MsNewGetDados():New(0,0,0,0,0,"Allwaystrue","AllWaysTrue","",,,Len(aCols3),,,,oPanel3,@aHead3,@aCols3)
oGetD3:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

oFWLayerItens:addLine("TOTAL", 15, .F.)
oFwLayerItens:addCollumn( "COL1", 100, .F. , "TOTAL")
oFwLayerItens:addWindow(  "COL1", "WIN1", ""	, 100, .T., .F., , "TOTAL")

oPanel4:= oFWLayerItens:GetWinPanel("COL1","WIN1","TOTAL")

@ 005,010 SAY "Valor Bruto"	OF oPanel4 PIXEL SIZE 038,010
@ 004,040 MSGET nVlrTot 	PICTURE PesqPict('SUA','UA_VLRLIQ') WHEN .F. OF oPanel4 FONT oFont1 PIXEL SIZE 070,010 HASBUTTON

nVlrCanc := (nVlrTot - nSubTot)
@ 005,130 SAY "Desconto/Cancelado" OF oPanel4 PIXEL SIZE 060,010
@ 004,190 MSGET nVlrCanc 	PICTURE PesqPict('SUA','UA_VLRLIQ') WHEN .F. OF oPanel4 FONT oFont1 PIXEL SIZE 070,010 HASBUTTON
                   
@ 005,280 SAY "Vlr. Creditos" 	OF oPanel4 PIXEL SIZE 038,010
@ 004,320 MSGET nVlrCred 	PICTURE PesqPict('SUA','UA_VLRLIQ') WHEN .F. OF oPanel4 FONT oFont1 PIXEL SIZE 070,010 HASBUTTON

If Mv_Par04==2
	nVlrConf := nSubTot	
Endif
nSubTot -= nVlrCred

@ 005,420 SAY "Valor Liquido" 	OF oPanel4 PIXEL SIZE 038,010
@ 004,460 MSGET nSubTot 	PICTURE PesqPict('SUA','UA_VLRLIQ') WHEN .F. OF oPanel4 FONT oFont1 PIXEL SIZE 070,010 HASBUTTON

@ 005,550 SAY "Valor Conferido"	OF oPanel4 PIXEL SIZE 038,010
@ 004,590 MSGET oVlrConf VAR nVlrConf PICTURE PesqPict('SUA','UA_VLRLIQ') WHEN .F. OF oPanel4 FONT oFont1 PIXEL SIZE 070,010 HASBUTTON

ACTIVATE MSDIALOG oDlg CENTERED ON INIT ( EnchoiceBar(oDlg,{|| nOpc := 1 , oDlg:End()  }, {||  nOpc := 0 , oDlg:End() },,aButtons) )

If nOpc==1

	If MsgYesNO("Confirma o fechamento do Caixa ?","Aten็ใo")
		
		Begin Transaction 
	
		FwMsgRun( ,{|| A107Grava(aRegs1,MV_PAR01) }, , "Por favor aguarde, conferindo os pedidos..." )
		
		End Transaction 
	
	Endif
	
Endif 
*/

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

Static Function CarregaSUA()

Local cQuery := ""
Local cAlias := GetNextAlias()

aRegs1 := {}

cQuery += " SELECT FILIAL, NUMERO, PEDIDO1, PEDIDO2, CODCLI, LOJACLI, NOMECLI, PENDENCIA, CONDPGTO, DESCPAGTO, PARCELA, CODVEN, NOMEVEN, EMISSAO, "+ CRLF
cQuery += " VALBRUT, FRETE, SUM((VALBRUT-DESCONTO)+FRETE) VLRLIQ, VLRORIG FROM ( "+ CRLF
cQuery += " SELECT UB_FILIAL FILIAL, UB_NUM NUMERO, UA_NUMSC5 PEDIDO1, UA_PEDLIN2 PEDIDO2, UA_CLIENTE CODCLI, UA_LOJA LOJACLI, A1_NOME NOMECLI, "+ CRLF
cQuery += " UA_PEDPEND PENDENCIA, UA_CONDPG CONDPGTO, E4_DESCRI DESCPAGTO, UA_PARCELA PARCELA, UA_VEND CODVEN, A3_NOME NOMEVEN, UA_EMISSAO EMISSAO, "+ CRLF
cQuery += " UA_VALBRUT VALBRUT, UA_FRETE FRETE, 0 VLRLIQ, UA_DESCONT DESCONTO, UA_VLRLIQ VLRORIG "+ CRLF
cQuery += " FROM "+RetSqlName("SUB")+" SUB (NOLOCK) "+ CRLF
cQuery += " INNER JOIN "+RetSqlName("SUA")+" SUA (NOLOCK) ON UA_FILIAL = '"+xFilial("SUA")+"' AND UA_NUM=UB_NUM AND SUA.D_E_L_E_T_ = ' ' "+ CRLF
cQuery += " INNER JOIN "+RetSqlName("SA1")+" SA1 (NOLOCK) ON A1_FILIAL = '"+xFilial("SA1")+"' AND A1_COD=UA_CLIENTE AND A1_LOJA=UA_LOJA AND SA1.D_E_L_E_T_ = ' ' "+ CRLF
cQuery += " INNER JOIN "+RetSqlName("SE4")+" SE4 (NOLOCK) ON E4_FILIAL = '"+xFilial("SE4")+"' AND E4_CODIGO=UA_CONDPG AND SE4.D_E_L_E_T_ = ' ' "+ CRLF
cQuery += " INNER JOIN "+RetSqlName("SA3")+" SA3 (NOLOCK) ON A3_FILIAL = '"+xFilial("SA3")+"' AND A3_COD=UA_VEND AND SA3.D_E_L_E_T_ = ' ' "+ CRLF
cQuery += " WHERE 
cQuery += " 	UA_FILIAL = '"+Mv_Par01+"' "+ CRLF
cQuery += " AND	UB_FILIAL = '"+Mv_Par01+"' "+ CRLF
cQuery += " AND UA_FILIAL=UB_FILIAL "+ CRLF
cQuery += " AND UA_OPER = '1' "+ CRLF
cQuery += " AND UA_PEDPEND <> '2' "+ CRLF
cQuery += " AND UA_CANC = ' ' "+ CRLF
If Mv_Par04==1 //Normal
	cQuery += " AND (UA_PEDPEND = '"+If(Mv_Par04==1,"4","3")+"' OR UA_PEDPEND = '1') "+ CRLF
ElseIF Mv_Par04==2 //Conferido
	cQuery += " AND (UA_PEDPEND = '"+If(Mv_Par04==1,"4","3")+"' OR UA_PEDPEND = '5')"+ CRLF
Endif
cQuery += " AND UA_EMISSAO >= '"+Dtos(Mv_Par02)+"' "+ CRLF 
cQuery += " AND UA_EMISSAO <= '"+Dtos(Mv_Par03)+"' "+ CRLF
cQuery += " AND (UA_NUMSC5 <> '' OR UA_PEDLIN2 <> '') "+ CRLF
cQuery += " AND UB_01CANC = ' ' "+ CRLF
cQuery += " AND SUB.D_E_L_E_T_ = ' ' "+ CRLF
cQuery += " GROUP BY UB_FILIAL,UB_NUM,UA_NUMSC5,UA_PEDLIN2,UA_CLIENTE,UA_LOJA,A1_NOME,UA_PEDPEND,UA_CONDPG,E4_DESCRI,UA_PARCELA,UA_VEND,A3_NOME,UA_EMISSAO,UA_VALBRUT,UA_FRETE,UA_DESCONT,UA_VLRLIQ "+ CRLF
cQuery += " ) AS TABELA "+ CRLF
cQuery += " GROUP BY FILIAL, NUMERO, PEDIDO1, PEDIDO2, CODCLI, LOJACLI, NOMECLI, PENDENCIA, CONDPGTO, DESCPAGTO, PARCELA, CODVEN, NOMEVEN, EMISSAO, VALBRUT, FRETE, DESCONTO, VLRORIG  "+ CRLF
cQuery += " ORDER BY FILIAL, NUMERO, PEDIDO1, PEDIDO2, CODCLI, LOJACLI, NOMECLI, PENDENCIA, CONDPGTO, DESCPAGTO, PARCELA, CODVEN, NOMEVEN, EMISSAO, FRETE "+ CRLF

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Salva query em disco para debug. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If GetNewPar("SY_DEBUG",.T.)
	MakeDir(cDirImp)
	MemoWrite(cDirImp+"SYVM107.SQL", cQuery)
EndIf

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

TcSetField(cAlias, "EMISSAO", "D", TamSx3("UA_EMISSAO")[1], TamSx3("UA_EMISSAO")[2])

(cAlias)->(DbGotop())
While (cAlias)->(!Eof())

	cString += "'"+(cAlias)->NUMERO+"',"

	AAdd( aRegs1 , {	.F. , 	(cAlias)->FILIAL,(cAlias)->NUMERO,(cAlias)->PEDIDO1,(cAlias)->PEDIDO2,(cAlias)->CODCLI,(cAlias)->LOJACLI,(cAlias)->NOMECLI,;
								If((cAlias)->PENDENCIA=="1","Em Aguardar",If((cAlias)->PENDENCIA=="2","Pendencia Financeira",If((cAlias)->PENDENCIA=="3","Pedido Conferido",If((cAlias)->PENDENCIA=="4","Pedido Normal","Em Aguardar Conferido")))),;
								(cAlias)->CONDPGTO,(cAlias)->DESCPAGTO,(cAlias)->PARCELA,(cAlias)->EMISSAO,;
								(cAlias)->CODVEN,(cAlias)->NOMEVEN,(cAlias)->VALBRUT,(cAlias)->FRETE,(cAlias)->VLRLIQ,(cAlias)->VLRORIG } )
								
	nSubTot += (cAlias)->VLRLIQ
	
	(cAlias)->(DbsKIP())
End
(cAlias)->( dbCloseArea() )

cString := Substr(cString,1,Len(cString)-1)

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

DbSelectArea("SL4")
Aadd(aHead2,{RetTitle('L4_NUM')		,'NUM' 		, PesqPict('SL4','L4_NUM')		,TamSx3('L4_NUM')[1]		,X3Decimal('L4_NUM' )		,'','','C','','',''})
Aadd(aHead2,{RetTitle('L4_DATA')	,'DATA' 	, PesqPict('SL4','L4_DATA')		,TamSx3('L4_DATA')[1]		,X3Decimal('L4_DATA' )		,'','','D','','',''})
Aadd(aHead2,{RetTitle('L4_FORMA')	,'FORMA' 	, PesqPict('SL4','L4_FORMA')	,TamSx3('L4_FORMA')[1]		,X3Decimal('L4_FORMA' )		,'','','C','','',''})
Aadd(aHead2,{RetTitle('L4_VALOR')	,'VALOR'	, PesqPict('SL4','L4_VALOR')	,TamSx3('L4_VALOR')[1]		,X3Decimal('L4_VALOR')		,'','','N','','',''})
Aadd(aHead2,{RetTitle('L4_XFORFAT')	,'XFORFAT'	, "@!"							,15							,X3Decimal('L4_XFORFAT')	,'','','C','','',''})
Aadd(aHead2,{''						,'VAZIO'	, "@!"							,0							,0							,'','','C','','',''})

aCols2 := {}

cQuery += " SELECT L4_NUM,L4_DATA,L4_FORMA,L4_VALOR,L4_XFORFAT "
cQuery += " FROM "+RetSqlName("SL4")+" SL4 "
cQuery += " WHERE
cQuery += " L4_FILIAL = '"+Mv_Par01+"' " 
cQuery += " AND L4_NUM IN ("+cString+") "
cQuery += " AND L4_ORIGEM = 'SIGATMK' "
cQuery += " AND SL4.D_E_L_E_T_= '' "
cQuery += " ORDER BY L4_XFORFAT,L4_FORMA "

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

TcSetField(cAlias, "L4_DATA", "D", TamSx3("L4_DATA")[1], TamSx3("L4_DATA")[2])

(cAlias)->(DbGotop())
While (cAlias)->(!Eof())
	AAdd( aCols2 , { (cAlias)->L4_NUM, (cAlias)->L4_DATA, (cAlias)->L4_FORMA, (cAlias)->L4_VALOR, "NORMAL" , "" , .F. } )	
	(cAlias)->(DbsKIP())
End
(cAlias)->( dbCloseArea() )

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

Local cQuery := ""
Local cAlias := GetNextAlias()

DbSelectArea("SL4")
Aadd(aHead3,{RetTitle('L4_FORMA')	,'FORMA' 	, PesqPict('SL4','L4_FORMA')	,TamSx3('L4_FORMA')[1]	,X3Decimal('L4_FORMA' )	,'','','C','','',''})
Aadd(aHead3,{'Valor'				,'VALOR'	, PesqPict('SL4','L4_VALOR')	,TamSx3('L4_VALOR')[1]	,X3Decimal('L4_VALOR')	,'','','N','','',''})
Aadd(aHead3,{''						,'VAZIO'	, "@!"							,0						,0						,'','','C','','',''})

aCols3 := {}

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
	
	(cAlias)->(DbsKIP())
End
(cAlias)->( dbCloseArea() ) 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ CARREGA TODOS OS RA'S LANCADOS NO PERIODO - LUIZ EDUARDO .F.C. - 26.07.20017 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQuery := ""
cQuery += " SELECT E1_TIPO, SUM(E1_VALOR) VALOR FROM " + RETSQLNAME("SE1")
cQuery += " WHERE E1_FILIAL = '" + XFILIAL("SE1") + "' " 
cQuery += " AND D_E_L_E_T_ = ' ' " 
cQuery += " AND E1_TIPO = 'RA' "
cQuery += " AND E1_MSFIL = '" + MV_PAR01 + "' "
cQuery += " AND E1_EMISSAO BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' " 
cQuery += " AND E1_STATUS = 'A' "  
cQuery += " AND E1_SALDO > 0 "
cQuery += " GROUP BY E1_TIPO "

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

(cAlias)->(DbGotop())
While (cAlias)->(!Eof())

	AAdd( aCols3 , { (cAlias)->E1_TIPO,(cAlias)->VALOR , "" , .F. } )
	
	nVlrTot += (cAlias)->VALOR
	
	(cAlias)->(DbsKIP())
End

(cAlias)->( dbCloseArea() ) 
                

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMudaPedido  บAutorณ Eduardo Patriani   บ Data ณ  06/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCarrega os produtos pela propriedade BChange.               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function MudaPedido(aCols1,cPedido) 

Local nI, nX, nY

//Crio novo array
aAux := {}
For nX := 1 To Len(aBkp)
	If aBkp[nX,1]==cPedido
		AAdd(aAux , aClone(aBkp[nX]) )
	Endif
Next nX

If Len(aBkp) > 0
	oGetD2:aCols := aAux
	oGetD2:oBrowse:Refresh()
	oGetD2:Refresh()
Endif

Return

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

/*Local aHlpPor01 := {"Informe a Filial de Fechamento","",""}
Local aHlpPor02 := {"Informe a Data Inicial do Fechamento","",""}
Local aHlpPor03 := {"Informe a Data Final do Fechamento","",""}
Local aHlpPor04 := {"Informe o Tipo de Pedido: Pedido Normal ; Pedido Conferido ; Todos","",""}

PutSx1(cPerg,"01","Filial"		,"Filial"		,"Filial"		,"MV_CH1","C",TamSx3("UA_FILIAL")[1] 	,0,0,"G","","SM0","","","mv_par01","","","","","","","","","","","",""," ","","","",aHlpPor01)
PutSx1(cPerg,"02","Data de "	,"Data de "		,"Data de "		,"MV_CH2","D",TamSx3("UA_EMISSAO")[1]	,0,0,"G","","","","","mv_par02","","","","","","","","","","","",""," ","","","",aHlpPor02)
PutSx1(cPerg,"03","Data ate "	,"Data ate "	,"Data ate "	,"MV_CH3","D",TamSx3("UA_EMISSAO")[1]	,0,0,"G","","","","","mv_par03","","","","","","","","","","","",""," ","","","",aHlpPor03)
PutSx1(cPerg,"04","Tipo Pedido" ,"Tipo Pedido" 	,"Tipo Pedido"  ,"MV_CH4","N",1							,0,2,"C","","","","","mv_par04","Pedido nใo Conferido","Pedido nใo Conferido","Pedido nใo Conferido",,"Pedido Conferido","Pedido Conferido","Pedido Conferido",,"Ambos","Ambos","Ambos",,,,,,aHlpPor04)*/

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


Return .T.

Static Function A107Grava(aRegs1,MV_PAR01)

Local nI 		:= 0
Local cLocDep 	:= GetMv("MV_SYLOCDP",,"100001")
Local cAlias 	:= GetNextAlias()
Local nOpcao 	:= ""

For nI := 1 To Len(aRegs1)

	If Alltrim(UPPER(aRegs1[nI,9]))=="PEDIDO NORMAL"
		nOpcao := "3"
	ElseIf Alltrim(UPPER(aRegs1[nI,9]))=="EM AGUARDAR"
		nOpcao := "5"		
	Endif
		
	If aRegs1[nI,1] //.And. Alltrim(UPPER(aRegs1[nI,9]))=="PEDIDO NORMAL"
				
		SUA->( DbSetOrder(1) )
		If SUA->( DbSeek( aRegs1[nI,2]+aRegs1[nI,3] ) )
			Reclock("SUA",.F.)
			SUA->UA_PEDPEND := nOpcao
			Msunlock()
		Endif
				
		SC5->(DbSetOrder(1))
		If SC5->(DbSeek(xFilial("SC5")+aRegs1[nI,4]))
			Reclock("SC5",.F.)
			SC5->C5_PEDPEND := nOpcao 
			SC5->C5_XCONPED := "1" // MARCA O PEDIDO COMO CONFERIDO - LUIZ EDUARDO F.C. - 01.02.2018
			Msunlock()
		
			SC6->(DbSetOrder(1))
			If SC6->(DbSeek(xFilial("SC6")+aRegs1[nI,4]))
				While SC6->(!Eof()) .And. SC6->C6_FILIAL+SC6->C6_NUM==xFilial("SC6")+aRegs1[nI,4]
					Reclock("SC6",.F.)
					SC6->C6_PEDPEND := nOpcao
					Msunlock()
					SC6->(DbSkip())
				End				
			Endif			
		Endif
		
		If !Empty(aRegs1[nI,5])
			SC5->(DbSetOrder(1))
			If SC5->(DbSeek(xFilial("SC5")+aRegs1[nI,5]))
				Reclock("SC5",.F.)
				SC5->C5_PEDPEND := nOpcao
				Msunlock()
				
				SC6->(DbSetOrder(1))
				If SC6->(DbSeek(xFilial("SC6")+aRegs1[nI,5]))
					While SC6->(!Eof()) .And. SC6->C6_FILIAL+SC6->C6_NUM==xFilial("SC6")+aRegs1[nI,5]
						Reclock("SC6",.F.)
						SC6->C6_PEDPEND := nOpcao
						Msunlock()
						SC6->(DbSkip())
					End				
				Endif			
			Endif
		Endif
		
		cQuery := ""				
		cQuery := "SELECT R_E_C_N_O_ RECSE1 FROM "+RetSqlName("SE1")+" SE1 (NOLOCK) WHERE E1_PREFIXO = 'PED' AND E1_NUM = '"+aRegs1[nI,4]+"' AND E1_CLIENTE = '"+aRegs1[nI,6]+"' AND E1_LOJA = '"+aRegs1[nI,7]+"' AND E1_NUMSUA = '"+aRegs1[nI,3]+"' AND D_E_L_E_T_ = ' ' "
		
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
								
	Endif
		
Next

U_SYVM104(.F.,MV_PAR02,MV_PAR03,MV_PAR01)

Return

Static Function A107VLD1(aRegs1)

Local nX	 := 0
Local nValor := 0

For nX := 1 To Len(aRegs1)		

	If aRegs1[nX,1]
		nValor += aRegs1[nX,18]
	Endif
		
Next
nVlrConf:=nValor
oVlrConf:Refresh()

Return