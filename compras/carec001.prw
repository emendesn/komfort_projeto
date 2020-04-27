#Include 'Protheus.ch'
#include "topconn.ch"

/*/{Protheus.doc}  Recalculo Preço de Venda e Custo

Especifico Casa Cenario

@author André Lanzieri
@since 15/01/2015
@version 1.0

/*/
User Function CAREC001()
	Local aArea	:= GetArea()
	Local nTipo := 0 // Tipo de Alteração 1- Fornecedor 2- Categoria
	Private B4_01CAT1 := ""
	Private M->B4_01CAT1 := ""
	Private B4_01CAT2 := ""
	Private M->B4_01CAT2 := ""

	nTipo := CAREC001B()

	If nTipo > 0

		CAREC001C(nTipo)

	EndIf

	RestArea(aArea)

Return

Static Function CAREC001B()
	Local aRet 		:= {}
	Local aParamBox := {}
	Local i 		:= 0
	Local nTipo 	:= 0

	aAdd(aParamBox,{3,"Selecione Tipo",1,{"Fornecedor","Categoria"},50,"",.T.})
	// Tipo 3 -> Radio
	//           [2]-Descricao
	//           [3]-Numerico contendo a opcao inicial do Radio
	//           [4]-Array contendo as opcoes do Radio
	//           [5]-Tamanho do Radio
	//           [6]-Validacao
	//           [7]-Flag .T./.F. Parametro Obrigatorio ?

	If ParamBox(aParamBox,"Parâmetros...",@aRet)

		nTipo := aRet[1]

	Endif

Return(nTipo)

Static Function CAREC001C(nTipo)

	Local aRet 		:= {}
	Local aParamBox := {}
	Local i 		:= 0

	If nTipo == 1

		aAdd(aParamBox,{1,"Fornecedor De"	,Space(TamSx3("A2_COD")[1])	,""		,""	,"SA2"	,".T."	,25	,.F.}) // Tipo caractere
		aAdd(aParamBox,{1,"Fornecedor Até"	,Space(TamSx3("A2_COD")[1])	,""		,""	,"SA2"	,".T."	,25	,.F.}) // Tipo caractere

		aAdd(aParamBox,{1,"Produto De"		,Space(TamSx3("B4_COD")[1])	,""		,"U_VLDCAT1()"	,"SB4"	,".T."	,100	,.F.}) // Tipo caractere
		aAdd(aParamBox,{1,"Produto Até"		,Space(TamSx3("B4_COD")[1])	,""		,""	,"SB4"	,".T."	,100	,.F.}) // Tipo caractere

		aAdd(aParamBox,{1,"Percentual",0,"@E 999.99","","","",20,.F.}) // Tipo numérico

		aAdd(aParamBox,{3,"Tipo",1,{"Acréscimo","Abatimento"},50,"",.T.})

		aAdd(aParamBox,{3,"Atualiza Preço de Venda",1,{"Não","Sim"},50,"",.T.})

	Else

		aAdd(aParamBox,{1,"Categoria 1"	,Space(TamSx3("B4_01CAT1")[1])	,""		,"U_VLDCAT1()"	,"AY0DEP"	,".T."	,100	,.F.}) // Tipo caractere

		aAdd(aParamBox,{1,"Categoria 2"	,Space(TamSx3("B4_01CAT2")[1])	,""		,"U_VLDCAT1()"	,"AY1LIN"	,".T."	,100	,.F.}) // Tipo caractere

		aAdd(aParamBox,{1,"Categoria 3"	,Space(TamSx3("B4_01CAT3")[1])	,""		,"U_VLDCAT1()"	,"AY1SEC"	,".T."	,100	,.F.}) // Tipo caractere

		aAdd(aParamBox,{1,"Produto De"	,Space(TamSx3("B4_COD")[1])	,""		,"U_VLDCAT1()"	,"SB4"	,".T."	,100	,.F.}) // Tipo caractere
		aAdd(aParamBox,{1,"Produto Até"	,Space(TamSx3("B4_COD")[1])	,""		,""	,"SB4"	,".T."	,100	,.F.}) // Tipo caractere

		aAdd(aParamBox,{1,"Markup",0,"@E 999.99","","","",20,.F.}) // Tipo numérico

		aAdd(aParamBox,{3,"Atualiza Preço de Venda",1,{"Não","Sim"},50,"",.T.})

	EndIf

	If ParamBox(aParamBox,"Parâmetros...",@aRet)

		CAREC001D(nTipo,aRet)

	Endif


Return

Static Function CAREC001D(nTipo,aRet)
	Local aHeader 	:= {}
	Local aCols	  	:= {}
	Local bProc		:= {|| PROCESSA( {|| CAREC001E(nTipo,aRet,@aCols) }, "Aguarde, Carregando Dados...") }
	Local aAlter	:= IIF(nTipo ==1, {"CUSNO","PORCE"}, {} )
	Local aSize 	:= MsAdvSize()
	Private lAltPrc	:= IIF(aRet[7] == 1, .F.,.T.)

	Eval(bProc)

	Aadd(aHeader,{"Produto"				,'PROD'		,PesqPict("SB4","B4_COD")		,15  	  ,0	,'.F.'			,'û','C',''	,'' } )
	Aadd(aHeader,{"Descrição"			,'DESC'		,PesqPict("SB1","B1_DESC")		,30		  ,0	,'.F.'			,'û','C',''	,'' } ) // "Descrição"
	Aadd(aHeader,{"Fornecedor"			,'FORN'		,'@!'							,20		  ,0	,'.F.'			,'û','C',''	,'' } )
	Aadd(aHeader,{"Categoria"			,'CATE'		,'@!'							,20		  ,0	,'.F.'			,'û','C',''	,'' } )
	Aadd(aHeader,{"Valor Custo Atual"	,'CUSAT'	,PesqPict("SB1","B1_01CUSTO")	,20		  ,0	,'.F.'	,'û','N',''	,'' } )
	Aadd(aHeader,{"%"					,'PORCE'	,"@E 999.99"					,20		  ,0	,'U_EC002VLD()'			,'û','N',''	,'' } )
	Aadd(aHeader,{"Valor Custo Novo"	,'CUSNO'	,PesqPict("SB1","B1_01CUSTO")	,20		  ,0	,'U_EC001VLD()'			,'û','N',''	,'' } )
	Aadd(aHeader,{"Situação"			,'SITUA'	,'@!'							,20		  ,0	,'.F.'			,'û','C',''	,'' } )
	Aadd(aHeader,{"Valor de Venda"		,'VLRVE'	,PesqPict("SB1","B1_PRV1")		,20		  ,0	,'.F.'			,'û','N',''	,'' } )
	Aadd(aHeader,{"Markup Atual"		,'MKPAT'	,PesqPict("SB4","B4_01MKP")		,20		  ,0	,'.F.'			,'û','N',''	,'' } )
	Aadd(aHeader,{"Markup Novo"			,'MKPNV'	,PesqPict("SB4","B4_01MKP")		,20		  ,0	,'.F.'			,'û','N',''	,'' } )
	/*
	Aadd(aCols,Array(Len(aHeader)+1))

	aCols[Len(aCols)][1] := ""
	aCols[Len(aCols)][2] := ""
	aCols[Len(aCols)][3] := ""
	aCols[Len(aCols)][4] := ""
	aCols[Len(aCols)][5] := ""
	aCols[Len(aCols)][6] := ""
	aCols[Len(aCols)][7] := ""
	aCols[Len(aCols)][8] := ""
	aCols[Len(aCols)][9] := ""
	aCols[Len(aCols)][10] := ""
	aCols[Len(aCols)][11] := ""
	aCols[Len(aCols)][Len(aHeader)+1] := .F.
	*/
	DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Estancia Objeto FWLayer. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oLayer := FWLayer():new()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa o objeto com a janela que ele pertencera. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oLayer:init(oDlg,.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria Linha do Layer. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oLayer:addLine('Lin01',100,.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria a coluna do Layer. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oLayer:addCollumn('Col01',100,.F.,'Lin01')

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Adiciona Janelas as suas respectivas Colunas. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oLayer:addWindow('Col01','L1_Win01','Reajuste de Preços',97,.F.,.F.,,'Lin01',)

	oGetGrade:=MsNewGetDados():New(1,1,1,1,GD_UPDATE,,/*"T_MA06TudOk"*/,"MAREF",aAlter,,999,,,,oLayer:getWinPanel('Col01','L1_Win01','Lin01'),@aHeader,@aCols)
	oGetGrade:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT


	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg , {|| PROCESSA( {|| REC001FIM(oGetGrade,nTipo) }, "Aguarde, Gravando Dados...") , oDlg:End() } , {|| oDlg:End() } ,,)

Return

Static Function CAREC001E(nTipo,aRet,aCols,aHeader)

	Local cQuery 		:= ""
	Local cAlias 		:= GetNextAlias()
	Local _nRec			:= 0

	aCols			:= {}

	If nTipo == 1

		/*
		1 - Fornecedor De   B1_PROC
		2 - Fornecedor Até
		3 - Produto De  	B1_COD
		4 - Produto Até
		5 - Percentual
		6 = Tipo
		7 - Atualiza Preço de Venda
		8 -
		*/

		cQuery	 :=	 " SELECT * FROM "+RetSqlName("SB4")+" SB4 "
		cQUery 	 +=  "LEFT JOIN "+RetSqlName("SB1")+" SB1 ON SB1.D_E_L_E_T_<>'*' "
		cQuery 	 +=  "AND SB4.B4_COD = SB1.B1_01PRODP AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"

		cQuery 	 +=  "WHERE "
		cQuery 	 +=  "SB4.B4_FILIAL = '"+xFilial("SB4")+"' "
		cQuery 	 +=  "AND SB4.D_E_L_E_T_<>'*' "

		If !Empty(aRet[1]) .OR. !Empty(aRet[2])
			cQuery 	 +=  "AND SB4.B4_PROC BETWEEN '"+aRet[1]+"' AND '"+aRet[2]+"' "
		EndIf

		If !Empty(aRet[3]) .OR. !Empty(aRet[4])
			cQuery 	 +=  "AND SB4.B4_COD BETWEEN '"+aRet[3]+"' AND '"+aRet[4]+"' "
		EndIf

		TCQUERY cQuery NEW ALIAS (cAlias)

		Count to _nRec //quantidade registros
		(cAlias)->(DbGotop())

		ProcRegua(_nRec)

		While (cAlias)->(!Eof())

			nPrcVen 		:= 0
			nCustoIpi 		:= 0
			nCustoFrete 	:= 0
			nCustoN    		:= 0

			If aRet[6] == 1
				nCustoN	:= ROund((cAlias)->B1_CUSTD + ((cAlias)->B1_CUSTD * (aRet[5]/100)),2)
			Else
				nCustoN	:= Round((cAlias)->B1_CUSTD - ((cAlias)->B1_CUSTD * (aRet[5]/100)),2)
			EndIf

			nCustoIpi		:= nCustoN * ((cAlias)->B4_IPI/100)

			nCustoFrete		:= (nCustoN + nCustoIpi) * ((cAlias)->B4_01VLFRE/100)

			nPrcVen	:= (nCustoN +nCustoIpi+(cAlias)->B4_01VLMON+(cAlias)->B4_01VLEMB+nCustoFrete+(cAlias)->B4_01ST) * (cAlias)->B4_01MKP

			Aadd(aCols,{ ;
				(cAlias)->B1_COD,;
				(cAlias)->B1_DESC,;
				POSICIONE( "SA2", 1, xFilial("SA2")+(cAlias)->B1_PROC, "A2_NREDUZ" ),;
				POSICIONE( "AY0", 1, xFilial("AY0")+(cAlias)->B1_01CAT3, "AY0_DESC" ),;
				(cAlias)->B1_CUSTD,;
				aRet[5]	,;
				nCustoN ,;
				IIF(aRet[6] == 1,"Acrescimo","Abatimento"),;
				nPrcVen,;
				(cAlias)->B4_01MKP,;
				(cAlias)->B4_01MKP,;
				.F.;
				})

			(cAlias)->(DbSkip())
			IncProc()
		EndDo

		(cAlias)->(dbCloseArea())

	Else
		/*
		1 - Categoria 1
		2 - Categoria 2
		3 - Categoria 3
		4 - Produto De
		5 - Produto Até
		6 - Markup
		7 - Atualiza Preço de Venda
		8 -
		*/

		cQuery	 :=	 " SELECT * FROM "+RetSqlName("SB4")+" SB4 "
		cQUery 	 +=  "LEFT JOIN "+RetSqlName("SB1")+" SB1 ON SB4.D_E_L_E_T_<>'*' "
		cQuery 	 +=  "AND SB4.B4_COD = SB1.B1_01PRODP AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"

		cQuery 	 +=  "WHERE "
		cQuery 	 +=  "SB4.B4_FILIAL = '"+xFilial("SB4")+"' "
		cQuery 	 +=  "AND SB4.D_E_L_E_T_<>'*' "

		If !Empty(aRet[1])
			cQuery 	 +=  "AND SB4.B4_01CAT1 = '"+aRet[1]+"' "
		EndIf

		If !Empty(aRet[2])
			cQuery 	 +=  "AND SB4.B4_01CAT2 = '"+aRet[2]+"' "
		EndIf

		If !Empty(aRet[3])
			cQuery 	 +=  "AND SB4.B4_01CAT3 = '"+aRet[3]+"' "
		EndIf

		If !Empty(aRet[4]) .OR. !Empty(aRet[5])
			cQuery 	 +=  "AND SB4.B4_COD BETWEEN '"+aRet[4]+"' AND '"+aRet[5]+"' "
		EndIf

		TCQUERY cQuery NEW ALIAS (cAlias)

		Count to _nRec //quantidade registros
		(cAlias)->(DbGotop())

		ProcRegua(_nRec)

		While (cAlias)->(!Eof())

			nPrcVen 		:= 0
			nCustoIpi 		:= 0
			nCustoFrete 	:= 0
			nCustoN    		:= 0

			nCustoN	:= (cAlias)->B1_CUSTD

			nCustoIpi		:= nCustoN * ((cAlias)->B4_IPI/100)

			nCustoFrete		:= (nCustoN + nCustoIpi) * ((cAlias)->B4_01VLFRE/100)

			nPrcVen	:= (nCustoN +nCustoIpi+(cAlias)->B4_01VLMON+(cAlias)->B4_01VLEMB+nCustoFrete+(cAlias)->B4_01ST) * aRet[6]

			Aadd(aCols,{ ;
				(cAlias)->B1_COD,;
				(cAlias)->B1_DESC,;
				POSICIONE( "SA2", 1, xFilial("SA2")+(cAlias)->B1_PROC, "A2_NREDUZ" ),;
				POSICIONE( "AY0", 1, xFilial("AY0")+(cAlias)->B1_01CAT3, "AY0_DESC" ),;
				(cAlias)->B1_CUSTD,;
				0	,;
				nCustoN ,;
				IIF(aRet[6] == 1,"Acrescimo","Abatimento"),;
				nPrcVen,;
				(cAlias)->B4_01MKP,;
				aRet[6],;
				.F.;
				})

			(cAlias)->(DbSkip())
			IncProc()
		EndDo

		(cAlias)->(dbCloseArea())

	EndIF

	If Len(aCols) == 0

		Aadd(aCols,Array(12))

		aCols[Len(aCols)][1] := ""
		aCols[Len(aCols)][2] := ""
		aCols[Len(aCols)][3] := ""
		aCols[Len(aCols)][4] := ""
		aCols[Len(aCols)][5] := ""
		aCols[Len(aCols)][6] := ""
		aCols[Len(aCols)][7] := ""
		aCols[Len(aCols)][8] := ""
		aCols[Len(aCols)][9] := ""
		aCols[Len(aCols)][10] := ""
		aCols[Len(aCols)][11] := ""
		aCols[Len(aCols)][12] := .F.

	EndIf

Return

User Function EC001VLD()
	Local nPosPrd	:= Ascan(oGetGrade:aHeader,{|x| AllTrim(Upper(x[2])) == 'PROD'})
	Local nPosVen	:= Ascan(oGetGrade:aHeader,{|x| AllTrim(Upper(x[2])) == 'VLRVE'})
	Local nPerc		:= Ascan(oGetGrade:aHeader,{|x| AllTrim(Upper(x[2])) == 'PORCE'})
	Local nCusPos	:= Ascan(oGetGrade:aHeader,{|x| AllTrim(Upper(x[2])) == 'CUSAT'})
	Local nCustoN	:= M->CUSNO
	Local cProduto	:= oGetGrade:aCols[n][nPosPrd]
	Local nCustoA	:= oGetGrade:aCols[n][nCusPos]
	Local nCustoIpi
	Local nCustoFrete
	Local nPrcVen

	DbSelectArea("SB1")
	DbSetORder(1)

	If DbSeek(xFilial("SB1")+cProduto)
		DbSelectArea("SB4")
		DbSetOrder(1)

		If DbSeek(xFilial("SB4")+SB1->B1_01PRODP)

			nCustoIpi		:= nCustoN * (SB4->B4_IPI/100)

			nCustoFrete		:= (nCustoN + nCustoIpi) * (SB4->B4_01VLFRE/100)

			nPrcVen	:= (nCustoN + nCustoIpi + SB4->B4_01VLMON + SB4->B4_01VLEMB + nCustoFrete + SB4->B4_01ST) * SB4->B4_01MKP

			oGetGrade:aCols[n][nPosVen] := nPrcVen

			oGetGrade:aCols[n][nPerc]	:= ((nCustoN - nCustoA  ) * 100) / nCustoA

		EndIf

	EndIf

Return(.T.)

Static Function REC001FIM(oGetGrade, nTipo)

	Local nPosPrd	:= Ascan(oGetGrade:aHeader,{|x| AllTrim(Upper(x[2])) == 'PROD'})
	Local nPosCus	:= Ascan(oGetGrade:aHeader,{|x| AllTrim(Upper(x[2])) == 'CUSNO'})
	Local nPosVen	:= Ascan(oGetGrade:aHeader,{|x| AllTrim(Upper(x[2])) == 'VLRVE'})
	Local nPerc		:= Ascan(oGetGrade:aHeader,{|x| AllTrim(Upper(x[2])) == 'PORCE'})
	Local nPosMkp	:= Ascan(oGetGrade:aHeader,{|x| AllTrim(Upper(x[2])) == 'MKPNV'})
	Local nX

	ProcRegua(Len(oGetGrade:aCols))

	For nX := 1 to Len(oGetGrade:aCols)
		If !(oGetGrade:aCols[nX][Len(oGetGrade:aCols[nX])])
			If !(oGetGrade:aCols[nX][nPerc] == 0) .OR. nTipo == 2

				DbSelectArea("SB1")
				DbSetOrder(1)

				If DbSeek(xFilial("SB1")+oGetGrade:aCols[nX][nPosPrd])

					RECLOCK("SB1", .F.) // INCLUSÃO(.T.) ALTERAÇÃO(.F.)

					SB1->B1_01CUSTO	:= oGetGrade:aCols[nX][nPosCus]
					SB1->B1_CUSTD	:= oGetGrade:aCols[nX][nPosCus]

					SB1->B1_PRV1    := oGetGrade:aCols[nX][nPosVen]

					//DA1_PRCVEN

					MSUNLOCK()    // Desbloqueia registro

					If lAltPrc

						DbSelectArea("DA1")
						DbSetOrder(1)

						If DbSeek(xFilial("DA1")+AvKey(GetMv("MV_TABPAD"),"DA1_CODTAB")+oGetGrade:aCols[nX][nPosPrd] )

							RECLOCK("DA1", .F.) // INCLUSÃO(.T.) ALTERAÇÃO(.F.)

							DA1->DA1_PRCVEN := oGetGrade:aCols[nX][nPosVen]

							MSUNLOCK()    // Desbloqueia registro
						EndIf

					EndIf

					If nTipo == 2
						DbSelectArea("SB4")
						DbSetOrder(1)

						If DbSeek(xFilial("SB4")+SB1->B1_01PRODP)

							If SB4->B4_01MKP <> oGetGrade:aCols[nX][nPosMkp]
								RECLOCK("SB4", .F.) // INCLUSÃO(.T.) ALTERAÇÃO(.F.)

								SB4->B4_01MKP := oGetGrade:aCols[nX][nPosMkp]

								MSUNLOCK()    // Desbloqueia registro
							EndIf
						EndIf
					EndIf

				EndIf
			EndIf
		EndIf
		IncProc()
	Next nX

	MsgInfo("Valores Reajustados!")

Return

User Function VLDCAT1()

	If ReadVar() == "MV_PAR01"

		M->B4_01CAT1 := &(ReadVar())
		//	B4_01CAT1 := &(ReadVar())
		MV_PAR02 := Space(TamSx3("B4_01CAT2")[1])

	EndIf

	If ReadVar() == "MV_PAR02"

		M->B4_01CAT2 := &(ReadVar())
		//B4_01CAT2 := &(ReadVar())
		MV_PAR03 := Space(TamSx3("B4_01CAT3")[1])

	EndIf

	If ReadVar() == "MV_PAR03"

		MV_PAR04 := Space(TamSx3("B4_COD")[1])

	EndIf

	If ReadVar() == "MV_PAR04"

		MV_PAR05 := Space(TamSx3("B4_COD")[1])

	EndIf

Return(.T.)

User Function EC002VLD()
	Local nPosPrd	:= Ascan(oGetGrade:aHeader,{|x| AllTrim(Upper(x[2])) == 'PROD'})
	Local nPosVen	:= Ascan(oGetGrade:aHeader,{|x| AllTrim(Upper(x[2])) == 'VLRVE'})
	Local nPerc		:= Ascan(oGetGrade:aHeader,{|x| AllTrim(Upper(x[2])) == 'PORCE'})
	Local nCusPos	:= Ascan(oGetGrade:aHeader,{|x| AllTrim(Upper(x[2])) == 'CUSAT'})
	Local nCusNP	:= Ascan(oGetGrade:aHeader,{|x| AllTrim(Upper(x[2])) == 'CUSNO'})
	Local nCustoN	:= 0//Ascan(oGetGrade:aHeader,{|x| AllTrim(Upper(x[2])) == 'CUSNO'})
	Local cProduto	:= oGetGrade:aCols[n][nPosPrd]
	Local nCustoA	:= oGetGrade:aCols[n][nCusPos]
	Local nCustoIpi
	Local nCustoFrete
	Local nPrcVen

	DbSelectArea("SB1")
	DbSetORder(1)

	If DbSeek(xFilial("SB1")+cProduto)
		DbSelectArea("SB4")
		DbSetOrder(1)

		If DbSeek(xFilial("SB4")+SB1->B1_01PRODP)

			nCustoN	:= ROund(SB1->B1_CUSTD + (SB1->B1_CUSTD * (M->PORCE/100)),2)

			nCustoIpi		:= nCustoN * (SB4->B4_IPI/100)

			nCustoFrete		:= (nCustoN + nCustoIpi) * (SB4->B4_01VLFRE/100)

			nPrcVen	:= (nCustoN + nCustoIpi + SB4->B4_01VLMON + SB4->B4_01VLEMB + nCustoFrete + SB4->B4_01ST) * SB4->B4_01MKP

			oGetGrade:aCols[n][nCusNP] := nCustoN

			oGetGrade:aCols[n][nPosVen] := nPrcVen

		EndIf

	EndIf

Return(.T.)