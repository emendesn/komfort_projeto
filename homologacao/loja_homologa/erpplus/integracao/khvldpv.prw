#include 'protheus.ch'
#include 'parmtype.ch'
#Include 'TopConn.Ch'
#Include 'TbiConn.ch'


/*/{Protheus.doc} KHVLDPV
//TODO: Validar os pedidos recebidos do e-comerce. 
 		Isso fará com que saiam da lista de novos.
@author ERPPLUS - Rafael S.Silva
@since 24/05/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
user function KHVLDPV()

	Local oPedido    := WSPedidoKH():New()
	Local cQuery	 := ""
	Local nLoja		 := 0
	Local cA1		:= ""
	Local cA2		:= ""
	
	cA1		:= ALLTRIM(GETNEWPAR("KH_A1KEYWS","D39243EF-5943-4378-A3EB-AA3D58865678"))
	cA2		:= ALLTRIM(GETNEWPAR("KH_A2KEYWS","39132A70-1622-43D5-AABD-B504DC924D26"))	
			
	DbSelectArea("Z12")
	
	cQuery := "SELECT Z12_PEDERP, Z12_PEDECO, R_E_C_N_O_ RECNO FROM "+RetSqlName("Z12")+" (NOLOCK) "
	cQuery += "  WHERE Z12_FILIAL = '"+xFilial("Z12")+"' "
	cQuery += "  AND Z12_VALID = 'S' AND D_E_L_E_T_ = ' '  "
	
	If Select("Z12TMP") > 0
		Z12TMP->(DbCloseArea())
	Endif
	
	TcQuery cQuery New Alias "Z12TMP"
	
	Z12TMP->( DbGoTop() )
	
	While .Not. Z12TMP->( Eof() )
	
         //Validar(<nLoja>,<cPedidoEcom>,<cPedidoErp>)
		If oPedido:Validar(nLoja,Val(Z12TMP->Z12_PEDECO),"",cA1,cA2)
			if oPedido:oWsValidarResult:nCodigo == 1
				
				Z12->(DbGoTo(Z12TMP->RECNO))
				
				RecLock("Z12",.F.)
				
				Z12->Z12_DTINT	:= dDataBase
				Z12->Z12_HRINT	:= Time()
				Z12->Z12_VALID	:= 'N'
				
				
				Z12->( MsUnlock() )
				
			Else
				U_KHLOGWS("Z12",dDataBase,Time(),"[Validar]" + oPedido:oWsValidarResult:cDescricao +"- KHCLDPV","SITE")//GRAVA NA TABELA DE LOG		

				Conout("Erro na Integração" + CRLF + ;
				oPedido:oWsValidarResult:cDescricao)		
							
			Endif
		Else
			U_KHLOGWS("Z12",dDataBase,Time(),"[Validar] Erro ao consumir WebService, favor verificar dados informados - KHCLDPV","SITE")//GRAVA NA TABELA DE LOG		
		Endif
		
		Z12TMP->( DbSkip() )
		
	EndDo		
	
Z12TMP->(DbCloseArea())
return

User Function JOBVLDPV(_cEmp, _cFil)

	Default _cEmp := "01"
	Default _cFil := "0142"


	RPCClearEnv()
	RPCSetType(3)
	PREPARE ENVIRONMENT EMPRESA _cEmp FILIAL _cFil TABLES "Z06,SB1,SB2,ZKC,ZKD,ZKG,Z07,Z08,Z11,Z12" MODULO "EST"

	U_KHVLDPV()
	RESET ENVIRONMENT
Return