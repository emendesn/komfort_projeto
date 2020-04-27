#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TbiConn.ch"
#INCLUDE "TbiCode.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "Fileio.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BRINTFIN บ Autor ณ Eduardo Patriani   บ Data ณ  10/07/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para geracao e recebimento de arquivos para       บฑฑ
ฑฑบ          ณ conciliacao de cartoes.                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Bio-Ritmo                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function SYTMOV14()

Local cSequen	:= "00"
Local cPerg		:= PADR("SYCONCIL",10)
Local cArquivo  := CriaTrab(,.F.)
Local cDirDocs  := MsDocPath()
Local cDirLogs 	:= "C:\TEMP\"
Local oDlg
Local oFwLayer
Local oPanel1
Local oGroup
Local oGroup2

Private cEmpOfic  := cEmpAnt
Private cFilOfic  := cFilAnt
Private cArqTrb	  := CriaTrab(,.F.)
Private aEmpresas := {}
Private aArqLogs  := {}
Private aLogs 	  := {}

Define MsDialog oDlg Title "Painel de Gestใo de Integracao Financeira" From 0,0 To 375,615 Pixel Of oDlg

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPainel Layerณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤู
oFwLayer := FwLayer():New()
oFwLayer:Init(oDlg,.F.)
//ฺฤฤฤฤฤฤฤฤฤฤฟ
//ณ1o. Painelณ
//ภฤฤฤฤฤฤฤฤฤฤู
oFWLayer:addLine("CENTRAL",100, .F.)
oFWLayer:addCollumn( "COLCENT",100, .F. , "CENTRAL")
oFWLayer:addWindow( "COLCENT", "WINENT", "Painel de Gestใo Concilia็ใo de Cart๕es", 100, .F., .F., , "CENTRAL")
oPanel1 := oFWLayer:GetWinPanel("COLCENT","WINENT","CENTRAL")

oGroup := TGROUP():New(002,001,080,300,"Integra็ใo Financeira - Gera็ใo",oPanel1,,,.T.)
oGroup2:= TGROUP():New(082,001,142,300,"Integra็ใo Financeira - Recebimento",oPanel1,,,.T.)

@030,010 Button "Gera Arquivo "			Size 92,20 Action ( nTipo:= 1, oDlg:End() ) Pixel
@110,010 Button "Recebe Arquivo "		Size 92,20 Action ( nTipo:= 2, oDlg:End() ) Pixel

@170,280 BmpButton Type 1 Action (nTipo:= 0, oDlg:End())

Activate Dialog oDlg Center

Do Case
	//Saida
	Case (nTipo == 0)
		Return
		
		//Gera Arquivo
	Case (nTipo == 1)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ`ฟ
		//ณFiltra as empresas de integracaoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ`ู

		if ! AjustaSx1(cPerg)
//		If !Pergunte(cPerg,.T.)
			Return
		Endif
		
		cPath := cGetFile(,"Selecione o diret๓rio de destino",0,"C:\",.T.,GETF_LOCALFLOPPY+GETF_NETWORKDRIVE+GETF_LOCALHARD+GETF_RETDIRECTORY, .F.)
		
		If !Empty(cPath)
		
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Gera o arquivo em formato .CSV. ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			cArquivo += ".CSV"
			nHandle := FCreate(cPath + cArquivo)
			If nHandle == -1
				MsgStop("Erro na criacao do arquivo Excel. Contate o administrador do sistema"	)
				Return
			EndIf
			
			Processa({|| LeTitulos(@cSequen)})
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณFecha o arquivoณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			FClose(nHandle)
		
		Endif		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณRecebe Arquivoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Case (nTipo == 2)
		RecebeTitulos()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณMonta Tela    ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู				
		If Len(aArqLogs) > 0		
			For nOpened := 1 To Len(aArqLogs)
				cArqImp := cDirLogs + Alltrim( aArqLogs[nOpened,1] )				
				ImportaTxt(cArqImp,aLogs)
			Next
		Endif			
		MtnTelaErr()		
EndCase

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLeTitulos บAutor  ณMicrosiga           บ Data ณ  10/07/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para a geracao dos titulos para envio na conciliacao บฑฑ
ฑฑบ          ณde cartoes.                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Bio-Ritmo                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function LeTitulos(cSequen)
Local cQuery   	:= ""
Local cBuffer 	:= ""
Local cArqSA1	:= ""
Local aTemp
Local aDados    := {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Gera o cabecalho do arquivo.    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//cBuffer := "A01;ADQUIRENTE;LOJA_FILIAL;BANDEIRA;NRO_PARCELA;QTD_PARCELAS;NSU;VALOR;CLIENTE;DATA_VENDA;ORIGEM;SEQUENCIA;NOTA_FISCAL;TAXA;CPF_CNPJ;ESTABELECIMENTO;DATA_VENCIMENTO;REFERENCIA1;REFERENCIA2;REFERENCIA3"
cBuffer := "A01;ADQUIRENTE;LOJA_FILIAL;BANDEIRA;TIPO_TRANSACAO;NRO_PARCELA;QTD_PARCELAS;TID;NSU;AUTORIZAวรO;VALOR;CLIENTE;DATA_VENDA;ORIGEM;SEQUENCIA;NOTA_FISCAL;CPF_CNPJ;ESTABELECIMENTO;DATA_VENCIMENTO;NUMERO CARTAO;REFERENCIA1"
FWrite(nHandle, cBuffer + CRLF)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Gera a query                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQuery	+= "SELECT  E1_FILIAL,"+CRLF
cQuery	+= " 		E1_PREFIXO,"+CRLF
cQuery	+= " 		E1_NUM,"+CRLF
cQuery	+= " 		E1_PARCELA,"+CRLF
cQuery	+= " 		E1_TIPO,"+CRLF
cQuery	+= " 		E1_NATUREZ,"+CRLF
cQuery	+= " 		E1_CLIENTE,"+CRLF
cQuery	+= " 		E1_LOJA,"+CRLF
cQuery	+= " 		A1_NOME,"+CRLF
cQuery	+= " 		E1_EMISSAO,"+CRLF
cQuery	+= " 		E1_VENCTO,"+CRLF
cQuery	+= " 		E1_VENCREA,"+CRLF
cQuery	+= " 		E1_VALOR,"+CRLF
cQuery	+= " 		E1_SALDO,"+CRLF
cQuery	+= " 		E1_MSFIL,"+CRLF
cQuery	+= " 		E1_MSEMP,"+CRLF //cQuery	+= " 		E1_DESCNAT,"+CRLF
cQuery	+= " 		E1_NSUTEF,"+CRLF
cQuery	+= " 		E1_DOCTEF,"+CRLF
cQuery	+= " 		E1_01QPARC,"+CRLF
cQuery	+= " 		E1_01NORED,"+CRLF
cQuery	+= " 		E1_01NOOPE,"+CRLF
cQuery	+= " 		A1_CGC,"+CRLF
cQuery	+= " 		E1_FILORIG,"+CRLF
cQuery	+= " 		SE1.R_E_C_N_O_ AS RECSE1 "+CRLF
cQuery	+= " FROM  " + RETSQLNAME("SE1")  + " SE1 (NOLOCK) "+CRLF
cQuery	+= " INNER JOIN " + RETSQLNAME("SA1") + " SA1 ON A1_COD=E1_CLIENTE AND A1_LOJA=E1_LOJA AND SA1.D_E_L_E_T_ = ' ' "+CRLF
cQuery	+= " WHERE "+CRLF
//cQuery	+= "   		SE1.E1_FILIAL IN ("+cFilAtu+") "+CRLF
cQuery	+= "   SE1.D_E_L_E_T_  = ''"+CRLF
cQuery	+= "   AND 	SE1.E1_SALDO > 0 "+CRLF
cQuery	+= "   AND 	SE1.E1_EMISSAO BETWEEN '"+Dtos(Mv_Par01)+"' AND '"+Dtos(Mv_Par02)+"' "+CRLF
//cQuery	+= "   AND 	SE1.E1_VENCREA BETWEEN '"+Dtos(Mv_Par01)+"' AND '"+Dtos(Mv_Par02)+"' "+CRLF
cQuery  += "   AND SE1.E1_NSUTEF <> '' "+CRLF
cQuery  += "   AND 	SE1.E1_01NOOPE <> ' ' "+CRLF


If Mv_Par03 == 1
	cQuery	+= "   AND 	SE1.E1_01DTEXP =  ' ' "+CRLF
Elseif Mv_Par03 == 2
	cQuery	+= "   AND 	SE1.E1_01DTEXP <> ' ' "+CRLF
Endif

//cQuery  += " ORDER BY E1_FILIAL,E1_PREFIXO,E1_NUM,E1_TIPO,E1_PARCELA "+CRLF
cQuery  += " ORDER BY E1_FILORIG,E1_PREFIXO,E1_NUM,E1_TIPO,E1_PARCELA "+CRLF

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)
Count to nRec

dbSelectArea("QRY")
dbGoTop()
ProcRegua(nRec)
While !Eof()
	
	IncProc()

	cSequen := Soma1(cSequen)

	aTemp := {}
	aadd( aTemp, "A02" )
	aadd( aTemp, Alltrim(UPPER(QRY->E1_01NORED)) )
	aadd( aTemp, getCNPJ(QRY->E1_FILORIG))
	aadd( aTemp, Alltrim(UPPER(QRY->E1_01NOOPE)))

	if Alltrim(QRY->E1_TIPO) == "CC"
		aadd( aTemp, "CREDITO")
	elseif Alltrim(QRY->E1_TIPO) == "CD"
		aadd( aTemp, "DEBITO")
  	else
		aadd( aTemp, Alltrim(QRY->E1_TIPO))
	endif

	aadd( aTemp, cValToChar( U_retParc(QRY->E1_PARCELA) ))
	aadd( aTemp, cValToChar(QRY->E1_01QPARC))
	aadd( aTemp, "")
	aadd( aTemp, Alltrim(QRY->E1_NSUTEF))
	aadd( aTemp, Alltrim(QRY->E1_DOCTEF))
	aadd( aTemp, STRTRAN(ALLTRIM(STR(QRY->E1_SALDO)),".",","))
	aadd( aTemp, Alltrim(QRY->A1_NOME))
	aadd( aTemp, SUBSTR(QRY->E1_EMISSAO,7,2)+"/"+SUBSTR(QRY->E1_EMISSAO,5,2)+"/"+SUBSTR(QRY->E1_EMISSAO,1,4))
	aadd( aTemp, "VENDA")
	aadd( aTemp, cSequen)
	aadd( aTemp, "")
	aadd( aTemp, Alltrim(QRY->A1_CGC))
	aadd( aTemp, "")
	aadd( aTemp, SUBSTR(QRY->E1_VENCREA,7,2)+"/"+SUBSTR(QRY->E1_VENCREA,5,2)+"/"+SUBSTR(QRY->E1_VENCREA,1,4))
	aadd( aTemp, "")
	aadd( aTemp, QRY->E1_FILIAL+QRY->E1_PREFIXO+QRY->E1_NUM+QRY->E1_PARCELA+QRY->E1_TIPO+QRY->E1_CLIENTE+QRY->E1_LOJA)

	
/*	
	cBuffer	:= ""
	cSequen := Soma1(cSequen)

	cBuffer +=  "A02" + ";"          																					//A02 (Tipo de Registro) - Identifica o o lancamento.
	cBuffer +=  Alltrim(UPPER(QRY->E1_01NORED)) + ";"																	//ADQUIRENTE - Adquirente que capturou a venda
//	cBuffer +=  SM0->M0_CGC + ";"												  										//LOJA_FILIAL - CNPJ do estabelecimento (00.000.000/0000-00).
	cBuffer +=  getCNPJ(QRY->E1_FILORIG) + ";"									  										//LOJA_FILIAL - CNPJ do estabelecimento (00.000.000/0000-00).
	cBuffer +=  Alltrim(UPPER(QRY->E1_01NOOPE)) + ";"																	//BANDEIRA - Descricao da bandeira respectiva a transa็ใo informada pela operadora

	if Alltrim(QRY->E1_TIPO) == "CC"																					// TIPO_TRANSACAO
		cBuffer += "CREDITO;"
	elseif Alltrim(QRY->E1_TIPO) == "CD"
		cBuffer += "DEBITO;"
  	else
		cBuffer +=  Alltrim(QRY->E1_TIPO)+";"
	endif

//	cBuffer +=  Alltrim(QRY->E1_PARCELA) + ";"																			//NRO_PARCELA - Identifica o numero da parcela.
	cBuffer +=  cValToChar( U_retParc(QRY->E1_PARCELA) ) + ";"																			//NRO_PARCELA - Identifica o numero da parcela.
	cBuffer +=  cValToChar(QRY->E1_01QPARC) + ";"																		//QTD_PARCELAS - identifica a quantidade de parcelas
	cBuffer +=  ";"																										//TID - CODIGO QUE IDENTIFICA A TRANSAวรO QUANDO A MESMA ษ REALIZADO EM ECOMMERCE (deixar em branco se nใo for e-commerce)
	cBuffer +=  Alltrim(QRY->E1_NSUTEF) + ";"																			//NSU - Numero do NSU informado pela operadora
	cBuffer +=  Alltrim(QRY->E1_DOCTEF) + ";"																			// CODIGO DE AUTORIZAวรO JUNTO A OPERADORA
	cBuffer +=  STRTRAN(ALLTRIM(STR(QRY->E1_SALDO)),".",",") + ";"														//VALOR - Informar o valor bruto da transacao
	cBuffer +=  Alltrim(QRY->A1_NOME) + ";"																				//CLIENTE - Nome do cliente
	cBuffer +=  SUBSTR(QRY->E1_EMISSAO,7,2)+"/"+SUBSTR(QRY->E1_EMISSAO,5,2)+"/"+SUBSTR(QRY->E1_EMISSAO,1,4) + ";"  		//DATA_VENDA - Informar a data da venda da transacao (99/99/99)
	cBuffer +=  "VENDA" + ";"																							//ORIGEM - Sempre VENDA

	cBuffer +=  cSequen + ";"																							//SEQUENCIA - Sera um sequencial unico no arquivo

	cBuffer +=  "" + ";"																								//NOTA_FISCAL - Nao definido (No obrigatorio)
	cBuffer +=  Alltrim(QRY->A1_CGC)	+ ";"																			//CPF/CNPJ - Identifica็ao do cliente
	cBuffer +=  "" + ";"																								//ESTABELECIMENTO - No definido
	cBuffer +=  SUBSTR(QRY->E1_VENCREA,7,2)+"/"+SUBSTR(QRY->E1_VENCREA,5,2)+"/"+SUBSTR(QRY->E1_VENCREA,1,4) + ";"		//DATA_VENCIMENTO - Data de vencimento do titulo

	cBuffer +=  "" + ";"																								//Numero do Cartใo utilizado - nใo obrigat๓rio
	cBuffer +=  QRY->E1_FILIAL+QRY->E1_PREFIXO+QRY->E1_NUM+QRY->E1_PARCELA+QRY->E1_TIPO+QRY->E1_CLIENTE+QRY->E1_LOJA	//REFERENCIA - Referencia de retorno
	FWrite(nHandle, cBuffer + CRLF)
*/
	aadd( aDados, aClone( aTemp ) )
	
	dbSelectArea("QRY")
	dbSkip()
EndDo
QRY->(dbCloseArea())

aSort( aDados,,, {|a,b| a[9]+a[6] < b[9]+b[6]} )	// ordena por 9-NSU e 6-parcela.

nI := 1
while nI <= len( aDados )

	cNSU    := aDados[nI,9]
	nQtParc := 0
	aEval(aDados, {|it| iif( it[9] == cNSU, nQtParc++, nil ) } )

	nParc   := 0
	while nI <= len( aDados ) .and. cNSU == aDados[nI,9]

		cBuffer := ""

		nParc++
		aDados[nI,6] := cValToChar( nParc   )	// parcela
		aDados[nI,7] := cValToChar( nQtParc )	// total das parcelas

		for nJ := 1 to len( aDados[nI] )
			cBuffer += iif( empty(cBuffer), "", ";" ) + aDados[nI,nJ]
		next

		FWrite(nHandle, cBuffer + CRLF)

		nI++
	end
end


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณExecuta o update para flegar os itens exportadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQuery := ""

cQuery := " UPDATE " + retsqlname("SE1")  + " SET "+ CRLF
cQuery += " 	E1_01DTEXP = '"+Dtos(dDatabase)+"' "+ CRLF
cQuery += " WHERE "+ CRLF
//cQuery += "   	E1_FILIAL IN ("+cFilAtu+") "+CRLF
cQuery += " D_E_L_E_T_  = ''"+CRLF
cQuery += " AND E1_SALDO 	> 0 "+CRLF
cQuery += " AND E1_EMISSAO BETWEEN '"+Dtos(Mv_Par01)+"' AND '"+Dtos(Mv_Par02)+"' "+CRLF
//cQuery += " AND E1_VENCREA BETWEEN '"+Dtos(Mv_Par01)+"' AND '"+Dtos(Mv_Par02)+"' "+CRLF
cQuery += " AND E1_NSUTEF <> ''  "+CRLF
cQuery += " AND E1_01NOOPE <> ' ' "+CRLF
If Mv_Par03==2
	cQuery	+= "   AND 	E1_01DTEXP <> ' ' "+CRLF
Endif

If (TCSQLExec(cQuery) < 0)
	Return MsgStop("TCSQLError() " + TCSQLError())
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออหอออออออัออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRecebeTitulos บAutor  ณMicrosiga       บ Data ณ  10/07/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para a recebimento dos titulos para conciliacao de   บฑฑ
ฑฑบ          ณcartoes.                                                 	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Bio-Ritmo                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RecebeTitulos()

Local cArquivo  := ""
Local cArq01   	:= ""
Local cTipoArq 	:= "Todos os Arquivos *.* | *.* |"
Local cDirDocs 	:= "C:\TEMP\"
Local cDirServ	:= "\importacao\"
Local nX		:= 0
Local nZa		:= 0
Local nHdl		:= 0
Local nHandle	:= 0
Local aCombo	:= {"Sim","Nใo"}
Local aArqTemp	:= {}
Local aBoxParam	:= {}
Local aRetParam	:= {}
Local lGeraSE2	:= .F.

//Carrego todOs arquivos textos da maquina local para exclui-los
aArqTemp := Directory(cDirDocs+"*.LOG")
aEval(aArqTemp, {|x| FErase(cDirDocs+x[1])})

//Cria Diretorio
MakeDir(cDirDocs)

//Cria Diretorio
MakeDir(cDirServ)

cArquivo := cGetFile(cTipoArq,"Selecione o arquivo para inporta็ใo.",0,,.T.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE,.F.)

IF !Empty(cArquivo)
	
	//Copia o arquivo local para o servidor
	lRet := CpyT2S( cArquivo , cDirServ , .F. )
	If lRet
		cArquivo := SubStr(cArquivo,RAT("\",cArquivo) + 1,Len(cArquivo))
	Endif
	cArq01 := Substr(cArquivo,1,Len(cArquivo)-4)
	
	//Abre o arquivo que sera importado
	nHdl := FT_FUSE(cDirServ+cArquivo)
	If nHdl == -1
		MsgStop("Erro na criacao do arquivo."	)
		Return(.T.)
	EndIf
/*	
	----- OS TอTULOS Jม EXISTEM, NรO PRECISA GERม-LOS

	//Verifica se ira gerar contas a pagar das taxas dos adquirentes.
	Aadd(aBoxParam,{2,"Gera Contas a Pagar"	,aCombo[1],aCombo,100,"",.F.})
	IF !ParamBox(aBoxParam,"Informe os Parametros",@aRetParam)
		Return(.T.)
	EndIf
	lGeraSE2 := IIF( MV_PAR01 == aCombo[1] 	, .T. , .F. )
*/
	//Gera tabela temporario no BD
	GeraTmp(cArquivo)
	
	//Carrega os dados na tabela temporario no BD
	Processa( {|lEnd| LeArquivo() } , "Aguarde, Processando Arquivo. Esta opera็ใo pode levar alguns minutos.")
	
	//Executa a conciliacao dos cartoes nas empresas carregadas
	For nX := 1 To Len(aEmpresas) 
		
//		FwMsgRun( ,{|| STARTJOB("U_BRCONARQ",GetEnvServer(),.T.,aEmpresas[nX],'01',cEmpOfic,lGeraSE2,cArqTrb,cArq01)  }, , "Aguarde, Conciliando arquivo da empresa "+aEmpresas[nx] )
		FwMsgRun( ,{|| U_BRCONARQ(aEmpresas[nX],'01',cEmpOfic,lGeraSE2,cArqTrb,cArq01)  }, , "Aguarde, Conciliando arquivo da empresa "+aEmpresas[nx] )
			
	Next
	
	//Fecha o arquivo importado.
	If !FCLOSE(nHdl)
		MsgStop("Erro ao fechar arquivo, erro numero: " +  Alltrim(Str(fError())) ,"Atencao!")
	Endif
	
	// Fecha Area Se Estiver Aberta
	If Select(cArqTrb) > 0
		DbSelectArea(cArqTrb)
		DbCloseArea(cArqTrb)
	EndIf
	
	//Fecha tabela Temporaria.
	TcDelFile(cArqTrb)
	
	//Carrego todas arquivos textos do servidor
	aArqTemp := Directory(cDirServ+"*.LOG")
	
	// Copia do Servidor para a esta็ใo
	For nZa := 1 To Len(aArqTemp)
		CpyS2T(cDirServ+aArqTemp[nZa,1],cDirDocs,.T.)
	Next
	aEval(aArqTemp, {|x| FErase(cDirServ+x[1])})
	
	//Carrego todas arquivos textos da maquina local
	aArqLogs := Directory(cDirDocs+"*.LOG")
	
EndIF

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGeraTMP   บAutor  ณ                    บ Data ณ  02/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera arquivo temporario GeraTMP atraves do arquivo XXX      บฑฑ
ฑฑบ          ณimportado atraves do comando APPEND						  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GeraTMP(cArquivo)

Local aCpoTMP	:= {}
Local aCampos	:= {}

AADD(aCpoTMP, {"CABEC"		,"C", 10, 0}) // CABECALHO
AADD(aCpoTMP, {"COD_ERP"	,"C", 30, 0}) // COD_ERP
//AADD(aCpoTMP, {"LOJA_FIL"	,"C", 04, 0}) // LOJA_FILIAL
AADD(aCpoTMP, {"LOJA_FIL"	,"C", 40, 0}) // LOJA_FILIAL
AADD(aCpoTMP, {"TIPO_LAN"	,"C", 20, 0}) // TIPO_LANCAMENTO
AADD(aCpoTMP, {"DESCRICA"	,"C", 30, 0}) // DESCRICAO
AADD(aCpoTMP, {"NRO_PARC"	,"C", 20, 0}) // NRO_PARCELA
AADD(aCpoTMP, {"ADQUIREN"	,"C", 20, 0}) // ADQUIRENTE
AADD(aCpoTMP, {"BANDEIRA"	,"C", 20, 0}) // BANDEIRA
AADD(aCpoTMP, {"TIPO_TRA"	,"C", 20, 0}) // TIPO_TRANSACAO
AADD(aCpoTMP, {"NSU"		,"C", 30, 0}) // NSU
AADD(aCpoTMP, {"AUTORIZA"	,"C", 20, 0}) // AUTORIZACAO
AADD(aCpoTMP, {"DT_PAGAM"	,"D", 08, 0}) // DT_PAGAMENTO
AADD(aCpoTMP, {"VLR_PAGO"	,"N", 20, 2}) // VLR_PAGO
AADD(aCpoTMP, {"TAXA"		,"N", 20, 2}) // TAXA
AADD(aCpoTMP, {"STATUS"		,"C", 10, 0}) // STATUS
AADD(aCpoTMP, {"REFER1"		,"C", 20, 0}) // REFER1
AADD(aCpoTMP, {"REFER2"		,"C", 20, 0}) // REFER2
AADD(aCpoTMP, {"NRO_ANTEC"	,"C", 20, 0}) // NRO_ANTECIPACAO
AADD(aCpoTMP, {"VLR_DESC_"	,"C", 20, 0}) // VLR_DESC_ANTECIP
AADD(aCpoTMP, {"NRO_BANCO"	,"C", 20, 0}) // NRO_BANCO
AADD(aCpoTMP, {"NRO_AGENC"	,"C", 20, 0}) // NRO_AGENCIA
AADD(aCpoTMP, {"NRO_CONTA"	,"C", 20, 0}) // NRO_CONTA
AADD(aCpoTMP, {"TID"		,"C", 20, 0}) // TID
AADD(aCpoTMP, {"TERMINAL"	,"C", 20, 0}) // TERMINAL

DBCreate(cArqTrb,aCpoTMP,"TOPCONN")

// Fecha Area Se Estiver Aberta
If Select(cArqTrb) > 0
	DbSelectArea(cArqTrb)
	DbCloseArea(cArqTrb)
EndIf

DbUseArea(.T.,"TOPCONN",cArqTrb,cArqTrb,.T.,.F.)
DbCreateIndex(cArqTrb+"1","COD_ERP",{|| COD_ERP },.F.)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ LeArquivoณ Autor ณ        TOTVS          ณ Data ณ 16/07/15 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Faz a leitura do arquivo e realiza a baixa dos titulos.    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function LeArquivo()

Local aTitulos 	:= {}
Local cLoja_Fil := ""
Local cBuffer

FT_FGOTOP()
ProcRegua(FT_FLASTREC())

While !FT_FEOF()
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Leitura do arquivo texto.                                      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cBuffer  := FT_FREADLN()
	aTitulos := Separa(cBuffer , ";")
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ`ฟ
	//ณDesconsiderar registros do Header (C01) e Trailler (C03)ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ`ู
	If Alltrim(aTitulos[1]) $ "C01;C03"
		FT_FSKIP(1)
		Loop
	Endif
	
	IncProc()
	
	cLoja_Fil := StrTran(aTitulos[03],"-","")
		
	If Alltrim(aTitulos[04])=="ALG"
		FT_FSKIP(1)
		Loop
	Endif
	
	RecLock(cArqTrb,.T.)
	
	REPLACE CABEC		WITH aTitulos[01]
	REPLACE COD_ERP		WITH aTitulos[02]
	REPLACE LOJA_FIL	WITH cLoja_Fil
	REPLACE TIPO_LAN	WITH aTitulos[04]
	REPLACE DESCRICA	WITH aTitulos[05]
	REPLACE NRO_PARC	WITH aTitulos[06]
	REPLACE ADQUIREN	WITH aTitulos[07]
	REPLACE BANDEIRA	WITH aTitulos[08]
	REPLACE TIPO_TRA	WITH aTitulos[09]
	REPLACE NSU			WITH aTitulos[10]
	REPLACE AUTORIZA	WITH aTitulos[11]
	REPLACE DT_PAGAM	WITH Ctod(atitulos[12])
	REPLACE VLR_PAGO	WITH RetValor(aTitulos[13])
	REPLACE TAXA		WITH RetValor(aTitulos[14])
	REPLACE STATUS		WITH aTitulos[15]
	REPLACE REFER1		WITH aTitulos[17]
	REPLACE REFER2		WITH aTitulos[17]
	REPLACE NRO_ANTEC	WITH aTitulos[18]
	REPLACE VLR_DESC_	WITH aTitulos[19]
	REPLACE NRO_BANCO	WITH aTitulos[20]
	REPLACE NRO_AGENC	WITH aTitulos[21]
	REPLACE NRO_CONTA	WITH aTitulos[22]
	REPLACE TID			WITH aTitulos[23]
	REPLACE TERMINAL	WITH aTitulos[24]
	
	MsUnLock()
	
//	nPos := Ascan( aEmpresas , Left(cLoja_Fil,2) )
	nPos := Ascan( aEmpresas , cLoja_Fil )
	If nPos==0
//		AAdd( aEmpresas , Left(cLoja_Fil,2) )
		AAdd( aEmpresas , cLoja_Fil )
	Endif
	
	FT_FSKIP(1)
EndDo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณOrdena o vetor das empresas   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aEmpresas := ASort(aEmpresas, , , {|x,y|x < y})

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ CoArquivoณ Autor ณ         TOTVS         ณ Data ณ 16/07/15 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Faz a conciliacao dos cartoes conforme registros lido no   ณฑฑ
ฑฑณ          ณ arquivo importado.                                         ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function BRCONARQ(cEmpresa,cFil,cEmpOfic,lGeraSE2,cArqTrb,cArq01)

Local aArea  	:= GetArea()
Local cAlias 	:= GetNextAlias()
Local nValor	:= 0
Local nVlrTX	:= 0
Local cQuery	:= ""
Local cBanco	:= ""
Local cAgencia  := ""
Local cConta    := ""
Local cTpPagto	:= ""
Local cEmpAtu	:= ""
//Local cFilAtu 	:= ""
Local cPrefixo	:= ""
Local cNumero	:= ""
Local cParcela	:= ""
Local cTipo		:= ""
Local cCliente	:= ""
Local cLoja		:= ""
Local cChave	:= ""
Local cDirServ	:= "\importacao\"
Local lBcoOk	:= .T.
Local aAdmFin	:= {}

//nHandle := MsfCreate(cDirServ+"LOG_"+cEmpresa+"_"+cArq01+".LOG",0)
nHandle := MsfCreate(cDirServ+"CONCILIACAO_"+Dtos(Date())+"_FILIAL_"+cEmpresa+".LOG",0)

fWrite(nHandle	,	"OPERACAO"			+ ";" )
fWrite(nHandle	,	"TIPO_LANCAMENTO"	+ ";" )
fWrite(nHandle	,	"LOJA_FIL"			+ ";" )
fWrite(nHandle	,	"OCORRENCIA"		+ ";" )
fWrite(nHandle	,	"ID_REGISTRO"		+ ";" )
fWrite(nHandle	,	CRLF )

//PREPARE ENVIRONMENT EMPRESA cEmpresa FILIAL '01' USER 'Administrador' PASSWORD 'protheus2015' TABLES 'SE1,SA1,SE2,SE5' MODULO 'FIN'
//InitPublic()
//SetsDefault()
//Conout("PREPARE ENVIRONMENT EMPRESA "+cEmpresa+" FILIAL '01' ")

//cQuery := " SELECT * FROM "+cArqTrb+" TMP WHERE LEFT(LOJA_FIL,2) = '"+cEmpresa+"' ORDER BY LOJA_FIL "
cQuery := " SELECT * FROM "+cArqTrb+" TMP WHERE LOJA_FIL = '"+cEmpresa+"' ORDER BY LOJA_FIL "
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

(cAlias)->(DbGotop())
While (cAlias)->(!Eof())
	
	lBcoOk	 := .T.
	cBanco 	 := PADR( (cAlias)->NRO_BANCO  , 3 )
	cAgencia := Strzero( Val( (cAlias)->NRO_AGENC ) , 4 )
	cConta 	 := Alltrim( Str( Val( (cAlias)->NRO_CONTA ) ) )
	
//	lBcoOk 	 := ValidSA6((cAlias)->LOJA_FIL , @cBanco , @cAgencia , @cConta  )
	lBcoOk 	 := ValidSA6(cEmpAnt , @cBanco , @cAgencia , @cConta  )
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณValida a existencia do banco, agencia e contaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If !lBcoOk
		Conout("BANCO NAO ENCONTRADO "+cBanco +" "+ cAgencia +" "+ cConta)
		//Grava registros com erros no arquivo
		fWrite(nHandle	,	'BANCO'										+ ";" )
		fWrite(nHandle	,	ALLTRIM((cAlias)->TIPO_LAN)					+ ";" )
		fWrite(nHandle	,	Alltrim((cAlias)->LOJA_FIL)					+ ";" )
		fWrite(nHandle	,	"Banco nใo cadastrado" 						+ ";" )
		fWrite(nHandle	,	cBanco +" "+ cAgencia +" "+ cConta 			+ ";" )
		fWrite(nHandle	,	CRLF )
		
		(cAlias)->(DbSkip())
		Loop
	Endif
	
	cTpPagto 	:= Alltrim((cAlias)->TIPO_LAN)
	cChave	 	:= Alltrim((cAlias)->COD_ERP)
//	cEmpAtu		:= SubStr(cChave,1,2)
	cFilAtu		:= xFilial("SE1")

	cPrefixo	:= ""
	cNumero		:= ""
	cParcela	:= ""
	cTipo		:= ""
	cCliente	:= ""
	cLoja		:= ""

	if len(cChave) == 25
		cPrefixo	:= SubStr(cChave,01,3)
		cNumero		:= SubStr(cChave,04,9)
		cParcela	:= SubStr(cChave,13,1)
		cTipo		:= SubStr(cChave,15,3)
		cCliente	:= SubStr(cChave,18,6)
		cLoja		:= SubStr(cChave,24,2)
	endif

	nValor		:= (cAlias)->VLR_PAGO
	
	If !Empty( cChave )
	
		lOk  := .F.
		lOk1 := .F.
		
		SE1->(DbSetOrder(1))
//		If SE1->(DbSeek( cFilAtu + cPrefixo + cNumero + cParcela + cTipo ))
		If SE1->(DbSeek( xFilial("SE1") + cChave ))
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณExecuta a baixa do Titulo quando o tipo de pagamento iniciar com a letra "P" (Pagamento)ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If Left(cTpPagto,1)=="P" .And. Empty(SE1->E1_BAIXA)
//				lOk := BaixaSE1(SE1->E1_FILIAL,SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_CLIENTE,SE1->E1_LOJA,cBanco,cAgencia,cConta,(cAlias)->DT_PAGAM,nValor)

//				_nSalvRec := SE1->(Recno())
//				_nTotAbat :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
//				SE1->( dbGoTo( _nSalvRec ) )
				_nSaldo   :=  SE1->E1_SALDO + SE1->E1_ACRESC - SE1->E1_DECRESC //- _nTotAbat

				_nValTX   := _nSaldo - nValor

				lOk := BaixaSE1(SE1->E1_FILIAL,SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_CLIENTE,SE1->E1_LOJA,cBanco,cAgencia,cConta,(cAlias)->DT_PAGAM,_nSaldo)
				If lOk
					CONOUT('TITULO_BAIXADO '+SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE+SE1->E1_LOJA)

					//Grava registros com erros no arquivo
					fWrite(nHandle	,	'TITULO_BAIXADO'													+ ";" )
					fWrite(nHandle	,	ALLTRIM((cAlias)->TIPO_LAN)											+ ";" )
					fWrite(nHandle	,	Alltrim((cAlias)->LOJA_FIL)											+ ";" )
					fWrite(nHandle	,	"Titulo baixado"													+ ";" )
					fWrite(nHandle	,	SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE+SE1->E1_LOJA 	+ ";" )
					fWrite(nHandle	,	CRLF )

					BxTaxa( _nValTX, dDatabase, cBanco,cAgencia,cConta )

				Endif
			Else								
				CONOUT(If(Left(cTpPagto,1)=="P",'BAIXADO_ANTERIORMENTE ','INCLUIDO_ANTERIORMENTE ')+cFilAtu + cPrefixo + cNumero + cParcela + cTipo + cCLiente+cLoja )
				//Grava registros com erros no arquivo								
				fWrite(nHandle	,	If(Left(cTpPagto,1)=="P",'BAIXADO_ANTERIORMENTE','INCLUIDO_ANTERIORMENTE')	+ ";" )
				fWrite(nHandle	,	ALLTRIM((cAlias)->TIPO_LAN)											+ ";" )
				fWrite(nHandle	,	Alltrim((cAlias)->LOJA_FIL)											+ ";" )
				fWrite(nHandle	,	If(Left(cTpPagto,1)=="P","Registro baixado anteriormente",'Registro incluido anteriormente') + ";" )
				fWrite(nHandle	,	cFilAtu + cPrefixo + cNumero + cParcela + cTipo + cCLiente+cLoja 	+ ";" )
				fWrite(nHandle	,	CRLF )
			Endif
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณExecuta a inclusao do Titulo quando o tipo de pagamento iniciar com a letra "C" ou "E!  ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If Left(cTpPagto,1)$"C|E"
				nValor := nValor *-1
				lOk1 := GeraSE1(cFilAtu,cPrefixo,cNumero,cParcela,"NCC",cCliente,cLoja,nValor,(cAlias)->DT_PAGAM)
				If lOk
					CONOUT('TITULO_INCLUIDO '+cFilAtu+cPrefixo+cNumero+cParcela+"NCC"+cCliente+cLoja )
					
					//Grava registros com erros no arquivo
					fWrite(nHandle	,	'TITULO_INCLUIDO'													+ ";" )
					fWrite(nHandle	,	ALLTRIM((cAlias)->TIPO_LAN)											+ ";" )
					fWrite(nHandle	,	Alltrim((cAlias)->LOJA_FIL)											+ ";" )
					fWrite(nHandle	,	"Titulo incluido"													+ ";" )
					fWrite(nHandle	,	cFilAtu+cPrefixo+cNumero+cParcela+"NCC"+cCliente+cLoja 				+ ";" )
					fWrite(nHandle	,	CRLF )
				Endif				
			Endif
			
		Else			                          
			CONOUT('TITULO_NAO_ENCONTRADO '+cFilAtu+cPrefixo+cNumero+cParcela+"NCC"+cCliente+cLoja )			
			//Grava registros com erros no arquivo
			fWrite(nHandle	,	'TITULO_NAO_ENCONTRADO'																	+ ";" )
			fWrite(nHandle	,	ALLTRIM((cAlias)->TIPO_LAN)																+ ";" )
			fWrite(nHandle	,	Alltrim((cAlias)->LOJA_FIL)																+ ";" )
			fWrite(nHandle	,	"Registro no encontrado no sistema"														+ ";" )
			fWrite(nHandle	,	cFilAtu +" "+ cPrefixo +" "+ cNumero +" "+ cParcela +" "+ cTipo +" "+ cCLiente+cLoja	+ ";" )
			fWrite(nHandle	,	CRLF )
			
		Endif
		
	Else
		CONOUT('TITULO_NAO_CONCILIADO '+ALLTRIM((cAlias)->NSU) )		
		//Grava registros com erros no arquivo
		fWrite(nHandle	,	'TITULO_NAO_CONCILIADO'						+ ";" )
		fWrite(nHandle	,	ALLTRIM((cAlias)->TIPO_LAN)					+ ";" )
		fWrite(nHandle	,	Alltrim((cAlias)->LOJA_FIL)					+ ";" )
		fWrite(nHandle	,	"Registro nao conciliado NSU: "				+ ";" )
		fWrite(nHandle	,	ALLTRIM((cAlias)->NSU)						+ ";" )
		fWrite(nHandle	,	CRLF )
		
	Endif
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAcumula os valores das taxas para gera็ใo do contas a pagar.		ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If (cAlias)->TAXA > 0
	
//		nVlrTX := ((cAlias)->VLR_PAGO * (cAlias)->TAXA)/100
		nVlrTX := (cAlias)->TAXA
		nPos   := AScan( aAdmFin, { |x| x[1]+x[2] == Alltrim((cAlias)->LOJA_FIL)+Alltrim((cAlias)->ADQUIREN) } )
		If nPos==0
			AAdd( aAdmFin , { Alltrim((cAlias)->LOJA_FIL) , Alltrim((cAlias)->ADQUIREN) , nVlrTX , (cAlias)->DT_PAGAM } )
		Else
			aAdmFin[nPos,3] += nVlrTX
		Endif
		
	Endif
		
	(cAlias)->(DbsKIP())
End
(cAlias)->( dbCloseArea() )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณExecuta a inclusao do Titulo no contas a pagar. 										   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lGeraSE2
	Conout("GERACAO DO CONTAS A PAGAR")	
	For nX1 := 1 To Len(aAdmFin)
		GeraSE2(aAdmFin[nX1,1],aAdmFin[nX1,2],aAdmFin[nX1,3],aAdmFin[nX1,4])
	Next
	
Endif

//RESET ENVIRONMENT
//Conout("RESET ENVIRONMENT")

FClose(nHandle)

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ BaixaSE1 ณ Autor ณ  Eduardo Patriani     ณ Data ณ 16/07/15 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Baixa o titulo financeiro.                                 ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function BaixaSE1(cFilAtu,cPrefixo,cTitulo,cParcela,cTipo,cCliente,cLoja,cBanco,cAgencia,cConta,dDataPgto,nVlrRec)
Local aBaixa 		:= {}
Local lMSHelpAuto	:= .T.
Local lMsErroAuto 	:= .F.
Local cFilOld		:= cFilAnt
Local lRet			:= .T.

cFilAnt := cFilAtu

AAdd(aBaixa,{"E1_PREFIXO"	,cPrefixo	, Nil})
AAdd(aBaixa,{"E1_NUM"    	,cTitulo	, Nil})
AAdd(aBaixa,{"E1_PARCELA"	,cParcela	, Nil})
AAdd(aBaixa,{"E1_TIPO"   	,cTipo		, Nil})
AAdd(aBaixa,{"E1_CLIENTE"	,cCliente	, Nil})
AAdd(aBaixa,{"E1_LOJA"   	,cLoja		, Nil})
AAdd(aBaixa,{"AUTMOTBX"  	,"NORMAL"  	, Nil})
aAdd(aBaixa,{"AUTVALREC"    ,nVlrRec  	,Nil})
AAdd(aBaixa,{"AUTDTBAIXA"	,Stod(dDataPgto), Nil})
AAdd(aBaixa,{"AUTBANCO"		,cBanco		, Nil})
AAdd(aBaixa,{"AUTAGENCIA"	,cAgencia	, Nil})
AAdd(aBaixa,{"AUTCONTA"		,cConta		, Nil})

MsExecAuto({|x,y|FINA070(x,y)},aBaixa,3)

IF lMsErroAuto
	MostraErro()
	lRet := .F.
EndIF

cFilAnt := cFilOld

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ GeraSE1  ณ Autor ณ  Eduardo Patriani     ณ Data ณ 16/07/15 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Gera  titulo financeiro do tipo NCC.                       ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GeraSE1(cFilAtu,cPrefixo,cTitulo,cParcela,cTipo,cCliente,cLoja,nValor,dDataPgto)

Local aRotAuto 		:= {}
Local lMSHelpAuto	:= .T.
Local lMsErroAuto 	:= .F.
Local cNatRec  		:= GetMv("MV_BRNATCA",,"3202A")
Local cFilOld		:= cFilAnt
Local lRet			:= .T.

cFilAnt := cFilAtu

AAdd( aRotAuto, { "E1_PREFIXO", cPrefixo						, NIL } )
AAdd( aRotAuto, { "E1_NUM"    , cTitulo							, NIL } )
AAdd( aRotAuto, { "E1_PARCELA", cParcela						, NIL } )
AAdd( aRotAuto, { "E1_NATUREZ", cNatRec							, NIL } )
AAdd( aRotAuto, { "E1_TIPO"   , cTipo							, NIL } )
AAdd( aRotAuto, { "E1_CLIENTE", cCliente						, NIL } )
AAdd( aRotAuto, { "E1_LOJA"   , cLoja							, NIL } )
AAdd( aRotAuto, { "E1_VALOR"  , nValor							, NIL } )
AAdd( aRotAuto, { "E1_EMISSAO", Stod(dDataPgto)					, NIL } )
AAdd( aRotAuto, { "E1_VENCTO" , Stod(dDataPgto)					, NIL } )
AAdd( aRotAuto, { "E1_VENCREA", DataValida( Stod(dDataPgto) )	, NIL } )

MSExecAuto({|x, y| FINA040(x, y)}, aRotAuto, 3 )

IF lMsErroAuto
	MostraErro()
	lRet := .F.
EndIF

cFilAnt := cFilOld

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ GeraSE2  ณ Autor ณ  Eduardo Patriani     ณ Data ณ 16/07/15 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Gera titulo financeiro no contas a pagar        			  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GeraSE2(cFilAtu,cAdquirente,nValor,dDataPgto)

Local cForn01		:= GetMv("SY_FORVISA",,"INQFOH01")	//Fornecedor VISANET corresponde ao ADQUIRENTE CIELO
Local cForn02		:= GetMv("SY_FORAMEX",,"77015301")	//Fornecedor BANCO AMERICAN EXPRESS corresponde ao ADQUIRENTE AMEX
Local cForn03		:= GetMv("SY_FORREDE",,"77004801")	//Fornecedor REDECARD corresponde ao ADQUIRENTE REDECARD
Local cNaturez		:= GetMv("SY_NATCONC",,"4201") 		//Natureza
Local cFornece		:= ""
Local cLoja			:= ""
Local cFilOld		:= cFilAnt
Local aRotAuto 		:= {}
Local lMSHelpAuto	:= .T.
Local lMsErroAuto 	:= .F.

//cFilAnt := Right(cFilAtu,2)

// NรO USADA, VISTO QUE O TอTULO Jม EXISTE
RETURN .F.                                          

If Alltrim(cAdquirente)=="AMEX"
	cFornece := Left(cForn02,6)
	cLoja	 := Right(cForn02,2)
ElseIf Alltrim(cAdquirente)=="CIELO"
	cFornece := Left(cForn01,6)
	cLoja	 := Right(cForn01,2)
Else
	cFornece := Left(cForn03,6)
	cLoja	 := Right(cForn03,2)
Endif

AAdd( aRotAuto , {"E2_PREFIXO"		,"TXA"					, Nil})
AAdd( aRotAuto , {"E2_NUM"    		,Dtos(dDatabase)		, Nil})
AAdd( aRotAuto , {"E2_PARCELA"		,"01"   				, Nil})
AAdd( aRotAuto , {"E2_TIPO"   		,"TX" 					, Nil})
AAdd( aRotAuto , {"E2_NATUREZ"   	,cNaturez				, 'AlwaysTrue()'})
AAdd( aRotAuto , {"E2_FORNECE" 		,cFornece		   		, Nil})
AAdd( aRotAuto , {"E2_LOJA"   		,cLoja	   				, Nil})
Aadd( aRotAuto , {"E2_EMISSAO"		,Stod(dDataPgto)		, Nil})
Aadd( aRotAuto , {"E2_VENCTO"		,Stod(dDataPgto)		, Nil})
Aadd( aRotAuto , {"E2_VENCREA"		,DataValida(Stod(dDataPgto)), Nil})
Aadd( aRotAuto , {"E2_VALOR"		,nValor					, Nil})

MSExecAuto({|x,y,z| Fina050(x,y,z)},aRotAuto,,3)

If lMsErroAuto
	MostraErro()
Else
	RecLock("SE2",.F.)
	SE2->E2_NATUREZ := cNaturez
//	SE2->E2_DESCNAT := Posicione("SED",1,xFilial("SED")+SE2->E2_NATUREZ,'ED_DESCRIC')	
	Msunlock()
EndIf

cFilAnt := cFilOld

Return(.T.)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaSx1 บAutor  ณ SYMM Consultoria	 บ Data ณ  20/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria Perguntas na SX1 atraves da funcao PUTSX1().          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function AjustaSx1(cPerg)
Local aPergs   := {}
Local aRet     := {}
Local dEmissao := CtoD("")
Local lRet     := .F.

//Local aHlpPor01 := {}
//Local aHlpPor02 := {}
//Local aHlpPor03 := {}

//PutSx1(cPerg,"01","Do Emissใo"		,"Do Emissใo"	,"Do Emissใo"		,"MV_CH1","D",TamSx3("E1_EMISSAO")[1]	,0,0,"G","",""	,"","","mv_par01","","","","","","","","","","","",""," ","","","",aHlpPor01)
//PutSx1(cPerg,"02","Ate Emissใo"		,"Ate Emissใo"	,"Ate Emissใo"		,"MV_CH2","D",TamSx3("E1_EMISSAO")[1]	,0,0,"G","",""	,"","","mv_par02","","","","","","","","","","","",""," ","","","",aHlpPor02)
//PutSx1(cPerg,"03","Reenvia Arquivo" 	,"Reenvia Arquivo"	,"Reenvia Arquivo"  	,"MV_CH3"	,"N"		,1			,0			,1			,"C"	,""			,""		,""			,""			,"mv_par03"	,"Nao"			,"Nao"			,"Nao"			,			,"Sim"		,"Sim"		,"Sim"		,""  			,""  			,""  			,""    					,""    					,""						,""			,""			,""			,aHlpPor03  ,			,			,)
//PutSx1(<cGrupo>		,<cOrdem>	,<cPergunt>				,<cPerSpa>				,<cPerEng>				,<cVar>		,<cTipo>	,<nTamanho>	,<nDecimal>,<nPresel>	,<cGSC>	,<cValid>	,<cF3>	,<cGrpSxg>	,<cPyme>	,<cVar01>	,<cDef01>		,<cDefSpa1>		,<cDefEng1>		,<cCnt01>	,<cDef02>	,<cDefSpa2>	,<cDefEng2>	,<cDef03>		,<cDefSpa3>		,<cDefEng3>		,<cDef04>				,<cDefSpa4>				,<cDefEng4>				,<cDef05>	,<cDefSpa5>	,<cDefEng5>	,<aHelpPor>	,<aHelpEng>	,<aHelpSpa>	,<cHelp>)

aAdd( aPergs ,{1,"Emissใo De: "       , dEmissao  ,"@!"			           ,'.t.',""  ,'.t.'	   , 50,.t.})
aAdd( aPergs ,{1,"Emissใo At้: "      , dEmissao  ,"@!"			           ,'.t.',""  ,'.t.'	   , 50,.t.})
aAdd( aPergs ,{2,"Reenvia Arquivo:"  ,2       ,{"1-Nao","2-Sim","3-Ambos" }, 50  ,""     ,.t.})

If ParamBox(aPergs ,"Parametros ",aRet, /*4*/, /*5*/, /*6*/, /*7*/, /*8*/, /*9*/, /*10*/, .F.)
	Mv_Par01 := aRet[01]
	Mv_Par02 := aRet[02]
	Mv_Par03 := aRet[03]

	if valtype(Mv_Par03) != "N"
		Mv_Par03 := val(left(aRet[03],1))
	endif
	
	lRet := .T.
endif
Return lRet

Static Function FilEmpresas()

Local cQuery := ""
Local nPos	 := 0
Local cAlias := CriaTrab(,.F.)

cQuery += "SELECT ZZ1_COD,ZZ1_CODFIL,ZZ1_NOMEMP FROM ZZ1010 (NOLOCK) WHERE ZZ1_XINTEG = '1' AND D_E_L_E_T_ = ' ' ORDER BY ZZ1_COD,ZZ1_CODFIL "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

dbSelectArea(cAlias)
dbGoTop()
While !Eof()
	
	nPos := AScan( aEmpresas, { |x| x[1] == (cAlias)->ZZ1_COD } )
	If nPos = 0
		AAdd( aEmpresas , { (cAlias)->ZZ1_COD , "'"+(cAlias)->ZZ1_CODFIL+"'," } )
	Else
		aEmpresas[nPos,2] +=  "'"+(cAlias)->ZZ1_CODFIL+"',"
	Endif
	
	
	dbSelectArea(cAlias)
	dbSkip()
EndDo
(cAlias)->(dbCloseArea())

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetValor  บAutor  ณSYMM Consultoria    บ Data ณ  02/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function RetValor(cString)

Local cAux	 := ""
Local nValor := 0

cAux 	:= Subs(cString,1,Len(cString)-2)+","+Right(cString,2)
cString := cAux

nValor := Val(StrTran(StrTran(cString,"."),",","."))

Return nValor

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidSA6  บAutor  ณSYMM Consultoria    บ Data ณ  02/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function ValidSA6( cEmpresa , cBanco , cAgencia , cConta)

Local cQuery := ""
Local lRet	 := .F.
Local cAlias := GetNextAlias()

cEmpresa := Alltrim(cEmpresa)

cQuery := " SELECT A6_COD,A6_AGENCIA,A6_NUMCON "
//cQuery += " FROM SA6"+Left(cEmpresa,2)+"0 SA6 "
cQuery += " FROM "+retSqlName("SA6")+" SA6 "
cQuery += " WHERE A6_FILIAL = '"+xFilial("SA6")+"' "
cQuery += " AND A6_COD 		= '"+cBanco+"' "
cQuery += " AND A6_AGENCIA 	LIKE '%"+cAgencia+"%' "
cQuery += " AND (A6_NUMCON 	LIKE '%"+cConta+"%' "
cQuery += " or A6_NUMCON 	LIKE '%"+left(cConta, len(cConta)-1)+"%' )"
//cQuery += " AND A6_BLOCKED 	= '2' "
cQuery += " AND SA6.D_E_L_E_T_ = ' ' "
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

(cAlias)->(DbGotop())
While (cAlias)->(!Eof())
	lRet 	 := .T.
	cBanco	 := (cAlias)->A6_COD
	cAgencia := (cAlias)->A6_AGENCIA
	cConta 	 := (cAlias)->A6_NUMCON
	
	(cAlias)->(DbsKIP())
End
(cAlias)->( dbCloseArea() )

Return lRet 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMtnTelaErrบAutor  ณ SYMM CONSULTORIA   บ Data ณ  18/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina Monta tela com erros encontrados na integra็ใo       บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MtnTelaErr()
Local aArea		:= GetArea()
Local aTitTwBr	:= {"Tํtulos"} 
Local aTamBrw	:= {200}
Local oDlgErro	

Define MsDialog oDlgErro Title "Retorno da Concilia็ใo" From 0,0 To 375,790 Pixel Of oDlgErro
		
	If Len(aLogs) <= 0
		aAdd(aLogs,{""})
	EndIf
				
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPainel Layerณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤู           
	oFwLayer := FwLayer():New()
	oFwLayer:Init(oDlgErro,.F.)    
	
   	//ฺฤฤฤฤฤฤฤฤฤฤฟ
	//ณ1o. Painelณ
	//ภฤฤฤฤฤฤฤฤฤฤู
	oFWLayer:addLine("SYERROPV",100, .F.)
	oFWLayer:addCollumn( "COLERROPV",100, .F. , "SYERROPV")
	oFWLayer:addWindow( "COLERROPV", "WINENT", "Retorno da Concilia็ใo", 100, .F., .F., , "SYERROPV") 
	oFwTwbr := oFWLayer:GetWinPanel("COLERROPV","WINENT","SYERROPV")	
	
	oFolder:=TFolder():New(0,0,{"Contas a Receber"},,oFwTwbr,,,,.T.,.F.,0,0)
	oFolder:Align := CONTROL_ALIGN_ALLCLIENT
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณTitulos nao baixados |
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oTwBrowse := TWBrowse():New(00,00,00,00,,aTitTwBr,aTamBrw,oFolder:aDialogs[1],,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
	oTwBrowse:SetArray(aLogs)
	oTwBrowse:bLine := {|| {aLogs[oTwBrowse:nAt,1]}} 
	oTwBrowse:Align 		:= CONTROL_ALIGN_ALLCLIENT
	
Activate dialog oDlgErro Center

RestArea(aArea)
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImportaTxtบAutor  ณ SYMM CONSULTORIA   บ Data ณ  20/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImporta os arquivos de Logs para apresentacao em tela.      บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ImportaTxt(cArquivo,aLogs)

Local cLinha 	:= ""
Local cDesc	 	:= ""
Local cTipo	 	:= ""
Local cEmpresa 	:= ""
Local Detalhes  := ""
Local cID		:= ""
Local aTitulos	:= {}

FT_FUSE(cArquivo)
FT_FGOTOP()
While !FT_FEOF()
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Carrega campos ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cLinha 	:= FT_FREADLN()
	aTitulos:= Separa(cLinha,";") 
	
	If UPPER(aTitulos[1]) == "OPERACAO"
		FT_FSKIP()	
		Loop		
	Endif
	
	cDesc	:= aTitulos[1]
	cTipo	:= aTitulos[2]
	cEmpresa:= aTitulos[3]
	Detalhes:= aTitulos[4]
	cID		:= aTitulos[5]
	
	AAdd(aLogs,{cEmpresa+" "+Detalhes+" "+cID})
	
	FT_FSKIP()	
End

FT_FUSE()

Return(.T.)


//-------------------------------------------------------------------------------
// Retorna o CNPJ da Filial informada no parโmetro - Cristiam Rossi em 26/07/2017
//-------------------------------------------------------------------------------
Static Function getCNPJ( xFil )
Local  cRet    := space(14)
Local  nPos
Local  aAreaSM0
Static aFilMAT := {}

	if len(aFilMAT) == 0
		aAreaSM0 := SM0->( getArea() )
		SM0->( dbGotop() )
		while ! SM0->( EOF() )

			aadd( aFilMAT, { alltrim(SM0->M0_CODFIL), SM0->M0_CGC } )

			SM0->( dbSkip() )
		end

		SM0->( restArea( aAreaSM0 ) )
	endif

	if ( nPos := aScan(aFilMAT,{|it| it[1] == alltrim(xFil)}) ) > 0
		cRet := aFilMAT[nPos][2]
	endif

return cRet


//-----------------------------------------------------------------------------------
// Localiza a Baixa Tํtulo a pagar da Taxa Administiva - Cristiam Rossi em 16/08/2017
//-----------------------------------------------------------------------------------
Static Function BxTaxa( _nValTX, dDtBx, _xBanco, _xAgencia, _xConta )
Local   aArea       := getArea()
Local   cMsg        := ""
Local   _oldDt      := dDataBase
Local   aBaixa      := {}
Local   lMsErroAuto := .F.
Local   lMsHelpauto := .T.
Default dDtBx       := dDatabase

	dDataBase := dDtBx

	SE2->( dbSetOrder(1) )
	if SE2->( dbSeek( xFilial("SE2") + SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO) ) )

		aAdd(aBaixa,{ "E2_PREFIXO" 	, SE2->E2_PREFIXO	 , Nil } )
		aAdd(aBaixa,{ "E2_NUM"     	, SE2->E2_NUM		 , Nil } )
		aAdd(aBaixa,{ "E2_PARCELA" 	, SE2->E2_PARCELA	 , Nil } )
		aAdd(aBaixa,{ "E2_TIPO"    	, SE2->E2_TIPO		 , Nil } )
		aAdd(aBaixa,{ "E2_FORNECE"	, SE2->E2_FORNECE	 , Nil } )
		aAdd(aBaixa,{ "E2_LOJA"    	, SE2->E2_LOJA		 , Nil } )

		aAdd(aBaixa,{ "AUTBANCO"  	, _xBanco			 , Nil } )
		aAdd(aBaixa,{ "AUTAGENCIA"  , _xAgencia			 , Nil } )
		aAdd(aBaixa,{ "AUTCONTA"  	, _xConta			 , Nil } )
		aAdd(aBaixa,{ "AUTMOTBX"  	, "NOR"       		 , Nil } )
		aAdd(aBaixa,{ "AUTDTBAIXA"	, dDataBase  		 , Nil } )
		aAdd(aBaixa,{ "AUTHIST"   	, "Bx retorno Concil", Nil } )
		aAdd(aBaixa,{ "AUTVLRPG"  	, SE2->E2_SALDO		 , Nil } )

		MsExecAuto({|x,y,w,z| Fina080(x,y,w,z)},aBaixa, 3, .F., nil)

		if lMserroAuto
			MostraErro()
		    cMsg := "Taxa do titulo nใo pode ser baixada, verifique!"
		else
			cMsg := "Taxa do titulo baixada"
		endIf                           

	else
		cMsg := "Taxa do titulo NAO encontrado, verifique!"
	endif

	conout( cMsg )
	dDataBase := _oldDt

	restArea( aArea )
return cMsg
