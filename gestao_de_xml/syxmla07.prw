#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#Include "Ap5Mail.Ch"
#Include "xmlxfun.ch"
#INCLUDE "JPEG.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SYXMLA07 º Autor ³ LUIZ EDUARDO F.C.  º Data ³  09/09/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ FAZ A LIBERACAO DO XML SEM PEDIDO VINCULADO                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GESTAO DE XML                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER FUNCTION SYXMLA07()

Local nPos      := 0
Local nUsado    := 0
Local aButtons  := {}
Local aClone    := {}
Local aHeader   := {}
Local aAlterZ34 := {"Z34_PEDIDO","Z34_CUSTRE","D1_LOTECTL","D1_DTVALID"}
Local aSize     := MsAdvSize()
Local oDlgXML, oPnlPrin, oPnlEmit, oPnlIn

Private oGetLib
Private nFtrConv := 0
Private cCombo1  := ""

DEFINE FONT oFntTit NAME "ARIAL" SIZE 0,-12 BOLD
DEFINE FONT oFntInf NAME "ARIAL" SIZE 0,-12
DEFINE FONT oFnt    NAME "ARIAL" SIZE 0,-10
DEFINE MSDIALOG oDlgXML FROM 0,0 TO aSize[6] , aSize[5] TITLE "Liberação de XML s/ Pedido" Of oMainWnd PIXEL

lControl := .T.

oPnlPrin:= TPanel():New(025,000, "",oDlgXML, NIL, .T., .F., NIL, NIL,300,060, .T., .F. )
oPnlPrin:Align:=CONTROL_ALIGN_ALLCLIENT

// PAINEL COM AS INFORMACOES DO XML
oPnlEmit:= TPanel():New(025,000, "",oPnlPrin, NIL, .T., .F., NIL, NIL,300,120, .T., .F. )
oPnlEmit:Align:=CONTROL_ALIGN_TOP

@ 005,070 Say "Identificação do Emitente"  		Size 150,010 Font oFnt Color CLR_BLUE 	Pixel Of oPnlEmit
@ 015,010 Say aDados[1]				  			Size 150,010 Font oFntInf				Pixel Of oPnlEmit
@ 025,010 Say aDados[2]				  			Size 150,010 Font oFntInf				Pixel Of oPnlEmit
@ 035,010 Say aDados[3]				  			Size 150,010 Font oFntInf				Pixel Of oPnlEmit
@ 045,010 Say aDados[4]				  			Size 150,010 Font oFntInf				Pixel Of oPnlEmit

@ 005,270 Say "Informações da Nota Fiscal"		Size 250,010 Font oFnt Color CLR_BLUE 	Pixel Of oPnlEmit
@ 015,200 Say "Chave de Acesso - " + cChaveNF 	Size 250,010 Font oFntInf 				Pixel Of oPnlEmit
@ 025,200 Say aDados[5]				  			Size 250,010 Font oFntInf				Pixel Of oPnlEmit
@ 035,200 Say aDados[6]				  			Size 250,010 Font oFntInf				Pixel Of oPnlEmit

@ 005,470 Say "Destinatário / Remetente"		Size 150,010 Font oFnt Color CLR_BLUE 			Pixel Of oPnlEmit
If nPos == 0
	@ 015,420 Say "CNPJ INEXISTENTE"				Size 150,010 Font oFntInf Color CLR_RED			Pixel Of oPnlEmit
Else
	@ 015,420 Say aDados[7]    						Size 150,010 Font oFntInf 						Pixel Of oPnlEmit
EndIf
@ 025,420 Say aDados[8]				  			Size 150,010 Font oFntInf			 			Pixel Of oPnlEmit
@ 035,420 Say aDados[9]				  			Size 150,010 Font oFntInf			   			Pixel Of oPnlEmit
@ 045,420 Say aDados[10]						Size 150,010 Font oFntInf			   			Pixel Of oPnlEmit

@ 055, 000 SAY REPLICATE("-",600) FONT oFnt SIZE 800,005 PIXEL OF oPnlEmit

@ 065,270 Say "Impostos / Informações"				Size 400,010 Font oFnt Color CLR_BLUE 		Pixel Of oPnlEmit
@ 075,010 Say aDados[11]    						Size 120,010 Font oFntInf 					Pixel Of oPnlEmit
@ 085,010 Say aDados[12]    						Size 120,010 Font oFntInf 		   			Pixel Of oPnlEmit
@ 095,010 Say aDados[13]    						Size 120,010 Font oFntInf 		   			Pixel Of oPnlEmit
@ 105,010 Say aDados[14]    						Size 120,010 Font oFntInf 			  		Pixel Of oPnlEmit

@ 075,150 Say aDados[15]    						Size 120,010 Font oFntInf 			  		Pixel Of oPnlEmit
@ 085,150 Say aDados[16]    						Size 120,010 Font oFntInf 	  				Pixel Of oPnlEmit
@ 095,150 Say aDados[17]    						Size 120,010 Font oFntInf 			  		Pixel Of oPnlEmit
@ 105,150 Say aDados[20]    						Size 120,010 Font oFntInf 	 				Pixel Of oPnlEmit

@ 075,280 Say aDados[21]    						Size 120,010 Font oFntInf 	  				Pixel Of oPnlEmit
@ 085,280 Say aDados[22]    						Size 120,010 Font oFntInf 	  				Pixel Of oPnlEmit
@ 095,280 Say aDados[23]    						Size 120,010 Font oFntInf 					Pixel Of oPnlEmit
@ 105,280 Say aDados[24]    						Size 120,010 Font oFntInf 	   				Pixel Of oPnlEmit

@ 075,420 Say aDados[25]    						Size 120,010 Font oFntInf 	   				Pixel Of oPnlEmit
@ 085,420 Say aDados[26]    						Size 120,010 Font oFntInf 					Pixel Of oPnlEmit
@ 095,420 Say aDados[27]    						Size 120,010 Font oFntInf 			 		Pixel Of oPnlEmit
@ 105,420 Say aDados[28]    						Size 120,010 Font oFntInf 			 		Pixel Of oPnlEmit

oPnlIn:= TPanel():New(000,600, "",oPnlEmit, NIL, .T., .F., NIL, NIL,200,200, .T., .F. )
@ 005,070 Say "Informações Complementares"			Size 200,010 Font oFnt Color CLR_BLUE 		Pixel Of oPnlIn
@ 015,000 Say aDados[29]    						Size 200,100 Font oFnt  					Pixel Of oPnlIn
@ 110,000 Say aDados[30]    						Size 200,010 Font oFnt						Pixel Of oPnlIn

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta aHeader a partir dos campos do SX3         	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SX3")
DbSetorder(1)
MsSeek("Z34")
While !Eof() .And. (X3_ARQUIVO == "Z34")
	IF AllTrim(SX3->X3_CAMPO) $ ("Z34_PEDIDO/Z34_COD/Z34_DESCRI/Z34_QUANT/Z34_VUNIT/Z34_CUSTRE/Z34_VLRTOT/Z34_NCM/Z34_CST/Z34_CFOP/Z34_BICMS/Z34_ALQICM/Z34_VICMS/Z34_BASIPI/Z34_VLRIPI/Z34_ALQIPI/Z34_UN")
		nUsado++
		Aadd(aHeader,{IF(AllTrim(SX3->X3_CAMPO) == "Z34_PEDIDO", "CÓDIGO DE PRODUTO PRÓPRIO",AllTrim(X3Titulo())),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,;
		SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO, IF(AllTrim(SX3->X3_CAMPO) == "Z34_PEDIDO", "SB1",SX3->X3_F3),SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO,SX3->X3_WHEN })
		
		IF AllTrim(SX3->X3_CAMPO) $ ("Z34_PEDIDO/Z34_CUSTRE")
			M->&(SX3->X3_CAMPO) := CriaVar(SX3->X3_CAMPO)
		EndIF
	ENDIF
	SX3->(DbSkip())
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta aHeader a partir dos campos do SX3         	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SX3")
DbSetorder(1)
MsSeek("SD1")
While !Eof() .And. (X3_ARQUIVO == "SD1")
	IF AllTrim(SX3->X3_CAMPO) $ ("D1_LOTECTL/D1_DTVALID")
		nUsado++
		Aadd(aHeader,{IF(AllTrim(SX3->X3_CAMPO) == "Z34_PEDIDO", "CÓDIGO DE PRODUTO PRÓPRIO",AllTrim(X3Titulo())),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,;
		,SX3->X3_USADO,SX3->X3_TIPO, IF(AllTrim(SX3->X3_CAMPO) == "Z34_PEDIDO", "SB1",SX3->X3_F3),SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO,SX3->X3_WHEN })
	ENDIF
	SX3->(DbSkip())
EndDo

If Len(aHeader) > 0
	_nPos := aScan(aHeader, {|x| AllTrim(x[2]) == "Z34_CUSTRE"})
	
	If _nPos > 0
		aHeader[_nPos,6] := "U_Z34Totais('C')"
	EndIf
EndIf

For nY:=1 To Len(aProdXML)
	aAdd( aClone, { M->Z34_PEDIDO			,;		// NUMERO DO PEDIDO
	aProdXML[nY,2]		,; 		// CODIGO DO PRODUTO (FORNECEDOR)
	aProdXML[nY,3]		,;		// DESCRICAO DO PRODUTO (FORNECEDOR)
	VAL(aProdXML[nY,8])		,; 		// QUANTIDADE
	VAL(aProdXML[nY,9])		,;		// VALOR UNITARIO DO PRODUTO
	VAL(aProdXML[nY,9])       ,;      // CUSTO REAL DO PRODUTO
	VAL(aProdXML[nY,10])		,;		// VALOR TOTAL DO PRODUTO
	aProdXML[nY,4]		,; 		// NCM DO PRODUTO
	aProdXML[nY,5]		,; 		// CST DO PRODUTO
	aProdXML[nY,6]		,; 		// CFOP DO PRODUTO
	aProdXML[nY,11]		,;		// BASE DE CALCULO DO ICMS
	aProdXML[nY,14]		,;		// ALIQUOTA DE CALCULO DE ICMS
	aProdXML[nY,12]		,; 		// VALOR DO ICMS
	aProdXML[nY,16]		,; 		// BASE DE CALCULO IPI
	aProdXML[nY,13]		,; 		// VALOR DO IPI
	aProdXML[nY,15]		,; 		// ALIQUOTA DE CALCULO DE IPI
	aProdXML[nY,7]		,; 		// UNIDADE DE MEDIDA
	SPACE(20)          		,; 		// LOTE
	CTOD("")           		,; 		// DATA VALIDADE
	""           		,; 		// CODIGO PRODUTO
	.F.					} )		// VARIAVEL DE CONTROLE DO MSNEWGETDADOS
	
	_nCustoReal += VAL(aProdXML[nY,9]) * VAL(aProdXML[nY,8])
	_nQuant		+= VAL(aProdXML[nY,8])
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FAZ A AMARRACAO PRODUTO X FORNECEDOR³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF lPRODFOR
	IF lCLIENTE
		DbSelectArea("SA1")
		SA1->(DbSetOrder(3))
		SA1->(DbSeek(xFilial("SA1") + SUBSTR(aDados[4],6,15)))
		
		DbSelectArea("SA7")
		SA7->(DbSetOrder(3))
		SA7->(DbGoTop())
		For nX:=1 To Len(aClone)
			IF SA7->(DbSeek(xFilial("SA7") + SA1->A1_COD + SA1->A1_LOJA + aClone[nX,2]))
				aClone[nX,01] := PADR(SA7->A7_PRODUTO,100)
			EndIF
		Next
	Else
		DbSelectArea("SA5")
		SA5->(DbSetOrder(14)) // A5_FILIAL+A5_FORNECE+A5_LOJA+A5_CODPRF
		SA5->(DbGoTop())
		
		For nY:=1 To Len(aClone)
			IF SA5->(DbSeek(xFilial("SA5") + Z31->Z31_CODFOR + ALLTRIM(Z31->Z31_LJFOR) + aClone[nY,2]))
				aClone[nY,01] := PADR(SA5->A5_PRODUTO,100)
			EndIF
		Next
	EndIF
EndIF

oGetLib:=MsNewGetDados():New(260,010,336,355,GD_INSERT+GD_DELETE+GD_UPDATE,"AllwaysTrue","AllwaysTrue",,aAlterZ34,,Len(aClone), "AllwaysTrue", "", "AllwaysTrue",oPnlPrin,aHeader,aClone)
oGetLib:OBROWSE:LADJUSTCOLSIZE := .T.
oGetLib:OBROWSE:Align:=CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oDlgXML ON INIT EnchoiceBar( oDlgXML, { || IIF(CRIAPNF() , oDlgXML:End() , )} , { || ATUSTATUS() , oDlgXML:End() },, aButtons)


RETURN()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SYXMLA07 º Autor ³ LUIZ EDUARDO F.C.  º Data ³  09/09/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ FAZ A LIBERACAO DO XML SEM PEDIDO VINCULADO                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GESTAO DE XML                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER FUNCTION CADPRODFOR()

Private nFtrConv := 0
Private cCombo1  := ""


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FAZ TRATAMENTO PARA A INCLUSAO DO CADASTRO DE PRODUTOS X FORNECEDOR ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF lPRODFOR
	IF lCLIENTE
		DbSelectArea("SA1")
		SA1->(DbSetOrder(3))
		SA1->(DbSeek(xFilial("SA1") + SUBSTR(aDados[4],6,15)))
		
		DbSelectArea("SA7")
		SA7->(DbSetOrder(1))
		SA7->(DbGoTop())
		
		IF SA7->(DbSeek(xFilial("SA7") + SA1->A1_COD + SA1->A1_LOJA + PADR(M->Z34_PEDIDO,15)))
			IF EMPTY(SA7->A7_CODCLI)
				//IF MsgYesNo("Deseja Gravar o Relacionamento Produto x Cliente Neste Item? Cod.Proprio - " + M->Z34_PEDIDO + "   Cod.Fornecedor - " + oGetLib:ACOLS[oGetLib:NAT,2],"YESNO")
					IF lUSACONV
						U_GRVREL()
					EndIF
					SA7->(RecLock("SA7",.F.))
					SA7->A7_CODCLI := oGetLib:ACOLS[oGetLib:NAT,2]
					SA7->A7_TIPCONV := LEFT(ALLTRIM(cCombo1),1)
					SA7->A7_CONV    := nFtrConv
					SA7->(MsUnlock())
				//EndIF
			ElseIF !(ALLTRIM(SA7->A7_CODCLI) == ALLTRIM(oGetLib:ACOLS[oGetLib:NAT,2]))
				MsgInfo("Já existe um relacionamento para o código de produto informado!!!")
			EndIF
		Else
			//IF MsgYesNo("Deseja Gravar o Relacionamento Produto x Cliente Neste Item? Cod.Proprio - " + M->Z34_PEDIDO + "   Cod.Cliente - " + oGetLib:ACOLS[oGetLib:NAT,2],"YESNO")
				IF lUSACONV
					U_GRVREL()
				EndIF
				SA7->(RecLock("SA7",.T.))
				SA7->A7_FILIAL  := XFILIAL("SA7")
				SA7->A7_CLIENTE := SA1->A1_COD
				SA7->A7_LOJA    := SA1->A1_LOJA
				SA7->A7_PRODUTO := PADR(M->Z34_PEDIDO,15)
				SA7->A7_CODCLI  := oGetLib:ACOLS[oGetLib:NAT,2]
				SA7->A7_DESCCLI := oGetLib:ACOLS[oGetLib:NAT,3]
				SA7->A7_TIPCONV := LEFT(ALLTRIM(cCombo1),1)
				SA7->A7_CONV    := nFtrConv
				SA7->(MsUnlock())
			//EndIF
		EndIF
	Else
		DbSelectArea("SA5")
		SA5->(DbSetOrder(2)) // A5_FILIAL+A5_PRODUTO+A5_FORNECE+A5_LOJA
		IF SA5->(DbSeek(XFILIAL("SA5") + PADR(M->Z34_PEDIDO,15) + Z31->Z31_CODFOR + Z31->Z31_LJFOR))
			IF EMPTY(SA5->A5_CODPRF)
				//IF MsgYesNo("Deseja Gravar o Relacionamento Produto x Fornecedor Neste Item? Cod.Proprio - " + M->Z34_PEDIDO + "   Cod.Fornecedor - " + oGetLib:ACOLS[oGetLib:NAT,2],"YESNO")
					IF lUSACONV
						U_GRVREL()
					EndIF
					SA5->(RecLock("SA5",.F.))
					SA5->A5_CODPRF  := oGetLib:ACOLS[oGetLib:NAT,2]
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
			ElseIF !(ALLTRIM(SA5->A5_CODPRF) == ALLTRIM(oGetLib:ACOLS[oGetLib:NAT,2]))
				MsgInfo("Já existe um relacionamento para o código de produto informado!!!")
			EndIF
		Else
			//IF MsgYesNo("Deseja Gravar o Relacionamento Produto x Fornecedor Neste Item? Cod.Proprio - " + M->Z34_PEDIDO + "   Cod.Fornecedor - " + oGetLib:ACOLS[oGetLib:NAT,2],"YESNO")
				IF lUSACONV
					U_GRVREL()
				EndIF
				SA5->(RecLock("SA5",.T.))
				SA5->A5_FILIAL  := XFILIAL("SA5")
				SA5->A5_FORNECE := Z31->Z31_CODFOR
				SA5->A5_LOJA    := Z31->Z31_LJFOR
				SA5->A5_NOMEFOR := POSICIONE("SA2",1,xFilial("SA2") + Z31->Z31_CODFOR + Z31->Z31_LJFOR,"A2_NOME")
				SA5->A5_PRODUTO := PADR(M->Z34_PEDIDO,15)
				SA5->A5_NOMPROD := POSICIONE("SB1",1,xFilial("SB1") + M->Z34_PEDIDO,"B1_DESC")
				SA5->A5_CODPRF  := oGetLib:ACOLS[oGetLib:NAT,2]
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

RETURN()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TELAXML  º Autor ³ LUIZ EDUARDO F.C.  º Data ³  29/07/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Monta a Tela de Gestao dos XML                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
STATIC FUNCTION CRIAPNF()

Local lRet      := .F.
Local lOk       := .T.
Local nOpc   	:= 0
Local aConv     := {}
Local aTipoNF   := IIF(lCLIENTE,{'B = BENEFICIAMENTO' , 'D = DEVOLUÇÃO'},{'N = NORMAL' , 'C = COMPLEMENTO DE PRECO/FRETE'})
Local aFormul   := {'S= SIM' , 'N = NAO'}
Local oDlgTp, oCmbNF, oCmbFor

Private aCabec      := {}
Private aItens      := {}
Private aLinha      := {}
Private aGrvSD1     := {}
Private lMsErroAuto := .F.

IF lSOLTIPO
	DEFINE DIALOG oDlgTp TITLE "Tipo de Nota Fiscal" FROM 0,0 TO 150,300 PIXEL
	
	@ 008,005 Say "Tipo de Nota Fiscal : " Size 150,010 Pixel Of oDlgTp
	
	cTipoNF:= aTipoNF[1]
	oCmbNF := TComboBox():New(005,060,{|u|if(PCount()>0,cTipoNF:=u,cTipoNF)},aTipoNF,080,010,oDlgTp,,{||},,,,.T.,,,,,,,,,'cTipoNF')
	
	@ 025,005 Say "Formulário Próprio  : " Size 150,010 Pixel Of oDlgTp
	
	cFormNF := aFormul[1]
	oCmbFor := TComboBox():New(022,060,{|u|if(PCount()>0,cFormNF:=u,cFormNF)},aFormul,080,010,oDlgTp,,{||},,,,.T.,,,,,,,,,'cFormNF')
	
	@ 050,005 BUTTON "&OK"	SIZE 50,15 OF oDlgTp PIXEL ACTION {|| (oDlgTp:End())  }
	
	ACTIVATE DIALOG oDlgTp CENTERED
Else
	IF lCLIENTE
		DbSelectArea("SA1")
		SA1->(DbSetOrder(3))
		SA1->(DbSeek(xFilial("SA1") + Z31->Z31_CNPJFO))
		
		cTipoNF := "B" // BENEFICIAMENTO
	EndIF
EndIF

For nT:=1 To Len(oGetLib:ACOLS)
	IF EMPTY(oGetLib:ACOLS[nT,1])
		MsgAlert("Um ou mais itens estão com o campo [CÓDIGO DE PRODUTO PRÓPRIO] em branco, por favor preencha!!!")
		lRet := .F.
		lOk  := .F.
		Exit
	EndIF
Next

IF lOk
	IF MsgYesNo("Deseja criar a pré-nota de entrada???","YESNO")
		lRet := .T.
		Begin Transaction
		
		FWLOADSM0()
		
		aCabec := 	{	{'F1_TIPO'		,cTipoNF		 									,"AlwaysTrue()"},;
		{'F1_FORMUL'	,cFormNF		 									,"AlwaysTrue()"},;
		{'F1_ESPECIE'	,cEspecie		 									,"AlwaysTrue()"},;
		{'F1_DOC'		,Z31->Z31_NUM       								,"AlwaysTrue()"},;
		{'F1_SERIE' 	,Z31->Z31_SERIE 									,"AlwaysTrue()"},;
		{'F1_EMISSAO'	,Z31->Z31_EMIS   									,"AlwaysTrue()"},;
		{'F1_FORNECE'	,IIF(lCLIENTE , SA1->A1_COD  , Z31->Z31_CODFOR )  	,"AlwaysTrue()"},;
		{'F1_CHVNFE'	,Z31->Z31_CHAVE 									,"AlwaysTrue()"},;
		{'F1_LOJA'		,IIF(lCLIENTE , SA1->A1_LOJA , Z31->Z31_LJFOR 	)  	,"AlwaysTrue()"}}
		
		For nT:=1 To Len(oGetLib:ACOLS)
			aLinha := {}
			
			IF lUSACONV
				IF lCLIENTE
					aConv := U_QTDCONV(PADR(oGetLib:ACOLS[nT,1],15),oGetLib:ACOLS[nT,4],SA1->A1_COD ,SA1->A1_LOJA,oGetLib:ACOLS[nT,7])
				Else
					aConv := U_QTDCONV(PADR(oGetLib:ACOLS[nT,1],15),oGetLib:ACOLS[nT,4],Z31->Z31_CODFOR ,Z31->Z31_LJFOR,oGetLib:ACOLS[nT,7])
				EndIF
				
				IF Len(aConv) = 0
					aConv     := {}
					aAdd( aConv , oGetLib:ACOLS[nT,4] )
					aAdd( aConv , oGetLib:ACOLS[nT,5] )
				EndIF
				
				IF aConv[1] = 0
					aConv[1] := oGetLib:ACOLS[nT,4]
				EndIF
				
				IF aConv[2] = 0
					aConv[2] := oGetLib:ACOLS[nT,5]
				EndIF
				
			EndIF
			
			aLinha := {	{'D1_COD'		,oGetLib:ACOLS[nT,1]															,"AlwaysTrue()"},;
			{'D1_XDESCRI'	,Posicione("SB1",1,xFilial("SB1")+oGetLib:ACOLS[nT,1],"B1_DESC")				,NIL},;			
			{'D1_UM'		,ALLTRIM(POSICIONE("SB1",1,xFilial("SB1")+oGetLib:ACOLS[nT,1],"B1_UM"))   		,"AlwaysTrue()"},;
			{'D1_QUANT'		,IIF(lUSACONV , aConv[1] , oGetLib:ACOLS[nT,4])								,"AlwaysTrue()"},;
			{'D1_VUNIT'		,IIF(lUSACONV , aConv[2] , oGetLib:ACOLS[nT,5] ) 								,"AlwaysTrue()"},;
			{'D1_TOTAL'		,oGetLib:ACOLS[nT,7]															,"AlwaysTrue()"},;
			{'D1_TES'		,ALLTRIM(POSICIONE("SB1",1,xFilial("SB1")+oGetLib:ACOLS[nT,1],"B1_TE"))	 	,"AlwaysTrue()"},;
			{'D1_LOTECTL'	,oGetLib:ACOLS[nT,18]	 														,"AlwaysTrue()"},;
			{'D1_DTVALID'	,oGetLib:ACOLS[nT,19]	 														,"AlwaysTrue()"},;
			{'D1_LOCAL'		,ALLTRIM(POSICIONE("SB1",1,xFilial("SB1")+oGetLib:ACOLS[nT,1],"B1_LOCPAD"))	,"AlwaysTrue()"}}
			
			aadd(aItens,aLinha)
			
		Next
		
		LjMsgRun("Aguarde...Criando Documento de Entrada",,{|| MSExecAuto({|x,y,z| MATA140(x,y,z)}, aCabec, aItens, 3)  })
		
		If lMsErroAuto
			mostraerro()
		Else
			Z31->(RecLock("Z31",.F.))
			Z31->Z31_STATUS := "04"
			Z31->Z31_USER   := ALLTRIM(cUserName)
			Z31->Z31_DTLOG  := dDataBase
			Z31->Z31_HRLOG  := Time()
			Z31->Z31_VLRTOT := VAL(aValores[1])
			Z31->Z31_BICMS  := VAL(aValores[2])
			Z31->Z31_VALICM := VAL(aValores[3])
			Z31->Z31_BASIPI := VAL(aValores[4])
			Z31->Z31_VLRIPI := VAL(aValores[5])
			Z31->Z31_DESCON := VAL(aValores[6])
			Z31->Z31_BICMST := VAL(aValores[7])
			Z31->Z31_VICMST := VAL(aValores[8])
			Z31->Z31_ESTATU := "01"
			Z31->Z31_QTDTOT := _nQuant
			Z31->(MsUnlock())
		EndIf
		
		End Transaction
	EndIF
EndIF

RETURN(lRet)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TELAXML  º Autor ³ LUIZ EDUARDO F.C.  º Data ³  29/07/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Monta a Tela de Gestao dos XML                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER FUNCTION GRVREL()

Local oDlgGRVREL
Local aItems:= {'M = MULTIPLICADOR','D = DIVISOR'}

DEFINE DIALOG oDlgGRVREL TITLE "Cadastro de Fator e Tipo Conversão de UM" FROM 0,0 TO 150,300 PIXEL

@ 008,005 Say "Tipo de Conversão : " Size 150,010 Pixel Of oDlgGRVREL

cCombo1:= aItems[1]
oCombo1 := TComboBox():New(005,060,{|u|if(PCount()>0,cCombo1:=u,cCombo1)},aItems,080,010,oDlgGRVREL,,{||},,,,.T.,,,,,,,,,'cCombo1')

@ 023,005 Say "Fator de Conversão : " Size 150,010 Pixel Of oDlgGRVREL
@ 020,060 MSGET nFtrConv WHEN .T. PICTURE PesqPict("SA7","A7_CONV") SIZE 080,010 PIXEL OF oDlgGRVREL

@ 045,005 BUTTON "&OK"	SIZE 50,15 OF oDlgGRVREL PIXEL ACTION {|| (oDlgGRVREL:End())  }

ACTIVATE DIALOG oDlgGRVREL CENTERED

RETURN()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ATUSTATUSº Autor ³ LUIZ EDUARDO F.C.  º Data ³  10/11/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ ATUALIZA OS STATUS AO SAIR DA ROTINA                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
STATIC FUNCTION ATUSTATUS()

Z31->(RecLock("Z31",.F.))
Z31->Z31_STATUS := "02"
Z31->Z31_USER   := ALLTRIM(cUserName)
Z31->Z31_DTLOG  := dDataBase
Z31->Z31_HRLOG  := Time()
Z31->(MsUnlock())

RETURN()