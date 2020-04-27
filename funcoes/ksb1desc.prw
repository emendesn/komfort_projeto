#include 'protheus.ch'
#include 'parmtype.ch'

user function KSB1DESC(cProd)

Local cAlias := GetNextAlias()
Local cQuery := ""

iF !EMPTY(cProd)

cQuery := " SELECT  B1_DESC FROM SB1010(NOLOCK)"
cQuery += "	WHERE B1_COD = '"+cProd+"'"
cQuery += " AND D_E_L_E_T_ = ' '"

PlsQuery (cQuery,cAlias)

M->Z15_DESCOR := (cAlias)->B1_DESC
	
EndIf
		
return