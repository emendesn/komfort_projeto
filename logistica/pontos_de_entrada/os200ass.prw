//--------------------------------------------------------------
/*/{Protheus.doc} OS200ASS
Description //Permite executar rotinas especificas após associar veiculo na montagem de cargas
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 05/06/2019 /*/
//--------------------------------------------------------------
User Function OS200ASS()

    Local cCarga      := DAK->DAK_COD
    Local cMotorista  := DAK->DAK_MOTORI
    Local cQuery := ""
    Local cAlias := getNextAlias()
    Local cNomeMotor := ""

    DbSelectArea("ZK0")

    DbSelectArea("DA4")
    DA4->(DbSetOrder(1))

    if DA4->(dbSeek(xFilial()+cMotorista))
        cNomeMotor := DA4->DA4_NOME
    Endif

    cQuery := "SELECT R_E_C_N_O_ AS RECNO FROM "+ retSqlName("ZK0")
    cQuery += " WHERE ZK0_CARGA = '"+ cCarga +"'"
    cQuery += " AND D_E_L_E_T_ = ''"

    PLSQuery(cQuery, cAlias)

    while (cAlias)->(!eof())

        	ZK0->(DbGoTop())
            ZK0->(DbGoTo((cAlias)->RECNO))
            
            RecLock("ZK0",.F.)
            
                ZK0->ZK0_CODMOT := cMotorista
                ZK0->ZK0_NOMMOT := cNomeMotor
            
            ZK0->(MsUnlock())

        (cAlias)->(dbSkip())
    end
    


Return 