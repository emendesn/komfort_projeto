#include "totvs.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TIRADV    �Autor  � Cristiam Rossi     � Data �  27/07/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna Codigo de barras sem os d�gitos verificadores      ���
���          � Concession�rias                                            ���
�������������������������������������������������������������������������͹��
���Uso       � KomfortHouse / Global                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function tiraDV( cParEntr )
Local cRet := alltrim(cParEntr)

	if len( cRet ) > 47
		cRet := substr( cRet, 1, 11) + substr( cRet, 13, 11) + substr( cRet, 25, 11) + substr( cRet, 37, 11)
	elseif len( cRet ) == 47
		cRet := left(cRet,4) + substr(cRet,33,1) + substr(cRet,34) + ( substr(cRet,5,5) + substr(cRet,11,10) + substr(cRet,22,10) )
	endif

return padR(cRet,44)
