#include 'protheus.ch'
#include 'parmtype.ch'

//----------------------------------------------------------------------
// Everton Santos - 10/01/2020
// Fun��o para bloquear a edi��o do campo C5_PEDPEND
//----------------------------------------------------------------------
user function PENDFIN()

Local lRet := .F.
Local cUsers := SuperGetMV("KH_PENDFIN",.T.,"000006")

If __cUserID $ cUsers
	lRet := .T.
EndIF
	
return lRet