#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MSD2520  � Autor � Eduardo Patriani     � Data � 06/04/2017���
�������������������������������������������������������������������������͹��
���Descri��o � Esse ponto de entrada est� localizado na fun��o A520Dele().���
���          � E chamado antes da exclus�o do registro no SD2.			  ���
�������������������������������������������������������������������������͹��
���Observacao�                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MSD2520()

Local aArea  := GetArea()
Local cCarga := SF2->F2_CARGA

cQuery := "UPDATE "+RetSqlname("SF1")+" "
cQuery += "SET F1_XCARGA = ' ' "
cQuery += "WHERE F1_XCARGA='"+cCarga+"' AND "
cQuery += "D_E_L_E_T_=' ' "
TcSqlExec(cQuery)
                                        
//ATUALI��O DE STATUS DO PEDIDO TIPO oStA - "BR_BRANCO"  "Produto Agendado"
if alltrim(cCarga) <>  ""
	U_SYTMOV15(SD2->D2_PEDIDO,SD2->D2_ITEMPV,SD2->D2_COD ,"3")
endif
	

RestArea(aArea)

Return