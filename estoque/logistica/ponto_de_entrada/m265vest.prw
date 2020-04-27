#include "rwmake.ch"
#include "TbiConn.ch"
#include "protheus.ch"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � M265VEST � Autor � Vanito Rocha       � Data � 16/05/2019  ���
�������������������������������������������������������������������������͹��
���Descricao � Estorno de Endere�amento-Devolve as quantidades e desmarca ���
���Descricao � a etiqueta como endere�ada                                 ���
�������������������������������������������������������������������������͹��
���Uso       � KOMFORT HOUSE                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function M265VEST()
Local nRet   := ParamIXB[1]// Valida��es do usu�rio...
Local xDoc   := DA_DOC
Local xSerie := DA_SERIE
Local xForn  := DA_CLIFOR
Local xLoja  := DA_LOJA
Local cQuery :=""

If nRet=1
	DbSelectArea("ZL2")
	DbSetOrder(2)
	If DbSeek(xFilial("ZL2")+xDoc+xSerie+xForn+xLoja)
		cQuery := "UPDATE "+RetSqlname("ZL2")+" "
		cQuery += "SET ZL2_QUANT = 1, ZL2_ENDER='N' "
		cQuery += "WHERE ZL2_NOTA='"+xDoc+"' AND ZL2_SERIE='"+xSerie+"' AND ZL2_FORNE='"+xForn+"' AND ZL2_LOJA='"+xLoja+"' AND "
		cQuery += "D_E_L_E_T_=' ' "
		TcSqlExec(cQuery)
	Endif
Endif

Return nRet
