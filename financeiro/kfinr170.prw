#INCLUDE "FINR170.CH"
#INCLUDE "PROTHEUS.CH"

Static lFWCodFil := .T.

// 17/08/2009 - Compilacao para o campo filial de 4 posicoes
// 18/08/2009 - Compilacao para o campo filial de 4 posicoes

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FINR170  � Autor �Marcel Borges Ferreira � Data � 15/08/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Rela��o de Borderos para cobranca / pagamentos             ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � FINR170                                                    ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
USER FUNCTION KFINR170()

If TRepInUse()
	//������������������������������������������������������������������������Ŀ
	//�Interface de impressao                                                  �
	//��������������������������������������������������������������������������
	Finr170R4()
Else
	FINR170R3()
EndIf

Return
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FINR170  � Autor �Marcel Borges Ferreira � Data � 15/08/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Rela��o de Borderos para cobranca / pagamentos             ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � FINR170                                                    ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
STATIC FUNCTION Finr170R4()

Local oReport

oReport:=ReportDef()
oReport:PrintDialog()

Return

/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������ͻ��
���Programa  � ReportDef � Autor � Marcel Borges Ferreira � Data �  15/08/06  ���
�����������������������������������������������������������������������������͹��
���Descricao � Definicao do objeto do relatorio personalizavel e das          ���
���          � secoes que serao utilizadas.                                   ���
�����������������������������������������������������������������������������͹��
���Parametros� 													                        ���
�����������������������������������������������������������������������������͹��
���Uso       � 												                           ���
�����������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/
Static Function ReportDef()

Local oReport
Local cReport 	:= "FINR170" 				// Nome do relatorio
Local cDescri 	:= STR0001 +;       		//"Este programa tem a fun��o de emitir os borderos de cobran�a"
						" " + STR0002   		//"ou pagamentos gerados pelo usuario."
Local cTitulo 	:= STR0006 					//"Emiss�o de Borderos de Pagamentos"
Local cPerg		:= "FIN170"					// Nome do grupo de perguntas
Local cPictTit := PesqPict("SE2","E2_VALOR")

Pergunte("FIN170",.F.)
//�������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                        �
//� mv_par01        	// Carteira (R/P)                          �
//� mv_par02        	// Numero do Bordero Inicial               �
//� mv_par03        	// Numero do Bordero Final                 �
//� mv_par04        	// considera filial                        �
//� mv_par05        	// da filial                               �
//� mv_par06        	// ate a filial                            �
//� mv_par07        	// moeda                                   �
//� mv_par08        	// imprime outras moedas                   �
//���������������������������������������������������������������

oReport := TReport():New(cReport, cTitulo, cPerg, {|oReport| ReportPrint(oReport, cTitulo)}, cDescri)

oReport:HideHeader()		//Oculta o cabecalho do relatorio

//�������������������������Ŀ
//� Secao 01 -				    �
//���������������������������
oSection1 := TRSection():New(oReport, "Cabecalho",("TRB","SA6"))
//TRCell():New(oSection1, STR0024,,"Texto 'AO'",,2,,{|| STR0024}) // AO
TRCell():New(oSection1, "A6_NOME","SA6",STR0024,,32,,)
oSection1:Cell("A6_NOME"):SetCellBreak()
//TRCell():New(oSection1,STR0016,,"Texto 'AGENCIA'",,7,,{|| STR0016}) // AGENCIA
TRCell():New(oSection1,"A6_AGENCIA","SA6",STR0016,,20,,)
//TRCell():New(oSection1,STR0017,,"Texto 'CONTA'",,5,,{|| STR0017})
TRCell():New(oSection1,"EA_NUMCON","SEA",STR0017,,15,,)
oSection1:Cell("EA_NUMCON"):SetCellBreak()
TRCell():New(oSection1,"A6_BAIRRO","SA6",,,15,,)
TRCell():New(oSection1,"A6_MUN","SA6",,,20,,)
TRCell():New(oSection1,"A6_EST","SA6",,,5,,)
oSection1:Cell("A6_EST"):SetCellBreak()
//TRCell():New(oSection1,STR0018,,"Texto 'Bordero nro'",,12,,{|| STR0018}) // BORDERO NRO
TRCell():New(oSection1,"EA_NUMBOR","SEA",STR0018,,15,,)
//TRCell():New(oSection1,STR0039,,"Texto 'Emitido em:'",,12,,{|| STR0039}) //
TRCell():New(oSection1,"EA_DATABOR","SEA",STR0039,PesqPict("SEA","EA_DATABOR"),10,,)
oSection1:Cell("EA_DATABOR"):SetCellBreak()
//RECEBER
TRCell():New(oSection1,STR0019,,"",,Len(STR0019),,{|| STR0019}) //"Solicitamos proceder o recebimento das duplicatas abaixo relacionadas"
oSection1:Cell(STR0019):SetCellBreak()
TRCell():New(oSection1,STR0020,,"",,Len(STR0020),,{|| STR0020}) //"CREDITANDO-NOS os valores correspondentes."
oSection1:Cell(STR0020):SetCellBreak()
//PAGAR
TRCell():New(oSection1,STR0021,,"",,Len(STR0021),,{|| STR0021}) //"Solicitamos proceder o pagamento das duplicatas abaixo relacionadas"
oSection1:Cell(STR0021):SetCellBreak()
TRCell():New(oSection1,STR0022,,"",,Len(STR0022),,{|| STR0022}) //"DEBITANDO-NOS os valores correspondentes."
oSection1:Cell(STR0022):SetCellBreak()
//Linhas complementares
TRCell():New(oSection1,"Linha complementar"+" 1",,"",,70,,)
oSection1:Cell("Linha complementar"+" 1"):SetCellBreak()
TRCell():New(oSection1,"Linha complementar"+" 2",,"",,70,,)
oSection1:Cell("Linha complementar"+" 2"):SetCellBreak()
TRCell():New(oSection1,"Linha complementar"+" 3",,"",,70,,)
oSection1:Cell("Linha complementar"+" 3"):SetCellBreak()

oSection1:SetCharSeparator("")
oSection1:SetLineStyle()
oSection1:SetHeaderSection(.F.)	//Nao imprime o cabecalho da secao
oSection1:SetPageBreak(.T.)		//Salta a pagina na quebra da secao

//�������������������������Ŀ
//� Secao 02 -              �
//���������������������������
oSection2 := TRSection():New(oSection1,"Titulos",{"TRB","SA1","SA2","SE1","SE2"})
TRCell():New(oSection2,"EA_PREFIXO","SEA",STR0040,,15,,)//"NUM"
TRCell():New(oSection2,"EA_NUM","SEA",STR0041,,15,,)//DUPLIC
TRCell():New(oSection2,"EA_PARCELA","SEA",STR0042,,15,,)//P
//RECEBER
TRCell():New(oSection2,"E1_CLIENTE"	,"SE1",STR0043,,TamSx3("E1_CLIENTE"	)[1],,)//CODIGO
TRCell():New(oSection2,"A1_NOME"	,"SA1",STR0044,,TamSx3("A1_NOME"	)[1],,)//RAZAO SOCIAL
TRCell():New(oSection2,"E1_VENCTO"	,"SE1",STR0045,PesqPict("SE1","E1_VENCTO"),10,,)//VENCTO

// PAGAR
TRCell():New(oSection2,"E2_FORNECE"	,"SE2",STR0043,,TamSx3("E2_FORNECE"	)[1],,)//CODIGO
TRCell():New(oSection2,"A2_NOME"	,"SA2",STR0044,,TamSx3("A2_NOME"	)[1],,)//RAZAO SOCIAL
TRCell():New(oSection2,"E2_VENCTO"	,"SE2",STR0045,PesqPict("SE2","E2_VENCTO"),10,,)//VENCTO
TRCell():New(oSection2,"VALOR","",STR0046,cPictTit,TamSx3("E2_VALOR")[1],/*lPixel*/,/*{|| code-block de impressao }*/,"RIGHT",,"RIGHT") //VALOR
//TRCell():New(oSection2,"E2_CCUSTO"	,"SE2","Centro Custo",PesqPict("SE2","E2_CCUSTO"),10,,)//VENCTO         
TRCell():New(oSection2,"E2_CCUSTO"	,"SE2","C.Custo",,TamSx3("E2_CCUSTO"	)[1],,)//RAZAO SOCIAL
TRCell():New(oSection2,"E2_XDESCCC"	,"SE2","Desc. Centro Custo",,TamSx3("E2_XDESCCC"	)[1],,)//RAZAO SOCIAL

oSection2:SetNoFilter({"TRB","SA1","SA2","SE1","SE2"})
oSection2:SetTotalText("")


Return oReport

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �+ �Autor �Marcel Borges Ferreira �Data �    /  /     ���
����������������������������������������������������������������������������͹��
���Descricao � Imprime o objeto oReport definido na funcao ReportDef.        ���
����������������������������������������������������������������������������͹��
���Parametros� EXPO1 - Objeto TReport do relatorio                           ���
���          �                                                               ���
����������������������������������������������������������������������������͹��
���Uso       �                                                               ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Static Function ReportPrint(oReport)

Local nOpca := 0
Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(1):Section(1)
Local cAliasQry := "TRB"
Local cFilialSEA
Local cFilialSA6
Local cFilialSEX := ""
Local cTable
Local cTableDel
Local cSE
Local cFilialSE
Local cPrefixo
Local cNum
Local cParcela
Local cTipo
Local cCampos
Local cComple1 := Space(79)
Local cComple2 := Space(79)
Local cComple3 := Space(79)
//Codebase
Local aTam		:= {}
Local aCampos	:= {}
Local cFiltro
Local nLen := 0
Local cFil := ""
Local cLayoutSM0 := FWSM0Layout()
Local lGestao	 := Substr(cLayoutSM0,1,1) $ "E|U"
Local cFilialSA := ""

If MV_PAR01==1
	oSection1:Cell(STR0021):Disable()
	oSection1:Cell(STR0022):Disable()
	oSection2:Cell("E2_FORNECE"):Disable()
	oSection2:Cell("A2_NOME"):Disable()
	oSection2:Cell("E2_VENCTO"):Disable()
	oSection2:Cell("E2_CCUSTO"):Disable()
	oSection2:Cell("E2_XDESCCC"):Disable()	
Else
	oSection1:Cell(STR0019):Disable()
	oSection1:Cell(STR0020):Disable()
	oSection2:Cell("E1_CLIENTE"):Disable()
	oSection2:Cell("A1_NOME"):Disable()
	oSection2:Cell("E1_VENCTO"):Disable()
EndIf

DEFINE MSDIALOG oDlg FROM  92,70 TO 221,463 TITLE OemToAnsi(STR0009) PIXEL  //  "Mensagem Complementar"
@ 09, 02 SAY STR0036 SIZE 24, 7 OF oDlg PIXEL  //"Linha 1"
@ 24, 02 SAY STR0037 SIZE 25, 7 OF oDlg PIXEL  //"Linha 2"
@ 38, 03 SAY STR0038 SIZE 25, 7 OF oDlg PIXEL  //"Linha 3"
@ 07, 31 MSGET cComple1 Picture "@S48" SIZE 163, 10 OF oDlg PIXEL
@ 21, 31 MSGET cComple2 Picture "@S48" SIZE 163, 10 OF oDlg PIXEL
@ 36, 31 MSGET cComple3 Picture "@S48" SIZE 163, 10 OF oDlg PIXEL

DEFINE SBUTTON FROM 50, 139 TYPE 1 ENABLE OF oDlg ACTION (nOpca:=1,oDlg:End())
DEFINE SBUTTON FROM 50, 167 TYPE 2 ENABLE OF oDlg ACTION oDlg:End()

ACTIVATE MSDIALOG oDlg CENTERED

If nOpca#1
	cComple1 := ""
	cComple2 := ""
	cComple3 := ""
EndIf

#IFDEF TOP
	cAliasQry := GetNextAlias()
	MakeSqlExpr(oReport:uParam)

	oSection1:BeginQuery()

	If MV_PAR04 == 1 //Considera Filial?
	  cFilialSEA := "EA_FILIAL BETWEEN '" + FWxFilial("SEA",MV_PAR05) + "' AND '" + FWxFilial("SEA",MV_PAR06) + "' "
	Else
		cFilialSEA := "EA_FILIAL = '" + xFilial("SEA") + "' "
	EndIf
	
	cFilialSEA := "%"+cFilialSEA+"%"

	nLen    := 0

	If MV_PAR04 == 1 //Considera Filial?
	  cFilialSA6 := "A6_FILIAL BETWEEN '" + FWxFilial("SA6",MV_PAR05)  + "' AND '" + FWxFilial("SA6",MV_PAR06) + "' "

	Else
		cFilialSA6 := "A6_FILIAL = " + "'"+xFilial("SA6")+"' "
	EndIf

	cFilialSA6 := "%"+cFilialSA6+"%"

  	If MV_PAR01 ==1 //Carteira (R/P)
		cTableSE  := "%" + RetSqlName("SE1") + " SE1" + "%"
		cTableSA  := "%" + RetSqlName("SA1") + " SA1" + "%"
		cTableDel := "%" + "SE1.D_E_L_E_T_='' AND SA1.D_E_L_E_T_=''" + "%"
		cOrdem    := "%" + "E1_CLIENTE" + "%"
		cCond	  := "%" + "A1_COD = E1_CLIENTE" + "%"
		cLoja     := "%" + "A1_LOJA = E1_LOJA" + "%"
		cSE       := "E1_"
		cCampos   := "%" + "E1_CLIENTE, E1_LOJA, E1_VENCTO, E1_MOEDA, SE1.R_E_C_N_O_ RECALIAS" + "%"
		cCart     := "R"
		
		If MV_PAR04 == 1
			cFilialSA := "A1_FILIAL BETWEEN '" + FWxFilial("SA1",MV_PAR05)  + "' AND '" + FWxFilial("SA1",MV_PAR06) + "' "
		Else
			cFilialSA := "A1_FILIAL = " + "'"+xFilial("SA1")+"' "
		Endif		 

		If MV_PAR04 == 1
			cFilialSEX := "E1_FILORIG BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
		Else
			cFilialSEX := "E1_FILORIG = " + "'" + cFilAnt + "' "
		EndIf

		cFilialSA := "%"+cFilialSA+"%"
		cFilialSEX := "%"+cFilialSEX+"%"
	Else
		cTableSE  := "%" + RetSqlName("SE2") + " SE2" + "%"
		cTableSA  := "%" + RetSqlName("SA2") + " SA2" + "%"
		cTableDel := "%" + "SE2.D_E_L_E_T_='' AND SA2.D_E_L_E_T_=''" + "%"
		cOrdem    := "%" + "E2_FORNECE" + "%"
		cCond     := "%" + "A2_COD = E2_FORNECE  AND E2_FORNECE = EA_FORNECE" + "%"
		cLoja     := "%" + "A2_LOJA = E2_LOJA AND E2_LOJA = EA_LOJA" + "%"
		cSE       := "E2_"
		cCampos   := "%" + "E2_FORNECE, E2_LOJA, E2_VENCTO, E2_MOEDA, E2_CCUSTO, E2_XDESCCC, SE2.R_E_C_N_O_ RECALIAS" + "%"
		cCart     := "P"
		
		If MV_PAR04 == 1
			cFilialSA := "A2_FILIAL BETWEEN '" + FWxFilial("SA2",MV_PAR05)  + "' AND '" + FWxFilial("SA2",MV_PAR06) + "' "
		Else
			cFilialSA := "A2_FILIAL = " + "'"+xFilial("SA2")+"' "
		Endif		 

		If MV_PAR04 == 1
			cFilialSEX := "E2_FILORIG BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
		Else
			cFilialSEX := "E2_FILORIG = " + "'" + cFilAnt + "' "
		EndIf

		cFilialSA := "%"+cFilialSA+"%"
		cFilialSEX := "%"+cFilialSEX+"%"
	EndIf

	//Considerar Filial tamb�m para a filial de origem.
	If mv_par04 == 1
		cFil := MV_PAR05
	Else
		cFil := xFilial("SEA")
	EndIf
	If cCart == "R"
		If lGestao
			If MsModoFil("SE1")[3] == "E"
				nLen := Len(FwCompany(cFil))
			EndIf
			If MsModoFil("SE1")[2] == "E"
				nLen += Len(FwUnitBusiness(cFil))
			EndIf
			If MsModoFil("SE1")[1] == "E"
				nLen += Len(FwFilial(cFil))
			EndIf
	    Else
	    	nLen := Len(xFilial("SE1"))
	    Endif
	Else
		If lGestao
			If MsModoFil("SE2")[3] == "E"
				nLen := Len(FwCompany(cFil))
			EndIf
			If MsModoFil("SE2")[2] == "E"
				nLen += Len(FwUnitBusiness(cFil))
			EndIf
			If MsModoFil("SE2")[1] == "E"
				nLen += Len(FwFilial(cFil))
			EndIf
		Else
	    	nLen := Len(xFilial("SE2"))
		Endif
	EndIf
	If mv_par04 == 1
		cFilialSE := "EA_FILORIG BETWEEN '" + MV_PAR05  + "' AND '" + MV_PAR06 + "' "
	Else
		cFilialSE := "EA_FILORIG = " + IIF(cCart=="R","E1_FILORIG","E2_FILORIG")
	EndIf

	cFilialSE  := "%"+cFilialSE+"%"
	cNumBor    := "%"+cSE+"NUMBOR"+"%"
	cPrefixo   := "%"+cSE+"PREFIXO"+"%"
	cNum 	   := "%"+cSE+"NUM"+"%"
	cParcela   := "%"+cSE+"PARCELA"+"%"
	cTipo	   := "%"+cSE+"TIPO"+"%"

	BeginSql Alias cAliasQry

		SELECT DISTINCT EA_NUMCON, EA_NUMBOR, EA_DATABOR, EA_PREFIXO, EA_NUM, EA_PARCELA,
			A6_COD, A6_NOME,A6_AGENCIA, A6_BAIRRO, A6_MUN, A6_EST,
			%Exp:cCampos%

		FROM %table:SEA% SEA, %table:SA6% SA6, %Exp:cTableSE%, %Exp:cTableSA%

		WHERE %Exp:cFilialSEA% AND
			%Exp:cFilialSA6% AND
			%Exp:cFilialSEX% AND
			EA_NUMBOR BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% AND
			EA_CART = %Exp:cCart% AND
			%Exp:cFilialSE% AND
			EA_PORTADO = A6_COD AND
			EA_NUMCON = A6_NUMCON AND
			EA_AGEDEP = A6_AGENCIA AND
			EA_NUMBOR = %Exp:cNumbor% AND
			EA_PREFIXO = %Exp:cPrefixo% AND
			EA_NUM = %Exp:cNum% AND
			EA_PARCELA = %Exp:cParcela% AND
			EA_TIPO = %Exp:cTipo% AND
			%Exp:cCond% AND
			%Exp:cLoja% AND
			%Exp:cFilialSA% AND
			SEA.%NotDel% AND SA6.%NotDel%	 AND %Exp:cTableDel%

		ORDER BY EA_NUMBOR, EA_PREFIXO, EA_NUM, EA_PARCELA, %Exp:cOrdem%

	EndSql

	oSection1:EndQuery()

	If mv_par01 == 1
		TRPosition():New(oSection2,"SA1",1,{|| xFilial("SA1")+(cAliasQry)->E1_CLIENTE+(cAliasQry)->E1_LOJA})
	Else
		TRPosition():New(oSection2,"SA2",1,{|| xFilial("SA2")+(cAliasQry)->E2_FORNECE+(cAliasQry)->E2_LOJA})
	EndIf

	oSection2:SetParentQuery( .T. )
  	oSection2:SetParentFilter({|cParam| (cAliasQry)->EA_NUMBOR = cParam},{|| (cAliasQry)->EA_NUMBOR})
#ELSE
	If MV_PAR04 == 1 //Considera Filial?
		cFiltro := "EA_FILIAL >= '" + MV_PAR05 + "' .AND. EA_FILIAL <= '" + MV_PAR06+ "' .AND."
	Else
		cFiltro := "EA_FILIAL = '" + xFilial("SEA") + "'admin		 .AND."
	EndIf
	cFiltro += "EA_NUMBOR >= '" + MV_PAR02 + "' .AND. EA_NUMBOR <= '" + MV_PAR03+ "'"

	//CRIA TRB

	cIndTmp := CriaTrab(nil,.F.)
	IndRegua("SEA",cIndTmp,SEA->(IndexKey()),,cFiltro)
	nIndexSEA := RetIndex("SEA")
	dbSetIndex(cIndTmp+OrdBagExt())
	dbSetOrder(nIndexSEA+1)

	aTam:=TamSX3("EA_NUMCON")
	AADD(aCampos,{"EA_NUMCON" ,"C",aTam[1],aTam[2]})

	aTam:=TamSX3("EA_NUMBOR")
	AADD(aCampos,{"EA_NUMBOR" ,"C",aTam[1],aTam[2]})

	aTam:=TamSX3("EA_DATABOR")
	AADD(aCampos,{"EA_DATABOR" ,"D",aTam[1],aTam[2]})

	aTam:=TamSX3("EA_PREFIXO")
	AADD(aCampos,{"EA_PREFIXO" ,"C",aTam[1],aTam[2]})

	aTam:=TamSX3("EA_NUM")
	AADD(aCampos,{"EA_NUM" ,"C",aTam[1],aTam[2]})

	aTam:=TamSX3("EA_PARCELA")
	AADD(aCampos,{"EA_PARCELA"  ,"C",aTam[1],aTam[2]})

	aTam:=TamSX3("A6_NOME")
	AADD(aCampos,{"A6_NOME"  ,"C",aTam[1],aTam[2]})

	aTam:=TamSX3("A6_AGENCIA")
	AADD(aCampos,{"A6_AGENCIA"  ,"C",aTam[1],aTam[2]})

	aTam:=TamSX3("A6_BAIRRO")
	AADD(aCampos,{"A6_BAIRRO"  ,"C",aTam[1],aTam[2]})

	aTam:=TamSX3("A6_MUN")
	AADD(aCampos,{"A6_MUN"  ,"C",aTam[1],aTam[2]})

	aTam:=TamSX3("A6_EST")
	AADD(aCampos,{"A6_EST"  ,"C",aTam[1],aTam[2]})

	AADD(aCampos,{"RECALIAS"  ,"N",10,0})

	If MV_PAR01 == 1
		cOrdem := "E1_CLIENTE"
		aTam:=TamSX3("E1_CLIENTE")
		AADD(aCampos,{"E1_CLIENTE","C",aTam[1],aTam[2]})

		aTam:=TamSX3("A1_NOME")
		AADD(aCampos,{"A1_NOME","C",aTam[1],aTam[2]})

		aTam:=TamSX3("E1_VENCTO")
		AADD(aCampos,{"E1_VENCTO","D",aTam[1],aTam[2]})

		aTam:=TamSX3("E1_MOEDA")
		AADD(aCampos,{"E1_MOEDA","N",aTam[1],aTam[2]})
	Else
		cOrdem := "E2_FORNECE"
		aTam:=TamSX3("E2_FORNECE")
		AADD(aCampos,{"E2_FORNECE","C",aTam[1],aTam[2]})

		aTam:=TamSX3("A2_NOME")
		AADD(aCampos,{"A2_NOME","C",aTam[1],aTam[2]})

		aTam:=TamSX3("E2_VENCTO")
		AADD(aCampos,{"E2_VENCTO","D",aTam[1],aTam[2]})

		aTam:=TamSX3("E2_MOEDA")
		AADD(aCampos,{"E2_MOEDA","N",aTam[1],aTam[2]})
		
		aTam:=TamSX3("E2_CCUSTO")
		AADD(aCampos,{"E2_CCUSTO","C",aTam[1],aTam[2]})                                     
		
		aTam:=TamSX3("E2_XDESCCC")
		AADD(aCampos,{"E2_XDESCCC","C",aTam[1],aTam[2]})                                     
		
	Endif

	cArq:=CriaTrab(aCampos)
	dbUseArea( .T.,, cArq, "TRB", NIL, .F. )
	cOrdem := "EA_NUMBOR + EA_PREFIXO + EA_NUM + EA_PARCELA + "+cOrdem
	IndRegua("TRB",cArq,cOrdem,,,)

	SEA->(dbGoTop())
	While SEA->(!Eof())
		R170TR4()
		SEA->(dbSkip())
	EndDo

	oSection2:SetParentFilter({|cParam| TRB->EA_NUMBOR == cParam},{|| TRB->EA_NUMBOR})

	oSection1:Cell("A6_NOME"    ):SetBlock({||TRB->A6_NOME})
	oSection1:Cell("A6_AGENCIA" ):SetBlock({||TRB->A6_AGENCIA})
	oSection1:Cell("EA_NUMCON"  ):SetBlock({||TRB->EA_NUMCON})
	oSection1:Cell("A6_BAIRRO"  ):SetBlock({||TRB->A6_BAIRRO})
	oSection1:Cell("A6_MUN"     ):SetBlock({||TRB->A6_MUN})
	oSection1:Cell("A6_EST"     ):SetBlock({||TRB->A6_EST})
	oSection1:Cell("EA_NUMBOR"  ):SetBlock({||TRB->EA_NUMBOR})
	oSection1:Cell("EA_DATABOR" ):SetBlock({||TRB->EA_DATABOR})

	oSection2:Cell("EA_PREFIXO" ):SetBlock({||TRB->EA_PREFIXO})
	oSection2:Cell("EA_NUM"     ):SetBlock({||TRB->EA_NUM})
	oSection2:Cell("EA_PARCELA" ):SetBlock({||TRB->EA_PARCELA})

	If MV_PAR01==1
		oSection2:Cell("E1_CLIENTE"):SetBlock({||TRB->E1_CLIENTE})
		oSection2:Cell("A1_NOME"   ):SetBlock({||TRB->A1_NOME})
	  	oSection2:Cell("E1_VENCTO" ):SetBlock({||TRB->E1_VENCTO})
	Else
		oSection2:Cell("E2_FORNECE"):SetBlock({||TRB->E2_FORNECE})
		oSection2:Cell("A2_NOME"   ):SetBlock({||TRB->A2_NOME})
	   	oSection2:Cell("E2_VENCTO" ):SetBlock({||TRB->E2_VENCTO})
	   	oSection2:Cell("E2_CCUSTO" ):SetBlock({||TRB->E2_CCUSTO})
	   	oSection2:Cell("E2_XDESCCC"):SetBlock({||TRB->E2_XDESCCC})	   	
	EndIf

#ENDIF

oSection1:Cell("Linha complementar"+" 1"):SetBlock({||cComple1})
oSection1:Cell("Linha complementar"+" 2"):SetBlock({||cComple2})
oSection1:Cell("Linha complementar"+" 3"):SetBlock({||cComple3})
oSection2:Cell("VALOR"):SetBlock({||R170ValorTit((cAliasQry)->RECALIAS)})

//Totalizadores

If mv_par01==1
	oSection2:SetLineCondition({||(mv_par08 == 1 .OR. (mv_par08 == 2 .AND. (cAliasQRY)->E1_MOEDA = mv_par07))})
	TRFunction():New(oSection2:Cell("VALOR"),/*"oTotal"*/ ,"SUM", /*oBreak */,STR0047,/*[ cPicture ]*/,/*[ uFormula ]*/,,.F.)
	TRFunction():New(oSection2:Cell("VALOR"),/*"oTotal"*/ ,"COUNT", /*oBreak */,STR0049,/*[ cPicture ]*/,/*[ uFormula ]*/,,.F.)
Else
	oSection2:SetLineCondition({||(mv_par08 == 1 .OR. (mv_par08 == 2 .AND. (cAliasQRY)->E2_MOEDA = mv_par07))})
	TRFunction():New(oSection2:Cell("VALOR"),/*"oTotal"*/ ,"SUM", /*oBreak */,STR0048,/*[ cPicture ]*/,/*[ uFormula ]*/,,.F.)
	TRFunction():New(oSection2:Cell("VALOR"),/*"oTotal"*/ ,"COUNT", /*oBreak */,STR0049,/*[ cPicture ]*/,/*[ uFormula ]*/,,.F.)
EndIf

oReport:OnPageBreak({|| R170Header(oReport)})

oSection1:Print()

If Select("TRB") > 0
	TRB->(dbCloseArea())
	Ferase(cArq+GetDBExtension())      // Elimina arquivos de Trabalho
	Ferase(cArq+OrdBagExt())			  // Elimina arquivos de Trabalho
Endif

Return


#IFNDEF TOP
	/*
	��������������������������������������������������������������������������
	��������������������������������������������������������������������������
	����������������������������������������������������������������������ͻ��
	���Funcao    �R170TR4 �Autor �Marcel Borges Ferreira � Data � 05/07/06 ���
	����������������������������������������������������������������������͹��
	���Desc.     �Gravacao do arquivo de trabalho                          ���
	���          �                                                         ���
	����������������������������������������������������������������������͹��
	���Uso       � Generico                                                ���
	����������������������������������������������������������������������ͼ��
	��������������������������������������������������������������������������
	��������������������������������������������������������������������������
	*/
	Static Function R170TR4()

	SA6->(MsSeek(xFilial("SA6")+SEA->EA_PORTADO+SEA->EA_AGEDEP+SEA->EA_NUMCON))

	If MV_PAR01==1
		SE1->(MsSeek(xFilial("SE1")+SEA->EA_PREFIXO+SEA->EA_NUM+SEA->EA_PARCELA+SEA->EA_TIPO))
		SA1->(MsSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA))
	Else
		SA2->(MsSeek(xFilial("SA2")+"" ))
		SE2->(MsSeek(xFilial("SE2")+"" ))
	EndIf

	Reclock("TRB", .T.)
		TRB->EA_NUMCON		:= SEA->EA_NUMCON
		TRB->EA_NUMBOR 		:= SEA->EA_NUMBOR
		TRB->EA_DATABOR 	:= SEA->EA_DATABOR
		TRB->EA_PREFIXO		:= SEA->EA_PREFIXO
		TRB->EA_NUM			:= SEA->EA_NUM
		TRB->EA_PARCELA		:= SEA->EA_PARCELA
		TRB->A6_NOME		:= SA6->A6_NOME
		TRB->A6_AGENCIA 	:= SA6->A6_AGENCIA
		TRB->A6_BAIRRO		:= SA6->A6_BAIRRO
		TRB->A6_MUN			:= SA6->A6_MUN
		TRB->A6_EST  	  	:= SA6->A6_EST


        If MV_PAR01 == 1
			TRB->A1_NOME   		:= SA1->A1_NOME
			TRB->E1_CLIENTE 	:= SE1->E1_CLIENTE
			TRB->E1_VENCTO 		:= SE1->E1_VENCTO
			TRB->E1_MOEDA 	 	:= SE1->E1_MOEDA
			TRB->RECALIAS 		:= SE1->(Recno())
	   Else
			TRB->A2_NOME     	:= SA2->A2_NOME
			TRB->E2_FORNECE 	:= SE2->E2_FORNECE
			TRB->E2_VENCTO 		:= SE2->E2_VENCTO
			TRB->E2_MOEDA  		:= SE2->E2_MOEDA
			TRB->E2_CCUSTO      := SE2->E2_CCUSTO
			TRB->E2_XDESCCC     := POSICIONE("CTT",1,XFILIAL("CTT")+SE2->E2_CCUSTO,"CTT_DESC01") 
			TRB->RECALIAS 		:= SE2->(Recno())
       EndIf
	TRB->(MsUnlock())

	Return

#ENDIF

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa �R170Header   �Autor �Marcel Borges Ferreira �Data �   /  /      ���
����������������������������������������������������������������������������͹��
���Desc.    �Monta o cabecalho do relatorio.						                 ���
���         � 						                                    	        ���
����������������������������������������������������������������������������͹��
���Uso      � 	                                                	           ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Static Function R170Header(oReport)
Local cStartPath	:= GetSrvProfString("Startpath","")
Local cLogo			:= cStartPath + "LGRL" + SM0->M0_CODIGO + IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ) + ".BMP" 	// Empresa+Filial

If !File( cLogo )
	cLogo := cStartPath + "LGRL" + SM0->M0_CODIGO + ".BMP"
endif

oReport:SkipLine()
oReport:SkipLine()
oReport:SkipLine()
oReport:FatLine()
oReport:SkipLine()
oReport:SayBitmap (oReport:Row(),005,cLogo,291,057)
oReport:SkipLine()
oReport:SkipLine()
oReport:SkipLine()
oReport:FatLine()

Return

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa �R170ValorTit �Autor �Marcel Borges Ferreira �Data �   /  /      ���
����������������������������������������������������������������������������͹��
���Desc.    �Calcula valor.       						                          ���
���         � 						                                    	        ���
����������������������������������������������������������������������������͹��
���Uso      � 	                                                	           ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Static Function R170ValorTit(nAliasRec)
Local nValor := 0
Local nAbat  := 0
Local ndecs  := Msdecimais(mv_par07)
Local cBusca
Local aAux		 := {}
Local aValor	:= {}

If MV_PAR01==1
	//Posiciona SE1
	SE1->(dbGoto(nAliasRec))

	If(cPaisLoc<>"BRA" .And. SE1->E1_TIPO $ +IIF(Type('MVCHEQUES')=='C',MVCHEQUES,MVCHEQUE))
		nValor:= xMoeda(SE1->E1_VALOR+SE1->E1_SDACRES-SE1->E1_SDDECRE,SE1->E1_MOEDA,mv_par07,,ndecs+1)
		If dDatabase <> SE1->E1_EMIS1.and. mv_par07=1
			nValor:= (SE1->E1_VALOR * SE1->E1_TXMOEDA+SE1->E1_SDACRES-SE1->E1_SDDECRE)
		EndIf
	Else				
		aValor:=Baixas(SE1->E1_NATUREZ,SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_MOEDA,"R",SE1->E1_CLIENTE,dDataBase,SE1->E1_LOJA)
		nValor:= xMoeda(IIF(SE1->E1_SALDO == 0, Iif(aValor[2] != SE1->E1_DESCONT .Or. aValor[3] != SE1->E1_JUROS .Or. aValor[4] != SE1->E1_MULTA,SE1->E1_VALOR - aValor[2] + (aValor[3] + aValor[4]),IIF(SE1->E1_SDACRES == 0 .And. SE1->E1_ACRESC > 0, SE1->(E1_VALOR+E1_ACRESC)-SE1->E1_DESCONT, SE1->E1_VALOR-SE1->E1_DESCONT)), SE1->E1_SALDO)-SE1->E1_SDDECRE+SE1->E1_SDACRES,SE1->E1_MOEDA,mv_par07,,ndecs+1)				
	EndIf

  	// Template GEM
	If HasTemplate("LOT") .And. !Empty(SE1->E1_NCONTR)
		aAux := CMDtPrc( SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA, SE1->E1_VENCTO, SE1->E1_VENCTO )
		nValor += aAux[2] + aAux[3]
	EndIf

	cBusca := SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA)
   SE1->(dbSeek(xFilial("SE1")+cBusca))
	While !Eof() .and. SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA) == cBusca
		If SE1->E1_TIPO $ MVABATIM
			nAbat += xMoeda(SE1->E1_SALDO,SE1->E1_MOEDA,mv_par07,,ndecs+1)
		Endif
		SE1->(dbSkip())
	EndDo

Else
	//Posiciona SE2
	SE2->(dbGoto(nAliasRec))
	If(cPaisLoc<>"BRA" .And. SE2->E2_TIPO $ IIF(Type('MVCHEQUES')=='C',MVCHEQUES,MVCHEQUE))
		nValor:=xMoeda(SE2->E2_VALOR+SE2->E2_SDACRES-SE2->E2_SDDECRE,SE2->E2_MOEDA,mv_par07,,ndecs+1)
		If dDatabase <> SE1->E1_EMIS1.and. mv_par07=1
			nValor:= (SE1->E1_VALOR * SE1->E1_TXMOEDA+SE1->E1_SDACRES-SE1->E1_SDDECRE)
		EndIf
	Else
		aValor:=Baixas(SE2->E2_NATUREZ,SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_MOEDA,"P",SE2->E2_FORNECE,dDataBase,SE2->E2_LOJA)
		nValor:=xMoeda(IIF(SE2->E2_SALDO == 0, Iif(aValor[2] != SE2->E2_DESCONT .Or. aValor[3] != SE2->E2_JUROS .Or. aValor[4] != SE2->E2_MULTA,SE2->E2_VALOR - aValor[2] + (aValor[3] + aValor[4]),SE2->E2_VALOR-SE2->E2_DESCONT+SE2->E2_ACRESC), SE2->E2_SALDO)-SE2->E2_SDDECRE+SE2->E2_SDACRES,SE2->E2_MOEDA,mv_par07,,ndecs+1, SE2->E2_TXMOEDA ,&("SM2->M2_MOEDA" + STR(mv_par07,1)))
	EndIf

	cBusca := SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA)
	SE2->(dbSeek(xFilial("SE2")+cBusca))
	While !Eof() .and. SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA) == cBusca
		If SE2->E2_TIPO $ MVABATIM .AND. SEA->EA_FORNECE==SE2->E2_FORNECE
			nAbat += xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,mv_par07,,ndecs+1)
		Endif
		SE2->(dbSkip())
	EndDo
Endif

nValor := nValor-nAbat

Return nValor

/*����������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    � FINR170  � Autor � Wagner Xavier          � Data � 05.10.92 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Rela��o de Borderos para cobranca / pagamentos              ���
��������������������������������������������������������������������������Ĵ��
���Sintaxe e � FINR170(void)                                               ���
��������������������������������������������������������������������������Ĵ��
���Parametros�                                                             ���
��������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
��� DATA   � BOPS �Prograd.�ALTERACAO                                      ���
��������������������������������������������������������������������������Ĵ��
���29.06.98�      �Mauricio�Nro de titulos com 12 posicoes                 ���
���20.08.98�xxxxxx�Alice   �Tratamento de filiais                          ���
���14.10.98�xxxxxx�Andreia �Alteracao no lay-out para ativar set century   ���
���29.06.98�      �Mauricio�Nro de titulos com 12 posicoes                 ���
���15.03.99�xxxxxx�Julio   �Correcao na Busca de Bordero consid. Filiais...���
���30.03.99�META  �Julio   �Verificacao nso Parametros de Tamanho do Rel.  ���
���06.07.99�      �Mauricio�Tratar drivers impressoras idem cabec()        ���
���02.08.99�META  �Julio   �Interpretar MV_CRNEG e MV_CPNEG                ���
���09.09.99�23811A�Mauricio�Corrigir impressao da empresa no rodap�        ���
���24.11.99�xxxxxx�Mauricio�Corrigir tratamento Filial De/Ate              ���
���14.02.03�XXXXXX�Eduardo Ju�Inclusao de Queries p/ filtros em TOPCONNECT.���
���11.08.06�		�Menon   �Inclusao da Data de Emissao do Bordero.			���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
����������������������������������������������������������������������������*/
STATIC FUNCTION FinR170R3()

//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
Local cDesc1  := STR0001  //"Este programa tem a fun��o de emitir os borderos de cobran�a"
Local cDesc2  := STR0002  //"ou pagamentos gerados pelo usuario."
Local cDesc3  := ""
Local wnrel
Local cString := "SEA"
Local nOpca	  := 0
Local aPergs := {}
Local nI := 0
Local nCount := 0

Private tamanho  := "M"
Private cabec1
Private cabec2
Private titulo   := STR0006  //"Emiss�o de Borderos"
Private aReturn  := { OemToAnsi(STR0007), 1,OemToAnsi(STR0008), 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
Private nomeprog := "FINR170"
Private aLinha   := { },nLastKey := 0
Private cPerg    := "FIN170"
Private cComple1 := Space(79)
Private cComple2 := Space(79)
Private cComple3 := Space(79)

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
DBSelectArea("SX1")
DBSetOrder(1) //FILIAL+VARIAVEL


If (TAMSX3("E1_CLIENTE")[1] + TAMSX3("E1_LOJA")[1] > 8) .or.;
   (TAMSX3("E2_FORNECE")[1] + TAMSX3("E2_LOJA")[1] > 8) .or.;
   (TAMSX3("E1_PARCELA")[1] + TAMSX3("E2_PARCELA")[1] > 4)
	tamanho := "M"
EndIf

Pergunte("FIN170",.F.)


//�������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                        �
//� mv_par01        	// Carteira (R/P)                          �
//� mv_par02        	// Numero do Bordero Inicial               �
//� mv_par03        	// Numero do Bordero Final                 �
//� mv_par04        	// considera filial                        �
//� mv_par05        	// da filial                               �
//� mv_par06        	// ate a filial                            �
//� mv_par07        	// moeda                                   �
//� mv_par08        	// imprime outras moedas                   �
//���������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel := "FINR170"            //Nome Default do relatorio em Disco
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey == 27
	Return
EndIf

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
EndIf

DEFINE MSDIALOG oDlg FROM  92,70 TO 221,463 TITLE OemToAnsi(STR0009) PIXEL  //  "Mensagem Complementar"
@ 09, 02 SAY STR0036 SIZE 24, 7 OF oDlg PIXEL  //"Linha 1"
@ 24, 02 SAY STR0037 SIZE 25, 7 OF oDlg PIXEL  //"Linha 2"
@ 38, 03 SAY STR0038 SIZE 25, 7 OF oDlg PIXEL  //"Linha 3"
@ 07, 31 MSGET cComple1 Picture "@S48" SIZE 163, 10 OF oDlg PIXEL
@ 21, 31 MSGET cComple2 Picture "@S48" SIZE 163, 10 OF oDlg PIXEL
@ 36, 31 MSGET cComple3 Picture "@S48" SIZE 163, 10 OF oDlg PIXEL

DEFINE SBUTTON FROM 50, 139 TYPE 1 ENABLE OF oDlg ACTION (nOpca:=1,oDlg:End())
DEFINE SBUTTON FROM 50, 167 TYPE 2 ENABLE OF oDlg ACTION oDlg:End()

ACTIVATE MSDIALOG oDlg CENTERED

If nOpca#1
	cComple1 := ""
	cComple2 := ""
	cComple3 := ""
EndIf

RptStatus({|lEnd| Fa170Imp(@lEnd,wnRel,cString)},Titulo)
Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FA170Imp � Autor � Wagner Xavier         � Data � 05.10.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Rela��o de Borderos para cobranca / pagamentos             ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � FA170Imp(lEnd,wnRel,cString)                               ���
�������������������������������������������������������������������������Ĵ��
���Parametros� lEnd     -  A��o do CodeBlock                              ���
���          � wnRel    -  T�tulo do relat�rio                            ���
���          � cString  -  Mensagem                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function FA170Imp(lEnd,wnRel,cString)

Local cCodigo,cNome,nValor:=0,nValTot:=0,dVencto
Local nContador := 0
Local cbcont,CbTxt
Local nAbat     := 0
Local cLoja
Local cFilDe,cFilAte
Local nRegEmp   := SM0->(RecNo())
Local aTam      := Iif(mv_par01==1,TAMSX3("E1_CLIENTE"),TAMSX3("E2_FORNECE"))
Local aColu     := {}
Local ndecs     := Msdecimais(mv_par07)
Local cCampo    := If(mv_par01==1,"E1_PARCELA","E2_PARCELA")
Local cChave
Local cCampoSea := "SEA->EA_FILIAL"
Local aAux		 := {}
Local cFilAtu	:=	""
Local lUnidNeg := IIF(Len(aUnidNeg := FWAllUnitBusiness())>0,.T.,.F.) //Identifico se tenho unidade de negocios.
Local cCondWhile:= ""
Local nRecno := 0
Local lAchou := .F.
Local cNumCheque  := ""
Local lMostraChq  := .F.
Local nFiltro := 0
Local cChaveAnt := ""
Local lUltRodape := .F.
Local cFilOrig	:= ""
Local cFilterUser:=aReturn[7]
Local cCondFil	:= ""
Local cLayoutSM0 := FWSM0Layout()
Local lGestao	 := Substr(cLayoutSM0,1,1) $ "E|U"
Local nLen := 0
Local cGravFil:= cFilAnt
Local aValor	:= {}

#IFDEF TOP
	Local aStru     := SEA->(dbStruct())
	Local nI  := 0
	Local cOrder    := ""
#ELSE
	Local lAchouFil := .F.
#ENDIF

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//����������������������������������������������������������������
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1

If Empty(mv_par02)
	If Empty(mv_par03)
		//sem filtro de Numero de Bordero
		nFiltro := 0
	Else
		//Ate o Bornero Y
		nFiltro := 3
	EndIf
Else
	If Empty(mv_par03)
		//Iniciando no Bordero N
		nFiltro := 1
	Else
		//Iniciando no Bordero N ate o Bordero Y
		nFiltro := 2
	EndIf
EndIf
nContador := 0

dbSelectArea("SEA")
dbSetOrder(1)

#IFDEF TOP

	cOrder := SqlOrder(IndexKey())
	cQuery := "SELECT * "
	cQuery += "  FROM "+	RetSqlName("SEA")
	cQuery += " WHERE "

	If MV_PAR04 == 1 //Considera Filial?
	  	cQuery += "EA_FILIAL BETWEEN '" + FWxFilial("SEA",MV_PAR05) + "' AND '" + FWxFilial("SEA",MV_PAR06) + "' AND "
	  	
	Else
 		cQuery += "EA_FILIAL = '"+ xFilial("SEA") + "' AND "
	EndIf

	If nFiltro # 0
		Do Case
			Case nFiltro == 1
				cQuery += "EA_NUMBOR >= '" + mv_par02 + "' AND "
			Case nFiltro == 2
				cQuery += "EA_NUMBOR >= '" + mv_par02 + "' AND "
				cQuery += "EA_NUMBOR <= '" + mv_par03 + "' AND "
			Case nFiltro == 3
				cQuery += "EA_NUMBOR <= '" + mv_par03 + "' AND "
		EndCase
	Endif

  	If mv_par01 == 1
  		cQuery += "EA_CART = 'R' AND "
	EndIf

  	If mv_par01 == 2
  		cQuery += "EA_CART = 'P' AND "
  	EndIf

   cQuery += "EA_TIPO NOT IN ('" + MV_CRNEG + "','" + MV_CPNEG + "','" + MVABATIM + "')  AND "
	cQuery += "D_E_L_E_T_ <> '*' "

	cQuery += " ORDER BY " + cOrder
	cQuery := ChangeQuery(cQuery)

	dbSelectArea("SEA")
	dbCloseArea()
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SEA', .F., .T.)

	For ni := 1 to Len(aStru)
		If aStru[ni,2] != 'C'
			TCSetField('SEA', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
		Endif
	Next

	dbSelectArea("SEA")
	dbGotop()
	If EOF() .AND. BOF()
		DbCloseArea()
		ChkFile("SEA")
		dbSetOrder(1)
		Return
	Endif

#ENDIF

SetRegua(RecCount())

If Empty(xFilial("SEA"))
	cCondFil := ".T."
	CfilDe   := xFilial("SEA")
	cFilAte  := Replicate ("Z",LEN(xFilial("SEA")))
Else
	If mv_par04 == 1
		cFilDe  := mv_par05
		cFilAte := mv_par06
	Else
		cFilDe  := cFilAnt
		cFilAte := cFilAnt
	EndIf
	cCondFil := "M0_CODFIL <= '"+cFilAte+"'"
EndIf

dbSelectArea("SM0")
dbSeek(cEmpAnt+cFilDe,.T.)

aColu := IIF (aTam[1] > 6,;
			TamParcela(cCampo,{050,051,076,077,087,091,105},;
							 {051,052,077,078,088,092,106},;
							 {052,053,078,079,089,093,107}),;
			TamParcela(cCampo,{036,037,062,063,073,075,094},;
						    {037,038,063,064,074,076,095},;
							 {038,039,064,065,075,077,096}))


While !Eof() .and. M0_CODIGO == cEmpAnt //.and. &cCondFil
	cFilAnt	:=	IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )		// Mudar filial atual temporariamente
	cFilAtu	:= SM0->M0_CODFIL

	If cFilAnt < cFilDe .or. cFilAnt > cFilAte
      dbskip()
      loop
	Endif

	dbSelectArea("SEA")
  	#IFNDEF TOP
		dbSeek(xFilial("SEA")+IIf(nFiltro==1 .Or. nFiltro == 2, mv_par02,""), .T.)
		If EOF()
			DbSelectArea("SM0")
			DbSkip()
			Loop
		Else
			lAchouFil := .T.
		EndIf
	#ENDIF

	//��������������������������������������������������������������Ŀ
	//� Existe a possibilidade ser gerado um bordero para varias     �
	//� filiais                                                      �
	//����������������������������������������������������������������

	#IFDEF TOP
		If nFiltro # 0
			Do Case
				Case nFiltro == 1
					cCondWhile := "EA_NUMBOR >= mv_par02"
				Case nFiltro == 2
					cCondWhile := "(EA_NUMBOR >= mv_par02 .And. "
					cCondWhile += "EA_NUMBOR <= mv_par03)"
				Case nFiltro == 3
					cCondWhile := "EA_NUMBOR <= mv_par03"
			EndCase
		Else
			cCondWhile:=".T."
		Endif
   #ELSE
		If nFiltro # 0
			Do Case
				Case nFiltro == 1
					cCondWhile := "EA_NUMBOR >= mv_par02"
				Case nFiltro == 2
					cCondWhile := "(EA_NUMBOR >= mv_par02 .And. "
					cCondWhile += "EA_NUMBOR <= mv_par03)"
				Case nFiltro == 3
					cCondWhile := "EA_NUMBOR <= mv_par03"
			EndCase
		Else
			cCondWhile:=".T."
		Endif
		cCondWhile += " .and. EA_FILIAL == xFilial()"
	#ENDIF

	While !Eof() .And. &(cCondWhile)

		If ( lEnd )
			@Prow()+1,001 PSAY OemToAnsi(STR0010)  //"CANCELADO PELO OPERADOR"
			Exit
		EndIf

		IncRegua()

   		If cPaisLoc == "BRA"
	 		If ( Empty(EA_NUMBOR) )
	 			dbSkip()
				Loop
			EndIf
		EndIf

		// Considera filtro do usuario                                  �
		If !Empty(cFilterUser).and.!(&cFilterUser)
			dbSelectArea("SEA")
			dbSkip()
			Loop
		Endif

		If ( mv_par01 == 1 .and. EA_CART = "P" )
			dbSkip()
			Loop
		EndIf

		If ( mv_par01 == 2 .and. EA_CART = "R" )
			dbSkip()
			Loop
		EndIf

		If SEA->EA_TIPO $ MV_CRNEG+"/"+MV_CPNEG+"/"+MVABATIM
			dbSkip()
			Loop
		Endif

		lAchou := .F.
		If ( mv_par01 == 1 )
			If Empty(SEA->EA_FILORIG) .AND. !Empty(xFilial("SE1"))
				cChave 	 := xFilial("SE1")+SEA->(EA_PREFIXO+EA_NUM+EA_PARCELA)
			Else
 			    cChave 	 := SEA->(FWxFilial("SE1",SEA->EA_FILORIG)+EA_PREFIXO+EA_NUM+EA_PARCELA)
				cCampoSea := FWXFilial("SEA",SEA->EA_FILORIG)
			Endif

			// posiciono no titulo ORIGINAL (principal com tipo)
			dbSelectArea( "SE1" )
			dbSeek( cChave+SEA->EA_TIPO )
			While !Eof() .and. SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO) == cChave+SEA->EA_TIPO
				If SE1->E1_NUMBOR == SEA->EA_NUMBOR
					lAchou := .T.
					Exit
				Else
					dbSkip()
				Endif
			Enddo
			//Caso n�o tenha achado titulo no SE1, desconsidera para o bordero
			If !lAchou
				dbSelectArea("SEA")
				dbSkip()
				Loop
			Endif

			If(cPaisLoc<>"BRA" .And. SE1->E1_TIPO $ +IIF(Type('MVCHEQUES')=='C',MVCHEQUES,MVCHEQUE))
				nValor:= xMoeda(SE1->E1_VALOR+SE1->E1_SDACRES-SE1->E1_SDDECRE,SE1->E1_MOEDA,mv_par07,,ndecs+1)
				If dDatabase <> SE1->E1_EMIS1.and. mv_par07=1
					nValor:= (SE1->E1_VALOR * SE1->E1_TXMOEDA+SE1->E1_SDACRES-SE1->E1_SDDECRE)
				EndIf
			Else
				aValor:=Baixas(SE1->E1_NATUREZ,SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_MOEDA,"R",SE1->E1_CLIENTE,dDataBase,SE1->E1_LOJA)
				nValor:= xMoeda(IIF(SE1->E1_SALDO == 0, Iif(aValor[2] != SE1->E1_DESCONT .Or. aValor[3] != SE1->E1_JUROS .Or. aValor[4] != SE1->E1_MULTA,SE1->E1_VALOR - aValor[2] + (aValor[3] + aValor[4]),IIF(SE1->E1_SDACRES == 0 .And. SE1->E1_ACRESC > 0, SE1->(E1_VALOR+E1_ACRESC)-SE1->E1_DESCONT, SE1->E1_VALOR-SE1->E1_DESCONT)), SE1->E1_SALDO)-SE1->E1_SDDECRE+SE1->E1_SDACRES,SE1->E1_MOEDA,mv_par07,,ndecs+1)								
			EndIf

		 	// Template GEM
			If HasTemplate("LOT") .And. !Empty(SE1->E1_NCONTR)
				aAux := CMDtPrc( SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA, SE1->E1_VENCTO, SE1->E1_VENCTO )
				nValor += aAux[2] + aAux[3]
			EndIf

			dVencto:= E1_VENCTO
			cCodigo:= E1_CLIENTE
			cLoja	 := E1_LOJA
			If cPaisLoc == "PAR" .And. AllTrim(E1_ORIGEM) == "LOJA010"
			   cNumCheque  := E1_NUMCHQ
			   lMostraChq  := .T.
			EndIf
			nRecno := Recno()
			If !Empty( Iif( lGestao, FWFilial("SA1"), xFilial("SA1") ) )
				cFilOrig := SE1->E1_FILORIG
			Else
				cFilOrig := xFilial("SA1")
			EndIf
			dbSelectArea( "SA1" )
			dbSeek(cFilOrig+cCodigo+cLoja)
			cNome  := SubStr(A1_NOME,1,25)
			dbSelectArea("SEA")
			If !(SEA->EA_TIPO $ MV_CRNEG+"/"+MVABATIM)
				// procura pelos abatimentos do titulo (sem tipo, para pegar todos)
				dbSelectArea("SE1")
				dbSeek( cChave )
				While !Eof() .and. cCampoSea+SEA->(EA_PREFIXO+EA_NUM+EA_PARCELA)==SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA
					//����������������������������������������Ŀ
					//� Verifica se deve imprimir outras moedas�
					//������������������������������������������
					If mv_par08 == 2 // nao imprime
						If SE1->E1_MOEDA != mv_par07 //verifica moeda do campo=moeda parametro
							dbSkip()
							Loop
						Endif
					Endif

					If SE1->(E1_CLIENTE+E1_LOJA) != cCodigo+cLoja
						dbSkip()
						Loop
					Endif

					If SE1->E1_TIPO $ MVABATIM
						nAbat += xMoeda(SE1->E1_SALDO,SE1->E1_MOEDA,mv_par07,,ndecs+1)
				   	Endif
					dbSkip()
				Enddo
			Endif
		Else
			If Empty(SEA->EA_FILORIG) .AND. !Empty(xFilial("SE2"))
				cChave 	 := xFilial("SE2")+SEA->(EA_PREFIXO+EA_NUM+EA_PARCELA)
			Else
				cChave 	:= FWxFilial("SE2",SEA->EA_FILORIG)+SEA->(EA_PREFIXO+EA_NUM+EA_PARCELA)
				cCampoSea := "SEA->EA_FILORIG"
			Endif

			cLoja := Iif ( Empty(SEA->EA_LOJA) , "" , SEA->EA_LOJA )
			dbSelectArea( "SE2" )
			dbSeek(cChave+SEA->EA_TIPO+SEA->EA_FORNECE + cLoja )
			While !Eof() .and. SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA) == ;
					cChave+SEA->(EA_TIPO+EA_FORNECE+EA_LOJA)
				If SE2->E2_NUMBOR == SEA->EA_NUMBOR
					lAchou := .T.
					Exit
				Else
					dbSkip()
				Endif
			Enddo
			//Caso n�o tenha achado titulo no SE1, desconsidera para o bordero
			If !lAchou
				dbSelectArea("SEA")
				dbSkip()
				Loop
			Endif

			If(cPaisLoc<>"BRA" .And. SE2->E2_TIPO $ IIF(Type('MVCHEQUES')=='C',MVCHEQUES,MVCHEQUE))
				nValor:=xMoeda(SE2->E2_VALOR+SE2->E2_SDACRES-SE2->E2_SDDECRE,SE2->E2_MOEDA,mv_par07,,ndecs+1)
				If dDatabase <> SE1->E1_EMIS1.and. mv_par07=1
					nValor:= (SE1->E1_VALOR * SE1->E1_TXMOEDA+SE1->E1_SDACRES-SE1->E1_SDDECRE)
				EndIf
			Else
				aValor:=Baixas(SE2->E2_NATUREZ,SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_MOEDA,"P",SE2->E2_FORNECE,dDataBase,SE2->E2_LOJA)
				nValor:=xMoeda(IIF(SE2->E2_SALDO == 0, Iif(aValor[2] != SE2->E2_DESCONT .Or. aValor[3] != SE2->E2_JUROS .Or. aValor[4] != SE2->E2_MULTA,SE2->E2_VALOR - aValor[2] + (aValor[3] + aValor[4]),SE2->E2_VALOR-SE2->E2_DESCONT+SE2->E2_ACRESC), SE2->E2_SALDO)-SE2->E2_SDDECRE+SE2->E2_SDACRES,SE2->E2_MOEDA,mv_par07,,ndecs+1, SE2->E2_TXMOEDA ,&("SM2->M2_MOEDA" + STR(mv_par07,1)))
			EndIf

			// Template GEM
			If HasTemplate("LOT") .And. !Empty(SE1->E1_NCONTR)
				aAux := CMDtPrc( SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA, SE1->E1_VENCTO, SE1->E1_VENCTO )
				nValor += aAux[2] + aAux[3]
			EndIf

			dVencto:=E2_VENCTO
			cCodigo:=E2_FORNECE
			nRecno := Recno()
			dbSelectArea( "SA2" )
			If !Empty( Iif( lGestao, FWFilial("SA2"), xFilial("SA2") ) )
				cFilOrig := SE2->E2_FILORIG
			Else
				cFilOrig := xFilial("SA2")
			EndIf
			dbSeek(cFilOrig+cCodigo+cLoja)
			cNome  :=SubStr(A2_NOME,1,25)
			dbSelectArea("SEA")
			If !(SEA->EA_TIPO $ MV_CPNEG+"/"+MVABATIM)
				// procura pelos abatimentos do titulo (sem tipo, para pegar todos)
				dbSelectArea("SE2")
				dbSeek( cChave )
				While !Eof() .and. &cCampoSea+SEA->(EA_PREFIXO+EA_NUM+EA_PARCELA)==SE2->E2_FILIAL+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA
					//����������������������������������������Ŀ
					//� Verifica se deve imprimir outras moedas�
					//������������������������������������������
					If mv_par08 == 2 // nao imprime
						If SE2->E2_MOEDA != mv_par07 //verifica moeda do campo=moeda parametro
							dbSkip()
							Loop
						Endif
					Endif

					If SE2->E2_TIPO $ MVABATIM .AND. SEA->EA_FORNECE==SE2->E2_FORNECE
						nAbat += xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,mv_par07,,ndecs+1)
					Endif
					dbSkip()
				Enddo
			Endif
		EndIf
		// volta ao titulo ORIGINAL (principal com tipo)
		dbSelectArea(IIF(mv_par01 == 1, "SE1","SE2"))
		dbGoTo(nRecno)
		dbSelectArea( "SEA" )
		If  nValor > 0
			If ( li > 55 )  .Or. cChaveAnt#SEA->EA_FILIAL+SEA->EA_NUMBOR
				If cChaveAnt==SEA->EA_FILIAL+SEA->EA_NUMBOR//( m_pag != 1 )
					li++
					@li, 0 PSAY REPLICATE("-",IIf(aTam[1] > 6,TamParcela(cCampo,106,107,108),TamParcela(cCampo,94,95,96)))
				EndIf
				If cChaveAnt#SEA->EA_FILIAL+SEA->EA_NUMBOR .And. !Empty(cChaveAnt)

					SM0->(dbSeek(cEmpAnt+cFilAtu))

					F170Rodape(SM0->M0_NOMECOM, nValTot, aTam, cCampo, li, aColu, nContador)
					lUltRodape := .F.
					nValTot:=0
					nContador:=0
				EndIf
				li++
				li++
				fr170cabec(lMostraChq, cChaveAnt#SEA->EA_FILIAL+SEA->EA_NUMBOR)
				lUltRodape := .T.
				m_pag++
				cChaveAnt:=SEA->EA_FILIAL+SEA->EA_NUMBOR
			EndIf
			li++
			@li, 0 PSAY "|"
			If lMostraChq
			   @li, 1 PSAY cNumCheque
			Else
			   @li, 1 PSAY EA_PREFIXO
			   @li, 5 PSAY EA_NUM
			EndIf
			@li,27 PSAY "|"
			@li,28 PSAY TamParcela(cCampo,Left(EA_PARCELA,1),Left(EA_PARCELA,2),Left(EA_PARCELA,3))
			@li,TamParcela(cCampo,29,30,31) PSAY "|"
			@li,TamParcela(cCampo,30,31,32) PSAY cCodigo
			@li,aColu[1] PSAY "|"
			@li,aColu[2] PSAY cNome
			@li,aColu[3] PSAY "|"
			@li,aColu[4] PSAY dVencto
			@li,aColu[5] PSAY "|"
			@li,aColu[6] PSAY (nValor - nAbat) Picture PesqPict("SE1","E1_VALOR",18,MV_PAR07)
			@li,aColu[7] PSAY "|"
			nValTot += nValor - nAbat
			nContador ++
			nAbat := 0
		EndIf
		cFilAtu	:=	SEA->EA_FILIAL
		dbSkip()
	EndDo
	#IFDEF TOP
		Exit
	#ELSE
		If Empty(xFilial("SEA"))
			Exit
		Endif
		dbSelectArea("SM0")
		dbSkip()
	#ENDIF
Enddo

If !SM0->(dbSeek(cEmpAnt+cFilAtu))
	SM0->(dbGoto(nRegEmp))
EndIf
cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )

If lUltRodape
	F170Rodape(SM0->M0_NOMECOM, nValTot, aTam, cCampo, li, aColu, nContador)
EndIf

SM0->(dbGoto(nRegEmp))
cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )

#IFDEF TOP
	dbSelectArea("SEA")
	DbCloseArea()
	chkfile("SEA")
#ENDIF

#IFNDEF TOP
	If !lAchouFil
		Set Device to Screen
		Help(" ",1,"NOBORDERO")
		SM0->(dbGoto(nRegEmp))
		cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
		dbSelectArea("SEA")
		dbSetOrder(1)
		Set Filter to
		cFilAnt:= cGravFil
		Return
	Endif
#ENDIF

Set Device To Screen
dbSelectArea("SE1")
dbSetOrder(1)
Set Filter To

If aReturn[5] = 1
	Set Printer To
	dbCommit()
	Ourspool(wnrel)
EndIf
MS_FLUSH()

 cFilAnt:= cGravFil
Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fr170cabec� Autor � Wagner Xavier         � Data � 24.05.93 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Cabecalho do Bordero                                       ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e �fr170cabec()                                                ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
Static Function fr170cabec(lMostraChq, lNew)

Local lWin    := .f.
Local aTam    := Iif(mv_par01==1,TAMSX3("E1_CLIENTE"),TAMSX3("E2_FORNECE"))
Local cCampo  := If(mv_par01==1,"E1_PARCELA","E2_PARCELA")
Local aCabec
Local nTipo := If(aReturn[4]==1,15,18)
Local cLayoutSM0 := FWSM0Layout()
Local lGestao	 := Substr(cLayoutSM0,1,1) $ "E|U"

//�������������������������������������������������������������������Ŀ
//� Executa o Cabec() para impress�o da p�gina de par�metros.         �
//���������������������������������������������������������������������
nTam 	 	:= 132
dDataRef := dDataBase
lPerg 	:= If(GetMv("MV_IMPSX1") == "S" ,.T.,.F.)
cNomPrg 	:= Alltrim(nomeprog)
aCabec   :=	{"__LOGOEMP__"}

Cabec(Titulo, "", "", cNomPrg, tamanho, nTipo, aCabec)


If m_pag == 1

	If TYPE("__DRIVER") == "C"
		If "DEFAULT"$__DRIVER
			lWin := .T.
		EndIf
	EndIf

	If GetMV("MV_CANSALT",,.T.) // Saltar uma p�gina na impress�o
		If GetMv("MV_SALTPAG",,"S") != "N"
			Setprc(0,0)
		EndIf
	Endif

	//�������������������������������������������������������������������Ŀ
	//� Faz manualmente porque nao chama a funcao Cabec()                 �
	//���������������������������������������������������������������������
	If	(TAMSX3("E1_CLIENTE")[1] + TAMSX3("E1_LOJA")[1] > 8) .or.;
		(TAMSX3("E2_FORNECE")[1] + TAMSX3("E2_LOJA")[1] >8) .or.;
	   (TAMSX3("E1_PARCELA")[1] + TAMSX3("E2_PARCELA")[1] > 4)
		nLargura:=132
		@ 0,0 PSay AvalImp(132)
    Else
    	nLargura:=080
		@ 0,0 PSay AvalImp(80)
    EndIf

EndIf

If !Empty( Iif( lGestao, FWFilial("SA6"), xFilial("SA6") ) )
	cFilOrig := IIF( mv_par01 == 1, SE1->E1_FILORIG, SE2->E2_FILORIG )
Else
	cFilOrig :=  xFilial("SA6")
EndIf

dbSelectArea("SA6")
dbSeek(cFilOrig+SEA->EA_PORTADO+SEA->EA_AGEDEP+SEA->EA_NUMCON)

If lNew
	@ 5, 0 PSAY OemToAnsi(STR0024)+SA6->A6_NOME //"AO "
	@ 6, 0 PSAY OemToAnsi(STR0016)+SA6->A6_AGENCIA + OemToAnsi(STR0017)+SEA->EA_NUMCON  // "AGENCIA "###" C/C "
	@ 7, 0 PSAY ALLTRIM(SA6->A6_BAIRRO)+" - "+ALLTRIM(SA6->A6_MUN)+" - "+ALLTRIM(SA6->A6_EST)
	@ 8, 0 PSAY OemToAnsi(STR0018)+SEA->EA_NUMBOR+" - "+OemToAnsi(STR0039)+DTOC(SEA->EA_DATABOR)  //"BORDERO NRO "###"Emitido em: "
	If mv_par01 == 1
		@ 9, 0 PSAY OemToAnsi(STR0019)  //"Solicitamos proceder o recebimento das duplicatas abaixo relacionadas"
		@10, 0 PSAY OemToAnsi(STR0020)  //"CREDITANDO-NOS os valores correspondentes."
	Else
		@ 9, 0 PSAY OemToAnsi(STR0021)  //"Solicitamos proceder o pagamento das duplicatas abaixo relacionadas"
		@10, 0 PSAY OemToAnsi(STR0022)  //"DEBITANDO-NOS os valores correspondentes."
	EndIf
	li:=11
	If ( !Empty ( cComple1 ) )
		@li++, 0 PSAY cComple1
	EndIf
	If	( !Empty ( cComple2 ) )
		@li++, 0 PSAY cComple2
	EndIf
	If !Empty ( cComple3 )
		@li++ , 0 PSAY cComple3
	EndIf
	li+=2
Else
	li:=5
EndIf
@li, 0 PSAY "|"+REPLICATE("-",IIf(aTam[1] > 6 , TamParcela(cCampo,106,107,108), TamParcela(cCampo,93,94,95)))+"|"
li++
If lMostraChq
   @li, 0 PSAY "|"+IIf(aTam[1] > 6,TamParcela(cCampo,STR0031,STR0034,STR0035),TamParcela(cCampo,STR0030,STR0032,STR0033))  //"NUM CHEQUE      |P|CODIGO|R A Z A O   S O C I A L  | VENCTO   |         VALOR |"
Else
   @li, 0 PSAY "|"+IIf(aTam[1] > 6,TamParcela(cCampo,STR0025,STR0028,STR0029),TamParcela(cCampo,STR0023,STR0026,STR0027))  //"NUM DUPLIC      |P|CODIGO|R A Z A O   S O C I A L  | VENCTO |         VALOR   |"
EndIf
li++
@li, 0 PSAY "|"+REPLICATE("-",IIF(aTam[1]>6,TamParcela(cCampo,106,107,108),TamParcela(cCampo,93,94,95)))+"|"
dbSelectArea( "SEA" )

Return .T.

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fr170cabec� Autor � Adilson H Yamaguchi   � Data � 09.05.05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Rodape                                                     ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e �f170Rodape()                                                ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
Static Function F170Rodape(cEmpresa, nValTot, aTam, cCampo, li, aColu, nContador)
If ( nValTot != 0 )
	While ( li <= 49 .and. nValTot != 0 )
		li++
		@li, 0 PSAY "|"
		@li,27 PSAY "|"
		@li,TamParcela(cCampo,29,30,31) PSAY "|"
		@li,aColu[1] PSAY "|"
		@li,aColu[3] PSAY "|"
		@li,aColu[5] PSAY "|"
		@li,aColu[7] PSAY "|"
	Enddo
	li++
	@li, 0 PSAY "|"+REPLICATE("-",IIF(aTam[1]>6,TamParcela(cCampo,104,105,106),TamParcela(cCampo,93,94,95)))+"|"
	li++
	If mv_par01 == 1
		@li, 0 PSAY OemToAnsi(STR0011)+IIF(aTam[1]>6,Space(16),"")+IIF(aTam[1]>6,TamParcela(cCampo,"        | ","         | ","          | "),TamParcela(cCampo,"          | ","           | ","            | "))+;
		Transform(nValTot,PesqPict("SE1","E1_VALOR",18,MV_PAR07))+IIF(aTam[1]>6," |", " |")  //"@E 9999,999,999.99")+"|"  //"|   TOTAL DA RELACAO A CREDITO DE NOSSA CONTA CORRENTE       "
	Else
		@li, 0 PSAY OemToAnsi(STR0012)+IIF(aTam[1]>6,Space(16),"")+IIF(aTam[1]>6,TamParcela(cCampo,"        | ","         | ","          | "),TamParcela(cCampo,"          | ","           | ","            | "))+;
		Transform(nValTot,PesqPict("SE1","E1_VALOR",18,MV_PAR07))+IIF(aTam[1]>6," |", " |")			//Transform(nValTot,"@E 9999,999,999.99")+"|"  //"|   TOTAL DA RELACAO A DEBITO DE NOSSA CONTA CORRENTE        "
	EndIf
	li ++

	@li, 0 PSAY OemToAnsi(STR0013)+IIF(aTam[1]>6,Space(14),"")+TamParcela(cCampo,"          |","           |","            |")  //"|   QUANTIDADE  DE TITULOS IMPRESSOS                         "
	@li, aColu[6] PSAY nContador PICTURE "@E 999999999999999999"
	@li, aColu[7] PSAY "|"

	li++
	@li, 0 PSAY "|"+REPLICATE("-",iif(aTam[1]>6,TamParcela(cCampo,104,105,106),TamParcela(cCampo,93,94,95)))+"|"
	li+=2
	@li, 0 PSAY OemToAnsi(STR0014) + DTOC(dDataBase)  //"Data: "
	@li,35 PSAY OemToAnsi(STR0015)  //"Atenciosamente"
	li+=1
	@li,35 PSAY cEmpresa
	li+=2
	@li,35 PSAY REPLICATE("-",Len(Trim(cEmpresa)))
	li++
	@li,0  PSAY " "
EndIf
Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MsModoFil � Autor  � Jose Lucas       � Data �17.06.2011   ���
�������������������������������������������������������������������������͹��
���Desc.     � Retornar o modo de compartilhamento de cada tabela.        ���
�������������������������������������������������������������������������͹��
���Sintaxe   � ExpA1 := MsModoFil(ExpC1)                                  ���
�������������������������������������������������������������������������͹��
���Parametros� ExpC1 := Alias da tabela a pesquisar.                      ���
�������������������������������������������������������������������������͹��
���Uso       � FINR170                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MsModoFil(cAlias)
Local aSavArea := GetArea()
Local aModo := {"","",""}

SX2->(dbSetOrder(1))
If SX2->(dbSeek(cAlias))
   aModo[1] := SX2->X2_MODO
   aModo[2] := SX2->X2_MODOUN
   aModo[3] := SX2->X2_MODOEMP
EndIf
RestArea(aSavArea)
Return aModo

/***********************************************************************************/
USER FUNCTION GATCTT()
        
M->E2_XDESCCC := POSICIONE("CTT",1,XFILIAL("CTT")+M->E2_CCUSTO,"CTT_DESC01") 

RETURN(.T.)