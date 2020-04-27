#include "totvs.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ M410STTS ºAutor  ³ Cristiam Rossi     º Data ³  21/03/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Está em todas as rotinas de alteração, inclusão, exclusão eº±±
±±º          ³ devolução de compras. Executado após todas as alterações noº±±
±±º          ³ no arquivo de pedidos terem sido feitas.                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GLOBAL / KOMFORTHOUSE                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ´±±
±±³ Programador ³ Data   ³ Chamado ³ Motivo da Alteracao                  ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ´±±
±±³Caio Garcia  ³23/01/18³         ³Alteração da chamada do WF            ³±±
±±³#CMG20180123 ³        ³         ³                                      ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M410STTS()		// não passa pelo resíduo (ROTINA)
Local aArea    := getArea()
Local aAreaSC6 := SC6->( getArea() )
Local aItens   := {}
Local cMES     := StrZero( Month( dDatabase ), 2 )
Local cProd
Local nQtd
Local nI
Local nMAXdesc := getMV("GL_MAXDESC")
Local lBloqPV  := .F.

	if SC5->C5_LIBEROK == "S" .and. SC5->C5_NOTA == Repl("X",Len(SC5->C5_NOTA)) .and. empty(SC5->C5_BLQ)	// eliminado por resíduo
		return nil
	endif

	SB1->( dbSetOrder(1) )	// B1_FILIAL+B1_COD

	for nI := 1 to len( aCols )
		cProd  := gdfieldGet("C6_PRODUTO", nI)
		if SB1->( dbSeek( xFilial("SB1")+cProd ) ) .and. SB1->B1_TIPO == "ME"
			nQtd   := gdfieldGet("C6_QTDVEN" , nI)
			nQtd   -= gdfieldGet("C6_XQTD"   , nI)		// abatendo Qtd já registrada no Consumo Médio

//			if ( gdDeleted(nI) .or. gdfieldGet("C6_BLQ",nI) $ "R ;S " ) .and. nQtd > 0
			if ( gdDeleted(nI) .or. ! empty( gdfieldGet("C6_BLQ",nI) ) ) .and. nQtd > 0
				nQtd *= -1
			endif
			if ! INCLUI .and. ! ALTERA	// é exclusão
				nQtd := gdfieldGet("C6_QTDVEN" , nI)
				nQtd *= -1
			endif

			aadd( aItens, { cProd, nQtd } )
		endif
	next

	SB3->( dbSetOrder(1) )	// B3_FILIAL+B3_COD
	for nI := 1 to len(aItens)
		if aItens[nI][2] != 0
			if ! SB3->( dbSeek( xFilial("SB3") + aItens[nI][1] ) )
				recLock("SB3",.T.)
				SB3->B3_FILIAL := xFilial("SB3")
				SB3->B3_COD    := aItens[nI][1]
				SB3->B3_MES    := dDatabase
			else
				recLock("SB3",.F.)
			endif
			&("SB3->B3_Q"+cMES) := &("SB3->B3_Q"+cMES) + aItens[nI][2]
			msUnlock()
		endif
	next
	/*
	SC6->( dbSetOrder(1) )			// atualizando o campo C6_XQTD
	for nI := 1 to len(aCols)
		if SC6->( dbSeek( xFilial("SC6") + SC5->C5_NUM + gdfieldGet("C6_ITEM",nI) + gdfieldGet("C6_PRODUTO",nI) ) )
			if ! gdDeleted(nI) .and. gdfieldGet("C6_DESCONT",nI) > nMAXdesc
				lBloqPV := .T.
			endif
			recLock("SC6", .F.)
			SC6->C6_XQTD := SC6->C6_QTDVEN
			msUnlock()
		endif
	next

	recLock("SC5", .F.)
	SC5->C5_XLIBER  := iif(lBloqPV, 'B', 'L')
	SC5->C5_XLIBUSR := ""
	SC5->C5_XLIBDH  := ""
	msUnlock()

	if lBloqPV		// gerar WF p/ aprovador
		cPara     := superGetMV( "GL_APRMAIL", , "aprendiz_cris@yahoo.com.br" )
		cAssunto  := "WorkFlow de aprovação - desconto do pedido de venda"
		//cMensagem := U_WFintPV( .F., SC5->C5_NUM )//#CMG20180123.o
		U_KMFATF02( .F., SC5->C5_NUM,.T. )//#CMG20180123.n
		//Processa( { || U_sendMail( cPara, cAssunto, cMensagem ) }  ,"Aguarde"   ,"Enviando e-mail...")//#CMG20180123.o
	endif
    */
	//#AFD20180614.bn
	if !INCLUI .and. !ALTERA
		FwMsgRun( ,{|| cancBx(SC5->C5_NUM) }, , "Realizando Cancelamento da baixa do titulo..." )
	endif
	//#AFD20180614.en
	
	SC6->( restArea( aAreaSC6 ) )
	
	restArea( aArea )
return nil


//--------------------------------------------------------------------------|
//	Funtion - cancBx() -> //Cancelamento da Baixa da baixa do titulo	   	| 
//	Uso - Komfort House													   	|
//  By Alexis Duarte - 14/06/2018  											|
//--------------------------------------------------------------------------|
Static Function cancBx(cNumPed)

	Local aArea := getArea()
	Local aBxSE1	:= {}
	Local nOpc		:= 5	// 5 = Cancelamento da Baixa | 6 Exclusão da Baixa
	
	Private lMSErroAuto := .F.

	DbSelectArea("SE1")
    SE1->(dbsetorder(30))
    SE1->(dbgotop())

	SE1->(dbSeek(xFilial() + cNumPed))

    while SE1->E1_PEDIDO == cNumPed 
		if SE1->E1_TIPO == 'NCC'
			
			lMSErroAuto := .F.

			if SE1->E1_VALOR == SE1->E1_SALDO
				msgInfo("O titulo "+ SE1->E1_NUM +" ja encontra-se em Aberto.","ATENÇÃO")
				restArea(aArea)

				Return
			else
				Aadd(aBxSE1,{"E1_PREFIXO" 	,SE1->E1_PREFIXO				, Nil})	// 01. Prefixo do titulo
				Aadd(aBxSE1,{"E1_NUM"     	,SE1->E1_NUM					, Nil})	// 02. Numero do titulo
				Aadd(aBxSE1,{"E1_PARCELA" 	,SE1->E1_PARCELA				, Nil})	// 03. Parcela do titulo
				Aadd(aBxSE1,{"E1_TIPO"    	,SE1->E1_TIPO					, Nil})	// 04. Tipo do titulo
				Aadd(aBxSE1,{"E1_MOEDA"    	,SE1->E1_MOEDA					, Nil})	// 05. Tipo de moeda
				Aadd(aBxSE1,{"E1_TXMOEDA"	,SE1->E1_TXMOEDA				, Nil})	// 06. Taxa de moeda
				Aadd(aBxSE1,{"E1_CLIENTE"	,SE1->E1_CLIENTE				, Nil})	// 07. Codigo do cliente
				Aadd(aBxSE1,{"E1_LOJA"		,SE1->E1_LOJA					, Nil})	// 08. Loja do cliente
				Aadd(aBxSE1,{"E1_SALDO"		,SE1->E1_VALOR					, Nil})	// 09. Valor cancelado
						
				MSExecAuto({|x,y|FINA070(x,y)},aBxSE1,nOpc)
				
				If lMSErroAuto
					msgAlert("Não foi possivel realizar o cancelamento da baixa do titulo "+ SE1->E1_NUM,"ATENÇÃO")
					MostraErro()
				Endif
			
			endif
		endif

	SE1->(dbskip())	
   	end

	restArea(aArea)

Return