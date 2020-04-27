#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �OS200EST  �Autor  �ALFA	             � Data �  03/03/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada no estorno da carga, para voltar status do���
���          � pedido de vendas                                           ���                                  '
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION OS200EST()

Local aArea		:= GetArea()

dbselectarea("SC9")
DBSETORDER(5)

DBSEEK(XFILIAL("SC9")+paramixb[1]+paramixb[2])
While SC9->C9_FILIAL == XFILIAL("SC9") .AND. SC9->C9_CARGA == paramixb[1] .AND. SC9->C9_SEQCAR == paramixb[2]
	
	//ATUALI��O DE STATUS DO PEDIDO TIPO 3 - oStA - "BR_BRANCO"  "Produto Agendado"
	U_SYTMOV15(SC9->C9_PEDIDO, SC9->C9_ITEM,SC9->C9_PRODUTO ,"3")
	
	dbselectarea("SC9")
	dbskip()
enddo

dbCloseArea()
RestArea(aArea)

//����������������������������������������������������������������������������������������������������������������������Ŀ
//� DESAMARRA A CARGA NO TERMO DE RETIRA E VOLTA O STATUS DO TERMO PARA "1 = PENDENTE' - LUIZ EDUARDO .F.C. - 28.06.2017 �
//������������������������������������������������������������������������������������������������������������������������
DbSelectArea("ZK0")
ZK0->(DbSetOrder(2))
ZK0->(DbGoTop())
IF ZK0->(DbSeek(xFilial("ZK0") + paramixb[1]))
	WHILE ZK0->(!EOF()) .AND. ZK0->ZK0_FILIAL + ZK0->ZK0_CARGA == xFilial("ZK0") + paramixb[1]
		ZK0->(RecLock("ZK0",.F.))
		ZK0->ZK0_CARGA  := ""
		ZK0->ZK0_STATUS := "1"
		ZK0->(MsUnlock())
		ZK0->(DbSkip())
	EndDo
EndIF


return()
