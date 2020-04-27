User Function F070BTOK()

Local lRet:=.T.
Local xSe1Num:=SE1->E1_NUM
Local xSe1Pre:=SE1->E1_PREFIXO
Local xSe1Parc:=SE1->E1_PARCELA
Local xSe1Tipo:=SE1->E1_TIPO
Local cQuery:=""
Local xSe2Pref:="TXA"
Local _cAlias 	:= GetNextAlias()
Local xSe1Data:=dBaixa
Local nOpc
Local aTitBx:={}
Private lMsErroAuto := .F.
Private xBanco:="C01"
Private xAgencia:="00001"
Private xConta:="0000000001"

//Solicitada através do Ticket - 8137
//por favor, precisa que esteja a baixa do titulo de contas a pagar automática na mesmo momento da baixa do titulo na contas receber.
//exemplo: um titulo na contas a receber for baixado, será baixado também na contas a pagar.
cQuery := " SELECT E2_FILIAL, E2_PREFIXO, E2_NUM, E2_TIPO, E2_PARCELA, E2_VALOR, E2_FORNECE, E2_LOJA FROM "+RetSqlName("SE2")+" SE2	"
cQuery += " WHERE SE2.E2_MSFIL = '"+Alltrim(cFilAnt)+"'
cQuery += " AND SE2.E2_TIPO = '"+xSe1Tipo+"'"
cQuery += " AND SE2.E2_NUM = '"+xSe1Num+"'"
cQuery += " AND SE2.E2_PARCELA = '"+xSe1Parc+"'"
cQuery += " AND SE2.E2_PREFIXO = '"+xSe2Pref+"'"
cQuery += " AND SE2.D_E_L_E_T_= ''

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),_cAlias,.T.,.T.)

If !Empty((_cAlias)->E2_TIPO)
	nOpc:=3
	//Faz a chamada da rotina de baixa das Taxas
	If nOpc == 3
		DbSelectArea("SE2")
		DbSetOrder(1)
		//E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA, R_E_C_N_O_, D_E_L_E_T_
		DbSeek(xFilial("SE2")+xSe2Pref+xSe1Num+xSe1Parc+xSe1Tipo)
		
		Aadd(aTitBx, {"E2_FILIAL",     (_cAlias)->E2_FILIAL,    	NIL})
		Aadd(aTitBx, {"E2_PREFIXO",    (_cAlias)->E2_PREFIXO,    	NIL})
		Aadd(aTitBx, {"E2_NUM",        (_cAlias)->E2_NUM,        	NIL})
		Aadd(aTitBx, {"E2_PARCELA",    (_cAlias)->E2_PARCELA,    	NIL})
		Aadd(aTitBx, {"E2_TIPO",       (_cAlias)->E2_TIPO,       	NIL})
		Aadd(aTitBx, {"E2_FORNECE",    (_cAlias)->E2_FORNECE,    	NIL})	
		Aadd(aTitBx, {"E2_LOJA",       (_cAlias)->E2_LOJA,       	NIL})
		Aadd(aTitBx, {"AUTMOTBX",      "NOR",  						NIL})
		Aadd(aTitBx, {"AUTBANCO"       , xBanco, 					NIL})
		Aadd(aTitBx, {"AUTAGENCIA"     , xAgencia, 					NIL})
		Aadd(aTitBx, {"AUTCONTA"       , xConta, 					NIL})
		Aadd(aTitBx, {"AUTDTBAIXA",    xSe1Data,          			NIL})
		Aadd(aTitBx, {"AUTDTCREDITO",  xSe1Data,          			NIL})
		Aadd(aTitBx, {"AUTHIST",       "Baixa Automatica - TAXA",   NIL})
	EndIf
	
	Begin Transaction
	
	MsExecAuto({|x, y| FINA080(x, y)}, aTitBx, nOpc)
	
	IF lMsErroAuto
		MostraErro()
		DisarmTransaction()
		lRet:=.F.
	Endif
	End Transaction
Endif


Return lRet