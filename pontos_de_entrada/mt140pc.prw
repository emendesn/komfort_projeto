#Include "Protheus.ch"
 
/*------------------------------------------------------------------------------------------------------*
 | P.E.:  MT140PC                                                                                       |
 | Desc:  Define se será obrigatório informar o pedido de compra na criação da Pré-Nota                 |
 | Links: http://tdn.totvs.com/pages/releaseview.actionçpageId=6085510                                  |
 *------------------------------------------------------------------------------------------------------*/
 
User Function MT140PC()

    Local lRet := ParamIXB[1]
     
    //Se vir do P.E. SF2460I, define que não será obrigatório
    If IsInCallStack('U_SF2460I') .OR. IsInCallStack('U_XMLMA005')
    	lRet := .F.
    EndIf
    
Return lRet