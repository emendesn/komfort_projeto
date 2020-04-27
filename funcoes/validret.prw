#include 'protheus.ch'
#include 'parmtype.ch'

//Função para contar a quantidade de retornos agendados por responsavel atraves da data selecionada no campo UC_PENDENT
//Everton Santos
user function ValidRet(_dRet,_cResp)

Local _lRet   := .T.
Local _nCount := 0
Local cAlias  := GetNextAlias()
Local cQuery  := ''

DbSelectArea("SUC")

cQuery := " SELECT COUNT(UC_CODIGO) AS COUNT FROM SUC010(NOLOCK)"
cQuery += " WHERE UC_TIPO = '"+ _cResp +"'"
cQuery += " AND UC_PENDENT = '"+ DTOS(_dRet) +"'"
cQuery += " AND D_E_L_E_T_ = ''"

If (Select(cAlias) > 0)
	(cAlias)->(dbCloseArea())
EndIf

PlsQuery(cQuery,cAlias)

_nCount := (cAlias)->COUNT

If (cAlias)->(!EOF())
	MsgAlert("Existem  "+ CvalToChar(_nCount) + "  Retornos agendados para  "+ DTOC(_dRet) +" .","Retornos Agendados")
EndIf
	
Return _lRet