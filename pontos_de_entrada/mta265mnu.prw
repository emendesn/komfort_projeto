#include 'protheus.ch'
#include 'parmtype.ch'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA265MNU �Autor  � Cristiam Rossi       Data �  12/05/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para adicionar botao no Browse da rotina  ���
���          � Endere�ar.                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � KomfortHouse / GLOBAL                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MTA265MNU()

	aadd(aRotina,{ "Imprimir Etiqueta", "StaticCall( MTA265MNU , ImpZebra )", 0 , 6, 0, .F.})

Return Nil

/*==========================================================================
Funcao.....: ImpZebra
Descricao..: Verifica se todos os produtos tem codigo de barras
Autor......: Jackson Santos
Data.......: 17/04/2013
Parametros.: Nil
Retorno....:
==========================================================================*/
Static Function ImpZebra()
Local   aArea       := getArea()
Private cCodFor		:= SDA->DA_CLIFOR
Private cLojaFor	:= SDA->DA_LOJA
Private cNotaFis	:= SDA->DA_DOC
Private cSrNFis		:= SDA->DA_SERIE
Private aProEan13   := {}
Private lAviso      := .T.
Private lSKipAll    := .F.
Private lValEan     := ( cEmpAnt == '01' )
Private cPrdEnde    := ""

	if SDA->DA_ORIGEM == "SD1"		// por enquanto somente Notas Fiscais de Entrada
		SF1->( dbSetOrder(1) )	// F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
		if ! SF1->( dbSeek( xFilial("SF1") + cNotaFis + cSrNFis + cCodFor + cLojaFor, .T. ) )
			msgAlert("Documento de Entrada n�o encontrado, verifique!", "Impress�o de Etiquetas")
			return nil
		endif

		if ! ValEnderc()
			Aviso("Impress�o de Etiquetas", cPrdEnde, {"Ok"},3)
			return nil
		endif

// EXECUTA ROTINA PARA VALIDAR CODBAR
		FwMsgRun(, {|| ValidCodBar() }, , "Validando codigo de barras, Por favor Aguarde" )

		If Len(aProEan13) > 0 .and. FindFunction("U_KFHETIQU") .and. MsgYesNo('Deseja imprimir etiquetas dos produtos ?')
			U_KFHETIQU(aProEan13,.T.)
		Endif
	else
		msgAlert("Esta rotina s� imprime Documento de Entrada!", "Impress�o de Etiquetas")
	endif

	restArea( aArea )
Return Nil

/*==========================================================================
Funcao.....: ImpZebra
Descricao..: Verifica se todos os produtos tem codigo de barras
==========================================================================*/
Static Function ValidCodBar
Local aAreaAT	:= GetArea()
Local aAreaF1	:= SF1->(GetArea())
Local aAreaD1	:= SD1->(GetArea())
Local nW

if SF1->F1_TIPO == "D"
	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1") + cCodFor + cLojaFor))
else
	SA2->(DbSetOrder(1))
	SA2->(DbSeek(xFilial("SA2") + cCodFor + cLojaFor ))
endif

DbSelectarea("SD1")
SD1->(DbSetorder(1))
If SD1->(DbSeek(xFilial("SD1") + cNotaFis + cSrNFis + cCodFor + cLojaFor))
	While !SD1->(Eof()) .And.	SD1->D1_FILIAL == xFilial("SD1") .And.;
		SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA == cNotaFis + cSrNFis + cCodFor + cLojaFor
		
		If lValEan
//			for nW := 1 to SD1->D1_QUANT
			ValidaEan13( SD1->D1_QUANT )
//			next
		Endif
		
		SD1->(DbSkip())
	Enddo
EndIf

RestArea(aAreaAT)
RestArea(aAreaF1)
RestArea(aAreaD1)
Return Nil
/*==========================================================================
Funcao.....: VALEAN13
Descricao..: Valida codEan13 no cadastro do Produto campo B1_CODBAR
Autor......: Jackson Santos
Data.......: 17/04/2013
Parametros.: Nil
Retorno....: .T. ou .F.
==========================================================================*/
Static Function ValidaEan13( nQuant )
Local   aArea    := GetArea()
Local   aAreaSD1 := SD1->(GetArea())

Local   cCodOri  := Alltrim(SD1->D1_COD)
Local   cCodBar  := ''
Local   cCodEan  := ''
Local   cDigEan  := ''

Local   nOpcAviso:= 0
Local   cMsgAviso:= ''
Local   cTituloAv:= "Aten��o - valida��o codigo [EAN13]"
Local   aOpcAviso:= {"Sim","Sim p/Todos","N�o"}
Local   lOk		 := .F.
Local cGrpNaoPri := SuperGetMv("GL_NAOIMPR",,"2001;2002")
Local   aEnderec   := {}
Local   nI

dbSelectArea('SB1')
SB1->(dbSetOrder(1))
If SB1->(MsSeek(xFilial('SB1')+cCodOri)) .and. ! SB1->B1_GRUPO $ cGrpNaoPri
	If Select("TSDB") > 0
		TSDB->(DbCloseArea())
	Endif
	cQryEnd := " SELECT LTRIM(RTRIM(DB_LOCALIZ)) ENDPRINC "
	cQryEnd +=  " FROM " + RetSqlName("SDB") + "  SDB "
	cQryEnd +=  " WHERE SDB.DB_FILIAL = '" + SD1->D1_FILIAL + "'"
	cQryEnd +=  " AND SDB.DB_PRODUTO = '" + SD1->D1_COD + "'"
	cQryEnd +=  " AND SDB.DB_DOC='" + SD1->D1_DOC + "'"
	cQryEnd +=  " AND SDB.DB_SERIE = '" + SD1->D1_SERIE + "'"
	cQryEnd +=  " AND SDB.DB_CLIFOR = '" + SD1->D1_FORNECE + "'"
	cQryEnd +=  " AND SDB.DB_LOJA = '" + SD1->D1_LOJA + "'"
	cQryEnd +=  " AND SDB.DB_NUMSEQ = '" + SD1->D1_NUMSEQ + "'"	
	cQryEnd +=  " AND SDB.DB_ORIGEM = 'SD1' "
	cQryEnd +=  " AND SDB.DB_LOCALIZ <> ''"
	cQryEnd +=  " AND SDB.DB_ESTORNO <> 'S'"
	cQryEnd +=  " AND SDB.D_E_L_E_T_ <> '*'"
	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQryEnd),"TSDB",.F.,.T.)
/*
	If TSDB->(!EOF())
		cEndPrinc := TSDB->ENDPRINC
	Else
		cEndPrinc := "SEM LOCALIZACAO"
	EndIf
*/
	while ! TSDB->( EOF() )
		aadd( aEnderec, TSDB->ENDPRINC)
		TSDB->( dbSkip() )
	end

	aSize( aEnderec, nQuant )

	for nI := 1 to nQuant
		if valType( aEnderec[nI] ) == "U"
			aEnderec[nI] := "SEM LOCALIZACAO"
		endif
	next

	If Select("TSDB") > 0
		TSDB->(DbCloseArea())
	Endif

	cCodBar  := SB1->B1_CODBAR
	cCodEan  := ''
	cDigEan  := Eandigito(cCodOri)
	cCodEan  := Padl( Left(cCodOri,12) , 12 , '0' ) + cDigEan

	cDimensoes := ""

	DbSelectArea("SB5")
	SB5->(DbSetOrder(1))
	If SB5->(DbSeek(xFilial("SB5") + SB1->B1_COD))
		cDimensoes := cValToChar(SB5->B5_ALTURLC) + " x "+  cValToChar(SB5->B5_LARGLC) + " x " + cValToChar(SB5->B5_COMPRLC)
	EndIf 

	&& ADICIONA PROUTOS PARA LEITURA DE CODIGO DE BARRAS
//	Aadd( aProEan13 , {B1_COD,B1_DESC,B1_CODBAR,SA2->A2_NOME + "-" + SA2->A2_NOME,DTOC(SD1->D1_DTDIGIT),"","XXXX","TESTE"} )

	for nI := 1 to nQuant
		cEndPrinc := aEnderec[nI]
		if SF1->F1_TIPO == "D"                                                                      
			Aadd( aProEan13 , {SB1->B1_COD,SB1->B1_DESC,SB1->B1_CODBAR,SA1->A1_COD + "/" + SA1->A1_LOJA + " - " + Alltrim(SA1->A1_NOME),DTOC(SD1->D1_DTDIGIT),cEndPrinc," ",cDimensoes,SD1->D1_DOC,SD1->D1_SERIE,SD1->D1_ITEM} ) 
		else
			Aadd( aProEan13 , {SB1->B1_COD,SB1->B1_DESC,SB1->B1_CODBAR,SA2->A2_COD + "/" + SA2->A2_LOJA + " - " + Alltrim(SA2->A2_NOME),DTOC(SD1->D1_DTDIGIT),cEndPrinc," ",cDimensoes,SD1->D1_DOC,SD1->D1_SERIE,SD1->D1_ITEM} )
		endif
	next
Endif

RestArea(aArea)
RestArea(aAreaSD1)

DbSelectarea("SD1")
SD1->(DbSetorder(1))

Return nil


//-----------------------------------------------
Static Function ValEnderc()		// verificar se todos os itens est�o endere�ados
Local aArea := getArea()

	cPrdEnde := ""

	SDA->( dbSetOrder(1) )	// DA_FILIAL+DA_PRODUTO+DA_LOCAL+DA_NUMSEQ+DA_DOC+DA_SERIE+DA_CLIFOR+DA_LOJA

	SD1->( dbSetOrder(1) )
	SD1->( dbSeek( xFilial("SD1") + cNotaFis + cSrNFis + cCodFor + cLojaFor ) )

	while ! SD1->( EOF() ) .and. SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == xFilial("SD1") + cNotaFis + cSrNFis + cCodFor + cLojaFor

		if SDA->( dbSeek( xFilial("SDA") + SD1->(D1_COD+D1_LOCAL+D1_NUMSEQ+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) ) )
			if SDA->DA_SALDO > 0
				cPrdEnde += "Produto: "+alltrim(SD1->D1_COD)+" tem saldo a endere�ar" + CRLF
			endif
		endif

		SD1->( dbSkip() )
	end

	restArea( aArea )
return empty( cPrdEnde )
