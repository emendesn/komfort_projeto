#Include "Protheus.ch"

#DEFINE ENTER CHR(13)+CHR(10)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M410ALOK  �Autor  �Bernard M. Margarido� Data �  02/01/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada no cancelamento do pedido de venda.        ���
�������������������������������������������������������������������������͹��
���Uso       � Template eCommerce                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function M410ALOK()
Local lContinua   := .T.
Local cUserLog := SUPERGETMV("KH_BLQAPV", .T., "001099") //USUARIOS QUE N�O POSSUEM PERMISS�O PARA ALTERAR PEDIDO DE VENDA NORMAL - C5_01TPOP == '1'
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

//Bloqueio de altera��o do PV. Everton Santos. 27/07/2019 - Chamado 7549
If !IsInCallStack("U_KMESTF02") 
	If ALTERA 
		If  !Empty(SC5->C5_ORCRES) .Or. !Empty(SC5->C5_NUMTMK) .Or. !Empty(SC5->C5_01SAC)
		 	If __cUserId $ cUserLog
				cMsg := "Pedido de venda gerado pela Loja ou SAC. Para altera-lo Entre em contato com o SAC." + ENTER
				msgAlert(cMsg,"ATEN��O - KH_BLQAPV")
				lContinua := .F.
			endIf
		EndIf	 		
	EndIf
Endif
//////////////////////////////////////////////////////////////////////////
//Verifica�ao do processo de compra. Existencia de solicita��o de compra
///////////////////////////Deo////29/12/17///////////////////////////////
//lContinua := u_KMC06Vld()

RestArea(aArea)

Return lContinua
