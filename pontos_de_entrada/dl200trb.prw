#INCLUDE "Protheus.ch"   

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³DL200TRB  ³AUTOR: ³Caio Garcia            ³DATA: ³08/10/18  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ Estoque/Custos - Komfort House                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€ŽO INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  PROGRAMADOR  ³  DATA  ³ ALTERACAO OCORRIDA 				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³               |  /  /  |                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function DL200TRB()                        

Local _aRet    := PARAMIXB
Local _nx      := 0
Local _nCep    := 0
Local _nSeqRot := 0
Local _cTpRot  := ''
Local _nTaRot  := 0
Local _nDeRot  := 0
Local _cTpCep  := ''
Local _nTaCep  := 0
Local _nDeCep  := 0
Local _cSeqRot := 'PED_SEQROT'
Local _cCep    := 'PED_CEP'
Local _cSeqLib := 'PED_SEQLIB'
Local _nSeqLib := 0
Local _cTpLib  := ''
Local _nTaLib  := 0
Local _nDeLib  := 0   
Local _cLoja   := 'PED_LOJA'
Local _nLoja   := 0
Local _cTpLoja := ''
Local _nTaLoja := 0
Local _nDeLoja := 0

For _nx := 1 To Len(_aRet)
	
	If AllTrim(_aRet[_nx,1]) == _cSeqRot
		
		_nSeqRot := _nx
		_cTpRot  := _aRet[_nx,2]
		_nTaRot  := _aRet[_nx,3]
		_nDeRot  := _aRet[_nx,4]
		
		
	ElseIf AllTrim(_aRet[_nx,1]) == _cCep
		
		_nCep := _nx
		_cTpCep  := _aRet[_nx,2]
		_nTaCep  := _aRet[_nx,3]
		_nDeCep  := _aRet[_nx,4]

	ElseIf AllTrim(_aRet[_nx,1]) == _cSeqLib
		
		_nSeqLib := _nx
		_cTpLib  := _aRet[_nx,2]
		_nTaLib  := _aRet[_nx,3]
		_nDeLib  := _aRet[_nx,4]		

	ElseIf AllTrim(_aRet[_nx,1]) == _cLoja
		
		_nLoja := _nx
		_cTpLoja := _aRet[_nx,2]
		_nTaLoja := _aRet[_nx,3]
		_nDeLoja := _aRet[_nx,4]
		
	EndIf
	
Next _nx

If _nSeqRot > 0 .And. _nCep > 0
	
	_aRet[_nSeqRot,1] := _cCep
	_aRet[_nSeqRot,2] := _cTpCep
	_aRet[_nSeqRot,3] := _nTaCep
	_aRet[_nSeqRot,4] := _nDeCep
	
	_aRet[_nCep,1] := _cSeqRot
	_aRet[_nCep,2] := _cTpRot
	_aRet[_nCep,3] := _nTaRot
	_aRet[_nCep,4] := _nDeRot
	
EndIf
               
If _nSeqLib > 0

	_aRet[_nSeqLib,1] := "PED_ENTREG"
	_aRet[_nSeqLib,2] := "D"
	_aRet[_nSeqLib,3] := 8
	_aRet[_nSeqLib,4] := 0

	AADD(_aRet,{_cSeqLib,_cTpLib,_nTaLib,_nDeLib}) // Seq. Liberação
               
Else

	AADD(_aRet,{"PED_ENTREG" ,"D",8,0}) // Data de Entrega

EndIf                                                     
                                                          
If _nLoja > 0

	_aRet[_nLoja,1] := "PED_TROCA"
	_aRet[_nLoja,2] := "C"
	_aRet[_nLoja,3] := 3
	_aRet[_nLoja,4] := 0

	AADD(_aRet,{_cLoja,_cTpLoja,_nTaLoja,_nDeLoja}) // Loja CLiente
               
Else

	AADD(_aRet,{"PED_TROCA" ,"C",3,0}) // Troca?

EndIf     

AADD(_aRet,{"PED_OPCTP" ,"C",15,0}) // Tipo Troca     

AADD(_aRet,{"PED_REGCON" ,"C",80,0}) // Restrição de Entrega                                            

Return _aRet
