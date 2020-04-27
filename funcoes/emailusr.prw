#include 'totvs.ch'
#include 'protheus.ch'

//--------------------------------------------------------------
/*/{Protheus.doc} EmailUsr
Description //Retorna o email do usuario
@param "usuario.protheus" Parameter Description Codigo do usuario
@return "usuario.protheus@hotmail.com" Return Description Email do Usuario
@author  - Alexis Duarte
@since 19/10/2018 /*/
//--------------------------------------------------------------
User Function EmailUsr(_cUserNome)

    Local aAllUsers := FWSFALLUSERS()
    Local nPosUser := 0
    Local cCodUser := ""
    Local cEmail := ""
    Local aInfo := {}

    Default _cUserNome := ""

    nPosUser := Ascan(aAllUsers,{|x| Alltrim(x[3]) == _cUserNome})
    
    if nPosUser == 0
        Conout("Usuario Não Encontrado!!!")
        Return("")
    else
        cCodUser := aAllUsers[nPosUser][2]
    endif

    PswOrder(1)
    
    if PswSeek(cCodUser,.T.)
        aInfo   	:= PswRet(1)
        cEmail 		:= Alltrim(aInfo[1,14])
    endif

Return (cEmail)
