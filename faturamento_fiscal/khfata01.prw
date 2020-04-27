#include 'totvs.ch'
#include 'protheus.ch'

//--------------------------------------------------------------
/*/{Protheus.doc} KHFATA01
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 02/01/2019 /*/
//--------------------------------------------------------------
User Function KHFATA01()

	Local cAlias := "ZKG"
	Local cTitulo := "Amarração de Categoria X Kits "
	Local cVldExc := "U_KHFATAEX(ZKG->ZKG_CATEGO, ZKG->ZKG_CODKIT)" //Validação na Exclusão
	Local cVldOk := "U_KHFATAIN(M->ZKG_CATEGO, M->ZKG_CODKIT)" //Validação na Inclusão
	
	AxCadastro(cAlias, cTitulo, cVldExc, cVldOk)
	
return 

//--------------------------------------------------------------
/*/{Protheus.doc} KHFATAEX
Description //Validação de Exclusão
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 02/01/2019 /*/
//--------------------------------------------------------------
User Function KHFATAEX(cCategoria,cCodKit)

    Local lRet := .F.

    if MsgYesNo("Deseja mesmo excluir o cadastro (categoria:" + cCategoria + " Kit: "+ cCodKit + " )." )
        lRet := .T.
    endif

Return lRet

//--------------------------------------------------------------
/*/{Protheus.doc} KHFATAIN
Description //Validação na Inclusão
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 02/01/2019 /*/
//--------------------------------------------------------------
User Function KHFATAIN(cCategoria,cCodKit)

    Local lRet := .T.
    
    if ALTERA
        Return lRet
    endif

    dbSelectArea("ZKG")
    ZKG->(dbSetOrder(1))

    if ZKG->(dbSeek(Xfilial() + cCategoria + cCodKit))
        msgAlert("O codigo "+ cCategoria +" + "+ cCodKit + " ja existe!!!","Atenção")
        lRet := .F.
    endif
    

Return lRet