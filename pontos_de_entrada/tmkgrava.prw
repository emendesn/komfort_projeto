#include "protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TMKGRAVA º Autor ³ EDUARDO PATRIANI   º Data ³  26/10/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ PONTO DE ENTRADA NA GRAVACAO DO CHAMADO DO SAC             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ KOMFORT HOUSE                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER FUNCTION TMKGRAVA(cPendencia,cChamado,aCampos,nOpc)

Local aArea			:= GetArea()
Local aAreaSUC		:= SUC->(GetArea())
Local aAreaSUD		:= SUD->(GetArea())
Local cOcorrencia 	:= GETMV("KH_WFOCORR",,"000002/000005")
Local lEnvia		:= .F.
Local cStatus 		:= M->UC_STATUS

SUD->( dbSetOrder(1) )
SUD->( dbSeek(xFilial('SUD') + cChamado ))
While SUD->( !Eof() ) .and. SUD->UD_FILIAL+SUD->UD_CODIGO == xFilial("SUD")+cChamado

	Z01->(DbSetOrder(1))
	Z01->(DbSeek(xFilial("Z01") + SUD->UD_01TIPO ))

	If (SUD->UD_OCORREN $ cOcorrencia) .And. Empty(SUD->UD_WFID) .And. !(SUD->UD_ENVWKF $ "2/3") //.And. Z01->Z01_TIPO == '1'
		lEnvia := .T.
		Exit
	Endif 

	SUD->( dbSkip() )
End

If lEnvia	
	MsgRun("Por favor aguarde, enviando workflow...",, {|| U_SYTMWF02(1) })
Endif

SUC->(DbSetOrder(1))//#WRP20190105.BN
SUC->(DbSeek(xFilial("SUC") + cChamado))//#WRP20190105.EN
if SUC->(FieldPos("UC_XUSRENC")) > 0 .and. SUC->(FieldPos("UC_XDTENC")) > 0
//Grava o usuario e data ao realizar o encerramento do chamado.
	if cStatus == "3"
		recLock("SUC",.F.)
			SUC->UC_XUSRENC := LogUserName()
			SUC->UC_XDTENC := date()
		SUC->(msUnLock())
	endif
endif

RestArea(aAreaSUD)
RestArea(aAreaSUC)
RestArea(aArea)

RETURN()
