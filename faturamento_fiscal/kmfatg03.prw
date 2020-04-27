#include 'protheus.ch'
#include 'parmtype.ch'

user function KMFATG03(_cCod, _cLoja)
	Local _cRet:=''

	IF _cCod == '000001' .And. _cLoja == '01'

			DBSelectarea("SM0")
			SM0-> (DbSetorder(1))
			SM0-> (DbSeek(cEmpant + cFilant))
			_cRet:= Alltrim(SM0->M0_FILIAL) +' - ' + cFilant


		ElseIf _cCod == '000001' 

			DBSelectarea("SA1")	
			SA1->(DbSetorder(1))
			SA1->(DbGotop())
			SA1->(DbSeek(xFilial("SA1") + _cCod + _cLoja))

			DBSelectarea("SM0")
			SM0-> (DbSetorder(1))
			SM0-> (DbSeek(cEmpant + SA1->A1_FILTRF))
			_cRet:= Alltrim(SM0->M0_FILIAL) +' - ' + SA1->A1_FILTRF

			

	EndIf	

return _cRet