#include 'totvs.ch'
#include 'protheus.ch'

//--------------------------------------------------------------
/*/{Protheus.doc} KHFATA01
Description //Descri��o da Fun��o
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 02/01/2019 /*/
//--------------------------------------------------------------
User Function KHFATA01()

	Local cAlias := "ZKG"
	Local cTitulo := "Amarra��o de Categoria X Kits "
	Local cVldExc := "U_KHFATAEX(ZKG->ZKG_CATEGO, ZKG->ZKG_CODKIT)" //Valida��o na Exclus�o
	Local cVldOk := "U_KHFATAIN(M->ZKG_CATEGO, M->ZKG_CODKIT)" //Valida��o na Inclus�o
	
	AxCadastro(cAlias, cTitulo, cVldExc, cVldOk)
	
return 

//--------------------------------------------------------------
/*/{Protheus.doc} KHFATAEX
Description //Valida��o de Exclus�o
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
Description //Valida��o na Inclus�o
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
        msgAlert("O codigo "+ cCategoria +" + "+ cCodKit + " ja existe!!!","Aten��o")
        lRet := .F.
    endif
    

Return lRet