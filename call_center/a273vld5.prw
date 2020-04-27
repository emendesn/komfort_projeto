#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A273VLD5  �Autor  �Microsiga           � Data �  20/02/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida o preenchimento do campo conforme a regra.           ���
�������������������������������������������������������������������������͹��
���Uso       �Validacao de Campo: UB_TPENTRE 				                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function A273VLD5()

Local aArea 	:= GetArea()  
Local nPCondEnt	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_CONDENT"})
Local nPTipProd	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_MOSTRUA"})
Local cConteudo	:= &(ReadVar())
Local lRet		:= .T.

If aCols[n,nPCondEnt]=="2" .And. cConteudo=="1"
	MsgStop("N�o � permitido escolher esta op��o, quando o produto for de encomenda.","Aten��o")
	lRet := .F.
Endif

If aCols[n,nPTipProd]=="4" .And. cConteudo <> "1"
	MsgStop("N�o � permitido escolher esta op��o, quando o produto for um acess�rio.","Aten��o")
	lRet := .F.
Endif

RestArea(aArea)

Return(lRet)