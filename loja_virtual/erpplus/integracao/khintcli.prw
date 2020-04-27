#include 'protheus.ch'
#include 'parmtype.ch'
#include 'TopConn.Ch'
#Include 'TbiConn.ch'



/*/{Protheus.doc} KHINTCLI
//TODO: Listar novos clientes recebidos do E-Commerce.
@author Rafael S.Silva
@since 04/05/2019
@version 1.0
@return Nil
@param: 
@type function
/*/
user function KHINTCLI()
	
	Local cQuery	:= ""
	Local oCliente	:= Nil
	Local cA1		:= ""
	Local cA2		:= ""
	Local nLoja 	:= 0
	Local nCliErp	:= 0
	Local cParCod	:= ""
	Local nTipo		:= 0
	Local cNome		:= ""
	Local cSbNomePf := ""
	Local cRazao	:= ""
	Local cFantasia := ""
	Local cCGC		:= ""
	Local cRG		:= ""
	Local cIE		:= ""
	Local cIM		:= ""
	Local cDtNasc   := ""
	Local nConta    := 0
	Local cTexto1	:= ""
	Local cTexto2	:= ""
	Local cTexto3	:= ""
	Local nNumero1	:= 0
	Local nNumero2	:= 0
	Local nNumero3	:= 0
	
	cA1		:= ALLTRIM(GETNEWPAR("KH_A1KEYWS","078ecd14-64d8-40a8-9045-0705f267a262"))
	cA2		:= ALLTRIM(GETNEWPAR("KH_A2KEYWS","860ff9f1-657c-4f93-bdea-2437af2d813c"))	
	
	//Instancia do Client WS
	oCliente := WSClienteKh():New()
	
	//if nOpc == 1 //ListarNovos
		If oCliente:ListarNovos(nLoja,cA1,cA2)
		   If oCliente:oWSListarNovosResult:nCodigo == 1
		   		aClientes := oCliente:oWSListarNovosResult:oWSLista:oWsClsUsuario
		   		
		   		Z11->(DbSetOrder(2))
		   		For nAux := 1 to Len(aClientes)
		  
		   			if ( NoAcento(Upper(aClientes[nAux]:oWsConta:oWSTipo:Value)) == "PESSOAFISICA" ) //CPF
			   			
			   			
			   			If !(Z11->(DbSeek(xFilial("Z11") + aClientes[nAux]:oWsConta:cCPF)))
			   				RecLock("Z11",.T.)
			   				
			   				Z11->Z11_FILIAL := xFilial("Z11")
			   				Z11->Z11_CADCLI	:= "S"
			   				Z11->Z11_INTEG		:= "1"
			   				Z11->Z11_CGC	:= aClientes[nAux]:oWsConta:cCPF
			   				//Z11->Z11_CCONTA := aClientes[nAux]:oWsConta:cContaCodigoInterno
			   				Z11->Z11_DTNASC	:= U_CWsData(Left(aClientes[nAux]:oWsConta:CDATANASCIMENTO,At(" ", aClientes[nAux]:oWsConta:CDATANASCIMENTO)-1))
			   				Z11->Z11_INSCE  := aClientes[nAux]:oWsConta:CIE
			   				Z11->Z11_INSCM := aClientes[nAux]:oWsConta:CIM
			   				Z11->Z11_NOME  := Upper(NoAcento(aClientes[nAux]:oWsConta:CNOME))
			   				Z11->Z11_SNOME := Upper(aClientes[nAux]:oWsConta:CSOBRENOME)
			   				Z11->Z11_EMAIL	:= Upper(NoAcento(aClientes[nAux]:CEMAIL))
			   				Z11->Z11_RG    := aClientes[nAux]:oWsConta:CRG
			   				
			   				If Upper(NoAcento(aClientes[nAux]:oWsConta:oWsContaStatus:Value)) == "NENHUM"
			   					Z11->Z11_CNTST	:= '0'
			   				Elseif Upper(NoAcento(aClientes[nAux]:oWsConta:oWsContaStatus:Value)) == "ATIVO"
			   					Z11->Z11_CNTST	:= '1'
			   				Elseif Upper(NoAcento(aClientes[nAux]:oWsConta:oWsContaStatus:Value)) == "INATIVO"
			   					Z11->Z11_CNTST	:= '2'
			   				Elseif Upper(NoAcento(aClientes[nAux]:oWsConta:oWsContaStatus:Value)) == "APROVACAO"
			   					Z11->Z11_CNTST	:= '3'
			   				Elseif Upper(NoAcento(aClientes[nAux]:oWsConta:oWsContaStatus:Value)) == "INTEGRACAO"
			   					Z11->Z11_CNTST	:= '4'
			   				Else
			   					Z11->Z11_CNTST	:= '5'
			   				EndIf
			   				
			   				Z11->Z11_PESSO  := "F"//aClientes[nAux]:oWsConta:oWSTipo:Value    //1=F;2=J - FISICA/JURIDICA  
			   				Z11->Z11_END    := Upper(NoAcento(aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:oWsTIPOLOGRADOURO:VALUE + " " + aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cLogradouro + ", " + aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cNumero))
			   				Z11->Z11_COMPLE := Upper(NoAcento(aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cComplemento))
			   				Z11->Z11_BAIRRO := Upper(NoAcento(aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cBairro))
			   				Z11->Z11_ESTADO := Upper(NoAcento(aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cCidade))
			   				Z11->Z11_EST	:= Upper(aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cEstado)
			   				Z11->Z11_PAIS   := aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cPais
			   				Z11->Z11_CEP	:= aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cCep
			   				Z11->Z11_DDD1	:= aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cDDD1
			   				Z11->Z11_TELEF1 := StrTran(AllTrim(aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cTelefone1),"-","")
			   				Z11->Z11_DDDCEL := aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cDDDCelular
			   				Z11->Z11_TELCEL := StrTran(AllTrim(aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cCelular),"-","")
			   				Z11->Z11_DTINT 	:= dDataBase
			   				Z11->Z11_HRINT 	:= Time()

			   				
			   				Z11->( MsUnlock() )
			   				
			   			Else
			   				RecLock("Z11",.F.)
			   				
			   				Z11->Z11_FILIAL := xFilial("Z11")
			   				Z11_INTEG		:= "1"
			   				//Z11->Z11_CADCLI	:= "S"
			   				Z11->Z11_CGC	:= aClientes[nAux]:oWsConta:cCPF
			   				//Z11->Z11_CCONTA := aClientes[nAux]:oWsConta:cContaCodigoInterno
			   				Z11->Z11_DTNASC	:= U_CWsData(Left(aClientes[nAux]:oWsConta:CDATANASCIMENTO,At(" ", aClientes[nAux]:oWsConta:CDATANASCIMENTO)-1))
			   				Z11->Z11_INSCE  := aClientes[nAux]:oWsConta:CIE
			   				Z11->Z11_INSCM := aClientes[nAux]:oWsConta:CIM
			   				Z11->Z11_NOME  := Upper(NoAcento(aClientes[nAux]:oWsConta:CNOME))
			   				Z11->Z11_SNOME := Upper(aClientes[nAux]:oWsConta:CSOBRENOME)
			   				Z11->Z11_RG    := aClientes[nAux]:oWsConta:CRG
			   				
			   				If Upper(NoAcento(aClientes[nAux]:oWsConta:oWsContaStatus:Value)) == "NENHUM"
			   					Z11->Z11_CNTST	:= '0'
			   				Elseif Upper(NoAcento(aClientes[nAux]:oWsConta:oWsContaStatus:Value)) == "ATIVO"
			   					Z11->Z11_CNTST	:= '1'
			   				Elseif Upper(NoAcento(aClientes[nAux]:oWsConta:oWsContaStatus:Value)) == "INATIVO"
			   					Z11->Z11_CNTST	:= '2'
			   				Elseif Upper(NoAcento(aClientes[nAux]:oWsConta:oWsContaStatus:Value)) == "APROVACAO"
			   					Z11->Z11_CNTST	:= '3'
			   				Elseif Upper(NoAcento(aClientes[nAux]:oWsConta:oWsContaStatus:Value)) == "INTEGRACAO"
			   					Z11->Z11_CNTST	:= '4'
			   				Else
			   					Z11->Z11_CNTST	:= '5'
			   				EndIf
			   				
			   				Z11->Z11_PESSO := "F"//aClientes[nAux]:oWsConta:oWSTipo:Value    //1=F;2=J - FISICA/JURIDICA  
			   				Z11->Z11_EMAIL	:= Upper(NoAcento(aClientes[nAux]:CEMAIL))
			   				Z11->Z11_END    := Upper(NoAcento(aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cLogradouro + ", " + aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cNumero))
			   				Z11->Z11_COMPLE := Upper(NoAcento(aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cComplemento))
			   				Z11->Z11_BAIRRO := Upper(NoAcento(aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cBairro))
			   				Z11->Z11_ESTADO := Upper(NoAcento(aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cCidade))
			   				Z11->Z11_EST	:= Upper(aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cEstado)
			   				Z11->Z11_PAIS   := aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cPais
			   				Z11->Z11_CEP	:= aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cCep
			   				Z11->Z11_DDD1	:= aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cDDD1
			   				Z11->Z11_TELEF1 := StrTran(AllTrim(aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cTelefone1),"-","")
			   				Z11->Z11_DDDCEL := aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cDDDCelular
			   				Z11->Z11_TELCEL := StrTran(AllTrim(aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cCelular),"-","")
			   				Z11->Z11_DTINT 		:= dDataBase
			   				Z11->Z11_HRINT 		:= Time()
			   				
			   				Z11->( MsUnlock() )			   			
			   			Endif
			   			
			   		Else  //cadastrar pessoa juridica
			   			If !(Z11->(DbSeek(xFilial("Z11") + aClientes[nAux]:oWsConta:cCNPJ)))
			   				RecLock("Z11",.T.)
			   				
			   				Z11->Z11_FILIAL := xFilial("Z11")
			   				Z11_INTEG		:= "1"
			   				Z11->Z11_CADCLI	:= "S"
			   				Z11->Z11_CGC	:= aClientes[nAux]:oWsConta:cCNPJ
			   				//Z11->Z11_CCONTA := aClientes[nAux]:oWsConta:cContaCodigoInterno
			   				//Z11->DTNASC	:= CWsData(aClientes[nAux]:oWsConta:CDATANASCIMENTO)
			   				Z11->Z11_INSCE := aClientes[nAux]:oWsConta:CIE
			   				Z11->Z11_INSCM := aClientes[nAux]:oWsConta:CIM
			   				Z11->Z11_NOME  := Upper(NoAcento(aClientes[nAux]:oWsConta:CRAZAOSOCIAL))
			   				Z11->Z11_SNOME := Upper(NoAcento(aClientes[nAux]:oWsConta:CNOMEFANTASIA))
			   	
			   				If Upper(NoAcento(aClientes[nAux]:oWsConta:oWsContaStatus:Value)) == "NENHUM"
			   					Z11->Z11_CNTST	:= '0'
			   				Elseif Upper(NoAcento(aClientes[nAux]:oWsConta:oWsContaStatus:Value)) == "ATIVO"
			   					Z11->Z11_CNTST	:= '1'
			   				Elseif Upper(NoAcento(aClientes[nAux]:oWsConta:oWsContaStatus:Value)) == "INATIVO"
			   					Z11->Z11_CNTST	:= '2'
			   				Elseif Upper(NoAcento(aClientes[nAux]:oWsConta:oWsContaStatus:Value)) == "APROVACAO"
			   					Z11->Z11_CNTST	:= '3'
			   				Elseif Upper(NoAcento(aClientes[nAux]:oWsConta:oWsContaStatus:Value)) == "INTEGRACAO"
			   					Z11->Z11_CNTST	:= '4'
			   				Else
			   					Z11->Z11_CNTST	:= '5'
			   				EndIf
			   				
			   				Z11->Z11_PESSO := 'J'			   	
			   				Z11->Z11_EMAIL	:= Upper(NoAcento(aClientes[nAux]:CEMAIL))
			   				Z11->Z11_END    := Upper(NoAcento(aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cLogradouro + ", " + aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cNumero))
			   				Z11->Z11_COMPLE := Upper(NoAcento(aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cComplemento))
			   				Z11->Z11_BAIRRO := Upper(NoAcento(aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cBairro))
			   				Z11->Z11_ESTADO := Upper(NoAcento(aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cCidade))
			   				Z11->Z11_EST	:= Upper(aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cEstado)
			   				Z11->Z11_PAIS   := aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cPais
			   				Z11->Z11_CEP	:= aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cCep
			   				Z11->Z11_DDD1	:= aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cDDD1
			   				Z11->Z11_TELEF1 := StrTran(AllTrim(aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cTelefone1),"-","")
			   				Z11->Z11_DDDCEL := aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cDDDCelular
			   				Z11->Z11_TELCEL := StrTran(AllTrim(aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cCelular),"-","")
			   				Z11->Z11_DTINT 		:= dDataBase
			   				Z11->Z11_HRINT 		:= Time()
			   				
			   				Z11->( MsUnlock() )
			   			Else
			   				RecLock("Z11",.F.)
			   				
			   				Z11->Z11_FILIAL := xFilial("Z11")
			   				Z11_INTEG		:= "1"
			   				//Z11->Z11_CADCLI	:= "S"
			   				Z11->Z11_CGC	:= aClientes[nAux]:oWsConta:cCNPJ
			   				//Z11->Z11_CCONTA := aClientes[nAux]:oWsConta:cContaCodigoInterno
			   				Z11->Z11_INSCE := aClientes[nAux]:oWsConta:CIE
			   				Z11->Z11_INSCM := aClientes[nAux]:oWsConta:CIM
			   				Z11->Z11_NOME  := Upper(NoAcento(aClientes[nAux]:oWsConta:CRAZAOSOCIAL))
			   				Z11->Z11_SNOME := Upper(NoAcento(aClientes[nAux]:oWsConta:CNOMEFANTASIA))

			   				If Upper(NoAcento(aClientes[nAux]:oWsConta:oWsContaStatus:Value)) == "NENHUM"
			   					Z11->Z11_CNTST	:= '0'
			   				Elseif Upper(NoAcento(aClientes[nAux]:oWsConta:oWsContaStatus:Value)) == "ATIVO"
			   					Z11->Z11_CNTST	:= '1'
			   				Elseif Upper(NoAcento(aClientes[nAux]:oWsConta:oWsContaStatus:Value)) == "INATIVO"
			   					Z11->Z11_CNTST	:= '2'
			   				Elseif Upper(NoAcento(aClientes[nAux]:oWsConta:oWsContaStatus:Value)) == "APROVACAO"
			   					Z11->Z11_CNTST	:= '3'
			   				Elseif Upper(NoAcento(aClientes[nAux]:oWsConta:oWsContaStatus:Value)) == "INTEGRACAO"
			   					Z11->Z11_CNTST	:= '4'
			   				Else
			   					Z11->Z11_CNTST	:= '5'
			   				EndIf
			   				
			   				Z11->Z11_PESSO := 'J'
			   				Z11->Z11_EMAIL	:= Upper(NoAcento(aClientes[nAux]:CEMAIL))
			   				Z11->Z11_END    := Upper(NoAcento(aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cLogradouro + ", " + aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cNumero))
			   				Z11->Z11_COMPLE := Upper(NoAcento(aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cComplemento))
			   				Z11->Z11_BAIRRO := Upper(NoAcento(aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cBairro))
			   				Z11->Z11_ESTADO := Upper(NoAcento(aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cCidade))
			   				Z11->Z11_EST	:= Upper(aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cEstado)
			   				Z11->Z11_PAIS   := aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cPais
			   				Z11->Z11_CEP	:= aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cCep
			   				Z11->Z11_DDD1	:= aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cDDD1
			   				Z11->Z11_TELEF1 := StrTran(AllTrim(aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cTelefone1),"-","")
			   				Z11->Z11_DDDCEL := aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cDDDCelular
			   				Z11->Z11_TELCEL := StrTran(AllTrim(aClientes[nAux]:oWsEnderecos:oWsClsEndereco[1]:cCelular),"-","")
			   				Z11->Z11_DTINT 		:= dDataBase
			   				Z11->Z11_HRINT 		:= Time()
			   				
			   				
			   				Z11->( MsUnlock() )
			   			Endif   			
	
		   			Endif
		   		Next nAux
		   		
				Conout("Integração realizada com sucesso " + CRLF + ;
				oCliente:oWSListarNovosResult:cDescricao)	
				Conout("DATA: " + DTOS(dDataBase) )
				Conout("HORA" + cValToChar( Time() ) )	
				Conout(CRLF)		   		
		   		
		   Else

		   		U_KHLOGWS("Z11",dDataBase,Time(),oCliente:oWSListarNovosResult:cDescricao + " KHINTCLI","SITE")//GRAVA NA TABELA DE LOG
						   	
		   Endif
		   
		Endif

	/*ElseIf nOpc == 2 //Validar
	
		cQuery += CRLF +  "SELECT Z11_CODIGO, Z11_EMAIL,R_E_C_N_O_ RECNO" 
		cQuery += CRLF +  "  FROM "+RetSqlName("Z11")+"  " 
		cQuery += CRLF +  "WHERE Z11_FILIAL = '"+xFilial("Z11")+"' AND " 
		cQuery += CRLF +  "  Z11_INTEG = '1' " 
		cQuery += CRLF +  "  AND D_E_L_E_T_ = ' ' " 
		
		If Select("TZ11") > 0
			TZ11->(DbCloseArea())		
		EndIf
		
		TcQuery cQuery New Alias "TZ11"
		
		If .Not. ( TZ11->( Eof() ))
		
			While .Not. ( TZ11->( Eof() ))
				//Comunicação com o WebService para listar os clintes novos
				If oCliente:Validar(0,AllTrim(TZ11->Z11_EMAIL),TZ11->Z11_CODIGO,cA1,cA2)
				   If oCliente:oWSValidarResult:nCodigo == 1
				   
				   		Z11->(DbGoTo(TZ11->RECNO))
				   		
				   		RecLock("Z11",.F.)
				   		
				   		Z11->DTINT := dDataBase
				   		Z11->HRINT := Time()
				   		Z11_CNTST  := "1"
				   		Z11_INTEG  := "2"
				   		Z11->(MsUnlock())
				   		
				   Else
						Conout("Erro na Integração" + CRLF + ;
						oCliente:oWsValidarResult:cDescricao)	
						
						Conout("Cliente: " + Z11->CODIGO)
						Conout("Loja: " + Z11->LOJA)
						Conout("DATA: " + DTOS(dDataBase) )
						Conout("HORA" + cValToChar( Time() ) + CRLF)
				   Endif
				Endif
				
				TZ11->( DbSkip() )
				
			Enddo
		Else
			Conout("Nenhum cliente pendente de validação!")
			Conout("DATA: " + DTOS(dDataBase) )
			Conout("HORA" + cValToChar( Time() ) + CRLF)
			
		Endif		
	Endif*/
	
Return

User Function KHJB003(aEmp)

	Local aEmp := {"01","0142"}


	PREPARE ENVIRONMENT EMPRESA aEmp[1] FILIAL aEmp[2]    
	U_KHINTCLI()

Return 