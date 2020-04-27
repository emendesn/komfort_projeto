#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA550NCI  ºAutor  ³ TOTVS              º Data ³  26/08/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Alterações na geração de NCC.   		  					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºPrograma. ³ MATA500  										   		  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MA550NCI()

Local aArea   	:= GetArea()
Local aRegAuto	:= Paramixb[1]
Local nDesconto	:= SC5->C5_DESCONT
Local nNewValor	:= 0
Local nVlrAbat	:= 0
Local nTotIt	:= 0
Local nPercen	:= 0
Local nVlrNCC	:= 0
Local nPos		:= 0
Local nPos1		:= 0

/*
nPos1 := Ascan(aRegAuto,{|x| Alltrim(x[1]) == 'E1_PREFIXO'})
If nPos1 > 0
	aRegAuto[nPos1][2] := "PED"
Endif
*/

If nDesconto > 0

	nVlrNCC := aRegAuto[Ascan(aRegAuto,{|x| x[1] == 'E1_VALOR'})][2]

	SC6->(DbSetOrder(1))
	SC6->(DbSeek(xFilial("SC6") + SC5->C5_NUM ))
	While SC6->(!Eof()) .And. SC6->C6_FILIAL+SC6->C6_NUM == xFilial("SC6")+SC5->C5_NUM
		nTotIt += SC6->C6_VALOR
		SC6->(DbSkip())
	End
	nPercen	 := Round(nDesconto/nTotIt,2)	 	
	nVlrAbat := Round((nVlrNCC*nPercen),2)		
	nNewValor:= Round(nVlrNCC-nVlrAbat,2)
	
	nPos := Ascan(aRegAuto,{|x| x[1] == 'E1_VALOR'})
	If nPos > 0
		aRegAuto[nPos][2] := nNewValor
	Endif
		
Endif

RestArea(aArea)

Return(aRegAuto)