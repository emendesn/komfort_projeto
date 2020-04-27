#include 'protheus.ch'
#include 'parmtype.ch'
#Include 'TopConn.Ch'
#Include 'TbiConn.ch'


/*/{Protheus.doc} KHINTPV
//TODO Integração de pedidos de venda com E-commerce da Rakuten.
@author Rafael S.Silva
@since 02/05/2019
@version 1.0
@return Nil
@param aPrepEnv, array, description
@type function
/*/
user function KHINTPV(aPrepEnv)

	Local oPedido    	 := WSPedidoKH():New()
	Local cQuery	 	 := ""
	Local nLoja		     := 0
	Local nQtdParcel     := 0
	Local  cCGC		     := ""
	Local  cPedEcom	     := ""
	Local  cEmissao	     := ""
	Local  cDataEntre    := ""
	Local  nNumeroNf	 := 0
	Local  cObserv	     := ""	
	Local  cPedWeb	     := ""	
	Local  cSedex		 := ""
	Local  cSerieNF	     := ""
	Local cNome  		 := ""
	Local cTipoCli		 := ""
	Local cCod_mun	     := ""
	local cCgc			 := ""
	Local cEstado		 := ""
	local cMunicipio	 := ""
	Local cEndereco		 := ""
	Local  nDesconto	 := 0 
	Local  nFormPag	     := 0
	Local  nValFrete	 := 0 
	Local  nPedStat	 	 := 0
	Local  nPesoTotal	 := 0
	Local  nPrazoEnt	 := 0
	Local  cValidar	 	 := ""
	Local  cCadastrar	 := ""
	Local  nDescItem 	 := 0
	Local  nValParc      := 0
	Local  aPedidos		 := {}
	Local  aItens	 	 := {}
	Local aCliente		 := {}
	Local az12			 := {}
	Local  cA1			 := ""
	Local  cA2			 := ""
	Local  lAcao		 := .T. //Indica se será alteração ou inclusão
	Local  _lInJob       := .F. 
	Local cAutoriz 		 := ""
	Local cCCID			 := ""
	Local cNumero		 := ""
	Local cValidade		 := ""
	Local cOperaRet		 := ""
	Local nOperaCodigo   := ""
	Local cOrigem		 := ""
	Local cAlz12 	     := GetNextAlias()
	
	//Chaves de acesso Produção
	cA1		:= ALLTRIM(GETNEWPAR("KH_A1KEYWS","D39243EF-5943-4378-A3EB-AA3D58865678"))
	cA2		:= ALLTRIM(GETNEWPAR("KH_A2KEYWS","39132A70-1622-43D5-AABD-B504DC924D26"))			
	DbSelectArea("Z12")

	DbSelectArea("SA1")
		
	//oWSPedidoKh:ListarNovos(<nLoja>,<nStatusEcom>,<cStatusErp>)
	If oPedido:ListarNovos(nLoja,7,"",cA1,cA2)//ANEXO 3
		if oPedido:oWsListarNovosResult:nCodigo == 1
		
			aPedidos := oPedido:oWsListarNovosResult:oWsLista:oWsClsPedido
			
			For nAux := 1 to Len(aPedidos)

				aCliente := {}
				
				SA1->(DbSetOrder(3)) //A1_FILIAL+A1_CGC

				cNome    := FwNoAccent(Upper(aPedidos[nAux]:cRazaoSocial))
				cTipoCli := "J"
				cCgc := aPedidos[nAux]:cCNPJ

				If AllTrim(FwNoAccent(Upper(aPedidos[nAux]:oWsPessoa:Value))) == "PESSOAFISICA"
					cTipoCli := "F"
					cCgc := aPedidos[nAux]:cCPF
					cNome :=  FwNoAccent(Upper(aPedidos[nAux]:cNomeDestinatario + " " + aPedidos[nAux]:cSobreNome))
				Endif

				nOpc := 4
				If !SA1->(DbSeek(xFilial("SA1") + PADR(cCgc,TAMSX3("A1_CGC")[1] ) ))
					nOpc := 3
					cCodCli := GetSxeNum("SA1","A1_COD")
					aAdd(aCliente,{"A1_COD",  cCodCli,NIL})
					aAdd(aCliente,{"A1_LOJA", "01",NIL})
				Else
					cCodCli := SA1->A1_COD
				Endif

				aAdd(aCliente,{"A1_NOME", cNome ,NIL})
				
				cEndereco := AllTrim(FwNoAccent(Upper(aPedidos[nAux]:oWsTipoLogradouro:Value))) + " "
				cEndereco += AllTrim(FwNoAccent(Upper(aPedidos[nAux]:cLogradouro))) 

				aAdd(aCliente,{"A1_PESSOA", cTipoCli,NIL})
				aAdd(aCliente,{"A1_CGC", cCgc ,Nil})
				aAdd(aCliente,{"A1_END" , cEndereco,NIL})
				aAdd(aCliente,{"A1_COMPLEM" ,AllTrim(FwNoAccent(Upper(aPedidos[nAux]:cComplemento))) ,NIL})
				aAdd(aCliente,{"A1_NREDUZ", SubStr(cNome,1,At(" ",cNome)),NIL})
				aAdd(aCliente,{"A1_BAIRRO", FwNoAccent(Upper(aPedidos[nAux]:cBairro)),NIL})
				aAdd(aCliente,{"A1_TIPO", "F",NIL})

				cEstado := aPedidos[nAux]:cEstado
				cMunicipio := AllTrim(FwNoAccent(Upper(aPedidos[nAux]:cCidade)))
				cCod_mun   := POSICIONE("CC2",4,xFilial("CC2") + cEstado+ cMunicipio,"CC2_CODMUN")

				aAdd(aCliente,{"A1_EST", cEstado,NIL})
				aAdd(aCliente,{"A1_MUN", cMunicipio,NIL})
				//aAdd(aCliente,{"A1_COD_MUN", cCod_mun,NIL})
				
				aAdd(aCliente,{"A1_CEP", aPedidos[nAux]:cCep ,NIL})
				aAdd(aCliente,{"A1_DDD",aPedidos[nAux]:cDDD1 ,NIL})
				aAdd(aCliente,{"A1_TEL",StrTran(aPedidos[nAux]:cTelefone1 ,'-','') ,NIL})
				aAdd(aCliente,{"A1_TEL2",StrTran(aPedidos[nAux]:cTelefone1 ,'-',''),Nil})
				aAdd(aCliente,{"A1_PFISICA", aPedidos[nAux]:cRG ,NIL})
				aAdd(aCliente,{"A1_INSCR", "ISENTO" ,NIL})
				aAdd(aCliente,{"A1_BAIRROC",FwNoAccent(Upper(aPedidos[nAux]:cBairro)),Nil})
				aAdd(aCliente,{"A1_CEPC",aPedidos[nAux]:cCep,Nil})
				aAdd(aCliente,{"A1_MUNC",cMunicipio,Nil})
				aAdd(aCliente,{"A1_BAIRROE", FwNoAccent(Upper(aPedidos[nAux]:cBairro)),Nil})
				aAdd(aCliente,{"A1_CEPE",aPedidos[nAux]:cCep,Nil})
				aAdd(aCliente,{"A1_MUNE",cMunicipio,Nil})
				aAdd(aCliente,{"A1_EMAIL",aPedidos[nAux]:cEmail,Nil})

				CADCLI(aCliente,nOpc,cCod_mun,cCodCli)

				//cAutoriz  := aPedidos[nAux]:oWsCartao:CAUTORIZACC
				//cCCID     := aPedidos[nAux]:oWsCartao:CCARTID
				//cNumero   := aPedidos[nAux]:oWsCartao:CNUMERO
				//cValidade := aPedidos[nAux]:oWsCartao:CVALIDMES + "/" + aPedidos[nAux]:oWsCartao:CVALIDANO
				//cOperaRet := aPedidos[nAux]:oWsCartao:CRETOPERCD
				//cCodSeg   := aPedidos[nAux]:oWsCartao:CSEGURANCA
				nOperaCodigo := aPedidos[nAux]:NOPERACOD
				cOrigem		:= aPedidos[nAux]:oWsOrigem:value
				//Begin transaction
				cCGC		:= Iif(!Empty(aPedidos[nAux]:CCNPJ),aPedidos[nAux]:CCNPJ,aPedidos[nAux]:CCPF)
				cPedEcom	:= cValToChar(aPedidos[nAux]:NPEDIDOCODIGO)
				cEmissao	:= U_CWsData(Left(aPedidos[nAux]:CDATA,At(" ", aPedidos[nAux]:CDATA)-1))
				cDataEntre  := U_CWsData(Left(AllTrim(aPedidos[nAux]:CDATAENTREGA),At(" ", aPedidos[nAux]:CDATAENTREGA)))
				nNumeroNf	:= aPedidos[nAux]:CNUMERONF
				cObserv		:= aPedidos[nAux]:COBSERVACAO
				cPedWeb	    := cValToChar(aPedidos[nAux]:CPEDCLICOD)
				cSedex		:= aPedidos[nAux]:CSEDEX
				cSerieNF	:= aPedidos[nAux]:CSERIENF
				nDesconto	:= aPedidos[nAux]:NDESCONTO
				nFormPag	:= Iif(ValType(aPedidos[nAux]:NTIPOPAG) == "U",0,aPedidos[nAux]:NTIPOPAG)
				nValFrete	:= aPedidos[nAux]:nValorFreteCobrado
				nPedStat	:= aPedidos[nAux]:NPEDIDOSTATUS
				nQtdParcel  := aPedidos[nAux]:NQTDPARCEL
				nValParc    := aPedidos[nAux]:NVALPARC
				nPesoTotal	:= aPedidos[nAux]:NPESOTOTAL
				nPrazoEnt	:= aPedidos[nAux]:NPRAZOENTREGA
				cValidar	:= "S" //VALIDAR PEDIDO
				cCadastrar	:= 'N' //CADASTRAR PEDIDO
				
				If Z12->( DbSeek(xFilial("Z12") + Padr(cPedWeb,TAMSX3("Z12_PEDWEB")[1]) ) )
					Loop
				Endif
				
				aItens:= aPedidos[nAux]:oWsItens:oWsItem
				
				//CARREGA ITENS DO PEDIDO
				For nX := 1 to Len(aItens)
				cQuery := CRLF +" SELECT Z12_PEDWEB FROM Z12010 "
				cQuery += CRLF +" WHERE D_E_L_E_T_ = '' AND Z12_PEDWEB = '"+cPedWeb+"' AND Z12_QUANT = '"+cvaltochar(aItens[nX]:NITEMQTDE)+"' " 
				cQuery += CRLF +" AND Z12_PRODUT = '"+aItens[nX]:CCODIGOINTERNO+"' AND Z12_ITEMPE = '"+cvaltochar(aItens[nX]:NITEMPESO)+"' " 
				cQuery += CRLF +" AND Z12_CODPAI = '"+aItens[nX]:CITEMPARTNUMBER+"' " 
				Plsquery(cQuery,cAlz12)
				az12 := {} 
				while (cAlz12)->(!eof())	
				Aadd(az12,{(cAlz12)->Z12_PEDWEB})
				(cAlz12)->(DbSkip())
				end
				(cAlz12)->(DbCloseArea())
				
				if len(az12) == 0
				
					RecLock("Z12",lAcao)
					
					//aPedidos[nAux]:CCEP
					//aPedidos[nAux]:CCIDADE
					Z12->Z12_FILIAL 	:= xFilial("Z12")
					Z12->Z12_CGC    	:= 	cCGC		
					Z12->Z12_PEDECO		:= 	cPedEcom	
					Z12->Z12_EMISS  	:= 	cEmissao	
					Z12->Z12_ENTREG 	:= 	cDataEntre  
					Z12->Z12_NOTA		:= 	nNumeroNf	
					Z12->Z12_OBSERV 	:= 	cObserv		
					Z12->Z12_PEDWEB		:= 	cPedWeb	
					Z12->Z12_SEDEX		:= 	cSedex		
					Z12->Z12_SERIE		:= 	cSerieNF	
					Z12->Z12_DESPED		:= 	nDesconto	
					Z12->Z12_PAGECO		:= 	cValtoChar(nFormPag)
					Z12->Z12_FRETE		:= 	nValFrete	
					Z12->Z12_STPVE		:= 	Iif(ValType(Z12->Z12_STPVE) == "C",cValToChar(nPedStat),nPedStat)
					Z12->Z12_PBRUTO		:= 	nPesoTotal	
					Z12->Z12_PRZENT		:= 	nPrazoEnt	
					Z12->Z12_VALID		:= 	cValidar			
					Z12->Z12_QTDPAR     := 	nQtdParcel	
					Z12->Z12_VALPAR     :=  nValParc
					//CRIAR CAMPOS
					//Z12->Z12_IDCART	 := cCCID
					//Z12->Z12_NUMERC    := cNumero
					//Z12->Z12_AUTORI    := cAutoriz
					//Z12->Z12_RETOPE    := cOperaRet
					//Z12->Z12_VALIDC    := cValidade
					//Z12->Z12_CODSEG	   := cCodSeg
					Z12->Z12_CODOPE    := nOperaCodigo
					Z12->Z12_ORIGEM    := Alltrim(cOrigem)
					nDescItem       := aItens[nX]:nValItem - aItens[nX]:nValFinal
					Z12->Z12_ITSTAT := aItens[nX]:CITEMSTATUSINTERNO
					Z12->Z12_QUANT	:= aItens[nX]:NITEMQTDE
					Z12->Z12_VUNIT	:= aItens[nX]:nValItem
					Z12->Z12_TOTAL	:= (aItens[nX]:NITEMQTDE * aItens[nX]:nValItem)
					Z12->Z12_DESC	:= nDescItem
					Z12->Z12_PRODUT	:= aItens[nX]:CCODIGOINTERNO //PRODUTO
					Z12->Z12_ITEM	:= aItens[nX]:CITEMCODIGOINTERNO
					Z12->Z12_ITEMPE := aItens[nX]:NITEMPESO
					Z12->Z12_CODPAI := aItens[nX]:CITEMPARTNUMBER//CODIGO PRODUTO PAI

					If oPedido:Validar(nLoja,Val(cPedEcom),"",cA1,cA2)
						if oPedido:oWsValidarResult:nCodigo == 1		
							Z12->Z12_DTINT	:= dDataBase
							Z12->Z12_HRINT	:= Time()
							Z12->Z12_VALID	:= 'N'
							Z12->Z12_CADPED := "S"
						Else
							U_KHLOGWS("Z12",dDataBase,Time(),"[VALIDAR]- "+ oPedido:oWsValidarResult:cDescricao +" - KHINTPV","PROTHEUS")
							Conout("Erro na Integração" + CRLF + ;
							oPedido:oWsValidarResult:cDescricao)
							Z12->Z12_DTINT	:= dDataBase
							Z12->Z12_HRINT	:= Time()
							Z12->Z12_VALID	:= 'S'
							Z12->Z12_CADPED := "N"		
						Endif
						Z12->Z12_DTINT	:= dDataBase
						Z12->Z12_HRINT	:= Time()
						Z12->Z12_VALID	:= 'N'
						Z12->Z12_CADPED := "S"
					Else
						U_KHLOGWS("Z12",dDataBase,Time(),"[VALIDAR]- Erro ao consumir WebService, favor verificar dados informados - KHINTPV","SITE")
					Endif			

					Z12->(MsUnLock())

				EndIf					
				Next nX	
				
				//End transaction				
			Next nAux			

		Else
			U_KHLOGWS("Z12",dDataBase,Time(),oPedido:oWsListarNovosResult:cDescricao + " KHINTPV","SITE")

			Conout("Erro na Integração" + CRLF + ;
			oPedido:oWsListarNovosResult:cDescricao)				
		Endif
	Else
		U_KHLOGWS("Z12",dDataBase,Time(),"Erro ao consumir WebService, favor verificar dados informados - KHINTPV","SITE")
	Endif
									

return


Static function CADCLI(aCliente,nOpc,cCod_mun,cCodigo)

	SA1->(DbSetOrder(1))
	lMsErroAuto := .F.
	
	Begin Transaction 
		MsExecAuto({|x,y| MATA030(x,y)}, aCliente, nOpc) 
		If !lMsErroAuto
			IF SA1->(DbSeek(xFilial("SA1")+cCodigo+"01"))
				RECLOCK("SA1",.F.)
				SA1->A1_COD_MUN := cCod_mun
				SA1->(MsUnLock())
			ENDIF
			ConfirmSx8()
		Else 
			MostraErro("\SYSTEM\EXECAUTO\",'CLIENTES_'+STRTRAN(TIME(),":","-")+".log")  

			cErro := "MATA030_JOB_D"+StrTran(cValToChar(dDataBase),'/','')+'H_'+StrTran(Time(),':','-')+'.LOG'
			MostraErro("\SYSTEM\EXECAUTO",cErro)
			cErro := MemoRead("\SYSTEM\EXECAUTO"+cErro)
			
			U_KHLOGWS("SA1",dDataBase,Time(),cErro + " KHINTPV","PROTHEUS")
			DisarmTransaction() 
			RollBackSx8()
		EndIf 
	End Transaction

return

User Function JOBNEWPV(aEmp)

	Local aEmp := {"01","0142"}

	PREPARE ENVIRONMENT EMPRESA aEmp[1] FILIAL aEmp[2]    

	U_KHINTPV()

Return 