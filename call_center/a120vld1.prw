#INCLUDE "PROTHEUS.CH"

#DEFINE FRETE 3

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออปฑฑ
ฑฑบPrograma  ณ A120VLD1 บAutor  ณ SYMM CONSULTORIA   บ Data ณ 26.05.2014 	   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออฯอออออออออนฑฑ
ฑฑบDesc.     ณ Carregar o frete automatico no pedido de compra.				   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function A120VLD1(nLinha)
/*
Local aArea		:= GetArea()
Local nPosProd	:= aScan(aHeader,{|x| Alltrim(x[2]) == "C7_PRODUTO"})
Local nPosTotal	:= aScan(aHeader,{|x| Alltrim(x[2]) == "C7_TOTAL"})
Local nPosVlIpi	:= aScan(aHeader,{|x| Alltrim(x[2]) == "C7_VALIPI"})
Local nVlrFrete	:= 0
Local nX

Default nLinha  := 0

aValores[FRETE]	:= 0

For nX := 1 To Len(aCols)
	
	If nLinha <> nX
		
		If !aCols[nX][Len(aHeader)+1]
			
			SB1->(DbSetOrder(1))
			SB1->(DbSeek(xFilial("SB1") + aCols[nX,nPosProd] ))
			
			SB4->(DbSetOrder(1))
			SB4->(DbSeek(xFilial("SB4") + SB1->B1_01PRODP ))
			
			If SB4->B4_01VLFRE > 0
				nVlrFrete += Round(((aCols[nX,nPosTotal]+aCols[nX,nPosVlIpi]) * SB4->B4_01VLFRE)/100,2)
			Endif
			
		Endif
		
	Endif
	
Next

aValores[FRETE]	:= nVlrFrete
cTpFrete		:= "C-CIF"
A120VFold("NF_FRETE",aValores[FRETE])

RestArea(aArea)
*/
Return(.T.)