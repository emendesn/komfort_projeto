#INCLUDE "Protheus.ch"                                                       

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���PROGRAMA: �DL200BRW  �AUTOR: �Caio Garcia            �DATA: �08/10/18  ���
�������������������������������������������������������������������������Ĵ��
���USADO EM: � Estoque/Custos - Komfort House                             ���
�������������������������������������������������������������������������Ĵ��
���	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU��O INICIAL.		      ���
�������������������������������������������������������������������������Ĵ��
���  PROGRAMADOR  �  DATA  � ALTERACAO OCORRIDA 				          ���
�������������������������������������������������������������������������Ĵ��
���               |  /  /  |                                              ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function DL200BRW()

Local _aRet := PARAMIXB        
Local _nx       := 0
Local _nCep     := 0
Local _nSeqRot  := 0
Local _cDesRot  := ''
Local _cDesCep  := ''
Local _cSeqRot  := 'PED_SEQROT'
Local _cCep     := 'PED_CEP'            
Local _cSeqLib  := 'PED_SEQLIB'
Local _cDesLib  := ''
Local _nSeqLibe := 0
Local _cLoja    := 'PED_LOJA'
Local _nLoja    := 0
Local _cDesLoja := ''

For _nx := 1 To Len(_aRet)
	
	If AllTrim(_aRet[_nx,1]) == _cSeqRot
		
		_nSeqRot  := _nx
		_cDesRot  := _aRet[_nx,3]
		
		
	ElseIf AllTrim(_aRet[_nx,1]) == _cCep
		
		_nCep := _nx
		_cDesCep  := _aRet[_nx,3]
                                 
	ElseIf AllTrim(_aRet[_nx,1]) == _cSeqLib
		
		_nSeqLib  := _nx
		_cDesLib  := _aRet[_nx,3]
		
	ElseIf AllTrim(_aRet[_nx,1]) == _cLoja
		
		_nLoja     := _nx
		_cDesLoja  := _aRet[_nx,3]
	
	EndIf
	
Next _nx

If _nSeqRot > 0 .And. _nCep > 0
	
	_aRet[_nSeqRot,1] := _cCep
	_aRet[_nSeqRot,2] := ''
	_aRet[_nSeqRot,3] := _cDesCep
	
	_aRet[_nCep,1] := _cSeqRot
	_aRet[_nCep,2] := ''	
	_aRet[_nCep,3] := _cDesRot
	
EndIf

If _nSeqLib > 0

	_aRet[_nSeqLib,1] := "PED_ENTREG"
	_aRet[_nSeqLib,2] := ''
	_aRet[_nSeqLib,3] := "Entrega"

	Aadd(_aRet,{_cSeqLib,,_cDesLib})

Else             
	Aadd(_aRet,{"PED_ENTREG",,"Entrega"})
EndIf	

If _nLoja > 0

	_aRet[_nLoja,1] := "PED_TROCA"
	_aRet[_nLoja,2] := ''
	_aRet[_nLoja,3] := "Troca?"

	Aadd(_aRet,{_cLoja,,_cDesLoja})
	
Else             
	Aadd(_aRet,{"PED_TROCA",,"Troca?"})
EndIf	             


Aadd(_aRet,{"PED_REGCON",,"Restri��o de Entrega"})
Aadd(_aRet,{"PED_OPCTP",,"Tipo Troca"})

nPosTpTr    := Ascan(_aRet,{|x| Alltrim(x[1]) == 'PED_OPCTP'})
nPosReg     := Ascan(_aRet,{|x| Alltrim(x[1]) == 'PED_REGCON'})
nPosCodCli  := Ascan(_aRet,{|x| Alltrim(x[1]) == 'PED_CODCLI'})

_aRet[nPosTpTr,1] := "PED_CODCLI"
_aRet[nPosTpTr,2] := ''
_aRet[nPosTpTr,3] := "Cliente"

_aRet[nPosCodCli,1] := "PED_OPCTP"
_aRet[nPosCodCli,2] := ''
_aRet[nPosCodCli,3] := "Tipo Troca"

nPosPtr := Ascan(_aRet,{|x| Alltrim(x[1]) == 'PED_TROCA'})

_aRet[nPosPtr,1] := "PED_REGCON"
_aRet[nPosPtr,2] := ''
_aRet[nPosPtr,3] := "Restri��o de Entrega"

_aRet[nPosReg,1] := "PED_TROCA"
_aRet[nPosReg,2] := ''
_aRet[nPosReg,3] := "Troca?"


Return _aRet