#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT120GRV º Autor ³ Ellen Santiago       º Data ³ 10/04/2018º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ P.E  após salvar o pedido de compra atualizar o campo data º±±
±±º          ³ de entrega prevista pelo fornecedor                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ KomfortHouse                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MT120FIM()

Local aArea 	:= GetArea()
Local aAreaC7	:= SC7->(GetArea())
Local nPosProd	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_PRODUTO"})
Local nPosPV	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_01NUMPV"})
Local cDatprf	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_DATPRF"}) 
Local nOpcao 	:= PARAMIXB[1] // Opção Escolhida pelo usuario
Local nSelec  	:= PARAMIXB[3] // Indica se a ação foi Cancelada = 0  ou Confirmada = 1  
Local nX		:= 0
     
If nSelec == 1
	If (nOpcao == 3 .or. nOpcao == 4) //Inclusao ou Alteracao
		DbSelectArea("SC6")
		DbSetOrder(2) 
		For nX := 1 To Len(aCols)  
			If SC6->(DbSeek(xFilial("SC6")+aCols[nX][nPosProd]+aCols[nX][nPosPV]))		   	
			   	RecLock("SC6",.F.)
			   		SC6->C6_XDTFORN = aCols[nX][cDatprf]
				SC6->(MsUnlock())
			Endif
		Next
	Endif
Endif
	    
RestArea(aAreaC7)
RestArea(aArea)
    
Return