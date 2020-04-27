#include 'protheus.ch'
#include 'parmtype.ch'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ KMSACA11บ Autor ณ MUrilo Zoratti     บ Data ณ  11/12/18    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบcadastro de comissใo vendedores                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 															  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

user function KMSACA15()
	
	Local cAlias := "ZK5"
	Local cTitulo:= "Cadastro Regiใo - Visitas"
	Local cVldExc:= "U_KMSACAEX()"
	Local cVldAlt:= "U_KMSACAIN()"

	AxCadastro(cAlias,cTitulo,cVldExc,cVldAlt)

Return

/*/
+------------------------------------------------------------------------------
| Descri็ใo     | Fun็ใo de valida็ใo de altera็ใo/ inclusใo para a AXCADASTRO()  
  Autor: Wellington Raul Pinto
  Data: 03/01/2019    
+------------------------------------------------------------------------------
/*/

User Function KMSACAIN()

	Local lRet := .F.
	local cUserEst := SUPERGETMV("KH_AGETEC", .T., "000779|000478|000695")

	if ALTERA
		if __cUserid $ cUserEst
			lRet := .T.
		else
			MsgInfo("Voc๊ nใo possuํ permissใo para executar estแ fun็ใo!")
		endif
	elseif INCLUI
		if __cUserid $ cUserEst
			lRet := .T.
		else
			MsgInfo("Voc๊ nใo possuํ permissใo para executar estแ fun็ใo!")
		endif
	EndIf

Return lRet

/*/
+------------------------------------------------------------------------------
 Descri็ใo     | Fun็ใo de valida็ใo de Exclusใo para a AXCADASTRO()  
 Autor: Wellington Raul Pinto
 Data: 03/01/2019  
+------------------------------------------------------------------------------
/*/

User Function KMSACAEX()

	Local lRet      := .F.
	local cUserEst := SUPERGETMV("KH_AGETEC", .T., "000779|000478|000695")
	
	if __cUserid $ cUserEst
		lRet := .T.
	else
		MsgInfo("Voc๊ nใo possuํ permissใo para executar estแ fun็ใo!!")
	endif

Return lRet