#include "rwmake.ch"
#include "TbiConn.ch"
#include "protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ M265VEST บ Autor ณ Vanito Rocha       บ Data ณ 16/05/2019  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Estorno de Endere็amento-Devolve as quantidades e desmarca บฑฑ
ฑฑบDescricao ณ a etiqueta como endere็ada                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ KOMFORT HOUSE                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function M265VEST()
Local nRet   := ParamIXB[1]// Valida็๕es do usuแrio...
Local xDoc   := DA_DOC
Local xSerie := DA_SERIE
Local xForn  := DA_CLIFOR
Local xLoja  := DA_LOJA
Local cQuery :=""

If nRet=1
	DbSelectArea("ZL2")
	DbSetOrder(2)
	If DbSeek(xFilial("ZL2")+xDoc+xSerie+xForn+xLoja)
		cQuery := "UPDATE "+RetSqlname("ZL2")+" "
		cQuery += "SET ZL2_QUANT = 1, ZL2_ENDER='N' "
		cQuery += "WHERE ZL2_NOTA='"+xDoc+"' AND ZL2_SERIE='"+xSerie+"' AND ZL2_FORNE='"+xForn+"' AND ZL2_LOJA='"+xLoja+"' AND "
		cQuery += "D_E_L_E_T_=' ' "
		TcSqlExec(cQuery)
	Endif
Endif

Return nRet
