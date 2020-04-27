#INCLUDE "protheus.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "tbicode.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "Ap5Mail.Ch"
#INCLUDE "xmlxfun.ch"
#INCLUDE "JPEG.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � M460NOTA � Autor � LUIZ EDUARDO F.C.  � Data �  12/01/2018 ���
�������������������������������������������������������������������������͹��
���Descricao � PONTO DE ENTRADA NO FATURAMENTO DA CARGA                   ���
�������������������������������������������������������������������������͹��
���Uso       � KOMFORT HOUSE                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
USER FUNCTION M460NOTA()

/*-------------------------------------------------------------------------------------------
P.E nao atende pois o romaneio de entrega precisa ser impresso por carga. Quando ocorria o 
faturamento de mais uma carga era impresso somente um romaneio, o que nao estava correto.
Chamada da funcao passou a ser no P.E [M460FIM]. #Ellen 17.04.2018
--------------------------------------------------------------------------------------------*/

/*
IF !EMPTY(SF2->F2_CARGA)
	If MsgYesNo("Deseja Imprimir o Mapa de Entrega?...")
		FwMsgRun( ,{|| U_KMOMSR02(SF2->F2_CARGA) }, , "Imprimindo o Mapa de Entrega, por favor aguarde..." )
	EndIF
EndIF
*/

RETURN(.T.)
