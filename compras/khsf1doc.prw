#include "protheus.ch"
#include "totvs.ch"

//Valid do campo SF1_DOC
//Vazio() .Or. U_KHSF1DOC()

// -----> U_KHSF1DOC()            
//--------------------------------------------------------------------------|
//	Funtion - KHSF1DOC() -> Complemento para o preenchimento dos zeros	   	| 
//	a esquerda na digitacao do numero do documento de entrada			   	|
//	Uso - Komfort House													   	|
//  By Alexis Duarte - 25/04/2018  											|
//--------------------------------------------------------------------------|
User Function KHSF1DOC()

	If !Empty(M->F1_DOC) .Or. !Empty(CNFISCAL)
	   M->F1_DOC := StrZero(Val(M->F1_DOC),9)
	   CNFISCAL := M->F1_DOC
	Endif   

Return(.T.)                
