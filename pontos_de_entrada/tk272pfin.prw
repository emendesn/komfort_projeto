#include 'protheus.ch'
#include 'parmtype.ch' 

#DEFINE ENTER CHR(13)+CHR(10)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ TK272PFIN บ Autor ณ Marcio Nunes       บ Data ณ  10/09/2019บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Cliente com pendencia financeira serแ emitido o alerta     บฑฑ
ฑฑ informado no gatilho do campo UC_CODCONT. O bloqueio ้ feito na        ผฑฑ
ฑฑ grava็ใo do chamado Fonte: (TMKMOK) - Chamado 11114                    ผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function TK272PFIN(cCodCont)
	
	Local aArea 	:= getArea() 
	Local cCliente	:= ""
	Local cLoja		:= "" 

	Default cCodCont := ""     
	
	If cCodCont <> ""  
	
		//Caso o Cliente esteja com pend๊ncia financeira nใo serแ permitido a abertura de chamados
		//Marcio Nunes - 27/08/2019 - Chamado 11114
		DbSelectArea("SU5")
		DbSetOrder(1)
		DbSeek(xFilial("SU5") + cCodCont)
		cCliente := SUBSTR(SU5->U5_01SAI,1,6)
		cLoja	 := SUBSTR(SU5->U5_01SAI,7,2)
		
		//Posiciona SE1 para verificar pend๊ncia financeira onnde a parcela ้ menor que a data atual e ainda nใo foi paga
		cQuery := "SELECT E1_CLIENTE, E1_LOJA, E1_NUM, E1_PARCELA, E1_PREFIXO, E1_TIPO, E1_EMISSAO, E1_VENCREA, E1_VALOR, E1_SALDO " + ENTER
		cQuery += " FROM SE1010  " + ENTER
		cQuery += " WHERE E1_TIPO IN('BOL','CH')  " + ENTER
		cQuery += " AND E1_CLIENTE='"+ cCliente +"' " + ENTER
		cQuery += " AND E1_LOJA='"+ cLoja +"' " + ENTER		
		cQuery += " AND E1_VENCREA < GETDATE ( )-1  " + ENTER //Considerar 1 dia para constar como atraso
		cQuery += " AND E1_SALDO > 0 " + ENTER
		cQuery += " AND D_E_L_E_T_='' " + ENTER    
		
		cAlias3 := GetNextAlias()               
	
		PLSQuery(cQuery, cAlias3)
		If (cAlias3)->(!Eof())//Exibe apenas o alerta, o bloqueio ้ feito na confirma็ใo do chamado
    				//MsgAlert("","ATENวรO")
			Help(NIL, NIL, 'ATENวรO', NIL, 'O Cliente possiu pendencia financeira nใo serแ permitido a abertura de chamado. KH_SAC001', 1, 0, NIL, NIL, NIL, NIL, NIL, {'Entre em contato com o supervisor da แrea.'})
			Return .F.
		EndIf   	   		    
		(cAlias3)->(DbCloseArea())  
	                             
	EndIf

	restArea(aArea)
	
Return
