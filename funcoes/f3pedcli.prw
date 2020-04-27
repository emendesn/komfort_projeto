#include 'totvs.ch'
#include 'protheus.ch'

//--------------------------------------------------------------
/*/{Protheus.doc} fAtuMsg
Description //CONSULTA PADRÃO DOS PEDIDO DO CLIENTE POSICIONADO
@param xParam Parameter Description
@return xRet Return C5_MSFIL, C5_NUM
@author  - Alexis Duarte
@since 16/10/2018
/*/
//--------------------------------------------------------------
User Function F3PEDCLI() 

    Local cFilter := ""

    if INCLUI
        cFilter += "@#SC5->C5_CLIENTE == '"+LEFT(ALLTRIM(M->UC_CHAVE),6)+"' .AND. SC5->C5_LOJACLI == '"+iif(len(ALLTRIM(M->UC_CHAVE))==7,RIGHT(ALLTRIM(M->UC_CHAVE),1),RIGHT(ALLTRIM(M->UC_CHAVE),2))+"' .AND. SC5->C5_01TPOP == '1'@#"
    else
        cFilter += "@#SC5->C5_CLIENTE == '"+LEFT(ALLTRIM(SUC->UC_CHAVE),6)+"' .AND. SC5->C5_LOJACLI == '"+iif(len(ALLTRIM(SUC->UC_CHAVE))==7,RIGHT(ALLTRIM(SUC->UC_CHAVE),1),RIGHT(ALLTRIM(SUC->UC_CHAVE),2))+"' .AND. SC5->C5_01TPOP == '1'@#"
    endif

Return(cFilter)

