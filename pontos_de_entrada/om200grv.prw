#INCLUDE "Protheus.ch"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���PROGRAMA: �OM200GRV  �AUTOR: �Caio Garcia            �DATA: �08/10/18  ���
�������������������������������������������������������������������������Ĵ��
���USADO EM: � Estoque/Custos - Komfort House                             ���
�������������������������������������������������������������������������Ĵ��
���	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU��O INICIAL.		      ���
�������������������������������������������������������������������������Ĵ��
���  PROGRAMADOR  �  DATA  � ALTERACAO OCORRIDA 				          ���
�������������������������������������������������������������������������Ĵ��
���               |  /  /  |                                              ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function OM200GRV()

Local _c01SAC := ''
Local _cTroca := ''
Local _cTpTro := ''

_c01SAC := GetAdvFVal("SC5","C5_01SAC",xFilial("SC5")+TRBPED->PED_PEDIDO,1)

If !Empty(AllTrim(_c01SAC))
	
	DbSelectArea("ZK0")
	ZK0->(DbSetOrder(5))
	ZK0->(DbGoTop())
	
	If ZK0->(DbSeek(xFilial("ZK0")+_c01SAC))
		_cTroca := "SIM"
		
		If ZK0->ZK0_OPCTP == '1'
			_cTpTro := 'Troca'
		ElseIf ZK0->ZK0_OPCTP == '2'
			_cTpTro := 'Cancelamento'
		ElseIf ZK0->ZK0_OPCTP == "3"
			_cTpTro := 'Conserto'
		ElseIf ZK0->ZK0_OPCTP == "4"
			_cTpTro := 'TJ/PROCON'
		ElseIf ZK0->ZK0_OPCTP == "5"
			_cTpTro := 'Emprestimo'
		Else
			_cTpTro := ''       
		EndIf	
		
	Else
		_cTroca := "N�O"
	EndIf                    
	
Else
	
	_cTroca := 'N�O'
	
EndIf          

TRBPED->PED_ENTREG  := GetAdvFVal("SC6","C6_ENTREG",xFilial("SC6")+TRBPED->PED_PEDIDO+TRBPED->PED_ITEM,1)
TRBPED->PED_REGCON  := GetAdvFVal("SC5","C5_XREGCON",xFilial("SC5")+TRBPED->PED_PEDIDO,1)
TRBPED->PED_TROCA   := _cTroca
TRBPED->PED_OPCTP   := _cTpTro

MsUnlock()

Return Nil
