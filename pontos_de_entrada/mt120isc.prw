#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT120ISC º Autor ³ Ellen Santiago       º Data ³ 10/04/2018º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ P.E reponsável por trazer as informações das solicitações  º±±
±±º          ³ de Compra para o aCols do Pedido de Compras.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ KomfortHouse                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MT120ISC() 

Local nNumPv      := aScan(aHeader,{|x| AllTrim(x[2])=="C7_01NUMPV"})
Local _nPosPrc    := aScan(aHeader,{|x| AllTrim(x[2])=="C7_PRECO"})  
Local _nPosTot    := aScan(aHeader,{|x| AllTrim(x[2])=="C7_TOTAL"})
Local _nPosFil    := aScan(aHeader,{|x| AllTrim(x[2])=="C7_XDESCFI"}) //#CMG20180702.n

If nTipoPed ==1 //Variavel que contem o tipo do pedido(1=Sc 2= Contrato de parceria)
	
	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	SB1->(DbGoTop())
 
	SB1->(DbSeek(xFilial("SB1")+SC1->C1_PRODUTO))
 
     aCols[n][nNumPv]   := SC1->C1_PEDRES
     aCols[n][_nPosPrc] := SB1->B1_CUSTD
     aCols[n][_nPosTot] := SB1->B1_CUSTD*SC1->C1_QUANT     
     aCols[n][_nPosFil]   := SC1->C1_XDESCFI //#CMG20180702.n
      
EndIf       

Return 