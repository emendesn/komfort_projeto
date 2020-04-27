#include "protheus.ch"

//Descrição: Este Ponto de Entrada permite que após o processamento de todas as Notas Fiscais, 
//de todas as cargas selecionadas, seja executada qualquer ação necessária de forma customizada.
//Localização:Localizado na função que efetua o processamento das Notas Fiscais após processar todas as filiais e todas as cargas selecionadas.

User Function OS460NOT()

Local aCargas := PARAMIXB[1]
Local cCarga  := ""
Local nX      := 0

// Processamento customizado
For nX := 1 to Len(aCargas)
    
    cCarga := aCargas[nX]
    LimpaPC(cCarga)

Next nX

Return

//----------------------------------------------------------------------------------------------------
/*/{Protheus.doc} LimpaPC
Description //A partir dos pedidos da carga limpa a associação do campo C7_01NUMPV no Pedido de Compra
@param xParam Parameter Description
@return xRet Return Description
@author  - Everton Santos
@since 15/02/2020 /*/
//----------------------------------------------------------------------------------------------------

Static Function LimpaPC(cCarga)

Local aArea     := GetArea()
Local _cQuery   := ""
Local _cAlias   := GetNextAlias()


_cQuery := " SELECT C7_FILIAL,C7_NUM,C7_PRODUTO,C7_ITEM,C7_01NUMPV,R_E_C_N_O_ " + CRLF 
_cQuery += " FROM SC7010(NOLOCK) " + CRLF 
_cQuery += " WHERE D_E_L_E_T_ = '' " + CRLF
_cQuery += " AND C7_QUJE = 0 " + CRLF // garante que so vai limpar o campo C7_01NUMPV do pedido de compra sem quantidade atendida.
_cQuery += " AND C7_RESIDUO <> 'S' " + CRLF
_cQuery += " AND C7_ENCER = '' " + CRLF
_cQuery += " AND C7_01NUMPV IN ( SELECT DAI_PEDIDO FROM DAI010(NOLOCK) WHERE DAI_COD = '"+ cCarga +"' AND D_E_L_E_T_ = '') " + CRLF

PlsQuery(_cQuery,_cAlias)

While (_cAlias)->(!eof())

    dbSelectArea("SC7")
    
    SC7->(dbgoto( (_cAlias)->(R_E_C_N_O_) ) )
    
    IF SC7->(!EOF())
	    RecLock("SC7",.F.)
		    SC7->C7_01NUMPV := ''
		SC7->(msUnlock())
	EndIF

    (_cAlias)->(DbSkip())

EndDo

SC7->(DBCLOSEAREA())

RestArea(aArea)

return