#include "totvs.ch"

//--------------------------------------------------------------
/*/{Protheus.doc} CLASSE KHSACX01
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 17/01/2019 /*/
//--------------------------------------------------------------
CLASS KHSACX01

    DATA cChamado
    DATA aAObs
    
    METHOD NEW( cChamado, aAObs ) CONSTRUCTOR
    METHOD DELETE()
    METHOD CORRIGE()
    METHOD ADD()

ENDCLASS

//--------------------------------------------------------------
/*/{Protheus.doc} NEW
Description //METODO CONSTRUTOR
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 17/01/2019 /*/
//--------------------------------------------------------------
Method NEW( cChamado, aAObs ) CLASS KHSACX01

    local aArea := getarea()
	Local ctxtRet := ""
    Local aPar := {}
	Local aRet := {}

    Default aAObs := {}
    
    ::aAObs := aAObs

    aAdd(aPar,{1,"Atendimento (Chamado)" ,CriaVar("UC_CODIGO",.F.),PesqPict("SUC","UC_CODIGO")," ",,, 30,.T.})

    If ParamBox(aPar,"Chamado",@aRet)
		ctxtRet := aRet[01]
		
		dbselectarea("SUC")
		dbsetorder(1) //UC_FILIAL, UC_CODIGO, R_E_C_N_O_, D_E_L_E_T_
	
		if dbseek(xFilial("SUC")+ctxtRet)
            ::cChamado := ctxtRet
		else
			msgalert("Atendimento (Chamado) "+ ctxtRet +" não existe!!")
			::cChamado := ""
		endif

	Else
		::cChamado := ""
	EndIf

    restArea(aArea)

Return

//--------------------------------------------------------------
/*/{Protheus.doc} METODO DELETE
Description //Deleta todos os registros
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 17/01/2019 /*/
//--------------------------------------------------------------
METHOD DELETE() CLASS KHSACX01

    cUpdate := ""

    //DELETA OS REGISTROS
    cUpdate := "UPDATE SYP010 SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_"
    cUpdate += " WHERE YP_CHAVE = (SELECT UC_CODOBS FROM "+ RetSqlName("SUC") 
    cUpdate += "                  WHERE UC_CODIGO = '"+ ::cChamado +"')"

    nStatus := TcSqlExec(cUpdate)
				
	if (nStatus < 0)
		msgAlert("Erro ao executar o update: " + TCSQLError(),"Atenção")
	else
        msgInfo("Registros Deletados com Sucesso", "Atenção")
    endif

Return

//--------------------------------------------------------------
/*/{Protheus.doc} METODO CORRIGE
Description //Corrige a sequencia da tabela SYP
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 17/01/2019 /*/
//--------------------------------------------------------------
METHOD CORRIGE() CLASS KHSACX01

    cAlias := getNextAlias()
    cQuery := ""
    nQtdReg := 1
    
    //RETORNA TODOS OS REGISTROS
    cQuery := "SELECT * FROM "+ retSqlName("SYP")
    cQuery += " WHERE YP_CHAVE = (SELECT UC_CODOBS FROM "+retSqlName("SUC")
    cQuery += "                   WHERE UC_CODIGO = '"+ ::cChamado +"')"
    cQuery += " ORDER BY YP_CHAVE, R_E_C_N_O_,YP_SEQ"

    PLSQuery(cQuery, cAlias)

    dbselectarea("SYP")
    SYP->(dbSetOrder(1))

    //Desabilta os registros deletados
    SET DELETED OFF 
    
    while (cAlias)->(!eof())

        //Posicione no registro Pelo Recno
        dbGoto((cAlias)->R_E_C_N_O_)

        recLock( "SYP", .F. )
            SYP->YP_SEQ := strZero(nQtdReg,3)
        msUnLock()

        nQtdReg++
    
    (cAlias)->(dbSkip())
    end

    //Habilita os registros deletados
    SET DELETED ON

    SYP->(dbCloseArea())

    restArea(aArea)

return

//--------------------------------------------------------------
/*/{Protheus.doc} METODO ADD
Description //Retorna todos os registros
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 17/01/2019 /*/
//--------------------------------------------------------------
METHOD ADD() CLASS KHSACX01

    Local cUpdate := ""
    
    //VOLTAR O REGISTRO
    cUpdate := "UPDATE SYP010 SET D_E_L_E_T_ = '', R_E_C_D_E_L_ = 0"
    cUpdate += " WHERE YP_CHAVE = (SELECT UC_CODOBS FROM "+ retSqlName("SUC")
    cUpdate += "                    WHERE UC_CODIGO = '"+ ::cChamado +"')"

    nStatus := TcSqlExec(cUpdate)
				
	if (nStatus < 0)
		msgAlert("Erro ao executar o update: " + TCSQLError(),"Atenção")
	else
        msgInfo("Registros Retornados com Sucesso", "Atenção")
    endif

Return


User Function AJUSTSYP()

    oAjust := KHSACX01():NEW()
    oAjust:DELETE()
    oAjust:CORRIGE()
    oAjust:ADD()

Return