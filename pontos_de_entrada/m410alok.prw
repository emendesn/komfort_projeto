#Include "Protheus.ch"

#DEFINE ENTER CHR(13)+CHR(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M410ALOK  ºAutor  ³Bernard M. Margaridoº Data ³  02/01/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada no cancelamento do pedido de venda.        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Template eCommerce                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M410ALOK()
Local lContinua   := .T.
Local cUserLog := SUPERGETMV("KH_BLQAPV", .T., "001099") //USUARIOS QUE NÃO POSSUEM PERMISSÃO PARA ALTERAR PEDIDO DE VENDA NORMAL - C5_01TPOP == '1'
Local aArea := GetArea()

If !l410Auto
	If Altera .And. !Empty(SC5->C5_ORCRES)
		RecLock("SC5",.F.)
		SC5->C5_ORCRES := ""
		Msunlock()
	ElseIf !Inclui .And. !Altera .And. !Empty(SC5->C5_ORCRES) .And. !AtIsRotina("A410VISUAL")
		RecLock("SC5",.F.)
		SC5->C5_ORCRES := ""
		Msunlock()
	EndIf
EndIf

//Bloqueio de alteração do PV. Everton Santos. 27/07/2019 - Chamado 7549
If !IsInCallStack("U_KMESTF02") 
	If ALTERA 
		If  !Empty(SC5->C5_ORCRES) .Or. !Empty(SC5->C5_NUMTMK) .Or. !Empty(SC5->C5_01SAC)
		 	If __cUserId $ cUserLog
				cMsg := "Pedido de venda gerado pela Loja ou SAC. Para altera-lo Entre em contato com o SAC." + ENTER
				msgAlert(cMsg,"ATENÇÃO - KH_BLQAPV")
				lContinua := .F.
			endIf
		EndIf	 		
	EndIf
Endif
//////////////////////////////////////////////////////////////////////////
//Verificaçao do processo de compra. Existencia de solicitação de compra
///////////////////////////Deo////29/12/17///////////////////////////////
//lContinua := u_KMC06Vld()

RestArea(aArea)

Return lContinua
