#include "totvs.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PPPV      ºAutor  ³ Cristiam Rossi     º Data ³  03/23/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ rotina auxiliar p/ abater Consumo Médio de pedid de venda  º±±
±±º          ³ eliminado por resíduo                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GLOBAL / KOMFORTHOUSE                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PPpv( cNUMpv )
Local aArea    := getArea()
Local aAreaSC5 := SC5->( getArea() )
Local aAreaSC6 := SC6->( getArea() )
Local cMES     := StrZero( Month( dDatabase ), 2 )
Local nQtd
Local aItens   := {}
Local nI
Default cNUMpv := SC5->C5_NUM

	if cNUMpv != SC5->C5_NUM
		SC5->( dbSetOrder(1) )
		if SC5->( dbSeek( xFilial("SC5") + cNUMpv ) )
			return .F.
		endif
	endif

	cMES := StrZero( Month( SC5->C5_EMISSAO ), 2 )

	SB1->( dbSetOrder(1) )	// B1_FILIAL+B1_COD
	SC6->( dbSetOrder(1) )			// atualizando o campo C6_XQTD
	SC6->( dbSeek( xFilial("SC6") + SC5->C5_NUM, .T. ) )
	while ! SC6->( EOF() ) .and. SC5->(C5_FILIAL+C5_NUM) == SC6->(C6_FILIAL+C6_NUM)
		if SB1->( dbSeek( xFilial("SB1")+SC6->C6_PRODUTO ) ) .and. SB1->B1_TIPO == "ME"
			nQtd   := SC6->C6_QTDVEN
			nQtd   -= SC6->C6_XQTD		// abatendo Qtd já registrada no Consumo Médio

			if ! empty(SC6->C6_BLQ)
				nQtd := SC6->C6_XQTD
				nQtd *= -1
				aadd( aItens, { SC6->C6_PRODUTO, nQtd } )
			endif
		endif

		SC6->( dbSkip() )
	end

	SB3->( dbSetOrder(1) )	// B3_FILIAL+B3_COD
	for nI := 1 to len(aItens)
		if aItens[nI][2] != 0
			if ! SB3->( dbSeek( xFilial("SB3") + aItens[nI][1] ) )
				recLock("SB3",.T.)
				SB3->B3_FILIAL := xFilial("SB3")
				SB3->B3_COD    := aItens[nI][1]
				SB3->B3_MES    := dDatabase
			else
				recLock("SB3",.F.)
			endif
			&("SB3->B3_Q"+cMES) := &("SB3->B3_Q"+cMES) + aItens[nI][2]
			msUnlock()
		endif
	next

return .T.
