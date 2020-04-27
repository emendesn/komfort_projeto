#include 'protheus.ch'
#include 'parmtype.ch'

/*
-> Autor: Wellington  Raul Pinto
-> Data: 09/08/2018
-> Valida campos SA1_tel e SA1_tel2 não permitindo duplicar o numero 
*/

User Function FVLDTEL(_cA1_TEL, _cA1_TEL2)

	Local _lRET := .T.

	If (!empty(AllTrim(_cA1_TEL)))

		If !( AllTrim(_cA1_TEL)<> AllTrim(_cA1_TEL2))

			_lRET := .F.

			MsgStop("Não é Permitido Informar o Mesmo Numero de Telefone Nos Campos *Telefone* e *Telefone 2*", "FVLDTEL02")

		Endif

	Endif
Return  _lRET