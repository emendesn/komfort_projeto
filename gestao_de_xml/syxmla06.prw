#Include "PROTHEUS.CH"
#Include 'Ap5Mail.Ch'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  º SYXMLA06 º Autor º LUIZ EDUARDO F.C.  º Data ³  15/08/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObjetivo  ³ VALIDACAO NO CAMPO Z34->Z34_PEDIDO - VALIDA SE OS ITENS    º±±
±±º          ³ DIGITADOS EXISTEM NOS PEDIDOS SELECIONADO                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GESTOR DE XML                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER FUNCTION SYXMLA06()

Local lRet     := .T.
Local cItem    := ""
Local npos     := 0
Local cZ34     := ALLTRIM(M->Z34_PEDIDO)

Private nFtrConv := 0
Private cCombo1  := ""
Private lCampoFil := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA QUAL CAMPO SERA USADO - C7_01FILDE SE O MODULO DO GCV ESTA INSTALADO / C7_FILENT PARA OS CASOS DE NAO ESTAR INSTALADO O GCV ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SX3")
DbSetorder(1)
MsSeek("SC7")
While !Eof() .And. (X3_ARQUIVO == "SC7")
	IF AllTrim(SX3->X3_CAMPO) $ ("C7_01FILDE")
		lCampoFil := .T.
	ENDIF
	SX3->(DbSkip())
EndDo

IF !lControl
	IF lMULTPED
		SELECPED()
	Else
		For nX:=1 To Len(cZ34)
			IF SUBSTR(cZ34,nX,1) <> "/"
				cItem := cItem + SUBSTR(cZ34,nX,1)
			Else
				nPos   := aScan( aProdutos , { |x| x[1] == cItem } )
				IF nPos = 0
					MsgAlert("Por Favor Digite um Item que exista no Pedido!!! - " +  cItem)
					lRet := .F.
					Exit
				Else
					cItem := ""
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ FAZ TRATAMENTO PARA A INCLUSAO DO CADASTRO DE PRODUTOS X FORNECEDOR ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					IF lPRODFOR
						DbSelectArea("SA5")
						SA5->(DbSetOrder(2)) // A5_FILIAL+A5_PRODUTO+A5_FORNECE+A5_LOJA
						IF DBSEEK(XFILIAL("SA5") + aProdutos[nPos,2] + Z31->Z31_CODFOR + Z31->Z31_LJFOR)
							IF EMPTY(SA5->A5_CODPRF)
								//IF MsgYesNo("Deseja Gravar o Relacionamento Produto x Fornecedor Neste Item? Cod.Proprio - " + aProdutos[nPos,2] + "   Cod.Fornecedor - " + oGetCat:ACOLS[oGetCat:NAT,2],"YESNO")
								IF lUSACONV
									U_GRVREL()
								EndIF
								SA5->(RecLock("SA5",.F.))
								SA5->A5_CODPRF  := oGetCat:ACOLS[oGetCat:NAT,2]
								SA5->A5_TIPCONV := LEFT(ALLTRIM(cCombo1),1)
								SA5->A5_CONV    := nFtrConv
								SA5->A5_SITU    := "C"
								SA5->A5_TEMPLIM := 99
								SA5->A5_FABREV  := "F"
								SA5->A5_ATUAL   := "N"
								SA5->A5_TIPATU  := "2"
								SA5->A5_XLIBGQ  := "2"
								SA5->(MsUnlock())
								//EndIF
							EndIf
						Else
							//IF MsgYesNo("Deseja Gravar o Relacionamento Produto x Fornecedor Neste Item? Cod.Proprio - " + aProdutos[nPos,2] + "   Cod.Fornecedor - " + oGetCat:ACOLS[oGetCat:NAT,2],"YESNO")
							IF lUSACONV
								U_GRVREL()
							EndIF
							SA5->(RecLock("SA5",.T.))
							SA5->A5_FILIAL  := XFILIAL("SA5")
							SA5->A5_FORNECE := Z31->Z31_CODFOR
							SA5->A5_LOJA    := Z31->Z31_LJFOR
							SA5->A5_NOMEFOR := POSICIONE("SA2",1,xFilial("SA2") + Z31->Z31_CODFOR + Z31->Z31_LJFOR,"A2_NOME")
							SA5->A5_PRODUTO := aProdutos[nPos,2]
							SA5->A5_NOMPROD := POSICIONE("SB1",1,xFilial("SB1") + aProdutos[nPos,2],"B1_DESC")
							SA5->A5_CODPRF  := oGetCat:ACOLS[oGetCat:NAT,2]
							SA5->A5_UMNFE   := "1"
							SA5->A5_TIPCONV := LEFT(ALLTRIM(cCombo1),1)
							SA5->A5_CONV    := nFtrConv
							SA5->A5_SITU    := "C"
							SA5->A5_TEMPLIM := 99
							SA5->A5_FABREV  := "F"
							SA5->A5_ATUAL   := "N"
							SA5->A5_TIPATU  := "2"
							SA5->A5_XLIBGQ  := "2"
							SA5->(MsUnlock())
							//EndIF
						EndIF
					EndIF
				EndIF
			EndIF
			
			IF nX = Len(cZ34)
				nPos   := aScan( aProdutos , { |x| x[1] == cItem } )
				IF nPos = 0
					MsgAlert("Por Favor Digite um Item que exista no Pedido!!! - " +  cItem)
					lRet := .F.
					Exit
				Else
					cItem := ""
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ FAZ TRATAMENTO PARA A INCLUSAO DO CADASTRO DE PRODUTOS X FORNECEDOR ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					IF lPRODFOR
						DbSelectArea("SA5")
						SA5->(DbSetOrder(2)) // A5_FILIAL+A5_PRODUTO+A5_FORNECE+A5_LOJA
						IF DBSEEK(XFILIAL("SA5") + aProdutos[nPos,2] + Z31->Z31_CODFOR + Z31->Z31_LJFOR)
							IF EMPTY(SA5->A5_CODPRF)
								//IF MsgYesNo("Deseja Gravar o Relacionamento Produto x Fornecedor Neste Item? Cod.Proprio - " + aProdutos[nPos,2] + "   Cod.Fornecedor - " + oGetCat:ACOLS[oGetCat:NAT,2],"YESNO")
								IF lUSACONV
									U_GRVREL()
								EndIF
								SA5->(RecLock("SA5",.F.))
								SA5->A5_CODPRF  := oGetCat:ACOLS[oGetCat:NAT,2]
								SA5->A5_TIPCONV := LEFT(ALLTRIM(cCombo1),1)
								SA5->A5_CONV    := nFtrConv
								SA5->A5_SITU    := "C"
								SA5->A5_TEMPLIM := 99
								SA5->A5_FABREV  := "F"
								SA5->A5_ATUAL   := "N"
								SA5->A5_TIPATU  := "2"
								SA5->A5_XLIBGQ  := "2"
								SA5->(MsUnlock())
								//EndIF
							EndIf
						Else
							//IF MsgYesNo("Deseja Gravar o Relacionamento Produto x Fornecedor Neste Item? Cod.Proprio - " + aProdutos[nPos,2] + "   Cod.Fornecedor - " + oGetCat:ACOLS[oGetCat:NAT,2],"YESNO")
							IF lUSACONV
								U_GRVREL()
							EndIF
							SA5->(RecLock("SA5",.T.))
							SA5->A5_FILIAL  := XFILIAL("SA5")
							SA5->A5_FORNECE := Z31->Z31_CODFOR
							SA5->A5_LOJA    := Z31->Z31_LJFOR
							SA5->A5_NOMEFOR := POSICIONE("SA2",1,xFilial("SA2") + Z31->Z31_CODFOR + Z31->Z31_LJFOR,"A2_NOME")
							SA5->A5_PRODUTO := aProdutos[nPos,2]
							SA5->A5_NOMPROD := POSICIONE("SB1",1,xFilial("SB1") + aProdutos[nPos,2],"B1_DESC")
							SA5->A5_CODPRF := oGetCat:ACOLS[oGetCat:NAT,2]
							SA5->A5_TIPCONV := LEFT(ALLTRIM(cCombo1),1)
							SA5->A5_CONV    := nFtrConv
							SA5->A5_SITU    := "C"
							SA5->A5_TEMPLIM := 99
							SA5->A5_FABREV  := "F"
							SA5->A5_ATUAL   := "N"
							SA5->A5_TIPATU  := "2"
							SA5->A5_XLIBGQ  := "2"
							SA5->(MsUnlock())
							//EndIF
						EndIF
					EndIF
				EndIF
			EndIF
		Next
	EndIF
Else
	U_CADPRODFOR()
	lRet := .T.
EndIF

RETURN(lRet)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ SELECPED º Autor ³ LUIZ EDUARDO F.C.  º Data ³  23/09/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ ABRE UMA TELA PARA SELECIONAR OS ITENS E OS PEDIDOS        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
STATIC FUNCTION SELECPED()

Local aItPed   := {}
Local aButtons := {}
Local oOk      := LoadBitMap(GetResources(), "LBOK")
Local oNo      := LoadBitMap(GetResources(), "LBNO")
Local oDlgPed, oBrwPed

For nPed := 1 To Len(aVisuPed)
	DbSelectArea("SC7")
	SC7->(DbSetOrder(1))
	SC7->(DbGoTop())
	SC7->(DbSeek(xFilial("SC7") + aVisuPed[nPed,2]))
	While !SC7->(EOF()) .AND. (SC7->C7_FILIAL + SC7->C7_NUM == xFilial("SC7") + aVisuPed[nPed,2])
		If lCampoFil
			IF ALLTRIM(SC7->C7_01FILDE) = ALLTRIM(cLjPed)
				aAdd( aItPed , { .F. , aVisuPed[nPed,2] , SC7->C7_ITEM ,  SC7->C7_PRODUTO , SC7->C7_DESCRI , SC7->C7_UM } )
			EndIF
		Else
			IF ALLTRIM(SC7->C7_FILENT) = ALLTRIM(cLjPed)
				aAdd( aItPed , { .F. , aVisuPed[nPed,2] , SC7->C7_ITEM ,  SC7->C7_PRODUTO , SC7->C7_DESCRI , SC7->C7_UM } )
			EndIF
		EndIF
		SC7->(DbSkip())
	EndDo
Next

DEFINE MSDIALOG oDlgPed FROM 0,0 TO 500,600 TITLE "Itens do Pedido X Itens do XML" Of oMainWnd PIXEL

@ 035, 005 Say "Produto Fornecedor : " + oGetCat:ACOLS[oGetCat:NAT,2] + " - " +  oGetCat:ACOLS[oGetCat:NAT,3]Size 500,010 Pixel Of oDlgPed

oBrwPed:= TWBrowse():New(050,005,300,200,,{"","Numero","Item","Código","Descrição","U.Medida"},,oDlgPed,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oBrwPed:SetArray(aItPed)
oBrwPed:bLine := {|| { If(aItPed[oBrwPed:nAt,1],oOK,oNO) , aItPed[oBrwPed:nAt,2] , aItPed[oBrwPed:nAt,3] , aItPed[oBrwPed:nAt,4], aItPed[oBrwPed:nAt,5] , aItPed[oBrwPed:nAt,6] }}
oBrwPed:bLDblClick := {|| IIF(aItPed[oBrwPed:nAt,1] , aItPed[oBrwPed:nAt,1] := .F. , aItPed[oBrwPed:nAt,1] := .T.) , oBrwPed:REFRESH() }

ACTIVATE MSDIALOG oDlgPed ON INIT EnchoiceBar( oDlgPed, { || IIF(GRVITPED(aItPed) , oDlgPed:End() , ) } , { || oDlgPed:End() },, aButtons)

RETURN()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ GRVITPED º Autor ³ LUIZ EDUARDO F.C.  º Data ³  26/09/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ GRAVA NO ACOLS OS ITENS SELECIONADOS                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
STATIC FUNCTION GRVITPED(aItPed)

Local lConf    := .F.
Local lRet     := .F.

Private cItxPed := ""

For nX:=1 To Len(aItPed)
	IF aItPed[nX,1]
		lRet := .T.
		Exit
	EndIF
Next

IF !lRet
	MsgInfo("Por favor, selecione ao menos um produto!!!!")
Else
	For nX:=1 To Len(aItPed)
		IF aItPed[nX,1]
			IF EMPTY(cItxPed)
				cItxPed := aItPed[nX,2] + aItPed[nX,3]
			Else
				cItxPed := cItxPed + "/" + aItPed[nX,2] + aItPed[nX,3]
			EndIF
		EndIF
	Next
	
	oGetCat:ACOLS[oGetCat:NAT,1] := cItxPed
	aClone[oGetCat:NAT,1] := cItxPed
	M->Z34_PEDIDO := cItxPed
	oGetCat:oBrowse:REFRESH()
	oTelVLDDANFE:REFRESH()
	lConf := .T.
EndIF

IF lPRODFOR
	IF MsgYesNo("Deseja gravar estas informações no cadastro de Produto X Fornecedor?","YESNO")
		
		IF lUSACONV
			U_GRVREL()
		EndIF
		
		Begin Transaction
		
		DbSelectArea("SA5")
		SA5->(DbSetOrder(2))
		
		For nX:=1 To Len(aItPed)
			IF aItPed[nX,1]
				SA5->(DbGoTop())
				IF !(SA5->(DbSeek(xFilial("SA5") + PADR(aItPed[nX,4],15) + Z31->Z31_CODFOR + Z31->Z31_LJFOR)))
					SA5->(RecLock("SA5",.T.))
					SA5->A5_FILIAL  := XFILIAL("SA5")
					SA5->A5_FORNECE := Z31->Z31_CODFOR
					SA5->A5_LOJA    := Z31->Z31_LJFOR
					SA5->A5_NOMEFOR := POSICIONE("SA2",1,xFilial("SA2") + Z31->Z31_CODFOR + Z31->Z31_LJFOR,"A2_NOME")
					SA5->A5_PRODUTO := PADR(aItPed[nX,4],15)
					SA5->A5_NOMPROD := POSICIONE("SB1",1,xFilial("SB1") + PADR(aItPed[nX,4],15),"B1_DESC")
					SA5->A5_CODPRF := oGetCat:ACOLS[oGetCat:NAT,2]
					SA5->A5_TIPCONV := LEFT(ALLTRIM(cCombo1),1)
					SA5->A5_CONV    := nFtrConv
					SA5->A5_SITU    := "C"
					SA5->A5_TEMPLIM := 99
					SA5->A5_FABREV  := "F"
					SA5->A5_ATUAL   := "N"
					SA5->A5_TIPATU  := "2"
					SA5->A5_XLIBGQ  := "2"
					SA5->(MsUnlock())
				EndIF
			EndIF
		Next
		End Transaction
	EndIF
EndIF

RETURN(lConf)
