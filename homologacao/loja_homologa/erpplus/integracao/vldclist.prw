#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "TOPCONN.CH"
#Include 'TbiConn.ch'



/*/{Protheus.doc} VLDCLIST
//TODO: Validar clientes do E-Commerce para 
		retirar da lista de novos.
@author ERPPLUS
@since 30/05/2019
@version 1.0
@return Nil
@param aPrepEnv, array, description
@type function
/*/
User function VLDCLIST()

	Local cQuery	:= ""
	Local oCliente	:= Nil
	Local cA1		:= ""
	Local _lInJob   := .F.
	Local cA2		:= ""
	Local cMensagem := ""
	
	cA1		:= ALLTRIM(GETNEWPAR("KH_A1KEYWS","D39243EF-5943-4378-A3EB-AA3D58865678"))
	cA2		:= ALLTRIM(GETNEWPAR("KH_A2KEYWS","39132A70-1622-43D5-AABD-B504DC924D26"))	
	
	//Instancia do Client WS
	oCliente := WSClienteKh():New()
	
	cQuery += CRLF +  "SELECT Z11_CODIGO, Z11_EMAIL,R_E_C_N_O_ RECNO" 
	cQuery += CRLF +  "  FROM "+RetSqlName("Z11")+" (NOLOCK)  " 
	cQuery += CRLF +  "WHERE Z11_FILIAL = '"+xFilial("Z11")+"' AND " 
	cQuery += CRLF +  "  Z11_INTEG = '1' AND Z11_CADCLI = 'S' " 
	cQuery += CRLF +  "  AND D_E_L_E_T_ = ' ' " 
	
	If Select("TZ11") > 0
		TZ11->(DbCloseArea())		
	EndIf
	
	MemoWrite("TZ11.SQL",cQuery)
	
	TcQuery cQuery New Alias "TZ11"
	
	If .Not. ( TZ11->( Eof() ))
	
		While .Not. ( TZ11->( Eof() ))
			
			If oCliente:Validar(0,AllTrim(TZ11->Z11_EMAIL),TZ11->Z11_CODIGO,cA1,cA2)
			   If oCliente:oWSValidarResult:nCodigo == 1
			   
			   		Z11->(DbGoTo(TZ11->RECNO))
			   		
			   		RecLock("Z11",.F.)
			   		
			   		Z11->Z11_DTINT := dDataBase
			   		Z11->Z11_HRINT := Time()
			   		Z11->Z11_CNTST  := "1"
			   		Z11->Z11_INTEG  := "2"
			   		Z11->(MsUnlock())
			   		
			   Else
			   		U_KHLOGWS("Z11",dDataBase,Time(),oCliente:oWsValidarResult:cDescricao,"SITE")//GRAVA NA TABELA DE LOG		

			   		MsgInfo("Erro na Integração" + CRLF + ;
					oCliente:oWsValidarResult:cDescricao,"ERRO_WS")
					
					Conout("Erro na Integração" + CRLF + ;
					oCliente:oWsValidarResult:cDescricao)	

					U_KHLOGWS("Z11",dDataBase,Time(),"[Validar]- "+oCliente:oWsValidarResult:cDescricao+" - VLDCLIST","SITE")
					
					Conout("Cliente: " + Z11->CODIGO)
					Conout("Loja: " + Z11->LOJA)
					Conout("DATA: " + DTOS(dDataBase) )
					Conout("HORA" + cValToChar( Time() ) + CRLF)
			   Endif
			Else
				U_KHLOGWS("Z11",dDataBase,Time(),"[Validar]- Erro ao consumir WebService, favor verificar dados informados - KHVLPVST","SITE")
			Endif
			
			TZ11->( DbSkip() )
			
		Enddo
	Else
		cMensagem := "Nenhum cliente pendente de validação!" + CRLF
		cMensagem += "DATA: " + DTOC(dDataBase) + CRLF
		cMensagem += "HORA" + cValToChar( Time() ) 

		MsgInfo(cMensagem,"VLDCLIST")
		Conout(cMensagem)
		
	Endif		
	
TZ11->(DbCloseArea())		

Return


/*/{Protheus.doc} JOBVLDCLI
//TODO: JOB para validação de clientes do E-Commerce.
@author ERPPLUS
@since 30/05/2019
@version 1.0
@return Nil
@type function
/*/

User Function JOBVLDCLI()

	Default _cEmp := "01"
	Default _cFil := "0142"

	RPCClearEnv()
	RPCSetType(3)
	PREPARE ENVIRONMENT EMPRESA _cEmp FILIAL _cFil TABLES "Z06,SB1,SB2,ZKC,ZKD,ZKG,Z07,Z08,Z11,Z12" MODULO "EST"

	U_VLDCLIST()

	RESET ENVIRONMENT
Return 