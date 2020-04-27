#include 'protheus.ch'
#include 'parmtype.ch'

/*****************************************************
Funão generica, para validação do usuário no dicionario
de dados.
#RVC20180422 - Tratamento para permitir o agendamento já na informação da data de entrega
*****************************************************/

User Function KFHVLDCPO(cCpoVld,dDataVld,dDtEmiss)

	Local lRet		:= .T.
	Local nPosAtu	:= aScan( aHeader, {|x| Alltrim(x[2]) == "UB_DTENTRE" } )
	Local nPosAtu2	:= GDFIELDPOS("UB_XAGEND")	//#RVC20180422.n
	Local _nPosPrd  := aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "UB_PRODUTO"})
	Local _nPosLoc  := aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "UB_LOCAL"})
	Local _nPosQtd  := aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "UB_QUANT"})
	Local _nPosMos  := aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "UB_MOSTRUA"})
	Local _cProduto := ""
	Local _cLocal   := ""
	Local _nQtdEst  := 0
	Local _nQtdPed  := 0
	Local _aSaldos  := {}
	Local _cFilBkp  := cFilAnt
	Default cCpoVld	:= ""
	Default dDataVld := CTOD("  /  /  ")
	Default dDtEmiss := CTOD("  /  /  ")

	dDataVld := M->UB_DTENTRE //aCols[n][nPosAtu]
	dDtEmiss := M->UA_EMISSAO

	_cProduto := aCols[oGetTLV:oBrowse:nAt][_nPosPrd]
	_cLocal   := aCols[oGetTLV:oBrowse:nAt][_nPosLoc]
	_nQtdPed  := aCols[oGetTLV:oBrowse:nAt][_nPosQtd]


	If aCols[oGetTLV:oBrowse:nAt][_nPosMos] == '1'//Verifica se o produto é novo, assim deve sair do armazem padrão
	
		cFilAnt := '0101'
		
	EndIf

	_aSaldos := CalcEst(_cProduto,_cLocal, (Date()+1))
	_nQtdEst := _aSaldos[1]

	cFilAnt := _cFilBkp

	If Alltrim(cCpoVld) $ "UB_DTENTRE/M->UB_DTENTRE/SUB->UB_DTENTRE"
		If dDataVld < dDtEmiss
			MsgStop("A data de entrega não pode ser menor que a data de emissao da venda.","Data de Entrega")
			lRet := .F.
		Else

			If _nQtdPed <= _nQtdEst

				//#RVC20180422.bn
				If !Empty(dDataVld) //.and. dDtEntre <> dDataBase
					If MsgYesNo("Confirma a Data de Entrega para: " + cValToChar(dDataVld) + "?","ATENÇÃO","YESNO")
                    	if aCols[oGetTLV:oBrowse:nAt][_nPosMos] == '2'//#afd27062018.bn
							MsgStop("Não é possivel Realizar o agendamento de mostruario, somente o SAC pode realizar essa ação.","Agendamento")							
							aCols[oGetTLV:oBrowse:nAt][nPosAtu2] := "2"
							lRet := .F.
						else//#afd27062018.en
							aCols[oGetTLV:oBrowse:nAt][nPosAtu2] := "1" //M->UB_XAGEND := '1'
							lRet := .T.
						endif//#afd27062018.n
					Else
						lRet := .F.
					EndIf
				EndIf
				//#RVC20180422.en
			Else
				MsgStop("Não é permitido agendar pedidos sem saldo no estoque!","NOSALDO")
			EndIf	
		EndIf	
	EndIf

Return lRet