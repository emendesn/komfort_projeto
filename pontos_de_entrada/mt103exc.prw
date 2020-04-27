#include "totvs.ch"
#include "protheus.ch"

/*/{Protheus.doc} MT103EXC
//TODO Descrição auto-gerada.
@author rafael.cruz
@since 20/09/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/

User Function MT103EXC()

Local lRet		:= .T.
Local aSE1		:= {}
Local aAreaSE1	:= SE1->(GetArea())

SE1->(dbSetOrder(1))
SE1->(dbGoTop())

If SF1->F1_TIPO <> 'N'
	While SD1->(!EOF()) .AND. SD1->(D1_FILIAL + D1_DOC + D1_SERIE) == SF1->(F1_FILIAL + F1_DOC + F1_SERIE) 
		If SE1->(dbSeek(xFilial("SE1") + "SAC" + SD1->D1_NFORI + "A " + "NDC" )) .AND. !EMPTY(SE1->E1_BAIXA)
			aAdd(aSE1,{SE1->E1_FILIAL,SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO})
		EndIf
		SD1->(dbSkip())
	EndDo
EndIf

If lRet
	For nI := 1 to Len(aSE1)
		FwMsgRun( ,{|| U_KMSACA9A(aSE1[nI],5)}, , "Excluindo a(s) baixa(s) de NDC(s) de empréstimo ("+ cValToChar(nI) +"/"+ cValToChar(Len(aSE1)) +"), favor aguarde..." )
	Next
EndIf

RestArea(aAreaSE1)

Return lRet