#include 'rwmake.ch'
#include 'totvs.ch'
#include 'protheus.ch'
#include 'topconn.ch'
#include 'tryexception.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} KMESTF06
Description => //Função responsavel por apresentar os Itens agendados
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul Pinto
@since 18/07/2018
/*/
//--------------------------------------------------------------

User Function KMESTF06()

	staticcall(AGEND,ITAGEND)

Return