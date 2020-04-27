#include "totvs.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MS520DEL  ºAutor  ³ Cristiam Rossi     º Data ³  23/03/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE localizado na função MaDelNfs e é executado antes da    º±±
±±º          ³ exclusão do registro da tabela SF2                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GLOBAL / KOMFORTHOUSE                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MS520DEL()
Local aArea    := getArea()
Local aAreaSD2 := SD2->( getArea() )

	SF4->( dbSetOrder(1) )
	SB1->( dbSetOrder(1) )
	SD2->( dbSetOrder(1) )
	SD2->( dbSeek( SF2->( F2_FILIAL + F2_DOC + F2_SERIE ), .T. ) )
	while ! SD2->( EOF() ) .and. SF2->( F2_FILIAL + F2_DOC + F2_SERIE ) == SD2->( D2_FILIAL + D2_DOC + D2_SERIE )

		if SB1->( dbSeek( xFilial("SB1")+SD2->D2_COD ) ) .and. SB1->B1_TIPO == "ME"
			if SF4->( dbSeek( xFilial("SF4")+SD2->D2_TES ) ) .and. SF4->F4_ESTOQUE == "S"

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Estorno das Demandas                                           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If Empty(SD2->D2_REMITO) .Or. SD2->D2_TPDCENV $ "1A"
					If !(SD2->D2_TIPO $ "DBCIP")
						dbSelectArea("SB3")
						dbSetOrder(1)
						If ( MsSeek(xFilial("SB3")+SD2->D2_COD) )
							RecLock("SB3")
						Else
							RecLock("SB3",.T.)
							SB3->B3_FILIAL := xFilial("SB3")
							SB3->B3_COD    := SD2->D2_COD
						EndIf
						FieldPut(FieldPos("B3_Q"+StrZero(Month(SD2->D2_EMISSAO),2)),FieldGet(FieldPos("B3_Q"+StrZero(Month(SD2->D2_EMISSAO),2))) + SD2->D2_QUANT)
						SB3->B3_MES := SD2->D2_EMISSAO
						MsUnLock()
					EndIf
				Endif

			Endif
		Endif

		SD2->( dbSkip() )
	end
	SD2->( restArea( aAreaSD2 ) )
	restArea( aArea )
return nil
