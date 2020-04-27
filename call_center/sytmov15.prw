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
���Programa  � SYTMOV15 � Autor � LUIZ EDUARDO F.C.  � Data �  31/08/16   ���
�������������������������������������������������������������������������͹��
���Descricao � ATUALIZA OS STATUS DOS PEDIDOS                             ���
�������������������������������������������������������������������������͹��
���Uso       � KOMFORT HOUSE                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
USER FUNCTION SYTMOV15(cPedido,cItem,cProduto,cStatus)

Local aArea 	:= GetArea()
Local aAreaSC6 	:= SC6->(GetArea())

DbSelectArea("SC6")
DbSetOrder(1)
// C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
DbSeek(xFilial("SC6") + cPedido + cItem + cProduto)

RecLock("SC6",.F.)
SC6->C6_01STATU  := cStatus
MsUnlock()

RestArea(aArea)
RestArea(aAreaSC6)

RETURN()
