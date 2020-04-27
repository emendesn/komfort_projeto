#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWBROWSE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

#DEFINE CRLF CHR(10)+CHR(13)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SYTM002  ºAutor  ³ SYMM CONSULTORIA   º Data ³  16/09/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina responsavel para realizacao de consulta do          º±±
±±º          ³ dados do cheque via Integracao WS Telecheque.   	    	  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SYTM002(aParcelas,cCliente,cLoja,cContato)


Local nUsuario	:= GetMv("MV_SYTM02A",,"011682")			//Código de acesso do Cliente MultiCrédito
Local nSenha	:= GetMv("MV_SYTM02B",,"AMZ")				//Senha de acesso do Cliente MultiCrédito
Local nPos		:= 0
Local nPos1		:= 0
Local nX		:= 0
Local nTipoDoc	:= 0										//Tipo do Documento: 1=CPF e 2=CNPJ
Local nDocum	:= 0										//Número do CPF/CNPJ
Local nQtdTelRes:= 0										//Quantidade de telefones residenciais do emitente
Local nQtdTelCom:= 0										//Quantidade de telefones comerciais
Local nPraca	:= 0										//Número da Praça de Compensação.
Local nBanco	:= 0										//Código do banco do emitente.
Local nAgencia	:= 0										//Código da agência bancária do emitente.
Local nDtAbertu	:= 0										//Data de abertura da conta corrente do emitente
Local nVlrTot	:= 0										//Valor total da compra. Formato: 999999999999,99
Local cTpEntr	:= ""										//00-Sem Entrada,01-Dinheiro,02-Cheque,03-Cartão Crédito Visa,04-Cartão Crédito Mastercard,05-Outros Cartões de Crédito,06-Cartão de Débito,99-Outros
Local nDigito1	:= 0										//Dígito C1
Local nDigito2	:= 0										//Dígito C2
Local nQtdParc	:= 0										//Quantidades de Parcelas da Consulta.
Local nCMC7		:= 0										//CMC7 da folha do cheque.
Local nNumCheq	:= 0										//Número do Cheque.
Local nDigito3	:= 0										//Dígito C3.
Local nVlrCheq	:= 0										//Valor do cheque.Formato: 999999999999,99
Local nDtVenc	:= 0										//Data vencimento do Cheque. Formato: ddmmaaaa
Local nConta	:= 0										//Número da Conta Corrente que consta no cheque
Local cString	:= ""
Local cXml		:= ""
Local cErro		:= ""
Local cAviso	:= ""
Local aRet		:= {}
Local oDados	:= Nil
Local oXml		:= Nil

SA1->(DbSetOrder(1))
SA1->(DbSeek(xFilial("SA1") + cCliente + cLoja))
nTipoDoc   := If(SA1->A1_PESSOA=="F",1,2)
nDocum	   := Val(SA1->A1_CGC)
nQtdTelRes := 1
nQtdTelCom := 1

nPos := aScan(aParcelas,{|x| DTOS(x[1]) == DTOS(M->UA_EMISSAO) })
If nPos > 0
	cTpEntr := IIf(Alltrim(aParcelas[nPos][3])=="R$","01",IIf(Alltrim(aParcelas[nPos][3])=="CH","02",IIf(Alltrim(aParcelas[nPos][3])=="CD","06","99")))
ElseIf nPos==0
	cTpEntr := "00"
Endif
nPos1 	 := aScan(aParcelas,{|x| Alltrim(x[3]) == "CH"})
aCheque  := Separa(aParcelas[nPos1][5],"|")

For nX := 1 To Len(aParcelas)
	If( Alltrim(aParcelas[nX][3])=="CH" )
		nQtdParc++
	Endif 
Next

aEval( aParcelas , { |x| nVlrTot += x[2] } )

nVlrCheq := Alltrim( STRTRAN(Transform(aParcelas[nPos1][2],"999999999999.99"),".",",") ) 
nVlrTot  := Alltrim( STRTRAN(Transform(nVlrTot,"999999999999.99"),".",","))
nDtVenc  := STRTRAN(DTOC(aParcelas[nPos1][1]),"/","")
nCMC7	 := aCheque[1]
nPraca	 := aCheque[2]
nBanco	 := aCheque[3]
nAgencia := aCheque[4]
nDigito1 := aCheque[5]
nConta	 := aCheque[6]
nDigito2 := aCheque[7]
nNumCheq := aCheque[8]
nDigito3 := aCheque[9]
nDtAbertu:= STRTRAN(aCheque[10],"/","")

oDados:=WsConsultaCH():New
//oDados:_URL 			:= "http://hom10.telecheque.com.br/wsautorizador/wsautorizador.asmx?WSDL"
oDados:_URL 			:= "http://www14.telecheque.com.br/wsautorizador/wsautorizador.asmx?WSDL"
oDados:CCODIGO_ACESSO   := ALLTRIM(nUsuario)
oDados:CSENHA_ACESSO	:= ALLTRIM(nSenha)

cString+="<?xml version='1.0' encoding='utf-8'?>"+CRLF
cString+="<PROPOSTA>"+CRLF
cString+="<VERSAO>4</VERSAO>"+CRLF
cString+="<PRODUTO>CHEQUE</PRODUTO>"+CRLF
cString+="<CODIGO_PROPOSTA></CODIGO_PROPOSTA>"+CRLF
cString+="<CODIGO_LOJA>"+ALLTRIM(nUsuario)+"</CODIGO_LOJA>"+CRLF
cString+="<SENHA_LOJA>"+ALLTRIM(nSenha)+"</SENHA_LOJA>"+CRLF
cString+="<CODIGO_USUARIO></CODIGO_USUARIO>"+CRLF
cString+="<DADOS_GERAIS>"+CRLF
cString+="<TIPO_DOCUMENTO>"+ALLTRIM(STR(nTipoDoc))+"</TIPO_DOCUMENTO>"+CRLF
cString+="<NUMERO_DOCUMENTO>"+ALLTRIM(STR(nDocum))+"</NUMERO_DOCUMENTO>"+CRLF
cString+="<NOME></NOME>"+CRLF
cString+="<SEXO></SEXO>"+CRLF
cString+="<DATA_NASCIMENTO></DATA_NASCIMENTO>"+CRLF
cString+="<NOME_MAE></NOME_MAE>"+CRLF
cString+="<ESTADO_CIVIL></ESTADO_CIVIL>"+CRLF
cString+="<VALOR_RENDA></VALOR_RENDA>"+CRLF
cString+="</DADOS_GERAIS>"+CRLF
cString+="<ENDERECO_RESIDENCIAL>"+CRLF
//cString+="<ENDERECO_VIA_COMPROVANTE></ENDERECO_VIA_COMPROVANTE>"+CRLF
cString+="<CEP></CEP>"+CRLF
cString+="<TIPO_LOGRADOURO></TIPO_LOGRADOURO>"+CRLF
cString+="<ENDERECO></ENDERECO>"+CRLF
cString+="<NUMERO></NUMERO>"+CRLF
cString+="<COMPLEMENTO></COMPLEMENTO>"+CRLF
cString+="<BAIRRO></BAIRRO>"+CRLF
cString+="<CIDADE></CIDADE>"+CRLF
cString+="<UF></UF>"+CRLF
cString+="<E_MAIL></E_MAIL>"+CRLF
cString+="<TELEFONES_RESIDENCIAIS>"+CRLF
cString+="<QTD_TELEFONES_RESIDENCIAIS>"+ALLTRIM(STR(nQtdTelRes))+"</QTD_TELEFONES_RESIDENCIAIS>"+CRLF
cString+="<TELEFONE_RESIDENCIAL>"+CRLF
cString+="<TIPO_TELEFONE></TIPO_TELEFONE>"+CRLF
cString+="<DDI></DDI>"+CRLF
cString+="<DDD></DDD>"+CRLF
cString+="<NUMERO_TELEFONE></NUMERO_TELEFONE>"+CRLF
cString+="</TELEFONE_RESIDENCIAL>"+CRLF
cString+="</TELEFONES_RESIDENCIAIS>"+CRLF
cString+="</ENDERECO_RESIDENCIAL>"+CRLF
cString+="<ENDERECO_COMERCIAL>"+CRLF
cString+="<CEP></CEP>"+CRLF
cString+="<TIPO_LOGRADOURO></TIPO_LOGRADOURO>"+CRLF
cString+="<ENDERECO></ENDERECO>"+CRLF
cString+="<NUMERO></NUMERO>"+CRLF
cString+="<COMPLEMENTO></COMPLEMENTO>"+CRLF
cString+="<BAIRRO></BAIRRO>"+CRLF
cString+="<CIDADE></CIDADE>"+CRLF
cString+="<UF></UF>"+CRLF
cString+="<TELEFONES_COMERCIAIS>"+CRLF
cString+="<QTD_TELEFONES_COMERCIAIS>"+ALLTRIM(STR(nQtdTelCom))+"</QTD_TELEFONES_COMERCIAIS>"+CRLF
cString+="<TELEFONE_COMERCIAL>"+CRLF
cString+="<TIPO_TELEFONE></TIPO_TELEFONE>"+CRLF
cString+="<DDI></DDI>"+CRLF
cString+="<DDD></DDD>"+CRLF
cString+="<NUMERO_TELEFONE></NUMERO_TELEFONE>"+CRLF
cString+="<RAMAL></RAMAL>"+CRLF
cString+="</TELEFONE_COMERCIAL>"+CRLF
cString+="</TELEFONES_COMERCIAIS>"+CRLF
cString+="</ENDERECO_COMERCIAL>"+CRLF
cString+="<HABITO_CONSUMO>"+CRLF
cString+="<SOLICITACAO_CREDITO>"+CRLF
cString+="<QTD_SOLICITACAO_CREDITO></QTD_SOLICITACAO_CREDITO>"+CRLF
cString+="<QTD_SOLICITACAO_CREDITO_AUTORIZADA></QTD_SOLICITACAO_CREDITO_AUTORIZADA>"+CRLF
cString+="</SOLICITACAO_CREDITO>"+CRLF
cString+="<HABITO_NEGATIVO>"+CRLF
cString+="<QTD_TOTAL_DEBITO></QTD_TOTAL_DEBITO>"+CRLF
cString+="<QTD_DEBITO_EM_ABERTO></QTD_DEBITO_EM_ABERTO>"+CRLF
cString+="<VALOR_TOTAL_DEBITO></VALOR_TOTAL_DEBITO>"+CRLF
cString+="<VALOR_TOTAL_DEBITO_EM_ABERTO></VALOR_TOTAL_DEBITO_EM_ABERTO>"+CRLF
cString+="</HABITO_NEGATIVO>"+CRLF
cString+="<HABITO_POSITIVO>"+CRLF
cString+="<QTD_COMPRAS_QUITADAS></QTD_COMPRAS_QUITADAS>"+CRLF
cString+="<VALOR_COMPRAS_QUITADAS></VALOR_COMPRAS_QUITADAS>"+CRLF
cString+="<VALOR_MAIOR_COMPRA></VALOR_MAIOR_COMPRA>"+CRLF
cString+="<VALOR_MAIOR_COMPROMETIMENTO_MENSAL></VALOR_MAIOR_COMPROMETIMENTO_MENSAL>"+CRLF
cString+="<DATA_PRIMEIRA_COMPRA></DATA_PRIMEIRA_COMPRA>"+CRLF
cString+="<DATA_ULTIMA_COMPRA></DATA_ULTIMA_COMPRA>"+CRLF
cString+="</HABITO_POSITIVO>"+CRLF
cString+="<COMPROMETIMENTOS_FUTURO>"+CRLF
cString+="<QTD_MESES_COM_COMPROMETIMENTO></QTD_MESES_COM_COMPROMETIMENTO>"+CRLF
cString+="<COMPROMETIMENTO>"+CRLF
cString+="<DATA_MES_ANO_COMPROMETIMENTO></DATA_MES_ANO_COMPROMETIMENTO>"+CRLF
cString+="<QTD_PARCELAS_MES></QTD_PARCELAS_MES>"+CRLF
cString+="<VALOR_COMPROMETIMENTO_MES></VALOR_COMPROMETIMENTO_MES>"+CRLF
cString+="</COMPROMETIMENTO>"+CRLF
cString+="</COMPROMETIMENTOS_FUTURO>"+CRLF
cString+="</HABITO_CONSUMO>"+CRLF
cString+="<DADOS_BANCARIOS>"+CRLF
cString+="<PRACA_COMPENSACAO>"+ALLTRIM(nPraca)+"</PRACA_COMPENSACAO>"+CRLF
cString+="<BANCO>"+ALLTRIM(nBanco)+"</BANCO>"+CRLF
cString+="<AGENCIA>"+ALLTRIM(nAgencia)+"</AGENCIA>"+CRLF
cString+="<DATA_ABERTURA>"+ALLTRIM(nDtAbertu)+"</DATA_ABERTURA>"+CRLF
cString+="<TIPO_CONTA></TIPO_CONTA>"+CRLF
cString+="</DADOS_BANCARIOS>"+CRLF
cString+="<COMPRA>"+CRLF
cString+="<CHEQUE_TERCEIRO>N</CHEQUE_TERCEIRO>"+CRLF					//Incluido na versão 4 do layout
cString+="<TP_DOCUMENTO_TERCEIRO></TP_DOCUMENTO_TERCEIRO>"+CRLF			//Incluido na versão 4 do layout
cString+="<NUMERO_DOCUMENTO_TERCEIRO></NUMERO_DOCUMENTO_TERCEIRO>"+CRLF	//Incluido na versão 4 do layout
cString+="<DATA_VIAGEM></DATA_VIAGEM>"+CRLF
cString+="<TIPO_VIAGEM></TIPO_VIAGEM>"+CRLF
cString+="<NOME_CONTINENTE></NOME_CONTINENTE>"+CRLF
cString+="<VALOR_TOTAL_COMPRA>"+ALLTRIM(nVlrTot)+"</VALOR_TOTAL_COMPRA>"+CRLF
cString+="<VALOR_ENTRADA></VALOR_ENTRADA>"+CRLF
cString+="<TIPO_ENTRADA>"+cTpEntr+"</TIPO_ENTRADA>"+CRLF
cString+="<VALOR_REPASSE></VALOR_REPASSE>"+CRLF
cString+="<VALOR_DESCONTO></VALOR_DESCONTO>"+CRLF
cString+="<VALOR_CAC></VALOR_CAC>"+CRLF
cString+="<DIGITO_C1>"+ALLTRIM(nDigito1)+"</DIGITO_C1>"+CRLF
cString+="<DIGITO_C2>"+ALLTRIM(nDigito2)+"</DIGITO_C2>"+CRLF
cString+="<PARCELAS>"+CRLF
cString+="<QTD_PARCELAS>"+ALLTRIM(STR(nQtdParc))+"</QTD_PARCELAS>"+CRLF

For nX := 1 To Len(aParcelas)
	
	If Alltrim(aParcelas[nX][3]) == "CH"		
		aCheque	 := {}
		aCheque  := Separa(aParcelas[nX][5],"|")
				
		nCMC7	 := aCheque[1]
		nNumCheq := aCheque[8]
		nDigito3 := aCheque[9]
		nVlrCheq := Alltrim( STRTRAN(Transform(aParcelas[nPos1][2],"999999999999.99"),".",",") ) 
		nDtVenc  := STRTRAN(DTOC(aParcelas[nX][1]),"/","")
		nConta	 := aCheque[6]		
		
		cString+="<PARCELA>"+CRLF
		cString+="<CMC7>"+ALLTRIM(nCMC7)+"</CMC7>"+CRLF
		cString+="<NUMERO_CHEQUE>"+ALLTRIM(nNumCheq)+"</NUMERO_CHEQUE>"+CRLF
		cString+="<DIGITO_C3>"+ALLTRIM(nDigito3)+"</DIGITO_C3>"+CRLF
		cString+="<VALOR_CHEQUE>"+ALLTRIM(nVlrCheq)+"</VALOR_CHEQUE>"+CRLF
		cString+="<DATA_VENCIMENTO>"+ALLTRIM(nDtVenc)+"</DATA_VENCIMENTO>"+CRLF
		cString+="<NUMERO_CONTA_CORRENTE>"+ALLTRIM(nConta)+"</NUMERO_CONTA_CORRENTE>"+CRLF
		cString+="</PARCELA>"+CRLF
	
	Endif
	
Next
cString+="</PARCELAS>"+CRLF
cString+="</COMPRA>"+CRLF
cString+="</PROPOSTA>"+CRLF

oDados:CP_XML := cString

memowrite("\xml_telecheque.xml", cString)		// log

If oDados:AnalisaProposta()
	cXml := oDados:CANALISAPROPOSTARESULT
	oXml := XmlParser(cXml,"_",@cErro,@cAviso)
	If (oXml == NIL )
		MsgStop("Falha ao gerar Objeto XML : "+cErro+" / "+cAviso)
	    AAdd( aRet , .T. )
	    AAdd( aRet , ""  )		
		Return(aRet)
	Else 
		//Integração com erro.
		If !Empty(oXml:_RETORNO:_ERRO:TEXT)
		    AAdd( aRet , .F. )
		    AAdd( aRet , UPPER(ALLTRIM(oXml:_RETORNO:_ERRO:TEXT)) )
					
		ElseIf Empty(oXml:_RETORNO:_ERRO:TEXT)
			
			If UPPER(ALLTRIM(oXml:_RETORNO:_SITUACAO_PROPOSTA:TEXT)) == UPPER("Nao Aprovado")
			    AAdd( aRet , .F. )
			    AAdd( aRet , UPPER(ALLTRIM(oXml:_RETORNO:_SITUACAO_PROPOSTA:TEXT))+" - "+UPPER(ALLTRIM(oXml:_RETORNO:_DESCRICAO_MENSAGEM:TEXT))	 )
				
			Else 
			    AAdd( aRet , .T. )
			    AAdd( aRet , UPPER(ALLTRIM(oXml:_RETORNO:_SITUACAO_PROPOSTA:TEXT))+" - "+UPPER(ALLTRIM(oXml:_RETORNO:_DESCRICAO_MENSAGEM:TEXT)) + " - Autorização: "+oXml:_RETORNO:_CODIGO_AUTORIZACAO:TEXT )

				memowrite("\CALL_CENTER_"+cFilAnt+"\SYTM002_"+cFilAnt+"_"+M->UA_NUM+".TXT", oXml:_RETORNO:_CODIGO_AUTORIZACAO:TEXT)
			Endif

		Endif

	Endif
	
Endif

Return(aRet)