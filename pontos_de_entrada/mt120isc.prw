#INCLUDE "PROTHEUS.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT120ISC � Autor � Ellen Santiago       � Data � 10/04/2018���
�������������������������������������������������������������������������͹��
���Descri��o � P.E repons�vel por trazer as informa��es das solicita��es  ���
���          � de Compra para o aCols do Pedido de Compras.               ���
�������������������������������������������������������������������������͹��
���Uso       � KomfortHouse                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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