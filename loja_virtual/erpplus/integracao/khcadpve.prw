#include 'protheus.ch'
#include 'parmtype.ch'
#include 'TopConn.ch'
#Include 'TbiConn.ch'



/*/{Protheus.doc} KHCADPVE
//TODO Descrição auto-gerada.
@author ERPPLUS
@since 30/05/2019
@version 1.0
@return ${return}, ${return_description}
@param aPrepEnv, array, description
@type function
/*/
user function KHCADPVE()

	Local cQuery := ""
	Local aPedidos := {}
	Local aLinha   := {}
	Local aItens   := {}
	Local cPeAtu   := ""
	Local cTipoPag := ""
	Local cNumTmk  := ""
	Local cTipoCli := ""
	Local cLojaCli  := ""
	Local cCliente := ""
	Local cNaturez := ""
	Local cCodOper := ""
	Local nFormPag := ""
	Local lGravado := .F.
	Local nRecno   := 0
	Local aRecnos   := {}
	Local cNumSC5   := ""
	Local aIXBPARAM := {}
	Local nTotalPrd := 0
	Local nQtdParc  := 0
	Local cCondPag  := ""
	Local cCodSeg   := ""
	
	Private cPedGerado := ""	

	lPadrao := GetNewPar("MV_XPVPADR",.F.)

	//Chaves de acesso ao WebService
	cA1		:= ALLTRIM(GETNEWPAR("KH_A1KEYWS","D39243EF-5943-4378-A3EB-AA3D58865678"))
	cA2		:= ALLTRIM(GETNEWPAR("KH_A2KEYWS","39132A70-1622-43D5-AABD-B504DC924D26"))
		
	cQuery += "SELECT Z12.R_E_C_N_O_ RECZ12,A1_COD,A1_NOME,A1_LOJA,A1_TIPO,A1_NATUREZ,A1_COND,Z12.* " + CRLF
	cQuery += "FROM "+RetSqlName("Z12")+"  Z12" + CRLF
	cQuery += "INNER JOIN "+RetSqlName("SA1")+" SA1 ON" + CRLF
	cQuery += " 	A1_FILIAL = '"+xFilial("SA1")+"' AND A1_CGC = Z12_CGC " + CRLF
	cQuery += " 	AND SA1.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "WHERE Z12_FILIAL = '"+xFilial("Z12")+"' AND " + CRLF
	cQuery += "		Z12_CADPED = 'S' AND Z12.D_E_L_E_T_ = ' '  " + CRLF
	cQuery += "	AND Z12_PRODUT <> '0000000000CADLOJA' " + CRLF
	cQuery += " ORDER BY Z12_PEDECO,Z12.R_E_C_N_O_ "

	If Select("TPZ12") > 0
		TPZ12->(DbCloseArea() )
	Endif
	
	MemoWrite("Z12_PEDIDO_VENDA.SQL",cQuery)
	
	TcQuery cQuery New Alias "TPZ12"
	
	TPZ12->(DbGoTop())
	
	While .Not. ( TPZ12->( Eof())) 
	
		//cNumSC5 := GETSXENUM("SC5","C5_NUM")

		nValParc := TPZ12->Z12_VALPAR
		cAutoriz := TPZ12->Z12_PEDWEB
		cCCID    := TPZ12->Z12_IDCART
		cNumero  := TPZ12->Z12_NUMERC
		cValidade := TPZ12->Z12_VALIDC
		cCodSeg := TPZ12->Z12_CODSEG
		cOperaRet := TPZ12->Z12_RETOPE
		nFormPag  := TPZ12->Z12_PAGECO
		cCodOper  :=  TPZ12->Z12_CODOPE

		cNaturez := fRetNat(Val(nFormPag),TPZ12->Z12_QTDPAR)
	
		aPedidos := {}

		aAdd(aPedidos,{"C5_TIPO",'N',Nil})
		aAdd(aPedidos,{"C5_CLIENTE",TPZ12->A1_COD,Nil})
		aAdd(aPedidos,{"C5_LOJACLI",TPZ12->A1_LOJA,Nil})
		aAdd(aPedidos,{"C5_TIPOCLI",TPZ12->A1_TIPO,Nil})
		aAdd(aPedidos,{"C5_FRETE",TPZ12->Z12_FRETE,Nil})
		aAdd(aPedidos,{"C5_XCONPED","1",Nil})
		aAdd(aPedidos,{"C5_NATUREZ",cNaturez,Nil})
		aAdd(aPedidos,{"C5_XPEDWEB",TPZ12->Z12_PEDWEB,Nil})
		aAdd(aPedidos,{"C5_XCONPED","1",Nil})
		aAdd(aPedidos,{"C5_01TPOP","1", Nil})
		aAdd(aPedidos,{"C5_XORIGEM",TPZ12->Z12_ORIGEM, Nil})

		nQtdParc := Iif(ValType(TPZ12->Z12_QTDPAR) == "C",VAL(TPZ12->Z12_QTDPAR),TPZ12->Z12_QTDPAR )
		cCondPag := VLDCODPG(Val(TPZ12->Z12_PAGECO),nQtdParc)

		aAdd(aPedidos,{"C5_CONDPAG",cCondPag,Nil})

		cPeAtu := TPZ12->Z12_PEDECO
		
		if !lPadrao
			GERASC5(aPedidos)
		else
			aSize(aPedidos,len(aPedidos)+1)
			aIns(aPedidos,1)
			cPedGerado := GetSxeNum("SC5","C5_NUM")
			aPedidos[1] := {"C5_NUM", cPedGerado, Nil}
		Endif

		aRecnos := {}
		aItens  := {}
		While .Not. ( TPZ12->( Eof())) .and. cPeAtu == TPZ12->Z12_PEDECO
			
			nTotalPrd := (TPZ12->Z12_QUANT * TPZ12->Z12_VUNIT)
			
			//Busca produtos do Kit e adiociona na linha de itens
			SKUSEEK(TPZ12->Z12_CODPAI,TPZ12->Z12_QUANT,nTotalPrd,TPZ12->Z12_DESC,@aItens,lPadrao)
		
			aAdd(aRecnos,{TPZ12->RECZ12,cPedGerado,TPZ12->A1_COD,TPZ12->A1_LOJA})
			
			TPZ12->( DbSkip())
		EndDo
		
		if !lPadrao
			GERASC6(aItens,cPedGerado,xFilial("SC6"),cAutoriz)
		Else
			aRetPv := CADPEDIDO(aPedidos,aItens)

			if !aRetPv[1][1]
				U_KHLOGWS("Z12",dDataBase,Time(),"[Erro ExecAuto]- "+ aRetPv[1][3] +" - KHCADPVE","PROTHEUS")
			Else
				cPedGerado := aRetPv[1][2]
			Endif

		Endif
		
		//envio de emails para todos os pedidos gerados 
		fEmailCanc(cPedGerado,cAutoriz)
		//Grava dados do pedido na tabela Z12
		if Len(aRecnos) > 0
			For nX := 1 to Len(aRecnos)
				Z12->(DbGoTo(aRecnos[nX][1]))
				
				RecLock("Z12",.F.)
				
				Z12->Z12_PEDERP := aRecnos[nX][2] //Pedido
				Z12->Z12_CODCLI := aRecnos[nX][3] //Cliente
				Z12->Z12_LOJCLI	:= aRecnos[nX][4] //Loja
				Z12->Z12_HRINC  := Time()
				Z12->Z12_DTINC  := dDataBase
				Z12->Z12_CADPED := 'N' //CADASTRAR PEDIDO ?
				
				Z12->(MsUnlock())		

			Next nX	
		endif

		aIXBPARAM := {}
		aAdd(aIXBPARAM,cPedGerado )

		if !lPadrao
			If ExistBlock("KHPVFIM")
			cNumTmk := ExecBlock("KHPVFIM",.F.,.F.,aIXBPARAM)
			
				RecLock("SC5",.F.)
				SC5->C5_NUMTMK := cNumTmk
				SC5->(MsUnlock())
			Endif		
		Endif

		cTipo := iif(Alltrim(Z12->Z12_PAGECO) == "1","CC","BRA")//DEFINIR TIPO

		GERASE1(VAL(nFormPag),SC5->C5_CLIENTE,SC5->C5_LOJACLI,cTipo,cNaturez,cPedGerado,nQtdParc,;
				nValParc,cAutoriz,cCCID,cNumero,cValidade,cCodSeg,cOperaRet,cCodOper,cNumTmk)
	Enddo
	
return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GERASC5  ºAutor  ³Microsiga           º Data ³  18/06/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera o cabecalho do pedido de venda                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßerßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GERASC5(aCabec)

Local cNumSc5 	:= ''													// Numero do Pedido	- Inclusao
Local nNumPar 	:= ""//SuperGetMv("MV_NUMPARC")								// Numero de parcelas utilizada no sistema
Local nUA_CONTRA // := SUA->(FieldPos("UA_CONTRA"))							// Verifica se o campo CONTRATO para integracao com o SIGACRD esta criado  na base de dados
Local lTipo9	:= .F.													// Indica se a venda foi tipo 9
Local aPedido	:= {}													// Array com o numero do pedido para emissao da NF - MV_OPFAT = S
Local nValComi	:= 0 													// Valor da Comissao para o SC5
Local nI		:= 0
Local cOBS1		:= ""//U_SyLeSYP(SUA->UA_CODOBS,TamSx3("UA_OBS")[1])
Local cTPFRETE  := "" // IRA ARMAZENAR O TIPO DE FRETE DO CADASTRO DE CLIENTES - LUIZ EDUARDO F.C. - 18.08.2017
Local aParcelas := {}
Local cFilAtu := xFilial("SC5")
Local nPosCli	:= 0
Local nPosLoja  := 0
Local nPosCPag  := 0
Local nPosPvWeb := 0
Local nPosOp    := 0


nPosOp    :=  aScan(aCabec,{|x| AllTrim(x[1]) == "C5_01TPOP" })
nPosPvWeb :=  aScan(aCabec,{|x| AllTrim(x[1]) == "C5_XPEDWEB" })
nPosCli  := aScan(aCabec,{|x| AllTrim(x[1]) == "C5_CLIENTE" })
nPosLoja := aScan(aCabec,{|x| AllTrim(x[1]) == "C5_LOJACLI" })
nPosCPag := aScan(aCabec,{|x| AllTrim(x[1]) == "C5_CONDPAG" })

DbSelectArea("SA1")
DbSetOrder(1)
If DbSeek(xFilial("SA1") + aCabec[nPosCli][2] + aCabec[nPosLoja][2] )
	nValComi:= SA1->A1_COMIS
EndIf

// Verifica se a condicao de pagamento e do tipo 9
DbSelectArea("SE4")
DbSetOrder(1)
	//Se ‚ um NOVO PEDIDO gero os registros no SC5
	DbSelectArea("SC5")
	DbSetOrder(1)
	
	cNumSC5 := GetSxeNum("SC5","C5_NUM")
	
	cMay := "SC5"+ALLTRIM(cFilAtu)+cNumSC5
	While (DbSeek(cFilAtu+cNumSC5) .OR. !MayIUseCode(cMay))
		cNumSC5 := Soma1(cNumSC5,Len(cNumSC5))
		cMay 	:= "SC5"+ALLTRIM(cFilAtu)+cNumSC5
	End
	//If __lSX8
	ConfirmSX8()
	//EndIf
	
	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))
	
	//lNovo := !SC5->(DbSeek(xFilial("SC5") + cNumSC5 ))
	
	SC5->(RecLock("SC5",.T.))
	
	Replace C5_FILIAL  With xFilial("SC5")
	Replace C5_NUM     With cNumSC5
	Replace C5_TIPO    With "N"
	Replace C5_01TPOP  With aCabec[nPosOp][2]
	Replace C5_CLIENTE With aCabec[aScan(aCabec,{|x| x[1] == "C5_CLIENTE" })][2]
	Replace C5_LOJACLI With aCabec[aScan(aCabec,{|x| x[1] == "C5_LOJACLI" })][2]
	Replace C5_CLIENT  With aCabec[aScan(aCabec,{|x| x[1] == "C5_CLIENTE" })][2]
	Replace C5_LOJAENT With aCabec[aScan(aCabec,{|x| x[1] == "C5_LOJACLI" })][2]
	Replace C5_XORIGEM With aCabec[aScan(aCabec,{|x| x[1] == "C5_XORIGEM" })][2]
	Replace C5_TIPOCLI With aCabec[aScan(aCabec,{|x| x[1] == "C5_TIPOCLI" })][2]
	Replace C5_CONDPAG With aCabec[aScan(aCabec,{|x| x[1] == "C5_CONDPAG" })][2]
	//Replace C5_XCONPED With aCabec[aScan(aCabec,{|x| x[1] == "C5_XCONPED" })][2]
	Replace C5_FRETE With aCabec[aScan(aCabec,{|x| x[1] ==    "C5_FRETE" })][2]
	Replace C5_XPEDWEB With aCabec[nPosPvWeb][2]

	Replace C5_EMISSAO With dDataBase
	Replace C5_LIBEROK With "S"
	Replace C5_VEND1 With "000874"
	Replace C5_DESPESA With 0//If(cLinha=="1",nVlDesp1,nVlDesp2)
	Replace C5_DESCONT With 0//IF(Empty(M->UA_PDESCAB),If(cLinha=="1",nVlDes01,nVlDes02),0) // O desconto no rodape e valido somente se o Operador nao usa a INDENIZACAO (Cabecalho)
	Replace C5_TIPLIB  With "1"//M->UA_TIPLIB
	Replace C5_PDESCAB With 0//M->UA_PDESCAB
	Replace C5_TPFRETE With "C"//M->UA_TPFRETE
	Replace C5_TPCARGA With "1"//IF(cTPEntrega=="3","1","2")
	Replace C5_DESC1   With 0//M->UA_DESC1
	Replace C5_DESC2   With 0//M->UA_DESC2
	Replace C5_DESC3   With 0//M->UA_DESC3
	Replace C5_DESC4   With 0//M->UA_DESC4
	//Replace C5_XCONPED With '1'
	//Replace C5_INCISS  With SA1->A1_INCISS
	//Replace C5_ORCRES  With cAtende
	//Replace C5_TPFRETE With Posicione("SA1",1,xFilial("SA1")+M->UA_CLIENTE + M->UA_LOJA,"A1_TPFRET")
	//Replace C5_XDESCFI With IIF(INCLUI,FWFILIALNAME(CEMPANT,CFILANT,1),)
	//Replace C5_XCONDMA With M->UA_XCONDMA      	
	
	// Grava as parcelas quando a venda For do tipo 9
	
	
	SC5->(MsUnlock())

	FkCommit() // Commit para integridade referencial do SC5
	
	

cPedido := cNumSC5
cPedGerado := cPedido
Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GERASC6  ºAutor  ³Microsiga           º Data ³  18/06/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±
±±ºDesc.     ³ Gera os itens do pedido de venda                       	  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GERASC6(aLinha,cNumSc5,cFilAtu,_cPedWeb)

Local nX 			:= 0
//Local nUB_OPC		:= SUB->(FieldPos("UB_OPC"))								// Verifica se o campo de Opcionais do produto esta criado na Base de dados
//Local nC6_NUMTMK	:= SC6->(FieldPos("C6_NUMTMK"))
//Local cPrcFiscal	:= TkPosto(M->UA_OPERADO,"U0_PRECOF")						// Preco Fiscal Bruto = S ou N - Posto de Venda
Local cNovoItem 	:= "00"														// Valor do NOVO ITEM que sera incluido no SUB/SC6
Local lLiber 		:= .F.														// Compatibilizacao com o SIGAFAT
Local lTransf		:= .F.                                                     	// Compatibilizacao com o SIGAFAT
Local lLiberOk 		:= .T.														// Compatibilizacao com o SIGAFAT
Local lResidOk 		:= .T.														// Compatibilizacao com o SIGAFAT
Local lFaturOk 		:= .F.														// Compatibilizacao com o SIGAFAT
Local lTLVReg  		:= .F.
Local cFilOld		:= cFilAnt

/*
Local lAvalCre 		:= .F.			// Avaliacao de Credito
Local lBloqCre 		:= .F. 			// Bloqueio de Credito
Local lAvalEst		:= .T.			// Avaliacao de Estoque
Local lBloqEst		:= .T.			// Bloqueio de Estoque
*/

Local lCredito	:= .T.
Local lEstoque	:= .T.
Local lAvCred	:= .F.
Local lAvEst	:= .F.
Local lLiber	:= .F.
Local lTransf   := .F.
Local cTESCont  := "800"
//Variaveis para controle de posições dos campos
Local nSldPed   := 0
Local nSldPed2  := 0  
Local nPosProd  := 0
Local nPosQtd	:= 0
Local nPosPrc   := 0
lOCAL nPosLocal := 0
Local nPosTES   := 0
Local nPosUM	:= 0
Local nPosPrUnit := 0
Local nPosEntre := 0
Local nPosPrcVe := 0

Local cLOCGLP    := GetMV("MV_LOCGLP") //#CMG20180621.n

lNovo := .T.
For nX := 1 To Len(aLinha)
	
	cNovoItem := SomaIt(cNovoItem)
	
	//Atualizo o numero do pedido no SUB
	/*DbSelectArea("SUB")
	DbGoto(aLinha[nX][17])
	Reclock("SUB",.F.)
	Replace UB_XFILPED 	With cFilAtu
	Replace UB_NUMPV 	With cNumSC5
	Replace UB_ITEMPV 	With cNovoItem 
	MsUnlock()*/
	
	nPosEntre := aScan(aLinha[nX],{|x| AllTrim(x[1]) == "C6_ENTREG" })
	nPosProd := aScan(aLinha[nX],{|x| AllTrim(x[1]) == "C6_PRODUTO" })
	nPosQtd	 := aScan(aLinha[nX],{|x| AllTrim(x[1]) == "C6_QUANT" })
	nPosPrc  := aScan(aLinha[nX],{|x| AllTrim(x[1]) == "C6_NPOSPRC" })
	nPosPrcVen := aScan(aLinha[nX],{|x| AllTrim(x[1]) == "C6_PRCVEN" })
	
	If aScan(aLinha[nX],{|x| AllTrim(x[1]) == "C6_UNSVEN" }) > 0
		nPosPrUnit := aScan(aLinha[nX],{|x| AllTrim(x[1]) == "C6_UNSVEN" })
	Endif
	
	nPosLocal := aScan(aLinha[nX],{|x| AllTrim(x[1]) == "C6_LOCAL" }) 
	nPosTES   := aScan(aLinha[nX],{|x| AllTrim(x[1]) == "C6_TES" })
	
	If aScan(aLinha[nX],{|x| AllTrim(x[1]) == "C6_UM" }) > 0
		nPosUM    := aScan(aLinha[nX],{|x| AllTrim(x[1]) == "C6_UM" })
	Endif
	
	nPosValor := aScan(aLinha[nX],{|x| AllTrim(x[1]) == "C6_VALOR" })
	
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+aLinha[nX][nPosProd][2] ))
	
	SF4->(DbSetOrder(1))
	SF4->(DbSeek(xFilial("SF4")+aLinha[nX][nPosTES][2]))
	
	dbSelectArea("SB2")
	dbSetOrder(1)
	If !DbSeek(cFilAtu + PADR(aLinha[nX][nPosProd][2],TAMSX3("B2_COD")[1]) + aLinha[nX][nPosLocal][2] )
		CriaSb2( PADR(aLinha[nX][nPosProd][02],TAMSX3("B2_COD")[1]) , aLinha[nX][nPosLocal][02] )
	EndIf
	
	DbSelectArea("SC6")
	SC6->(Reclock("SC6",lNovo))
	Replace C6_FILIAL  With xFilial("SC6")
	Replace C6_NUM     With cNumSC5
	Replace C6_ITEM    With cNovoItem
	Replace C6_CLI     With SC5->C5_CLIENTE
	Replace C6_LOJA    With SC5->C5_LOJACLI
	Replace C6_PRODUTO With aLinha[nX][nPosProd][2]
	Replace C6_COMIS1  With SB1->B1_COMIS
	
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ TRATAMENTO PARA GRAVAR A DESCRICAO DO PRODUTO PERSONALIZADO - LUIZ EDUARDO F.C. - 11.08.2017 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	/*If !EMPTY(aLinha[nX,22])
		Replace C6_DESCRI  With ALLTRIM(SB1->B1_DESC) //+ "  //  " + ALLTRIM(aLinha[nX,22])
		Replace C6_PERSONA With "1"
	Else*/
	Replace C6_DESCRI  With SB1->B1_DESC
	Replace C6_XDESCR  With SB1->B1_DESC
	Replace C6_PERSONA With "2"
	Replace C6_UM	   With SB1->B1_UM
	//EndIf
	/*if nPosUM > 0
		Replace C6_UM	   With aLinha[nX][nPosUM][2]
	Else
		Replace C6_UM	   With SB1->B1_UM
	Endif*/
	
	Replace C6_QTDVEN  With aLinha[nX][nPosQtd][2]
	Replace C6_QTDLIB  With C6_QTDVEN
	Replace C6_SEGUM   With SB1->B1_SEGUM
	Replace C6_UNSVEN  With ConvUm(aLinha[nX][nPosProd][2],aLinha[nX][nPosQtd][2],0,2)
	
	If nPosPrUnit > 0
		Replace C6_PRUNIT  With aLinha[nX][nPosPrUnit][2]	
	Endif
	//If cPrcFiscal == "1"  								// Se o PRECO FISCAL BRUTO = Sim
	//Replace C6_PRCVEN With NoRound(aLinha[nX][06] / aLinha[nX][04],nTamDec)
	//Else
	Replace C6_PRCVEN  	With aLinha[nX][nPosPrcVen][02] 	// O valor do item ja esta com desconto
		//Replace C6_DESCONT 	With aLinha[nX][14] 
		//Replace C6_VALDESC	With aLinha[nX][15]
		
	//EndIf
	Replace C6_VALOR   With aLinha[nX][nPosValor][2]
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ TRATAMENTO PARA CLIENTES FORA DO ESTADO NAO CONTRIBUINTES - LUIZ EDUARDO F.C. - 12.07.2017 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ALLTRIM(SA1->A1_EST) <> "SP"
		If SA1->A1_CONTRIB == "2"
			Replace C6_TES     With cTESCont
		EndIf
	Else
		Replace C6_TES	With  cTESCont  // SF4->F4_CODIGOIf( !Empty(SB1->B1_TSESPEC) , SB1->B1_TSESPEC , aLinha[nX][08])				//aLinha[nX][08]
	EndIf
	
	Replace C6_CF      With SF4->F4_CF//SYRETCF(SC6->C6_TES,M->UA_CLIENTE,M->UA_LOJA,cNumSC5,cFilAtu) 					//aLinha[nX][09]
	Replace C6_LOCAL   With "15"
	
	If nPosEntre > 0
		Replace C6_ENTREG  With aLinha[nX][nPosEntre][02]
	Endif
	
	Replace C6_TPOP    With "F"
	
	If !Empty(SF4->F4_SITTRIB)
		Replace C6_CLASFIS With Subs(IIF(Empty(SB1->B1_ORIGEM),"0",SB1->B1_ORIGEM),1,1)+SF4->F4_SITTRIB
	Else
		Replace C6_CLASFIS With SF4->F4_CF
	Endif
	//Replace C6_PEDCLI  With "TMK"+M->UA_NUM
	/*If nUB_OPC > 0
		Replace C6_OPC  With aLinha[nX][16]
	EndIf*/
	Replace C6_CODISS  	With SB1->B1_CODISS
	//Replace C6_DTVALID 	With aLinha[nX][13]
	Replace C6_WKF1    	With "2"
	Replace C6_WKF2 	With "2"
	Replace C6_WKF3 	With "2"
	Replace C6_PEDPEND	with "4"
	Replace C6_MOSTRUA	with "2" //TODO: VERIFICAR SE É MONSTRUARIO

	
	//Replace C6_01DESME	with aLinha[nX][20]
	//If nC6_NUMTMK > 0
	//	Replace C6_NUMTMK  With xFilial("SUA")+M->UA_NUM
	//EndIf
	
	/*If aLinha[nX][18] = "2"
		Replace C6_01STATU 	With "2"
	Else
		Replace C6_01STATU 	With "1"
	EndIf*/
	
	Replace C6_01AGEND 	With "2"
	
	//#CMG20180122.bn
	//Replace C6_XLIBDES 	With aLinha[nX][23]
	//Replace C6_XDESMAX 	With aLinha[nX][24]
	//#CMG20180122.en
	
	//#RVC20180508.bn
	//If !Empty(aLinha[nX][25])	
	//	Replace C6_01AGEND 	With aLinha[nX][25]
	//EndIf
	//#RVC20180508.en
	
	SC6->(MsUnlock())
	
	//Tratamento para atualizar a previsao de saida no SB2. Mesmo liberando logo em seguida
	//é necessario para nao deixar o saldo negativo no B2_QPEDVEN
	//Deo - 21/12/17
	nSldPed := Max(SC6->C6_QTDVEN-SC6->C6_QTDENT-SC6->C6_QTDEMP,0)
	nSldPed2:= SB1->(ConvUm(SB2->B2_COD,nSldPed,nSldPed2,2))
	FatAtuEmpN("+")
	RecLock("SB2",.F.)
	SB2->B2_QPEDVEN += nSldPed
	SB2->B2_QPEDVE2 += nSldPed2
	SB2->(MsUnlock())
	
	FkCommit() // Commit para integridade referencial do SC5

	MaLibDoFat(SC6->(Recno()),SC6->C6_QTDLIB,@lCredito,@lEstoque,lAvCred,lAvEst,lLiber,lTransf)
			
	//Diminuo as quantidades previstas na tabela de saldos (B2_01SALPE)
	U_AtualB2Pre("-",SC6->C6_QTDVEN,SC6->C6_FILIAL,SC6->C6_PRODUTO,SC6->C6_LOCAL)
	
Next

SB2->(DbCloseArea())


Return

Static Function fEmailCanc(cPedido,_cPedWeb)

Local cPara := "isaias.gomes@komforthouse.com.br;suporte.protheus@komforthouse.com.br;joao.neto@komforthouse.com.br"
//Local cPara := "wellington.raul@komforthouse.com.br"
Local cAssunto := "Integração E-commerce Pedido: "+ cPedido
Local cBody := ""

cBody += "Email enviado automaticamente, não responder este email."+ CRLF + CRLF
cBody += "Por favor verificar se existe divergência entre o pedido do Site: "+ _cPedWeb +" e o pedido de venda:"+ cPedido +"."+ CRLF
cBody += "Caso haja necessidade, de Ajuste favor acionar o departamento de sistemas."+ CRLF+ CRLF
cBody += "Att."+ CRLF
cBody += "Sistema Protheus"

U_sendMail( cPara, cAssunto, cBody ) 

Return


/*/{Protheus.doc} SKUSEEK
//TODO:
Popula o Array passado por referência com os produtos do Kit no formato abaixo:
{"C6_PRODUTO",<cProduto>}
{"C6_QUANT"  ,<nQuantidade>}
{"C6_PRCVEN" ,<nPrecoVenda>}
{"C6_TES"    ,<cTES>}
{"C6_LOCAL"  ,<cArmazem>}
{"C6_VALDESC",<nDesconto>}
{"C6_NPOSPRC",<nPosPrc>}
{"C6_VALOR"  ,<nValor>}
------------------------------------------------------------------------------------------
SKUSEEK(<cCodProd>,<nValor>,<aDados>,<lPrecoB1>
cCodProd --> Código SKU do KIT
nValor   --> Valor total do item do Kit (Quantidade * Unitario)
aDados   --> Array que será populado com os itens. O array deve ser passado por referência
lPrecoB1 --> Indica se buscará o preço no cadastro de produtos. Se Falso cada produto terá 
o valor total do Kit dividido pelo total de itens do KIT.

@author Rafael S.Silva
@since 05/06/2019
@version 1.0
@return ${return}, ${return_description}
@param cCodKit, characters, description
@param aSkuList, array, description
@type function
/*/
Static Function SKUSEEK(cCodKit,nQuant,nTotal,nDesc,aItens,lPadrao)

	Local cQuery := ""
	Local nAux   := 0
	Local nPrcDefaul := (nTotal / nQuant)
	Local nPreco := 0
	Local aProds := {}
	Local lOrcamento := .F.
	Local aLinha := {}
	Local _aCodPro := {}
	cQuery := ""
	cQuery += CRLF + "SELECT B1_PRV1,B1_COD,B1_DESC,B1_TS,B1_LOCPAD,B1_PRV1,B1_XPRECV "
	cQuery += CRLF + "FROM "+RetSqlName("ZKC")+" (NOLOCK)  ZKC   " 
	cQuery += CRLF + "INNER JOIN "+RetSqlName("ZKD")+" (NOLOCK) ZKD ON ZKD_FILIAL = '"+xFilial("ZKD")+"'  "
	cQuery += CRLF + "	AND ZKD_CODPAI = ZKC_CODPAI AND ZKD.D_E_L_E_T_ = ' ' "
	cQuery += CRLF + "INNER JOIN "+RetSqlName("SB1")+" (NOLOCK) SB1 ON B1_FILIAL = '"+xFilial("SB1")+"'   "
	cQuery += CRLF + "	AND B1_COD = ZKD_CODFIL AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += CRLF + "WHERE ZKC_FILIAL = '"+xFilial("ZKC")+"'  "
	cQuery += CRLF + "	AND ZKC_CODPAI= '"+cCodKit+"' "
	cQuery += CRLF + "	AND ZKC.D_E_L_E_T_ = ' ' "

	If Select("TXSB1") > 0
		TXSB1->(DbCloseArea())
	Endif

	MemoWrite("SKU_ITEMS.SQL",cQuery)
	
	TcQuery cQuery New Alias "TXSB1"

	lOrcamento := .F.
	While .Not. ( TXSB1->( Eof()))

		//if ( aScan(aProds,{|x| AllTrim(x) == AllTrim(TXSB1->B1_COD) }) ) == 0
		If !lOrcamento
			If TXSB1->B1_XPRECV > 0
				nPreco := TXSB1->B1_XPRECV
			Else	
				lOrcamento := .T.
				nPreco := TXSB1->B1_PRV1
			Endif
		Else
			nPreco := TXSB1->B1_PRV1
		Endif
	
		//aAdd(aProds,TXSB1->B1_COD)

		aLinha := {}

		If lPadrao
			aAdd(aLinha,{"C6_PRODUTO",TXSB1->B1_COD,Nil})
			aAdd(aLinha,{"C6_QUANT",nQuant,Nil})
			aAdd(aLinha,{"C6_PRCVEN",nPreco,Nil})
			aAdd(aLinha,{"C6_LOCAL","15",Nil})//VERIFICAR ARMAZÉM
			//aAdd(aLinha,{"C6_VALOR",nPreco * nQuant,Nil})
			aAdd(aLinha,{"C6_TES",TXSB1->B1_TS,Nil})
			//aAdd(aLinha,{"C6_VALDESC",nDesc,Nil})
			aAdd(aLinha,{"C6_NPOSPRC",0})
			aAdd(aLinha,{"C6_XDESCR",TXSB1->B1_DESC,Nil })

		Else
			aAdd(aLinha,{"C6_PRODUTO",TXSB1->B1_COD,Nil})
			aAdd(aLinha,{"C6_XDESCR",TXSB1->B1_DESC,Nil })
			aAdd(aLinha,{"C6_QUANT",nQuant,Nil})
			aAdd(aLinha,{"C6_PRCVEN",nPreco,Nil})
			aAdd(aLinha,{"C6_LOCAL","15",Nil})
			aAdd(aLinha,{"C6_VALOR",nPreco* nQuant,Nil})
			aAdd(aLinha,{"C6_TES",TXSB1->B1_TS,Nil})
			aAdd(aLinha,{"C6_VALDESC",nDesc,Nil})
			aAdd(aLinha,{"C6_NPOSPRC",0,Nil})			

		Endif
		
		aAdd(aItens,aLinha)
	
		

		TXSB1->(DbSkip())
	
	EndDo
	
	
	
Return 

//BUSCA CONDIÇÕES DE PAGAMENTO CONFORME QUANTIDADE DE PARCELAS E FORMA DE PAGAMENTO NO SITE
Static function VLDCODPG(nFormPag,nQtdParc)

	Local cCondPag := ""
	Local cQuery   := ""

	DbSelectArea("SE4")
	SE4->(dbSetOrder(1))//E4_FILIAL+E4_CODIGO


	if nFormPag == 1
		cCondPag := "001"
	else 
		cCondPag := "001"
	endif

return cCondPag


Static function GERASE1(nFormPag,cCliente,cLojaCli,cTipo,cNaturez,cNum,nQtdParc,nValParc,cAutoriz,cCCID,cNumero,cValidade,cCodSeg,cOperaRet,nCodOper,cNumSua)

Local aCampos  := {}
//Local nValParc := (nValTot/nQtdParc)
Local nTamParc := TAMSX3("E1_PARCELA")[1]
Local dDataPg  := dDataBase
Local dNewData := dDataBase
Local aConParc := {{10,"A"},{11,"B"},{12,"C"},{13,"D"},{14,"E"},{15,"F"},{16,"G"},{17,"H"},{18,"I"},{19,"J"},{20,"K"}}
Local cCodParc := ""
LocaL nPos     := 0
Local nPosOper := 0
Local aOpera   := {}
Local aOperadoras := {}
lOCAL cCodAd := ""
Local cIten  := ""
Local cForTX := ""
Local cPortado := ""
Local cLojTX := ""
Local cLogErro := ""


if nFormPag == 1
	IF nQtdParc == 1
			cCodAd := "115"
			cIten  := "001"
	elseif nQtdParc > 1   .AND. nQtdParc <= 6
			cCodAd := "115"
			cIten := "002"
	elseif nQtdParc > 6 .AND. nQtdParc <= 10
			cCodAd := "115"
			cIten := "003"
	EndIf

elseif nFormPag == 2
	cCodAd := "116"
	cIten  := "001"
endif

//cCodAd := "112"

aAdd(aOpera,{1,"American Express"})
aAdd(aOpera,{3,"Bradesco"})
aAdd(aOpera,{4,"Dinners"})
aAdd(aOpera,{8,"MasterCard"})
aAdd(aOpera,{9,"Visa"})
aAdd(aOpera,{41,"ELO"})


Default ctipo := "CD"

dbSelectAreA("SL4")

lMSErroAuto := .F.

nPosOper := aScan(aOpera, {|x| x[1] == nCodOper } )

DbSelectArea("SAE")
SAE->(dbSetOrder(1))//E4_FILIAL+E4_CODIGO

if SAE->(DbSeek(xFilial()+cCodAd))
	cPortado  := SAE->AE_XPORTAD
	cAdmins := SAE->AE_DESC
Endif

DbSelectArea("MEN")
MEN->(dbSetOrder(1))//MEN_FILIAL, MEN_ITEM, MEN_CODADM, R_E_C_N_O_, D_E_L_E_T_		
if MEN->(DbSeek(xFilial()+cIten+cCodAd))
	nValTx := MEN->MEN_TAXADM
EndIf	



fGeraE2(nValParc,nFormPag,nQtdParc,{"K42",cNum,cTipo,cNaturez})

For nAux := 1 to nQtdParc
	aCampos := {}  

	If nAux > 9
		nPos := aScan(aConParc, {|x| x[1] == nAux } )
		cCodParc := aConParc[nPos][2]
	else
		cCodParc :=	cValToChar(nAux)
	Endif
	
	if nFormPag == 1
		dDataPg  := dDataBase+(30*nAux)
		dNewData := DataValida(dDataPg, .T.)
	ElseIf nFormPag == 2
		dDataPg  := dDataBase+4
		dNewData := DataValida(dDataPg, .T.)
		nValTx   := 0
	EndIf

	aAdd( aCampos , { "E1_PREFIXO"  , "K42" , Nil })                          
	aAdd( aCampos , { "E1_NUM"      , cNum , Nil })                          
	aAdd( aCampos , { "E1_PARCELA"  , cCodParc , Nil })                          
	aAdd( aCampos , { "E1_TIPO"     , cTipo , Nil })
	aAdd( aCampos , { "E1_EMISSAO"  , dDataBase , Nil })
	aAdd( aCampos , { "E1_NATUREZ"  , cNaturez , Nil })                          
	aAdd( aCampos , { "E1_CLIENTE"  , cCliente , Nil })                          
	aAdd( aCampos , { "E1_LOJA"     , cLojaCli , Nil })                                                    
	aAdd( aCampos , { "E1_VENCTO"   , dDataPg, Nil })                          
	aAdd( aCampos , { "E1_VENCREA"  , dNewData , Nil })                          
	aAdd( aCampos , { "E1_DTACRED"  , dNewData , Nil })                          
	aAdd( aCampos , { "E1_VALOR"    , nValParc , Nil })
	aAdd( aCampos , { "E1_NSUTEF"   , PADR(Alltrim(cAutoriz),12) , Nil })
	aAdd( aCampos , { "E1_PORTADO"  , cPortado , Nil })   //VERIFICAR NECESSIDADE DE CRIAR PARÂMETROS
	aAdd( aCampos , { "E1_NUMSUA"   , cNumSua , Nil })
	aAdd( aCampos , { "E1_HIST"     , "RAKUTEN PAY" , Nil })
	aAdd( aCampos , { "E1_VEND1"    , "000874" , Nil })
	aAdd( aCampos , { "E1_ADM"      , cCodAd  , Nil })
	aAdd( aCampos , { "E1_01TAXA"   , nValTx , Nil })
	//aAdd( aCampos , { "CAGEAUTO"    , "BMP" , Nil })
	//aAdd( aCampos , { "CCTAAUTO"    , "BMP" , Nil })
								
	MsExecAuto({|x,y| FINA040(x,y)}, aCampos, 3)
		
	If !lMSErroAuto
		SL4->(RecLock("SL4",.T.))
		SL4->L4_FILIAL  := xFilial("SL4")
		SL4->L4_NUM     := cNumSua
		SL4->L4_DATA    := dDataPg
		SL4->L4_VALOR   := nValParc
		SL4->L4_FORMA   := cTipo
		SL4->L4_ADMINIS := cAdmins//BUSCAR SAE
		SL4->L4_OBS     := ""
		SL4->L4_TERCEIR := .F.
		SL4->L4_AUTORIZ := cAutoriz
		SL4->L4_MOEDA   := 1
		SL4->L4_ORIGEM  := "SITE"
		SL4->L4_DESCMN  := 0
		SL4->L4_XFORFAT := "1"
		SL4->L4_XPARC   := cValToChar(nQtdParc)
		SL4->L4_XPARNSU := cCodParc
		SL4->L4_XNCART4 := Right(cCCID,4)//4 ULTIMOS CARTÃO 
		SL4->L4_XFLAG   := Iif(nPosOper > 0,aOpera[nPosOper][2],"")
		SL4->(MsUnlock())
	Else
		cLogErro := 'TITULOS_RAKUTEN_'+STRTRAN(TIME(),":","-")+".log"
		MostraErro("\SYSTEM\EXECAUTO\",cLogErro)	
		cLogErro := memoread("\SYSTEM\EXECAUTO\"+cLogErro) 
		U_KHLOGWS("SE1",dDataBase,Time(),cLogErro + " KHCADPVE","PROTHEUS")

	Endif
Next nAux


Return


Static function fGeraE2(nValParc,nFormPag,nQtdParc,aCampos)

    Local cCodAd   := ""
    Local cIten    := ""
    Local cForTX   := ""
    Local cLojTX   := ""
    Local cPortado := ""
    Local nValAdm  := 0
	Local aConParc := {{10,"A"},{11,"B"},{12,"C"},{13,"D"},{14,"E"},{15,"F"},{16,"G"},{17,"H"},{18,"I"},{19,"J"},{20,"K"}}
	Local aVetorSE2 := {}
    Local dDataPg  := dDataBase
	Local dNewData := DataValida(dDataPg, .T.)

    if nFormPag == 1
        Do Case
            Case nQtdParc == 1
                cCodAd := "115"
                cIten  := '001'
            Case nQtdParc  > 1 .AND. nQtdParc <= 6
                cCodAd := "115"
                cIten := '002'
            Case nQtdParc > 6 .AND. nQtdParc <= 10
                cCodAd := "115"
                cIten := '003'
        EndCase

    elseif nFormPag == 2
        cCodAd := "116"
		cIten  := "001"
    endif

 	//cCodAd := "112"

	DbSelectArea("SAE")
	SAE->(dbSetOrder(1))//E4_FILIAL+E4_CODIGO

	If SAE->(DbSeek(xFilial()+cCodAd))
		cNaturez :=  SAE->AE_01NATTX
		cForTX    := SAE->AE_XFORTX
		cPortado  := SAE->AE_XPORTAD
		cLojTX    := SAE->AE_XLJTX
	Endif

	For nAux := 1 to nQtdParc
	aVetorSE2 :={}
		If nAux > 9
			nPos := aScan(aConParc, {|x| x[1] == nAux } )
			cCodParc := aConParc[nPos][2]
		else
			cCodParc :=	cValToChar(nAux)
		Endif

			DbSelectArea("MEN")

			MEN->(dbSetOrder(1))//MEN_FILIAL, MEN_ITEM, MEN_CODADM, R_E_C_N_O_, D_E_L_E_T_
			
			if MEN->(DbSeek(xFilial()+cIten+cCodAd))
				nValTx := MEN->MEN_TAXADM
				
				if nFormPag == 1
				nValAdm := (nValParc * nValTx)/ 100
				dDataPg  := dDataBase+(30*nAux)
				dNewData := DataValida(dDataPg, .T.)
				ElseIf nFormPag == 2
				nValAdm := nValTx
				dDataPg  := dDataBase+4
				dNewData := DataValida(dDataPg, .T.)
				EndIf
				
				
				lMsErroAuto     := .F.

				

				//aAdd( aCampos , { "E1_PREFIXO"  , "K42" , Nil })  				
	
				aAdd( aVetorSE2, {"E2_PREFIXO"       ,"TXA"                                   ,Nil})              // 01		
				aAdd( aVetorSE2, {"E2_NUM"           ,aCampos[2]                              ,Nil})              // 02
				aAdd( aVetorSE2, {"E2_TIPO"          ,PADR(Alltrim(aCampos[3]),3)             ,Nil})              // 04			
				aAdd( aVetorSE2, {"E2_PARCELA"       ,cCodParc                                ,Nil})              // 03
				aAdd( aVetorSE2, {"E2_NATUREZ"       ,cNaturez                     ,"AlwaysTrue()"})              // 05
				aAdd( aVetorSE2, {"E2_FORNECE"       ,IIF(EMPTY(cForTX),"999999",cForTX)      ,Nil})              // 06   
				aAdd( aVetorSE2, {"E2_LOJA"          ,cLojTX                                  ,Nil})              // 07   
				aAdd( aVetorSE2, {"E2_EMISSAO"       ,dDataBase                               ,NIL})              // 08
				aAdd( aVetorSE2, {"E2_VENCTO"        ,dDataPg                           	  ,NIL})              // 09
				aAdd( aVetorSE2, {"E2_VENCREA"       ,dNewData                                ,NIL})              // 10
				aAdd( aVetorSE2, {"E2_VALOR"         ,nValAdm                                 ,NIL})              // 11
				aAdd( aVetorSE2, {"E2_XDESCFI"       ,"ECMMOMERCE/CD"                         ,NIL})              // 12
				aAdd( aVetorSE2, {"E2_PORTADO"       ,cPortado                                ,NIL})              // 13
					
				MSExecAuto({|x,y,z| Fina050(x,y,z)},aVetorSE2,,3)

				if lMsErroAuto
				    cLogErro := 'TAXAS_RAKUTEN_'+STRTRAN(TIME(),":","-")+".log"
	        	    MostraErro("\SYSTEM\EXECAUTO\",cLogErro)	
				    U_KHLOGWS("SE2",dDataBase,Time(),cLogErro + " KHCADPVE","PROTHEUS")
		       Endif
			Else
				U_KHLOGWS("MEN",dDataBase,Time(),"["+cCodAd+cIten+"] Cadastro não encontrado no financeiro - KHCADPVE","PROTHEUS")
			Endif

		
 	Next nAux

	SAE->(DbCloseArea())
	MEN->(DbCloseArea())
return


//Retorna natureza de acordo com a forma de pagamento
//1 = Cartão; 2 = boleto
Static function fRetNat(nForma,nQtdParc)

    if nForma == 1
        Do Case
            Case nQtdParc == 1
                cCodAd := "115"
            Case nQtdParc  > 1 .AND. nQtdParc <= 6
                cCodAd := "115"
            Case nQtdParc > 6 .AND. nQtdParc <= 10
                cCodAd := "115"
        EndCase

    elseif nForma == 2
        cCodAd := "116"
    endif

	//cCodAd := "112"
	DbSelectArea("SAE")
	SAE->(dbSetOrder(1))//E4_FILIAL+E4_CODIGO

	if SAE->(DbSeek(xFilial("SAE")+cCodAd))
		cNaturez  := SAE->AE_01NAT
	Else
		U_KHLOGWS("SAE",dDataBase,Time(),"["+cCodAd+"] ERRO AO BUSCAR NATUREZA NA TABELA SAE -  KHCADPVE","PROTHEUS")
	Endif

	SAE->(DbCloseArea())
	
return cNaturez


//Cadastra pedidos via ExecAuto
Static function CADPEDIDO(aCabec,aItens)
Local nAux := 0
Local lRet := .F.
Local lRet := .F.
Local cErro		:= ""
Local aError := {}
Local alRet	:= {}  
Local cPed	:= ""
Local nPosPed := 0 
Local cPedWeb := ""
Local cLogErro := ""
Private lMsErroAuto 

SC5->(DbSetorder(11))//C5_FILIAL+C5_XPEDWEB - FILIAL + PEDIDOWEB

if len(aCabec) > 0 .and. len(aItens) > 0 
	nPosPed := aScan(aCabec,{|x| AllTrim(x[1]) == "C5_XPEDWEB"}) 
	If nPosPed > 0
	     cPedWeb := AllTrim(aCabec[nPosPed][2])
	Endif

	If !SC5->(DbSeek( xFilial("SC5") + Padr(cPedWeb,TamSx3("C5_XPEDWEB")[1]) )) //Criar indice 

		Begin Transaction
			lMsErroAuto := .F.
			MSExecAuto({|x,y,z|MATA410(x,y,z)},aCabec,aItens,3)
			If !lMsErroAuto
				ConfirmSx8() 
				lRet := .T.
				cPed := SC5->C5_NUM

				If ExistBlock("KHPVFIM")
					cNumTmk := ExecBlock("KHPVFIM",.F.,.F.,{cPed})
				
					RecLock("SC5",.F.)
					SC5->C5_NUMTMK := cNumTmk
					SC5->(MsUnlock())
				Endif	

				aAdd(alRet,{lRet,cPed,""})  
			Else
				cLogErro := 'PEDIDO_'+STRTRAN(TIME(),":","-")+".log"
				MostraErro("\SYSTEM\EXECAUTO\",cLogErro)  
				cErro += "O Pedido "+cPedWeb+" não foi cadastrado" +;
						CRLF + MemoRead(cLogErro)
				DisarmTransaction() 
				RollBackSx8()    
				
				cPed := ''
			    lRet := .F.      
			    
				aAdd(alRet,{lRet,cPed,cErro})   
			Endif
		End Transaction  
		
	Else 
		cPed :=  SC5->C5_NUM 
	    cErro := "O Pedido "+cPedWeb+" E-Commerce já existe na base de dados"  
	    lRet := .F.      
	    
		aAdd(alRet,{lRet,cPed,cErro})     

	Endif
Endif

return alRet


User Function KHJOBPVE(aEmp)
	

	Local aEmp := {"01","0142"}

	PREPARE ENVIRONMENT EMPRESA aEmp[1] FILIAL aEmp[2]    

	U_KHCADPVE()


Return 




