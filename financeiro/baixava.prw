#include 'protheus.ch'
#include 'parmtype.ch'
#Include 'TopConn.Ch'
#Include 'TbiConn.ch'

//----------------------------------------------------------------------------------------------------
/*/{Protheus.doc} TRORESP
Description //Esta rotina efetua a baixa dos titulos de VA na data de vencimento real.
@param xParam Parameter Description
@return xRet Return Description
@author  - Everton Santos
@since 05/03/2020 /*/
//----------------------------------------------------------------------------------------------------
User Function BaixaVa()

Local aBaixa := {}
Local aDados := {}
Local cQuery := ""
Local cAlias := GetNextAlias()
Local aArea  := GetArea()
Local nx := 0

Private lMSHelpAuto := .T.
Private lMsErroAuto := .F.

cQuery := " SELECT E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_VENCREA, E1_VALOR, R_E_C_N_O_ FROM SE1010(NOLOCK) " + CRLF 
cQuery += " WHERE E1_TIPO = 'VA' " + CRLF 
cQuery += " AND E1_VENCREA BETWEEN '20180903' AND GETDATE() " + CRLF
cQuery += " AND E1_BAIXA = '' " + CRLF
cQuery += " AND D_E_L_E_T_ = '' " + CRLF
cQuery += " ORDER BY E1_NUM " + CRLF

PlsQuery(cQuery, cAlias)

(cAlias)->(dbgotop())

While ! (cAlias)->(Eof())

    Aadd(aDados,{ (cAlias)->E1_FILIAL,;
                  (cAlias)->E1_PREFIXO,;
                  (cAlias)->E1_NUM,;
                  (cAlias)->E1_PARCELA,;
                  (cAlias)->E1_TIPO,;
                  (cAlias)->E1_VENCREA,;
                  (cAlias)->E1_VALOR,;
                  (cAlias)->R_E_C_N_O_   })

    (cAlias)->(dbSkip())

EndDo

If Len(aDados) > 0

	For nx := 1 to Len(aDados)

		aBaixa := {}

		AADD(aBaixa , {"E1_PREFIXO"		,aDados[nx,2]		,NIL})
		AADD(aBaixa , {"E1_NUM"		 	,aDados[nx,3]		,NIL})
		AADD(aBaixa , {"E1_PARCELA"	 	,aDados[nx,4]       ,NIL})  
		AADD(aBaixa , {"E1_TIPO"	 	,aDados[nx,5]		,NIL})
		AADD(aBaixa , {"AUTMOTBX"    	,"NOR"         		,Nil})
		AADD(aBaixa , {"AUTBANCO"    	,"CX1"				,Nil})
		AADD(aBaixa , {"AUTAGENCIA"  	,"00001"			,Nil})
		AADD(aBaixa , {"AUTCONTA"    	,"0000000001"		,Nil})
		AADD(aBaixa , {"AUTDTBAIXA"  	,aDados[nx,6]     	,Nil})
		AADD(aBaixa , {"AUTDTCREDITO"	,aDados[nx,6]     	,Nil})
		AADD(aBaixa , {"AUTHIST"     	,"Baixa Automatica - JOBBXVA.",Nil})
		AADD(aBaixa , {"AUTJUROS"    	,0            		,Nil})
		AADD(aBaixa , {"AUTVALREC"   	,aDados[nx,7]   	,Nil})
    
        MSExecAuto({|x, y| FINA070(x, y)}, aBaixa, 3) 
        //3 - Baixa de Título, 5 - Cancelamento de baixa, 6 - Exclusão de Baixa.
                    
        If  lMsErroAuto
            MostraErro()
            DisarmTransaction()
        else
            dbSelectArea("SE1")
            SE1->(DBGOTO( aDados[nx,8] ))
            IF SE1->(!EOF())
                RecLock("SE1",.F.)
                    SE1->E1_XBXCNB1 := '6' // RASTREIO BAIXA AUTOMATICA VA
                SE1->(msUnlock())
            EndIF
            SE1->(DBCLOSEAREA())
        EndIF

    Next nx
    
ENDIF

(cAlias)->(dbCloseArea())
RestArea(aArea)

return

User Function JOBBXVA(aEmp)

	Local aEmp := {"01","0101"}

	PREPARE ENVIRONMENT EMPRESA aEmp[1] FILIAL aEmp[2]    

	U_BaixaVa()

Return 