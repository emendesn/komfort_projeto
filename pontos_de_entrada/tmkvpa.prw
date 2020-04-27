#INCLUDE "TCBROWSE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"

#DEFINE CRLF 		CHR(10)+CHR(13)

#DEFINE MERCADORIA 	1
#DEFINE DESCONTO	2
#DEFINE	 ACRESCIMO	3
#DEFINE	 FRETE	   	4
#DEFINE	 DESPESA	5
#DEFINE	 BASEDUP	6
#DEFINE	 SUFRAMA	7
#DEFINE	 TOTAL		8

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³	TMKVPA		³ Autor ³ SYMM CONSULTORIA  ³ Data ³ 20/01/06  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Executa a tela com as condicoes de pagamento                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ TeleVendas                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TMKVPA(	aValores		,aObj			,aItens			,cCodPagto		,;
	oCodPagto		,cDescPagto		,oDescPagto		,cCodTransp		,;
	oCodTransp		,cTransp		,oTransp		,cCob			,;
	oCob			,cEnt			,oEnt			,cCidadeC		,;
	oCidadeC		,cCepC			,oCepC			,cUfC			,;
	oUfC			,cBairroE		,oBairroE		,cBairroC		,;
	oBairroC		,cCidadeE		,oCidadeE		,cCepE			,;
	oCepE			,cUfE			,oUfE			,nLiquido		,;
	oLiquido		,nTxJuros		,oTxJuros		,nTxDescon		,;
	oTxDescon		,aParcelas		,oParcelas		,nEntrada		,;
	oEntrada		,nFinanciado	,oFinanciado	,nNumParcelas	,;
	oNumParcelas	,nVlJur			,nOpc			,cNumTlv		,;
	cCliente		,cLoja			,cCodCont		,cCodOper		,;
	cCliAnt         ,lTLVReg)

	Local aArea 	:= GetArea() // Salva a area atual
	Local nCont 	:= 0
	
	MaMtForma(				@aValores		,aObj			,aItens			,cCodPagto		,;
	oCodPagto		,cDescPagto		,oDescPagto		,@cCodTransp	,;
	@oCodTransp		,@cTransp		,@oTransp		,cCob			,;
	oCob			,cEnt			,oEnt			,cCidadeC		,;
	oCidadeC		,cCepC			,oCepC			,cUfC			,;
	oUfC			,cBairroE		,oBairroE		,cBairroC		,;
	oBairroC		,cCidadeE		,oCidadeE		,cCepE			,;
	oCepE			,cUfE			,oUfE			,@nLiquido		,;
	@oLiquido		,@nTxJuros		,@oTxJuros		,@nTxDescon		,;
	@oTxDescon		,@aParcelas		,@oParcelas		,@nEntrada		,;
	@oEntrada		,@nFinanciado	,@oFinanciado	,@nNumParcelas	,;
	@oNumParcelas	,@nVlJur		,nOpc			,cNumTlv		,;
	cCliente		,cLoja			,cCodCont		,cCodOper		,;
	cCliAnt         ,lTLVReg)

	//Ordena o array por datas de pagamento.
	aParcelas := aSort(aParcelas ,,,{|x,y| DTOS(x[1]) < DTOS(y[1])})

	nParcelas   := Len(aParcelas)
	nNumParcelas:= nParcelas

	If nParcelas > 0

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Pega o total da parcela.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nTotalParcela := 0
		For nCont:=1 To nParcelas
			nTotalParcela += Round(aParcelas[nCont][2],2)
		Next nCont

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Carrega a Entrada										³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nEntrada := 0
		For nCont := 1 To nParcelas
			If aParcelas[nCont][1] == dDataBase
				nEntrada += aParcelas[nCont][2]
			EndIf
		Next nCont

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Carrega o valor a ser financiado						³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nFinanciado := 0
		For nCont := 1 TO nParcelas
			If aParcelas[nCont][1] > dDataBase
				nFinanciado += Round(aParcelas[nCont][2],2)
			Endif
		Next nCont

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ajuste da ultima parcela (arredondamento)				³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nLiquido	:= aValores[BASEDUP]
		nResto 		:= nTotalParcela - nLiquido
		If (nResto <> 0) .And. Len(aParcelas) >= (nCont-1)
			aParcelas[nCont-1][2] += nResto
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Incrementa no valor financiado a diferen‡a       	³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nFinanciado > 0
				nFinanciado += Round(nResto,2)
			Endif
		Endif
	Endif
	aValores[TOTAL] := aValores[BASEDUP]

	RestArea(aArea)

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa ³MaMtForma ³ Autor ³                   ³ Data ³ 22/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³ Chama rotina de formas de pagamento.                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MaMtForma(	aValores		,aObj			,aItens			,cCodPagto		,;
	oCodPagto		,cDescPagto		,oDescPagto		,cCodTransp	,;
	oCodTransp		,cTransp		,oTransp		,cCob			,;
	oCob			,cEnt			,oEnt			,cCidadeC		,;
	oCidadeC		,cCepC			,oCepC			,cUfC			,;
	oUfC			,cBairroE		,oBairroE		,cBairroC		,;
	oBairroC		,cCidadeE		,oCidadeE		,cCepE			,;
	oCepE			,cUfE			,oUfE			,nLiquido		,;
	oLiquido		,nTxJuros		,oTxJuros		,nTxDescon		,;
	oTxDescon		,aParcelas		,oParcelas		,nEntrada		,;
	oEntrada		,nFinanciado	,oFinanciado	,nNumParcelas	,;
	oNumParcelas	,nVlJur			,nOpc			,cNumTlv		,;
	cCliente		,cLoja			,cCodCont		,cCodOper		,;
	cCliAnt         ,lTLVReg)

	Local nVlrVenda		:= If(aValores[TOTAL]>0,aValores[TOTAL],aValores[BASEDUP])
	Local cMVCliPad 	:= SuperGetMV("MV_CLIPAD") 				// Cliente padrao
	Local cMVLojaPad	:= SuperGetMV("MV_LOJAPAD")				// Loja Padrao
	Local aPagNew 		:= {}

	Private nSaldoCred	:= 0
	Private nValorCred	:= 0
	Private cDadosCH	:= Space(130)
	Private cDetCH		:= Space(100)
	Private cDetCD		:= Space(100)
	Private cDetCC		:= Space(100)
	Private cDetBol		:= Space(100)
	Private lTelaRA		:= .F.
	Private lEditCpo	:= Empty(M->UA_01SAC)
	Private cUserId	    := __cUserID //#CMG20180608.n
	Private _cGrpCred	:= GetMv("MV_KOGRPLB") //Usuario que poderão liberar de orcamento para faturamento no Call Center //#CMG20180608.n

	If !(Alltrim(cUserId) $ _cGrpCred) //Se não for usuário do crédito executa a rotina

		//Faz a selecao das NCCs a serem usadas.
		If (Alltrim(cMVLojaPad) + Alltrim(cMVCliPad)) <> (Alltrim(M->UA_LOJA) + Alltrim(M->UA_CLIENTE))

			cAlias := GetNextAlias()

			//Tratamento para carregar o valor do credito quando o campo numero do chamado estiver preenchido.
			If !lEditCpo
				cQuery := " SELECT SUM(E1_SALDO) E1_SALDO FROM "+RetSqlName("SE1")+" SE1 (NOLOCK) WHERE E1_CLIENTE = '"+M->UA_CLIENTE+"' AND E1_LOJA = '"+M->UA_LOJA+"' AND E1_01SAC = '"+M->UA_01SAC+"' AND E1_STATUS = 'A' AND E1_TIPO IN ('NCC') AND E1_SALDO > 0 AND E1_XCONFSC <> 'N' AND D_E_L_E_T_ <> '*'  "
			Else
				cQuery := " SELECT SUM(E1_SALDO) E1_SALDO FROM "+RetSqlName("SE1")+" SE1 (NOLOCK) WHERE E1_CLIENTE = '"+M->UA_CLIENTE+"' AND E1_LOJA = '"+M->UA_LOJA+"' AND E1_STATUS = 'A' AND E1_TIPO IN ('NCC','RA') AND E1_SALDO > 0 AND E1_XCONFSC <> 'N' AND D_E_L_E_T_ <> '*'  "
			Endif

			cQuery := ChangeQuery(cQuery)
			DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

			(cAlias)->(DbGotop())
			While (cAlias)->(!Eof())
				nSaldoCred += (cAlias)->E1_SALDO
				(cAlias)->(DbsKIP())
			End
			(cAlias)->( dbCloseArea() )

			If nSaldoCred > 0 .And. M->UA_OPER=="1" .And. (nOpc==3 .Or. nOpc==4)

				If !lEditCpo
					nValorCred := nSaldoCred
				Endif

				DEFINE MSDIALOG oDlgCred FROM  23,80 TO 150,350 TITLE "Créditos do Cliente" PIXEL STYLE DS_MODALFRAME

				@ 010,005 SAY "Créditos em Aberto:" OF oDlgCred PIXEL
				@ 010,055 MSGET nSaldoCred Picture "@E 999,999,999.99" SIZE 45,8  OF oDlgCred PIXEL When .F.

				@ 025,005 SAY "Digite o Valor:" OF oDlgCred PIXEL
				@ 025,055 MSGET nValorCred Picture "@E 999,999,999.99" SIZE 45,8  OF oDlgCred PIXEL When lEditCpo  VALID( VLDCRED(@nValorCred,@nSaldoCred,@nVlrVenda) )  //VALID( If(nValorCred > nSaldoCred,(MsgStop("Valor informado é superior ao valor dos creditos em aberto. Por favor, informe outro valor!"),.F.),.T.) )

				DEFINE SBUTTON FROM 050,075 TYPE 1 ACTION (oDlgCred:End()) ENABLE OF oDlgCred
				DEFINE SBUTTON FROM 050,105 TYPE 2 ACTION ( nValorCred:=0 , oDlgCred:End()) ENABLE OF oDlgCred

				ACTIVATE MSDIALOG oDlgCred CENTERED

			Endif

		Endif
		//nEntrada := nValorCred

		nVlrVenda -= nValorCred                                                           

	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define formas de pagamento.               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aPagNew  := aClone( U_MtForma(	@nVlrVenda														,;
	@aValores		,aObj			,aItens			,cCodPagto		,;
	oCodPagto		,cDescPagto		,oDescPagto		,@cCodTransp	,;
	@oCodTransp		,@cTransp		,@oTransp		,cCob			,;
	oCob			,cEnt			,oEnt			,cCidadeC		,;
	oCidadeC		,cCepC			,oCepC			,cUfC			,;
	oUfC			,cBairroE		,oBairroE		,cBairroC		,;
	oBairroC		,cCidadeE		,oCidadeE		,cCepE			,;
	oCepE			,cUfE			,oUfE			,@nLiquido		,;
	@oLiquido		,@nTxJuros		,@oTxJuros		,@nTxDescon		,;
	@oTxDescon		,@aParcelas		,@oParcelas		,@nEntrada		,;
	@oEntrada		,@nFinanciado	,@oFinanciado	,@nNumParcelas	,;
	@oNumParcelas	,@nVlJur		,nOpc			,cNumTlv		,;
	cCliente		,cLoja			,cCodCont		,cCodOper		,;
	cCliAnt         ,lTLVReg		,nValorCred		,cDetCH			,;
	cDetCC			,cDetCD			,cDetBol		,lTelaRA))


Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa ³ MtForma  ³ Autor ³     			   ³ Data ³ 22/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³ Cria tela para selecao das formas de pagamento.        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MtForma(		nVlrVenda														,;
	aValores		,aObj			,aItens			,cCodPagto		,;
	oCodPagto		,cDescPagto		,oDescPagto		,cCodTransp		,;
	oCodTransp		,cTransp		,oTransp		,cCob			,;
	oCob			,cEnt			,oEnt			,cCidadeC		,;
	oCidadeC		,cCepC			,oCepC			,cUfC			,;
	oUfC			,cBairroE		,oBairroE		,cBairroC		,;
	oBairroC		,cCidadeE		,oCidadeE		,cCepE			,;
	oCepE			,cUfE			,oUfE			,nLiquido		,;
	oLiquido		,nTxJuros		,oTxJuros		,nTxDescon		,;
	oTxDescon		,aParcelas		,oParcelas		,nEntrada		,;
	oEntrada		,nFinanciado	,oFinanciado	,nNumParcelas	,;
	oNumParcelas	,nVlJur			,nOpc			,cNumTlv		,;
	cCliente		,cLoja			,cCodCont		,cCodOper		,;
	cCliAnt         ,lTLVReg		,nValorCred		,cDetCH			,;
	cDetCC			,cDetCD			,cDetBol		,lTelaRA)

	Local xAlias  	:= GetArea()
	Local lRet    	:= .T.
	Local cParc 	:= ""
	Local oForma
	Local cForma	:= ""
	Local aForma    := {}
	Local oDlg
	Local oPanel
	Local oPanel2
	Local oPanel3
	Local oPanel4
	Local oPanel5
	Local oPanel6
	Local oPanel7
	Local oPanel10
	Local oFnt
	Local cCartao	:= ""
	Local aCartao   := {}
	Local oCartao
	Local oVenda
	Local nStyle      := 0
	Local nMoeda 	  := 1
	Local aHeaderPg   := {}
	Local aColsPG     := {}
	Local bGetForma   := {|| ( oTotal:SetFocus() , oGetForma:oBrowse:SetFocus() ) }
	Local bDelForma   := {|| DelForma(@oGetForma,@oTotal,@nTotal,@nVlrVenda,@nValorRes,@oValor,@nValor) }
	Local bVldFim	  := {|| VldFim(@oGetForma,@oTotal,@nTotal,@nVlrVenda,@nValorRes,@oValor,@nValor,@oDlg,@aParcelas,cDetCH,cDetCD,cDetCC,cDetBol,nOpc,lTelaRA) }
	Local bVldSaida   := {|| VldSaida(@oDlg,@oGetForma,@nVlrVenda,@nTotal,@lFinaliza,@aParcelas) }
	Local bVldForma   := {|| VldForma(@nVlrVenda,@nValorRes,nMoeda,@oParc,@cParc,@nValor,@oValor,Substr(cForma,1,3),@oGetForma,cCartao,@oDlg,@oTotal,@nTotal,bVldSaida,@lFinaliza) }
	Local bVldZera	  := {|| VldZera(@nVlrVenda,@nValorRes,nMoeda,@oParc,@cParc,@nValor,@oValor,Substr(cForma,1,3),@oGetForma,cCartao,@oDlg,@oTotal,@nTotal,bVldSaida,@lFinaliza,nOpc,cNumTlv) }
	Local nPosTipo	  := 0
	Local lFinaliza   := .T.
	Local nY
	Local cConsulta	  := ""
	Local nI		  := 0	//#RVC20180709.n
	Local nPosAt	  := 0	//#RVC20180709.n

	Default nValorCred	:= 0
	Default nOpc		:= 3
	Default cNumTlv		:= ""
	Default cDetCH		:= ""
	Default cDetCD		:= ""
	Default cDetCC		:= ""
	Default cDetBol		:= ""
	Default cCliente	:= ""
	Default cLoja		:= ""
	Default aParcelas	:= {}
	Default lTelaRA		:= .T.              

	Private cSoma		:= "00"
	Private nQtdParc	:= GetMv("KH_NUMPARC",,10)
	Private nValorOrig 	:= If(aValores[TOTAL]>0,aValores[TOTAL],aValores[BASEDUP])
	Private nValor		:= If(nValorCred>0,nVlrVenda,nValorOrig)
	Private nValorRes 	:= nVlrVenda
	Private nTotal   	:= 0
	Private nValorParc	:= 0
	Private nVlVenda  	:= nVlrVenda
	Private aRetorno	:= {}
	Private aParc 	    := {}
	Private oValor
	Private oTotal
	Private oGetForma
	Private oParc
	Private ALTERA
	Private cUserId	    := __cUserID //#CMG20180608.n
	Private _cGrpCred	:= GetMv("MV_KOGRPLB") //Usuario que poderão liberar de orcamento para faturamento no Call Center //#CMG20180608.n
	Private _cAdmEsp	:= ""
	Private _cNsu		:= ""	//#RVC20181210.n

	nTotal := If(nOpc<>3,nValor,0)
	aForma := RetFormas(lTelaRA)

	For nY := 1 to nQtdParc
		aadd(aParc, AllTrim(Str(nY))+" Parcela"+IIF(nY > 1,"s",""))
	Next nX

	Aadd(aHeaderPg,{"Vencimento"	,"DATAPG"	,PesqPict("SL1","L1_EMISSAO")	,08	,0,"u_MudaData()","û","D",""," " } )
	Aadd(aHeaderPg,{"Valor"			,"VALOR"	,PesqPict("SL1","L1_VLRLIQ") 	,14	,2,"u_MudaValor()","û","N",""," " } )
	Aadd(aHeaderPg,{"Forma"			,"FORPG"	,"@!" 						  	,03	,0,"u_vldTipo()","û","C",""," " } )
	Aadd(aHeaderPg,{"Descrição"		,"DESC"		,"@!" 						  	,25	,0,/*Valid*/,"û","C",""," " } )
	Aadd(aHeaderPg,{"Complemento"	,"COMPL"	,"@S50"						  	,130,0,/*Valid*/,"û","C",""," " } )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busco os dados do cliente.                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SA1->(DbSetOrder(1))
	If SA1->(DbSeek(xFilial("SA1") + cCliente + cLoja ))
		cEnt		:= SA1->A1_ENDENT
		cBairroE	:= SA1->A1_BAIRROE
		cCidadeE	:= SA1->A1_MUNE
		cCepE		:= SA1->A1_CEPE
		cUfE		:= SA1->A1_ESTE
		cCob		:= SA1->A1_ENDCOB
		cCidadeC	:= SA1->A1_MUNC
		cBairroC	:= SA1->A1_BAIRROC
		cCepC		:= SA1->A1_ESTC
		cUfC		:= SA1->A1_ESTC
	Endif

	If Empty(cCodTransp)
		cCodTransp 	:= SA1->A1_TRANSP
	Else
		cCodTransp 	:= SUA->UA_TRANSP
	Endif
	cTransp := Posicione("SA4",1,xFilial("SA4")+cCodTransp,"A4_NOME")

	If Len(aForma) > 0
		cForma := AllTrim(SubsTr(aForma[1],1,3))
	EndIf	

	SAE->(DbSeek(xFilial("SAE")))
	While SAE->(!Eof()) .and. xFilial("SAE") == SAE->AE_FILIAL
		If Alltrim(SAE->AE_TIPO) == Alltrim(cForma) .And. !Empty(SAE->AE_COD) .AND. SAE->AE_01BLOQ <> "1"
			Aadd( aCartao , SAE->AE_COD + " - " + Capital(SubStr(SAE->AE_DESC,1,25)))
			IF Empty(cCartao)
				cCartao := aCartao[Len(aCartao)]
			EndIF
		EndIf
		SAE->(dbSkip())
	EndDo

	DEFINE FONT oFnt NAME "Arial" SIZE 0,-15 BOLD

	DEFINE MSDIALOG oDlg FROM 0,0 TO 600,600 TITLE "Formas de Pagamento" Of oMainWnd PIXEL STYLE DS_MODALFRAME STATUS

	oPanel:= TPanel():New(0, 0, "", oDlg, NIL, .T., .F., NIL, NIL, 0,22, .T., .F. )
	oPanel:Align:= CONTROL_ALIGN_TOP
	oPanel:NCLRPANE:=-2763063

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Valor da forma de  pagamento.                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ 05, 055 SAY "Valor: " Of oPanel FONT oFnt COLOR CLR_BLACK Pixel SIZE 35,15
	@ 04, 095 MSGET oValor  VAR nValor Of oPanel PICTURE PesqPict("SL1","L1_VLRLIQ") FONT oFnt COLOR CLR_BLACK Pixel SIZE 110,15 VALID ( nValor <= nValorRes ) When If(lTelaRA,.F.,nOpc<>2)

	oPanel2:= TPanel():New(0, 0, "", oDlg, NIL, .T., .F., NIL, NIL, 0,22, .T., .F. )
	oPanel2:Align:= CONTROL_ALIGN_TOP
	oPanel2:NCLRPANE:=-2763063

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Valor da forma de  pagamento.                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ 06, 055 SAY "Forma: " Of oPanel2 FONT oFnt COLOR CLR_BLACK Pixel SIZE 35,15
	@ 05, 095 MSCOMBOBOX oForma VAR cForma Items aForma SIZE 120,15 OF oPanel2 PIXEL FONT oFnt COLOR CLR_BLACK
	oForma:bLostFocus := { || VldCartao(Substr(cForma,1,3),@aParc,@oParc,@cParc,@oCartao,@cCartao,@aCartao) }
	oForma:lActive	  := nOpc<>2

	oPanel3:= TPanel():New(0, 0, "", oDlg, NIL, .T., .F., NIL, NIL, 0,22, .T., .F. )
	oPanel3:Align:= CONTROL_ALIGN_TOP
	oPanel3:NCLRPANE:=-2763063


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cartoes da forma de  pagamento.                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ 06, 055 SAY "Cartão: " Of oPanel3 FONT oFnt COLOR CLR_BLACK Pixel SIZE 35,15
	@ 05, 095 MSCOMBOBOX oCartao VAR cCartao Items aCartao SIZE 120,15 OF oPanel3 PIXEL FONT oFnt COLOR CLR_BLACK
	oCartao:bLostFocus := { || VldParcela(LEFT(ALLTRIM(cCartao),3),cForma) , oParc:Refresh() , oPanel4:REFRESH()}
	oCartao:lActive := nOpc<>2
	
	oPanel4:= TPanel():New(0, 0, "", oDlg, NIL, .T., .F., NIL, NIL, 0,22, .T., .F. )
	oPanel4:Align:= CONTROL_ALIGN_TOP
	oPanel4:NCLRPANE:=-2763063

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Parcelas da forma de  pagamento.                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ 06, 055 SAY "Parcelas: " Of oPanel4 FONT oFnt COLOR CLR_BLACK Pixel SIZE 35,15
	@ 05, 095 MSCOMBOBOX oParc VAR cParc Items aParc SIZE 120,15 OF oPanel4 PIXEL FONT oFnt COLOR CLR_BLACK
	oParc:lActive := .F.

	oPanel7:= TPanel():New(0, 0, "", oDlg, NIL, .T., .T., NIL, NIL, 0,15, .T., .F. )
	oPanel7:Align:= CONTROL_ALIGN_TOP
	oPanel7:NCLRPANE:=12214921

	oConfirma := TButton():New(0,0,"Confirma"	,oPanel7,{ || Eval(bVldForma) } ,0,0,,oFnt,.F.,.T.,.F.,,.F.,,,.F.)
	oConfirma:Align:= CONTROL_ALIGN_ALLCLIENT
	oConfirma:lProcessing := nOpc==2 //Nao sera executado o bloco de codigo Eval(bVldForma)

	oPanel10:= TPanel():New(0, 0, "", oDlg, NIL, .T., .T., NIL, NIL, 0,15, .T., .F. )
	oPanel10:Align:= CONTROL_ALIGN_TOP
	oPanel10:NCLRPANE:=12214921

	oZeraPgto := TButton():New(0,0,"Zera Pagtos",oPanel10,{ || Eval(bVldZera) } ,0,0,,oFnt,.F.,.T.,.F.,,.F.,,,.F.)
	oZeraPgto:Align:= CONTROL_ALIGN_ALLCLIENT
	oZeraPgto:lProcessing := nOpc==2 //Nao sera executado o bloco de codigo Eval(bVldZera)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ ListBox das formas de pagamento.                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oPanel5:= TPanel():New(0, 0, "", oDlg, NIL, .T., .F., NIL, NIL, 0,0, .T., .F. )
	oPanel5:Align:= CONTROL_ALIGN_ALLCLIENT
	oPanel5:NCLRPANE:=-2763063

	//Caso parcelas tiver preenchidas no pedido, carrega no grid.
	CarregaForma(@aColsPG,cNumTlv,@aParcelas,@oTotal,@oValor,@nTotal,@nValor,nValorCred)

	oGetForma:=MsNewGetDados():New(0,0,0,0,GD_UPDATE+GD_DELETE,"Allwaystrue","AllWaysTrue","",{"DATAPG","VALOR","FORPG"},0,9999,,,,oPanel5,@aHeaderPg,@aColsPG)
	oGetForma:oBrowse:Align 	 := CONTROL_ALIGN_ALLCLIENT
	oGetForma:bDelOk 			 := {|| Eval(bDelForma) }
	oGetForma:OBROWSE:BLDBLCLICK := {|| IIF(M->UA_OPER=="1" .OR. lTelaRA,VldCompl( aParcelas, aItens, @cDetCH, @cDetCD, @cDetCC, @cDetBol ),) }

	oPanel6:= TPanel():New(0, 0, "", oDlg, NIL, .T., .F., NIL, NIL, 0,25, .T., .F. )
	oPanel6:Align:= CONTROL_ALIGN_BOTTOM
	oPanel6:NCLRPANE:=-2763063

	@ 03, 005 SAY "Valor da Venda R$: " Of oPanel6 FONT oFnt COLOR CLR_BLACK Pixel SIZE 45,20
	@ 03, 040 MSGET oVenda  VAR nVlrVenda Of oPanel6 PICTURE PesqPict("SL1","L1_VLRLIQ") FONT oFnt COLOR CLR_BLACK Pixel SIZE 65,15 When .F.

	@ 06, 150 SAY "Total R$: " Of oPanel6 FONT oFnt COLOR CLR_BLACK Pixel SIZE 35,20
	@ 03, 195 MSGET oTotal  VAR nTotal Of oPanel6 PICTURE PesqPict("SL1","L1_VLRLIQ") FONT oFnt COLOR CLR_BLACK Pixel SIZE 65,15 When .F.

	oPanel7:= TPanel():New(0, 0, "", oDlg, NIL, .T., .F., NIL, NIL, 0,25, .T., .F. )
	oPanel7:Align:= CONTROL_ALIGN_BOTTOM
	oPanel7:NCLRPANE:=-2763063

	@ 03, 005 SAY "Transportadora: " Of oPanel7 FONT oFnt COLOR CLR_BLACK Pixel SIZE 55,20
	//@ 03, 065 MSGET oCodTransp VAR cCodTransp Of oPanel7 PICTURE PesqPict("SA4","A4_COD") F3 "SA4" 	FONT oFnt COLOR CLR_BLACK Pixel SIZE 45,15 When .T. //#RVC20180322.o
	If !IsInCallStack('TMKA271') //#RVC20180322.bn
		@ 03, 065 MSGET oCodTransp VAR cCodTransp Of oPanel7 PICTURE PesqPict("SA4","A4_COD") F3 "SA4" 	FONT oFnt COLOR CLR_BLACK Pixel SIZE 45,15 When .F.
	Else
		@ 03, 065 MSGET oCodTransp VAR cCodTransp Of oPanel7 PICTURE PesqPict("SA4","A4_COD") F3 "SA4" 	FONT oFnt COLOR CLR_BLACK Pixel SIZE 45,15 When .T.
	Endif						//#RVC20180322.be
	@ 03, 110 MSGET oTransp    VAR cTransp Of oPanel7 PICTURE PesqPict("SA4","A4_NOME") 	FONT oFnt COLOR CLR_BLACK Pixel SIZE 120,15 When .F.
	oCodTransp:bLostFocus := { || cTransp := Posicione("SA4",1,xFilial("SA4")+cCodTransp,"A4_NOME"),oTransp:Refresh() }

	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, { || Eval(bVldFim) }, { || Eval(bVldSaida) })

	RestArea(xAlias)

Return(oGetForma:aCols)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa ³ VldSaida ³ Autor ³     			   ³ Data ³ 22/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³ Valida saida da rotina de forma de pagamento.          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VldSaida(oDlg,oGetForma,nVlrVenda,nTotal,lFinaliza,aParcelas)

	nTotal := 0
	If !Empty( oGetForma:aCols[Len(oGetForma:aCols),2] )
		aEval( oGetForma:aCols , { |x| nTotal += x[2] } )
	Endif

	IF NoRound(nTotal, MsDecimais(1)) == NoRound(nVlrVenda, MsDecimais(1))
		oDlg:End()
	Else
		IF MsgYesNo("As Formas de Pagamento não foram definidas. Deseja Cancelar ? ","Atenção")
			oGetForma:aCols := {}
			aParcelas		:= {}
			lFinaliza 		:= .F.
			oDlg:End()
		EndIF
	EndIF

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa ³ VldForma ³ Autor ³     			   ³ Data ³ 22/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³ Valida a forma de pagamento informada.                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VldForma(nVlrVenda,nValorRes,nMoeda,oParc,cParc,nValor,oValor,cForma,oGetForma,;
	cCartao,oDlg,oTotal,nTotal,bVldSaida,lFinaliza)

	Local nParc     := IIF( Alltrim(cForma) $ "R$|CD|TR|TED|DOC|CR|DC" , 1 , Val(Alltrim(cParc)) )
	Local nVlParc   := nValor
	Local nResto    := nValor
	Local aRet      := {}
	Local lRet 	    := .T.
	Local nDias     := 0
	Local nY
	Local nSoma		:= 0
	Local cCartaoPg := IIF( cForma == "R$|CD|TR|TED|DOC|CR|DC" , "" , cCartao ) 
	Local dDataCH   := dDataBase 
	Local dDtSalto  := dDataBase
	Local dDataBST  := dDataBase
	Local dDataVA	:= dDataBase	//#RVC20180523.n
	Local dUltVenc	:= dDataBase	//#RVC20180523.n
	Local aDtBOL    := {'05 = DIA 05' , '10 = DIA 10' , '15 = DIA 15' , '20 = DIA 20' , '25 = DIA 25' , '30 = DIA 30'}
	lOCAL dDtBOL    := dDataBase  
	Local lFecha    := .F.
	Local _cDia     := "" 			//#CMG20180927.n
	Local _dDtDeb	:= dDataBase	//#RVC20181228.n

	If (Len(aRetorno) > 0 .And. !aRetorno[1]) .And. Alltrim(cForma)=="CHT"
		MsgStop("Esta forma de pagamento não é permitida. Devido ao retorno do Telecheque: "+aRetorno[2],"Atenção")
		lRet := .F.
		Return(lRet)
	Endif

	If Empty(oGetForma:aCols[Len(oGetForma:aCols),2])
		nSoma	:= Len(oGetForma:aCols)-1
	ELse
		nSoma	:= Len(oGetForma:aCols)
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza Combobox das parcelas.                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF Alltrim(cForma) $ "R$|CD|TR|TED|DOC|CR|DC"
		cParc 	:= oParc:aItems[1]
		oParc:nAt:= 1
		oParc:lActive := .F.
	Else
		oParc:lActive := .T.
	EndIF
	oParc:Refresh()

	IF cForma $ "R$" .And. !(Alltrim(oGetForma:aCols[1,3])  $ "R$/  ")

		MsgAlert("A Forma de Pagamento [ " +cForma+ " ] deve ser a 1ª [Primeira] a ser informada.","Atenção")

	ElseIF cForma $ "R$" .And. Ascan( oGetForma:aCols ,{ |x|  x[3] + Alltrim(x[4]) == cForma + Alltrim(cCartaoPg) } ) > 0

		MsgAlert("Esta Forma de Pagamento [ " +cForma+ " ] ja foi informada.","Atenção")

	EndIF

	//#RVC20180709.bn
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Valida se a NSU das parcelas CC e CD estão preenchidas.   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nI := 1 to Len(oGetForma:aCols)
		nPosAt := AT("|",RTRIM(oGetForma:aCols[nI][4]))
		If Alltrim(oGetForma:aCols[nI][3]) $ "BOL|BST"
			Exit
		ElseIf Alltrim(oGetForma:aCols[nI][3]) $ "CD|CC" .AND. nPosAt == 0 .AND. M->UA_OPER == "1"
			MsgAlert("Informar o NSU da(s) parcela(s) inserida(s) antes de informar as demais.","Atenção")
			lRet := .F.
			Return(lRet)
		EndIf
	Next
	//#RVC20180709.en

	If Empty(oGetForma:aCols)
		cSoma := "01"
	Else
		cSoma	:= Soma1(cSoma)
	EndIf

	nValorRes := ( nValorRes - nValor )
	nValor 	  := nValorRes  

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ ID K015 - TELA PARA INFORMAR O VENCIMENTO DO PRIMEIRO CHEQUE - LUIZ EDUARDO F.C. - 06.02.2018 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF cForma $ "CHK/CHT"
		DEFINE DIALOG oDlgOpc TITLE "Data Vencimento 1° Cheque" FROM 0,0 TO 150,300 PIXEL 

		oDlgOpc:LESCCLOSE := .F.  

		@ 005,005 Say "Informe a Data de Vencimento do 1° Cheque : " Size 300,010 Pixel Of oDlgOpc
		@ 020,005 MSGET dDataCH	PICTURE PesqPict('SE1','E1_VENCTO') OF oDlgOpc PIXEL SIZE 050,010  

		@ 050,005 BUTTON "&OK"	SIZE 50,15 OF oDlgOpc PIXEL ACTION {|| (oDlgOpc:End())  } 

		ACTIVATE DIALOG oDlgOpc CENTERED
	EndIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ ID K015 - TELA PARA INFORMAR O VENCIMENTO DO DA PRIMEIRA PARCELA DO BOLETO KOMFORT - LUIZ EDUARDO F.C. - 06.02.2018 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF cForma $ "BOL"                                                       
		While !lFecha                         	
			DEFINE DIALOG oDlgOpc TITLE "Data Vencimento 1° Parcela do Boleto Komfort" FROM 0,0 TO 150,300 PIXEL 

			oDlgOpc:LESCCLOSE := .F.  

//			@ 005,005 Say "Informe a Data de Vencimento do 1° Boleto Komfort : [INFORME SOMENTE OS DIAS 05, 10, 15, 20, 25 OU 30!!!]" Size 300,010 Pixel Of oDlgOpc	//#RVC20181116.o
			@ 005,005 Say "Informe a Data de Vencimento do 1° Boleto Komfort : " Size 300,010 Pixel Of oDlgOpc	//#RVC20181116.n
			@ 010,005 Say "[Permitido somente os dias 05, 10, 15, 20, 25 ou 30]" Size 300,010 Pixel Of oDlgOpc	//#RVC20181116.n
			@ 020,005 MSGET dDtBOL	PICTURE PesqPict('SE1','E1_VENCTO') OF oDlgOpc PIXEL SIZE 050,010  

			@ 050,005 BUTTON "&OK"	SIZE 50,15 OF oDlgOpc PIXEL ACTION {|| IIF(VLDDTBOL(dDtBOL),(oDlgOpc:End(),lFecha:=.T.),lFecha:=.F.) } 

			ACTIVATE DIALOG oDlgOpc CENTERED
		EndDO                             
		
		_cDia := SubsTr(AllTrim(DtoS(dDtBOL)),7,2)
		
	EndIF

	IF nVlParc > 0

		nDias := 0

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Tratamento para jogar os centavos na primeira parcela   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aValParc  := Array(nParc)
		nTotInt	  := 0
		nValParce := NoRound(nVlParc/nParc,2)	//#RVC20181228.o
//		nValParce := NoRound(nVlParc/nParc,3)	//#RVC20181228.n

		For nY := 1 To nParc

			aValParc[nY]:= nValParce			//#RVC20181228.o
//			aValParc[nY]:= NoRound(nValParce,2)	//#RVC20181228.n
			nResto 		-= nValParce			//#RVC20181215.n
			
		Next nY          
		    
		//#RVC20181215.bn
		IF nResto != 0
			aValParc[1] += NoRound(nResto, MsDecimais(1))
		EndIF
		//#RVC20181215.en
		
		For nY := 1 To nParc

			IF oGetForma:aCols[Len(oGetForma:aCols),2] > 0

				Aadd( oGetForma:aCols , { Ctod("") , 0 , Space(03) , Space(25) , Space(130) , cSoma, .F. } )
			EndIF

			If Alltrim(cForma) $ "CC" .AND. nY == 1
				nDias += 30
			EndIf                                   

			If Alltrim(cForma) $ "BST" .AND. nY == 1
				dDataBST := DaySum(dDataBST, 15) 
			EndIF

			If Alltrim(cForma) $ "BOL" .AND. nY == 1
				dDtBOL := dDtBOL
			EndIF

			IF Alltrim(cForma) $ "CHT/CHK" .AND. nY == 1
				dDtSalto := dDataCH

			EndIF
			//#RVC20180523.bn
			IF Alltrim(cForma) $ "VA"// .AND. nY == 1
				dDataVA		:= ValidVenc(dUltVenc)
				dUltVenc	:= dDataVA 
			EndIF
			//#RVC20180523.en 		      

			_dDtDeb := iif(dow(datavalida(dDataBase+1,.T.))==7,datavalida(dDataBase+2,.T.),datavalida(dDataBase+1,.T.))	//#RVC20181228.n

			IF Alltrim(cForma) $ "CD"
//				oGetForma:aCols[Len(oGetForma:aCols),1] := dDataBase+1	//#RVC20181228.o
				oGetForma:aCols[Len(oGetForma:aCols),1] := _dDtDeb		//#RVC20181228.n
			ElseIF Alltrim(cForma) $ "CHT/CHK"
				oGetForma:aCols[Len(oGetForma:aCols),1] := dDtSalto
			ElseIF 	Alltrim(cForma) $ "BST"					
				oGetForma:aCols[Len(oGetForma:aCols),1] := dDataBST 
			ElseIF Alltrim(cForma) $ "BOL"							
				oGetForma:aCols[Len(oGetForma:aCols),1] := dDtBOL
				//#RVC20180523.bn
			ElseIF Alltrim(cForma) $ "VA"
				oGetForma:aCols[Len(oGetForma:aCols),1] := dDataVA
				//#RVC20180523.en 
			Else
				oGetForma:aCols[Len(oGetForma:aCols),1] := dDataBase+nDias
			EndIF
			oGetForma:aCols[Len(oGetForma:aCols),2] := aValParc[nY]
			oGetForma:aCols[Len(oGetForma:aCols),3] := cForma
			oGetForma:aCols[Len(oGetForma:aCols),4] := cCartaoPg

			oGetForma:aCols[Len(oGetForma:aCols),6] := cSoma

//			nResto 	-= oGetForma:aCols[Len(oGetForma:aCols),2]	//#RVC20181215.o

			nDias += 30  

			dDtSalto := MonthSum(dDtSalto,1)
			dDataBST := MonthSum(dDataBST,1)

			If _cDia == '30' 
				
				If SubsTr(DtoS(dDtBOL),5,4) == '0228'
				
					dDtBOL := StoD(SubsTr(DtoS(dDtBOL),1,4)+'0330')
				                                    
				Else
	
					dDtBOL   := MonthSum(dDtBOL,1) 				
	
				EndIf                
			
			Else

				dDtBOL   := MonthSum(dDtBOL,1) 		

			EndIf
				
		Next

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza Diferencas de centavos/divisao.  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//#RVC20181215.bo
/*		IF nResto != 0
			oGetForma:aCols[Len(oGetForma:aCols),2] += NoRound(nResto, MsDecimais(1))
		EndIF
*/		
		//#RVC20181215.eo		
		oGetForma:Refresh()

	EndIF
	nTotal := 0
	aEval( oGetForma:aCols , { |x| nTotal += x[2] } )

	oTotal:Refresh()

	oValor:Refresh()
	oValor:SetFocus()                                      

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ CARREGA O TOTAL DE PARCELAS DAQUELA FORMA DE PAGAMENTO SELECIONADA - LUIZ EDUARDO F.C. - 09.03.20118 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For Nx:=1 To Len(oGetForma:aCols)
		IF LEN(ALLTRIM(oGetForma:aCols[nX,5])) = 0
			oGetForma:aCols[nX,5] := LEFT(ALLTRIM(cParc),2)
		EndIF
	Next

Return(lRet)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ZeraDef   º Autor ³     			     ³ Data ³ 22/08/06    ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Zera as condicoes de pagamento informadas                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function VldZera(nVlrVenda,nValorRes,nMoeda,oParc,cParc,nValor,oValor,xForma,oGetForma,cCartao,oDlg,oTotal,nTotal,bVldSaida,lFinaliza,nOpc,cNumTlv)

	Local nVlrCR := 0

	If !(Alltrim(cUserId) $ _cGrpCred) //Se não for usuário do crédito executa a rotina

		If nOpc==4

			IF MsgYesNo("As Formas de Pagamento já foram definidas. Deseja Cancelar ? ","Atenção")
				DbSelectArea("SL4")
				DbSetOrder(1)
				If DbSeek(xFilial("SL4")+cNumTlv+"SIGATMK ")
					While (!SL4->(Eof())) .AND. (xFilial("SL4") == SL4->L4_FILIAL)  .AND. ;
					(SL4->L4_NUM == cNumTlv) 			.AND. ;
					(AllTrim(SL4->L4_ORIGEM) == "SIGATMK")

						SL4->( RecLock("SL4", .F.) )
						SL4->( DbDelete() )
						SL4->( MsUnLock() )
						SL4->( DbSkip() )
					End
				EndIf
			Else
				Return
			Endif

		Endif

		//#RVC20180720.bn
		For nI := 1 to Len(oGetForma:aCols)
			If Alltrim(oGetForma:aCols[nI][3]) == "CR"
				nVlrCR += oGetForma:aCols[nI][2]
			EndIf
		Next
		//#RVC20180720.en

		aColsPG := {}
		Aadd(aColsPG,{ Ctod("") , 0 , Space(03) , Space(25) , Space(130) , "", .F. } )

		nVlrVenda	+= nVlrCR		//#RVC20180720.n
		nValorRes 	:= nVlrVenda
		nValor		:= nVlrVenda
		_cNSU		:= ""			//#RVC20181210.n
		
		nTotal := 0
		oTotal:Refresh()

		oGetForma:aCols := aClone(aColsPG)
		oGetForma:Refresh()

	EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MudaData  ºAutor  ³                    º Data ³  05/08/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Faz a mudanca automatica da data                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MudaData()

	Local cCampo	:= ReadVar()
	Local nRet		:= 0
	Local nNumParc	:= Len(oGetForma:aCols)
	Local nY
	Local nFORPG	:= aScan(aHeader,{|x| AllTrim(x[2]) == "FORPG"})
	Local nDtFPG	:= aScan(aHeader,{|x| AllTrim(x[2]) == "DATAPG"})	//#RVC20181227.n
	Local aLLDay	:= {}												//#RVC20181227.n
	Local dDtTmp	:= dDataBase										//#RVC20181227.n
    
	//#CMG20180927.bn
//	Local lOK       := .F.					//#RVC20181227.o
    Local lOK       := .T.					//#RVC20181227.n
    Local cMsg		:= ""					//#RVC20181227.n
	Local aDatas    := {5,10,15,20,25,30}

	For nX:=1 To Len(aDatas)
//		IF aDatas[nX] == Day(M->DATAPG)			//#RVC20181227.o
		IF aScan(aDatas,Day(M->DATAPG)) == 0	//#RVC20181227.n
//			lOK := .T.							//#RVC20181227.o
			lOK := .F.							//#RVC20181227.n
			cMsg := "Data Informada Inválida!!! Por favor selecione apenas os dias 5, 10, 15, 20, 25 ou 30" //#RVC20181227.n
			Exit
		EndIf
	Next

	//#RVC20181227.bn
	If lOK .and. aCols[n][nFORPG] $ "BOL"
		For nY := 1 to nNumParc
			If aCols[nY][nFORPG] $ "BOL"
				aAdd(aLLDay,{DtoS(aCols[nY][nDtFPG])})
			endIf
		Next
		
		ASORT(aLLDay, , , { | x,y | x[1] > y[1] } )	//Ordena da última à primeira data do array
		
		dDtTmp := StoD(aLLDay[1][1])
		
		dDtTmp := DaySum(LastDay(DaySum(LastDay(dDtTmp),1)),1)
		
		If M->DATAPG >  dDtTmp
			lOK := .F.
			cMsg := "Data informada superior ao permitido."
		EndIf
	EndIF
	//#RVC20181227.en
	
	If !lOK
//		MsgInfo("Data Informada Inválida!!! Por favor selecione apenas os dias 5, 10, 15, 20, 25 ou 30")  
		MsgInfo(cMsg,"Data Inválida")
		Return .F.
	EndIF
	//#CMG20180927.en
	
//	If aCols[n][nFORPG] $ "BOL/CHT/CHK"		//#RVC20181129.o
	If aCols[n][nFORPG] $ "BOL/CHT/CHK/VA"	//#RVC20181129.n
		IF EMPTY( STOD( DTOS( M->DATAPG ) )) .Or. ( M->DATAPG < ddatabase )
			MsgInfo("Data inválida","Atenção")
			Return .F.
		Endif
	Else
		MsgInfo("Não é permitido alterar a data para esta forma de pagamento!!!!","Atenção")
		Return .F.
	EndIF

Return .T.

User Function MudaValor()

	Local lRet		:= .T.
	Local nPosValor	:= aScan(aHeader,{|x| AllTrim(x[2]) == "VALOR"})     
	Local nFORPG	:= aScan(aHeader,{|x| AllTrim(x[2]) == "FORPG"})
	Local _nz := 0               
	Local _lCr := .F.
	Local _nValCre := 0

	For _nz := 1 To Len(aCols)

		If aCols[_nz][nFORPG] $ "CR"

			_lCr := .T.
			_nValCre += aCols[_nz][nPosValor]

		EndIf

	Next _nz

	If aCols[n][nFORPG] $ "BOL/CH/BST/CHT/CHK"
		If M->VALOR > (nValorRes+aCols[n][nPosValor])
			MsgInfo("Valor inválido!","Atenção")
			lRet	:= .F.
		Else
			nValorRes 	:= (nValorRes+aCols[n][nPosValor]) - M->VALOR
			aCols[n][nPosValor] := M->VALOR
			nTotal		:= 0
			aEval( oGetForma:aCols , { |x| nTotal += x[2] } )


			If _lCr

				nValor	:= (nVlVenda+_nValCre)-nTotal

			Else

				nValor	:= nVlVenda-nTotal

			EndIf

		EndIf
	Else
		MsgInfo("Não é permitido alterar o valor para esta forma de pagamento!!!!","Atenção")
		Return .F.
	EndIf

	oTotal:Refresh()

	oValor:Refresh()
	oValor:SetFocus()

Return(lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa ³RetFormas ³ Autor ³                   ³ Data ³ 22/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³ Retorna as formas de pagamento.                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RetFormas(lTelaRA)

	Local xAlias  	:= GetArea()
	//Local aFormas 	:= {"R$ DINHEIRO"}
	Local aFormas 	:= {}
	Local cFormas	:= "CO;FI;FID"
	Local cRotina	:= Alltrim(FunName())
	Local cPgtoRA	:= ""                                                       
	Local cQuery    := ""

	If Select("TRB1") > 0
		TRB1->(DbCloseArea())
	EndIf

	/*
	BeginSql Alias "TRB1"
	SELECT * FROM %Table:Z02% Z02
	WHERE Z02_FILIAL = XFILIAL("Z02") //%xfilial:Z02%
	AND Z02.%notDel%
	EndSql
	*/                                                         

	cQuery := " SELECT * FROM " + RETSQLNAME("Z02")
	cQuery += " WHERE Z02_FILIAL = '" + XFILIAL("Z02") + "' " 
	cQuery += " AND D_E_L_E_T_ = ' ' "

	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB1",.F.,.T.)

	IF TRB1->(Eof())
		DbSelectArea("Z02")
		RecLock("Z02",.T.)
		Z02->Z02_FILIAL	:= xFilial("Z02")
		Z02->Z02_FORMA 	:= "R$"
		Z02->Z02_BANCO 	:= "CX1"
		Z02->Z02_AGENCI	:= "00001"
		Z02->Z02_NUMCON	:= "0000000001"
		Z02->Z02_OPER	:= "1"
		Msunlock()
		cPgtoRA += Z02->Z02_FORMA+"|"
	Else
		While TRB1->(!Eof())
			cPgtoRA += TRB1->Z02_FORMA+"|"
			TRB1->(DbSkip())
		EndDo
	EndIF
	/*
	DbSelectArea("SX5")
	DbSetOrder(1)
	IF DbSeek(xFilial("SX5")+"24")
	While !Eof() .And. X5_FILIAL+X5_TABELA == xFilial("SX5")+"24"

	IF Alltrim(X5_CHAVE) != "R$" .AND. !(Alltrim(X5_CHAVE) $ cFormas)

	If lTelaRA .And. ( Alltrim(X5_CHAVE) $ cPgtoRA ) .And. cRotina == "TMKA271"
	Aadd( aFormas , Alltrim(X5_CHAVE) + " " + Alltrim(X5_DESCRI) )

	ElseIf lTelaRA .And. cRotina == "LANCRA"
	Aadd( aFormas , Alltrim(X5_CHAVE) + " " + Alltrim(X5_DESCRI) )

	ElseIf !lTelaRA .And. cRotina == "TMKA271"
	Aadd( aFormas , Alltrim(X5_CHAVE) + " " + Alltrim(X5_DESCRI) )

	Endif

	EndIF

	DbSkip()
	EndDo
	EndIF
	*/   

	DbSelectArea("Z02")
	Z02->(DbSetOrder(1))
	Z02->(DbGoTop())
	While Z02->(!Eof())

		//	If Alltrim(Z02->Z02_FORMA) <> 'R$' .And. AllTrim(Z02->Z02_FILIAL) == xFilial("Z02") //#CMG20180423.o
		If AllTrim(Z02->Z02_FILIAL) == xFilial("Z02") //#CMG20180423.n

			If lTelaRA
				
				iF  cFilAnt == '0142'
				
						If Z02->Z02_TPPGTO == '1' .Or. Z02->Z02_TPPGTO == '3'
		
							Aadd( aFormas , Alltrim(Z02->Z02_FORMA) + " " + Subs(Alltrim(Z02->Z02_DESC),1,15) )
		
						EndIf
				
				ElseIf Z02->Z02_TPPGTO == '2' .Or. Z02->Z02_TPPGTO == '3'

					Aadd( aFormas , Alltrim(Z02->Z02_FORMA) + " " + Subs(Alltrim(Z02->Z02_DESC),1,15) )

				EndIf

			Else

				If Z02->Z02_TPPGTO == '1' .Or. Z02->Z02_TPPGTO == '3'

					Aadd( aFormas , Alltrim(Z02->Z02_FORMA) + " " + Subs(Alltrim(Z02->Z02_DESC),1,15) )

				EndIf

			EndIf

		EndIf

		Z02->(DbSkip())

	EndDo


	RestArea(xAlias)

Return(aFormas)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa ³VldCartao ³ Autor ³                   ³ Data ³ 22/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³ Retorna as Administradoras conforma a forma de pagto.  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VldCartao(cForma,aParc,oParc,cParc,oCartao,cCartao,aCartao)

	aCartao  := {}
	cCartao  := ""

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ FAZ TRATAMENTO PARA FILTRAR AS ADMINISTRADORAS QUE ESTEJAM BLOQUEADAS - LUIZ EDUARDO F.C. - 21.12.2017 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SAE->(DbSeek(xFilial("SAE")))
	While SAE->(!Eof()) .and. xFilial("SAE") == SAE->AE_FILIAL
		If cFilAnt == '0142'
			If Alltrim(SAE->AE_TIPO) == Alltrim(cForma) .AND. SAE->AE_COD == "116" 
				Aadd( aCartao , SAE->AE_COD + " - " + Capital(SubStr(SAE->AE_DESC,1,25)))
				IF Empty(cCartao)
					cCartao := aCartao[Len(aCartao)]
				EndIF
			EndIf
			If Alltrim(SAE->AE_TIPO) == Alltrim(cForma) .AND. SAE->AE_COD == "115" 
				Aadd( aCartao , SAE->AE_COD + " - " + Capital(SubStr(SAE->AE_DESC,1,25)))
				IF Empty(cCartao)
					cCartao := aCartao[Len(aCartao)]
				EndIF
			EndIf
		ELSE
			If Alltrim(SAE->AE_TIPO) == Alltrim(cForma) .And. !Empty(SAE->AE_COD) .AND. SAE->AE_01BLOQ <> "1"
				Aadd( aCartao , SAE->AE_COD + " - " + Capital(SubStr(SAE->AE_DESC,1,25)))
				IF Empty(cCartao)
					cCartao := aCartao[Len(aCartao)]
				EndIF
			EndIf
		EndIf
		SAE->(dbSkip())
	EndDo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza Combobox dos cartoes.                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF Len(aCartao) > 0
		oCartao:Show()
	Else
		oCartao:Hide()
	EndIF

	oCartao:aItems := aClone(aCartao)
	oCartao:nAt    := 1
	oCartao:Refresh()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza Combobox das parcelas.                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF Alltrim(cForma) $ "R$|CD|TR|TED|DOC|CR|DC|BRA"
		cParc 	:= oParc:aItems[1]
		oParc:nAt:= 1
		oParc:lActive := .F.
	Else
		oParc:lActive := .T.
	EndIF
	oParc:Refresh()

	IF Len(aCartao) > 0
		oCartao:SetFocus()
	Else
		If oParc:lActive
			oParc:SetFocus()
		Endif
	Endif

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa ³ DelForma ³ Autor ³                   ³ Data ³ 22/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³ Deleta forma de pagamento.                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function DelForma(oGetForma,oTotal,nTotal,nVlrVenda,nValorRes,oValor,nValor)

	Local cForma := ""
	Local nDel   := 0
	Local nPos   := 0

	IF Len(oGetForma:aCols) > 0

		IF MsgYesNo("Apagar esta forma de Pagamento ?","Atenção")
			cForma := AllTrim(oGetForma:aCols[oGetForma:nAt,3])

			While .T.
				nPos := aScan(oGetForma:aCols,{|x| Trim(x[3]) == Trim(cForma)}, 1, Len(oGetForma:aCols)-nDel)
				If nPos > 0
					Adel(oGetForma:aCols, nPos)
					nDel++
				Else
					Exit
				EndIf
			End

			Asize(oGetForma:aCols,Len(oGetForma:aCols)-nDel)

			IF Len(oGetForma:aCols) == 0
				Aadd( oGetForma:aCols , { Ctod("") , 0 , Space(03) , Space(25) , Space(130) , "" , .F. } )
			EndIF
			oGetForma:Refresh()

			nTotal := 0
			aEval( oGetForma:aCols , { |x| nTotal += x[2] } )

			nValorRes	:= ( nVlrVenda - nTotal )
			nValor 		:= nValorRes

			oTotal:Refresh()
			oValor:Refresh()
			oValor:SetFocus()

		EndIF

	EndIF

Return(.F.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa ³ CarregaForma ³ Autor ³               ³ Data ³ 22/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³ Carrega as forma de pagamento                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CarregaForma(aColsPG,cNumTlv,aParcelas,oTotal,oValor,nTotal,nValor,nValorCred)

	Local nPos 		:= 0
	Local nX   		:= 0
	Local lCredito 	:= .T.

	Default ALTERA := .T.

	//====== Tratamento para zerar as formas de pagamento quando operação de orçamento e perfil diferente de televendas.
	//Comentado por Caio - #CMG20180927.n
	/*SU7->(dbSetOrder(1))
	IF SU7->(dbSeek(xFilial("SU7")+SUA->UA_OPERADO))
	If SU7->U7_TIPOATE <> "2"
	ALTERA := .T.
	EndIF
	Endif*/

	If nValorCred > 0 .And. lCredito
		Aadd(aColsPG,{ dDatabase , nValorCred , "CR" , Space(25) , Space(130) , "", .F. })
		nValorParc += nValorCred
	EndIf

	nValorParc := 0
	DbSelectArea("SL4")
	DbSetOrder(1)
	If DbSeek(xFilial("SL4")+cNumTlv + "SIGATMK")
		While (!SL4->(Eof())) .AND. (xFilial("SL4") == SL4->L4_FILIAL) .AND. (SL4->L4_NUM == cNumTlv) .AND. (AllTrim(SL4->L4_ORIGEM) == "SIGATMK")

			Aadd( aColsPG , { Ctod("") , 0 , Space(03) , Space(25) , Space(130) , "",.F. } )
			nPos := Len(aColsPG)

			aColsPG[nPos,1] := SL4->L4_DATA
			aColsPG[nPos,2] := SL4->L4_VALOR
			aColsPG[nPos,3] := LEFT(SL4->L4_FORMA,TAMSX3("L4_FORMA")[1])
			aColsPG[nPos,4] := SL4->L4_OBS
			aColsPG[nPos,5]	:= SL4->L4_XPARC	//			aColsPG[nPos,5]	:= "" //#RVC20181004.n
			aColsPG[nPos,6] := .F.

			nValorParc += SL4->L4_VALOR

			SL4->(DbSkip())
		End
		aColsPG := aSort(aColsPG ,,,{|x,y| x[3]+DTOS(x[1]) < y[3]+DTOS(y[1])})

	Else

		If Len(aParcelas) > 0 .And. !Empty(aParcelas[1][1])

			For nX := 1 To Len(aParcelas)

				Aadd( aColsPG , { Ctod("") , 0 , Space(03) , Space(25) , Space(130) , "", .F. } )
				nPos := Len(aColsPG)

				aColsPG[nPos,1] := aParcelas[nX][1]
				aColsPG[nPos,2] := aParcelas[nX][2]
				aColsPG[nPos,3] := aParcelas[nX][3]
				aColsPG[nPos,4] := aParcelas[nX][4]
				aColsPG[nPos,5] := ""
				aColsPG[nPos,6] := .F.

				nValorParc += aParcelas[nX][2]
			Next

			aColsPG := aSort(aColsPG ,,,{|x,y| x[3]+DTOS(x[1]) < y[3]+DTOS(y[1])})
		Endif

	Endif

	//TRATAMENTO PARA ZERAR AS FORMAS DE PAGAMENTO QUANDO HOUVER ALTERACAO DE VALOR E A OPERAÇÃO FOR UM ORÇAMENTO.
	If !(Alltrim(cUserId) $ _cGrpCred) //Se não for usuário do crédito executa a rotina

		//	If ALTERA .And. SUA->UA_OPER=="2" //.And. (nValor <> nValorParc)	//#RVC20180820.o
		If ALTERA .And. SUA->UA_OPER=="2" .AND. Empty(SUA->UA_NUMSC5)		//#RVC20180820.n
			/*If MsgYesNo("Apagar a(s) forma(s) de Pagamento ?","Atenção")
			If MsgYesNo("Tem Certeza ?","Atenção")
			DbSelectArea("SL4")
			DbSetOrder(1)
			If DbSeek(xFilial("SL4")+cNumTlv+"SIGATMK ")
			While (!SL4->(Eof())) .AND. (xFilial("SL4") == SL4->L4_FILIAL)  .AND. (SL4->L4_NUM == cNumTlv) .AND. (AllTrim(SL4->L4_ORIGEM) == "SIGATMK")
			SL4->( RecLock("SL4", .F.) )
			SL4->( DbDelete() )
			SL4->( MsUnLock() )
			SL4->( DbSkip() )
			End
			EndIf
			//aColsPG := {}
			//Aadd(aColsPG,{ Ctod("") , 0 , Space(03) , Space(25) , Space(130) , "", .F. } )

			If nValorCred > 0 .And. lCredito .And. nValor <> nValorParc .And. Len(aColsPG) > 0
			aColsPG := {}
			Aadd(aColsPG,{ dDatabase , nValorCred , "CR" , Space(25) , Space(130) , "", .F. })
			nValorParc += nValorCred
			EndIf
			EndIf

			EndIf*///#CMG20180927.o - Comentado para não perguntar, pois o registro estava bloqueado e nunca apagava
			If nValorCred > 0 .And. lCredito .And. nValor <> nValorParc .And. Len(aColsPG) > 0
				aColsPG := {}
				Aadd(aColsPG,{ dDatabase , nValorCred , "CR" , Space(25) , Space(130) , "", .F. })
				nValorParc += nValorCred
			EndIf
			
		EndIF

	EndIf
	
	IF NoRound((nValorParc-nValorCred), MsDecimais(1)) == NoRound(nValor, MsDecimais(1))
		nTotal 	  := nValor
		nValor 	  := 0
		nValorRes := 0
		//oTotal:Refresh()
		oValor:Refresh()
	Endif

	If Len(aColsPG) == 0
		If nValorCred > 0 .And. lCredito
			Aadd(aColsPG,{ dDatabase , nValorCred , "CR" , Space(25) , Space(130) , "", .F. })
		Else
			Aadd(aColsPG,{ Ctod("") , 0 , Space(03) , Space(25) , Space(130) , "", .F. } )
		Endif
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa ³    VldFim    ³ Autor ³               ³ Data ³ 22/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³ Confirma a operacao e carrega as variaveis             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VldFim(oGetForma, oTotal, nTotal, nVlrVenda, nValorRes, oValor, nValor, oDlg, aParcelas, cDetCH, cDetCD, cDetCC, cDetBol, nOpc,lTelaRA)

	Local nX
	Local cMsg		:= ""
	Local lRet		:= .T.
	Local aDados 	:= {}
	Local _lBol     := .F. //#CMG20180607.n

	If nValorRes <> 0 .And. nOpc==3
		cMsg := "As Formas de Pagamento ainda não foram definidas totalmente."
		lRet := .F.
	Endif

	If lRet

		//#CMG20180607.bn - Verifica se tem boleto no pagamento
		If !lTelaRA

			For nX := 1 to Len(oGetForma:aCols)

				Aadd(aParcelas,{ oGetForma:ACOLS[nX][1] , oGetForma:ACOLS[nX][2] , oGetForma:ACOLS[nX][3] , oGetForma:ACOLS[nX][4] + "  " + oGetForma:ACOLS[nX][5] , 111, ""  })
				nPos := Len(aParcelas)

//				If Alltrim(aParcelas[nPos,03]) $ "BOL/BST" .And. M->UA_OPER=="1"		//#RVC20181116.o
				If Alltrim(aParcelas[nPos,03]) $ "BOL/BST/CH" .And. M->UA_OPER=="1"		//#RVC20181116.n
					_lBol := .T.

				EndIf

			Next nX

		EndIf
		//#CMG20180607.en

		aParcelas := {}
		For nX := 1 to Len(oGetForma:aCols)

			Aadd(aParcelas,{ oGetForma:ACOLS[nX][1] , oGetForma:ACOLS[nX][2] , oGetForma:ACOLS[nX][3] , oGetForma:ACOLS[nX][4] + "  " + oGetForma:ACOLS[nX][5] , 111, ""  })
			nPos := Len(aParcelas)
			/*------------------------------------------------------------------------------------#AFD20180517.bo
			If Alltrim(aParcelas[nPos,03])=="CHT"
			//If Empty(aParcelas[nPos,04])	//cDetCH
			//cMsg := "É necessário informar o dados do cheque."
			//lRet := .F.
			//Exit
			//Endif

			aDados := Separa(aParcelas[nPos,04],"|")

			IF M->UA_OPER=="1" .OR. lTelaRA
			If Len(aDados) == 1
			cMsg := "É necessário informar o dados do cheque."
			lRet := .F.
			Exit
			Endif
			EndIF

			ElseIf Alltrim(aParcelas[nPos,03])=="CHK"

			//If Empty(aParcelas[nPos,04])	//cDetCH
			//cMsg := "É necessário informar o dados do cheque."
			//lRet := .F.
			//Exit
			//Endif

			aDados := Separa(aParcelas[nPos,04],"|")

			IF M->UA_OPER=="1" .OR. lTelaRA
			If Len(aDados) == 1
			cMsg := "É necessário informar o dados do cheque."
			lRet := .F.
			Exit
			Endif
			EndIF

			ElseIf Alltrim(aParcelas[nPos,03])=="CD"

			If Alltrim(aParcelas[nPos,03])=="CD"
			aDados := Separa(aParcelas[nPos,04],"|")

			IF M->UA_OPER=="1" .OR. lTelaRA
			If Len(aDados) == 1
			cMsg := "É necessário informar o NSU do cartão de debito."
			lRet := .F.
			Exit
			Endif
			EndIF

			ElseIf Alltrim(aParcelas[nPos,03])=="CC"
			aDados := Separa(aParcelas[nPos,04],"|")

			IF M->UA_OPER=="1" .OR. lTelaRA
			If Len(aDados) == 1
			cMsg := "É necessário informar o NSU do cartão de crédito."
			lRet := .F.
			Exit
			Endif
			EndIF
			-----------------------------------------------------------------------------------------  #AFD20180517.eo */
			//ElseIf Alltrim(aParcelas[nPos,03]) $ "BOL/BST" .and. M->UA_PEDPEND == '2' //#AFD20180517.o
			If Alltrim(aParcelas[nPos,03]) $ "BOL/BST" .and. M->UA_PEDPEND == '2' //#AFD20180521.n
				aDados := Separa(aParcelas[nPos,04],"|")

				IF M->UA_OPER=="1" .OR. lTelaRA
					If Len(aDados)==1 .Or. Len(aDados)==0 .Or. Empty(aDados[2])
						cMsg := "É necessário informar o CR do boleto bancário."
						lRet := .F.
						Exit
					Endif
				EndIF

			ElseIf !(lTelaRA) .And. !(_lBol) .And. M->UA_OPER=="1"

				aDados := Separa(aParcelas[nPos,04],"|")        

				If Alltrim(aParcelas[nPos,03]) $ "CC|CD"
					If Len(aDados)==1 .Or. Len(aDados)==0 .Or. Empty(aDados[2])
						cMsg := "É necessário informar o NSU do cartão."
						lRet := .F.
						Exit
					Endif
				ElseIf Alltrim(aParcelas[nPos,03]) $ "CHK/CHT"
					If Len(aDados)==1 .Or. Len(aDados)==0 .Or. Empty(aDados[2])
						cMsg := "É necessário informar o número do cheque."
						lRet := .F.
						Exit
					Endif
				EndIF

			Else

				aDados := Separa(aParcelas[nPos,04],"|")

				IF  lTelaRA
					If Alltrim(aParcelas[nPos,03]) $ "BOL|BST"
						If Len(aDados)==1 .Or. Len(aDados)==0 .Or. Empty(aDados[2])
							cMsg := "É necessário informar o CR do boleto bancário."
							lRet := .F.
							Exit
						Endif
					ElseIf Alltrim(aParcelas[nPos,03]) $ "CC|CD"
						If Len(aDados)==1 .Or. Len(aDados)==0 .Or. Empty(aDados[2])
							cMsg := "É necessário informar o NSU do cartão."
							lRet := .F.
							Exit
						Endif
					ElseIf Alltrim(aParcelas[nPos,03]) $ "CHK/CHT"
						If Len(aDados)==1 .Or. Len(aDados)==0 .Or. Empty(aDados[2])
							cMsg := "É necessário informar o número do cheque."
							lRet := .F.
							Exit
						Endif
					EndIF
				EndIf

			Endif

			/*----------------------------------------------------------------------------------------#AFD20180517.bo
			IF M->UA_OPER=="1" .OR. lTelaRA
			// Armazenar o CMC7 em arquivo temporário - Cristiam Rossi em 18/07/2017
			if Alltrim(aParcelas[nPos,03]) $ "CHT/CHK"
			_NumCheq := separa(aParcelas[nPos,04], "|")[4]
			_CMC7    := separa(oGetForma:ACOLS[nX][5], "|")[1]

			if M->UA_NUM == NIL //#AFD20180503.n
			memowrite("\CALL_CENTER_"+cFilAnt+"\TMKVPA_"+cFilAnt+"_000000_"+ALLTRIM(_NumCheq)+".TXT", ALLTRIM(_CMC7))//#AFD20180503.n
			else//#AFD20180503.n
			memowrite("\CALL_CENTER_"+cFilAnt+"\TMKVPA_"+cFilAnt+"_"+M->UA_NUM+"_"+ALLTRIM(_NumCheq)+".TXT", ALLTRIM(_CMC7))
			endif//#AFD20180503.n
			endif
			EndIF
			-----------------------------------------------------------------------------------------  #AFD20180517.bo */

		Next nX

	Endif

	If lRet

		if IsInCallStack("U_ALTFRMPG")//#AFD20180517.n

			nPos := aScan(aParcelas,{|x| Alltrim(x[3]) == "CHT"})
			If nPos > 0

				IF M->UA_OPER=="1"	.OR. lTelaRA
					If MsgYesNO("Deseja realizar a consulta do(s) cheque(s) no Telecheque S/N?","Atenção")
						FwMsgRun( ,{|| aRetorno := U_SYTM002(oGetForma:aCols,M->UA_CLIENTE,M->UA_LOJA,M->UA_CODCONT) }, , "Por favor, aguarde consultando dados do cheque..." )
					Else
						aRetorno := {.T.,"APROVADO - COMPRA AUTORIZADA!"}
					Endif

					If aRetorno[1] //Aprovado
						MsgInfo(aRetorno[2],"Atenção")
						oDlg:End()
					Else
						MsgInfo(aRetorno[2],"Atenção")

						aSize(aRetorno, 0)
						lRet := .F.
						return lRet			// adição por Cristiam Rossi em 13/07/2017 - solicitação pra não apagar os dados

						nValor 			:= If(nValorCred>0,nVlrVenda,nValorOrig)
						nValorRes 		:= nVlrVenda
						aParcelas		:= {}
						oGetForma:aCols	:= {}

						If nValorCred > 0
							Aadd( oGetForma:aCols , { dDatabase , nValorCred , "CR" , Space(25) , Space(130), "" , .F. })
						Else
							Aadd( oGetForma:aCols , { Ctod("") , 0 , Space(03) , Space(25) , Space(130), "" , .F. } )
						Endif

						oGetForma:Refresh()
						oValor:Refresh()

					Endif
				Else
					oDlg:End()
				EndIF

			Else
				oDlg:End()
			Endif
		else //#AFD20180517.n
			oDlg:End() //#AFD20180517.n
		endif //#AFD20180517.n
	Else
		MsgInfo(cMsg,"Atenção")
	Endif

Return(lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ VldCompl ³ Autor ³                       ³ Data ³08/01/02  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Tela de complemento da parcela de acordo com a Forma       ³±±
±±³          ³ de pagamento escolhida                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VldCompl( aParcelas, aItens, cDetCH, cDetCD, cDetCC, cDetBol )

	Local cCMC7		:=SPACE(30),oCMC7			//CMC7
	Local cPraca	:=SPACE(3),oPraca			//Praca de Compensacao
	Local cBanco 	:=SPACE(3),oBanco			//Banco
	Local cAgencia	:=SPACE(5),oAgencia			//Agencia
	Local cConta 	:=SPACE(10),oConta			//Conta
	Local cCheque 	:=SPACE(15),oCheque			//Cheque
	//Local cRg 		:=SPACE(14),oRg				//RG //#AFD20180517.o
	Local cCpf 		:=SPACE(14),oCpf				//CPF //#AFD20180517.n
	Local cFone 	:=SPACE(15),oFone			//Telefone
	Local cDig1		:=SPACE(1),oDig1			//Digito 1
	Local cDig2		:=SPACE(1),oDig2			//Digito 2
	Local cDig3		:=SPACE(1),oDig3			//Digito 3
	Local cDtAbert	:=SPACE(7),oDtAbert			//Data de Abertura da conta
	Local aCheque	:= {}

	Local aSAE    	:={}						//Array com as Administradoras cadastradas
	Local cComboAdm	:=SPACE(20),oComboAdm		//Administradora
	Local cCartao	:=SPACE(20),oCartao			//Dados do cartao
	Local dDtValid 	:=SPACE(07),oDtValid		//CTOD("  /  /  "),oDtValid	//Data de validade
	//Local cAutor	:=SPACE(6),oAutor			//Codigo de autorizacao
	Local cAutor    := Space(GetSx3Cache("E1_NSUTEF","X3_TAMANHO")),oAutor
	Local cCard4	:= Space(GetSx3Cache("E1_XNCART4","X3_TAMANHO")),oCard4	//#RVC20180602.n
	Local cFlag		:= Space(GetSx3Cache("E1_XFLAG","X3_TAMANHO")),oFlag	//#RVC20180602.n
	Local aFlag  := {"","MASTERCARD", "VISA", "ELO", "AMERICAN EXPRESS", "HIPER", "HIPERCARD", "ALELO","OUTROS"}
	Local aCartao	:= {}

	Local oDlg									//Tela
	Local nPos 		:= 0                        //Posicao
	Local lCheckBox	:=.F.,oCheckBox				//Checkbox
	Local cDetalhe	:= SPACE(80)				//Detalhe
	Local nOpca 	:= 0						//Opcao de escolha OK ou CANCELA
	Local lShowDlg  := .T.						//Flag para exibicao da tela dos dados complementares
	Local nLinha	:= oGetForma:NAT			//Linha selecionada no browse
	Local nContx    := 0
	Local cFormaPag := ""
	Local cTipo 	:= Alltrim(oGetForma:aCols[nLinha][3])
	//Local lHabilita := .T.//#AFD20180517.o
	Local lHabilita := .F.	//#AFD20180517.n
	Local lHabCheque := .T. //#AFD20180517.n
	Local lMarkAll	:= .T.	//#AFD20180521.n

	//#AFD20180517.bn
	if IsInCallStack("U_ALTFRMPG")
		lHabilita := .T.
	endif
	//#AFD20180517.en

	Private cDadosCH := Space(130)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se for a vista n„o tem informa‡”es complementares			    	  ³
	//³Se estiver usando TEF nao tem informacoes complementares para CC e CH  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (cTipo == "CC" .OR. cTipo == "CHT" .Or. cTipo == "CD" .Or. cTipo == "BOL" .Or. cTipo == "CHK" .Or. cTipo == "BST" ) .OR. ("$" $ cTipo) .OR. !(cTipo $ "CDCCVAFICOCH")
		lShowDlg := .T.
	Endif

	If lShowDlg
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Se for pagamento em CHEQUE					     					  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (cTipo == "CHT" .Or. cTipo == "CHK")

			lMarkAll := .F. //#AFD20180521.n

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Se o valor digitado anteriormente n„o foi em CHEQUE limpo o complemento³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cDetalhe := UPPER(Alltrim(oGetForma:aCols[nLinha][5]))

			If !Empty(cDetalhe)
				aCheque := Separa(cDetalhe,"|")
			Endif

			//		If Len(aCheque) > 0 //#RVC20180329.o
			If Len(aCheque) > 1 
				cCMC7	:= aCheque[1]
				cPraca	:= aCheque[2]
				cBanco	:= aCheque[3]
				cAgencia:= aCheque[4]
				cDig1	:= aCheque[5]
				cConta	:= aCheque[6]
				cDig2	:= aCheque[7]
				cCheque	:= aCheque[8]
				cDig3	:= aCheque[9]
				cDtAbert:= aCheque[10]
				cRg		:= aCheque[11]
				cFone	:= aCheque[12]
			Endif

			DEFINE MSDIALOG oDlg FROM 10,20 TO 400,450 TITLE "Complemento da Parcela" PIXEL STYLE DS_MODALFRAME

			@05,10 SAY "CMC7" OF oDlg PIXEL
			@05,47 MSGET oCMC7 VAR cCMC7 Picture "999999999999999999999999999999" VALID NaoVazio(cCMC7) SIZE 100,8 OF oDlg PIXEL When lHabilita RIGHT
			oCMC7:bLostFocus := { || CarregaCpos(cCMC7,@cBanco,@oBanco,@cAgencia,@oAgencia,@cPraca,@oPraca,@cCheque,@oCheque,@cConta,@oConta) }

			@20,10 SAY "Praca"  OF oDlg PIXEL
			@20,47 MSGET oPraca VAR cPraca Picture "999" VALID NaoVazio(cPraca) SIZE 40,8 PIXEL OF oDlg When lHabilita RIGHT

			@35,10 SAY "Banco" OF oDlg PIXEL
			//		@35,47 MSGET oBanco VAR cBanco Picture "999" VALID NaoVazio(cBanco) SIZE 40,8 PIXEL OF oDlg When lHabilita RIGHT 
			@35,47 MSGET oBanco VAR cBanco Picture "999" VALID NaoVazio(cBanco) SIZE 40,8 PIXEL OF oDlg When lHabCheque RIGHT

			@50,10 SAY "Agencia" OF oDlg PIXEL
			//		@50,47 MSGET oAgencia VAR cAgencia Picture "99999" VALID NaoVazio(cAgencia) SIZE 40,8 PIXEL OF oDlg When lHabilita RIGHT
			@50,47 MSGET oAgencia VAR cAgencia Picture "99999" VALID NaoVazio(cAgencia) SIZE 40,8 PIXEL OF oDlg When lHabCheque RIGHT

			@50,130 SAY "Digito 1" OF oDlg PIXEL
			@50,167 MSGET oDig1 VAR cDig1 Picture "9" VALID NaoVazio(cDig1) SIZE 15,8 PIXEL OF oDlg When lHabilita RIGHT

			@65,10 SAY "Conta" OF oDlg PIXEL
			//		@65,47 MSGET oConta VAR cConta Picture "9999999999" VALID NaoVazio(cConta) SIZE 60,8 PIXEL OF oDlg When lHabilita RIGHT
			@65,47 MSGET oConta VAR cConta Picture "9999999999" VALID NaoVazio(cConta) SIZE 60,8 PIXEL OF oDlg When lHabCheque RIGHT

			@65,130 SAY "Digito 2" OF oDlg PIXEL
			@65,167 MSGET oDig2 VAR cDig2 Picture "9" VALID NaoVazio(cDig2) SIZE 15,8 PIXEL OF oDlg When lHabilita RIGHT

			@80,10 SAY "Cheque" OF oDlg PIXEL
			//		@80,47 MSGET oCheque VAR cCheque Picture "999999999999999" VALID NaoVazio(cCheque) SIZE 60,8 PIXEL OF oDlg When lHabilita RIGHT
			@80,47 MSGET oCheque VAR cCheque Picture "999999999999999" VALID NaoVazio(cCheque) SIZE 60,8 PIXEL OF oDlg When lHabCheque RIGHT

			@80,130 SAY "Digito 3" OF oDlg PIXEL
			@80,167 MSGET oDig3 VAR cDig3 Picture "9" VALID NaoVazio(cDig3) SIZE 15,8 PIXEL OF oDlg When lHabilita RIGHT

			@95,10 SAY "Cliente desde" OF oDlg PIXEL
			@95,47 MSGET oDtAbert VAR cDtAbert Picture "99/9999" VALID NaoVazio(cDtAbert) SIZE 40,8 PIXEL OF oDlg When lHabilita RIGHT

			//@110,10 SAY "RG" OF oDlg PIXEL //#AFD20180517.o
			//@110,47 MSGET oRg VAR cRg Picture "@R 99.999.999.999" VALID NaoVazio(cRg) SIZE 60,8 PIXEL OF oDlg When lHabilita RIGHT //#AFD20180517.o

			@110,10 SAY "CPF" OF oDlg PIXEL  //#AFD20180517.n
			@110,47 MSGET oCpf VAR cCpf Picture "@R 999.999.999-99" VALID NaoVazio(cCpf) SIZE 60,8 PIXEL OF oDlg When lHabilita RIGHT //#AFD20180517.n

			@125,10 SAY "Telefone" OF oDlg PIXEL
			@125,47 MSGET oFone VAR cFone  Picture "@R (99) 99999-9999" VALID NaoVazio(cFone) SIZE 60,8 PIXEL OF oDlg When lHabilita RIGHT

			//@148,10 CHECKBOX oCheckBox VAR lCheckBox PROMPT "Aplica em todas as parcelas" SIZE 90,10 OF oDlg PIXEL //#AFD20180521.o
			@148,10 CHECKBOX oCheckBox VAR lCheckBox PROMPT "Aplica em todas as parcelas" SIZE 90,10 OF oDlg When lMarkAll PIXEL //#AFD20180521.n

			DEFINE SBUTTON FROM 168,130 TYPE 1 ACTION (nOpca := 1,oDlg:End()) ENABLE OF oDlg

			DEFINE SBUTTON FROM 168,167 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg

			// Desabilita a tecla ESC
			oDlg:LESCCLOSE := .F.

			ACTIVATE MSDIALOG oDlg CENTER

			If nOpcA == 1
				//cDetalhe := cBanco +"|"+ cAgencia +"|"+ cConta +"|"+ cCheque +"|"+ cRg +"|"+ cFone +"|"+ cTipo
				//cDetalhe := cBanco +"|"+ cAgencia +"|"+ cConta +"|"+ cCheque +"|"+ cRg +"|"+ cFone +"|"+ cTipo +"|"+LEFT(UPPER(Alltrim(oGetForma:aCols[nLinha][4])),3) // ALTERADO PARA GRAVAR O CODIGO DO SAE NO CASO DO CHEQUE - luiz eduardo f.c. - 31/08/2018 //#AFD20180517.o
				//cDadosCH := cCMC7+"|"+cPraca+"|"+cBanco+"|"+cAgencia+"|"+cDig1+"|"+cConta+"|"+cDig2+"|"+cCheque+"|"+cDig3+"|"+cDtAbert+"|"+cRg+"|"+cFone //#AFD20180517.o
				cDetalhe := cBanco +"|"+ cAgencia +"|"+ cConta +"|"+ cCheque +"|"+ cCpf +"|"+ cFone +"|"+ cTipo +"|"+LEFT(UPPER(Alltrim(oGetForma:aCols[nLinha][4])),3) // ALTERADO PARA GRAVAR O CODIGO DO SAE NO CASO DO CHEQUE - luiz eduardo f.c. - 31/08/2018 //#AFD20180517.n
				//cDadosCH := cCMC7+"|"+cPraca+"|"+cBanco+"|"+cAgencia+"|"+cDig1+"|"+cConta+"|"+cDig2+"|"+cCheque+"|"+cDig3+"|"+cDtAbert+"|"+cCpf+"|"+cFone //#AFD20180517.n

				cDetCH   := cDetalhe
			Endif

			If !Empty(cCheque)
				nAux := VAL(cCheque)
			Else
				nAux := 0
			EndIf

		ElseIf (cTipo == "CC" .Or. cTipo == "CD" .Or. cTipo == "BOL" .Or. cTipo == "BST")

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Se o valor digitado ou gravado anteriormente n„o foi em CARTAO limpo o complemento³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//cDetalhe := UPPER(Alltrim(oGetForma:aCols[nLinha][4])) //#AFD20180516.o

			If !Empty(cDetalhe)
				aCartao := Separa(cDetalhe,"|")
			Endif

			If Len(aCartao) > 1
				//cAutor := SPACE(6)
				cAutor := Space(GetSx3Cache("E1_NSUTEF","X3_TAMANHO"))
				If Len(aCartao) > 1
					cAutor := aCartao[1]
				Else
					cAutor := aCartao[2]
				Endif
			Endif

			//		DEFINE MSDIALOG oDlg FROM 10,20 TO 150,300 TITLE "Complemento da Parcela" PIXEL STYLE DS_MODALFRAME	//#RVC20180602.o
			DEFINE MSDIALOG oDlg FROM 10,20 TO 160,300 TITLE "Complemento da Parcela" PIXEL STYLE DS_MODALFRAME	//#RVC20180602.n

			// PARA AS FORMAS DE PAGAMENTO ABAIXO TRAZER MARCADO O CHECK
			//		IF cTipo$ "CC|CD|BOL|BST"	//#RVC20180628.o	
			IF cTipo$ "BOL|BST"			//#RVC20180628.n
				lCheckBox := .T.
			Else
//				lCheckBox := .T.	//#RVC20180628.o
				lCheckBox := .F.	//#RVC20180628.n
			EndIF

			lHabilita := .T. //#AFD20180517.n

			@05,10 SAY "Autorizacao" OF oDlg PIXEL
//			@05,57 MSGET oAutor  VAR cAutor Picture "@!"  SIZE 60,8 PIXEL OF oDlg When lHabilita VALID U_VLDIGNSU(cAutor)	//#RVC20181210.o
			@05,57 MSGET oAutor  VAR cAutor Picture "@!"  SIZE 60,8 PIXEL OF oDlg When lHabilita VALID VLDIGNSU(cAutor)		//#RVC20181210.n

			//#RVC20180607.bo			
			/*		@20,10 SAY "Cartao ****.****.****." OF oDlg PIXEL
			@20,57 MSGET oCard4  VAR cCard4 Picture "@!"  SIZE 60,8 PIXEL OF oDlg WHEN If(cTipo$"CC|CD",lHabilita,.F.) //VALID VAZIO()
			@35,10 SAY "Bandeira" OF oDlg PIXEL
			@35,57 MSGET oFlag  VAR cFlag Picture "@!"  SIZE 60,8 PIXEL OF oDlg WHEN If(cTipo$"CC|CD",lHabilita,.F.) //VALID VAZIO()*/
			//#RVC20180607.eo

			//#RVC20180607.bn
			@20,10 SAY "Cartão(4 Ult. Dig.)" OF oDlg PIXEL
			//		@20,57 MSGET oCard4  VAR cCard4 Picture "@!"  SIZE 60,8 PIXEL OF oDlg WHEN If(cTipo$"CC|CD",lHabilita,.F.) VALID !Empty(cCard4)		//#RVC20180622.o
//			@20,57 MSGET oCard4  VAR cCard4 Picture "@!"  SIZE 60,8 PIXEL OF oDlg WHEN If(cTipo$"CC|CD",lHabilita,.F.) VALID U_VLDCARD(cCARD4)			//#RVC20180622.n	//#RVC20181210.o
			@20,57 MSGET oCard4  VAR cCard4 Picture "@!"  SIZE 60,8 PIXEL OF oDlg WHEN If(cTipo$"CC|CD",lHabilita,.F.) VALID VLDCARD(cCARD4)								//#RVC20181210.n
			@35,10 SAY "Bandeira" OF oDlg PIXEL
//			@35,57 MSCOMBOBOX oFlag VAR cFlag ITEMS aFlag SIZE 60,8 PIXEL OF oDlg WHEN If(cTipo$"CC|CD",lHabilita,.F.) VALID !Empty(cFlag)VLDFLAG
//			@35,57 MSCOMBOBOX oFlag VAR cFlag ITEMS aFlag SIZE 60,8 PIXEL OF oDlg WHEN If(cTipo$"CC|CD",lHabilita,.F.) VALID U_VLDFLAG(_cAdmEsp,cFlag)	//#RVC20181210.o
			@35,57 MSCOMBOBOX oFlag VAR cFlag ITEMS aFlag SIZE 60,8 PIXEL OF oDlg WHEN If(cTipo$"CC|CD",lHabilita,.F.) VALID VLDFLAG(_cAdmEsp,cFlag)	//#RVC20181210.n
			//#RVC20180607.en

//			@20,10 CHECKBOX oCheckBox VAR lCheckBox PROMPT "Aplica em todas as parcelas" SIZE 90,10 OF oDlg PIXEL WHEN If(cTipo$"CC|CD|BOL|BST",lHabilita,.F.)	//#RVC20180602.o		
//			@50,10 CHECKBOX oCheckBox VAR lCheckBox PROMPT "Aplica em todas as parcelas" SIZE 90,10 OF oDlg PIXEL WHEN If(cTipo$"CC|CD|BOL|BST",lHabilita,.F.)	//#RVC20181017.o
			@50,10 CHECKBOX oCheckBox VAR lCheckBox PROMPT "Aplica em todas as parcelas" SIZE 90,10 OF oDlg PIXEL WHEN If(cTipo$"CC|BOL|BST",lHabilita,.F.)		//#RVC20181017.n


			//Confirmacao - Botao de Ok
			//		DEFINE SBUTTON FROM 35,075 TYPE 1 ACTION (IIF( If(cTipo=="CC",(!Empty(cAutor)),.T.),(nOpca:= 1,oDlg:End()),nil)) ENABLE OF oDlg	//#RVC20180602.o
			//		DEFINE SBUTTON FROM 60,075 TYPE 1 ACTION (IIF( If(cTipo=="CC",(!Empty(cAutor)),.T.),(nOpca:= 1,oDlg:End()),nil)) ENABLE OF oDlg	//#RVC20180602.n	//#RVC20180622.o
			DEFINE SBUTTON FROM 60,075 TYPE 1 ACTION (IIF( If(cTipo $ "CC|CD",(!Empty(cAutor)) .AND. (!Empty(cCard4)) .AND. (!Empty(cFlag)),.T.),(nOpca:= 1,oDlg:End()),nil)) ENABLE OF oDlg	//#RVC20180622.n

			//		DEFINE SBUTTON FROM 35,105 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg	//#RVC20180602.o
			DEFINE SBUTTON FROM 60,105 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg	//#RVC20180602.n

			// Desabilita a tecla ESC
			oDlg:LESCCLOSE := .F.

			ACTIVATE MSDIALOG oDlg CENTER

			If nOpcA == 1
				nPos := at("|",UPPER(Alltrim(oGetForma:aCols[nLinha][4]))+"|"+cAutor+"|"+cTipo) //#AFD20180516.n
				cPos4 := substr(UPPER(Alltrim(oGetForma:aCols[nLinha][4]))+"|"+cAutor+"|"+cTipo,1,nPos-1)//#AFD20180516.n

				//cDetalhe := UPPER(Alltrim(oGetForma:aCols[nLinha][4]))+"|"+cAutor+"|"+cTipo //#AFD20180516.o
				//			cDetalhe := UPPER(cPos4)+"|"+cAutor+"|"+cTipo //#AFD20180516.n				  //#RVC20180603.o
				cDetalhe := UPPER(cPos4)+"|"+cAutor+"|"+cTipo+"|"+cCard4+"|"+UPPER(Alltrim(cFlag))	  //#RVC20180603.n

				If cTipo == "CC"
					cDetCC  := cDetalhe
				ElseIf cTipo == "CD"
					cDetCD  := cDetalhe
				ElseIf cTipo == "BOL"
					cDetBol := cDetalhe
				ElseIf cTipo == "BST"
					cDetBol := cDetalhe				
				Endif
			Endif
		Endif

	Else
		nOpca := 1
	Endif

	If nOpca == 1
		If lCheckBox

			cIgual	:= oGetForma:ACOLS[nLinha, Len(oGetForma:ACOLS[nLinha])-1]

			For nPos := 1 TO Len(oGetForma:ACOLS)

				If Alltrim(oGetForma:ACOLS[nPos][3])=="CR"
					Loop
				Endif

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifico se a parcela e igual a parcela preenchida e se nao 			   ³
				//³e a primeira, pois o numero sequencial dos cheques e a partir da segunda³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If (Alltrim(oGetForma:ACOLS[nPos][3]) == "CHT") .And. cTipo == "CHT"

					If (nPos > 1)
						nAux ++
					Endif

					//cDetalhe := cBanco +"|"+ cAgencia +"|"+ cConta +"|"+ StrZero(nAux,Len(cCheque)) +"|"+ cRg +"|"+ cFone +"|"+ cTipo+"|"+LEFT(UPPER(Alltrim(oGetForma:aCols[nPos][4])),3) //#20180517.o
					cDetalhe := cBanco +"|"+ cAgencia +"|"+ cConta +"|"+ StrZero(nAux,Len(cCheque)) +"|"+ cCpf +"|"+ cFone +"|"+ cTipo+"|"+LEFT(UPPER(Alltrim(oGetForma:aCols[nPos][4])),3) //#20180517.n
					oGetForma:ACOLS[nPos,4]	:= cDetalhe
					oGetForma:ACOLS[nPos,5]	:= cDadosCH

				ElseIf (Alltrim(oGetForma:ACOLS[nPos][3]) == "CHK") .And. cTipo == "CHK"

					If (nPos > 1)
						nAux ++
					Endif

					//cDetalhe := cBanco +"|"+ cAgencia +"|"+ cConta +"|"+ StrZero(nAux,Len(cCheque)) +"|"+ cRg +"|"+ cFone +"|"+ cTipo+"|"+LEFT(UPPER(Alltrim(oGetForma:aCols[nPos][4])),3) //#20180517.o
					cDetalhe := cBanco +"|"+ cAgencia +"|"+ cConta +"|"+ StrZero(nAux,Len(cCheque)) +"|"+ cCpf +"|"+ cFone +"|"+ cTipo+"|"+LEFT(UPPER(Alltrim(oGetForma:aCols[nPos][4])),3) //#20180517.n
					oGetForma:ACOLS[nPos,4]	:= cDetalhe
					//oGetForma:ACOLS[nPos,5]	:= cDadosCH

				ElseIf (Alltrim(oGetForma:ACOLS[nPos][3]) == "CC" ) .And. cTipo == "CC" .AND. (Alltrim(oGetForma:ACOLS[nPos][Len(oGetForma:ACOLS[nPos])-1]) == AllTrim(cIgual) )

					oGetForma:ACOLS[nPos,4] := cDetalhe

				ElseIf (Alltrim(oGetForma:ACOLS[nPos][3]) == "CD" ) .And. cTipo == "CD"

					oGetForma:ACOLS[nPos,4] := cDetalhe

				ElseIf (Alltrim(oGetForma:ACOLS[nPos][3]) == "BOL" ) .And. cTipo == "BOL"

					oGetForma:ACOLS[nPos,4] := cDetalhe

				ElseIf (Alltrim(oGetForma:ACOLS[nPos][3]) == "BST" ) .And. cTipo == "BST"

					oGetForma:ACOLS[nPos,4] := cDetalhe

				Endif

			Next nPos

		Else

			nPos := Ascan( oGetForma:ACOLS, { |x| Alltrim(x[3]) == cTipo } )
			If nPos > 0
				//oGetForma:ACOLS[nLinha,3] := oGetForma:ACOLS[nPos][2]	//Forma de pagamento
				oGetForma:ACOLS[nLinha,4] := cDetalhe					//Detalhes
				//			oGetForma:ACOLS[nLinha,5] := cDadosCH					//Detalhes	//#RVC20180711.o
				//#RVC20180711.bn
				//If cTipo $ "CHT|CHK"
				//	oGetForma:ACOLS[nLinha,5] := cDadosCH					//Detalhes
				//EndIf
				//#RVC20180711.en
			Endif

		Endif

	Endif
	oGetForma:Refresh()

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa ³ CarregaCpos ³ Autor ³                ³ Data ³ 20/09/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³ Carrega os campos a partir da digitacao do CMC7.       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CarregaCpos(cCMC7,cBanco,oBanco,cAgencia,oAgencia,cPraca,oPraca,cCheque,oCheque,cConta,oConta)

	If !Empty(cCMC7)

		cBanco:= Substr(cCMC7,1,3)
		oBanco:Refresh()

		cAgencia:= Substr(cCMC7,4,4)
		oAgencia:Refresh()

		cPraca:= Substr(cCMC7,9,3)
		oPraca:Refresh()

		cCheque:= Substr(cCMC7,12,6)
		oCheque:Refresh()

		//	cConta:= Substr(cCMC7,23,10)			// Cristiam Rossi em 13/07/2017
		cConta:= left(right(alltrim(cCMC7),7),6)
		oConta:Refresh()

	Endif

Return
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa ³ VldParcela  ³ Autor ³ LUIZ EDUARDO F.C. ³ Data ³ 20/09/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³ Carrega a quantidade de pacelas de acordo com o SAE       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
STATIC FUNCTION VldParcela(cCartao,cForma)

	Local nQtd := 1
	Local nMin := 1

	aParc := {}

	IF LEFT(ALLTRIM(cForma),2) $ "CC/BS" // TRATAR BOLETO BST
		DbSelectArea("SAE")
		DbSetOrder(1)
		IF DbSeek(xFilial("SAE") + cCartao)
			nQtd := SAE->AE_PARCATE
			nMin := SAE->AE_PARCDE
		Else
			nQtd := 10
			nMin := 1
		EndIF
	Else
		nQtd := 10
		nMin := 1
	EndIF

	IF nMin = 0
		nMin := 1
	EndIF

	For nX:=nMin To nQtd
		aadd(aParc, AllTrim(Str(nX))+" Parcela"+IIF(nX > 1,"s",""))
	Next

	oParc:AITEMS := aParc
	
	_cAdmEsp := cCartao
	
RETURN()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa ³   VLDCRED   ³ Autor ³ LUIZ EDUARDO F.C. ³ Data ³ 22/08/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³ VALIDA OS CREDITOS DIGITADOS                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
STATIC FUNCTION VLDCRED(nValorCred,nSaldoCred,nVlrVenda)

	Local lVldCred := .T.

	If nValorCred > nSaldoCred
		MsgStop("Valor informado é superior ao valor dos creditos em aberto. Por favor, informe outro valor!") 
		lVldCred := .F.
	ElseIF nValorCred > nVlrVenda
		MsgStop("Valor informado é superior ao valor total da venda. Por favor, informe outro valor!")
		lVldCred := .F.
	EndIF

RETURN(lVldCred)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa ³   VLDCRED   ³ Autor ³ LUIZ EDUARDO F.C. ³ Data ³ 06/02/18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³ VALIDA DATA DIGITADA PARA VCTO. DO PRIMEIRO BOLETO        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
STATIC FUNCTION VLDDTBOL(dDtBOL)

	Local lOK       := .F.    
	Local aDatas    := {5,10,15,20,25,30}
	Local _nDiasBol := SUPERGETMV("KH_DIASBOL", .T., 45) //#CMG20180604.n

	If dDtBOL < dDataBase
		MsgInfo("Não é possivel selecionar data de vencimento retroativa, por favor escolha outra data!")
		lOk := .F.
	Else
		For nX:=1 To Len(aDatas)
			IF aDatas[nX] = Day(dDtBOL)
				lOK := .T.
				Exit
			EndIF
		Next

		If lOK
			IF DateDiffDay(dDataBase,dDtBOL) > _nDiasBol
//				MsgInfo("Data de Vencimento Informada maior que 30 dias, por favor escolha outra data!")
				MsgInfo("Data de Vencimento Informada maior que " + cValToChar(_nDiasBol) + " dia(s), por favor escolha outra data!")
				lOk := .F.
			EndIF  

			IF DateDiffDay(dDataBase,dDtBOL) < 15
				MsgInfo("Data de Vencimento Informada menor do que 15 dias, por favor escolha outra data!")
				lOk := .F.
			EndIF  		
		Else
			MsgInfo("Data Informada Inválida!!! Por favor selecione apenas os dias 5, 10, 15, 20, 25 ou 30")  
			lOk := .F.
		EndIF
	EndIF

RETURN(lOK)

Static Function ValidVenc(dDtVenc)

	Local nDias 	:= 0
	Local nDiaFolh	:= SuperGetMv("KH_DFECFLH",.F.,20) //#RVC20180523.n

	If Day(dDtVenc) >= nDiaFolh
		dDtTmp := DaySum(LastDay(DaySum(LastDay(dDtVenc),1)),1)
	Else
		dDtTmp := DaySum(LastDay(dDtVenc),1)
	EndIf			

	While nDias < 5
		If DataValida(dDtTmp,.T.) == dDtTmp 
			nDias++
		EndIf
		dDtTmp := DaySum(dDtTmp,1)
	EndDo

Return dDtTmp

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VLDIGNSU                                 Data ³  30/01/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validação Do NSU digitado, para minimizar os erros         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Shoebiz                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function VLDIGNSU(cChr)

Local lRet    	:= .T.
Local cCodBloq 	:= GetMv("MV_NSUBLOQ",,"000000000000|           |111111111111|222222222222|333333333333|444444444444|555555555555|666666666666|777777777777|888888888888|999999999999|123456789012")

Default cChr	:= ""

If Empty(cChr) .Or. cChr == ""
//  MsgAlert("O NSU digitado é inválido. Digite o NSU CORRETAMENTE!!!")	//Alterado por Eduardo Clemente - 27/06/14 //#RVC20180622.o
  MsgStop("O NSU em branco. Digite o NSU.")	//#RVC20180622.n
  lRet := .F.     
//If Substr(UPPER(cChr),1,6) $ cCodBloq .OR. Len(cChr) < 6			//#RVC20180622.o
ElseIf Substr(UPPER(cChr),1,6) $ cCodBloq .OR. Len(Alltrim(cChr)) < 6	//#RVC20180622.n
//  MsgAlert("O NSU digitado é inválido. Digite o NSU CORRETAMENTE!!!")	//#RVC20180622.o  
  MsgStop("O NSU digitado é inválido. Digite o NSU CORRETAMENTE!!!")	//#RVC20180622.n
  lRet := .F.      
EndIF

//#RVC20181210.bn
If (Empty(_cNsu) .or. _cNsu == "") .and.  (!Empty(cChr) .or. cChr <> "")
	_cNsu := cChr + "|"
Else
	If cChr $ _cNsu
		MsgStop("NSU já informado")
		lRet := .F.
	Else
		_cNsu := _cNsu + cChr + "|"
	EndIf
EndIf
//#RVC20181210.en

//Verifica cada Caracter
//**********************
/*For x := 1 To Len(cChr)

	If !(Asc(Substr(cChr,x,1)) > 47 .And. Asc(Substr(cChr,x,1)) < 58).And.; //Verifica se existe Numeros
	      !(Asc(Substr(cChr,x,1)) == 32) //Verifica se existe Espaco

		MsgAlert("O caracter " + Substr(cChr,x, 1) + " não é permitido neste campo.")
		x    := Len(cChr)
		lRet := .F.

    EndIf

Next x*/

Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VLDCARD                                  Data ³  22/06/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validação Do CARTÃO digitado, para minimizar os erros      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Komfort                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function VLDCARD(cCARD)

Local lRet    	:= .T.
Default cCARD	:= ""

If Empty(cCARD) .Or. cCARD = ' '
  MsgStop("Campo em branco. Informar Cartão.")
  lRet := .F. 
ElseIf Len(Alltrim(cCARD)) < 4	
  MsgStop("Tamanho Inválido. Mínimo 4.")  
  lRet := .F.          
EndIF

Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VLDFLAG         	                       Data ³  16/11/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validação Do CARTÃO digitado, para minimizar os erros      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Komfort                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function VLDFLAG(cADM,cFLAG)

Local lRet    	:= .T.
Local cCodEsp	:= SuperGetMV("KH_ADMESPC",.T.,"112")
Local cDescAdm1	:= ""
Local cDescAdm2	:= ""

Default cFLAG	:= ""

cDescAdm1 := GetAdvFVal("SAE","AE_DESC",xFilial("SAE") + cADM ,1,"OPERADORA1")
cDescAdm2 := GetAdvFVal("SAE","AE_DESC",xFilial("SAE") + cCodEsp,1,"OPERADORA2")

If Empty(cFLAG) .Or. cFLAG = ' '
	MsgStop("Campo em branco. Informar Bandeira.")
	lRet := .F. 
ElseIf cFLAG $ "AMERICAN EXPRESS|HIPER|HIPERCARD" .AND. !cADM $ cCodEsp
	MsgStop("AMEX/HIPER não permitido para "+ Alltrim(cADM) + " - " + Alltrim(cDescAdm1) + "." + chr(13) + chr(10) + "Utilizar a opção " + Alltrim(cCodEsp) + " - " + Alltrim(cDescAdm2) + ".")
	lRet := .F.          
EndIF

Return lRet


User Function vldtipo()

	MsgInfo("Não é permitido alterar o tipo da forma de pagamento!!!!","Atenção")

Return .F.
