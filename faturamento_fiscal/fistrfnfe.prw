#include "protheus.ch"
#include "totvs.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FISTRFNFE  ºAutor  ³ Cristiam Rossi	 º Data ³  05/05/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Inclui o botão para Impressão de etiqueta, na rotina de 	  º±±
±±º			 ³Transmissao do Sped Nf-e        							  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ Parametro   ³    Tipo      ³ Descrição					  º±±
±±º          ³ lEnd        ³    L         ³ Indica se adiciona ou nao o   º±±
±±º          ³             ³              ³ Botao ao menu da rotina       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 															  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/			  
User Function FISTRFNFE()

	Local cImpDanfe := superGetMv('KH_IMPDANF', .F., '000127|000779|001111|000038|000455|001133|000486|000872|000033|000770', ) // Usuarios com permissão para imprimir Danfe.
	Local nPosDanfe := Ascan(aRotina,{|x| Alltrim(x[2]) == "SpedDanfe()"}) //Posição da impressão da DANFE no aRotina.
	
	aAdd(aRotina, {"Impressão Etiqueta" , "U_PrintEtiq"	 , 0, 2, 0, NIL})       

	if !(__cUserId $ cImpDanfe)
		if nPosDanfe > 0
			aDel(aRotina, nPosDanfe) // Remove a opção do aRotina
			aRotina := aClone(ASize( aRotina, len(aRotina)-1 )) // Ajusta o tamanho do aRotina
		endif
	endif

Return .T.


//---------------------------------
User Function PrintEtiq()

Local   oDlg
Local   cDOCde
Local   cDOCate    
Local   cSerie
Local   nTipo
Local   cTipo
Local   lTransfer
Local   aCNPJs     := {}
Local   aAreaSM0

Local   cCodEndDe  := Space(15)
Local   cCodEndAt  := Space(15)
Local   cCodLocDe  := Space(02)
Local   cCodLocAt  := Space(02)
Local   cQtdEtq    := "  1"
Local   nOpcSel    := 0
Local   xKey
Local 	nRotCham
Local   aProEan13

Private _cFil    := ''
Private cCodProdDe := SPACE(15)
Private cCodProdAt := SPACE(15)
Private cGetCodDe  := ""
Private cGetCodAt  := ""
Private cGetEndDe  := ""
Private cGetEndAt  := ""                   
Private cGetLocDe  := ""
Private cGetLocAt  := ""
Private cGetTpEtq  := space(02)
Private aGetTpEtq  := {"01-Unico"}
Private cLotePrd   := Space(12)
Private cLocImpr   := "000001"
Private nTipoEtq   := 0
Private nOpcSel    := 0    
Default nRotCham   := 0 //1=MA010BUT 2-LJ110MENU
Default aProEan13  := {}

	If alias() == "SF1"
		cDocde  := F1_DOC
		cDocAte := F1_DOC
		cSerie  := F1_SERIE
		nTipo   := 1
		cTipo   := iif( nTipo == 1, "ENTRADA" , "SAÍDA" )
		_cFil   := xFilial("SF1")
				
	EndIf

	if alias() == "SF2"
		cDocde  := F2_DOC
		cDocAte := F2_DOC
		cSerie  := F2_SERIE
		nTipo   := 2
		cTipo   := iif( nTipo == 1, "ENTRADA" , "SAÍDA" )
		_cFil   := xFilial("SF2")
				
	endif

	if isinCallStack("U_PRTNFESEF") .or. isinCallStack("U_DANFE_P1")
		pergunte( "NFSIGW", .F. )
		cDocde  := MV_PAR01
		cDocAte := MV_PAR02
		cSerie  := MV_PAR03
		nTipo   := MV_PAR04
		_cFil   := xFilial("SF2")
		cTipo   := iif( nTipo == 1, "ENTRADA" , "SAÍDA" )

		if nTipo == 1	// não imprimir NF de Entrada c/ formulário próprio
			return nil
		endif

		if msgYesNo("Deseja imprimir as etiquetas?")
			nOpcSel := 1
		endif
	else
		DEFINE MSDIALOG oDlg TITLE "Seleçao da Nota Fiscal"  of oMainWnd PIXEL FROM  0,0 TO 240,280
	
		DEFINE FONT oFnt NAME "ARIAL" SIZE 0,-12 BOLD
		@ 05,05 say "Impressão de Etiqueta de Mercadoria" font oFnt of oDlg Pixel
	
		@ 20,05 say "Documento de:" of oDlg Pixel
		@ 19,45 msget cDOCde Size 60,9 Picture "999999999" of oDlg Pixel

		@ 35,05 say "Documento até:" of oDlg Pixel
		@ 34,45 msget cDOCate Size 60,9 Picture "999999999" of oDlg Pixel

		@ 50,05 say "Série:" of oDlg Pixel
		@ 49,45 msget cSerie Size 30,9 Picture "XXX" of oDlg Pixel

		@ 65,05 say "Filial:" of oDlg Pixel
		@ 64,45 msget _cFil Size 60,9 Picture "9999" F3 "SM0" of oDlg Pixel

		@ 80,05 say "Tipo:" of oDlg Pixel
		@ 79,45 combobox oCmb Var cTipo ITEMS {"ENTRADA","SAÍDA"} size 60,9 of oDlg Pixel

		DEFINE SBUTTON FROM 105, 080 oButton1 TYPE 1 ENABLE OF oDlg ACTION iif( valCpo(cDOCde, cDOCate, cSerie), Processa({|| nOpcSel := 1, oDlg:End() }), nil) PIXEL
		DEFINE SBUTTON FROM 105, 110 oButton2 TYPE 2 ENABLE OF oDlg ACTION Processa({|| nOpcSel := 2, oDlg:End() }) PIXEL

		ACTIVATE MSDIALOG oDlg CENTERED
	endif

	If nOpcSel == 1

		nTipo    := iif( cTipo == "ENTRADA" , 1, 2 )

		aAreaSM0 := SM0->( getArea() )
		SM0->( dbGotop() )
		While ! SM0->( EOF() )
			AADD( aCNPJs, SM0->M0_CGC )
			SM0->( dbSkip() )
		EndDo
		SM0->( restArea( aAreaSM0 ) )

		cNFvez := alltrim(cDOCde)

		While cNFvez <= alltrim(cDOCate)

			If nTipo == 1	// entrada
				dbSelectArea("SF1")
				//xKey := xFilial("SF1") + padr(cNFvez, 9) + cSerie //#20181023.o
				xKey := _cFil + padr(cNFvez, 9) + cSerie //#CMG20181023.n
			Else
				dbSelectArea("SF2")
				//xKey := xFilial("SF2") + padr(cNFvez, 9) + cSerie //#CMG20181023.o
				xKey := _cFil + padr(cNFvez, 9) + cSerie //#CMG20181023.n
			EndIf

			DbSetOrder(1)
			If dbSeek( xKey, .T. )
				If nTipo == 1
					If SF1->F1_TIPO == "N"
						_cCNPJ := Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_CGC")
					Else
						_cCNPJ := Posicione("SA1",1,xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA,"A1_CGC")
					EndIf
				Else
					If SF2->F2_TIPO == "N"
						_cCNPJ := Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_CGC")
					Else
						_cCNPJ := Posicione("SA2",1,xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A2_CGC")
					EndIf
				EndIf

				lTransfer := aScan( aCNPJs, _cCNPJ ) > 0

				U_ImpZebra( .F., nTipo==1, lTransfer, .T. )
			
			EndIf

			cNFvez := Soma1( cNFvez )
			
		EndDo
	EndIf
	
Return Nil


//---------------------------------------------------
Static Function valCpo( cDOCde, cDOCate, cSerie )

	if empty( cDOCde ) .or. empty( cDOCate ) .or. empty( cSerie )
		msgAlert( "Favor preencher todos os campos", "validação parâmetros" )
		return .F.
	endif

return .T.
