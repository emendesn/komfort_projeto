#include 'protheus.ch'
#include 'parmtype.ch'
#Include 'TopConn.Ch'
#Include 'TbiConn.ch'

//--------------------------------------------------------------
/*/{Protheus.doc} KHCATEG
Description //Envia categorias de produtos para o site
@param xParam Parameter Description
@return xRet Return Description
@author  - Rafael S.Silva
@since: 01-08-2019 /*/
//--------------------------------------------------------------

User function KHCATEG()

	Local oCategoria := WSCategoriaKh():New()
	
	Local cQuery	:= ""
	
	Local nLoja 	:= 0
	Local cCodCateg := ""
	Local cNomeCat 	:= "" 
	Local nStatus 	:= 0
	Local cA1		:= ""
	Local cA2		:= ""
	Local cErro     := ""
	
	cA1		:= ALLTRIM(GETNEWPAR("KH_A1KEYWS","D39243EF-5943-4378-A3EB-AA3D58865678"))
	cA2		:= ALLTRIM(GETNEWPAR("KH_A2KEYWS","39132A70-1622-43D5-AABD-B504DC924D26"))
	
	cQuery := "SELECT * FROM "+ RetSqlName("Z09") +" " + CRLF
	cQuery += "WHERE Z09_INTEG = 'S' AND D_E_L_E_T_ = ' ' "
	
	MemoWrite("KHCATEG.SQL",cQuery)
	
	If Select("TZ09") > 0
		TZ09->(DbCloseArea())
	Endif
	
	TcQuery cQuery New Alias "TZ09"
	
	DbSelectArea("Z09")
	Z09->(DbSetorder(1))
			
	While !(TZ09->(Eof())) 
		cCodCateg := TZ09->Z09_COD
		cNomeCat  := TZ09->Z09_DESC
		nStatus   := Val(TZ09->Z09_STATUS)
		
		If oCategoria:Salvar(nLoja,cCodCateg,cNomeCat,nStatus,,cA1,cA2)
			If oCategoria:oWSSalvarResult:nCodigo == 1
				Conout("Categoria cadastrada no E-Commerce")

				U_KHLOGWS("Z09",dDataBase,Time(),oCategoria:oWSSalvarResult:cDescricao,"SITE")//GRAVA NA TABELA DE LOG

				If	Z09->( DbSeek(xFilial("Z09") + TZ09->Z09_COD  ) )
					Z09->(RecLock("Z09"),.F.)
					
					Z09->Z09_INTEG := "N"
					Z09->Z09_DTALT := dDataBase
					Z09->Z09_HRALT := Time()
					
					Z09->(MsUnlock())
				EndIf
				
			Else
				Conout("Erro na Integração "+ CRLF + ;
						oCategoria:oWSSalvarResult:cDescricao)			
				
				U_KHLOGWS("Z09",dDataBase,Time(),oCategoria:oWSSalvarResult:cDescricao + " KHCATEG","SITE")//GRAVA NA TABELA DE LOG
			Endif
		Else

			cErro := "CATEGORIAS - Erro na requisição do serviço, verificar os dados de acesso ao webService"
			U_KHLOGWS("Z09",dDataBase,Time(),cErro,"SITE")//GRAVA NA TABELA DE LOG

		Endif
		
		TZ09->(DbSkip())
	Enddo
	
	
	RESET ENVIRONMENT

Return


User Function KHJOBCTG(_cEmp, _cFil)

	Default _cEmp := "01"
	Default _cFil := "0142"


	RPCClearEnv()
	RPCSetType(3)
	PREPARE ENVIRONMENT EMPRESA _cEmp FILIAL _cFil TABLES "Z06,SB1,SB2,ZKC,ZKD,ZKG,Z07,Z08,Z11,Z12" MODULO "EST"

	U_KHCATEG()

	RESET ENVIRONMENT
Return 