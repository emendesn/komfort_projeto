#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#include "TOPCONN.CH"

//--------------------------------------------------------------
/*/{Protheus.doc} KHSACA01
Description //Cadastro de informações complementares (Filiais)
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 02/01/2019 /*/
//--------------------------------------------------------------
User Function KHFINA01()

	Local cAlias := "ZK9"
	Local cTitulo := "Cadastro Informações Complementares - Filiais"
	Local cVldExc := "U_KHFINA02(M->ZK9_COD)" //Validação na Exclusão
	Local cVldOk := "U_KHFINA03(M->ZK9_COD)" //Validação na Inclusão
	
	AxCadastro(cAlias, cTitulo, cVldExc, cVldOk)
	
return 

//--------------------------------------------------------------
/*/{Protheus.doc} KHSACAEX
Description //Validação de Exclusão
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
Description //Validação na Inclusão
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
        msgAlert("O codigo "+ cCod + " ja existe!!!","Atenção")
        lRet := .F.
    endif
    

Return lRet