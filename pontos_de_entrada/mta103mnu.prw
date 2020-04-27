#include 'protheus.ch'
#include 'parmtype.ch'


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA103MNU ºAutor  ³ Jackson Santos       Data ³  12/04/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para adicionar botao no Browse das notas  º±±
±±º          ³ de Entrada.                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ KomfortHouse.                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MTA103MNU()

AAdd(aRotina,{ "Imp.Etiqueta", "StaticCall( MTA103MNU , ImpZebra )", 0 , 4, 0, .F.})

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
Local   bExecRot    := {|| FwMsgRun(, {|| ValidCodBar() }, , "Validando codigo de barras, Por favor Aguarde" )}
Private cCodFor		:= SF1->F1_FORNECE 
Private cLojaFor	:= SF1->F1_LOJA
Private cNotaFis	:= SF1->F1_DOC
Private cSrNFis		:= SF1->F1_SERIE

// Bruno Abrigo -->>
Private aProEan13   := {}
Private lAviso      := .T.
Private lSKipAll    := .F.
Private lValEan     := ( cEmpAnt == '01' )

&& EXECUTA ROTINA PARA VALIDAR CODBAR
Eval(bExecRot)


If Len(aProEan13) > 0 .and. FindFunction("U_KFHETIQU") .and. MsgYesNo('Deseja imprimir etiquetas dos produtos ?')
	U_KFHETIQU(aProEan13,.T.)
Endif

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
Local   aArea      := GetArea()
Local   aAreaSD1   := SD1->(GetArea())
Local   cCodOri    := Alltrim(SD1->D1_COD)
Local   cCodBar    := ''
Local   cCodEan    := ''
Local   cDigEan    := ''
Local   nOpcAviso  := 0
Local   cMsgAviso  := ''
Local   cTituloAv  := "Atenção - validação codigo [EAN13]"
Local   aOpcAviso  := {"Sim","Sim p/Todos","Não"}
Local   lOk		   := .F.
Local   cGrpNaoPri := SuperGetMv("GL_NAOIMPR",,"2001;2002")
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
	cQryEnd +=  " AND SDB.DB_NUMSEQ = '" + SD1->D1_NUMSEQ + "'"//#RVC20180827.n
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

Return
