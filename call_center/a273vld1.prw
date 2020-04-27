#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A273VLD1  �Autor  �Microsiga           � Data �  20/02/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Somente o ADM ou Supervisor pode selecionar a opcao 3.      ���
�������������������������������������������������������������������������͹��
���Uso       �Validacao de Campo: UA_PEDPEND                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function A273VLD1()

Local aArea 	:= GetArea()  
Local lRet		:= .T.
Local cOperador := M->UA_OPERADO
Local cUserId	:= __cUserID

If !Empty(cOperador)
	
	SU7->(DbSetOrder(4))
	SU7->(Dbseek(xFilial("SU7") + cUserId ))
	
	If SU7->U7_TIPO=="1" 	//Operador

		If M->UA_PEDPEND == "3"
		
			MsgStop("Voce n�o pode selecionar essa op��o. Somente o Supervisor ou ADM.","Aten��o")
			lRet := .F.
		
		Endif
		
	Endif
		
Endif

RestArea(aArea)

Return(lRet)