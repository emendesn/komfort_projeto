#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TBICONN.CH'

User Function KHCodAleat(cCampo)

	Local nRandom	:= 0
	Local nQtde		:= 0
	Local nX		:= 0
	Local cRet		:= ""

	DEFAULT cCampo	:= "" // Verifica se o conteudo de 'cCampo' existe no dicionario (SX3).

	If (Empty(cCampo))
		//Se nenhum conteudo for informado, por padrao, sera gerado um codigo com 06 caracteres.

		nQtde	:= 6

	Else

		nQtde	:= TamSx3(cCampo)[1]//Verifica se o campo existe no dicionario (SX3). Existindo, sera gerado um codigo com a quantidade de caracteres considerando o tamanho do campo.

		If (nQtde == 0)
			//Se nao existir, cria um codigo com 06 caracteres

			nQtde	:= 6

		EndIf

	EndIf

	For nX := 1 TO nQtde

		nRandom		:= Randomize(1,3)

		If (nRandom == 1)

			nRandom		:= Randomize(65,91) // Através da tabela ASCII, retorna um caracter entre 'A' e 'Z'

		Else

			nRandom		:= Randomize(49,58) // Através da tabela ASCII, retorna um caracter entre '1' e '9'

		EndIf

		cRet	+= CHR(nRandom)

	Next nX

Return cRet