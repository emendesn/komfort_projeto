#include 'protheus.ch'

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �  MT110GRV� Autor � EDILSON MENDES       � Data � 12/12/2019���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de entrada apos grava��o da SC.                      ���
�������������������������������������������������������������������������Ĵ��
���          �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function MT110GRV()

Local aArea := GetArea()
Local cRet  := .T.

	//GRAVA O NOME DA FUNCAO NA Z03
	U_CFGRD001(FunName())
	
	//��������������������������������������������������������Ŀ
	//�Envia Workflow para aprovacao da Solicitacao de Compras �
	//����������������������������������������������������������
	If INCLUI .OR. ALTERA //Verifica se e Inclusao ou Alteracao da Solicitacao
		MsgRun("Enviando Workflow para Aprovador da Solicita��o, Aguarde...","",{|| CursorWait(), U_COMRD003() ,CursorArrow()})
	EndIf
	RestArea(aArea)
	
Return cRet