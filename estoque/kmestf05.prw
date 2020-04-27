#Include "rwmake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "TbiConn.ch"
#include 'parmtype.ch'

User Function KMESTF05()

	Local _cPerg   := "KMESTF05"
	Local _cEnd    := ""

	_cPerg    := PadR(_cPerg, Len(SX1->X1_GRUPO))
	fAjustSX1(_cPerg)

	If Pergunte(_cPerg,.T.)

		_cQuery := " SELECT * "
		_cQuery += " FROM " + RETSQLNAME("SBE") + " SBE (NOLOCK) "
		_cQuery += " WHERE SBE.D_E_L_E_T_ <> '*' "
		_cQuery += " AND BE_LOCALIZ BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
		_cQuery += " AND BE_LOCAL BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
		_cQuery += " AND BE_FILIAL = '"+xFilial("SBE")+"' "

		_cQuery := ChangeQuery(_cQuery)

		_cAlias   := GetNextAlias()

		DbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, _cQuery ), _cAlias, .T., .F. )

		DbSelectArea(_cAlias)
		(_cAlias)->(DbGoTop())

		If !Empty(AllTrim((_cAlias)->BE_LOCALIZ))

			cModelo:= "ZEBRA"
			cPorta := "LPT1"
			MSCBPRINTER(cModelo,cPorta,,110,.F.,,,,,,)
			MSCBLOADGRF("LOGOZ.GRF")
			MSCBCHKSTATUS(.F.)

			While (_cAlias)->(!Eof())

				MSCBBEGIN(1,4)

				MSCBSAY(065,010, AllTrim((_cAlias)->BE_LOCALIZ),"R","0","280,200")
				MSCBSAYBAR(30,25,AllTrim((_cAlias)->BE_LOCALIZ),"R","MB07",40,.F.,.F.,.T.,,6,5)

				MSCBEND()

				(_cAlias)->(DbSkip())

			EndDo

		Else

			Alert("Não foram encontradas etiquetas nos parâmetros informados")

		EndIf

		MSCBCLOSEPRINTER()

	Else

		Alert("Cancelado pelo usuário")

	EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ AjustaSX1³ Autor ³ Caio Garcia                   ³ Data ³  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Verifica as perguntas inclu¡ndo-as caso não existam        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fAjustSX1(_cPerg)

	Local _aArea	:= GetArea()
	Local aRegs		:= {}

	dbSelectArea("SX1")
	dbSetOrder(1)

	_cPerg := padr(_cPerg,len(SX1->X1_GRUPO))

	Aadd(aRegs,{_cPerg,"01","Endereço De...","MV_CH1" ,"C",15,0,"G","MV_PAR01","SBE","","","","",""})
	Aadd(aRegs,{_cPerg,"02","Endereço Até..","MV_CH2" ,"C",15,0,"G","MV_PAR02","SBE","","","","",""})
	Aadd(aRegs,{_cPerg,"03","Local De..."  ,"MV_CH3" ,"C",2,0,"G","MV_PAR03","NNR","","","","",""})
	Aadd(aRegs,{_cPerg,"04","Local Até.."  ,"MV_CH4" ,"C",2,0,"G","MV_PAR04","NNR","","","","",""})

	DbSelectArea("SX1")
	DbSetOrder(1)

	For _i := 1 To Len(aRegs)

		If  !DbSeek(aRegs[_i,1]+aRegs[_i,2])
			RecLock("SX1",.T.)
			Replace X1_GRUPO   with aRegs[_i,01]
			Replace X1_ORDEM   with aRegs[_i,02]
			Replace X1_PERGUNT with aRegs[_i,03]
			Replace X1_VARIAVL with aRegs[_i,04]
			Replace X1_TIPO    with aRegs[_i,05]
			Replace X1_TAMANHO with aRegs[_i,06]
			Replace X1_PRESEL  with aRegs[_i,07]
			Replace X1_GSC     with aRegs[_i,08]
			Replace X1_VAR01   with aRegs[_i,09]
			Replace X1_F3      with aRegs[_i,10]
			Replace X1_DEF01   with aRegs[_i,11]
			Replace X1_DEF02   with aRegs[_i,12]
			Replace X1_DEF03   with aRegs[_i,13]
			Replace X1_DEF04   with aRegs[_i,14]
			Replace X1_DEF05   with aRegs[_i,15]
			MsUnlock()
		EndIf

	Next _i

	RestArea(_aArea)

Return