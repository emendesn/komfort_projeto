#include 'protheus.ch'
#include 'parmtype.ch'
#Include 'TopConn.Ch'
#Include 'TbiConn.ch'


/*/{Protheus.doc} KHINTPROD
//TODO Cadastra produtos no E-Commerce.
@author Rafael S.Silva
@since 30/04/2019
@version 1.0
@return nil
@type User function
/*/
user function KHINTPROD()//aPrepEnv

	Local oProduto		:= Nil
	Local oProFil		:= Nil // clase de produto filho
	Local oCaract		:= Nil
	Local _lInJob		:= .F.
	Local nComEmb		:= 2 //Peso para composição do peso da embalagem
	Local cA1			:= ""
	Local cA2			:= ""
	Local cQuery    	:= ""
	//Variáveis para cadastrar o produto no site
	Local nLoja			:= 0 //VERIFICAR A NECESSIDADE DE CRIAR PARAMETRO MV_???????
	Local cIProduto		:= ""
	Local cIFornece		:= ""
	Local cNomeProd		:= ""
	Local cTituloPro	:= ""
	Local cSubTit		:= ""
	Local cDescProd		:= ""
	Local cCaracPrd		:= ""
	Local cTexto1		:= ""
	Local cTexto2		:= ""
	Local cTexto3		:= ""
	Local cTexto4		:= ""
	Local cTexto5		:= ""
	Local cTexto6		:= ""
	Local cTexto7		:= ""
	Local cTexto8		:= ""
	Local cTexto9		:= ""
	Local cTexto10		:= ""
	Local nNumber1		:= 0
	Local nNumber2		:= 0
	Local nNumber3		:= 0
	Local nNumber4		:= 0
	Local nNumber5		:= 0
	Local nNumber6		:= 0
	Local nNumber7		:= 0
	Local nNumber8		:= 0
	Local nNumber9		:= 0
	Local nNumber10		:= 0
	Local cCodEnquad	:= ""
	Local cModProd		:= ""
	Local nPesoProd		:= 0  
	Local nPesoEmba		:= 0 
	Local nAlturaPrd	:= 0
	Local nAltEmbPrd	:= 0 
	Local nLargProd		:= 0
	Local nLarEmbPrd	:= 0 
	Local nProfProd		:= 0
	Local nProfEmbPrd	:= 0 
	Local nEntProd		:= 0 
	Local nQtdMax		:= 0
	Local nStatusPrd	:= 0
	Local cTipoProd		:= ""
	Local nPresente		:= 0
	Local nPrecChPrd	:= 0
	Local nPrecoPor		:= 0
	Local nPersExt		:= 0
	Local cPersLabel	:= ""
	Local cISBN			:= ""
	Local cEAN13		:= ""
	Local cYouTube		:= ""
	Local cErro  		:= ""
	Local cPAi 			:= ""
	Local cCor  		:= ""
	Local nCont     := 0
	Local cAlmEst	:= ALLTRIM(GETNEWPAR("MV_XALMRAK","15"))
	Local nSaldo	:= 0
	Local cAlmRak	:= ALLTRIM(GETNEWPAR("MV_XAMDRAK","15"))
	Local oCor 		:= nil
	Local oTmanho   := nil
	Local oVoltagem := nil
	Local oEstampa  := nil
	Local oMidia 	:= nil
	
	//Chaves de acesso ao WebService
	cA1		:= ALLTRIM(GETNEWPAR("KH_A1KEYWS","078ecd14-64d8-40a8-9045-0705f267a262"))
	cA2		:= ALLTRIM(GETNEWPAR("KH_A2KEYWS","860ff9f1-657c-4f93-bdea-2437af2d813c"))
	
	oCor 		:= SKU_ARRAYOFSTRING():New()
	oTmanho   := SKU_ARRAYOFSTRING():New()
	oVoltagem := SKU_ARRAYOFSTRING():New()
	oEstampa  := SKU_ARRAYOFSTRING():New()
	oMidia 	:= SKU_ARRAYOFSTRING():New()
	
	oProduto := KHWSProduto():New()
	oProFil  := WSSKU():New()
	oCaract  := SKU_clsProdutoCaracteristica():NEW()
	cQuery := ""
	cQuery += CRLF + "SELECT Z06_PRODUT,Z06_STATUS, Z06.R_E_C_N_O_ Z06RECNO "
	cQuery += CRLF + "FROM "+RetSqlName("Z06")+" Z06 "
	cQuery += CRLF + "WHERE Z06_INTEG = 'S' AND Z06.D_E_L_E_T_ = ' ' "

	MemoWrite("Z06.SQL",cQuery)

	if Select("TMPZ06") > 0
		TMPZ06-(DbCloseArea())
	Endif

	TcQuery cQuery New Alias "TMPZ06"

	Z06->(DbSetOrder(1))
	TMPZ06->(DBGoTop())

	//Processa os pedidos e envia para o E-Commerce
	Do While .Not. (TMPZ06->(Eof()))

		cQuery := ""
		cQuery += CRLF + "SELECT "
		cQuery += CRLF + "* FROM "+RetSqlName("ZKC")+"  "
		//cQuery += CRLF + "WHERE ZKC_FILIAL = '"+xFilial("ZKC")+"' AND ZKC_SKU = '"+AllTrim(TMPZ06->Z06_PRODUT)+"' "
		cQuery += CRLF + "WHERE ZKC_FILIAL = '"+xFilial("ZKC")+"' AND ZKC_CODPAI = '"+AllTrim(TMPZ06->Z06_PRODUT)+"' "
		cQuery += CRLF + "AND D_E_L_E_T_ = ' ' "

		MemoWrite("ZKC_ECOMM.SQL",cQuery)

		TcQuery cQuery New Alias "TZKC"		

		IF .Not. (TZKC->(Eof()))

			nLoja						:= 0
			cIProduto					:= AllTrim(TMPZ06->Z06_PRODUT)
			cCor						:= Substr(cIProduto,10,5)
			cPAi						:= Substr(cIProduto,1,14)
			cIFornece					:= "000001" //VERIFICAR A NECESSIDADE DE CRIAR PARAMETRO MV_???????
			cNomeProd					:= AllTrim(TZKC->ZKC_DESCST)
			cTituloPro					:= ""
			cSubTit						:= ""
			
			//Função para buscar o titulo do campo na SX3
			//TITSXE(cCampo)

			//POSICAO 1 = TEXTO
			//POSICAO 2 = ESTRUTURA
			//POSICAO 3 = DETALHE
			//aDetailhe := RetDtlKit(TMPZ06->Z06_PRODUT)

			//cDescProd += aDetailhe[1] + CRLF//TZKC->ZKC_TEXTO  + CRLF
			cDescProd += MSMM(TZKC->ZKC_CODTXT,10,,,3,,,"ZKC","ZKC_CODTXT")
			cDescProd += U_TITSXE("ZKC_COR")    + ": " + AllTrim(TZKC->ZKC_COR) + CRLF
			cDescProd += U_TITSXE("ZKC_TECIDO") + ": " + allTrim(TZKC->ZKC_TECIDO) + CRLF
			cDescProd += U_TITSXE("ZKC_GARANT") + ": " + allTrim(TZKC->ZKC_GARANT) + CRLF
			cDescProd += U_TITSXE("ZKC_EMBALA") + ": " + allTrim(TZKC->ZKC_EMBALA) + CRLF
			cDescProd += U_TITSXE("ZKC_ESPUMA") + ": " + allTrim(TZKC->ZKC_ESPUMA) + CRLF
			cDescProd += U_TITSXE("ZKC_TPASSE") + ": " + allTrim(TZKC->ZKC_TPASSE) + CRLF
			cDescProd += U_TITSXE("ZKC_TPENCO") + ": " + allTrim(TZKC->ZKC_TPENCO) + CRLF
			cDescProd += U_TITSXE("ZKC_ALTURA") + ": " + cValToChar(TZKC->ZKC_ALTURA) + CRLF
			cDescProd += U_TITSXE("ZKC_PROFUN") + ": " + cValToChar(TZKC->ZKC_PROFUN) + CRLF
			cDescProd += U_TITSXE("ZKC_COMPRI") + ": " + cValToChar(TZKC->ZKC_COMPRI) + CRLF
			cDescProd += U_TITSXE("ZKC_PESO")   + ": " + cValToChar(TZKC->ZKC_PESO)   + CRLF
			cDescProd += U_TITSXE("ZKC_PSUPOR") + ": " + cValToChar(TZKC->ZKC_PSUPOR) + CRLF
			cDescProd += "Estrutura:  "+ MSMM(TZKC->ZKC_CODEST,10,,,3,,,"ZKC","ZKC_CODEST")+ CRLF
			cDescProd += "Detalhes: " + MSMM(TZKC->ZKC_CODDET,10,,,3,,,"ZKC","ZKC_CODDET")

			//Verificar a necessidade deste campos
			cCaracPrd					:= ""
			cTexto1						:= ""
			cTexto2						:= ""
			cTexto3						:= ""
			cTexto4						:= ""
			cTexto5						:= ""
			cTexto6						:= ""
			cTexto7						:= ""
			cTexto8						:= ""
			cTexto9						:= ""
			cTexto10					:= ""
			nNumber1					:= 0//iif(TZKC->ZKC_SKU == '000000000070',1,0)
			nNumber2					:= 0//iif(TZKC->ZKC_SKU == '000000000071',1,0)
			nNumber3					:= 0
			nNumber4					:= 0
			nNumber5					:= 0
			nNumber6					:= 0
			nNumber7					:= 0
			nNumber8					:= 0
			nNumber9					:= 0
			nNumber10					:= 0	
			//Verificar a necessidade deste campos

			cCodEnquad					:= ""
			cModProd					:= "" //Verificar com João	
			nPesoProd					:= TZKC->ZKC_PESO  
			nPesoEmba					:= TZKC->ZKC_PESO   + nComEmb
			nAlturaPrd					:= TZKC->ZKC_ALTURA
			nAltEmbPrd					:= TZKC->ZKC_ALTURA + nComEmb
			nLargProd					:= TZKC->ZKC_COMPRI
			nLarEmbPrd					:= TZKC->ZKC_COMPRI + nComEmb
			nProfProd					:= TZKC->ZKC_PROFUN
			nProfEmbPrd 				:= TZKC->ZKC_PROFUN + nComEmb
			nEntProd					:= 0 //VEIFICAR DIAS PARA ENTREGA
			nQtdMax						:= 999
			nStatusPrd					:= Val(TMPZ06->Z06_STATUS)
			cTipoProd					:= "1" // 1=Produto	
			nPresente				 	:= 2

			nPrecoPor 					:= GETPRCPOR(cIProduto) //busca preço na tabela de preços
			nPrecChPrd 					:= TZKC->ZKC_PRCDE

			nPersExt					:= 2
			cPersLabel					:= ""
			cISBN						:= ""
			cEAN13						:= ""
			cYouTube					:= ""

			If oProduto:Salvar(nLoja,cPAi,cIFornece,cNomeProd,cTituloPro,cSubTit,cDescProd,cCaracPrd,cTexto1,cTexto2,cTexto3,cTexto4,cTexto5,cTexto6,cTexto7,cTexto8,cTexto9,cTexto10,nNumber1,nNumber2,nNumber3,nNumber4,nNumber5,nNumber6,nNumber7,nNumber8,nNumber9,nNumber10,cCodEnquad,cModProd,nPesoProd,nPesoEmba,nAlturaPrd,nAltEmbPrd,nLargProd,nLarEmbPrd,nProfProd,nProfEmbPrd,nEntProd,nQtdMax,nStatusPrd,cTipoProd,nPresente,nPrecChPrd,nPrecoPor,nPersExt,cPersLabel,cISBN,cEAN13,cYouTube,cA1,cA2)

				If oProduto:oWsSalvarResult:nCodigo == 1
					Conout("-----------------------------------------------------")
					Conout("PRODUTO " + AllTrim(TMPZ06->Z06_PRODUT) + " CADASTRADO.")
					Conout("-----------------------------------------------------")
					//If Z06->(DbSeek(xFilial("Z06") + TMPZ06->Z06_PRODUT ))

					Z06->(DbGoTo(TMPZ06->Z06RECNO))

					If Z06->(Reclock("Z06",.F.))

						Z06->Z06_DTINTE := dDataBase
						Z06->Z06_HRINTE := Time()
						Z06->Z06_INTEG  := "N"

						Z06->(MsUnlock())

					Endif

				Else
					U_KHLOGWS("Z06",dDataBase,Time(),"Código: "+cIProduto+" - "+oProduto:oWSSalvarResult:cDescricao + " KHINTPROD","SITE")		
				Endif
			Else
				CONOUT()
				cErro := "Erro ao consumir o Serviço de produtos, favor verificar os dados de acesso! = KHINTPROD"
				U_KHLOGWS("Z06",dDataBase,Time(),"Código: "+cIProduto+" - "+cErro,"SITE")
			Endif	
			oCor:cstring      := {"Cor",cCor}
			//oTmanho:cstring   := {"Tamanho","GG"}
			//oVoltagem:cstring := {"Voltagem","110"}
			//oEstampa:cstring  := {"Estampa","Padrao"}
			//oMidia:cstring    := {"Midia","CD"}
				
			If oProFil:Salvar(nLoja,cPAi,cIProduto,nPrecoPor,oCor,,,,,1,cA1,cA2)
				If oProFil:oWSSalvarResult:nCodigo == 1
					Conout("-----------------------------------------------------")
				    Conout("PRODUTO " + AllTrim(TMPZ06->Z06_PRODUT) + " CADASTRADO.")
					Conout("-----------------------------------------------------")	
					Z06->(DbGoTo(TMPZ06->Z06RECNO))
					If Z06->(Reclock("Z06",.F.))
							Z06->Z06_DTINTE := dDataBase
							Z06->Z06_HRINTE := Time()
							Z06->Z06_INTEG  := "N"
							Z06->(MsUnlock())
					Endif
				Else
					CONOUT()
					cErro := "Erro ao consumir o Serviço de produtos, favor verificar os dados de acesso! = KHINTPROD"
				EndIf
			Else
				CONOUT()
				cErro := "Erro ao consumir o Serviço de produtos, favor verificar os dados de acesso! = KHINTPROD"
				U_KHLOGWS("Z06",dDataBase,Time(),"Código: "+cIProduto+" - "+cErro,"SITE")
			EndIf
			
		ENDIF

		TZKC->(DBCLOSEAREA())
		cDescProd := ""
		TMPZ06->(DbSkip())

	Enddo 

	TMPZ06->(DbCloseArea())

Return


Static Function GETPRCPOR(cCodkit)

	Local cQuery 	 := ""	
	Local nPreco     := 0
	Local nPrecoDef  := 0
	Local nPrecoSite := 0
	Local lFist      := .T.
	Local lOrcamento := .F.
	Local aProds     := {}

	//BUSCA PREÇOS NA TABELA DE PREÇOS ATRAVÉS DO SKU
	cQuery := ""
	cQuery += CRLF + "SELECT B1_COD,B1_PRV1,B1_XPRECV"
	cQuery += CRLF + "FROM "+RetSqlName("ZKC")+" (NOLOCK)  ZKC   " 
	cQuery += CRLF + "INNER JOIN "+RetSqlName("ZKD")+" (NOLOCK) ZKD ON ZKD_FILIAL = '"+xFilial("ZKD")+"'  "
	cQuery += CRLF + "	AND ZKD_CODPAI = ZKC_CODPAI AND ZKD.D_E_L_E_T_ = ' ' "
	cQuery += CRLF + "INNER JOIN "+RetSqlName("SB1")+" (NOLOCK) SB1 ON B1_FILIAL = '"+xFilial("SB1")+"'   "
	cQuery += CRLF + "	AND B1_COD = ZKD_CODFIL AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += CRLF + "WHERE ZKC_FILIAL = '"+xFilial("ZKC")+"'  "
	//cQuery += CRLF + "	AND ZKC_SKU= '"+cCodkit+"' "
	cQuery += CRLF + " AND ZKC_CODPAI= '"+cCodkit+"'"
	cQuery += CRLF + "	AND ZKC.D_E_L_E_T_ = ' ' "

	If Select("TPRD") > 0
		TPRD->(DbCloseArea())
	Endif

	MemoWrite("PRODUTOS_DO_KIT.SQL",cQuery)

	TcQuery cQuery New Alias "TPRD"

	TPRD->(DBGoTop())

	lOrcamento := .F.
	While !TPRD->(Eof()) 

		//Array para controlar se o preço do produto já foi somado
		if ( aScan(aProds,{|x| AllTrim(x) == AllTrim(TPRD->B1_COD) }) ) == 0
			If !lOrcamento
				If TPRD->B1_XPRECV == 0
					lOrcamento := .T.
				Endif
			Endif

			nPrecoSite += TPRD->B1_XPRECV
			nPrecoDef += TPRD->B1_PRV1

			aAdd(aProds,TPRD->B1_COD)

		Endif

		TPRD->(DbSkip())
	Enddo


	TPRD->(DbCloseArea())

	if lOrcamento
		nPreco := nPrecoDef 
	Else
		nPreco := nPrecoSite
	Endif

Return nPreco


User Function TITSXE(cCampo)

	Local cTitulo := ""

	dbSelectArea('SX3')
	SX3->( dbSetOrder(2) )
	SX3->( dbSeek( cCampo ) )

	cTitulo := AllTrim(X3Titulo())

Return cTitulo 


Static function RetDtlKit(cCodkit)

	Local cQry := ""
	Local aRet := {}
	Local cRetTxt := ""
	Local cRetEstru := ""
	Local cRetDetail := ""
	Local cFilter    := ""
	Local nNextTxt := 45
	Local nNextEst:= 45
	Local nNextDet := 45
	Local cChave1 := ""
	Local cChave2 := ""
	Local cChave3 := ""


	cQry += CRLF +"SELECT ZKC_CODTXT,ZKC_CODEST,ZKC_CODDET FROM " + ZKC->(RetSqlName("ZKC"))
	cQry += CRLF +"WHERE ZKC_FILIAL = '"+xFilial("ZKC")+"' "
	cQry += CRLF +"AND ZKC_SKU = '"+cCodkit+"' AND D_E_L_E_T_ = ' ' "

	TcQuery cQry New Alias "TKIT"

	TKIT->(DBGoTop())
	if !TKIT->(Eof())

		cFilter := TKIT->ZKC_CODTXT + ";" + TKIT->ZKC_CODEST + ";" + TKIT->ZKC_CODDET

		cQry := ""
		cQry += CRLF +"SELECT YP_CHAVE,YP_TEXTO "
		cQry += CRLF +"FROM " + SYP->(RetSqlName("SYP"))
		cQry += CRLF +"WHERE YP_FILIAL = '"+xFilial("SYP")+"' AND YP_CHAVE IN "+FORMATIN( cFilter ,";")+" AND D_E_L_E_T_ = ' '

		TcQuery cQry New Alias "TSYP"

		TSYP->(DbGoTop())

		//Defino a primeira chave da SYP como chave 1, depois alterno entre as chaves dentro do laço
		cChave1 := TKIT->ZKC_CODTXT
		cChave2 := TKIT->ZKC_CODEST
		cChave3 := TKIT->ZKC_CODDET
		While !TSYP->(Eof())
			if cChave1 == TSYP->YP_CHAVE
				cRetTxt += FwCutoff(StrTran(FwNoAccent(left(TSYP->YP_TEXTO,6)),"\r\n",""),.T.)
				If len(cRetTxt) >= nNextTxt
					nNextTxt := nNextTxt + nNextTxt
					cRetTxt += CRLF
				Endif
			Elseif cChave2 == TSYP->YP_CHAVE
				cRetEstru +=  FwCutoff(StrTran(FwNoAccent(left(TSYP->YP_TEXTO,6)),"\r\n",""),.T.)
				if len(cRetEstru) >= nNextEst
					nNextEst := nNextEst + nNextEst
					cRetEstru += CRLF
				Endif
			Elseif cChave3 == TSYP->YP_CHAVE
				cRetDetail +=  FwCutoff(StrTran(FwNoAccent(left(TSYP->YP_TEXTO,6)),"\r\n",""),.T.)
				if len(cRetDetail) >= nNextDet
					nNextDet := nNextDet + nNextDet
					cRetDetail += CRLF
				Endif
			Endif

			TSYP->(DbSkip())
		Enddo

	Endif

	aAdd(aRet,cRetTxt)
	aAdd(aRet,cRetEstru)
	aAdd(aRet,cRetDetail)

	TKIT->(DbCloseArea())
	TSYP->(DbCloseArea())

Return aRet


User Function KHJB010(aEmp)

	Local aEmp := {"01","0142"}


	PREPARE ENVIRONMENT EMPRESA aEmp[1] FILIAL aEmp[2]                      

	U_KHINTPROD()




Return
