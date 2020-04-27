#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT240TOK  ºAutor  ³Vanito Rocha        º Data ³  12/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada utilizado para validar usuarios que       º±±
±±º          ³ podem movimentar o armazem 95                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT241TOK()

Local _lRet := .T.
Local i := 0
Local _nPosDel := Len(aCols[1])
Local _nPosLocal := aScan(aHeader,{|x| AllTrim(x[2]) == "D3_LOCAL"})
Local xUser:=SuperGetMv("KH_USRMVIN",.F.)

If !l241Auto //Verifica se nao e rotina automatica
	For i:=1 To Len(aCols)
		If !aCols[i, _nPosDel]
			If _nPosLocal > 0 .And. (aCols[i, _nPosLocal])=="95" .AND. !cUsername $ xUser
				If SB1->B1_TIPO <> "PA"
					MsgStop('Você não possui autorização para movimentar esse armazem, procure o gestor do PCP', "Atencao")
					_lRet := .F.
					Exit
				Endif
			Endif
		EndIf
	Next
EndIf

Return _lRet
