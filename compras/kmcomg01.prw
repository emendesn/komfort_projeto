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
���Programa  � KMCOMG01 � Autor � LUIZ EDUARDO F.C.  � Data �  07/03/2017 ���
�������������������������������������������������������������������������͹��                                     
���Descricao � GATILHO NO CAMPO D1_COD - PREENCHE O CAMPO D1_XDESCRI COM  ���
���          � A DESCRICAO DO PRODUTO                                     ���
�������������������������������������������������������������������������͹��
���Uso       � KOMFORT HOUSE - COMPRAS                                    ���
�������������������������������������������������������������������������ͼ��                                     
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
USER FUNCTION KMCOMG01()           

Local nXDESCRI := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_XDESCRI"})
Local nCOD     := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_COD"})

IF nXDESCRI > 0
	aCols[n,nXDESCRI] := Posicione("SB1",1,xFilial("SB1")+M->D1_COD,"B1_DESC")
EndIF

RETURN(.T.)