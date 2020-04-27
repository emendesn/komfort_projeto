#include 'rwmake.ch'
#include 'protheus.ch'
#include 'topconn.ch' 
#include 'parmtype.ch'
#Include "TBICONN.CH"

#DEFINE ENTER (Chr(13)+Chr(10))

user function KMCOB001()

Local lRet:= .T.
Local xAssunto:="KomfortHouse Sofás LTDA"
Local  cCliente := ""
Local xMail := ""
lOCAL xCopia := "wellington.raul@komforthouse.com.br"
Local cQuery := ""
Local _cAliRC := GetNextAlias()
Local dData 


//Variaveis para iniciar o ambiente                        
_cEmp 	:= "01"
_cFil 	:= "0101"
//Define ambiente
RpcSetType(3)
PREPARE ENVIRONMENT EMPRESA _cEmp FILIAL _cFil MODULO "FIN"

  cQuery := " SELECT E1_NUM ,E1_PREFIXO,E1_VENCTO,E1_PARCELA,A1_NOME,E1_CPFCNPJ,E1_TIPO,A1_EMAIL"+ENTER
  cQuery += " FROM SE1010 (NOLOCK) SE1"+ENTER
  cQuery += " INNER JOIN SA1010 (NOLOCK) SA1"+ENTER
  cQuery += " ON SA1.A1_COD = SE1.E1_CLIENTE"+ENTER
  cQuery += " WHERE E1_EMISSAO >= '20180903'"+ENTER
  cQuery += " AND E1_TIPO IN ('BOL','CHK')"+ENTER
  cQuery += " AND SE1.D_E_L_E_T_ = '' "+ENTER
  cQuery += " AND E1_BAIXA = ''"+ENTER
  cQuery += " AND E1_VENCTO  BETWEEN GETDATE() AND GETDATE()+2"+ENTER
  cQuery += " AND E1_XENMAIL <> 1"+ENTER
  cQuery += " AND A1_XENMAIL <> 1"+ENTER


	If Select(_cAliRC) > 0
		(_cAliRC)->(DbCloseArea())
	EndIf                                                                                                                                                                                                                                  
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),_cAliRC,.T.,.T.)
	
	(_cAliRC)->(DbGoTop())
	While (_cAliRC)->(!EOF())    
			DbSelectArea('SE1')
			SE1->(DbSetOrder(1))//E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, R_E_C_N_O_, D_E_L_E_T_
				If  SE1->(DbSeek(xFilial()+(_cAliRC)->E1_PREFIXO+(_cAliRC)->E1_NUM+(_cAliRC)->E1_PARCELA+(_cAliRC)->E1_TIPO))
				RecLock("SE1", .F.)
				SE1->E1_XENMAIL := 1
				cCliente := SE1->E1_NOMCLI
				dData := SE1->E1_VENCTO
				xMail := (_cAliRC)->A1_EMAIL
				xMsg:= {"Prezado (a) "+ cCliente + " Gostariamos de lembra-lo que "+ dtoc(dData) +" vence a parcela da sua compra."}
				u_MailCobK(xMail,xCopia,xAssunto,xMsg,{},.T.)
				MsUnLock()
				EndIf				
		(_cAliRC)->(DbSkip())                                                                   	
	EndDo
	(_cAliRC)->(DbCloseArea())
Return lRet
