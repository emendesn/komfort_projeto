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
���Programa  � KMFATG01 � Autor � LUIZ EDUARDO F.C.  � Data �  18/01/18   ���
�������������������������������������������������������������������������͹��
���Descricao � VALIDACAO NO CAMPO X3_INIBRW DO CAMPO C6_NOMCLI PARA TRAZER���
���          � O NOME DE ACORDO COM O TIPO DO PV - CLIENTE/FORNECEDOR     ���
�������������������������������������������������������������������������͹��
���Uso       � KOMFORT HOUSE                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
USER FUNCTION KMFATG01(cAlias)

Local cNome := ""

IF ALLTRIM(cAlias) == "SC5"
	IF SC5->C5_TIPO $ "D/B"
		cNome := Posicione("SA2",1,xFilial("SA2")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A2_NOME")
	Else
		cNome := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME")
	EndIF
Else
	IF SC5->C5_TIPO $ "D/B"
		cNome := Posicione("SA2",1,xFilial("SA2")+SC6->C6_CLI+SC6->C6_LOJA,"A2_NOME")
	Else
		cNome := Posicione("SA1",1,xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA,"A1_NOME")
	EndIF
EndIF

RETURN(cNome)          
