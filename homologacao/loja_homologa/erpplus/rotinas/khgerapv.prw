#include 'protheus.ch'
#include 'parmtype.ch'

user function KHGERAPV()
	
	Local aCabec := {}

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
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GERASC5(aCabec)

Local cNumSc5 	:= ''													// Numero do Pedido	- Inclusao
Local nNumPar 	:= ""//SuperGetMv("MV_NUMPARC")								// Numero de parcelas utilizada no sistema
Local nUA_CONTRA // := SUA->(FieldPos("UA_CONTRA"))							// Verifica se o campo CONTRATO para integracao com o SIGACRD esta criado  na base de dados
Local lTipo9	:= .F.													// Indica se a venda foi tipo 9
Local aPedido	:= {}													// Array com o numero do pedido para emissao da NF - MV_OPFAT = S
Local nValComi	:= 0 													// Valor da Comissao para o SC5
Local nI		:= 0
Local cOBS1		:= " "//U_SyLeSYP(SUA->UA_CODOBS,TamSx3("UA_OBS")[1])
Local cTPFRETE  := "" // IRA ARMAZENAR O TIPO DE FRETE DO CADASTRO DE CLIENTES - LUIZ EDUARDO F.C. - 18.08.2017


/*
DbSelectArea("SA1")
DbSetOrder(1)
If DbSeek(xFilial("SA1") + M->UA_CLIENTE + M->UA_LOJA)
	nValComi:= SA1->A1_COMIS
EndIf*/

/*If nValComi == 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Pega o valor da comissao no cadastro de vendedores, caso nao tenha o % preenchido no cadastro de clientes ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty(M->UA_COMIS) .AND. !Empty(M->UA_VEND)
		DbSelectArea("SA3")
		DbSetOrder(1)
		If DbSeek(xFilial("SA3")+M->UA_VEND)
			nValComi := A3_COMIS
		EndIf
	EndIf
EndIf*/


/*
// Verifica se a condicao de pagamento e do tipo 9
DbSelectArea("SE4")
DbSetOrder(1)
If DbSeek(xFilial("SE4")+M->UA_CONDPG)
	If SE4->E4_TIPO == "9"
		lTipo9 := .T.
	EndIf
EndIf
*/

//If M->UA_OPER == "1"
	//Se ‚ um NOVO PEDIDO gero os registros no SC5
	DbSelectArea("SC5")
	DbSetOrder(1)
	
	cNumSC5 := GetSxeNum("SC5","C5_NUM")
	
	cMay := "SC5"+ALLTRIM(cFilAtu)+cNumSC5
	While (DbSeek(cFilAtu+cNumSC5) .OR. !MayIUseCode(cMay))
		cNumSC5 := Soma1(cNumSC5,Len(cNumSC5))
		cMay 	:= "SC5"+ALLTRIM(cFilAtu)+cNumSC5
	End
	If __lSX8
		ConfirmSX8()
	EndIf
	
	lNovo := .T.
	
	DbSelectArea("SC5")
	SC5->(RecLock("SC5",lNovo))
	Replace C5_FILIAL  With xFilial("SC5")
	Replace C5_NUM     With cNumSC5
	Replace C5_TIPO    With "N"
	Replace C5_CLIENTE With M->UA_CLIENTE
	Replace C5_LOJACLI With M->UA_LOJA
	Replace C5_CLIENT  With M->UA_CLIENTE
	Replace C5_LOJAENT With M->UA_LOJA
	Replace C5_TRANSP  With M->UA_TRANSP
	Replace C5_TIPOCLI With M->UA_TIPOCLI
	Replace C5_CONDPAG With M->UA_CONDPG
	Replace C5_TABELA  With M->UA_TABELA
	Replace C5_VEND1   With M->UA_VEND
	Replace C5_COMIS1  With IIF( Empty( nValComi ), M->UA_COMIS, nValComi)
	Replace C5_ACRSFIN With 0
	Replace C5_01SAC   With M->UA_01SAC
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³A data de emissao do pedido e atualizada somente na primeira gravacao³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lNovo
		Replace C5_EMISSAO With dDataBase
	EndIf
	Replace C5_MOEDA   With M->UA_MOEDA
	Replace C5_TXMOEDA With RecMoeda(M->UA_EMISSAO,M->UA_MOEDA)
	Replace C5_LIBEROK With "S"
	Replace C5_FRETE   With 0//If(cLinha=="1",nVlFre01,nVlFre02)
	Replace C5_DESPESA With 0//If(cLinha=="1",nVlDesp1,nVlDesp2)
	Replace C5_DESCONT With 0//IF(Empty(M->UA_PDESCAB),If(cLinha=="1",nVlDes01,nVlDes02),0) // O desconto no rodape e valido somente se o Operador nao usa a INDENIZACAO (Cabecalho)
	Replace C5_TIPLIB  With "1"//M->UA_TIPLIB
	Replace C5_COMIS1  With 0//IIF( Empty( nValComi ), M->UA_COMIS, nValComi)
	Replace C5_PDESCAB With 0//M->UA_PDESCAB
	Replace C5_TPFRETE With "C"//M->UA_TPFRETE
	Replace C5_TPCARGA With "1"//IF(cTPEntrega=="3","1","2")
	Replace C5_DESC1   With ""//M->UA_DESC1
	Replace C5_DESC2   With ""//M->UA_DESC2
	Replace C5_DESC3   With ""//M->UA_DESC3
	Replace C5_DESC4   With ""//M->UA_DESC4
	//Replace C5_INCISS  With SA1->A1_INCISS
	//Replace C5_ORCRES  With cAtende
	//Replace C5_TPFRETE With Posicione("SA1",1,xFilial("SA1")+M->UA_CLIENTE + M->UA_LOJA,"A1_TPFRET")
	//Replace C5_XDESCFI With IIF(INCLUI,FWFILIALNAME(CEMPANT,CFILANT,1),)
	//Replace C5_XCONDMA With M->UA_XCONDMA      	
	
	// Grava as parcelas quando a venda For do tipo 9
	/*If lTipo9
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Acerta as informações das parcelas que foram desconsideradas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Len(aParcelas) < nNumPar
			For nI := 1 To nNumPar - Len(aParcelas)
				AADD(aParcelas ,{	CtoD("  /  /  "),;
				0  ,;
				"" ,;
				Space(80),;
				0,;
				Space(01)})
			Next
		EndIf
		For nI := 1 TO Len(aParcelas)
			Replace &("SC5->C5_DATA"+Substr(cParcela,nI,1)) With aParcelas[nI][1]
			If aParcelas[nI][5] > 0
				Replace &("SC5->C5_PARC"+Substr(cParcela,nI,1)) With aParcelas[nI][5] //Valor em %
			Else
				Replace &("SC5->C5_PARC"+Substr(cParcela,nI,1)) With aParcelas[nI][2] //Valor em R$
			EndIf
		Next nI
	EndIf*/
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Gravacao dos campos SIGACRD para integracao com o SIGAFAT.  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	/*If nUA_CONTRA > 0
		Replace C5_CONTRA with SUA->UA_CONTRA
	EndIf*/
	
	//Replace C5_VEND2	with SUA->UA_VEND1
	//Replace C5_COMIS2	with Posicione("SA3",1,xFilial("SA3")+SUA->UA_VEND1,"A3_COMIS")
	Replace C5_01TPOP 	with "1"
	//Replace C5_PEDPEND	with SUA->UA_PEDPENDS //#AFD20180413.o
	//Replace C5_PEDPEND	with iif(SUA->UA_XPERLIB > 0,"2",SUA->UA_PEDPEND)//#AFD20180413.n
	//Replace C5_NUMTMK	with cAtende
	//Replace C5_XPERLIB	with SUA->UA_XPERLIB//#AFD20180412.n 
	
	SC5->(MsUnlock())
	
	/*If !Empty(cOBS1)
		MSMM(,TamSx3("C5_XCODOBS") [1],,cOBS1,1,,,"SC5","C5_XCODOBS")
	EndIf*/
	FkCommit() // Commit para integridade referencial do SC5
	
	//Atualizo o numero do pedido e do atendimento para gerar a NF  - MV_OPFAT = "S"
	//AADD(aPedido,{M->UA_NUM,cNumSc5})
	
	//Atualizo o numero do pedido no SUA
	/*DbSelectArea("SUA")
	SUA->(RecLock("SUA",.F.))
	If cLinha == "1"
		Replace UA_NUMSC5  With cNumSC5
		//LjWriteLog( cARQLOG, "2.01 - GERADO PEDIDO DE VENDA LINHA 1: "+cNumSC5 )
	Else
		Replace UA_PEDLIN2 With cNumSC5
		//LjWriteLog( cARQLOG, "3.01 - GERADO PEDIDO DE VENDA LINHA 2: "+cNumSC5 )
	EndIf
	SUA->(MsUnlock())*/
//EndIf
cPedido := cNumSC5

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GERASC6  ºAutor  ³Microsiga           º Data ³  18/06/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera os itens do pedido de venda                       	  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GERASC6(aLinha,cNumSc5,cFilAtu)

Local nX 			:= 0
Local nUB_OPC		:= SUB->(FieldPos("UB_OPC"))								// Verifica se o campo de Opcionais do produto esta criado na Base de dados
Local nC6_NUMTMK	:= SC6->(FieldPos("C6_NUMTMK"))
Local cPrcFiscal	:= TkPosto(M->UA_OPERADO,"U0_PRECOF")						// Preco Fiscal Bruto = S ou N - Posto de Venda
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
Local cTESCont      := GetMV("KM_TESCONT",,"631")
Local nSldPed   := 0
Local nSldPed2  := 0  

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
	
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+aLinha[nX][03] ))
	
	SF4->(DbSetOrder(1))
	SF4->(DbSeek(xFilial("SF4")+aLinha[nX][08]))
	
	dbSelectArea("SB2")
	dbSetOrder(1)
	If !DbSeek(cFilAtu + PADR(aLinha[nX][03],TAMSX3("B2_COD")[1]) + aLinha[nX][10] )
		CriaSb2( PADR(aLinha[nX][03],TAMSX3("B2_COD")[1]) , aLinha[nX][10] )
	EndIf
	
	DbSelectArea("SC6")
	SC6->(Reclock("SC6",lNovo))
	Replace C6_FILIAL  With xFilial("SC6")
	Replace C6_NUM     With cNumSC5
	Replace C6_ITEM    With cNovoItem
	Replace C6_CLI     With M->UA_CLIENTE
	Replace C6_LOJA    With M->UA_LOJA
	Replace C6_PRODUTO With aLinha[nX][03]
	Replace C6_COMIS1  With SB1->B1_COMIS
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ TRATAMENTO PARA GRAVAR A DESCRICAO DO PRODUTO PERSONALIZADO - LUIZ EDUARDO F.C. - 11.08.2017 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !EMPTY(aLinha[nX,22])
		Replace C6_DESCRI  With ALLTRIM(SB1->B1_DESC) + "  //  " + ALLTRIM(aLinha[nX,22])
		Replace C6_PERSONA With "1"
	Else
		Replace C6_DESCRI  With SB1->B1_DESC
		Replace C6_PERSONA With "2"
	EndIf
	
	Replace C6_UM	   With aLinha[nX][11]
	Replace C6_QTDVEN  With aLinha[nX][04]
	Replace C6_QTDLIB  With C6_QTDVEN
	Replace C6_SEGUM   With SB1->B1_SEGUM
	Replace C6_UNSVEN  With ConvUm(aLinha[nX][03],aLinha[nX][04],0,2)
	Replace C6_PRUNIT  With aLinha[nX][12]
	If cPrcFiscal == "1"  								// Se o PRECO FISCAL BRUTO = Sim
		Replace C6_PRCVEN With NoRound(aLinha[nX][06] / aLinha[nX][04],nTamDec)
	Else
		Replace C6_PRCVEN  	With aLinha[nX][05] 	// O valor do item ja esta com desconto
		Replace C6_DESCONT 	With aLinha[nX][14]
		Replace C6_VALDESC	With aLinha[nX][15]
		
	EndIf
	Replace C6_VALOR   With aLinha[nX][06]
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ TRATAMENTO PARA CLIENTES FORA DO ESTADO NAO CONTRIBUINTES - LUIZ EDUARDO F.C. - 12.07.2017 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ALLTRIM(SA1->A1_EST) <> "SP"
		If SA1->A1_CONTRIB == "2"
			Replace C6_TES     With cTESCont
		EndIf
	Else
		Replace C6_TES     With If( !Empty(SB1->B1_TSESPEC) , SB1->B1_TSESPEC , aLinha[nX][08])				//aLinha[nX][08]
	EndIf
	Replace C6_CF      With SYRETCF(SC6->C6_TES,M->UA_CLIENTE,M->UA_LOJA,cNumSC5,cFilAtu) 					//aLinha[nX][09]

	//#CMG20180621.bn
	If Alltrim(aLinha[nX][19]) == '2' .Or. Alltrim(aLinha[nX][19]) == '4' 
		Replace C6_LOCAL With cLOCGLP
	Else
		Replace C6_LOCAL   With aLinha[nX][10]
	EndIf
	//#CMG20180621.en
	
	Replace C6_ENTREG  With aLinha[nX][07]
	Replace C6_TPOP    With "F"
	Replace C6_CLASFIS With Subs(SB1->B1_ORIGEM,1,1)+SF4->F4_SITTRIB
	Replace C6_PEDCLI  With "TMK"+M->UA_NUM
	If nUB_OPC > 0
		Replace C6_OPC  With aLinha[nX][16]
	EndIf
	Replace C6_CODISS  	With SB1->B1_CODISS
	Replace C6_DTVALID 	With aLinha[nX][13]
	Replace C6_WKF1    	With "2"
	Replace C6_WKF2 	With "2"
	Replace C6_WKF3 	With "2"
	Replace C6_PEDPEND	with iif(SUA->UA_XPERLIB > 0,"2",SUA->UA_PEDPEND)//#AFD20180620.n
	Replace C6_MOSTRUA	with aLinha[nX][19]
	Replace C6_01DESME	with aLinha[nX][20]
	If nC6_NUMTMK > 0
		Replace C6_NUMTMK  With xFilial("SUA")+M->UA_NUM
	EndIf
	
	If aLinha[nX][18] = "2"
		Replace C6_01STATU 	With "2"
	Else
		Replace C6_01STATU 	With "1"
	EndIf
	Replace C6_01AGEND 	With "2"
	
	//#CMG20180122.bn
	Replace C6_XLIBDES 	With aLinha[nX][23]
	Replace C6_XDESMAX 	With aLinha[nX][24]
	//#CMG20180122.en
	
	//#RVC20180508.bn
	If !Empty(aLinha[nX][25])	
		Replace C6_01AGEND 	With aLinha[nX][25]
	EndIf
	//#RVC20180508.en
	
	SC6->(MsUnlock())
	
	//Tratamento para atualizar a previsao de saida no SB2. Mesmo liberando logo em seguida
	//é necessario para nao deixar o saldo negativo no B2_QPEDVEN
	//Deo - 21/12/17
	nSldPed := Max(SC6->C6_QTDVEN-SC6->C6_QTDENT-SC6->C6_QTDEMP,0)
	nSldPed2:= SB1->(ConvUm(SB2->B2_COD,nSldPed,nSldPed2,2))
	FatAtuEmpN("+")
	RecLock("SB2")
	SB2->B2_QPEDVEN += nSldPed
	SB2->B2_QPEDVE2 += nSldPed2
	SB2->(MsUnlock())
	
	FkCommit() // Commit para integridade referencial do SC5

	//Empenhar o estoque para pedido diferente do status 'Em Aguardar'
	If cPedPend <> "1"
		lAvEst	:= .T.
		MaLibDoFat(SC6->(Recno()),SC6->C6_QTDLIB,@lCredito,@lEstoque,lAvCred,lAvEst,lLiber,lTransf)			
	EndIf
			
	//Diminuo as quantidades previstas na tabela de saldos (B2_01SALPE)
	If aLinha[nX][18]=='3'
		U_AtualB2Pre("-",SC6->C6_QTDVEN,SC6->C6_FILIAL,SC6->C6_PRODUTO,SC6->C6_LOCAL)
	EndIf
	
Next

SB2->(DbCloseArea())


Return