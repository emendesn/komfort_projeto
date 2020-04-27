#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH" 

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � F240AFIL � Autor � LUIZ EDUARDO F.C.  � Data �  31/01/18   ���
�������������������������������������������������������������������������͹��
���Descricao � P.E. NO FILTRO DE TITULOS PARA A MONTAGEM DO BORDERO       ���
�������������������������������������������������������������������������͹��
���Uso       � KOMFORT HOUSE                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
USER FUNCTION F240AFIL()  

Local cFiltro := PARAMIXB[1]  

//cFiltro := "E2_XTPPAG = '"+PADR(cModPgto,6)+"' AND " + cFiltro	//#RVC20180723.o
cFiltro := "E2_XTPPAG = '"+ Alltrim(cTipoPag) +"' AND " + cFiltro	//#RVC20180723.n

RETURN(cFiltro)