#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT103LDV � Autor � Eduardo Patriani     � Data � 14/05/2017���
�������������������������������������������������������������������������͹��
���Descri��o � Este ponto de entrada � executado durante o preenchimento  ���
���          � da linhas a serem enviadas para a rotina automatica		  ���
�������������������������������������������������������������������������͹��
���Observacao�                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MT103LDV()

Local aArea  := GetArea()
Local aDados := ParamIxb[1]
Local cAlias := Paramixb[2]	
Local aVetor := {}

AAdd( aDados, { "D1_01SAC" , (cAlias)->D2_01SAC	, Nil } )
	
RestArea(aArea)

Return(aDados)