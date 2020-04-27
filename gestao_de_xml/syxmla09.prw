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
±±ºPrograma  ³ SYXMLA09 º Autor ³ LUIZ EDUARDO F.C.  º Data ³  28/09/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ FAZ O ESTORNO DO XML                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GESTAO DE XML                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER FUNCTION SYXMLA09()

Local cqry := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VERIFICA SE JA FOI CRIADA UMA PRE-NOTA DESTE XML ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SF1")
SF1->(DbSetOrder(1))
SF1->(DbGoTop())

IF lTCLIENT
	DbSelectArea("SA1")
	SA1->(DbSetOrder(3))
	SA1->(DbSeek(xFilial("SA1") + Z31->Z31_CNPJFO))
	
	IF SF1->(DbSeek(xFilial("SF1") + Z31->Z31_NUM + Z31->Z31_SERIE + SA1->A1_COD + SA1->A1_LOJA))
		MsgInfo("Já existe uma pré-nota ou uma nota fiscal com estas informações! Por favor faça a exclusão para continuar o processo!  Nota:  " + Z31->Z31_NUM + "  Série: " + Z31->Z31_SERIE )
		Return()
	Else
		IF SF1->(DbSeek(xFilial("SF1") + Z31->Z31_NUM + Z31->Z31_SERIE + Z31->Z31_CODFOR + ALLTRIM(Z31->Z31_LJFOR)))
			MsgInfo("Já existe uma pré-nota ou uma nota fiscal com estas informações! Por favor faça a exclusão para continuar o processo!  Nota:  " + Z31->Z31_NUM + "  Série: " + Z31->Z31_SERIE )
			Return()
		EndIF
	EndIF
Else
	IF SF1->(DbSeek(xFilial("SF1") + Z31->Z31_NUM + Z31->Z31_SERIE + Z31->Z31_CODFOR + ALLTRIM(Z31->Z31_LJFOR)))
		MsgInfo("Já existe uma pré-nota ou uma nota fiscal com estas informações! Por favor faça a exclusão para continuar o processo!  Nota:  " + Z31->Z31_NUM + "  Série: " + Z31->Z31_SERIE )
		Return()
	EndIF
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ DELETA AS INFORMACOES NA TABELA Z34 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cqry := " DELETE FROM "  + RETSQLNAME('Z34')
cqry += " WHERE Z34_FILIAL = '" + XFILIAL("Z34") + "'"
cqry += " AND Z34_CHAVE = '" + Z31->Z31_CHAVE  + "' "
TCSQLExec(cqry)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ DELETA AS INFORMACOES NA TABELA Z32 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cqry := " DELETE FROM "  + RETSQLNAME('Z32')
cqry += " WHERE Z32_FILIAL = '" + XFILIAL("Z32") + "'"
cqry += " AND Z32_CHAVE = '" + Z31->Z31_CHAVE  + "' "
TCSQLExec(cqry)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VOLTA O STATUS DO XML PARA 02 - EM ABERTO NA TABELA Z31 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Z31->(RecLock("Z31",.F.))
Z31->Z31_STATUS := "02"
Z31->Z31_USER   := ALLTRIM(cUserName)
Z31->Z31_DTLOG  := dDataBase
Z31->Z31_HRLOG  := Time()
Z31->(MsUnlock())

RETURN()
