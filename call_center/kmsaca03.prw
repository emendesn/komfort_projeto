#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#Include "Ap5Mail.Ch"
#Include "xmlxfun.ch"
#INCLUDE "JPEG.CH"

#Define CRLF Chr(10)+Chr(13)

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � KMSACA03 � Autor � LUIZ EDUARDO F.C.  � Data �  10/04/2017 ���
�������������������������������������������������������������������������͹��
���Descricao � TRAVA O PREENCHIMENTO DO CAMPO ACAO DE ACORDO COM O PERFIL ���
���Descricao � DO OPERADOR - UD_SOLUCAO                                   ���
�������������������������������������������������������������������������͹��
���Uso       � KOMFORT HOUSE                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
USER FUNCTION KMSACA03()

Local cVendedor := ALLTRIM(POSICIONE("SU7",4,xFilial("SU7")+__CUSERID,"U7_CODVEN"))
Local cLiber    := ""
Local lRet      := .T.

IF !EMPTY(cVendedor)
	cLiber := POSICIONE("SUQ",1,xFilial("SUQ")+UD_SOLUCAO,"UQ_XLIBVND")
	IF EMPTY(cLiber) .OR. cLiber == "2"
		MsgInfo("A��o n�o liberada para uso do Depto. de Vendas!!!")
		UD_SOLUCAO		:= SPACE(06)
		M->UD_SOLUCAO 	:= SPACE(06)
		UD_DESCSOL    	:= SPACE(20)
		M->UD_DESCSOL 	:= SPACE(20) 
		acols[1][8]    	:= SPACE(06)
		acols[1][9]    	:= SPACE(20)
		lRet := .F.
	EndIF
EndIF

RETURN(lRet) 