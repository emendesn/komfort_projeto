#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �	TMKCPG  �Autor  � SYMM CONSULTORIA   � Data �  10/04/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada executado antes da abertura da tela de     ���
���          �condi��o de pagamento.	                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TMKCPG(lHabilAux)	

Local aArea := GetArea()

Public __cCondPg := M->UA_CONDPG

lHabilAux := .T.	    

RestArea(aArea)

Return