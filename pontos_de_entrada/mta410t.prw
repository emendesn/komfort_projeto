#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA410T   �Autor  �Bernard M. Margarido� Data �  02/01/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada apos a gravacao do pedido.        		  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MTA410T()

Local aArea 	:= GetArea()
Local cRotina   := FunName()

If Alltrim(cRotina)=="MATA410"
	If !l410Auto
		RecLock("SC5",.F.)
		SC5->C5_ORCRES := SC5->C5_NUMTMK
		Msunlock()
	EndIf
EndIf

RestArea(aArea)

Return(.T.)
