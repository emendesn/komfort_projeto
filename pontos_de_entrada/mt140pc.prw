#Include "Protheus.ch"
 
/*------------------------------------------------------------------------------------------------------*
 | P.E.:  MT140PC                                                                                       |
 | Desc:  Define se ser� obrigat�rio informar o pedido de compra na cria��o da Pr�-Nota                 |
 | Links: http://tdn.totvs.com/pages/releaseview.action�pageId=6085510                                  |
 *------------------------------------------------------------------------------------------------------*/
 
User Function MT140PC()

    Local lRet := ParamIXB[1]
     
    //Se vir do P.E. SF2460I, define que n�o ser� obrigat�rio
    If IsInCallStack('U_SF2460I') .OR. IsInCallStack('U_XMLMA005')
    	lRet := .F.
    EndIf
    
Return lRet