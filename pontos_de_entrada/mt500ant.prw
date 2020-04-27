#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT500ANT  �Autor  � TOTVS              � Data �  26/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada permite validar dados especificos   		  ���
���Desc.     �do usuario antes da eliminacao do residuo.		   		  ���
�������������������������������������������������������������������������͹��
���Programa. � MATA500  										   		  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT500ANT()

Local aArea := GetArea()
Local lRet  := .T.

If Empty(SC5->C5_ORCRES)
	RecLock("SC5",.F.)
	SC5->C5_ORCRES := SC5->C5_NUMTMK
	Msunlock()
Endif

If SC6->C6_QTDEMP > 0 
	lRet := .F.      
	MsgInfo("Aten��o usu�rio, o item: "+SC6->C6_ITEM+" do Pedido: "+SC6->C6_NUM+" encontra-se liberado. Por favor estornar o pedido.","Aten��o")
Endif

RestArea(aArea)

Return(lRet)