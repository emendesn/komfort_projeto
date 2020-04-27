#include 'protheus.ch'
#include 'parmtype.ch' 

#DEFINE ENTER CHR(13)+CHR(10)

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � TK272PFIN � Autor � Marcio Nunes       � Data �  10/09/2019���
�������������������������������������������������������������������������͹��
���Descricao � Cliente com pendencia financeira ser� emitido o alerta     ���
�� informado no gatilho do campo UC_CODCONT. O bloqueio � feito na        ���
�� grava��o do chamado Fonte: (TMKMOK) - Chamado 11114                    ���
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function TK272PFIN(cCodCont)
	
	Local aArea 	:= getArea() 
	Local cCliente	:= ""
	Local cLoja		:= "" 

	Default cCodCont := ""     
	
	If cCodCont <> ""  
	
		//Caso o Cliente esteja com pend�ncia financeira n�o ser� permitido a abertura de chamados
		//Marcio Nunes - 27/08/2019 - Chamado 11114
		DbSelectArea("SU5")
		DbSetOrder(1)
		DbSeek(xFilial("SU5") + cCodCont)
		cCliente := SUBSTR(SU5->U5_01SAI,1,6)
		cLoja	 := SUBSTR(SU5->U5_01SAI,7,2)
		
		//Posiciona SE1 para verificar pend�ncia financeira onnde a parcela � menor que a data atual e ainda n�o foi paga
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
		If (cAlias3)->(!Eof())//Exibe apenas o alerta, o bloqueio � feito na confirma��o do chamado
    				//MsgAlert("","ATEN��O")
			Help(NIL, NIL, 'ATEN��O', NIL, 'O Cliente possiu pendencia financeira n�o ser� permitido a abertura de chamado. KH_SAC001', 1, 0, NIL, NIL, NIL, NIL, NIL, {'Entre em contato com o supervisor da �rea.'})
			Return .F.
		EndIf   	   		    
		(cAlias3)->(DbCloseArea())  
	                             
	EndIf

	restArea(aArea)
	
Return
