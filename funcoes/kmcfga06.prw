#include 'protheus.ch'
#include 'parmtype.ch'

#DEFINE CRLF CHR(13)+CHR(10)	
#DEFINE ENTER CHR(10)+CHR(13)	

/*****************************************************
Fun�o generica, para valida��o do usu�rio no dicionario
de dados.
#RVC20181128 - Tratamento para n�o permitir quant. maior que 1
*****************************************************/

User Function kmcfga06()

	Local lRet		:= .T.
	Local _nPosPrd  := aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "UB_PRODUTO"})
	Local _nPosQtd  := aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "UB_QUANT"})
	Local _cProduto := ""
	Local _nQtdPed  := 0
	
	_cProduto := aCols[oGetTLV:oBrowse:nAt][_nPosPrd]
	_nQtdPed  := aCols[oGetTLV:oBrowse:nAt][_nPosQtd]
	
	If Posicione("SB1",1,xFilial("SB1") + _cProduto,"B1_LOCALIZ")=="S"
		if _nQtdPed > 1
			MsgStop("N�o � permitido inserir quantidade maior que 1 para este caso." + CRLF +"Por favor, insira a outra quantidade em uma nova linha.","Desmembrar Item")
			lRet := .F.
		endIf
	EndIf
	
Return lRet