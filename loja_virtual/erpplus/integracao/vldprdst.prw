#include 'protheus.ch'
#include 'parmtype.ch'
#Include 'TopConn.Ch'
#Include 'TbiConn.ch'



/*/{Protheus.doc} VLDPRDST
//TODO: Atualiza status do poduto no site.
@author Rafael S.Silva 
@since 23/05/2019
@version 1.0
@return Nil
@param aPrepEnv, array, 
		description :Array com os dados do ambiente
@type function
/*/
user function VLDPRDST()

	Local oProduto	:= Nil
	Local cA1		:= ""
	Local cA2		:= ""
	Local cQuery    := ""
	Local cErro     := ""
	Local nLoja		:= 0 //VERIFICAR A NECESSIDADE DE CRIAR PARAMETRO MV_???????
	
	//Chaves de acesso ao WebService
	cA1		:= ALLTRIM(GETNEWPAR("KH_A1KEYWS","D39243EF-5943-4378-A3EB-AA3D58865678"))
	cA2		:= ALLTRIM(GETNEWPAR("KH_A2KEYWS","39132A70-1622-43D5-AABD-B504DC924D26"))
	
	oProduto := KHWSProduto():New()	//Cria instancia de comunicação com o e-commerce	
	
	cQuery += CRLF + "SELECT Z06_PRODUT, Z06_R_E_C_N_O_ Z06RECNO"
	cQuery += CRLF + "FROM "+RetSqlName("Z06")+" Z06 "
	cQuery += CRLF + "INNER JOIN "+RetSqlName("ZKC")+" KC ON "  
	cQuery += CRLF + "		ZKC_SKU = Z06_PRODUT AND KC.D_E_L_E_T_ = ' ' " 
	cQuery += CRLF + "WHERE Z06_INTEG = 'S' AND Z06.D_E_L_E_T_ = ' ' "
	
	if select("TSZ06") > 0
		TSZ06->(DbCloseArea())
	Endif

	TcQuery cQuery New Alias "TSZ06"

	//processa o status de cada produto e envia para o site.
	Do While !(TSZ06->(Eof()))
		
			//AlterarStatus(<nLoja>,<cCodigoProduto>,<nStatus>)
		If oProduto:AlterarStatus(nLoja,AllTrim(TSZ06->Z06_PRODUT),Val(TSZ06->Z06_STATUS))
			If oProduto:oWSAlterarStatusResult:nCodigo == 1

				If Z06->(DbSeek(xFilial("Z06") + TSZ06->Z06_PRODUT ))

					Z06->(Reclock("Z06",.F.))

					Z06->Z06_DTINTE := dDataBase
					Z06->Z06_HRINTE := Time()
					Z06->Z06_INTEG  := "N"

					Z06->(MsUnclock())

				Endif
			Else

				U_KHLOGWS("Z06",dDataBase,Time(),"[SalvarStatus] "+oProduto:oWSAlterarStatusResult:cDescricao +"- VLDPRDST","SITE")//GRAVA NA TABELA DE LOG				
				
				Conout("Erro na Integração" + CRLF + ;
				oProduto:oWSAlterarStatusResult:cDescricao)			
			Endif			
		Else
			cErro := "[SalvarStatus] VALIDACAO DE PRODUTO - Erro na requisição do serviço, verificar os dados de acesso ao webService - VLDPRDST"
			U_KHLOGWS("Z06",dDataBase,Time(),cErro,"SITE")//GRAVA NA TABELA DE LOG		
		Endif
		
		TSZ06->( DbSkip() )
	EndDo

TSZ06->(DbCloseArea())

Return

User Function JOBVLPST(_cEmp, _cFil)

	Default _cEmp := "01"
	Default _cFil := "0142"


	RPCClearEnv()
	RPCSetType(3)
	PREPARE ENVIRONMENT EMPRESA _cEmp FILIAL _cFil TABLES "Z06,SB1,SB2,ZKC,ZKD,ZKG,Z07,Z08,Z11,Z12" MODULO "EST"

	U_VLDPRDST()
	RESET ENVIRONMENT
Return
