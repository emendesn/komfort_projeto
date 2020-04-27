#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �OM200QRY  �Autor  �ALFA                � Data �  02/15/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada na montagem de carga para filtrar os      ���
���          � pedidos da Komfort n�o agendados.                          ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

user function OM200QRY()
    
	local cQuery := paramixb[1]             
	
	//Tabelas posicionadas na Query //#AFD20180413.n
	//SC9, SC5, SC6, SB1 //#AFD20180413.n
	cQuery := cQuery + " AND SC6.C6_01AGEND = '1'"
	cQuery := cQuery + " AND SC5.C5_PEDPEND <> '2'"	//#AFD20180413.n
	cQuery := cQuery + " AND SC5.C5_XCONPED = '1'"	//#AFD20181213.n
	
return(cQuery)
