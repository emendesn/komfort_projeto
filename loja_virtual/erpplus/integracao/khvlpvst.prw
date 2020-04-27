#include 'protheus.ch'
#include 'parmtype.ch'
#Include 'TopConn.Ch'
#Include 'TbiConn.ch'

/*/{Protheus.doc} KHVLPVST
//TODO : Altera o status do pedido no E-Commerce.
@author ERPPLUS - Rafael S.Silva
@since 22/05/2019
@version 1.0
@return Nil

@type function
/*/
user function KHVLPVST()
	

	Local oPedido    := WSPedidoKH():New()
	Local nLoja		 := 0 // Verificar a necessidade de criar parâmetro
	Local cQuery	 := ""
	Local cA1		 := ""
	Local cA2		 := ""
	Local nStatusAtu := 6
	Local nStatusNew := 7

	cA1		:= ALLTRIM(GETNEWPAR("KH_A1KEYWS","D39243EF-5943-4378-A3EB-AA3D58865678"))
	cA2		:= ALLTRIM(GETNEWPAR("KH_A2KEYWS","39132A70-1622-43D5-AABD-B504DC924D26"))
	
	DbSelectArea("Z12")

	/*	Códigos de status do pedido de venda	
	    +--------------------------+
		|COD | DESCRICAO		   |
		+----|---------------------+
		|1 	 | Efetuado            |
		|4 	 | Problemas           |
		|5 	 | Cancelado           |
		|6 	 | AguardandoPagamento |
		|7 	 | PagamentoConfirmado |
		|8   | AnaliseRisco        |
		|17  | Despachado          |
		|92  | Entregue             |
		|99  | Troca               |
		|100 | CupomProxCompra     |
		|108 | AlterarFormaPgto    |
		+--------------------------+*/

	nStatusAtu := 6
	nStatusNew := 17
			
	cQuery := "SELECT Z12_PEDERP, Z12_PEDECO, R_E_C_N_O_ RECNO " 
	cQuery += CRLF + "  FROM "+RetSqlName("Z12")+" "
	cQuery += CRLF + "WHERE Z12_FILIAL = '"+xFilial("Z12")+"' "
	cQuery += CRLF + "  AND Z12_STPVS <> "+cValToChar(nStatusNew)+" AND D_E_L_E_T_ = ' '  "
	
	If Select("TZ12") > 0
		TZ12->(DbCloseArea())
	Endif
	
	MemoWrite("Z12_STATUS_ECOM.SQL",cQuery)
	
	TcQuery cQuery New Alias "TZ12"
	
	TZ12->( DbGoTop() )
	
	While .Not. TZ12->( Eof() )
	
		If oPedido:ValidarComStatus(nLoja,AllTrim(TZ12->Z12_PEDECO),AllTrim(TZ12->Z12_PEDERP),nStatusNew,cA1,cA2)
			if oPedido:oWsValidarResult:nCodigo == 1
				
				Z12->(DbGoTo(TZ12->RECNO))
				
				RecLock("Z12",.F.)
				
				Z12->Z12_DTINT	:= dDataBase
				Z12->Z12_HRINT	:= Time()
				Z12->Z12_STPVS	:= nStatusNew
				
				Z12->( MsUnlock() )
				
			Else
				U_KHLOGWS("Z12",dDataBase,Time(),"[Validar]- "+oPedido:oWsValidarResult:cDescricao+" - KHVLPVST","SITE")
				Conout("Erro na Integração" + CRLF + ;
				oPedido:oWsValidarResult:cDescricao)		
							
			Endif
		Else
			U_KHLOGWS("Z12",dDataBase,Time(),"[Validar]- Erro ao consumir WebService, favor verificar dados informados - KHVLPVST","SITE")
		Endif
		
		TZ12->( DbSkip() )
		
	EndDo			

return



/*/{Protheus.doc} JOBSTAPV
//TODO: Altera status do pedido no E-Commerce - JOB.
@author Rafael S.Silva
@since 30/05/2019
@version 1.0
@return Nil

@type function
/*/
User Function JOBSTAPV(_cEmp, _cFil)
	
	Default _cEmp := "01"
	Default _cFil := "0142"


	RPCClearEnv()
	RPCSetType(3)
	PREPARE ENVIRONMENT EMPRESA _cEmp FILIAL _cFil TABLES "Z06,SB1,SB2,ZKC,ZKD,ZKG,Z07,Z08,Z11,Z12" MODULO "EST"
	
	U_KHVLPVST()
	
	RESET ENVIRONMENT
Return
