#include 'protheus.ch'
#include 'parmtype.ch'
#Include 'TopConn.Ch'
#Include 'TbiConn.ch'

//----------------------------------------------------------------------------------------------------
/*/{Protheus.doc} TRORESP
Description //Esta rotina trata a Pendencia Financeira nos casos onde a rotina automatica falha.
@param xParam Parameter Description
@return xRet Return Description
@author  - Everton Santos
@since 09/03/2020 /*/
//----------------------------------------------------------------------------------------------------
user function KHFIN009()

Local cAlias1  := GetNextAlias()
Local cAlias2  := GetNextAlias()
Local cQuery   := ''
Local cQuery2  := ''
Local aDados1  := {}
Local aDados2  := {}
Local nx
Local ny

// Traz os pedidos que alcançaram o valor minimo e não foram liberados ao passar pelo ponto de entrada FA070TIT.
cQuery := " SELECT C5_NUM,C5_EMISSAO,C5_MSFIL,UA_XPERLIB, (UA_VLRLIQ/100)*UA_XPERLIB AS VALOR_MINIMO, " + CRLF
cQuery += " (SELECT CASE WHEN SUM(E1_VALOR) IS NULL THEN 0 ELSE SUM(E1_VALOR) END VALOR FROM SE1010(NOLOCK) WHERE E1_MSFIL = SUA.UA_FILIAL AND E1_PEDIDO = SUA.UA_NUMSC5 AND E1_CLIENTE = SUA.UA_CLIENTE AND E1_TIPO NOT IN ('BOL','CHK','RA') AND D_E_L_E_T_ = ' ')" + CRLF 
cQuery += " + " + CRLF
cQuery += " (SELECT CASE WHEN SUM(E1_VALOR) IS NULL THEN 0 ELSE SUM(E1_VALOR) END VALOR FROM SE1010(NOLOCK) WHERE E1_MSFIL = SUA.UA_FILIAL AND E1_PEDIDO = SUA.UA_NUMSC5 AND E1_CLIENTE = SUA.UA_CLIENTE AND E1_TIPO IN ('BOL','CHK') AND E1_STATUS = 'B' AND D_E_L_E_T_ = ' ') AS RECEBIDO," + CRLF
cQuery += " SC5.R_E_C_N_O_" + CRLF
cQuery += " FROM SUA010(NOLOCK) SUA" + CRLF
cQuery += " INNER JOIN SC5010(NOLOCK) SC5 ON SC5.C5_NUM = SUA.UA_NUMSC5 AND SUA.D_E_L_E_T_ = ' '" + CRLF
cQuery += " WHERE SC5.C5_PEDPEND = '2'" + CRLF
cQuery += " AND (SELECT CASE WHEN SUM(E1_VALOR) IS NULL THEN 0 ELSE SUM(E1_VALOR) END VALOR FROM SE1010(NOLOCK) WHERE E1_MSFIL = SUA.UA_FILIAL AND E1_PEDIDO = SUA.UA_NUMSC5 AND E1_CLIENTE = SUA.UA_CLIENTE AND E1_TIPO NOT IN ('BOL','CHK','RA') AND D_E_L_E_T_ = ' ') + (SELECT CASE WHEN SUM(E1_VALOR) IS NULL THEN 0 ELSE SUM(E1_VALOR) END VALOR FROM SE1010(NOLOCK) WHERE E1_MSFIL = SUA.UA_FILIAL AND E1_PEDIDO = SUA.UA_NUMSC5 AND E1_CLIENTE = SUA.UA_CLIENTE AND E1_TIPO IN ('BOL','CHK') AND E1_STATUS = 'B' AND D_E_L_E_T_ = ' ') >= ((UA_VLRLIQ/100)*UA_XPERLIB)" + CRLF
cQuery += " AND C5_NOTA = ''" + CRLF
cQuery += " AND C5_XPERLIB > 0" + CRLF
cQuery += " AND SC5.D_E_L_E_T_ = ''" + CRLF
cQuery += " ORDER BY SC5.R_E_C_N_O_" + CRLF

PlsQuery(cQuery, cAlias1)

dbSelectArea("SC5")

while (cAlias1)->(!eof())
	Aadd(aDados1,{ (cAlias1)->C5_NUM ,(cAlias1)->C5_MSFIL, (cAlias1)->R_E_C_N_O_ } )
	(cAlias1)->(dbSkip())
EndDo

// Altera o Pedido e os itens do pedido para Pedido Normal
For nx := 1 To Len(aDados1)
	
	SC5->(dbgoto(aDados1[nx][3])) 
	IF SC5->(!EOF())
	  	RecLock("SC5",.F.)
	  		SC5->C5_PEDPEND := '4' // Pedido Normal
	  	SC5->(msUnLock())
	EndIF
	
	dbselectarea("SC6")
	SC6->(dbsetorder(1))
				
	if SC6->(dbseek(xFilial() + aDados1[nx][1]))
		while SC6->C6_MSFIL == aDados1[nx][2] .and. SC6->C6_NUM == aDados1[nx][1]
			recLock("SC6",.F.)
				SC6->C6_PEDPEND := "4"
			SC6->(msUnlock())
			SC6->(dbskip())
		endDo
	endif
		
Next nx

SC5->(dbCloseArea())
SC6->(dbCloseArea())


//Traz os pedidos que não alcançaram o valor minimo e estão com o campo C5_PEDPEND <> 2(Liberados)
cQuery2 := " SELECT C5_NUM,C5_EMISSAO,C5_MSFIL,C5_PEDPEND,UA_XPERLIB, (UA_VLRLIQ/100)*UA_XPERLIB AS VALOR_MINIMO, " + CRLF
cQuery2 += " (SELECT CASE WHEN SUM(E1_VALOR) IS NULL THEN 0 ELSE SUM(E1_VALOR) END VALOR FROM SE1010(NOLOCK) WHERE E1_MSFIL = SUA.UA_FILIAL AND E1_PEDIDO = SUA.UA_NUMSC5 AND E1_CLIENTE = SUA.UA_CLIENTE AND E1_TIPO NOT IN ('BOL','CHK','RA') AND D_E_L_E_T_ = ' ') " + CRLF 
cQuery2 += " + " + CRLF
cQuery2 += " (SELECT CASE WHEN SUM(E1_VALOR) IS NULL THEN 0 ELSE SUM(E1_VALOR) END VALOR FROM SE1010(NOLOCK) WHERE E1_MSFIL = SUA.UA_FILIAL AND E1_PEDIDO = SUA.UA_NUMSC5 AND E1_CLIENTE = SUA.UA_CLIENTE AND E1_TIPO IN ('BOL','CHK') AND E1_STATUS = 'B' AND D_E_L_E_T_ = ' ') AS RECEBIDO, " + CRLF
cQuery2 += " SC5.R_E_C_N_O_ " + CRLF
cQuery2 += " FROM SUA010(NOLOCK) SUA " + CRLF
cQuery2 += " INNER JOIN SC5010(NOLOCK) SC5 ON SC5.C5_NUM = SUA.UA_NUMSC5 AND SUA.D_E_L_E_T_ = ' ' " + CRLF
cQuery2 += " WHERE SC5.C5_PEDPEND <> '2' " + CRLF
cQuery2 += " AND (SELECT CASE WHEN SUM(E1_VALOR) IS NULL THEN 0 ELSE SUM(E1_VALOR) END VALOR FROM SE1010(NOLOCK) WHERE E1_MSFIL = SUA.UA_FILIAL AND E1_PEDIDO = SUA.UA_NUMSC5 AND E1_CLIENTE = SUA.UA_CLIENTE AND E1_TIPO NOT IN ('BOL','CHK','RA') AND D_E_L_E_T_ = ' ') + (SELECT CASE WHEN SUM(E1_VALOR) IS NULL THEN 0 ELSE SUM(E1_VALOR) END VALOR FROM SE1010(NOLOCK) WHERE E1_MSFIL = SUA.UA_FILIAL AND E1_PEDIDO = SUA.UA_NUMSC5 AND E1_CLIENTE = SUA.UA_CLIENTE AND E1_TIPO IN ('BOL','CHK') AND E1_STATUS = 'B' AND D_E_L_E_T_ = ' ') < ((UA_VLRLIQ/100)*UA_XPERLIB) " + CRLF
cQuery2 += " AND C5_NOTA = '' " + CRLF
cQuery2 += " AND C5_XPERLIB > 0 " + CRLF
cQuery2 += " AND SC5.D_E_L_E_T_ = '' " + CRLF
cQuery2 += " ORDER BY SC5.R_E_C_N_O_ " + CRLF	

PlsQuery(cQuery2, cAlias2)

dbSelectArea("SC5")

while (cAlias2)->(!eof())
	Aadd(aDados2,{ (cAlias2)->C5_NUM ,(cAlias2)->C5_MSFIL, (cAlias2)->R_E_C_N_O_ } )
	(cAlias2)->(dbSkip())
EndDo

// Altera o pedido e os itens para Pendencia financeira
For ny := 1 To Len(aDados2)
	
	SC5->(dbgoto(aDados2[ny][3])) 
	IF SC5->(!EOF())
	  	RecLock("SC5",.F.)
	  		SC5->C5_PEDPEND := '2' // Pendencia Financeira
	  	SC5->(msUnLock())
	EndIF
	
	dbselectarea("SC6")
	SC6->(dbsetorder(1))
				
	if SC6->(dbseek(xFilial() + aDados2[ny][1]))
		while SC6->C6_MSFIL == aDados2[ny][2] .and. SC6->C6_NUM == aDados2[ny][1]
			recLock("SC6",.F.)
				SC6->C6_PEDPEND := "2"
			SC6->(msUnlock())
			SC6->(dbskip())
		endDo
	endif
		
Next ny

SC5->(dbCloseArea())
SC6->(dbCloseArea())	

return

User Function JOBPENDF(aEmp)

	Local aEmp := {"01","0101"}

	PREPARE ENVIRONMENT EMPRESA aEmp[1] FILIAL aEmp[2]    

	//U_KHFIN009()

Return 