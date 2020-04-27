#include 'protheus.ch'
#include 'parmtype.ch'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ KMFATF03 º Autor ³ Caio Garcia        º Data ³  08/11/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ajusta o MSFIL do pedido de venda                          º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function KMFATF03()

	Local _cPerg   := "KMFATF03" 
	Local _cQuery  := ""
	Local _cAlias  := ""
	Local _cFilOrc := "" 	
	_cPerg    := PadR(_cPerg, Len(SX1->X1_GRUPO))
	fAjustSX1(_cPerg)
	Pergunte(_cPerg,.F.)

	If Pergunte(_cPerg,.T.)

		MV_PAR01 := AllTrim(MV_PAR01)	

		_cQuery := "SELECT * "
		_cQuery += " FROM " + RETSQLNAME("SUA") + " SUA (NOLOCK) "
		_cQuery += " WHERE SUA.D_E_L_E_T_ <> '*' "
		_cQuery += " AND UA_NUMSC5 = '"+AllTrim(MV_PAR01)+"' "
		_cQuery := ChangeQuery(_cQuery)

		_cAlias   := GetNextAlias()

		DbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, _cQuery ), _cAlias, .T., .F. )

		DbSelectArea(_cAlias)
		(_cAlias)->(DbGoTop())	

		If Empty(AllTrim((_cAlias)->UA_FILIAL))

			Alert("Orçamento não encontrado, a rotina não será executada!")

		Else

			_cFilOrc := AllTrim((_cAlias)->UA_FILIAL)

			DbSelectArea("SC6")
			SC6->(DbSetOrder(1))
			SC6->(DbSeek(xFilial("SC6")+MV_PAR01))

			While SC6->(!Eof()) .And. SC6->C6_NUM == MV_PAR01

				If SC6->C6_MSFIL <> _cFilOrc

					RecLock("SC6",.F.)
					SC6->C6_MSFIL := _cFilOrc
					SC6->(MsUnLock())

				EndIf

				SC6->(DbSkip())

			EndDo

			Alert("Pedido atualizado com sucesso!")

		EndIf

	EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ AjustaSX1³ Autor ³ Bruno Gomes           ³ Data ³  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Verifica as perguntas inclu¡ndo-as caso não existam        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fAjustSX1(_cPerg)

	Local _aArea	:= GetArea()
	Local aRegs		:= {}

	dbSelectArea("SX1")
	dbSetOrder(1)

	_cPerg := padr(_cPerg,len(SX1->X1_GRUPO))

	Aadd(aRegs,{_cPerg,"01","Pedido","MV_CH1"   ,"C",6,0,"G","MV_PAR01","SC5","","","","",""})

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