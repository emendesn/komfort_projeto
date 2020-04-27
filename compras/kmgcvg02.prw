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
���Programa  � KMGCVG02 � Autor � LUIZ EDUARDO F.C.  � Data �  12/01/2018 ���
�������������������������������������������������������������������������͹��
���Descricao � VALIDACAO NO CAMPO C7_PRODUTO PARA VERIFICAR SE O MESMO    ���
���Descricao � ESTA FORA DE LINHA E BLOQUEIA A CAMPRA                  	  ���
�������������������������������������������������������������������������͹��
���Uso       � KOMFORT HOUSE                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
USER FUNCTION KMGCVG02()       

Local lRet := .T.

IF ALLTRIM(POSICIONE("SB1",1,XFILIAL("SB1") +C7_PRODUTO,"B1_01FORAL")) == "F"
	MsgAlert("Produto marcado como fora de linha, n�o � possivel efetuar nova compra!") 
	lRet := .F.
EndIF

RETURN(lRet)