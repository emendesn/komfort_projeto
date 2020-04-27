#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A273VLDF  �Autor  �Microsiga           � Data �  23/01/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Bloqueia o cliente quando houver pendencia financeira.      ���
�������������������������������������������������������������������������͹��
���Uso       �Validacao de Campo: UA_MIDIA                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function A273VLDF()

Local aArea 	:= GetArea()  
Local cRotina	:= FunName()
Local lRet		:= .T.
Local cCliente 	:= If(cRotina=="TMKA271",M->UA_CLIENTE,M->AB6_CODCLI)
Local cLoja 	:= If(cRotina=="TMKA271",M->UA_LOJA,M->AB6_LOJA)

SA1->(DbSetOrder(1))
If SA1->(Dbseek(xFilial("SA1") + cCliente + cLoja ))
	
	If SA1->A1_01PEDFI=="1"
		MsgStop("Cliente possui pendencias financeiras. Contate o financeiro.","Aten��o")
		lRet := .F.
	Endif
	
Endif
		
RestArea(aArea)

Return(lRet)