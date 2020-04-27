// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : MT103GET
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 11/06/14 | TOTVS | Developer Studio | Gerado pelo Assistente de Código
// ---------+-------------------+-----------------------------------------------------------

#include "rwmake.ch"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} novo
Montagem da tela de processamento

@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     11/06/2014
/*/
//------------------------------------------------------------------------------------------
user function MT103GET()

Local lRet	:= .T.
Local aArea := GetArea()
Local cUser := SuperGetMV("KH_ALTFIS",.T.,"000826|001206")//habilita a alteração dos campos para os usuarios contidos.

If __cUserId $ cUser
	lRet := .F.
EndIf

RestArea(aArea)
return(lRet)
//--< fim de arquivo >----------------------------------------------------------------------
