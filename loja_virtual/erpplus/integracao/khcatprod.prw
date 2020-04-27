#include 'protheus.ch'
#include 'parmtype.ch'
#Include 'TopConn.Ch'
#Include 'TbiConn.ch'


//--------------------------------------------------------------
/*/{Protheus.doc} KHCATPROD
Description //Cadastra categoria de produtos no site
@param xParam Parameter Description
@return xRet Return Description
@author  - Rafael S.Silva
@since: 23-06-2019 /*/
//--------------------------------------------------------------

User function KHCATPROD()

	Local oCatProd  := WSProdutoCategoriaKh():New()
	Local cQuery	:= ""
	Local nLoja 	:= 0
	Local nProdutos := 0
	Local cCodCateg := ""
	Local cCodProd  := ""
	Local cA1		:= ""
	Local cA2		:= ""
	Local cErro		:= ""	

	
	cA1		:= ALLTRIM(GETNEWPAR("KH_A1KEYWS","D39243EF-5943-4378-A3EB-AA3D58865678"))
	cA2		:= ALLTRIM(GETNEWPAR("KH_A2KEYWS","39132A70-1622-43D5-AABD-B504DC924D26"))
	
	cQuery += CRLF +"SELECT * FROM "+ RetSqlName("Z10") +" " 
	cQuery += CRLF +"WHERE Z10_INTEG = 'S' " 
	cQuery += CRLF +" AND D_E_L_E_T_ = ' ' "
	
	MemoWrite("KHCATPROD.SQL",cQuery)
	
	If Select("TZ10") > 0
		TZ10->(DbCloseArea())
	Endif
	
	TcQuery cQuery new Alias "TZ10"
	Count To nProdutos
	
	Conout(cValToChar(nProdutos) + " Produtos encontrados!")
	
	TZ10->(DbGoTop())
	DbSelectArea("Z10")
	
	Do While !(Z10->( Eof() ) )
	
		cCodProd := ALLTRIM(TZ10->Z10_CODPRO)
		cCodCateg := ALLTRIM(TZ10->Z10_CATEGO)
		
		If oCatProd:Salvar(nLoja,cCodProd,cCodCateg,cA1,cA2)
			If oCatProd:oWSSalvarResult:nCodigo == 1 .or. (oCatProd:oWSSalvarResult:nCodigo == 0 .and. ;
				"JA EXISTENTE" $ FWNOACCENT(Upper(oCatProd:oWSSalvarResult:cDescricao)))

				If "JA EXISTENTE" $ FWNOACCENT(Upper(oCatProd:oWSSalvarResult:cDescricao))
					U_KHLOGWS("Z10",dDataBase,Time(),oCatProd:oWSSalvarResult:cDescricao,"SITE")//GRAVA NA TABELA DE LOG
				Endif
				
				Z10->(DbGoTo(TZ10->R_E_C_N_O_))//POSICIONA NO REGISTRO
				
				If Z10->(RecLock("Z10",.F.))
				
					Z10->Z10_DTINT := dDataBase
					Z10->Z10_HRINT := Time()
					Z10->Z10_INTEG := "N"
					
					Z10->( MsUnlock() )
					
				Endif
			Else

				U_KHLOGWS("Z10",dDataBase,Time(),oCatProd:oWSSalvarResult:cDescricao,"SITE")//GRAVA NA TABELA DE LOG

				Conout("Erro na Integração "+ CRLF + ;
						oCatProd:oWSSalvarResult:cDescricao)
			EndIf
		Else
			cErro := "CATEGORIAS X PRODUTOS - Erro na requisição do serviço, verificar os dados de acesso ao webService"
			U_KHLOGWS("Z10",dDataBase,Time(),cErro,"SITE")//GRAVA NA TABELA DE LOG

		Endif
		
		TZ10->(DbSkip())
	EndDo
	
Return

User Function KHCTG2JB(_cEmp, _cFil)

	Default _cEmp := "01"
	Default _cFil := "0142"

	PREPARE ENVIRONMENT EMPRESA _cEmp FILIAL _cFil TABLES "Z06,SB1,SB2,ZKC,ZKD,ZKG,Z07,Z08,Z11,Z12" MODULO "EST"
	U_KHCATPROD()

	RESET ENVIRONMENT
Return 