#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'

#DEFINE EMPRESA "Komfort House"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ KMESTX01 ºAutor  ³Mário - ERP Plus    º Data ³  12/02/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Classe com as funcionalidades para cálculo do código EAN.  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SUGESTÃO DO CÓDIGO EAN.                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
CLASS KMESTX01
	DATA cCodProdu
	DATA cCodPais
	DATA cEmpresa
	DATA cSequenc
	DATA cDigVerif
	DATA cMsgErro

	METHOD New( cCodProdu , cCodPais , cEmpresa , cSequenc , cDigVerif , cMsgErro ) CONSTRUCTOR	
	METHOD lCaldSeq()
	METHOD lCalcDV()
	METHOD lVldSeq()
	METHOD lValidDV()
	METHOD lVldDupli( cCodEAN )
ENDCLASS


METHOD New( cCodProdu , cCodPais , cEmpresa , cSequenc , cDigVerif , cMsgErro ) CLASS KMESTX01
Local aArea := GetArea()

DEFAULT cCodProdu	:= "" 
DEFAULT cCodPais	:= "789" 
DEFAULT cEmpresa	:= "98552"
DEFAULT cSequenc	:= ""
DEFAULT cDigVerif	:= ""
DEFAULT cMsgErro	:= ""

::cCodProdu		:= cCodProdu 
::cCodPais		:= cCodPais
::cEmpresa		:= cEmpresa
::cSequenc		:= cSequenc
::cDigVerif		:= cDigVerif
::cMsgErro		:= cMsgErro

RestArea(aArea)
RETURN


METHOD lCaldSeq() CLASS KMESTX01
Local aArea 	:= GetArea()
Local lRet 	:= .F.
Local cQuery	:= ""
Local lLacuna := .F.
Local nLacuna := 9998
Local nAux		:= 0
Local cTipo := SuperGetMv("KH_TPPROD",.F.,"ME")

cQuery := " SELECT "
cQuery += "   MAX(LEFT(B1_CODBAR,12)) CODATUAL "
cQuery += " FROM "
cQuery += "   "+ SB1->(RetSQLName("SB1"))
cQuery += " WHERE "
cQuery += "   B1_FILIAL = '"+ SB1->(xFILIAL("SB1")) +"' AND B1_CODBAR LIKE '"+ ALLTRIM(::cCodPais)+ALLTRIM(::cEmpresa) +"_____' "
cQuery += "   AND (ISNUMERIC(B1_CODBAR) = 1) "
If Len(cTipo) > 2
	cQuery += "   AND B1_TIPO IN " + FormatIn(cTipo,"|")
	cQuery += "   AND D_E_L_E_T_ = ' ' "
Else
	cQuery += "   AND B1_TIPO = '" + cTipo + "' 
	cQuery += "   AND D_E_L_E_T_ = ' ' "
EndIf
TcQuery cQuery Alias TSB1A New
TSB1A->(dbGoTop())
If EMPTY(TSB1A->CODATUAL)
	::cSequenc	 := "0001"
	lRet := .T.
Else
	If SUBSTR(TSB1A->CODATUAL,9,4) == "9999"
		lLacuna := .T.
	Else
		::cSequenc	:= SOMA1(SUBSTR(TSB1A->CODATUAL,9,4))
		lRet := .T.
	Endif
Endif
TSB1A->(dbCloseArea())

If lLacuna
	While nLacuna > 0
		cQuery := " SELECT "
		cQuery += "   COUNT(*) CODATUAL "
		cQuery += " FROM "
		cQuery += "   "+ SB1->(RetSQLName("SB1"))
		cQuery += " WHERE "
		cQuery += "   B1_FILIAL = '"+ SB1->(xFILIAL("SB1")) +"' AND LEFT(B1_CODBAR,12) = '"+ ALLTRIM(::cCodPais)+ALLTRIM(::cEmpresa)+STRZERO(nLacuna,4) +"' "
		If Len(cTipo) > 2
			cQuery += "   AND B1_TIPO IN " + FormatIn(cTipo,"|")
			cQuery += "   AND D_E_L_E_T_ = ' ' "
		Else
			cQuery += "   AND B1_TIPO = '" + cTipo + "' 
			cQuery += "   AND D_E_L_E_T_ = ' ' "
		EndIf
		TcQuery cQuery Alias TSB1A New
		TSB1A->(dbGoTop())
		nAux := TSB1A->CODATUAL
		TSB1A->(dbCloseArea())
	
		If nAux == 0
			::cSequenc := STRZERO(nLacuna,4)
			lRet := .T.
			EXIT
		Endif
		
		nLacuna--
	Enddo
Endif

If !lRet
	::cMsgErro := "Não foi possível o cálculo do próximo sequêncial."
Endif

CONOUT(::cSequenc)

RestArea(aArea)
RETURN lRet


METHOD lCalcDV() CLASS KMESTX01
Local aArea 	:= GetArea()
Local lRet 	:= .F.

//If ALLTRIM(::cCodPais) == "789"		//#RVC20180416.o
//	If ALLTRIM(::cEmpresa) == "98552"	//#RVC20180416.o
If ALLTRIM(::cCodPais) $ "789|790"			//#RVC20180416.n	
	If ALLTRIM(::cEmpresa) $ "98552|94870|94871|94872|94873|94874|94875|94876|94877|94878|94879"	//#RVC20180611.n
		If LEN(ALLTRIM(::cCodPais)+ALLTRIM(::cEmpresa)+ALLTRIM(::cSequenc)) == 12
			::cDigVerif := eandigito(ALLTRIM(::cCodPais)+ALLTRIM(::cEmpresa)+ALLTRIM(::cSequenc))
			::cMsgErro := "" 
			lRet := .T.
			
			CONOUT(::cDigVerif)
		Else
			::cMsgErro := "Digito Verificador não pode ser calculado por não possuir 12 caracteres."
			lRet := .F.
		Endif
	Else
//		::cMsgErro := "Digito Verificador não pode ser calculado por não ser de origem " + EMPRESA + " (" + cEmpresa + ")."									//#RVC20180416.o
//		::cMsgErro := "Digito Verificador não pode ser calculado por não ser de origem " + EMPRESA + " (" + SuperGetMV("KH_PRFXEAN",.F.,"78998552") + ")."	//#RVC20180416.n	//#RVC20180613.o	
		::cMsgErro := "Digito Verificador não pode ser calculado por não ser de origem " + EMPRESA + " ( 78998552 e 79094870 à 79094879)."	//#RVC20180613.n
		lRet := .F.
	Endif
Else
//	::cMsgErro := "Digito Verificador não pode ser calculado por não ser de origem Brasil (789)."		//#RVC20180416.o
	::cMsgErro := "Digito Verificador não pode ser calculado por não ser de origem Brasil (789|790)."	//#RVC20180416.n
	lRet := .F. 
Endif

RestArea(aArea)
RETURN lRet


METHOD lVldSeq() CLASS KMESTX01
Local aArea 	  := GetArea()
Local lRet 	  := .F.
Local cQuery	  := ""
Local nAux		  := 0
Local cProdList := ""
Local cTipo := SuperGetMv("KH_TPPROD",.F.,"ME")

If Len(ALLTRIM(::cCodPais)+ALLTRIM(::cEmpresa)+ALLTRIM(::cSequenc)) == 12
	cQuery := " SELECT "
	cQuery += "   B1_COD "
	cQuery += " FROM "
	cQuery += "   "+ SB1->(RetSQLName("SB1"))
	cQuery += " WHERE "
	cQuery += "   B1_FILIAL = '"+ SB1->(xFILIAL("SB1")) +"'"
	If Len(cTipo) > 2
		cQuery += "   AND B1_TIPO IN " + FormatIn(cTipo,"|")
	Else
		cQuery += "   AND B1_TIPO = '" + cTipo + "' 
	EndIf
	If !Empty(::cCodProdu)
		cQuery += " AND B1_COD <> '"+ ALLTRIM(::cCodProdu) +"' "
	Endif
	cQuery += "   AND LEFT(B1_CODBAR,12) = '"+ ALLTRIM(::cCodPais)+ALLTRIM(::cEmpresa)+ALLTRIM(::cSequenc) +"' "
	cQuery += "   AND D_E_L_E_T_ = ' ' "
	TcQuery cQuery Alias TSB1C New
	TSB1C->(dbGoTop())
	While !TSB1C->(EOF())
		If !Empty(cProdList)
			cProdList += " , "
		Endif
		cProdList += ALLTRIM(TSB1C->B1_COD)
		
		nAux++
		TSB1C->(dbSkip())
	Enddo
	TSB1C->(dbCloseArea()) 
	
	If nAux == 0
		lRet := .T.
		::cMsgErro := ""
	Else
		lRet := .F.
		::cMsgErro := "Código EAN existente para o(s) produto(s) "+ cProdList
	Endif
Else
	lRet := .F.
	::cMsgErro := "Código EAN diferente de 12 dígitos ( sem o DV )."
Endif

RestArea(aArea)
RETURN lRet


METHOD lValidDV() CLASS KMESTX01
Local aArea 	:= GetArea()
Local lRet 	:= .F.
Local cDVCalc	:= ""

//If ALLTRIM(::cCodPais) == "789"		//#RVC20180416.o
//	If ALLTRIM(::cEmpresa) == "98552"	//#RVC20180416.o
If ALLTRIM(::cCodPais) $ "789|790"			//#RVC20180416.n
//	If ALLTRIM(::cEmpresa) $ "98552|94870"	//#RVC20180416.n										//#RVC20180613.o
	If ALLTRIM(::cEmpresa) $ "98552|94870|94871|94872|94873|94874|94875|94876|94877|94878|94879"	//#RVC20180613.n
		If LEN(ALLTRIM(::cCodPais)+ALLTRIM(::cEmpresa)+ALLTRIM(::cSequenc)) == 12
			cDVCalc := eandigito(ALLTRIM(::cCodPais)+ALLTRIM(::cEmpresa)+ALLTRIM(::cSequenc))
			If Alltrim(cDVCalc) == Alltrim(::cDigVerif)			
				::cMsgErro := "" 
				lRet := .T.
			Else
				::cMsgErro := "Digito Verificador inválido. Informado: "+ Alltrim(::cDigVerif) +" e calculado: "+ Alltrim(cDVCalc) 
				lRet := .F.
			Endif
		Else
			::cMsgErro := "Digito Verificador inválido por não possuir 12 caracteres."
			lRet := .F.
		Endif
	Else
//		::cMsgErro := "Digito Verificador inválido por não ser de origem " + EMPRESA + " (" + cEmpresa + ")."									//#RVC20180416.o
		::cMsgErro := "Digito Verificador inválido por não ser de origem " + EMPRESA + " (" + SuperGetMV("KH_PRFXEAN",.F.,"78998552") + ")."	//#RVC20180416.n
		lRet := .F.
	Endif
Else
//	::cMsgErro := "Digito Verificador inválido por não ser de origem Brasil (789)."		//#RVC20180416.o
	::cMsgErro := "Digito Verificador inválido por não ser de origem Brasil (789|790)."	//#RVC20180416.n
	lRet := .F. 
Endif

RestArea(aArea)
RETURN lRet


METHOD lVldDupli( cCodEAN ) CLASS KMESTX01
Local aArea 	  := GetArea()
Local lRet 	  := .F.
Local cQuery	  := ""
Local nAux		  := 0
Local cProdList := ""
Local cTipo := SuperGetMv("KH_TPPROD",.F.,"ME")

DEFAULT cCodEAN := ALLTRIM(::cCodPais)+ALLTRIM(::cEmpresa)+ALLTRIM(::cSequenc)+ALLTRIM(::cDigVerif)

cQuery := " SELECT "
cQuery += "   B1_COD "
cQuery += " FROM "
cQuery += "   "+ SB1->(RetSQLName("SB1"))
cQuery += " WHERE "
//cQuery += "   B1_FILIAL = '"+ SB1->(xFILIAL("SB1")) +"' AND B1_TIPO = 'PA' "	//#RVC20180416.o
//#RVC20180416.bn
cQuery += "   B1_FILIAL = '"+ SB1->(xFILIAL("SB1")) +"'	"	
If Len(cTipo) > 2
	cQuery += "   AND B1_TIPO IN " + FormatIn(cTipo,"|")
Else
	cQuery += "   AND B1_TIPO = '" + cTipo + "' 
EndIf
//#RVC20180416.en
If !Empty(::cCodProdu)
	cQuery += " AND B1_COD <> '"+ ALLTRIM(::cCodProdu) +"' "
Endif
cQuery += "   AND B1_CODBAR = '"+ cCodEAN +"' AND D_E_L_E_T_ = ' ' "
TcQuery cQuery Alias TSB1E New
TSB1E->(dbGoTop())
While !TSB1E->(EOF())
	If !Empty(cProdList)
		cProdList += " , "
	Endif
	cProdList += ALLTRIM(TSB1E->B1_COD)
	
	nAux++
	TSB1E->(dbSkip())
Enddo
TSB1E->(dbCloseArea()) 

If nAux == 0
	lRet := .T.
	::cMsgErro := ""
Else
	lRet := .F.
	::cMsgErro := "Código EAN existente para o(s) produto(s) "+ cProdList
Endif

RestArea(aArea)
RETURN lRet