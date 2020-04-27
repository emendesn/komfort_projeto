#INCLUDE "totvs.ch"
#INCLUDE "protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A650ALTD4 � Autor � Vanito Rocha     	 � Data �  12/06/19   ���
�������������������������������������������������������������������������͹��
���Descricao � Trata o empenho na abertura da Ordem de produ��o na 		�͹��
���Rotina MATA650 porque o sistema abre e empenha somente na primeira   �͹��
���unidade de medida													�͹��
�������������������������������������������������������������������������͹��
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function A650ALTD4()

Local aArea		:= GetArea()
Local aAreaSD4	:= SD4->(GetArea())
Local cQuery	:= ""
Local nPosLocal	:= aScan(aHeader,{|x| AllTrim(x[2])=="D4_LOCAL"})
Local nPosProdu	:= aScan(aHeader,{|x| AllTrim(x[2])=="G1_COMP"})
Local nPosLocLz	:= aScan(aHeader,{|x| AllTrim(x[2])=="DC_LOCALIZ"})
Local nPosQtde	:= aScan(aHeader,{|x| AllTrim(x[2])=="D4_QUANT"})
Local nPosQtd2  := aScan(aHeader,{|x| AllTrim(x[2])=="D4_QTSEGUM"})
Local nPosLote	:= aScan(aHeader,{|x| AllTrim(x[2])=="D4_LOTECTL"})
Local nPosNLte	:= aScan(aHeader,{|x| AllTrim(x[2])=="D4_NUMLOTE"})
Local nPosTRT	:= aScan(aHeader,{|x| AllTrim(x[2])=="G1_TRT"})
Local nPosLoc	:= aScan(aHeader,{|x| AllTrim(x[2])=="D4_LOCAL"})
Local nX		:= 0
Local aColsNew  := {}
Local lxUsa2um:=SuperGetMv("KH_USA2UM",,.T.)


aColsDele := {}

If lxUsa2um
	
	For nX := 1 To Len(aCols)
		
		If nx > 1 .And. aTail(aColsNew)[nPosProdu]+aTail(aColsNew)[nPosTRT]+aTail(aColsNew)[nPosLoc] == aCols[nX,nPosProdu]+aCols[nX,nPosTRT]+aCols[nX,nPosLoc]
			aTail(aColsNew)[nPosQtde] += aCols[nX,nPosQtde]
		Else
			AADD(aColsNew,aClone(aCols[nX]))
			
		EndIf
		
		
		If aTail(aColsNew)[nPosQtde] == 0
			aTail(aColsNew)[Len(aHeader)+1] := .T.
		EndIf
	Next nX
	
	aCols := {}
	nX := 0
	For nX := 1 To Len(aColsNew)
		
		AADD(aCols, aClone(aColsNew[NX]))
		
		If aTail(aCols)[nPosQtd2] > 0
			
			aTail(aCols)[nPosQtde]:=aTail(aCols)[nPosQtd2]
			
		Endif
	Next nX
	
Endif
RestArea(aArea)
RestArea(aAreaSD4)
Return