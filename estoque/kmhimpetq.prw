#include 'protheus.ch'
#include 'parmtype.ch'
#include "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
/*==========================================================================
Funcao.....: ZEPIMPETQ
Descricao..: Impressao de Etiquetas Zeppini
Autor......: Jackson Santos
Data.......: 22/08/2016
Parametros.: Nil
Retorno....: Nil
==========================================================================*/
User Function KMHIMPETQ(nRotCham,aProEan13)
	Local oDlgEtq
	Local cCodEndDe	 := Space(15)
	Local cCodEndAt  := Space(15)
	Local cCodLocDe  := Space(02)
	Local cCodLocAt  := Space(02)
	Local cQtdEtq 	 := SPACE(03)
	Private cCodProdDe := SPACE(15)
	Private cCodProdAt := SPACE(15)

	Private cGetCodDe := ""
	Private cGetCodAt := ""
	Private cGetEndDe := ""
	Private cGetEndAt := ""                   
	Private cGetLocDe := ""
	Private cGetLocAt := ""
	Private cGetTpEtq := space(02)
	//Private aGetTpEtq := {"01-30x100-Pequena","02-75x100-Grande"}
	Private aGetTpEtq := {"01-Unico"}
	Private cLotePrd  := Space(12)
	Private cLocImpr    := "000001"
	Private nTipoEtq  := 0
	Private nOpcSel := 0    
	Default nRotCham := 0 //1=MA010BUT 2-LJ110MENU
	Default aProEan13 := {}
	cQtdEtq := "  1"                               

	nTipoEtq := Aviso("Atenção", "Escolha o tipo de Etiqueta a ser impressa.",{"Nota Entrada","Nota Saida","Sair"}, 3)

	If nTipoEtq == 1
		U_ImpZebra(.T.,.T.,.F.)

	ElseIf nTipoEtq == 2
		U_ImpZebra(.T.,.F.,.F.)
	EndIf

Return Nil


/*==========================================================================
Funcao.....: ImpZebra
Descricao..: Verifica se todos os produtos tem codigo de barras
Autor......: Jackson Santos
Data.......: 17/04/2013
Parametros.: Nil
Retorno....:
==========================================================================*/
User Function ImpZebra(lNotPE,lEntrada,lTransfer, lQuiet)
	Local   bExecRot    := {} //{|| FwMsgRun(, {|| ValidCodBar() }, , "Validando codigo de barras, Por favor Aguarde" )}
	Local   oDlgPrc
	Local   aCNPJs      := {}
	Local   _cCNPJ      := ""

	Private cCodFor		:= "" //SF1->F1_FORNECE 
	Private cLojaFor	:= "" //SF1->F1_LOJA
	Private cNotaFis	:= "" //SF1->F1_DOC
	Private cSrNFis		:= "" //SF1->F1_SERIE

	// Bruno Abrigo -->>
	Private aProEan13   := {}
	Private lAviso      := .T.
	Private lSKipAll    := .F.
	Private lValEan     := ( cEmpAnt == '01' )

	Private cXNumNota := SPACE(09)
	Private cXSerNota := SPACE(03)
	Private cXFornece := SPACE(06)
	Private nQtdEtq	  := 1

	Private nOpcSel := 0          

	Default lTransfer := .F.
	Default lNotPE    := .F.
	Default lQuiet    := .F.

	aAreaSM0 := SM0->( getArea() )
	SM0->( dbGotop() )
	while ! SM0->( EOF() )
		aadd( aCNPJs, SM0->M0_CGC )
		SM0->( dbSkip() )
	end
	SM0->( restArea( aAreaSM0 ) )

	If lNotPE
		DEFINE MSDIALOG oDlgPrc TITLE "Seleçao da Nota Fiscal"  of oMainWnd PIXEL FROM  47,130 TO 300,490

		//@ 006, 04 BITMAP RESOURCE "CUSTOMER" OF oDlgPrc PIXEL SIZE 32,32 ADJUST When .F. NOBORDER
		@ 005, 020 TO 39, 130 LABEL 'Nota Fiscal' 	OF oDlgPrc  PIXEL
		@ 050, 020 TO 90, 130 LABEL 'Série'  		OF oDlgPrc PIXEL

		@ 095, 040 Say IIF(lEntrada,"Fornecedor:","Cliente:") Size 060,10  COLOR CLR_BLUE Of oDlgPrc Pixel 
		@ 095, 080 Say "Qtd." Size 040,10  COLOR CLR_BLUE Of oDlgPrc Pixel

		@ 20, 25 MSGET cXNumNota SIZE 070,10 When .T. PIXEL OF oDlgPrc 
		@ 65, 25 MSGET cXSerNota SIZE 030,10 When .T. PIXEL OF oDlgPrc 

		//	@ 110,25 MSGET cXFornece PICTURE "@!" F3 IIF(lEntrada,"SA2","SA1") SIZE 35,10 /*When IIF(nOpcRad == 3,.T.,.T.)*/ PIXEL OF oDlgPrc 

		@ 110,25 MSGET cXFornece PICTURE "@!" F3 IIF(lEntrada,"SA2","SA1") SIZE 35,10 /*When IIF(nOpcRad == 3,.T.,.T.)*/ PIXEL OF oDlgPrc        
		@ 110,80 MSGET nQtdEtq PICTURE "@E 999" SIZE 35,10  PIXEL OF oDlgPrc
		DEFINE SBUTTON FROM 090, 150 oButton1 TYPE 1 ENABLE OF oDlgPrc ;
		ACTION Processa({|| nOpcSel := 1, oDlgPrc:End() }) PIXEL

		DEFINE SBUTTON FROM 105, 150 oButton2 TYPE 2 ENABLE OF oDlgPrc ;
		ACTION Processa({|| nOpcSel := 2,oDlgPrc:End() }) PIXEL

		ACTIVATE MSDIALOG oDlgPrc CENTERED

		If nOpcSel == 1

			If lEntrada
				DbSelectArea("SF1")
				SF1->(DbSetOrder(1))
				SF1->(DbSeek(xFilial("SF1") + Padr(Alltrim(cXNumNota),9) + Alltrim(cXserNota) + cXFornece + "01" ))

				if SF1->F1_TIPO == "D"
					SA1->(DbSetOrder(1))
					if SA1->(DbSeek(xFilial("SA1") + cXFornece + "01" ))
						_cCNPJ := SA1->A1_CGC
					endif
				else
					SA2->(DbSetOrder(1))
					if SA2->(DbSeek(xFilial("SA2") + cXFornece + "01" ))
						_cCNPJ := SA2->A2_CGC
					endif
				endif

				cCodFor		:= SF1->F1_FORNECE 
				cLojaFor	:= SF1->F1_LOJA
				cNotaFis	:= SF1->F1_DOC
				cSrNFis		:= SF1->F1_SERIE
				bExecRot    := {|| FwMsgRun(, {|| ValidCodBar(lEntrada) }, , "Validando codigo de barras, Por favor Aguarde" )}

			Else

				DbSelectArea("SF2")
				SF2->(DbSetOrder(1))
				SF2->(DbSeek(xFilial("SF2") + Padr(Alltrim(cXNumNota),9) + Alltrim(cXserNota) + cXFornece + "01" ))

				if SF2->F2_TIPO == "D"
					SA2->(DbSetOrder(1))
					if SA2->(DbSeek(xFilial("SA2") + cXFornece + "01" ))
						_cCNPJ := SA2->A2_CGC
					endif
				else
					SA1->(DbSetOrder(1))
					if SA1->(DbSeek(xFilial("SA1") + cXFornece + "01" ))
						_cCNPJ := SA1->A1_CGC
					endif
				endif

				cCodFor		:= SF2->F2_CLIENTE 
				cLojaFor	:= SF2->F2_LOJA
				cNotaFis	:= SF2->F2_DOC
				cSrNFis		:= SF2->F2_SERIE
				bExecRot    := {|| FwMsgRun(, {|| ValidCodBar(lEntrada) }, , "Validando codigo de barras, Por favor Aguarde" )}
			EndIf

			lTransfer := aScan( aCNPJs, _cCNPJ ) > 0

			&& EXECUTA ROTINA PARA VALIDAR CODBAR
			Eval(bExecRot)


			If Len(aProEan13) > 0 .and. FindFunction("U_KFHETIQU") .and. iif(lQuiet, .T., MsgYesNo('Deseja imprimir etiquetas dos produtos ?') )
				U_KFHETIQU(aProEan13,lEntrada,nQtdEtq,lTransfer)
			Endif				
		EndIf	
	Else
		If lEntrada
			cCodFor		:= SF1->F1_FORNECE 
			cLojaFor	:= SF1->F1_LOJA
			cNotaFis	:= SF1->F1_DOC
			cSrNFis		:= SF1->F1_SERIE

			if SF1->F1_TIPO == "N"
				_cCNPJ := Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_CGC")
			else
				_cCNPJ := Posicione("SA1",1,xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA,"A1_CGC")
			endif

		Else
			cCodFor		:= SF2->F2_CLIENTE 
			cLojaFor	:= SF2->F2_LOJA
			cNotaFis	:= SF2->F2_DOC
			cSrNFis		:= SF2->F2_SERIE

			if SF2->F2_TIPO == "N"
				_cCNPJ := Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_CGC")
			else
				_cCNPJ := Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_CGC")
			endif
		EndIf

		bExecRot    := {|| FwMsgRun(, {|| ValidCodBar(lEntrada) }, , "Validando codigo de barras, Por favor Aguarde" )}
		&& EXECUTA ROTINA PARA VALIDAR CODBAR
		Eval(bExecRot)

		lTransfer := aScan( aCNPJs, _cCNPJ ) > 0

		If Len(aProEan13) > 0 .and. FindFunction("U_KFHETIQU") .and. iif( lQuiet, .T., MsgYesNo('Deseja imprimir etiquetas dos produtos ?') )
			U_KFHETIQU(aProEan13,lEntrada,nQtdEtq,lTransfer)
		Endif

	EndIf


Return Nil

/*==========================================================================
Funcao.....: ImpZebra
Descricao..: Verifica se todos os produtos tem codigo de barras
==========================================================================*/
Static Function ValidCodBar(lEntrada)
	Local aAreaAT	:= GetArea()
	Local aAreaF1	:= {} //SF1->(GetArea())
	Local aAreaD1	:= {} //SD1->(GetArea())
	Local AaReaF2	:= {} //SF2->(GetArea())
	Local aAreaD2   := {} //SD2->(GetArea())
	Local nW

	If lEntrada
		aAreaF1 := SF1->(GetArea())
		aAreaD1 := SD1->(GetArea())

		DbSelectarea("SD1")
		SD1->(DbSetorder(1))
		If SD1->(DbSeek(xFilial("SD1") + cNotaFis + cSrNFis + cCodFor + cLojaFor))
			While !SD1->(Eof()) .And.	SD1->D1_FILIAL == xFilial("SD1") .And.;
			SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA == cNotaFis + cSrNFis + cCodFor + cLojaFor
				If lValEan
					//				for nW := 1 to SD1->D1_QUANT
					ValidaEan13(lEntrada, SD1->D1_QUANT)
					//				next
				Endif

				SD1->(DbSkip())
			Enddo
		EndIf

		RestArea(aAreaAT)
		RestArea(aAreaF1)
		RestArea(aAreaD1)
	Else
		aAreaF2 := SF2->(GetArea())
		aAreaD2 := SD2->(GetArea())

		DbSelectarea("SD2")
		SD2->(DbSetorder(3))
		If SD2->(DbSeek(xFilial("SD2") + cNotaFis + cSrNFis + cCodFor + cLojaFor))
			While !SD2->(Eof()) .And.	SD2->D2_FILIAL == xFilial("SD2") .And.;
			SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_CLIENTE + SD2->D2_LOJA == cNotaFis + cSrNFis + cCodFor + cLojaFor
				If lValEan
					//				for nW := 1 to SD2->D2_QUANT
					ValidaEan13(lEntrada, SD2->D2_QUANT)
					//				next
				Endif			
				SD2->(DbSkip())
			Enddo
		EndIf	
		RestArea(aAreaAT)
		RestArea(aAreaF2)
		RestArea(aAreaD2)
	EndIf
Return Nil
/*==========================================================================
Funcao.....: VALEAN13
Descricao..: Valida codEan13 no cadastro do Produto campo B1_CODBAR
Autor......: Jackson Santos
Data.......: 17/04/2013
Parametros.: Nil
Retorno....: .T. ou .F.
============================================================================
#RVC20180613 - Ajuste da validação de retirada da loja para impressão da etiqueta
==========================================================================*/
Static Function ValidaEan13(lEntrada, nQuant)

	Local   aArea    := GetArea()

	Local   cCodOri  := IIF(lEntrada,Alltrim(SD1->D1_COD),Alltrim(SD2->D2_COD))
	Local   cCodBar  := ''
	Local   cCodEan  := ''
	Local   cDigEan  := ''

	Local   nOpcAviso:= 0
	Local   cMsgAviso:= ''
	Local   cTituloAv:= "Atenção - validação codigo [EAN13]"
	Local   aOpcAviso:= {"Sim","Sim p/Todos","Não"}
	Local   lOk		 := .F.
	Local cEndPrinc  := ""
	Local cDimensoes := ""
	Local cGrpNaoPri := SuperGetMv("GL_NAOIMPR",,"2001;2002")
	Local   aEnderec   := {}
	Local   nI

	DbSelectArea('SB1')
	SB1->(dbSetOrder(1))
	If SB1->(MsSeek(xFilial('SB1')+cCodOri)) .and. ! SB1->B1_GRUPO $ cGrpNaoPri

		If SB1->B1_XACESSO <> '1'//#CMG20181004.n

			cCodBar  := SB1->B1_CODBAR
			cCodEan  := ''
			cDigEan  := Eandigito(cCodOri)
			cCodEan  := Padl( Left(cCodOri,12) , 12 , '0' ) + cDigEan

			&& ADICIONA PROUTOS PARA LEITURA DE CODIGO DE BARRAS
			iF lEntrada
				cQryEnd := " SELECT LTRIM(RTRIM(DB_LOCALIZ)) ENDPRINC "
				cQryEnd +=  " FROM " + RetSqlName("SDB") + "  SDB "
				cQryEnd +=  " WHERE SDB.DB_FILIAL = '" + SD1->D1_FILIAL + "'"
				cQryEnd +=  " AND SDB.DB_PRODUTO = '" + SD1->D1_COD + "'"
				cQryEnd +=  " AND SDB.DB_DOC='" + SD1->D1_DOC + "'"
				cQryEnd +=  " AND SDB.DB_SERIE = '" + SD1->D1_SERIE + "'"
				cQryEnd +=  " AND SDB.DB_CLIFOR = '" + SD1->D1_FORNECE + "'"
				cQryEnd +=  " AND SDB.DB_LOJA = '" + SD1->D1_LOJA + "'"
				cQryEnd +=  " AND SDB.DB_ORIGEM = 'SD1' "
				cQryEnd +=  " AND SDB.DB_LOCALIZ <> ''"
				cQryEnd +=  " AND SDB.DB_NUMSEQ = '" + SD1->D1_NUMSEQ + "'" //#CMG20181004.n		
				cQryEnd +=  " AND SDB.DB_ESTORNO <> 'S'"
				cQryEnd +=  " AND SDB.D_E_L_E_T_ <> '*'"
				If Select("TSDB") > 0
					TSDB->(DbCloseArea())
				Endif
				TCQUERY cQryEnd NEW ALIAS "TSDB"
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
				DbSelectArea("SB5")
				SB5->(DbSetOrder(1))
				If SB5->(DbSeek(xFilial("SB5") + SB1->B1_COD))
					cDimensoes := cValToChar(SB5->B5_ALTURLC) + " x "+  cValToChar(SB5->B5_LARGLC) + " x " + cValToChar(SB5->B5_COMPRLC)
				EndIf 

				for nI := 1 to nQuant
					cEndPrinc := aEnderec[nI]
					if SF1->F1_TIPO == "D"
						Aadd( aProEan13 , {SB1->B1_COD,SB1->B1_DESC,SB1->B1_CODBAR,SA1->A1_COD + "/" + SA1->A1_LOJA + " - " + Alltrim(SA1->A1_NOME),DTOC(SD1->D1_DTDIGIT),cEndPrinc," ",cDimensoes,SD1->D1_DOC,SD1->D1_SERIE,SD1->D1_ITEM} )
					else
						Aadd( aProEan13 , {SB1->B1_COD,SB1->B1_DESC,SB1->B1_CODBAR,SA2->A2_COD + "/" + SA2->A2_LOJA + " - " + Alltrim(SA2->A2_NOME),DTOC(SD1->D1_DTDIGIT),cEndPrinc," ",cDimensoes,SD1->D1_DOC,SD1->D1_SERIE,SD1->D1_ITEM} )
					endif
				next
			Else	
				cQryEnd := " SELECT LTRIM(RTRIM(DB_LOCALIZ)) ENDPRINC "
				cQryEnd +=  " FROM " + RetSqlName("SDB") + "  SDB "
				cQryEnd +=  " WHERE SDB.D_E_L_E_T_ <> '*' AND SDB.DB_FILIAL = '" + SD2->D2_FILIAL + "' AND SDB.DB_ORIGEM = 'SC6'  "
				cQryEnd +=  " AND SDB.DB_DOC='" + SD2->D2_DOC + "' AND SDB.DB_SERIE = '" + SD2->D2_SERIE + "' "
				cQryEnd +=  " AND SDB.DB_CLIFOR = '" + SD2->D2_CLIENTE + "' AND SDB.DB_LOJA = '" + SD2->D2_LOJA + "'  
				cQryEnd +=  " AND SDB.DB_PRODUTO = '" + SD2->D2_COD + "' AND SDB.DB_LOCALIZ <> '' " 
				cQryEnd +=  " AND SDB.DB_NUMSEQ = '" + SD2->D2_NUMSEQ + "' " //#CMG20181004.n	
				If Select("TSDB") > 0
					TSDB->(DbCloseArea())
				Endif

				TCQUERY cQryEnd NEW ALIAS "TSDB"
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

				// verifica se a mercadoria já foi retirada da loja
				//		if Val_SUB()		//#RVC20180613.o
				If !Val_SUB()		//#RVC20180613.n	

					for nI := 1 to nQuant
						cEndPrinc := aEnderec[nI]
						if SF2->F2_TIPO $ "D;B"
							Aadd( aProEan13 , {SB1->B1_COD,SB1->B1_DESC,SB1->B1_CODBAR,SA2->A2_COD + "/" + SA2->A2_LOJA + " - " + Alltrim(SA2->A2_NOME),ALLTRIM(SA2->A2_END) + " - " + Alltrim(SA2->A2_BAIRRO) ;
							+ " - " + Alltrim(SA2->A2_MUN) + " - " + Alltrim(SA2->A2_EST) + " - " + "CEP: " + SA2->A2_CEP, DTOC(SD2->D2_EMISSAO), "30/01/2017", SF2->F2_DOC, cEndPrinc,SD2->D2_DOC,SD2->D2_SERIE,SD2->D2_ITEM} )
						else
							Aadd( aProEan13 , {SB1->B1_COD,SB1->B1_DESC,SB1->B1_CODBAR,SA1->A1_COD + "/" + SA1->A1_LOJA + " - " + Alltrim(SA1->A1_NOME),ALLTRIM(SA1->A1_END) + " - " + Alltrim(SA1->A1_BAIRRO) ;
							+ " - " + Alltrim(SA1->A1_MUN) + " - " + Alltrim(SA1->A1_EST) + " - " + "CEP: " + SA1->A1_CEP, DTOC(SD2->D2_EMISSAO), "30/01/2017", SF2->F2_DOC, cEndPrinc,SD2->D2_DOC,SD2->D2_SERIE,SD2->D2_ITEM} )
						endif
					next

				endif
			EndIf

		EndIf

	Endif

	RestArea(aArea)

Return


//---------------------------------------------------
// valida se a mercadoria já foi retirada da loja
Static Function Val_SUB()
	//Local lRet 	:= .T.	//#RVC20180613.o
	Local lRet 		:= .F.	//#RVC20180613.n
	Local aAreaSUB	:= SUB->( getArea() )

	SUB->( dbSetOrder(3) )
	if SUB->( dbSeek( xFilial("SUB") + SD2->( D2_PEDIDO + D2_ITEMPV ) ) )
		if SUB->UB_CONDENT == "1" .and. SUB->UB_TPENTRE == "1"	// Retirada imediata na loja
			//lRet := .F.	//#RVC20180613.o
			lRet := .T.		//#RVC20180613.n
		endif
	endif

	SUB->( restArea( aAreaSUB ) )
return lRet
