#INCLUDE "PROTHEUS.CH"

 /*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT100TOK  �Autor  �Juliana Taveira     � Data �  20/04/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Validacao na confirmacao da nota fiscal de entrada          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���          �1- Valida se a chave de acesso foi preenchida para NFE SPED ���
�������������������������������������������������������������������������ͼ��
���17/10/17  � Valida��o da chave NFe na inclus�o de Documento de Entrada.���
���ERPPlus   � Empresa Galderma                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT100TOK()
Local aArea	:= GetArea()
Local lRet := .T.
Local _lErro  := .F.
Local _Return := .T.

//������������������������Ŀ
//�Verifica Chave de acesso�
//��������������������������
//if cfilant == '04' .and. Type("cEspecie")<>"U" .and. Type("cFormul")<>"U"	//#RVC20180924.o
if Type("cEspecie")<>"U" .and. Type("cFormul")<>"U" 						//#RVC20180924.n
	If ( Alltrim(cEspecie)=="SPED" .OR. Alltrim(cEspecie)=="CTE") .and. cFormul == "N" .and. len(aNfeDanfe)>=13 .and. Empty(aNfeDanfe[13])
		MsgStop("Chave de acesso obrigatorio"+ CHR(13) + "Preencher o campo chave de acesso")
		lRet := .F.
	EndIf
Endif
   
// Realizado por Rafael Cruz - ERP Plus - 17/10/2017.
dbSelectArea("SF1")
dbSetOrder(8)
dbGotop()
If !(Empty(M->F1_CHVNFE)) .AND. SF1->(dbSeek(xFilial("SF1") + M->F1_CHVNFE))
	If IsBlind() 
		ConOut("Documento j� cadastrado com a Chave NFe encontrada." + CHR(13) + "Chave n. " + M->F1_CHVNFE)  
	Else
		MsgStop("Documento j� cadastrado com a Chave NFe informada." + CHR(13) + "Chave n. " + M->F1_CHVNFE)
	EndIf
	lRet := .F.
EndIf
// Fim - Realizado por Rafael Cruz - ERP Plus - 17/10/2017.

RestArea(aArea)
Return(lRet)