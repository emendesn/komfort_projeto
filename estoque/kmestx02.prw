#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ KMESTX02 บAutor  ณRafael Cruz         บ Data ณ  03/02/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Nova Funcionalidade para cแlculo do c๓digo EAN.  		  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SUGESTรO DO CำDIGO EAN.                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function KMESTX02(cCBarAtu)

Local cCBarAtu
Local cQuery	:= ""
Local nCBarNew	:= 0
Local nCBarTmp	:= 0
Local nLacuna 	:= 1
Local nA		:= 0
Local nB		:= 0
Local aArea 	:= GetArea()
Local aTipo 	:= SuperGetMv("KH_TPPROD",.F.,"ME")
Local aPfxGS1   := {}
Local lRet 		:= .F.
Local lProcessa := .F.

aPfxGS1 := STRTOKARR(SuperGetMV("KH_PRFXEAN",.F.,"78998552"),"|")

For nA := 1 to Len(aPfxGS1)
	IF SUBSTR(cCBarAtu,1,8) <> aPfxGS1[nA]
		lProcessa := .T.
	Else
		If U_LacunaX(cCBarAtu)
			If Len(alltrim(cCBarAtu)) >= 12
				RecLock("SB1",.F.) // .F. = ALTERA
					SB1->B1_CODBAR :=  LEFT(trim(cCBarAtu),12) + eandigito(Left(trim(cCBarAtu),12))
				MsUnlock()
				lRet 		:= .T.
				lProcessa	:= .F.
				EXIT
			Else
				lProcessa := .T.
				Exit
			EndIf
		Else
			lProcessa := .T.
			Exit
		EndIf
	Endif
Next
If lProcessa
	For nB := 1 to Len(aPfxGS1)
		cQuery := " SELECT "
		cQuery += "   MAX(LEFT(B1_CODBAR,12)) CODATUAL "
		cQuery += " FROM "
		cQuery += "   "+ SB1->(RetSQLName("SB1"))
		cQuery += " WHERE "
		cQuery += "   B1_FILIAL = '"+ SB1->(xFILIAL("SB1")) +"' "
		cQuery += "   AND B1_TIPO IN " + FormatIn(aTipo,"|")
		cQuery += "   AND ISNUMERIC(B1_CODBAR) = '1' "
		cQuery += "   AND B1_CODBAR LIKE '%"+ aPfxGS1[nB] +"_____' "
		cQuery += "   AND D_E_L_E_T_ = ' ' "
		TcQuery cQuery Alias TSB1A New
		TSB1A->(dbGoTop())
		nCBarTmp := TSB1A->CODATUAL
		TSB1A->(dbCloseArea())
		If Empty(nCBarTmp)  
			nCBarNew	:= aPfxGS1[nB] + STRZERO(nLacuna,4)
			RecLock("SB1",.F.) // .F. = ALTERA
				SB1->B1_CODBAR :=  trim(nCBarNew) + eandigito(trim(nCBarNew))
			MsUnlock()
			lRet 	:= .T.
			EXIT
		Else
			If SUBSTR(nCBarTmp,9,4) == "9999"
				LOOP
			Else
				If U_LacunaX(nCBarTmp)
					nCBarNew := aPfxGS1[nB] + SOMA1(SUBSTR(nCBarTmp,9,4),,.T.)
					RecLock("SB1",.F.) // .F. = ALTERA
						SB1->B1_CODBAR :=  trim(nCBarNew) + eandigito(trim(nCBarNew))
					MsUnlock()
					lRet 	:= .T.
					EXIT
				Else
					lRet := .F.
					EXIT
				EndIf
			Endif
		EndIf
	Next
EndIf
If !lRet
	Conout("Nใo foi possํvel gerar o c๓digo de barras")
Endif

RestArea(aArea)
Return

User Function LacunaX(cCodBar)

Local cCodBar
Local cLacunaX	:= SUBSTR(cCodBar,9,4)
Local cElem		:= ""
Local nY		:= 0
Local cMatriz	:= 'A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z'
Local lRet		:= .T.

For nY := 1 to Len(cLacunaX)
	cElem := Substr(cLacunaX,nY,1)
	If (Upper(cElem) $ cMatriz)
		lRet := .F.
		Exit
	EndIf
Next

Return lRet