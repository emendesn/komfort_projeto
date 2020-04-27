#INCLUDE "protheus.ch"

STATIC cOpFat := Alltrim(GetMv("MV_OPFAT"))
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TMKVFIM  º Autor ³ Eduardo Patriani   º Data ³  17/02/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Após a gravação do Pedido de Venda - quando a operação for º±±
±±º          ³ de FATURAMENTO - na rotina de Televendas. 				  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function TMKVFIM()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea     := GetArea()
Local aAreaSL4	:= SL4->(GetArea())
Local cAtende   := SUA->UA_NUM
Local cPedido   := SUA->UA_NUMSC5

IF SUA->UA_OPER=="2" //Orcamento
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia Workflow para Responsavel Tecnico.    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(SUA->UA_VEND1) .And. ( SUA->UA_ENWKFRT=='2' .Or. Empty(SUA->UA_ENWKFRT))
		U_SYVW100(cAtende)
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄdH¿
//³Grava o numero do pedido gerado pelo faturamento, no pedido³
//³de venda vinculado. [FATURAMENTO]                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄdHÙ
If SUA->UA_OPER=="1" .And. !Empty(SUA->UA_01PEDAN)
	
	SC5->(DbSetOrder(1))
	If SC5->(DbSeek(xFilial("SC5") + cPedido ))
		Reclock("SC5",.F.)
		SC5->C5_01PEDAN := SUA->UA_01PEDAN
		Msunlock()
	Endif
	
	SC5->(DbSetOrder(1))
	If SC5->(DbSeek(xFilial("SC5") + SC5->C5_01PEDAN ))
		Reclock("SC5",.F.)
		SC5->C5_01PEDAN := cPedido
		Msunlock()
	Endif
	
	
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Grava as parcelas no contas a receber conforme a tabela    ³
//³SL4 (negociacoes de pagamento), somente quando faturamento.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SUA->UA_OPER=="1" //Faturamento
	
	SC5->(DbSetOrder(1))
	If SC5->(DbSeek(xFilial("SC5") + cPedido ))
		Reclock("SC5",.F.)
		SC5->C5_VEND2		:= SUA->UA_VEND1
		SC5->C5_COMIS2	:= Posicione("SA3",1,xFilial("SA3")+SUA->UA_VEND1,"A3_COMIS")
		SC5->C5_01TPOP 	:= "1"
		SC5->C5_PEDPEND	:= SUA->UA_PEDPEND
		SC5->C5_NUMTMK	:= cAtende
		Msunlock()
	Endif
	
	SC6->(DbSetOrder(1))
	If SC6->(DbSeek(xFilial("SC6") + cPedido ))
		While SC6->( !Eof() ) .And. SC6->C6_FILIAL+SC6->C6_NUM == xFilial("SC6") + cPedido
			RecLock("SC6",.F.)
			SC6->C6_WKF1 := "2"
			SC6->C6_WKF2 := "2"
			SC6->C6_WKF3 := "2"
			Msunlock()
			SC6->(DbSkip())
		End
	Endif
	
Endif

RestArea(aAreaSL4)
RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImpTerRet ºAutor  ³Microsiga           º Data ³  17/02/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Imprime Termo de Retirada de Mercadoria.                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//User Function ImpTerRet(cAtende)		//#RVC20180717.o
User Function ImpTerRet(cLoja,cAtende)	//#RVC20180717.n

Local lRet := .F.

If SUA->UA_OPER<>"1"
	MsgStop("Termo de Retira só é possivel realizar a impressão com operação Faturamento","Atenção!")
	Return
Endif

SUB->(DbSetOrder(1))
//If SUB->(DbSeek(xFilial("SUB") + cAtende ))	//#RVC20180717.o
If SUB->(DbSeek(cLoja + cAtende ))				//#RVC20180717.n
	While SUB->(!Eof()) .And. SUB->UB_FILIAL+SUB->UB_NUM == cLoja + cAtende
		If SUB->UB_CONDENT=="1" .And. (SUB->UB_TPENTRE=="1" .Or. SUB->UB_TPENTRE=="2" ) //Estoque + Retirada Posterior
			lRet := .T.
			Exit
		Endif
		SUB->(DbSkip())
	End
Endif

If lRet
	//#RVC20180723.bo
/*	//If MsgYesNO("Este pedido possui Mercadoria(s) para Retirada. Deseja imprimir o Termo de Retirada ?","Atenção")
	U_KMOMSR04(cAtende)   //#CMG20180619.n
	//Endif	*/
	//#RVC20180723.eo

	//#RVC20180723.bn
	If !EMPTY(SUA->UA_01SAC)
		U_KMOMSR04(SUA->UA_01SAC)
	EndIf
	//#RVC20180723.en

Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ITRenunciaºAutor  ³Microsiga           º Data ³  17/02/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Imprime Termo de Renuncia.                   			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ITRenuncia(cAtende)

Local cTabMost 	:= GetMv("MV_SYTABMO",,"003")	//Tabela de Preco de Mostruario
Local lRet 	  	:= .F.

If SUA->UA_OPER<>"1"
	MsgStop("Termo de Renuncia só é possivel realizar a impressão com operação Faturamento","Atenção!")
	Return
Endif

SUB->(DbSetOrder(1))
If SUB->(DbSeek(xFilial("SUB") + cAtende ))
	While SUB->(!Eof()) .And. SUB->UB_FILIAL+SUB->UB_NUM == xFilial("SUB") + cAtende
		
		If SUB->UB_01TABPA==cTabMost
			lRet := .T.
			Exit
		Endif
		
		SUB->(DbSkip())
	End
Endif

If lRet
	//If MsgYesNO("Este pedido possui Mercadoria(s) de Mostruário(s). Deseja imprimir o Termo de Renuncia ?","Atenção")
	U_SYVR104()
	//Endif
Endif

Return