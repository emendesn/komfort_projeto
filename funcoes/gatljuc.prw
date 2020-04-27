#include 'protheus.ch'
#include 'parmtype.ch'

//Criado em 24/05/2019 - Everton Santos
//Função para preencher o campo UC_XFILIAL com o codigo da loja referente ao campo UC_01PED.
//Função alterada em 04/06/2019 - Preenche o campo UC_01FIL com o nome da filial de origem do pedido.
//Caso pedido seja do Netgera preenche a descrição da filial como CD MATRIZ. 

user function GatLjUC()

Local _cRet  := ''
Local _cFil  := ''
Local cQuery := ''
Local _cDesc := ''
Local cAlias := GetNextAlias()

If Len(ALLTRIM(M->UC_01PED)) == 10
	_cRet := LEFT(ALLTRIM(M->UC_01PED),4)
	cQuery := "SELECT * FROM SM0010 WHERE FILFULL = '"+ _cRet +"'
	PLSQuery(cQuery, cAlias)

	If (cAlias)->(!EOF())
		_cFil  := (cAlias)->FILFULL
		_cDesc := (cAlias)->FILIAL
	EndIf
		
	If !Empty(_cFil)
		M->UC_XFILIAL := ALLTRIM(_cFil)
		M->UC_01FIL   := ALLTRIM(_cDesc)
	EndIf
	(cAlias)->(dbCloseArea())	
Else
		M->UC_01FIL := 'CD MATRIZ'
		M->UC_XFILIAL := ''
EndIf

return .T.