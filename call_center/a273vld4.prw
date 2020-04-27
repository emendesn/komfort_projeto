#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A273VLD4  �Autor  �Microsiga           � Data �  20/02/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida o preenchimento do campo conforme a regra.           ���
�������������������������������������������������������������������������͹��
���Uso       �Validacao de Campo: UB_FILSAI (Modo de Edicao)              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function A273VLD4()

Local aArea 	:= GetArea()  
Local nPCondEnt	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_CONDENT"})
Local nPTpEntre	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_TPENTRE"})
Local lRet		:= .T.

//lRet := !(aCols[n,nPCondEnt]=="2" .AND. aCols[n,nPTpEntre]=="3")                 

RestArea(aArea)

Return(lRet)