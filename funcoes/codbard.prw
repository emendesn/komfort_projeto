#include 'protheus.ch'
#include 'parmtype.ch'

//Everton Santos 08/11/2019
user function CodBarD()

Local cAlias   := GetnextAlias()
Local _cQuery  := ""
Local lRet     := .T.

if !Empty(M->E2_LINDIG)
	
	_cQuery := " SELECT E2_LINDIG,E2_NUM FROM SE2010(NOLOCK) WHERE E2_LINDIG = '"+ M->E2_LINDIG + "' AND D_E_L_E_T_ = '' "
	
	PLSQuery(_cQuery, cAlias)
	dBSelectArea(cAlias)

	If (cAlias)->(!EOF())
		MsgAlert("O Codigo digitado no campo Linha Dig. ja foi utilizado no titulo: "+ (cAlias)->E2_NUM + ".")
		lRet := .F.
	EndIf
	dBCloseArea(cAlias)
	
EndIf

return lRet