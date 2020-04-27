// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : KMCFGA05.prw
// -----------+-------------------+---------------------------------------------------------
// Data       | Autor             | Descricao
// -----------+-------------------+---------------------------------------------------------
// 02/10/2018 | rafael.cruz       | Gerado com aux�lio do Assistente de C�digo do TDS.
// -----------+-------------------+---------------------------------------------------------

#include "protheus.ch"
#include "vkey.ch"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} KMCFGA05
Manuten��o de dados em SUA-Orcamento Televendas.

@author    rafael.cruz
@version   11.3.9.201806061959
@since     02/10/2018
/*/
//------------------------------------------------------------------------------------------

/*------------------------------------------------------------------------------------------
Notas sobre aRotina.
A lista multidimensional aRotina cont�m as definicoes das opcoes d�sponiveis ao usuario.
Cada elemento indica uma op��o e possue o formato:
private aRotina := {;
{<DESCRICAO>,<ROTINA>,0,<TIPO>}[,...];
}
Onde:
<DESCRICAO> - Descricao da opcao do menu
<ROTINA>    - Rotina a ser executada. Deve estar entre aspas duplas e pode ser
uma das funcoes pre-definidas do sistema (AXPESQUI, AXVISUAL, AXINCLUI, AXALTERA e
AXDELETA) ou a chamada de um EXECBLOCK. Ao utilizar a funcao AXDELETA, deve-se
declarar a variavel CDELFUNC, contendo uma expressao logica que define se o usuario
pode ou nao excluir o registro. Exemplos:
private cDelFunc := 'ExecBlock("TESTE")'
Ou
private cDelFunc := '.T.'
Ao utilizar chamada de EXECBLOCKs, as aspas simples devem estar SEMPRE por fora.
<TIPO>      - Identifica o tipo de rotina que sera executada. Podendo ser:
1, identifica rotina de pesquisa (n�o permite altera��es)
3, identifica rotina de inclusao, esta sera chamada continuamente ao final do
processamento, ate o acionamento de <ESC>
4, identifica rotina de altera��o, geralmente ao se usar uma chamada de EXECBLOCK

A declaracao padr�o de aRotina (abaixo), far� com que MBROWSE comporte-se como AXCADASTRO.
private cDelFunc  := ".T."
private aRotina := {;
{ "Pesquisar"    ,"AxPesqui" , 0, 1},;
{ "Visualizar"   ,"AxVisual" , 0, 2},;
{ "Incluir"      ,"AxInclui" , 0, 3},;
{ "Alterar"      ,"AxAltera" , 0, 4},;
{ "Excluir"      ,"AxDeleta" , 0, 5};
}

Notas sobre a fun��o MBROWSE.
Sintaxe: mBrowse(<nLin1>,<nCol1>,<nLin2>,<nCol2>,<Alias>,<aCampos>,<cCampo>)
Onde:
>nLin1>,...,<nCol2> - Coordenadas dos cantos aonde o browse sera exibido.
Para seguir o padrao da AXCADASTRO use sempre 6,1,22,75.
Na plataforma Windows, o browse sera exibi do sempre na janela ativa. Caso nenhuma
esteja ativa no momento, ele sera exibido na janela do proprio SIGAADV.
>Alias>                  - Alias do arquivo a ser exibido.
>aCampos>                - Lista multidimensional com os campos a serem exibidos
no browse. Se nao informado, todos os campos definidos no dicionario de dados ser�o
exibidos. Para arquivos de trabalho, faz-se obrigat�rio.
Cada elemento, indica uma coluna e possue o formato:
private aCampos := {
{<CAMPO>,<DESCRICAO>}[,...];
}
Onde:
<CAMPO>           - Nome do campo
<DESCRICAO>       - T�tulo da coluna
<cCampo>                  - Nome do campo (entre aspas) que sera usado como ""flag"".
Se o campo estiver preenchido, o registro ficara em destaque.
------------------------------------------------------------------------------------------*/

user function KMCFGA05()
//-- vari�veis -------------------------------------------------------------------------

//Trabalho/apoio

local cFilQuery := "UA_CODCANC = ' ' AND UA_OPER = '1'"

//Indica a permiss�o ou n�o para a opera��o (pode-se utilizar 'ExecBlock')
private cDelFunc := ".F." // Operacao: EXCLUSAO
private cCadastro := "Or�amentos p/ Bloqueio" //T�tulo das opera��es
private aRotina := {} //Op�oes de opera��es
private aCores	:= {}
//-- procedimentos ---------------------------------------------------------------------

aAdd( aRotina,{'Bloqueio','U_KMFRA06()',0,4,0,NIL})

aCores := {	{"(Empty(SUA->UA_DOC))  .AND. VAL(SUA->UA_PEDPEND) <> 2", "BR_VERDE"   },; // Faturamento - VERDE
			{"(!Empty(SUA->UA_DOC)) .AND. VAL(SUA->UA_PEDPEND) <> 2", "BR_VERMELHO"},; // Faturado - VERMELHO
   			{"(Empty(SUA->UA_DOC))  .AND. VAL(SUA->UA_PEDPEND) == 2", "BR_VIOLETA"	}} // Bloqueado - Violeta
   			



chkFile("SUA")
dbSelectArea("SUA")
SUA->(dbSetOrder(1))

mBrowse( 6, 1, 22, 75,"SUA",,,,,,aCores,,,,,,,,cFilQuery)

//-- encerramento ----------------------------------------------------------------------

return

//-------------------------------------------------------------------------------------------
// Gerado pelo assistente de c�digo do TDS tds_version em 02/10/2018 as 20:34:52
//-- fim de arquivo--------------------------------------------------------------------------

