// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : SYVA110
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 02/06/14 | TOTVS | Developer Studio | Gerado pelo Assistente de Código
// ---------+-------------------+-----------------------------------------------------------

#include "rwmake.ch"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} novo
Permite a manutenção de dados armazenados em SZ5.

@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     2/06/2014
/*/
//------------------------------------------------------------------------------------------
user function SYVA110()
//--< variáveis >---------------------------------------------------------------------------

//Indica a permissão ou não para a operação (pode-se utilizar 'ExecBlock')
	local cVldAlt := ".T." // Operacao: ALTERACAO
	local cVldExc := ".T." // Operacao: EXCLUSAO

//trabalho/apoio
	local cAlias

//--< procedimentos >-----------------------------------------------------------------------
	cAlias := "SZ5"
	chkFile(cAlias)
	dbSelectArea(cAlias)
//indices
	dbSetOrder(1)
	axCadastro(cAlias, "Cadastro de Montadores", cVldExc, cVldAlt)

return
//--< fim de arquivo >----------------------------------------------------------------------
