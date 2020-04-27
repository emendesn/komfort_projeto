//--------------------------------------------------------------
/*/{Protheus.doc} KHSACA01
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 02/01/2019 /*/
//--------------------------------------------------------------
User Function KHSACA01()

	Local cAlias := "Z05"
	Local cTitulo := "Motivos de Cancelamento - Pedidos Venda"
	Local cVldExc := "U_KHSACAEX(M->Z05_COD)" //Validação na Exclusão
	Local cVldOk := "U_KHSACAIN(M->Z05_COD)" //Validação na Inclusão
	
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
User Function KHSACAEX(cCod)   

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
User Function KHSACAIN(cCod)   

    Local lRet := .T.
    
    if ALTERA
        Return lRet
    endif

    dbSelectArea("Z05")
    Z05->(dbSetOrder(1))

    if Z05->(dbSeek(Xfilial()+cCod))
        msgAlert("O codigo "+ cCod + " ja existe!!!","Atenção")
        lRet := .F.
    endif
    

Return lRet