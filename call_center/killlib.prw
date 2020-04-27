#include "totvs.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³KILLLIB   ºAutor  ³ Cristiam Rossi     º Data ³  25/08/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exclusão da Liberação do PV - forçada, pois está dando     º±±
±±º          ³ erro no padrão e não temos ideia do que seja               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ KomfortHouse / Global                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function KillLib( cPedido )

/*  Retirado e corrigido o ERP padrão - Deo 21/12/2017 - k008

Local aArea    := getArea()
Local aAreaSC5 := SC5->( getArea() )
Local aAreaSC6 := SC6->( getArea() )
Local aAreaSC9 := SC9->( getArea() )
Local aAreaSB2 := SB2->( getArea() )
Local aAreaSF4 := SF4->( getArea() )
Local aDadosB2 := {}
Local aDadosC9 := {}
Local lERRO    := .F.
Local nI

	if empty( cPedido )
		return .F.
	endif

	SC5->( dbSetOrder(1) )

	if ! SC5->( dbSeek( xFilial("SC5") + cPedido ) )
		SC5->( restArea( aAreaSC5 ) )
		restArea( aArea )
		return .F.
	endif

	SB2->( dbSetOrder(1) )
	SC6->( dbSetOrder(1) )
	SF4->( dbSetOrder(1) )

	SC9->( dbSetOrder(1) )
	SC9->( dbSeek( xFilial("SC9") + SC5->C5_NUM ) )
	while ! SC9->( EOF() ) .and. SC9->(C9_FILIAL+C9_PEDIDO) == xFilial("SC9") + SC5->C5_NUM
		if ! empty( SC9->C9_NFISCAL )
			lERRO := .T.
			exit
		endif

		if SC6->( dbSeek( xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM ) ) .and. SF4->( dbSeek( xFilial("SF4")+SC6->C6_TES ) ) .and. SF4->F4_ESTOQUE == "S"
			if SC9->C9_BLEST $ "  .10"
				if SB2->( dbSeek( xFilial("SB2") + SC9->C9_PRODUTO + SC9->C9_LOCAL) )
					aadd( aDadosB2, { SB2->( RECNO() ), SC9->C9_QTDLIB } )
				endif
			endif
		endif

		aadd( aDadosC9, SC9->( RECNO() ) )

		SC9->( dbSkip() )
	end

	if ! lERRO
		lErro := .T.                                                                                     
		begin Transaction

		for nI := 1 to len( aDadosB2 )
			SB2->( dbGoto( aDadosB2[nI][1] ) )
			recLock( "SB2", .F. )
			SB2->B2_QPEDVEN -= aDadosB2[nI][2]
			SB2->B2_QPEDVE2 -= ConvUM(SB2->B2_COD, aDadosB2[nI][2], 0, 2)
			msUnlock()
		next

		for nI := 1 to len( aDadosC9 )
			Sc9->( dbGoto( aDadosC9[nI] ) )
			recLock( "SC9", .F. )
			dbDelete()
			msUnlock()
		next

		lErro := .F.
		end Transaction
	endif

	SF4->( restArea( aAreaSF4 ) )
	SB2->( restArea( aAreaSB2 ) )
	SC9->( restArea( aAreaSC9 ) )
	SC6->( restArea( aAreaSC6 ) )
	SC5->( restArea( aAreaSC5 ) )
	restArea( aArea )
	
	*/
return .T.
