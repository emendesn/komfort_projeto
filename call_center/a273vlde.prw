#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A273VLDE  �Autor  �Microsiga           � Data �  29/09/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Carrego as quantidades prevista de ordem de compra estoque. ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function A273VLDE(cProduto)

Local aArea 	:= GetArea()
Local cQuery	:= ""
Local cAlias    := GetNextAlias()
Local aProds	:= {}            
Local nSaldo	:= 0

cQuery += " SELECT C7_NUM NUMERO,C7_PRODUTO PRODUTO,(C7_QUANT-(C7_QUJE+C7_QTDACLA)) SALDO FROM "+RetSqlName("SC7")+" SC7 (NOLOCK) "
cQuery += " WHERE C7_PRODUTO = '"+cProduto+"' "
cQuery += " AND C7_01TPMAT = '2' "
cQuery += " AND SC7.D_E_L_E_T_ = ' ' "
cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

(cAlias)->(DbGotop())
While (cAlias)->(!Eof())
	AAdd(aProds , { (cAlias)->NUMERO, (cAlias)->PRODUTO, (cAlias)->SALDO } )
	nSaldo += (cAlias)->SALDO
	(cAlias)->(DbsKIP())
End
(cAlias)->( dbCloseArea() )

RestArea(aArea)

Return(nSaldo)