#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#Include "Ap5Mail.Ch"
#Include "xmlxfun.ch"
#INCLUDE "JPEG.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � OM320EST � Autor � LUIZ EDUARDO F.C.  � Data �  29/06/2017 ���
�������������������������������������������������������������������������͹��
���Descricao � PONTO DE ENTRADA NO ESTORNO DE RETORNO DE CARGA            ���
�������������������������������������������������������������������������͹��
���Uso       � KOMFORT HOUSE                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/                          
USER FUNCTION OM320EST()

//����������������������������������������������������������������������������������������������������������������������Ŀ
//� DESAMARRA A CARGA NO TERMO DE RETIRA E VOLTA O STATUS DO TERMO PARA "1 = PENDENTE' - LUIZ EDUARDO .F.C. - 28.06.2017 �
//������������������������������������������������������������������������������������������������������������������������
DbSelectArea("ZK0")
ZK0->(DbSetOrder(2))
ZK0->(DbGoTop())
IF ZK0->(DbSeek(xFilial("ZK0") + DAK->DAK_COD))
	WHILE ZK0->(!EOF()) .AND. ZK0->ZK0_FILIAL + ZK0->ZK0_CARGA == xFilial("ZK0") + DAK->DAK_COD
		ZK0->(RecLock("ZK0",.F.))
		ZK0->ZK0_STATUS := "2"
		ZK0->ZK0_DTRET  := CTOD("")
		ZK0->(MsUnlock())
		ZK0->(DbSkip())
	EndDo
EndIF

RETURN(.T.)