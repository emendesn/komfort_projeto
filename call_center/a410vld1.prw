#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A410VLD1  ºAutor  ³Microsiga           º Data ³  20/02/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Valida o preenchimento do campo conforme a regra.           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Validacao de Campo: UB_FILSAI (Modo de Edicao)              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A410VLD1()

Local aArea 	:= GetArea()
Local cCampo 	:= ReadVar()
Local cConteudo := &(ReadVar())
Local nPosProd	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_PRODUTO"})
Local nPosBloq	:= GdFieldPos("C6_BLQ")
Local nLinha	:= n

SB1->(DbSetOrder(1))
SB1->(DbSeek(xFilial("SB1") + aCols[nLinha,nPosProd] ))

SB4->(DbSetOrder(1))
SB4->(DbSeek(xFilial("SB4") + SB1->B1_01PRODP ))

If ALTERA
	
	If !aTail( aCols[nLinha] )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄH¿
		//³Valida o status do pedido para realizar os agendamentos     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄHÙ
		If M->C5_PEDPEND == "1" .Or. M->C5_PEDPEND == "2"  .Or. M->C5_PEDPEND == "5"
			
			If Alltrim(cCampo) == "M->C6_DTAGEND"
				MsgInfo("Não é possivel agendar a entrega para pedidos em Aguardar!","Atenção")
				Return(.F.)
				
			ElseIf Alltrim(cCampo) == "M->C6_DTMONTA"
				MsgInfo("Não é possivel agendar a montagem para pedidos em Aguardar!","Atenção")
				Return(.F.)
				
			Endif
			
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Valida se o produto permite montagem.                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Alltrim(cCampo) == "M->C6_DTMONTA" .And. SB4->B4_01VLMON==0
			MsgInfo("Este produto não permite montagem.","Atenção")
			Return(.F.)
		Endif
		
		If Alltrim(cCampo) == "M->C6_DTMONTA" .And. Alltrim(aCols[nLinha][nPosBloq])=="R"
			MsgInfo("Pedido Cancelado! Montagem não permitida.","Atenção")
			Return(.F.)
		Endif
				
		If Alltrim(cCampo) == "M->C6_DTAGEND" .And. Alltrim(aCols[nLinha][nPosBloq])=="R"
			MsgInfo("Pedido Cancelado! Agendamento não permitido.","Atenção")
			Return(.F.)
		Endif
				          		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Preenche os campos de cabecalho.                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Alltrim(cCampo)=="M->C6_DTAGEND"
			M->C5_DTAGEND := cConteudo
		Else
			M->C5_DTMONTA := cConteudo
		Endif
		
	Endif
	
Endif

RestArea(aArea)

Return(.T.)