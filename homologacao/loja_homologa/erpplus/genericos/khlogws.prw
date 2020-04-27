//--------------------------------------------------------------
/*/{Protheus.doc} KHLOGWS
Description //Grava o log de erros
@param xParam Parameter Description
@return 
@author  - Rafael S.Silva
@since: 02-08-2019 /*/
//--------------------------------------------------------------
User Function KHLOGWS(cAlias,dData,cHora,cErro,cTipo)

DbSelectArea('Z14')


RecLock("Z14",.T.)
Z14->Z14_TABELA := cAlias
Z14->Z14_DATA   := dData
Z14->Z14_HORA   := cHora
Z14->Z14_ERRO   := cErro
Z14->Z14_TIPO   := cTipo
Z14->(Msunlock())


Z14->(DbCloseArea())


Return()