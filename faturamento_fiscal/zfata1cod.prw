#INCLUDE "Protheus.ch"
#INCLUDE "Rwmake.ch"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ZFATA1COD � Autor � Caio Garcia        � Data �  06/06/2018 ���
�������������������������������������������������������������������������͹��
���Descricao � Busca ultimo codigo na SA1                                 ���
�������������������������������������������������������������������������͹��
���Uso       � KOMFORT HOUSE                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function ZFATA1COD()
               
Local _cAlias       := GetNextAlias()
Local _cCodigo      := ""
Local _lSai         := .T.
Local _cCodSXE      := ""

_cQuery := " SELECT * "
_cQuery += " FROM " + RETSQLNAME("SA1") + " SA1 "
_cQuery += " WHERE SA1.D_E_L_E_T_ <> '*' "
_cQuery += " ORDER BY A1_COD DESC "

_cQuery := ChangeQuery(_cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),(_cAlias),.F.,.T.)

DbSelectArea(_cAlias)
(_cAlias)->(DbGoTop()) 
                                               
_cCodigo := Soma1((_cAlias)->A1_COD)

(_cAlias)->(DbCloseArea())                    

_cCodSXE := GetSxeNum("SA1","A1_COD")

While _lSai

	If (_cCodSXE > _cCodigo)

		_lSai := .F.

	Else
	
		If (_cCodSXE == _cCodigo)
			
			_lSai := .F.
			
		Else
		
			ConfirmSx8()
			_cCodSXE := GetSxeNum("SA1","A1_COD")
			
		EndIf

	EndIf

EndDo

Return(_cCodSXE) 