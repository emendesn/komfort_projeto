#Include "Protheus.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SYTM001  ºAutor  ³ SYMM CONSULTORIA   º Data ³  02/09/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Consulta de recebimentos antecipados.                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SYTM001()

Local nX,nY,nPos
Local aPosObj   	:= {}
Local aObjects  	:= {}
Local aSize     	:= {}
Local aInfo     	:= {}
Local aCposAlt		:= {}
Local aCposVis		:= {}
Local bColor	 	:= &("{|| a105CorBrw(@aCorGrd,1) }")
Local cAlias    	:= GetNextAlias()
Local nTotal		:= 0
Local nValor		:= 0
Local cRotina		:= Alltrim(FunName())
Local cCliente		:= ""
Local cLoja			:= ""
Local cCPF			:= ""
Local cNome			:= ""
Local oPanel1
Local oPanel2
Local oLayer

Local aCorGrd := {	;
{ Rgb(240,255,255)	, Nil , 'Azure'				} ,;
{ Rgb(230,230,250) 	, Nil , 'Lavander'			} ,;
{ Rgb(0,255,255) 	, Nil , 'Cyan'				} ,;
{ Rgb(193,255,193) 	, Nil , 'Lavander'			} ,;
{ Rgb(202,225,255)	, Nil , 'DarkSeaGreen1'		} ,;
{ Rgb(192,255,62) 	, Nil , 'OliveDrab1'		} ,;
{ Rgb(255,255,240)	, Nil , 'Ivory1'			} ,;
{ Rgb(255,239,213)	, Nil , 'PapayaWhip' 		} ,;
{ Rgb(255,250,205)	, Nil , 'LemonChiffon' 		} ,;
{ Rgb(240,255,240)	, Nil , 'Honeydew' 			} ,;
{ Rgb(127,255,212)	, Nil , 'Aquamarine1'		} ,;
{ Rgb(245,255,250)	, Nil , 'MintCream' 		} ,;
{ Rgb(255,240,245)	, Nil , 'LavenderBlush' 	} ,;
{ Rgb(255,225,255)	, Nil , 'Thistle1' 			} ,;
{ Rgb(255,250,250)	, Nil , 'Snow' 				} }

Private aHeader1 	:= {}
Private aCols1		:= {}
Private o001Get, oDlg

//If cRotina == "TMKA271"	//#RVC20180803.o
If IsInCallStack('TMKA271')	//#RVC20180803.n
	cCliente := M->UA_CLIENTE
	cLoja	 := M->UA_LOJA
Endif

If Empty(cCliente)
	If !SYPERGUNTA(@cCliente,@cLoja,@cCPF)
		Return(.T.)
	Endif
	
	If !Empty(cCPF)
		SA1->(DbSetOrder(3))
		If SA1->(DbSeek(xFilial("SA1")+cCPF))
			cCliente := SA1->A1_COD
			cLoja	 := SA1->A1_LOJA
		Endif
	Endif
	
Endif
cNome := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_NOME")

DEFINE FONT oFonteMemo 	NAME "Arial" SIZE 0,-15 BOLD

Aadd(aHeader1,{RetTitle('E1_TIPO')		,'TIPO' 		, PesqPict('SE1','E1_TIPO')		,TamSx3('E1_TIPO')[1]		,X3Decimal('E1_TIPO' )		,'','','C','','',''})
Aadd(aHeader1,{RetTitle('E1_NUM')		,'NUMERO' 		, PesqPict('SE1','E1_NUM')		,TamSx3('E1_NUM')[1]		,X3Decimal('E1_NUM' )		,'','','C','','',''})
Aadd(aHeader1,{RetTitle('E1_PREFIXO')	,'PREFIXO' 		, PesqPict('SE1','E1_PREFIXO')	,TamSx3('E1_PREFIXO')[1]	,X3Decimal('E1_PREFIXO' )	,'','','C','','',''})
Aadd(aHeader1,{RetTitle('E1_PARCELA')	,'PARCELA' 		, PesqPict('SE1','E1_PARCELA')	,TamSx3('E1_PARCELA')[1]	,X3Decimal('E1_PARCELA' )	,'','','C','','',''})
Aadd(aHeader1,{RetTitle('E1_EMISSAO')	,'EMISSAO' 		, PesqPict('SE1','E1_EMISSAO')	,TamSx3('E1_EMISSAO')[1]	,X3Decimal('E1_EMISSAO' )	,'','','D','','',''})
Aadd(aHeader1,{RetTitle('E1_VENCREA')	,'VENCREA' 		, PesqPict('SE1','E1_VENCREA')	,TamSx3('E1_VENCREA')[1]	,X3Decimal('E1_VENCREA' )	,'','','D','','',''})
Aadd(aHeader1,{RetTitle('E1_VALOR')		,'VALOR' 		, PesqPict('SE1','E1_VALOR')	,TamSx3('E1_VALOR')[1]		,X3Decimal('E1_VALOR' )		,'','','N','','',''})
Aadd(aHeader1,{RetTitle('E1_FORMREC')	,'FORMREC' 		, PesqPict('SE1','E1_FORMREC')	,TamSx3('E1_FORMREC')[1]	,X3Decimal('E1_FORMREC' )	,'','','C','','',''})
Aadd(aHeader1,{'Loja Origen'			,'LOJAORI' 		, "@!"							,20							,0							,'','','C','','',''})
Aadd(aHeader1,{RetTitle('E1_USRNAME')	,'USRNAME' 		, PesqPict('SE1','E1_USRNAME')	,TamSx3('E1_USRNAME')[1]	,X3Decimal('E1_USRNAME' )	,'','','C','','',''})

cQuery := " SELECT	E1_TIPO TIPO, "
cQuery += " 		E1_NUM	NUMERO, "
cQuery += " 		E1_PREFIXO PREFIXO, "
cQuery += " 		E1_PARCELA PARCELA, "
cQuery += " 		E1_EMISSAO EMISSAO, "
cQuery += " 		E1_VENCREA VENCIMENTO, "
cQuery += " 		E1_SALDO VALOR, "
cQuery += " 		E1_FORMREC FORMA, "
cQuery += " 		RIGHT(E1_PREFIXO,2) LOJA, "
cQuery += " 		E1_USRNAME OPERADOR "
cQuery += " FROM "+RetSqlName("SE1")+" SE1 (NOLOCK) "
cQuery += " INNER JOIN "+RetSqlName("SA1")+" SA1 (NOLOCK) ON A1_COD=E1_CLIENTE AND A1_LOJA=E1_LOJA AND SA1.D_E_L_E_T_ <> '*' "
cQuery += " WHERE "
If !Empty(cCliente)
	cQuery += " 	E1_CLIENTE = '"+cCliente+"' AND E1_LOJA = '"+cLoja+"' "
Else
	cQuery += " 	A1_CGC = '"+cCPF+"' "
Endif
cQuery += " AND E1_STATUS = 'A' "
cQuery += " AND E1_TIPO IN ('NCC','RA') "
cQuery += " AND E1_SALDO > 0 "
cQuery += " AND SE1.D_E_L_E_T_ <> '*'  "
cQuery += " ORDER BY E1_PREFIXO,E1_NUM,E1_TIPO,E1_PARCELA "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

(cAlias)->(DbGotop())
While (cAlias)->(!Eof())
	
	Aadd(aCols1,Array(Len(aHeader1)+1))
	nPos := Len(aCols1)
	
	aCols1[nPos,01] := (cAlias)->TIPO
	aCols1[nPos,02] := (cAlias)->NUMERO
	aCols1[nPos,03] := (cAlias)->PREFIXO
	aCols1[nPos,04] := (cAlias)->PARCELA
	aCols1[nPos,05] := STOD((cAlias)->EMISSAO)
	aCols1[nPos,06] := STOD((cAlias)->VENCIMENTO)
	aCols1[nPos,07] := (cAlias)->VALOR
	aCols1[nPos,08] := (cAlias)->FORMA
	aCols1[nPos,09] := POSICIONE("SM0",1,cEmpAnt+(cAlias)->LOJA,"M0_FILIAL")
	aCols1[nPos,10] := (cAlias)->OPERADOR
	aCols1[nPos,Len(aHeader1)+1] := .F.
	
	nTotal++
	nValor+=(cAlias)->VALOR
	
	(cAlias)->(DbsKIP())
End
(cAlias)->( dbCloseArea() )

If Len(aCols1)==0
	Aadd(aCols1,Array(Len(aHeader1)+1))
	nPos := Len(aCols1)
	
	aCols1[nPos,1] := CriaVar('E1_TIPO' ,.F.)
	aCols1[nPos,2] := CriaVar('E1_NUM',.F.)
	aCols1[nPos,3] := CriaVar('E1_PREFIXO',.F.)
	aCols1[nPos,4] := CriaVar('E1_PARCELA',.F.)
	aCols1[nPos,5] := CriaVar('E1_EMISSAO',.F.)
	aCols1[nPos,6] := CriaVar('E1_VENCREA',.F.)
	aCols1[nPos,7] := CriaVar('E1_VALOR',.F.)
	aCols1[nPos,8] := CriaVar('E1_FORMREC',.F.)
	aCols1[nPos,9] := Space(20)
	aCols1[nPos,10] := CriaVar('E1_USRNAME',.F.)
	aCols1[nPos,Len(aHeader1)+1] := .F.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz o calculo automatico de dimensoes de objetos     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aSize := MsAdvSize()

aObjects := {}
AAdd( aObjects, { 100, 100, .T., .F. } )
AAdd( aObjects, { 070, 100, .F., .T. } )
AAdd( aObjects, { 100, 015, .T., .F. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )
aPosObj[1][3] := 230

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Dialogo.		                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG oDlg TITLE "Consulta Recebimentos Antecipados" FROM 0,0 TO aSize[6],aSize[5] OF oMainWnd PIXEL

oLayer:= FwLayer():New()
oLayer:Init(oDlg,.T.)
oLayer:AddLine("PEDIDO", 095, .F.)
oLayer:AddCollumn( "COL1",100, .T. , "PEDIDO")
oLayer:AddWindow ( "COL1", "WIN1", "Dados Gerais"				, 025 , .T., .F., , "PEDIDO")
oLayer:AddWindow ( "COL1", "WIN2", "Recebimentos Antecipados"	, 070 , .T., .F., , "PEDIDO")

oPanel1:= oLayer:GetWinPanel("COL1","WIN1","PEDIDO")

@ 005,010 SAY "Cliente" 	OF oPanel1 PIXEL SIZE 038,010
@ 004,045 MSGET cCliente PICTURE PesqPict('SA1','A1_COD') 	WHEN .F. OF oPanel1 PIXEL SIZE 035,010 HASBUTTON

@ 005,150 SAY "Total de Créditos" 	OF oPanel1 PIXEL SIZE 058,010
@ 004,205 MSGET nTotal  PICTURE PesqPict('SE1','E1_VALOR') 	WHEN .F. OF oPanel1 PIXEL SIZE 080,010 HASBUTTON

@ 020,010 SAY "Nome Cliente" OF oPanel1 PIXEL SIZE 038,010
@ 019,045 MSGET cNome PICTURE PesqPict('SA1','A1_NOME') 	WHEN .F. OF oPanel1 PIXEL SIZE 080,010 HASBUTTON

@ 020,150 SAY "Valor Total" OF oPanel1 PIXEL SIZE 058,010
@ 019,205 MSGET nValor  PICTURE PesqPict('SE1','E1_VALOR') WHEN .F. OF oPanel1 PIXEL SIZE 080,010 HASBUTTON

oPanel2:= oLayer:GetWinPanel("COL1","WIN2","PEDIDO")

o001Get:= MsNewGetDados():New(0,0,0,0,GD_UPDATE,"Allwaystrue","AllWaysTrue","",,,Len(aCols1),,,,oPanel2,@aHeader1,@aCols1)
o001Get:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
o001Get:oBrowse:SetBlkBackColor(bColor)
o001Get:oBrowse:bLDblClick := {|| IIF(MsgYesNo("Deseja EXCLUIR o registro de RA?..."),EXCLUIRA(),)  }

ACTIVATE MSDIALOG oDlg CENTERED ON INIT ( EnchoiceBar(oDlg,{|| oDlg:End() }, {|| oDlg:End() },,) )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³a105CorBrwºAutor  ³Microsiga           º Data ³  02/09/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao de cores na GetDados.                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function a105CorBrw(aCorGrd,nOrig)

IF nOrig == 1
	IF Empty(o001Get:aCols[o001Get:nAt,1])
		Return(Rgb(255,255,0))
	Else
		Return(Rgb(240,255,255))
	EndIF
EndIF

Return(cCor)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SYPERGUNTAºAutor  ³Microsiga           º Data ³  02/09/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria perguntas para filtrar as informaçoes                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function SYPERGUNTA(cCliente,cLoja,cCPF)

Local aBoxParam  := {}
Local aRetParam  := {}

Aadd(aBoxParam,{1,"CPF"		,CriaVar("A1_CGC",.F.)	,PesqPict("SA1","A1_CGC")	,"","","",50,.F.})
Aadd(aBoxParam,{1,"Cliente"	,CriaVar("A1_COD",.F.)	,PesqPict("SA1","A1_COD")	,"Vazio() .Or. ExistCpo('SA1')","SA1","",50,.F.})
Aadd(aBoxParam,{1,"Loja"	,CriaVar("A1_LOJA",.F.)	,PesqPict("SA1","A1_LOJA")	,"","","",50,.F.})

IF !ParamBox(aBoxParam,"Informe os Parametros",@aRetParam)
	Return(.F.)
EndIf

cCPF   	:= aRetParam[1]
cCliente:= aRetParam[2]
cLoja	:= aRetParam[3]

Return(.T.)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ EXCLUIRA ºAutor  ³ LUIZ EDUARDO F.C.  º Data ³  20.12.2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ FAZ AS TRATATIVAS PARA EXCLUSAO DO RA                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
STATIC FUNCTION EXCLUIRA()

Local cQuery := ""
Local cE2PFX := SuperGetMV("KH_PREFSE2",.F.,"TXA")	//#RVC20180808.n
Local lRet   := .F.  
Local aClone := o001Get:aCols
Local aBaixa := {}			//#RVC20180807.n
Local aExcE1 := {}			//#RVC20180807.n
Local aExcE2 := {} 			//#RVC20180807.n
Local cPara := superGetMv('KH_MAILCAN', .F., 'financeiro@komforthouse.com.br')

Private lMSErroAuto := .F.	//#RVC20180807.n

IF MsgYesNo("Deseja realmente EXCLUIR o registro de RA?...")
	//#RVC201808.03.bo	
/*	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ VERIFICA SE O TITULO DO RA FOI VERIFICDO NA ROTINA DE FECHAMENTO DE CAICA. SO DEIXA EXCLUIR SE O TITULO AINDA NAO ³
	//³ FOI CONFERIDO - LUIZ EDUARDO F.C. - 20.12.2017                                                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF(Posicione("SE1",1,xFilial("SE1")+o001Get:aCols[o001Get:nAt][3] + o001Get:aCols[o001Get:nAt][2] + o001Get:aCols[o001Get:nAt][4] + o001Get:aCols[o001Get:nAt][1],"E1_01VALCX") ) == "2"
		lRet := .T.
	Else
		MsgInfo("Este RA já foi conferido na rotina de fechamento de caixa. Não é mais possivel excluir o mesmo, por favor entrar em contato com o Dpto.Financeiro!") 
		RETURN()
	EndIF
*/	//#RVC201808.03.eo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ VERIFICA SE O USUÁRIO LOGADO É SUPERVISOR DE LOJA. CASO CONTRÁRIO, O SISTEMA NÃO PERMITIRÁ REALIZAR O CANCELAMENTO - #RVC20180810 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If GetAdvFVal("SU7","U7_TIPO",xFilial("SU7") + __cUserID,4,"1") <> "2" 
		msgstop("Apenas o SUPERVISOR está autorizado a excluir.","Exclusão não permitida")
		Return()	
	EndIF
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ VERIFICA SE A DATA DE EMISSAO É A MESMA DA DATA DO DIA. CASO CONTRARIO, NÃO SERÁ POSSÍVEL REALIZAR O CANCELAMENTO - #RVC20180807 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If o001Get:aCols[o001Get:nAt][5] <> dDatabase
		msgstop("Título com emissão inferior a data de hoje.","Exclusão não permitida")
		Return()																					//prf num parc tipo
	EndIf
	
	If GetAdvFVal("SE1","E1_SALDO",xFilial("SE1") + o001Get:aCols[o001Get:nAt][3] + o001Get:aCols[o001Get:nAt][2] + o001Get:aCols[o001Get:nAt][4] + o001Get:aCols[o001Get:nAt][1],1,0) <> o001Get:aCols[o001Get:nAt][7]  
		msgstop("RA já utilizado em Pedido.", "Exclusão não permitida")
		Return()
	Else
		lRet := .T.
	EndIF
	
	IF lRet  
		
		Begin Transaction
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ VERIFICA SE EXISTE ALGUM TITULO ATRELADO A ESTE RA QUE JA TEVE BAIXA (TOTAL OU PARCIAL) - LUIZ EDUARDO F.C. - 20.12.2017 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//		cQuery := " SELECT * FROM " + RETSQLNAME("SE1")					//#RVC20181204.o
		cQuery := " SELECT * FROM " + RETSQLNAME("SE1") + "(NOLOCK)"	//#RVC20181204.n
		cQuery += " WHERE E1_CLIENTE = '" + SA1->A1_COD + "' "
		cQuery += " AND E1_LOJA = '" + SA1->A1_LOJA + "' "
		cQuery += " AND E1_NUM = '" + o001Get:aCols[o001Get:nAt][2] + "' "
		cQuery += " AND E1_TIPO <> '" + o001Get:aCols[o001Get:nAt][1] + "' "
		cQuery += " AND E1_PREFIXO = '" + o001Get:aCols[o001Get:nAt][3] + "' "
		cQuery += " AND E1_SALDO = 0 "		
		cQuery += " AND E1_BAIXA <> ' ' "	
		cQuery += " AND E1_MOVIMEN <> ' ' "	
		cQuery += " AND D_E_L_E_T_ = ' ' "		
		
		If Select("TRB") > 0
			TRB->(DbCloseArea())
		EndIf
		
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.) 
				
		TRB->(DbGoTop()) 
		While TRB->(!EOF())
		
			Aadd(aBaixa,{"E1_FILIAL" 	,TRB->E1_FILIAL					, Nil})	
			Aadd(aBaixa,{"E1_PREFIXO" 	,TRB->E1_PREFIXO				, Nil})	
			Aadd(aBaixa,{"E1_NUM"     	,TRB->E1_NUM					, Nil})	
			Aadd(aBaixa,{"E1_PARCELA" 	,TRB->E1_PARCELA				, Nil})	
			Aadd(aBaixa,{"E1_TIPO"    	,TRB->E1_TIPO					, Nil})	
			Aadd(aBaixa,{"E1_MOEDA"    	,TRB->E1_MOEDA					, Nil})	
			Aadd(aBaixa,{"E1_TXMOEDA"	,TRB->E1_TXMOEDA				, Nil})	
			Aadd(aBaixa,{"E1_CLIENTE"	,TRB->E1_CLIENTE				, Nil})	
			Aadd(aBaixa,{"E1_LOJA"		,TRB->E1_LOJA					, Nil})	
			Aadd(aBaixa,{"E1_SALDO"		,TRB->E1_VALOR					, Nil})	
					
			MsgRun("Cancelando a(s) baixa(s)...","Aguarde", {|| MSExecAuto({|x,y|FINA070(x,y)},aBaixa,5)})
			
			If lMSErroAuto
				msgAlert("Não foi possivel realizar o cancelamento da baixa do titulo "+ TRB->E1_NUM,"ATENÇÃO")
				MostraErro()
				lRet := .F.
				DisarmTransaction()
			Endif
			
			aBaixa := {}
			
			TRB->(DbSkip())
		EndDo
			
		If Select("TRB") > 0
			TRB->(DbCloseArea())
			cQuery := ""	//#RVC20180808.n
		EndIf		
				
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ SE TODOS OS TITULOS ESTIVEREM EM ABERTO ,FAZ A EXCLUSAO DOS TITULOS NO SE1 - LUIZ EDUARDO F.C. - 20.12.2017 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF lRet           		
			//#RVC20180807.bo
/*			cQuery := " UPDATE " + RETSQLNAME("SE1") + " SET D_E_L_E_T_ = '*' " 
			cQuery += " WHERE E1_CLIENTE = '" + SA1->A1_COD + "' "
			cQuery += " AND E1_LOJA = '" + SA1->A1_LOJA + "' "
			cQuery += " AND E1_NUM = '" + o001Get:aCols[o001Get:nAt][2] + "' "
			cQuery += " AND E1_PREFIXO = '" + o001Get:aCols[o001Get:nAt][3] + "' "
			cQuery += " AND D_E_L_E_T_ = ' ' " 
			
			TcSqlExec(cQuery)*/	 
			//#RVC20180807.eo
			
			//#RVC20180807.bn
//			cQuery := " SELECT * FROM " + RETSQLNAME("SE1")				//#RVC20181204.o
			cQuery := " SELECT * FROM " + RETSQLNAME("SE1") + "(NOLOCK)"//#RVC20181204.n
			cQuery += " WHERE E1_CLIENTE = '" + SA1->A1_COD + "' "
			cQuery += " AND E1_LOJA = '" + SA1->A1_LOJA + "' "
			cQuery += " AND E1_NUM = '" + o001Get:aCols[o001Get:nAt][2] + "' "
			cQuery += " AND E1_TIPO <> '" + o001Get:aCols[o001Get:nAt][1] + "' "
			cQuery += " AND E1_PREFIXO = '" + o001Get:aCols[o001Get:nAt][3] + "' "
			cQuery += " AND D_E_L_E_T_ = ' ' "		
			
			If Select("TRB") > 0
				TRB->(DbCloseArea())
			EndIf
			
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.) 
				
			TRB->(DbGoTop()) 		
			While TRB->(!EOF())
				
				AADD(aExcE1, {"E1_FILIAL"		,TRB->E1_FILIAL		,NIL})
				AADD(aExcE1, {"E1_PREFIXO"		,TRB->E1_PREFIXO	,NIL})
				AADD(aExcE1, {"E1_NUM"			,TRB->E1_NUM		,NIL})
				AADD(aExcE1, {"E1_PARCELA"		,TRB->E1_PARCELA	,NIL})
				AADD(aExcE1, {"E1_TIPO"			,TRB->E1_TIPO		,NIL})
				AADD(aExcE1, {"E1_CLIENTE"		,TRB->E1_CLIENTE	,NIL})
				AADD(aExcE1, {"E1_LOJA"			,TRB->E1_LOJA		,NIL})
             
				MsgRun("Excluindo Título(s) à Receber...","Aguarde", {|| MSExecAuto({|x,y| Fina040(x,y)},aExcE1,5)})	 
			
				If lMSErroAuto
					msgAlert("Não foi possivel realizar a exclusão do titulo "+ TRB->E1_NUM,"ATENÇÃO")
					MostraErro()
					lRet := .F.
					DisarmTransaction()
				Endif
				
				If lRet
					If Alltrim(TRB->E1_TIPO) $ "CC|CD" .AND. SE2->(dbSeek(xFilial("SE2") + cE2PFX + TRB->E1_NUM + TRB->E1_PARCELA + TRB->E1_TIPO))
						lMsErroAuto := .F.
						aExcE2 := {{"E2_FILIAL"    ,TRB->E1_FILIAL	,Nil},;
								   {"E2_PREFIXO"	,cE2PFX			,Nil},;
								   {"E2_NUM"		,TRB->E1_NUM	,Nil},;
								   {"E2_PARCELA"	,TRB->E1_PARCELA,Nil},;
								   {"E2_TIPO"		,TRB->E1_TIPO	,Nil} }
						
						MsgRun("Excluindo Taxa(s)","Aguarde", {|| MsExecAuto({|x,y,z| FINA050(x,y,z)}, aExcE2,,5)})	   
							
						If lMsErroAuto
							msgAlert("Não foi possivel realizar a exclusão do titulo "+ TRB->E1_NUM,"ATENÇÃO")
							mostraErro()
							lRet := .F.
							disarmTransaction()
						EndIf
					EndIf
				EndIf
				
				aExcE1 := {}
				aExcE2 := {}
				
				TRB->(DbSkip())
             EndDo
             
             If lRet
             
				AADD(aExcE1, {"E1_FILIAL"		,xFilial("SE1")					,NIL})
				AADD(aExcE1, {"E1_PREFIXO"		,o001Get:aCols[o001Get:nAt][3]	,NIL})
				AADD(aExcE1, {"E1_NUM"			,o001Get:aCols[o001Get:nAt][2] 	,NIL})
				AADD(aExcE1, {"E1_PARCELA"		,o001Get:aCols[o001Get:nAt][4]	,NIL})
				AADD(aExcE1, {"E1_TIPO"			,o001Get:aCols[o001Get:nAt][1]	,NIL})
				AADD(aExcE1, {"E1_CLIENTE"		,SA1->A1_COD					,NIL})
				AADD(aExcE1, {"E1_LOJA"			,SA1->A1_LOJA					,NIL})
             
				MsgRun("Excluindo RA","Aguarde", {|| MSExecAuto({|x,y| Fina040(x,y)},aExcE1,5) })
				
				If lMSErroAuto
					msgAlert("Não foi possivel realizar a exclusão do RA.","ATENÇÃO")
					MostraErro()
					lRet := .F.
					DisarmTransaction()
				Else
					
					cAssunto := "Exclusão de RA's"
					cMensagem := "Realizada exclusão do RA ("+ o001Get:aCols[o001Get:nAt][2] +") - Prefixo ("+ o001Get:aCols[o001Get:nAt][3] +")," + CRLF
					cMensagem += "Cliente ("+ SA1->A1_COD +") - Loja ("+ SA1->A1_LOJA +")."

					processa( {|| U_sendMail( cPara, cAssunto, cMensagem ) }, "Aguarde...", "Enviando email de Exclusão...", .F.)
									
				Endif
				
				aExcE1 := {}
						
             EndIf
             //#RVC20180807.en
             
            //#RVC20180807.bo
/*			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ EXCLUI OS TITULOS DE TAXAS CRIADOS NO CONTAS A PAGAR - LUIZ EDUARDO F.C. - 20.12.2017 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cQuery := " UPDATE " + RETSQLNAME("SE2") + " SET D_E_L_E_T_ = '*'"
			cQuery += " WHERE E2_FILIAL = '" + xFilial("SE2") + "' 
			cQuery += " AND D_E_L_E_T_ = ' ' " 
			cQuery += " AND E2_NUM = '" + o001Get:aCols[o001Get:nAt][2] + "'
			cQuery += " AND E2_PREFIXO = '" + o001Get:aCols[o001Get:nAt][3] + "' 
			TcSqlExec(cQuery)			
*/			//#RVC20180807.eo
 
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ ATUALIZA O ACOLS QUE MONTA O BROWSE - LUIZ EDUARDO F.C. - 20.12.2017 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            o001Get:aCols := {}      
			For nX:=1 To Len(aClone)
				IF o001Get:nAt <> nX
				 	aAdd( o001Get:aCols , aClone[nX])
				EndIF			
			Next
			o001Get:obrowse:refresh()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ SE SO EXISTIR UM RA E O MESMO FOR EXCLUIDO, FECHA A TELA DE CONSULTA - LUIZ EDUARDO F.C. - 29.12.2017 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			if Len(o001Get:acols) < 1 //#AFD20180619.N
			//IF Len(o001Get:obrowse) = 0 //#AFD20180619.O
				//o001Get:obrowse:End() //#AFD20180619.O
				oDlg:End()//#AFD20180619.N
			EndIF
						
   		Else
//			MsgInfo("Um ou mais títulos referente a este RA já possui movimentação Financeira. Não é possível excluir estes títulos. Por favor, entre em contato com o Dpto.Financeiro!")
			MsgAlert("Título(s) referente a este RA tem bloqueio(s). Não é possível excluir este RA. Por favor, entre em contato com o Dpto.Financeiro!")
			RETURN()
		EndIF
		
	End Transaction
		
	EndIF
EndIF

RETURN()
