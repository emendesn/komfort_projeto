#include 'protheus.ch'

//Ponto de entrada que valida a inclus�o do pedido de compra (MATA120) antes da valida��o do m�dulo SIGAPCO (Valida��o de bloqueio).

user function MT120PCOK()

Local lOk := .T.
Local nCnpj := 0
Local nPvi	:= 0

//Preenche o campo C7_XCNPJFO com o CNPJ do forncedor selecionado para pesquisa no browse.
nCnpj := ASCAN(aHeader, {|x| x[2] == 'C7_XCNPJFO'})     

//Preenche o campo C7_XNUMPVI necess�rio para altera��o manual de pedidos de compras - Marcio Nunes - 11/02/2020
nPvi := ASCAN(aHeader, {|x| x[2] == 'C7_XNUMPVI'})

If nCnpj > 0
	For nx := 1 To Len(Acols)
			Acols[nx,nCnpj] := SA2->A2_CGC
	Next nx                                                        
EndIf     

If nPvi > 0
	For nx := 1 To Len(Acols)
		If Empty(Alltrim(Acols[nx,nPvi]))   
			Acols[nx,nPvi] := "ZZ"
		EndIf                                                               
	Next nx
EndIf   

//--------------------------------------------------------------------------------------------

return lOk