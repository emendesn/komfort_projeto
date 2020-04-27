#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA273VLD2  บAutor  ณ SYMM CONSULTORIA   บ Data ณ  10/04/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณZera os descontos na mudanca dos seguintes campos           บฑฑ
ฑฑบDesc.     ณa) Tabela de preco do item;                                 บฑฑ
ฑฑบDesc.     ณa) Condicao de pagamento no cabecalho;                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function A273VLD2()

Local aArea 	:= GetArea()
Local lRet		:= .T.
Local nPDesc 	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_DESC"})
Local nPValDesc	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_VALDESC"})
Local nPTabPad	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_01TABPA"})
Local nPProd	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_PRODUTO"})
Local nLinha   	:= n
Local nX

For nX := 1 To Len(aCols)
	
	If !Empty(aCols[nX,nPProd])
		
		aCols[nX,nPDesc] 	:= 0
		aCols[nX,nPValDesc]	:= 0
		
		U_SyEnterCpo("UB_01TABPA",aCols[nX,nPTabPad],nX)		
	Endif
Next

n := nLinha
Eval(bGDRefresh)

RestArea(aArea)

Return(lRet)