#include 'protheus.ch'
#include 'parmtype.ch'

user function KHPVFIM()
	
Local aArea := GetArea()
Local cNumTmk := ""

//Inclus�o do or�amento com base no pedido de venda
cNumTmk := U_KHTMKA01(PARAMIXB[1])

restArea(aArea)

return cNumTmk