#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#Include "Ap5Mail.Ch"
#Include "xmlxfun.ch"
#INCLUDE "JPEG.CH"
#include "RWMAKE.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SYXMLA08 º Autor ³ LUIZ EDUARDO F.C.  º Data ³  26/09/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ FAZ A LIBERACAO E GRAVACAO DOS DADOS NAS TABELAS DE XML    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GESTAO DE XML                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER FUNCTION SYXMLA08()

Local cqry 	  := ""
Local aXML08  := {}

IF MsgYesNo("Confirma a LIBERAÇÃO da DANFE? ","YESNO")
	
	Begin Transaction
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ VERIFICA SE EXISTE ALGUMA INFORMACAO GRAVADA DESTE XML NA TABELA Z34 E SE EXISTIR DELETA ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cqry := " DELETE FROM "  + RETSQLNAME('Z34')
	cqry += " WHERE Z34_FILIAL = '" + XFILIAL("Z34") + "'"
	cqry += " AND Z34_CHAVE = '" + Z31->Z31_CHAVE  + "' "
	TCSQLExec(cqry)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ VERIFICA SE EXISTE ALGUMA INFORMACAO GRAVADA DESTE XML NA TABELA Z32 E SE EXISTIR DELETA ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cqry := " DELETE FROM "  + RETSQLNAME('Z32')
	cqry += " WHERE Z32_FILIAL = '" + XFILIAL("Z32") + "'"
	cqry += " AND Z32_CHAVE = '" + Z31->Z31_CHAVE  + "' "
	TCSQLExec(cqry)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ ATUALIZA AS INFORMACOES NA TABELA Z31³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ GRAVANDO AS INFORMACOES NA TABELA Z32 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nT:=1 To Len(aPedidos)
		DbSelectArea("Z32")
		IF aPedidos[nt,1]
			Z32->(RecLock("Z32",.T.))
			Z32->Z32_FILIAL := xFilial("Z32")
			Z32->Z32_CHAVE  := Z31->Z31_CHAVE
			Z32->Z32_NUM    := Z31->Z31_NUM
			Z32->Z32_SERIE  := Z31->Z31_SERIE
			Z32->Z32_FORNEC := Z31->Z31_CODFOR
			Z32->Z32_LJFORN := Z31->Z31_LJFOR
			Z32->Z32_LJDEST := Z31->Z31_LJDEST
			Z32->Z32_PEDIDO := aPedidos[nt,2]
		EndIF
		Z32->(MsUnlock())
	Next
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ GRAVANDO AS INFORMACOES NA TABELA Z34 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nY:=1 To Len(oGetCat:ACOLS)
		aXML08 := StrToKarr(oGetCat:ACOLS[nY,1],"/")
		
		For nZ:=1 To Len(aXML08)
			Z34->(RecLock("Z34",.T.))
			Z34->Z34_FILIAL := xFilial("Z34")
			Z34->Z34_PEDIDO := LEFT(aXML08[nZ],6)
			Z34->Z34_COD    := oGetCat:ACOLS[nY,2]
			Z34->Z34_DESCRI := oGetCat:ACOLS[nY,3]
			Z34->Z34_QUANT  := oGetCat:ACOLS[nY,4]
			Z34->Z34_VUNIT  := oGetCat:ACOLS[nY,5]
			Z34->Z34_CUSTRE := oGetCat:ACOLS[nY,6]
			Z34->Z34_VLRTOT := oGetCat:ACOLS[nY,7]
			Z34->Z34_NCM    := oGetCat:ACOLS[nY,8]
			Z34->Z34_CST    := oGetCat:ACOLS[nY,9]
			Z34->Z34_CFOP   := oGetCat:ACOLS[nY,10]
			Z34->Z34_BICMS  := IIF(VAL(oGetCat:ACOLS[nY,11])=0,0,Z34->Z34_VLRTOT)
			Z34->Z34_ALQICM := VAL(oGetCat:ACOLS[nY,12])
			Z34->Z34_VICMS  := ((Z34->Z34_BICMS * Z34->Z34_ALQICM )/100)
			Z34->Z34_BASIPI := IIF(VAL(oGetCat:ACOLS[nY,14])=0,0,Z34->Z34_VLRTOT)
			Z34->Z34_VLRIPI := ((Z34->Z34_BICMS * Z34->Z34_ALQIPI)/100)
			Z34->Z34_ALQIPI := VAL(oGetCat:ACOLS[nY,16])
			Z34->Z34_NFDANF := Z31->Z31_NUM
			Z34->Z34_SRDANF := Z31->Z31_SERIE
			Z34->Z34_CHAVE  := Z31->Z31_CHAVE
			Z34->Z34_ITEM	:= SUBSTR(aXML08[nZ],7,Len(aXML08[nZ])) 
			Z34->Z34_LOTE   := oGetCat:ACOLS[nY,19]
			Z34->Z34_DTVALI := oGetCat:ACOLS[nY,20]
			
			DbSelectArea("SC7")
			SC7->(DbSetOrder(1))
			SC7->(DBGoTop())
			SC7->(DbSeek(xFilial("SC7") + aXML08[nZ]))
			
			While !SC7->(EOF()) .AND. (SC7->C7_FILIAL + SC7->C7_NUM + SC7->C7_ITEM == xFilial("SC7") + aXML08[nZ])
				If lCampoFil
					IF ALLTRIM(SC7->C7_01FILDE) = ALLTRIM(cLjPed)
						Z34->Z34_PEDPRO := SC7->C7_PRODUTO
						Z34->Z34_UN     := SC7->C7_UM
						Z34->Z34_LOCAL  := SC7->C7_LOCAL
						Z34->Z34_TES    := SC7->C7_TES
					EndIF
				Else
					IF ALLTRIM(SC7->C7_FILENT) = ALLTRIM(cLjPed)
						Z34->Z34_PEDPRO := SC7->C7_PRODUTO
						Z34->Z34_UN     := SC7->C7_UM
						Z34->Z34_LOCAL  := SC7->C7_LOCAL
						Z34->Z34_TES    := SC7->C7_TES
					EndIF
				EndIF
				SC7->(DbSkip())
			EndDo
			
			//IF lUSACONV
				//Z34_QTDCON := U_QTDCONV(Z34->Z34_COD,Z34->Z34_QUANT,Z31->Z31_CODFOR,Z31->Z31_LJFOR)
			//EndIF
			
			Z34->(MsUnlock())
		Next
	Next
	
	End Transaction
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³VALIDA SE VAI SER CRIADA A PRE-NOTA DE ENTRADA OU NAO ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF lVLDPNF
		IF MsgYesNo("Deseja Criar o Documento de Pré-Nota de Entrada? ","YESNO")
			U_SYXMLA05(Z31->Z31_CHAVE)
		EndIF
	EndIF
EndIF

RETURN()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ QTDCONV  º Autor ³ LUIZ EDUARDO F.C.  º Data ³  03/10/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ FAZ A CONVERSAO DA UNIDADE DE MEDIDA                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER FUNCTION QTDCONV(xCod,xQuant,xFornece,xLjFor,xVlrTot)

Local nQuant  := 0
Local nVUnit  := 0
Local aConv   := {}
                  
IF lCLIENTE
	DbSelectArea("SA7")
	SA7->(DbSetOrder(2))
	SA7->(DbGoTop())
	IF SA7->(DbSeek(xFilial("SA7") + PADR(xCod,15) + xFornece + xLjFor))
		IF ALLTRIM(SA7->A7_TIPCONV) == "M"
			nQuant :=  xQuant * SA7->A7_CONV
			nVUnit := xVlrTot / nQuant
		ElseIF ALLTRIM(SA7->A7_TIPCONV) == "D"
			nQuant :=  xQuant / SA7->A7_CONV
			nVUnit := xVlrTot / nQuant
		EndIF
		
		aAdd( aConv , nQuant )
		aAdd( aConv , nVUnit )	
	EndIF
Else
	DbSelectArea("SA5")
	SA5->(DbSetOrder(2))
	SA5->(DbGoTop())
	IF SA5->(DbSeek(xFilial("SA5") + PADR(xCod,15) + xFornece + xLjFor))
		IF ALLTRIM(SA5->A5_TIPCONV) == "M"
			nQuant :=  xQuant * SA5->A5_CONV
			nVUnit := xVlrTot / nQuant
		ElseIF ALLTRIM(SA5->A5_TIPCONV) == "D"
			nQuant :=  xQuant / SA5->A5_CONV
			nVUnit := xVlrTot / nQuant
		EndIF
		
		aAdd( aConv , nQuant )
		aAdd( aConv , nVUnit )	
	EndIF
EndIF

RETURN(aConv)
