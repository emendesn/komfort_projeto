#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³KMFINR04  ºAutor  ³Microsiga           º Data ³  12/20/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressao do boleto grafico santander.                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function KMFINR04(_cPed,_aTitulos)

Local _cBolSant	 := AllTrim(GetMV("KH_BOLSANT",,""))
Local aTitulos	:= {}
Local nLastKey	:= 0
Local cTamanho	:= "M"
Local cDesc1	:= "Este programa tem como objetivo efetuar a impressão do"
Local cDesc2	:= "Boleto de Cobrança com código de barras, conforme os"
Local cDesc3	:= "parâmetros definidos pelo usuário"
Local cString	:= "SE1"
Local _cPerg		:= "KMFINR04"
Local wnrel		:= "BOLETO_SANTANDER"
Local _nCont := 1
Private _lAuto      := .F.
Private cStatus := 1
Private lEnd	:= .F.
Private aReturn	:= {	"Banco",;					// [1]= Tipo de Formulário
1,;							// [2]= Número de Vias
"Administração",;			// [3]= Destinatário
2,;							// [4]= Formato 1=Comprimido 2=Normal
2,;							// [5]= Mídia 1=Disco 2=Impressora
1,;							// [6]= Porta LPT1, LPT2, Etc
"",;						// [7]= Expressão do Filtro
1 ;							// [8]= ordem a ser selecionada
}
Private cTitulo	:= "Boleto de Cobrança com Código de Barras"
Private cLogoSant := '\system\SANT_BOL1.bmp'
Private _cBanco := ""
Private _cAg := ""
Private _cCC := ""
Private _cLog := cUsername +" - "+ DtoC(Date()) +" - "+ Subs(Time(),1,5)
Default _aTitulos		:= {}
Default _cPed      := " "

If Empty(_cBolSant)
	
	MsgStop("Não existe banco configurado para o boleto!","NOBANCO")
	
Else
	
	For _nx := 1 To Len(_cBolSant)
		
		If _nCont == 1 .And. Subs(_cBolSant,_nx,1) <> '/'
			
			_cBanco += Subs(_cBolSant,_nx,1)
			
		ElseIf _nCont == 2 .And. Subs(_cBolSant,_nx,1) <> '/'
			
			_cAg += Subs(_cBolSant,_nx,1)
			
		ElseIf _nCont == 3 .And. Subs(_cBolSant,_nx,1) <> '/'
			
			_cCC += Subs(_cBolSant,_nx,1)
			
		Else
			
			_nCont++
			
		EndIf
		
	Next _nx
	
	//Posiciona o SA6 (Bancos)
	DbSelectArea("SA6")
	SA6->(DbSetOrder(1))//A6_FILIAL+A6_COD+A6_AGENCIA+A6_NUMCON
	SA6->(DbSeek(xFilial("SA6")+_cBanco+_cAG+" "+_cCC,.T.))
	
	_cCC     := PADR(_cCC,LEN(SA6->A6_NUMCON))
	
EndIf

If Len(_aTitulos) > 0 .And. !Empty(AllTrim(_cPed))
	
	_lAuto := .T.
	
EndIf

//Posiciona na Arq de Parametros CNAB
DbSelectArea("SEE")
SEE->(DbSetOrder(1))//EE_FILIAL+EE_CODIGO+EE_AGENCIA+EE_CONTA+EE_SUBCTA
If !(SEE->(DbSeek(xFilial("SEE")+_cBanco+_cAG+" "+_cCC,.T.)))
	
	MsgStop("Por favor cadastrar os parâmetros do banco selecionado!(SEE)","NOPAR")
	
	Return
	
EndIf

If _lAuto
	
	Wnrel := SetPrint(cString,Wnrel,,@cTitulo,cDesc1,cDesc2,cDesc3,.F.,,,cTamanho,,)
	
	If nLastKey == 27
		Set Filter to
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
		Set Filter to
		Return
	Endif
	
	// Seleciona os registros para marcação
	MsgRun( "Títulos a Receber", "Selecionando registros para processamento", { || CallRegs(@aTitulos,_cPed)} )
	// Monta tela de seleção dos registros que deverão gerar o boleto
	CallTela(@aTitulos,_cPed)
	
Else
	
	_cPerg := padr(_cPerg,len(SX1->X1_GRUPO))
	
	CriaSx1(_cPerg)
	
	If Pergunte (_cPerg,.T.)
		
		Wnrel := SetPrint(cString,Wnrel,_cPerg,@cTitulo,cDesc1,cDesc2,cDesc3,.F.,,,cTamanho,,)
		
		If nLastKey == 27
			Set Filter to
			Return
		Endif
		
		SetDefault(aReturn,cString)
		
		If nLastKey == 27
			Set Filter to
			Return
		Endif
		
		// Seleciona os registros para marcação
		MsgRun( "Títulos a Receber", "Selecionando registros para processamento", { || CallRegs(@aTitulos,_cPed)} )
		// Monta tela de seleção dos registros que deverão gerar o boleto
		CallTela(@aTitulos,_cPed)
		
	EndIf
	
EndIf

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CallRegs   ºAutor  ³Microsiga           º Data ³  12/20/11  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carrega os titulos conforme os parametros informados pelo  º±±
±±º          ³ usuario                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CallRegs(aTitulos,_cPed)

Local cQry	:= "SELECT"

If _lAuto
	
	cQry	+= " SE1.E1_PREFIXO,SE1.E1_NUM,SE1.E1_PARCELA,SE1.E1_TIPO,SE1.E1_NATUREZ,SE1.E1_CLIENTE,SE1.E1_LOJA,"
	cQry	+= " SE1.E1_NOMCLI,SE1.E1_EMISSAO,SE1.E1_VENCTO,SE1.E1_VENCREA,SE1.E1_VALOR,SE1.E1_HIST,SE1.E1_NUMBCO,"
	cQry	+= " R_E_C_N_O_ AS E1_REGSE1"
	cQry	+= " FROM "+RetSqlName("SE1")+" SE1 "
	cQry	+= " WHERE SE1.E1_FILIAL = '"+xFilial("SE1")+"'"
	cQry	+= " AND SE1.E1_PEDIDO = '"+_cPed+"' "
	cQry	+= " AND SE1.E1_SALDO > 0"
	cQry	+= " AND SE1.E1_TIPO = 'BOL' "	
	cQry	+= " AND SE1.E1_NUMBCO <> ' '"
	cQry	+= " AND SE1.E1_PORTADO = '033'"
	cQry	+= " AND SE1.E1_TIPO NOT IN('"+MVABATIM+"')"
	cQry	+= " AND SE1.D_E_L_E_T_ <> '*'"
	cQry	+= " ORDER BY SE1.E1_CLIENTE,SE1.E1_LOJA,SE1.E1_PREFIXO,SE1.E1_NUM,SE1.E1_PARCELA,SE1.E1_TIPO"
	
Else
	
	cQry	+= " SE1.E1_PREFIXO,SE1.E1_NUM,SE1.E1_PARCELA,SE1.E1_TIPO,SE1.E1_NATUREZ,SE1.E1_CLIENTE,SE1.E1_LOJA,"
	cQry	+= " SE1.E1_NOMCLI,SE1.E1_EMISSAO,SE1.E1_VENCTO,SE1.E1_VENCREA,SE1.E1_VALOR,SE1.E1_HIST,SE1.E1_NUMBCO,"
	cQry	+= " R_E_C_N_O_ AS E1_REGSE1"
	cQry	+= " FROM "+RetSqlName("SE1")+" SE1 "
	cQry	+= " WHERE SE1.E1_FILIAL = '"+xFilial("SE1")+"'"
	cQry	+= " AND SE1.E1_PREFIXO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cQry	+= " AND SE1.E1_NUM BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cQry	+= " AND SE1.E1_PARCELA BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
	cQry	+= " AND SE1.E1_TIPO = 'BOL' "
	cQry	+= " AND SE1.E1_CLIENTE BETWEEN '"+mv_par09+"' AND '"+mv_par10+"'"
	cQry	+= " AND SE1.E1_LOJA BETWEEN '"+mv_par11+"' AND '"+mv_par12+"'"
	cQry	+= " AND SE1.E1_EMISSAO BETWEEN '"+DTOS(mv_par13)+"' AND '"+DTOS(mv_par14)+"'"
	cQry	+= " AND SE1.E1_VENCTO BETWEEN '"+DTOS(mv_par15)+"' AND '"+DTOS(mv_par16)+"'"
	cQry	+= " AND SE1.E1_NATUREZ BETWEEN '"+mv_par17+"' AND '"+mv_par18+"'"
	cQry	+= " AND SE1.E1_SALDO > 0"
	
	If mv_par19 == 1
		cQry	+= " AND SE1.E1_NUMBCO <> ' '"
	Else
		cQry	+= " AND SE1.E1_NUMBCO = ' '"
	EndIf
	
	cQry	+= " AND SE1.E1_TIPO NOT IN('"+MVABATIM+"')"
	cQry	+= " AND SE1.D_E_L_E_T_ <> '*'"
	cQry	+= " ORDER BY SE1.E1_CLIENTE,SE1.E1_LOJA,SE1.E1_PREFIXO,SE1.E1_NUM,SE1.E1_PARCELA,SE1.E1_TIPO"
	
EndIf

If Select("FINR01A") > 0
	dbSelectArea("FINR01A")
	dbCloseAea()
EndIf

TCQUERY cQry NEW ALIAS "FINR01A"
TCSETFIELD("FINR01A", "E1_EMISSAO",	"D",08,0)
TCSETFIELD("FINR01A", "E1_VENCTO",	"D",08,0)
TCSETFIELD("FINR01A", "E1_VENCREA",	"D",08,0)
TCSETFIELD("FINR01A", "E1_VALOR", 	"N",14,2)
TCSETFIELD("FINR01A", "E1_REGSE1",	"N",10,0)

dbSelectArea("FINR01A")
While !Eof()
	aAdd(aTitulos, {	.F.,;						// 1=Mark
	FINR01A->E1_PREFIXO,;		// 2=Prefixo do Título
	FINR01A->E1_NUM,;			// 3=Número do Título
	FINR01A->E1_PARCELA,;		// 4=Parcela do Título
	FINR01A->E1_TIPO,;			// 5=Tipo do Título
	FINR01A->E1_NATUREZ,;		// 6=Natureza do Título
	FINR01A->E1_CLIENTE,;		// 7=Cliente do título
	FINR01A->E1_LOJA,;			// 8=Loja do Cliente
	FINR01A->E1_NOMCLI,;		// 9=Nome do Cliente
	FINR01A->E1_EMISSAO,;		//10=Data de Emissão do Título
	FINR01A->E1_VENCTO,;		//11=Data de Vencimento do Título
	FINR01A->E1_VENCREA,;		//12=Data de Vencimento Real do Título
	FINR01A->E1_VALOR,;			//13=Valor do Título
	FINR01A->E1_HIST,;			//14=Histótico do Título
	FINR01A->E1_REGSE1,;		//15=Número do registro no arquivo
	FINR01A->E1_NUMBCO ;		//16=Nosso Número
	})
	dbSkip()
EndDo

If Len(aTitulos) == 0
	aAdd(aTitulos, {.F.,"","","","","","","","","","","",0,"",0,""})
EndIf

dbSelectArea("FINR01A")
dbCloseArea()

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CallTela  ºAutor  ³Caio Garcia         º Data ³  12/20/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carrega os titulo no objeto para o usuario selecionar os   º±±
±±º          ³ que serão impressos                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CallTela(aTitulos)

Local oDlg
Local oList1
Local oMark
Local bCancel   := {|| RFINR01A(oDlg,@lRetorno,aTitulos) }
Local bOk       := {|| RFINR01B(oDlg,@lRetorno,aTitulos) }
Local aAreaAtu	:= GetArea()
Local aLabel	:= {" ","Prefixo","Número","Parcela","Tipo","Natureza","Cliente","Loja","Nome Cliente","Emissão","Vencimento","Venc.Real","Valor","Histórico","Nosso Número"}
Local aBotao    := {}
Local lRetorno	:= .T.
Local lMark		:= .F.
Local cList1

Private oOk			:= LoadBitMap(GetResources(),"LBOK")
//Private oNo			:= LoadBitMap(GetResources(),"NADA")LBNO
Private oNo			:= LoadBitMap(GetResources(),"LBNO")

AADD(aBotao, {"S4WB011N" 	, { || KMFINR04A("SE1",SE1->(aTitulos[oList1:nAt,15]),2)}, "[F12] - Visualiza Título", "Título" })
SetKey(VK_F10,	{|| KMFINR04A("SE1",SE1->(aTitulos[oLis1:nAt,15]),2)})

DEFINE MSDIALOG oDlg TITLE cTitulo From 000,000 To 420,940 OF oMainWnd PIXEL
@ 015,005 CHECKBOX oMark VAR lMark PROMPT "Marca Todos" FONT oDlg:oFont PIXEL SIZE 80,09 OF oDlg;
ON CLICK (aEval(aTitulos, {|x,y| aTitulos[y,1] := lMark}), oList1:Refresh() )
@ 030,003 LISTBOX oList1 VAR cList1 Fields HEADER ;
aLabel[1],;
aLabel[2],;
aLabel[3],;
aLabel[4],;
aLabel[5],;
aLabel[6],;
aLabel[7],;
aLabel[8],;
aLabel[9],;
aLabel[10],;
aLabel[11],;
aLabel[12],;
aLabel[13],;
aLabel[14],;
aLabel[15] ;
SIZE 463,175  NOSCROLL PIXEL
oList1:SetArray(aTitulos)
oList1:bLine	:= {|| {	If(aTitulos[oList1:nAt,1], oOk, oNo),;
aTitulos[oList1:nAt,2],;
aTitulos[oList1:nAt,3],;
aTitulos[oList1:nAt,4],;
aTitulos[oList1:nAt,5],;
aTitulos[oList1:nAt,6],;
aTitulos[oList1:nAt,7],;
aTitulos[oList1:nAt,8],;
aTitulos[oList1:nAt,9],;
aTitulos[oList1:nAt,10],;
aTitulos[oList1:nAt,11],;
aTitulos[oList1:nAt,12],;
Transform(aTitulos[oList1:nAt,13], "@E 999,999,999.99"),;
aTitulos[oList1:nAt,14],;
aTitulos[oList1:nAt,16] ;
}}

oList1:blDblClick 	:= {|| aTitulos[oList1:nAt,1] := !aTitulos[oList1:nAt,1], oList1:Refresh() }
oList1:cToolTip		:= "Duplo click para marcar/desmarcar o título"
oList1:Refresh()

@ 15,81 BMPBUTTON TYPE 01 ACTION RFINR01B(oDlg,@lRetorno,aTitulos)
@ 15,110 BMPBUTTON TYPE 2 ACTION RFINR01A(oDlg,@lRetorno,aTitulos)
ACTIVATE MSDIALOG oDlg CENTERED //ON INIT EnchoiceBar(oDlg,bOk,bcancel,,aBotao)


SetKey(VK_F12,	Nil)

Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFINR01A  ºAutor  ³Microsiga           º Data ³  12/20/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Caso não seja selecionado nenhum titulo finaliza o objeto  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RFINR01A(oDlg,lRetorno, aTitulos)

lRetorno := .F.

oDlg:End()

Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFINR01B   ºAutor  ³Microsiga           º Data ³  12/20/11  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica a quantidades de boletos que serão impressos      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RFINR01B(oDlg,lRetorno, aTitulos)


Local nLoop		:= 0
Local nContador	:= 0

lRetorno := .T.

For nLoop := 1 To Len(aTitulos)
	If aTitulos[nLoop,1]
		nContador++
	EndIf
Next

If nContador > 0
	RptStatus( {|lEnd| MontaRel(aTitulos) }, cTitulo)
	
Else
	lRetorno := .F.
EndIf

oDlg:End()

Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BOLITAU   ºAutor  ³Microsiga           º Data ³  12/20/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function KMFINR04A(cAlias, nRecAlias, nOpcEsc)

Local aAreaAtu	:= GetArea()
Local aAreaAux	:= (cAlias)->(GetArea())

If !Empty(nRecAlias)
	dbSelectArea(cAlias)
	dbSetOrder(1)
	dbGoTo(nRecAlias)
	
	AxVisual(cAlias,nRecAlias,nOpcEsc)
	
EndIf

RestArea(aAreaAux)
RestArea(aAreaAtu)

Return(Nil)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  MontaRel³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER DO SANTANDER COM CODIGO DE BARRAS     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaRel(aTitulos)

LOCAL oPrint
LOCAL nX := 0
LOCAL aDadosEmp    := {	SM0->M0_NOMECOM                                    								  ,; //[1]Nome da Empresa
SM0->M0_ENDCOB                                     						  ,; //[2]Endereço
AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
"PABX/FAX: "+SM0->M0_TEL                                                  ,; //[5]Telefones
"CNPJ: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+          	   ; //[6]
Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       ; //[6]
Subs(SM0->M0_CGC,13,2)                                                    ,; //[6]CGC
"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ; //[7]
Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                         }  //[7]I.E

LOCAL aDadosTit
LOCAL aDadosBanco := {}
LOCAL aDatSacado
LOCAL aBolText     := { "APOS O VENCIMENTO COBRAR MULTA DE R$ 35,00 "     	   ,;
                        "NÃO RECEBER APÓS 30 DIAS DO VENCIMENTO"               ,;
						"NÃO AUTORIZADO O RECEBIMENTO PARCIAL"                 ,;
						"SUJEITO A PROTESTO APÓS 7 DIAS DE ATRASO E NÃO PAGO"  ,;
						""}  

LOCAL nI		:= 1
LOCAL aCB_RN_NN	:= {}
LOCAL nVlrAbat	:= 0
Local aBCOLogo  := {}
Local cDVNrBanc
Local cNrBancario
Local cAgeNN
Local cCtaNN
Local cCarNN
Local cNumNN
Local cMsg     := "Referente Nota Fiscal Eletronica Nr: "
Local cNFEle   := ""
Local cRet     := Space(30)
Local _ny := 0
Local _cTmp := ""
Local _lAtiv := .F.
Local _cDtBol := ""

oPrint:= TMSPrinter():New( "Boleto Laser" )
oPrint:SetPortrait() 	// ou SetLandscape()
oPrint:StartPage()   	// Inicia uma nova página

For nI:=1 To Len(aTitulos)
	
	If aTitulos[nI,1]
		
		cPrefixo := aTitulos[nI,2]
		cNum     := aTitulos[nI,3]
		cParcela := aTitulos[nI,4]
		cTipo    := aTitulos[nI,5]
		cCLiente := aTitulos[nI,7]
		cLoja    := aTitulos[nI,8]
		
		//Posiciona o SA1 (Cliente)
		DbSelectArea("SA1")
		DbSetOrder(1)
		DbSeek(xFilial("SA1") + cCliente + cLoja )
		
		DbSelectArea("SE1")
		DbSetOrder(1)
		If !DbSeek(xFilial("SE1") + cPrefixo + cNum + cParcela + cTipo + cCliente + cLoja)
			Alert("O Titulo: " + cPrefixo + " " + cNum + " " + cParcela + " nao existe!")
			Loop
		Endif
		
		aDadosBanco  := {SA6->A6_COD                        					,;	// [1] Numero do Banco
		SA6->A6_NOME      	            	                  	,; 	// [2] Nome do Banco
		SUBSTR(SA6->A6_AGENCIA, 1, 4)                        	,;	// [3] Agência
		SUBSTR(SA6->A6_NUMCON, 1, 9)							    ,; 	// [4] Conta Corrente
		SA6->A6_DVCTA       	 									,; 	// [5] Dígito da conta corrente
		SA6->A6_CARTEIR 										    ,;  // [6] Codigo da Carteira
		SA6->A6_XTXMLBL											,;	// [7] Tx da Multa
		SA6->A6_XTXMOBL 										    ,;  // [8] Tx de Mora Diaria
		SA6->A6_CODCED           								}   // [9] Codigo do Cedente
		
		If Empty(SA1->A1_ENDCOB)
			aDatSacado   := {AllTrim(SA1->A1_NOME)           ,;      	// [1]Razão Social
			AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;      	// [2]Código
			AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO),;      	// [3]Endereço
			AllTrim(SA1->A1_MUN )                            ,;  		// [4]Cidade
			SA1->A1_EST                                      ,;    		// [5]Estado
			SA1->A1_CEP                                      ,;      	// [6]CEP
			SA1->A1_CGC										 ,;  		// [7]CGC
			SA1->A1_PESSOA}       										// [8]PESSOA
		Else
			aDatSacado   := {AllTrim(SA1->A1_NOME)            	,;   	// [1]Razão Social
			AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA              ,;   	// [2]Código
			AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC),;   	// [3]Endereço
			AllTrim(SA1->A1_MUNC)	                            ,;   	// [4]Cidade
			SA1->A1_ESTC	                                    ,;   	// [5]Estado
			SA1->A1_CEPC                                        ,;   	// [6]CEP
			SA1->A1_CGC											,;		// [7]CGC
			SA1->A1_PESSOA}												// [8]PESSOA
		Endif
		
		If Empty(AllTrim(SE1->E1_XUSRBOL))
			
			_cDtBol := DtoC(Date()+1)
			
		Else
			
			For _ny := 1 To Len(AllTrim(SE1->E1_XUSRBOL))
				
				If SubsTr(AllTrim(SE1->E1_XUSRBOL),_ny,1) == '-'
					
					_lAtiv := .T.
					_ny := _ny+2
					
				EndIf
				
				If _lAtiv
					
					_cDtBol := DtoC(CtoD(SubsTr(AllTrim(SE1->E1_XUSRBOL),_ny,10))+1)
					Exit
					
				EndIf
				
			Next _ny
			
		EndIf
		
		aBolText[5] := "DISPONÍVEL PARA PAGAMENTO NA REDE BANCÁRIA A PARTIR DE "+_cDtBol     
		
		If Empty (SE1->E1_NUMBCO)
			cNumNN   := Strzero(Val(Alltrim(SEE->EE_FAXATU))+1,12)
			
			RecLock( "SEE" , .F. )
			SEE->EE_FAXATU := cNumNN
			MsUnlock()
			
			//--- Para o Santander precisa gravar o Nosso Numero com o Digito (Modulo 11)
			nCalcNrBanc  := Alltrim(cNumNN)
			cDVNrBanc	:= Modulo11Nn(Alltrim(nCalcNrBanc))
			cNossoNum 	:= Alltrim(cNumNN) + Alltrim(str(cDVNrBanc))
			
			RecLock( "SE1" , .F. )
			SE1->E1_PORTADO := _cBanco
			SE1->E1_AGEDEP  := _cAG
			SE1->E1_CONTA   := _cCC
			SE1->E1_XUSRBOL := _cLog
			SE1->E1_XNUMBOL := SE1->E1_XNUMBOL+1
			If Empty(AllTrim(SE1->E1_NUMBCO))
				SE1->E1_NUMBCO 	:= cNossoNum  // Nosso número (Ver fórmula para calculo)
			EndIf
			
			MsUnlock()
		Else
			cNossoNum := Substr(SE1->E1_NUMBCO,1,12)
		EndIf
		
		cAgeNN		:= SUBSTR(SA6->A6_AGENCIA,1,4)
		cCtaNN		:= SUBSTR(SA6->A6_NUMCON,1,9)
		cCarNN		:= Alltrim(SUBSTR(SA6->A6_CARTEIR,1,3))
		cNumNN		:= SUBSTR(SE1->E1_NUMBCO,1,12)
		nCalcNrBanc := Alltrim(cNumNN)
		cDVNrBanc	:= Modulo11Nn(Alltrim(nCalcNrBanc))
		cNrBancario	:= Alltrim(cNumNN) + Alltrim(str(cDVNrBanc))
		
		nVlrAbat   :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
		
		//Monta codigo de barras
		aCB_RN_NN    := fCodBar(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],cNrBancario,(SE1->E1_VALOR-nVlrAbat),SE1->E1_VENCTO,cCarNN,aDadosBanco[9])
		
		
		aDadosTit	:= {AllTrim(SE1->E1_NUM)+AllTrim(SE1->E1_PARCELA)	,;  // [1] Número do título
		SE1->E1_EMISSAO                      			,;  // [2] Data da emissão do título
		dDataBase                    					,;  // [3] Data da emissão do boleto
		SE1->E1_VENCTO                       			,;  // [4] Data do vencimento
		(SE1->E1_SALDO - nVlrAbat)           			,;  // [5] Valor do título
		SE1->E1_NUMBCO									,;  // [6] Nosso número (Ver fórmula para calculo)
		SE1->E1_PREFIXO                      			,;  // [7] Prefixo da NF
		SE1->E1_TIPO	                        		}	// [8] Tipo do Titulo
		
		If !Empty(SE1->E1_NFELETR)
			cRet := cMsg + SE1->E1_NFELETR
		Endif
		
		Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN,cNrBancario,cRet,cDVNrBanc)
		nX := nX + 1
		
		IncProc()
		
	EndIf
	
Next nI

oPrint:EndPage()     // Finaliza a página
oPrint:Preview()     // Visualiza antes de imprimir

Return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  Impress ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASERDO SANTANDER COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßß$$ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN,cNrBancario,cRet,cDVNrBanc)
LOCAL oFont8
LOCAL oFont11c
LOCAL oFont10
LOCAL oFont13
LOCAL oFont14
LOCAL oFont16n
LOCAL oFont15
LOCAL oFont14n
LOCAL oFont24
LOCAL nI := 0

//Parametros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
oFont8   := TFont():New("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.)
oFont11c := TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10  := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont13  := TFont():New("Arial",9,13,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14  := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont20  := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
oFont21  := TFont():New("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n := TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont15  := TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont15n := TFont():New("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14n := TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont24  := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

oPrint:StartPage()   // Inicia uma nova página

/*****************/
/* SEGUNDA PARTE */
/*****************/

nRow2 := 0

oPrint:Line (nRow2+0210,100,nRow2+0210,2300)
oPrint:Line (nRow2+0210,500,nRow2+0130, 500)
oPrint:Line (nRow2+0210,710,nRow2+0130, 710)

oPrint:SayBitmap(nRow2+0115,100,cLogoSant,400,090) //300, 120      // Imprime o Logo do Banco     +0135
oPrint:Say  (nRow2+0135,518,aDadosBanco[1]+"-7",oFont20 )	// [1]Numero do Banco
oPrint:Say  (nRow2+0144,1800,"Recibo do Sacado",oFont10)

oPrint:Line (nRow2+0310,100,nRow2+0310,2300 )
oPrint:Line (nRow2+0410,100,nRow2+0410,2300 )
oPrint:Line (nRow2+0480,100,nRow2+0480,2300 )
oPrint:Line (nRow2+0550,100,nRow2+0550,2300 )

oPrint:Line (nRow2+0410,500,nRow2+0550,500)
oPrint:Line (nRow2+0480,750,nRow2+0550,750)
oPrint:Line (nRow2+0410,1000,nRow2+0550,1000)
oPrint:Line (nRow2+0410,1300,nRow2+0480,1300)
oPrint:Line (nRow2+0410,1480,nRow2+0550,1480)

oPrint:Say  (nRow2+0210,100 ,"Local de Pagamento",oFont8)
oPrint:Say  (nRow2+0225,400 ,"Pagar preferencialmente no Banco Santander",oFont10)

oPrint:Say  (nRow2+0210,1810,"Vencimento"                                     ,oFont8)
cString	:= StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol := 1810+(460-(len(cString)*22))
oPrint:Say  (nRow2+0250,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0310,100 ,"Cedente"                                        ,oFont8)
oPrint:Say  (nRow2+0350,100 ,AllTrim(aDadosEmp[1])+" - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ

oPrint:Say  (nRow2+0310,1810,"Agência/Código Cedente",oFont8)
cString := Alltrim(aDadosBanco[3]+" / "+aDadosBanco[9])
nCol  := 1810+(460-(len(cString)*22))
oPrint:Say  (nRow2+0350,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0410,100 ,"Data do Documento"                              ,oFont8)
oPrint:Say  (nRow2+0440,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont10)

oPrint:Say  (nRow2+0410,505 ,"Número do Documento"                      ,oFont8)
oPrint:Say  (nRow2+0440,605 ,aDadosTit[7]+aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow2+0410,1005,"Espécie Documento"                                   ,oFont8)
oPrint:Say  (nRow2+0440,1050,"DM"										,oFont10) //Tipo do Titulo

oPrint:Say  (nRow2+0410,1305,"Aceite"                                         ,oFont8)
oPrint:Say  (nRow2+0440,1400,"N"                                             ,oFont10)

oPrint:Say  (nRow2+0410,1485,"Data do Processamento"                          ,oFont8)
oPrint:Say  (nRow2+0440,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4),oFont10) // Data impressao

oPrint:Say  (nRow2+0410,1810,"Nosso Número"                                   ,oFont8)
cString := Alltrim(Substr(aDadosTit[6],1,12) +  ' ' + Alltrim(str(cDVNrBanc)) )
nCol := 1810+(444-(len(cString)*22))
oPrint:Say  (nRow2+0440,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0480,505 ,"Uso do Banco"                                   ,oFont8)

oPrint:Say  (nRow2+0480,100 ,"Carteira    "                                   ,oFont8)
oPrint:Say  (nRow2+0510,105 ,"RCR"                                            ,oFont10)

oPrint:Say  (nRow2+0480,755 ,"Espécie"                                        ,oFont8)
oPrint:Say  (nRow2+0510,805 ,"REAL"                                             ,oFont10)

oPrint:Say  (nRow2+0480,1005,"Quantidade"                                     ,oFont8)
oPrint:Say  (nRow2+0480,1485,"(x) Valor"                                          ,oFont8)
oPrint:Say  (nRow2+0510,1485,"0,00",oFont11c)

oPrint:Say  (nRow2+0480,1810,"(=) Valor do Documento"                          	,oFont8)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol := 1810+(460-(len(cString)*22))
oPrint:Say  (nRow2+0510,nCol,cString ,oFont11c)

oPrint:Say  (nRow2+0550,100 ,"Instruções (Termo de responsabilidade do cedente)",oFont8)
oPrint:Say  (nRow2+0600,100 ,aBolText[1]                                                                  	        ,oFont10)
oPrint:Say  (nRow2+0650,100 ,aBolText[2]                                                                        	,oFont10)
oPrint:Say  (nRow2+0690,100 ,aBolText[3]                                                                        	,oFont10)
oPrint:Say  (nRow2+0730,100 ,aBolText[4]                                                                        	,oFont10)
oPrint:Say  (nRow2+0770,100 ,aBolText[5]                                                                        	,oFont10)
oPrint:Say  (nRow2+0810,100 ,cRet																					,oFont10)

oPrint:Say  (nRow2+0550,1810,"(-)Desconto"                         ,oFont8)
oPrint:Say  (nRow2+0620,1810,"(-)Abatimento"                             ,oFont8)
oPrint:Say  (nRow2+0690,1810,"(+)Mora"                                  ,oFont8)
oPrint:Say  (nRow2+0760,1810,"(+)Outros Acréscimos"                           ,oFont8)
oPrint:Say  (nRow2+0830,1810,"(=)Valor Cobrado"                               ,oFont8)

oPrint:Say  (nRow2+0900,100 ,"Sacado"                                         ,oFont8)
oPrint:Say  (nRow2+0920,400 ,aDatSacado[1]+" ("+aDatSacado[2]+" )"            ,oFont10)
oPrint:Say  (nRow2+0957,400 ,aDatSacado[3]                                    ,oFont10)
oPrint:Say  (nRow2+0992,400 ,aDatSacado[4]+" - "+aDatSacado[5]+ " CEP: " + aDatSacado[6],oFont10) // Cidade+Estado+CEP
if aDatSacado[8] = "F"
	oPrint:Say  (nRow2+1033,400 ,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
Else
	oPrint:Say  (nRow2+1033,400 ,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
EndIf

oPrint:Say  (nRow2+1048,100 ,"Sacador/Avalista",oFont8)
oPrint:Say  (nRow2+1085,1500,"Autenticação Mecânica",oFont8)

oPrint:Line (nRow2+0210,1800,nRow2+0900,1800 )
oPrint:Line (nRow2+0620,1800,nRow2+0620,2300 )
oPrint:Line (nRow2+0690,1800,nRow2+0690,2300 )
oPrint:Line (nRow2+0760,1800,nRow2+0760,2300 )
oPrint:Line (nRow2+0830,1800,nRow2+0830,2300 )
oPrint:Line (nRow2+0900,100 ,nRow2+0900,2300 )
oPrint:Line (nRow2+1080,100 ,nRow2+1080,2300 )


/******************/
/* TERCEIRA PARTE */
/******************/

nRow3 := -30

For nI := 100 to 2300 step 50
	oPrint:Line(nRow3+1280, nI, nRow3+1280, nI+30)
Next nI

oPrint:Line (nRow3+1500,100,nRow3+1500,2300)
oPrint:Line (nRow3+1500,500,nRow3+1420, 500)
oPrint:Line (nRow3+1500,710,nRow3+1420, 710)

oPrint:SayBitmap(nRow3+1405,100,cLogoSant,400,090) //300, 120      // Imprime o Logo do Banco
oPrint:Say  (nRow3+1425,518,aDadosBanco[1]+"-7",oFont20 )	// 	[1]Numero do Banco
oPrint:Say  (nRow3+1434,755,aCB_RN_NN[2],oFont14n)			//	Linha Digitavel do Codigo de Barras

oPrint:Line (nRow3+1600,100,nRow3+1600,2300 )
oPrint:Line (nRow3+1700,100,nRow3+1700,2300 )
oPrint:Line (nRow3+1770,100,nRow3+1770,2300 )
oPrint:Line (nRow3+1840,100,nRow3+1840,2300 )

oPrint:Line (nRow3+1700,500 ,nRow3+1840,500 )
oPrint:Line (nRow3+1770,750 ,nRow3+1840,750 )
oPrint:Line (nRow3+1700,1000,nRow3+1840,1000)
oPrint:Line (nRow3+1700,1300,nRow3+1770,1300)
oPrint:Line (nRow3+1700,1480,nRow3+1840,1480)

oPrint:Say  (nRow3+1500,100 ,"Local de Pagamento",oFont8)
oPrint:Say  (nRow3+1515,400 ,"Pagar preferencialmente no Banco Santander",oFont10)

oPrint:Say  (nRow3+1500,1810,"Vencimento",oFont8)
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol	 	 := 1810+(460-(len(cString)*22))
oPrint:Say  (nRow3+1540,nCol,cString,oFont11c)

oPrint:Say  (nRow3+1600,100 ,"Cedente",oFont8)
oPrint:Say  (nRow3+1640,100 ,AllTrim(aDadosEmp[1])+" - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ

oPrint:Say  (nRow3+1600,1810,"Agência/Código Cedente",oFont8)
cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[9])
nCol 	 := 1810+(460-(len(cString)*22))
oPrint:Say  (nRow3+1640,nCol,cString ,oFont11c)

oPrint:Say  (nRow3+1700,100 ,"Data do Documento"                              ,oFont8)
oPrint:Say (nRow3+1730,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)

oPrint:Say  (nRow3+1700,505 ,"Número do Documento"                                  ,oFont8)
oPrint:Say  (nRow3+1730,605 ,aDadosTit[7]+aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow3+1700,1005,"Espécie Documento"                                   ,oFont8)
oPrint:Say  (nRow3+1730,1050,"DM"										,oFont10) //Tipo do Titulo

oPrint:Say  (nRow3+1700,1305,"Aceite"                                         ,oFont8)
oPrint:Say  (nRow3+1730,1400,"N"                                             ,oFont10)

oPrint:Say  (nRow3+1700,1485,"Data do Processamento"                          ,oFont8)
oPrint:Say  (nRow3+1730,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao

oPrint:Say  (nRow3+1700,1810,"Nosso Número"                                   ,oFont8)
cString := Alltrim(Substr(aDadosTit[6],1,12) +  ' ' + Alltrim(str(cDVNrBanc))  )
nCol:= 		1810+(444-(len(cString)*22))
oPrint:Say  (nRow3+1730,nCol,cString,oFont11c)


oPrint:Say  (nRow3+1770,505 ,"Uso do Banco"                                   ,oFont8)
oPrint:Say  (nRow3+1770,100 ,"Carteira"                                   ,oFont8)
oPrint:Say  (nRow3+1800,105 ,"RCR"                        	,oFont10)

oPrint:Say  (nRow3+1770,755 ,"Espécie"                                        ,oFont8)
oPrint:Say  (nRow3+1800,805 ,"REAL"                                             ,oFont10)

oPrint:Say  (nRow3+1770,1005,"Quantidade"                                     ,oFont8)
oPrint:Say  (nRow3+1770,1485,"(x) Valor"                                          ,oFont8)
oPrint:Say  (nRow3+1800,1485,"0,00",oFont11c)

oPrint:Say  (nRow3+1770,1810,"(=) Valor do Documento"                          	,oFont8)
cString:=   Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol:=      1810+(460-(len(cString)*22))
oPrint:Say  (nRow3+1800,nCol,cString,oFont11c)

oPrint:Say  (nRow2+1840,100 ,"Instruções (Termo de responsabilidade do cedente)",oFont8)
oPrint:Say  (nRow2+1890,100 ,aBolText[1]                                                                            ,oFont10)
oPrint:Say  (nRow2+1930,100 ,aBolText[2]                                                                        	,oFont10)
oPrint:Say  (nRow2+1970,100 ,aBolText[3]                                                                        	,oFont10)
oPrint:Say  (nRow2+2010,100 ,aBolText[4]                                                                        	,oFont10)
oPrint:Say  (nRow2+2040,100 ,aBolText[5]                                                                        	,oFont10)
oPrint:Say  (nRow2+2090,100 ,cRet																					,oFont10)

oPrint:Say  (nRow3+1840,1810,"(-)Desconto"                         ,oFont8)
oPrint:Say  (nRow3+1910,1810,"(-)Abatimento"                      ,oFont8)
oPrint:Say  (nRow3+1980,1810,"(+)Mora"                              ,oFont8)
oPrint:Say  (nRow3+2050,1810,"(+)Outros Acréscimos"         ,oFont8)
oPrint:Say  (nRow3+2120,1810,"(=)Valor Cobrado"                ,oFont8)

oPrint:Say  (nRow3+2190,100 ,"Sacado"                                         ,oFont8)
oPrint:Say  (nRow3+2207,400 ,aDatSacado[1]+" ("+aDatSacado[2]+" )"             ,oFont10)
oPrint:Say  (nRow3+2244,400 ,aDatSacado[3]                                    ,oFont10)
oPrint:Say  (nRow3+2279,400 ,aDatSacado[4]+" - "+aDatSacado[5]+ " CEP: " + aDatSacado[6]	,oFont10) // Cidade+Estado+CEP

If aDatSacado[8] = "F"
	oPrint:Say  (nRow3+2320,400,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
Else
	oPrint:Say  (nRow3+2320,400,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
EndIf
oPrint:Say  (nRow3+2335,100 ,"Sacador/Avalista"                               ,oFont8)
oPrint:Say  (nRow3+2375,1500,"Autenticação Mecânica - Ficha de Compensação"                        ,oFont8)

oPrint:Line (nRow3+1500,1800,nRow3+2190,1800 )
oPrint:Line (nRow3+1910,1800,nRow3+1910,2300 )
oPrint:Line (nRow3+1980,1800,nRow3+1980,2300 )
oPrint:Line (nRow3+2050,1800,nRow3+2050,2300 )
oPrint:Line (nRow3+2120,1800,nRow3+2120,2300 )
oPrint:Line (nRow3+2190,100 ,nRow3+2190,2300 )
oPrint:Line (nRow3+2370,100,nRow3+2370,2300  )

MSBAR("INT25",20.8,1.3,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,1.5,Nil,Nil,"A",.F.)

oPrint:EndPage() // Finaliza a página

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo10 ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO SANTANDER COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo10(cData)
LOCAL L,D,P := 0
LOCAL B     := .F.
L := Len(cData)
B := .T.
D := 0
While L > 0
	P := Val(SubStr(cData, L, 1))
	If (B)
		P := P * 2
		If P > 9
			P := P - 9
		End
	End
	D := D + P
	L := L - 1
	B := !B
End
D := 10 - (Mod(D,10))
If D = 10
	D := 0
End
Return(D)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo11 ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER DO SANTANDER COM CODIGO DE BARRAS     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo11(cData)
LOCAL L, D, P := 0
L := Len(cdata)
D := 0
P := 1
While L > 0
	P := P + 1
	D := D + (Val(SubStr(cData, L, 1)) * P)
	If P = 9
		P := 1
	End
	L := L - 1
End
D := 11 - (mod(D,11))
If (D == 0 .Or. D == 1 .Or. D == 10 .Or. D == 11)
	D := 1
End
Return(D)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo11Nn ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER DO SANTANDER COM CODIGO DE BARRAS     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo11Nn(cData)
LOCAL L, D, P,R := 0
L := Len(cdata)
D := 0
P := 1
While L > 0
	P := P + 1
	D := D + (Val(SubStr(cData, L, 1)) * P)
	If P = 9
		P := 1
	End
	L := L - 1
End

R := mod(D,11)
If (R == 10)
	D := 1
ElseIf (R == 0 .or. R == 1)
	D := 0
Else
	D := (11 - R)
End

Return(D)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³fCodBar³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO SANTANDER COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fCodBar(cBanco,cAgencia,cConta,cDacCC,cNrBancario,nValor,dVencto,cCart,cCedente)

LOCAL cValorFinal 	:= strzero(nValor*100,10)
LOCAL nDvnn			:= 0
LOCAL nDvcb			:= 0
LOCAL nDv			:= 0
LOCAL cNN			:= ''
LOCAL cRN			:= ''
LOCAL cCB			:= ''
LOCAL cS				:= ''
LOCAL cFator      := strzero(dVencto - ctod("07/10/97"),4)

//----------------------------------
//	 Definicao do CODIGO DE BARRAS
//----------------------------------
// cBanco está igual a 0339
cS:= cBanco + cFator +  cValorFinal + "9" + AllTrim(cCedente) + cNrBancario + "0" + cCart
nDvcb := modulo11(cS)
cCB   := SubStr(cS, 1, 4) + AllTrim(Str(nDvcb)) + SubStr(cS,5,39)

//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
//	AAABC.DDDDX		EEEFF.FFFFFY	GGGGG.GHJJJZ	K			UUUUVVVVVVVVVV

// 	CAMPO 1:
//	AAA	= Codigo do banco na Camara de Compensacao
//	  B = Codigo da moeda, sempre 9
//	  C = Fixo "9"
//	 DDDD = 4 Primeiras posicoes do codigo do cedente padrao Santander Banespa
//	  X = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo

cS1   := cBanco + "9" + SubStr(cCedente,1,4)
nDv1  := modulo10(cS1)
cRN1  := SubStr(cS1, 1, 5) + '.' + SubStr(cS1, 6, 4) + AllTrim(Str(nDv1)) + '   '

// 	CAMPO 2:
//	EEE  = Restante do Codigo do Cedente padrao Santander Banesp
//	FFFFFFF = Sete primeiros campos do Nosso Numero
//	     Y = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo

cS2 := SubStr(cCedente,5,3) + SubStr(cNrBancario,1,7)
nDv2:= modulo10(cS2)
cRN2:= SubStr(cS2, 1, 5) + '.' + SubStr(cS2, 6, 5) + AllTrim(Str(nDv2)) + '   '

// 	CAMPO 3:
//	GGGGGG = Restante do Nosso Numero
//	H              = 0  (Conteudo Fixo)
//	JJJ            = Carteira
//	     Z = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
cS3   := Subs(cNrBancario,8,6) + "0" + cCart
nDv3  := modulo10(cS3)
cRN3  := SubStr(cS3, 1, 5) + '.' + SubStr(cS3, 6, 5) + AllTrim(Str(nDv3)) + '   '

//	CAMPO 4:
//	     K = DAC do Codigo de Barras
cRN4  := AllTrim(Str(nDvcb)) + '  '

// 	CAMPO 5:
//	      UUUU = Fator de Vencimento
//	VVVVVVVVVV = Valor do Titulo
cRN5  := cFator + cValorFinal

cRN	  := cRN1 + cRN2 + cRN3 + cRN4 + cRN5

Return({cCB,cRN})

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa    ³ CriaSx1  ³ Verifica e cria um novo grupo de perguntas com base nos      º±±
±±º             ³          ³ parâmetros fornecidos                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Solicitante ³ 23.05.05 ³ Modelagem de Dados                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Produção    ³ 99.99.99 ³ Ignorado                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Parâmetros  ³ ExpA1 = array com o conteúdo do grupo de perguntas (SX1)                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Retorno     ³ Nil                                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Observações ³                                                                         º±±
±±º             ³                                                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Alterações  ³ 99/99/99 - Consultor - Descricao da alteração                           º±±
±±º             ³                                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CriaSx1(_cPerg)

Local aAreaAtu	:= GetArea()
Local aAreaSX1	:= SX1->(GetArea())
Local nJ		:= 0
Local nY		:= 0
Local aRegs		:= {}

// Monta array com as perguntas
aAdd(aRegs,{	_cPerg,;										// Grupo de perguntas
"01",;										// Sequencia
"Prefixo Inicial",;							// Nome da pergunta
"",;										// Nome da pergunta em espanhol
"",;										// Nome da pergunta em ingles
"mv_ch1",;									// Variável
"C",;										// Tipo do campo
03,;										// Tamanho do campo
0,;											// Decimal do campo
0,;											// Pré-selecionado quando for choice
"G",;										// Tipo de seleção (Get ou Choice)
"",;										// Validação do campo
"MV_PAR01",;								// 1a. Variável disponível no programa
"",;		  								// 1a. Definição da variável - quando choice
"",;										// 1a. Definição variável em espanhol - quando choice
"",;										// 1a. Definição variável em ingles - quando choice
"",;										// 1o. Conteúdo variável
"",;										// 2a. Variável disponível no programa
"",;										// 2a. Definição da variável
"",;										// 2a. Definição variável em espanhol
"",;										// 2a. Definição variável em ingles
"",;										// 2o. Conteúdo variável
"",;										// 3a. Variável disponível no programa
"",;										// 3a. Definição da variável
"",;										// 3a. Definição variável em espanhol
"",;										// 3a. Definição variável em ingles
"",;										// 3o. Conteúdo variável
"",;										// 4a. Variável disponível no programa
"",;										// 4a. Definição da variável
"",;										// 4a. Definição variável em espanhol
"",;										// 4a. Definição variável em ingles
"",;										// 4o. Conteúdo variável
"",;										// 5a. Variável disponível no programa
"",;										// 5a. Definição da variável
"",;										// 5a. Definição variável em espanhol
"",;										// 5a. Definição variável em ingles
"",;										// 5o. Conteúdo variável
"",;										// F3 para o campo
"",;										// Identificador do PYME
"",;										// Grupo do SXG
"",;										// Help do campo
"" })										// Picture do campo
aAdd(aRegs,{_cPerg,"02","Prefixo Final",			"","","mv_ch2","C",03,0,0,"G","","MV_PAR02","",	"",		"",		"zzz",			"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","","","" })

aTamSX3	:= TAMSX3("E1_NUM")
aAdd(aRegs,{_cPerg,"03","Numero Inicial", 		"","","mv_ch3","C",aTamSx3[1],0,0,"G","","MV_PAR03","",	"",		"",		"",				"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})
aAdd(aRegs,{_cPerg,"04","Numero Final",			"","","mv_ch4","C",aTamSx3[1],0,0,"G","","MV_PAR04","",	"",		"",		"zzzzzz",		"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})

aTamSX3	:= TAMSX3("E1_PARCELA")
aAdd(aRegs,{_cPerg,"05","Parcela Inicial",		"","","mv_ch5","C",aTamSx3[1],0,0,"G","","MV_PAR05","",	"",		"",		"",				"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})
aAdd(aRegs,{_cPerg,"06","Parcela Final",			"","","mv_ch6","C",aTamSx3[1],0,0,"G","","MV_PAR06","",	"",		"",		"z",			"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})

aAdd(aRegs,{_cPerg,"07","Tipo Inicial",			"","","mv_ch7","C",03,0,0,"G","","MV_PAR07","",	"",		"",		"",				"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})
aAdd(aRegs,{_cPerg,"08","Tipo Final",			"","","mv_ch8","C",03,0,0,"G","","MV_PAR08","",	"",		"",		"zzz",			"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})
aAdd(aRegs,{_cPerg,"09","Cliente Inicial",		"","","mv_ch9","C",06,0,0,"G","","MV_PAR09","",	"",		"",		"",				"","",		"",		"",		"","","","","","","","","","","","","","","","","SA1",	"","","",""})
aAdd(aRegs,{_cPerg,"10","Cliente Final",			"","","mv_cha","C",06,0,0,"G","","MV_PAR10","",	"",		"",		"zzzzzz",		"","",		"",		"",		"","","","","","","","","","","","","","","","","SA1",	"","","",""})
aAdd(aRegs,{_cPerg,"11","Loja Inicial",			"","","mv_chb","C",02,0,0,"G","","MV_PAR11","",	"",		"",		"",				"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})
aAdd(aRegs,{_cPerg,"12","Loja Final",			"","","mv_chc","C",02,0,0,"G","","MV_PAR12","",	"",		"",		"zz",			"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})
aAdd(aRegs,{_cPerg,"13","Emissao Inicial",		"","","mv_chd","D",08,0,0,"G","","MV_PAR13","",	"",		"",		"01/01/05",		"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})
aAdd(aRegs,{_cPerg,"14","Emissao Final",			"","","mv_che","D",08,0,0,"G","","MV_PAR14","",	"",		"",		"31/12/05",		"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})
aAdd(aRegs,{_cPerg,"15","Vencimento Inicial",	"","","mv_chf","D",08,0,0,"G","","MV_PAR15","",	"",		"",		"01/01/05",		"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})
aAdd(aRegs,{_cPerg,"16","Vencimento Final",		"","","mv_chg","D",08,0,0,"G","","MV_PAR16","",	"",		"",		"31/12/05",		"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})
aAdd(aRegs,{_cPerg,"17","Natureza Inicial",		"","","mv_chh","C",10,0,0,"G","","MV_PAR17","",	"",		"",		"",				"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})
aAdd(aRegs,{_cPerg,"18","Natureza Final",		"","","mv_chi","C",10,0,0,"G","","MV_PAR18","",	"",		"",		"zzzzzzzzzz",	"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})
aAdd(aRegs,{_cPerg,"19","Re-Impressao",			"","","mv_chn","N",01,0,0,"C","","MV_PAR19","Sim",	"Si",	"Yes",	"",				"","Nao",	"No",	"No",	"","","","","","","","","","","","","","","","","",		"","","",""})
aAdd(aRegs,{_cPerg,"20","Multa",					"","","mv_chq","N",11,2,0,"G","","MV_PAR20","",	"",		"",		"5",			"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})

dbSelectArea("SX1")
dbSetOrder(1)

For nY := 1 To Len(aRegs)
	If !MsSeek(aRegs[nY,1]+aRegs[nY,2])
		RecLock("SX1",.T.)
		For nJ := 1 To FCount()
			If nJ <= Len(aRegs[nY])
				FieldPut(nJ,aRegs[nY,nJ])
			EndIf
		Next nJ
		MsUnlock()
	EndIf
Next nY

RestArea(aAreaSX1)
RestArea(aAreaAtu)

Return(Nil)
