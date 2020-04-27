#include 'protheus.ch'
#include 'parmtype.ch'

user function KHPVFIM()
	
Local aArea := GetArea()
Local cNumTmk := ""

//Inclusão do orçamento com base no pedido de venda
cNumTmk := U_KHTMKA01(PARAMIXB[1])

restArea(aArea)

return cNumTmk