#Include "Protheus.ch"
#Include "Topconn.ch"
USER FUNCTION FA040B01()

Local cQuery 	:= ""
Local cPref		:= SE1->E1_PREFIXO	//#RVC20181227.n
Local cNum		:= SE1->E1_NUM		//#RVC20181227.n
Local cPar		:= SE1->E1_PARCELA	//#RVC20181227.n
Local cTipo		:= SE1->E1_TIPO		//#RVC20181227.n
Local _cAliRC	:= GetNextAlias()	//#RVC20181227.n
Local lRet   	:= .T.
Local aDados 	:= {}				//#RVC20181227.n
Local aDados2	:= {}				//#RVC20181227.n
Local cUserMv	:= SuperGetMV("KH_USRDLFI",.F.,"000721|000954|000019|000685") //Parametro responsável pelos usuários que não tem permissão de exclusão de títulos
Local xAssunto:="Exclusâo de Títulos contas a Receberr"
Local  xMail:="marcio.nunes@komforthouse.com.br;vanito.rocha@hotmail.com;mohammed.sinno@komforthouse.com.br"
Local xMsg:={"O título de Prefixo:  "  + cPref  +  "  Numero:   " +  cNum + "   Valor:   R$  " + Str(E1_VALOR,16,2) + "  foi excluido por  " + cUserName }


Private lMsErroAuto := .F.

//Usuários que não tem permissão de exclusão de títulos - Marcio Nunes 7942 06022019

If (__cUserID $ cUserMv) .And.  !IsInCallStack("U_KMFINA03")  //valida a pilha para permitir a exclusão via rotina @altera forma de pagamento
	MsgAlert("Usuário sem premissão para exclusão, entre em contato com o Coordenador Financeiro.","Atencao")
	Return .F.
EndIf

IF ALLTRIM(E1_TIPO) == "RA"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ VERIFICA SE EXISTE ALGUM TITULO ATRELADO A ESTE RA QUE JA TEVE BAIXA (TOTAL OU PARCIAL) - LUIZ EDUARDO F.C. - 20.12.2017 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := " SELECT * FROM " + RETSQLNAME("SE1")
	cQuery += " WHERE E1_CLIENTE = '" + E1_CLIENTE + "' "
	cQuery += " AND E1_LOJA = '" + E1_LOJA + "' "
	cQuery += " AND E1_NUM = '" + E1_NUM + "' "
	cQuery += " AND E1_TIPO <> '" + E1_TIPO + "' "
	cQuery += " AND E1_PREFIXO = '" + E1_PREFIXO + "' "
	//		cQuery += " AND E1_SALDO = 0 "			//#RVC20181227.o
	//		cQuery += " AND E1_BAIXA <> ' ' "		//#RVC20181227.o
	//		cQuery += " AND E1_MOVIMEN <> ' ' "		//#RVC20181227.o
	cQuery += " AND D_E_L_E_T_ = ' ' "
	
	If Select(_cAliRC) > 0
		(_cAliRC)->(DbCloseArea())
	EndIf
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),_cAliRC,.T.,.T.)
	
	// SE ENCONTRAR ALGUM TITULO ABORTA A EXCLUSAO
	(_cAliRC)->(DbGoTop())
	While (_cAliRC)->(!EOF())
		//#RVC20181227.bn
		if (_cAliRC)->E1_SALDO <> (_cAliRC)->E1_VALOR .OR. !EMPTY((_cAliRC)->E1_BAIXA) // .OR. !EMPTY((_cAliRC)->E1_MOVIMEN) #WRP20190109 .n
			lRet := .F.
		endIf
		//#RVC20181227.en
		
		(_cAliRC)->(DbSkip())
	EndDo
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ SE TODOS OS TITULOS ESTIVEREM EM ABERTO ,FAZ A EXCLUSAO DOS TITULOS NO SE1 - LUIZ EDUARDO F.C. - 20.12.2017 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF lRet
		//#RVC20181227.bn
		SE1->( DbSetOrder(1) )
		IF SE1->( DbSeek( xFilial("SE1") + cPref  + cNum + cPar + cTipo ) )
			RecLock("SE1",.F.,.T.)
			SE1->(DbDelete())
			MsUnLock()
		EndIF
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ EXCLUI OS TITULOS DE TAXAS CRIADOS NO CONTAS A PAGAR - LUIZ EDUARDO F.C. - 20.12.2017 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cQuery := " UPDATE " + RETSQLNAME("SE2") + " SET D_E_L_E_T_ = '*'"
		cQuery += " WHERE E2_FILIAL = '" + xFilial("SE2") + "'
		cQuery += " AND D_E_L_E_T_ = ' ' "
		cQuery += " AND E2_NUM = '" + E1_NUM + "'
		cQuery += " AND E2_PREFIXO = '" + E1_PREFIXO+ "'
		TcSqlExec(cQuery)
		
		MsgAlert("Título Excluido com Sucesso!!!")
		//#RVC20181227.eo
		
		(_cAliRC)->(DbGoTop())
		While (_cAliRC)->(!EOF())
			lMsErroAuto := .F.
			aDados  := {	{"E1_FILIAL"    ,(_cAliRC)->E1_FILIAL     ,Nil},;
			{"E1_PREFIXO"	,(_cAliRC)->E1_PREFIXO	,Nil},;
			{"E1_NUM"		,(_cAliRC)->E1_NUM		,Nil},;
			{"E1_PARCELA"	,(_cAliRC)->E1_PARCELA	,Nil},;
			{"E1_TIPO"		,(_cAliRC)->E1_TIPO		,Nil} }
			MsgRun("Excluindo Titulo(s) a Receber. Parc.:" + (_cAliRC)->E1_PARCELA + "/" + Strzero((_cAliRC)->E1_01QPARC,2) +".","Aguarde", {|| MSExecAuto({|x,y| Fina040(x,y)},aDados,5) })
			
			If lMsErroAuto
				mostraErro()
				lRet := .F.
			endIf
			(_cAliRC)->(DbSkip())
		EndDo
	Else
		MsgInfo("Um ou mais títulos atrelados a este RA possuem movimentação. Por favor, efetua a reabertura do mesmo para prosseguir com a exclusão!")
		RETURN(lRet)
	EndIF
	//#RVC20181226.bn
ElseIf ALLTRIM(E1_TIPO) $"CC|CD"
	dbSelectArea("SE2")
	SE2->(dbSetOrder(1))
	SE2->(dbGoTop())
	if SE2->(dbSeek(xFilial("SE2") + "TXA" + SE1->E1_NUM + SE1->E1_PARCELA + SE1->E1_TIPO))
		
		lMsErroAuto := .F.
		aDados2  := {	{"E2_FILIAL"    ,xFilial("SE2")	,Nil},;
		{"E2_PREFIXO"	,"TXA"			,Nil},;
		{"E2_NUM"		,SE1->E1_NUM	,Nil},;
		{"E2_PARCELA"	,SE1->E1_PARCELA,Nil},;
		{"E2_TIPO"		,SE1->E1_TIPO	,Nil}}
		MsgRun("Excluindo Titulo a Pagar","Aguarde", {|| MsExecAuto({|x,y,z| FINA050(x,y,z)}, aDados2,,5)})
		
		if lMsErroAuto
			mostraErro()
			lRet := .F.
		endIf
	Endif
else
	lRet := .T.
	//#RVC20181226.en
EndIF

//#RVC20181227.bn
If Select(_cAliRC) > 0
	(_cAliRC)->(DbCloseArea())
EndIf
//#RVC20181227.en


//Alteracao solicitada através do ticket 7559
If lRet
	If nModulo=6
		If FunName() == "'FINA050" .OR. FunName() == "'FINA040"
			u_MailNotify(xMail,"",xAssunto,xMsg,{},.T.)
		Endif
	Endif
Endif

RETURN(lRet)
