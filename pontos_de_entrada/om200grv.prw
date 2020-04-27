#INCLUDE "Protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³OM200GRV  ³AUTOR: ³Caio Garcia            ³DATA: ³08/10/18  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ Estoque/Custos - Komfort House                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€ŽO INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  PROGRAMADOR  ³  DATA  ³ ALTERACAO OCORRIDA 				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³               |  /  /  |                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function OM200GRV()

Local _c01SAC := ''
Local _cTroca := ''
Local _cTpTro := ''

_c01SAC := GetAdvFVal("SC5","C5_01SAC",xFilial("SC5")+TRBPED->PED_PEDIDO,1)

If !Empty(AllTrim(_c01SAC))
	
	DbSelectArea("ZK0")
	ZK0->(DbSetOrder(5))
	ZK0->(DbGoTop())
	
	If ZK0->(DbSeek(xFilial("ZK0")+_c01SAC))
		_cTroca := "SIM"
		
		If ZK0->ZK0_OPCTP == '1'
			_cTpTro := 'Troca'
		ElseIf ZK0->ZK0_OPCTP == '2'
			_cTpTro := 'Cancelamento'
		ElseIf ZK0->ZK0_OPCTP == "3"
			_cTpTro := 'Conserto'
		ElseIf ZK0->ZK0_OPCTP == "4"
			_cTpTro := 'TJ/PROCON'
		ElseIf ZK0->ZK0_OPCTP == "5"
			_cTpTro := 'Emprestimo'
		Else
			_cTpTro := ''       
		EndIf	
		
	Else
		_cTroca := "NÃO"
	EndIf                    
	
Else
	
	_cTroca := 'NÃO'
	
EndIf          

TRBPED->PED_ENTREG  := GetAdvFVal("SC6","C6_ENTREG",xFilial("SC6")+TRBPED->PED_PEDIDO+TRBPED->PED_ITEM,1)
TRBPED->PED_REGCON  := GetAdvFVal("SC5","C5_XREGCON",xFilial("SC5")+TRBPED->PED_PEDIDO,1)
TRBPED->PED_TROCA   := _cTroca
TRBPED->PED_OPCTP   := _cTpTro

MsUnlock()

Return Nil
