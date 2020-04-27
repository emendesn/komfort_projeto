#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#include "rwmake.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfGerREG   บ Autor ณ Caio Garcia        บ Data ณ  11/06/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Gera n๚mero sequencial de inclusใo                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Komfort House                                              บฑฑ
ฑฑฬอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออดฑฑ
ฑฑณ Programador ณ Data   ณ Chamado ณ Motivo da Alteracao                  ณฑฑ
ฑฑฬอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออดฑฑ
ฑฑณ             ณ        ณ         ณ                                      ณฑฑ
ฑฑณ             ณ        ณ         ณ                                      ณฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function fGerREG(_nOpc)

	Local _cNum := ''
	Local _cAlias       := GetNextAlias()
	Local _cQuery := ''
	Local _lSai         := .T.
	Local _cCodSXE      := ""
	Local _cFil         := Subs(cFilAnt,1,2)+"01"
	Local _cFilBkp      := cFilAnt

	If _nOpc == 1//Pedido de Venda

		//Ajuste feito, pois os pedidos iniciaram com o n๚mero 002929
		_cQuery := " SELECT * "
		_cQuery += " FROM " + RETSQLNAME("SC5") + " SC5 "
		_cQuery += " WHERE SC5.D_E_L_E_T_ <> '*' "
		_cQuery += " AND C5_NUM NOT IN ('002929','002930','002931','002932','002933','002934','002935','002936','002937','002938','002939','002940','002941','002942','002943','002944','002946','002947','002948','002949','002950','002951','002952','002953','002954','002955','002956','002957','002958','002959','002960','002961','002963','002964','002965','002966','002967','002968','002969','002970','002971','002972','002973','002974','002975','002976','002977','002978','002979','002980','002981','002982','002983','002984','002985','002986','002987','002988','002991','002992','002993','002994','002995','002996','002997','002998','002999','003000')"
		_cQuery += " ORDER BY C5_NUM DESC "

		_cQuery := ChangeQuery(_cQuery)
		DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),(_cAlias),.F.,.T.)

		DbSelectArea(_cAlias)
		(_cAlias)->(DbGoTop()) 

		If Empty(AllTrim((_cAlias)->C5_NUM))

			_cNum = '000001'

		Else

			_cNum := StrZero((Val((_cAlias)->C5_NUM)+1),6)

			If Val(_cNum) >= 2929 .And. Val(_cNum) <= 3000

				_cNum := '003001'

			EndIf

		EndIf

		(_cAlias)->(DbCloseArea())                    


	ElseIf _nOpc == 2//Or็amento

		_cQuery := " SELECT * "
		_cQuery += " FROM " + RETSQLNAME("SUA") + " SUA "
		_cQuery += " WHERE SUA.D_E_L_E_T_ <> '*' "
		_cQuery += " ORDER BY UA_NUM DESC "

		_cQuery := ChangeQuery(_cQuery)
		DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),(_cAlias),.F.,.T.)

		DbSelectArea(_cAlias)
		(_cAlias)->(DbGoTop()) 

		_cNum := Soma1((_cAlias)->UA_NUM)

		(_cAlias)->(DbCloseArea())                    

		cFilAnt := _cFil

		_cCodSXE := GetSxeNum("SUA","UA_NUM")

		While _lSai

			If (_cCodSXE > _cNum)

				_lSai := .F.

			Else

				If (_cCodSXE == _cNum)

					_lSai := .F.

				Else

					ConfirmSx8()
					_cCodSXE := GetSxeNum("SUA","UA_NUM")

				EndIf

			EndIf

		EndDo

		cFilAnt := _cFilBkp

	EndIf

Return(_cCodSXE)