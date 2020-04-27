#include "totvs.ch"
#include "protheus.ch"

/*/{Protheus.doc} MT103EXC
//TODO Descrição auto-gerada.
@author rafael.cruz
@since 21/09/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/

User Function MS520VLD()

Local lRet		:= .T.
Local aSE1		:= {}
Local aAreaSE1	:= SE1->(GetArea())

SE1->(dbSetOrder(1))
SE1->(dbGoTop())

If SE1->(dbSeek(xFilial("SE1") + "SAC" + SF2->F2_DOC + "A " + "NDC" )) 
	If EMPTY(SE1->E1_BAIXA)
		aAdd(aSE1,{SE1->E1_FILIAL,SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO})
	Else
		MsgStop("O(s) título(s) de NDC de empréstimo já baixado(s). Por favor, comunique o financeiro.","Exclusão NDC Empréstimo")
		lRet := .F.
	EndIf
EndIf
		
If lRet
	For nI := 1 to Len(aSE1)
		FwMsgRun( ,{|| U_KMSACA9B(aSE1[nI])}, , "Excluindo o(s) NDC(s) de empréstimo ("+ cValToChar(nI) +"/"+ cValToChar(Len(aSE1)) +"), favor aguarde..." )
	Next
EndIf

RestArea(aAreaSE1)

Return lRet