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
���Programa  � KMLOJG03 � Autor � LUIZ EDUARDO F.C.  � Data �  28/05/2017 ���
�������������������������������������������������������������������������͹��                                     
���Descricao � GATILHO NO CAMPO UA_VEND - SO PERMITE VENDA PARA VENDEDOR  ���
�������������������������������������������������������������������������͹��
���Uso       � KOMFORT HOUSE - LOJA                                       ���
�������������������������������������������������������������������������ͼ��                                     
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
USER FUNCTION KMLOJG03()  
                
Local lRet      := .F. 
Local aAreaSB3  := SA3->(GetArea())

DbSelectArea("SA3")
SA3->(DbsetOrder(1))
SA3->(DbGoTop())    

SA3->(DbSeek(xFilial("SA3") + M->UA_VEND)) 

IF SA3->A3_01TIPO == "1"  
	lRet := .T.
Else
	lRet := .F.
	MsgInfo("N�o � permitido emitir vendas  como Gerente Loja/Supervisor/Gerente Regional!")
EndIF


RestArea(aAreaSB3)

RETURN(lRet)