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
���Programa  � KMSACA06 � Autor � LUIZ EDUARDO F.C.  � Data �  23/05/17   ���
�������������������������������������������������������������������������͹��
���Descricao � GATINHO NO CAMPO UD_OCORREN - ITENS DO TELEMARKETING       ���
�������������������������������������������������������������������������͹��
���Uso       � KOMFORT HOUSE                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
USER FUNCTION KMSACA06()       
                                              
Local nSTATUS  := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_STATUS"})
Local nXIMPLAU := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_XIMPLAU"}) 
Local nSolucao  := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_SOLUCAO"})

IF aCols[N,nSolucao] $ '000013' .And. aCols[N,nSTATUS]=='1' //Permite a impressao do laudo desde que a acao seja 000013 
	aCols[N,nXIMPLAU] := "1"
EndIF

RETURN(.T.)