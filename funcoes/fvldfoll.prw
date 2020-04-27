//--------------------------------------------------------------
/*/{Protheus.doc} FVLDFOLL
Description //Valida a quantidade de Follow Ups agendados em determinada data por usuario atraves do parametro KH_LIMITF
Description //Bloqueia o agendamento de Follow Ups nos dias da semana definidos no parametro KH_BLQDT
@author  - Everton Santos
@since 26/06/2019 /*/
//--------------------------------------------------------------

#include 'protheus.ch'
#include 'parmtype.ch'
#DEFINE ENTER (Chr(13)+Chr(10))

user function FVLDFOLL(_dData)

Local _lRet    := .T.
Local cAlias   := GetNextAlias()
Local _cQuery  := ''
Local _nQtdAg  := 0
Local _cLimitF := SUPERGETMV("KH_LIMITF", .T.,"15")
Local _cBlqDt  := SUPERGETMV("KH_BLQDT", .T.,"1,2,7")
Local _aBlqDt  := StrtokArr(_cBlqDt, ",")
Private cUser  := LogUserName()

For nx := 1 to len(_aBlqDt) 
	If Val(_aBlqDt[nx]) == DOW(_dData)
		MsgAlert("Não é possivel agendar Visita Técnica para este dia da semana! Por gentileza, selecione outra data")
	    return .F.
	EndIf
next nx

/*
	dbSelectArea("SUD")
	 
    cQuery := " SELECT ISNULL(COUNT(DISTINCT UC_CODIGO),0) AS QTDAG"+ ENTER
    cQuery += " FROM "+ retSqlName("SUD")+ " SUD"+ ENTER
    cQuery += " INNER JOIN "+ retSqlName("SUC")+ " SUC ON UC_FILIAL = UD_FILIAL AND UC_CODIGO = UD_CODIGO "+ ENTER
    cQuery += " INNER JOIN "+ retSqlName("SC5")+ " SC5 ON SUBSTRING(UC_01PED,5,10) = C5_NUM"+ ENTER 
    cQuery += " INNER JOIN "+ retSqlName("SUA")+ " SUA ON UA_NUMSC5 = C5_NUM "+ ENTER 
    cQuery += " INNER JOIN "+ retSqlName("SA3")+ " SA3 ON A3_COD = UA_VEND "+ ENTER 
    cQuery += " INNER JOIN "+ retSqlName("SU7")+ " SU7 ON U7_COD = UC_OPERADO "+ ENTER 
    cQuery += " INNER JOIN "+ retSqlName("SA1")+ " SA1 ON A1_COD + A1_LOJA = UC_CHAVE "+ ENTER 
    cQuery += " INNER JOIN "+ retSqlName("SX5")+ " SX5 ON X5_CHAVE = UD_ASSUNTO "+ ENTER 
    cQuery += " INNER JOIN "+ retSqlName("SU9")+ " SU9 ON U9_CODIGO = UD_OCORREN "+ ENTER 
    cQuery += " WHERE UD_FILIAL = '' "+ ENTER
    cQuery += " AND UC_FILIAL = '' "+ ENTER
    cQuery += " AND U7_FILIAL = '    ' "+ ENTER
    cQuery += " AND A1_FILIAL = '    ' "+ ENTER
    cQuery += " AND X5_FILIAL = '01  ' "+ ENTER
    cQuery += " AND U9_FILIAL = '    ' "+ ENTER
    cQuery += " AND UC_STATUS <> '3 ' "+ ENTER
    cQuery += " AND SUD.D_E_L_E_T_ = ' ' "+ ENTER
    cQuery += " AND SUC.D_E_L_E_T_ = ' ' "+ ENTER
    cQuery += " AND SU7.D_E_L_E_T_ = ' ' "+ ENTER
    cQuery += " AND SA1.D_E_L_E_T_ = ' ' "+ ENTER
    cQuery += " AND SA3.D_E_L_E_T_ = ' ' "+ ENTER
    cQuery += " AND SX5.D_E_L_E_T_ = ' ' "+ ENTER
    cQuery += " AND SU9.D_E_L_E_T_ = ' ' "+ ENTER
    cQuery += " AND X5_TABELA = 'T1' "+ ENTER
    cQuery += " AND UC_XSTATUS IN ('EM PROCESSO')  "+ ENTER
    cQuery += " AND UC_XFOLLOW = '"+DTOS(_dData)+"'"+ ENTER
    cQuery += " AND UD_ASSUNTO IN ('000008', '000010') "+ ENTER
   	cQuery += " AND UD_XUSER = '"+cUser+"'"+ ENTER

    PLSQuery(cQuery, cAlias)
    
	dbSelectArea(cAlias)
	_nQtdAg := (cAlias)->QTDAG
	dbCloseArea(cAlias)

  	If _nQtdAg > Val(_cLimitF)  -- retirada validação para o preenchimento do campo pelo SAC
		MSGALERT("Limite diario de " +_cLimitF+ " Follow Ups atingido. Por gentileza, selecione outra data.","Quantidade de Follow up")
		_lret := .F.
	Else
		MSGALERT("Voce possui  " +CValToChar(_nQtdAg)+ "  Follow Ups agendados para "+ DTOC(_dData),"Quantidade de Follow up")
	EndIf 
	*/                                                         
                                                               
return _lRet