#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#Include "Ap5Mail.Ch"
#Include "xmlxfun.ch"
#INCLUDE "JPEG.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � KMSACA05 � Autor � LUIZ EDUARDO F.C.  � Data �  23/05/17   ���
�������������������������������������������������������������������������͹��
���Descricao � GATINHO NO CAMPO UD_XCODNET - ITENS DO TELEMARKETING       ���
�������������������������������������������������������������������������͹��
���Uso       � KOMFORT HOUSE                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
USER FUNCTION KMSACA05()

Local aAreaSB1  := SB1->(GetArea())
Local lRet      := .T.

Private nPRODUTO := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_PRODUTO"})
Private nDESCPRO := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_DESCPRO"})  

DbSelectArea("SB1")
DbSetOrder(12)
IF DbSeek(xFilial("SB1") + M->UD_XCODNET) 
	aCols[N,nPRODUTO] := SB1->B1_COD 
	aCols[N,nDESCPRO] := SB1->B1_DESC
Else
	MsgAlert("N�o existe relacionamento para o c�digo NETGERA informado!!!") 
	lRet := .F.
EndIF

RestArea(aAreaSB1)

RETURN(lRet)
