#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#include "TOPCONN.CH"

//--------------------------------------------------------------
/*/{Protheus.doc} KHSACA01
Description //Cadastro de informa��es complementares (Filiais)
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 02/01/2019 /*/
//--------------------------------------------------------------
User Function KHFINA01()

	Local cAlias := "ZK9"
	Local cTitulo := "Cadastro Informa��es Complementares - Filiais"
	Local cVldExc := "U_KHFINA02(M->ZK9_COD)" //Valida��o na Exclus�o
	Local cVldOk := "U_KHFINA03(M->ZK9_COD)" //Valida��o na Inclus�o
	
	AxCadastro(cAlias, cTitulo, cVldExc, cVldOk)
	
return 

//--------------------------------------------------------------
/*/{Protheus.doc} KHSACAEX
Description //Valida��o de Exclus�o
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 02/01/2019 /*/
//--------------------------------------------------------------
User Function KHFINA02(cCod)   

    Local lRet := .F.

    if MsgYesNo("Deseja mesmo excluir o cadastro " + cCod )
        lRet := .T.
    endif

Return lRet

//--------------------------------------------------------------
/*/{Protheus.doc} KHSACAIN
Description //Valida��o na Inclus�o
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 02/01/2019 /*/
//--------------------------------------------------------------
User Function KHFINA03(cCod)   

    Local lRet := .T.
    
    if ALTERA
        Return lRet
    endif

    dbSelectArea("ZK9")
    ZK9->(dbSetOrder(1))

    if ZK9->(dbSeek(Xfilial()+cCod))
        msgAlert("O codigo "+ cCod + " ja existe!!!","Aten��o")
        lRet := .F.
    endif
    

Return lRet