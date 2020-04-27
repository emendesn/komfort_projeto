#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#include 'FWMVCDEF.CH'
#Include "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MTA440C9 ³ Autor ³ Eduardo Alberti       ³ Data ³16/Mar/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³ Central Recursos ³Contato ³     ealberti@totvs.com.br      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de Entrada Executado Apos a Geracao Do SC9 No PV.    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Projeto   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Bops ³ Manutencao Efetuada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³      ³                                        ³±±
±±³              ³  /  /  ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MTA440C9()

	Local	_aArea	:= GetArea()
	Local	_aArSC5	:= SC5->(GetArea())
	Local	_aArSC6	:= SC6->(GetArea())

	If cEmpAnt $ SuperGetMV("KH_MT440C9",.T.,"01|02")
		If SC6->( FieldPos("C6_XPRTBKP") > 0 .And. FieldPos("C6_XPDSBKP") > 0 .And.FieldPos("C6_XVDSBKP") > 0)
			// Na Confirmação do Ped De Venda Com Liberacao Automatica No Parametro <F12>
			If Type("aCols") == "A" .And. SC6->C6_XPRTBKP == 0

				_aVetCont := {}

				Aadd(_aVetCont,{"C6_XPRTBKP","C6_PRUNIT"	})
				Aadd(_aVetCont,{"C6_XPDSBKP","C6_DESCONT"	})
				Aadd(_aVetCont,{"C6_XVDSBKP","C6_VALDESC"	})
				Aadd(_aVetCont,{"C6_DESCONT","0"			})
				Aadd(_aVetCont,{"C6_VALDESC","0"			})
				Aadd(_aVetCont,{"C6_PRUNIT" ,"C6_PRCVEN"	})

				For i := 1 To Len(_aVetCont)

					_cQuery := " UPDATE " + RetSqlName("SC6") + " "
					_cQuery += " SET " + _aVetCont[i,1] + " = " + _aVetCont[i,2] + " "
					_cQuery += " WHERE C6_FILIAL = '" + xFilial("SC6") + "' "
					_cQuery += " AND C6_NUM = '" + SC9->C9_PEDIDO + "' "
					_cQuery += " AND C6_ITEM = '" + SC9->C9_ITEM + "' "

					TcSqlExec(_cQuery)

				Next i
				M->C5_XSTATUS	:= "4"
			Else			
				// Forca Posicionamento
				DbSelectArea("SC5")
				DbSetOrder(1)
				MsSeek(xFilial("SC5") + SC9->C9_PEDIDO )

				/*
				aAdd(_aLeg, {"BR_PRETO"		,"Retenção por Saldo"				})	// C5_XSTATUS == '2'
				aAdd(_aLeg, {"BR_BRANCO"	,"Retenção por definição comercial"	})	// C5_XSTATUS == '3'
				aAdd(_aLeg, {"BR_AZUL"		,"Regra de Negocio"					})	// C5_BLQ == '1'
				aAdd(_aLeg, {"BR_AMARELO"	,"Pedido em Processo de Faturamento"}) 	// C5_XSTATUS == '4'
				*/

				If SC5->C5_XSTATUS	<> "4"

					DbSelectArea("SC6")
					DbSetOrder(1)	//C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
					MsSeek(xFilial("SC6") + SC9->C9_PEDIDO )

					_cChave := xFilial("SC6") + SC9->C9_PEDIDO

					While !Eof() .And. ((SC6->C6_FILIAL + SC6->C6_NUM) == _cChave) .And. SC6->C6_XPRTBKP == 0

						RecLock("SC6",.F.)
						SC6->C6_XPRTBKP	:= SC6->C6_PRUNIT
						SC6->C6_XPDSBKP	:= SC6->C6_DESCONT
						SC6->C6_XVDSBKP	:= SC6->C6_VALDESC
						SC6->C6_DESCONT	:= 0
						SC6->C6_VALDESC	:= 0
						SC6->C6_PRUNIT	:= SC6->C6_PRCVEN
						SC6->( MsUnLock() )

						DbSelectArea("SC6")
						SC6->( DbSkip())
					EndDo

					RecLock("SC5",.F.)

					SC5->C5_XSTATUS	:= "4"

					SC5->( MsUnLock() )

				EndIf
			EndIf
		Else
			ConOut("MTA440C9 - KH_MT440C9 - Os campos C6_XPRTBKP, C6_XPDSBKP e C6_XVDSBKP nao existem")
		EndIf
	EndIf

	RestArea(_aArSC6)
	RestArea(_aArSC5)
	RestArea(_aArea)
Return()