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
���Programa  � KMSACA02 � Autor � LUIZ EDUARDO F.C.  � Data �  10/03/2017 ���
�������������������������������������������������������������������������͹��
���Descricao � GRAVA LOG DE ALTERACAO DE CHAMADO DO SAC                   ���
�������������������������������������������������������������������������͹��
���Uso       � KOMFORT HOUSE                                              ���
�������������������������������������������������������������������������ͼ��                              		        '
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
USER FUNCTION KMSACA02()

Local cMensagem := ""     

IF INCLUI
	cMensagem := "INCLUSAO - " + ALLTRIM(cUserName) + " - " + 	DTOC(dDataBase) + " - " + Time()
ElseIF ALTERA
	cMensagem := CRLF + "ALTERACAO - " + ALLTRIM(cUserName) + " - " + 	DTOC(dDataBase) + " - " + Time()
EndIF       

M->UC_XOBS := M->UC_XOBS + cMensagem                                                                                

RETURN()