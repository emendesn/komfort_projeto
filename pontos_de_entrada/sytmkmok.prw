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
���Programa  � SYTMKMOK � Autor � LUIZ EDUARDO F.C.  � Data �  21/03/2017 ���
�������������������������������������������������������������������������͹��
���Descricao � PONTO DE ENTRADA DENTRO DO FONTE TMKMOK ( GRAVACAO DOS     ���
���          � CHAMADOS DO SAC )                                          ���
�������������������������������������������������������������������������͹��
���Uso       � KOMFORT HOUSE                                              ���
�������������������������������������������������������������������������ͼ��                              		        '
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
USER FUNCTION SYTMKMOK ()

FwMsgRun( ,{|| U_KMSACA02() }, , "Gravando Log de Alteracao SAC , Por Favor Aguarde..." )    

RETURN(.T.)