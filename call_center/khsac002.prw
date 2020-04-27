#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#include "TOPCONN.CH"

#DEFINE ENTER CHR(13)+CHR(10)

//--------------------------------------------------------------
/*/{Protheus.doc} KHSAC002
Description //Fila de Pedidos não liberados
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 30/11/2018 /*/
//--------------------------------------------------------------
User Function KHSAC002()

    Local aSize     := MsAdvSize()
    Local aButtons  := {}
    
    Private cUsrReproc := SUPERGETMV("KH_REPROC", .T., )//000779

    Private aOrcPriori := {}
    Private aOrcFila := {}
    
    Private oTela
    Private oSpDiv

    Private oBrwSup
    Private oBrwInf

    Private aCoord := FWGetDialogSize(oMainWnd) //ret. array com a area da tela
  
    Private oTimer
	Private nMilissegundos := 10000//3600000 // Disparo será de 1 em 1 minuto
	Private bRefresh:= {|| fCarrItSup(), fCarrItInf(), oTela:Refresh() }

    DEFINE MSDIALOG oTela FROM 0,0 TO aSize[6],aSize[5] TITLE "FILA DE PEDIDOS" Of oMainWnd PIXEL

    oTimer := TTimer():New(nMilissegundos, {|| processa( bRefresh , "Aguarde...", "Atualizando Dados...", .f.) }, oTela )   

    oPanel := TPanel():New(000,000,,oTela, NIL, .T., .F., NIL, NIL,000,000, .T., .F. )
    oPanel:Align := CONTROL_ALIGN_ALLCLIENT

	oSpDiv := TSplitter():New( 30,01,oTela,aCoord[4],270, 1 ) // Orientacao Vertical
	oSpDiv:setCSS("QSplitter::handle:vertical{background-color: #0080FF; height: 4px;}")
	oSpDiv:align := CONTROL_ALIGN_ALLCLIENT

    oPnlSup := TPanel():New(000,000,,oSpDiv, NIL, .T., .F., NIL, NIL,aSize[6],aSize[5], .T., .F. )
    oPnlInf := TPanel():New(150,000,,oSpDiv, NIL, .T., .F., NIL, NIL,aSize[6],aSize[5], .T., .F. )

    //ORÇAMENTOS DE PRIORIDADE
    oBrwSup := TwBrowse():New(005, 005, aSize[6], aSize[5],, {;
                                                                'N°',;
                                                                'Filial',;
                                                                'Pedido',;
                                                                'Emissao',;
                                                                'Cod. Cliente',;
                                                                'Loja',;
                                                                'Nome Cliente',;
                                                                'Item Ped.',;
                                                                'Fora de Linha',;
                                                                'Produto',;
                                                                'Descrição',;
                                                                'Qtd. Venda',;
                                                                'Armazem',;
                                                                '';
                                                                },,oPnlSup,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
    
    oBrwSup:bLDblClick := {|| MaViewSB2(aOrcPriori[oBrwSup:nAt][10],,aOrcPriori[oBrwSup:nAt][13])  }
    
    fCarrItSup()
    
    //PEDIDOS PRIORIDADE
    oBrwInf := TwBrowse():New(005, 005, aSize[6], aSize[5],, {;
                                                                'N°',;
                                                                'Filial',;
                                                                'Pedido',;
                                                                'Emissao',;
                                                                'Cod. Cliente',;
                                                                'Loja',;
                                                                'Nome Cliente',;
                                                                'Item Ped.',;
                                                                'Fora de Linha',;
                                                                'Produto',;
                                                                'Descrição',;
                                                                'Qtd. Venda',;
                                                                'Armazem',;
                                                                '';
                                                                },,oPnlInf,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
    
    oBrwInf:bLDblClick := {|| MaViewSB2(aOrcFila[oBrwInf:nAt][10],,aOrcFila[oBrwInf:nAt][13])  }
        
    fCarrItInf()
    
    SetKey(VK_F5, {|| processa( {|| fCarrItSup(), fCarrItInf() }, "Aguarde...", "Atualizando Dados...", .f.) })
    /*    
    if __cUserid $ cUsrReproc
        AAdd(aButtons,{	'',{|| Reproc() }, "Reprocessar Fila"} )
    endif
    */
    AAdd(aButtons,{	'',{|| setTime(1) }, "Incluir Timer"} )
    AAdd(aButtons,{	'',{|| setTime(2) }, "Remover Timer"} )
    AAdd(aButtons,{	'',{|| fExcel(aOrcPriori,"Fila de Pedidos Prioridades") }, "Excel Prioridade"} )
    AAdd(aButtons,{	'',{|| fExcel(aOrcFila,"Fila de Pedido") }, "Excel Fila"} )

    ACTIVATE MSDIALOG oTela ON INIT EnchoiceBar( oTela, { || } , { || oTela:End() },, aButtons)
    
Return

//--------------------------------------------------------------
/*/{Protheus.doc} fCarrItSup
Description //Carrega itens do painel Superior - *Prioridades
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 30/11/2018 /*/
//--------------------------------------------------------------
Static Function fCarrItSup()
    
    Local cAlias := getNextAlias()
    Local cQuery := ""
    Local nCount := 0

    cQuery := "SELECT FILIAL,C6_NUM,C5_EMISSAO,C5_CLIENT,C5_LOJACLI,A1_NOME,C6_ITEM,C6_PRODUTO,B1_DESC,B1_01FORAL,C6_QTDVEN,C6_LOCAL,SC6.R_E_C_N_O_ AS RECSC6" + ENTER
	cQuery += " FROM "+ RetSqlName("SC6")+" SC6" + ENTER
	cQuery += " INNER JOIN SM0010 SM0 ON SC6.C6_MSFIL = SM0.FILFULL" + ENTER
    cQuery += " INNER JOIN "+ RetSqlName("SC5")+" SC5 ON SC5.C5_MSFIL = SC6.C6_MSFIL AND SC5.C5_NUM = SC6.C6_NUM " + ENTER
    cQuery += " LEFT JOIN "+ RetSqlName("SC9")+" SC9 ON SC6.C6_NUM = SC9.C9_PEDIDO AND SC6.C6_PRODUTO = SC9.C9_PRODUTO AND SC6.C6_ITEM = SC9.C9_ITEM AND SC9.D_E_L_E_T_ = ''" + ENTER
    cQuery += " INNER JOIN "+ RetSqlName("SB1")+" B1 ON B1_COD = C6_PRODUTO" + ENTER
    cQuery += " INNER JOIN "+ RetSqlName("SA10")+" SA1 ON SA1.A1_COD = C5_CLIENT AND SA1.A1_LOJA = SC5.C5_LOJACLI" + ENTER
	cQuery += "	WHERE SC6.D_E_L_E_T_ = ' '" + ENTER
	cQuery += "	AND C5_XPRIORI = '1'" + ENTER
	cQuery += "	AND C5_NOTA = ''" + ENTER
//	cQuery += "	AND C5_CLIENTE NOT IN ('000001')" + ENTER
	cQuery += "	AND SC5.D_E_L_E_T_ = ' '" + ENTER
	cQuery += "	AND (CASE WHEN C9_BLEST IS NULL THEN 'NAO-LIB' ELSE 'LIB' END) = 'NAO-LIB'" + ENTER
	cQuery += "	AND C6_BLQ <> 'R'" + ENTER
	cQuery += "	AND C6_NOTA = ''" + ENTER
	cQuery += "	AND C6_LOCAL = '01'" + ENTER
	cQuery += "	ORDER BY C5_EMISSAO, C6_NUM, C6_ITEM" + ENTER
		
	//MemoWrite( "C:\spool\khsac002pri.txt", cQuery )

	cAlias := getNextAlias()

	PLSQuery(cQuery, cAlias)
	
    aOrcPriori := {}

    while (cAlias)->(!eof())

        nCount++
        aAdd(aOrcPriori,{nCount,;
                         (cAlias)->FILIAL,;
                         (cAlias)->C6_NUM,;
                         (cAlias)->C5_EMISSAO,;
                         (cAlias)->C5_CLIENT,;
                         (cAlias)->C5_LOJACLI,;
                         (cAlias)->A1_NOME,;
                         (cAlias)->C6_ITEM,;
                         (cAlias)->B1_01FORAL,;
                         (cAlias)->C6_PRODUTO,;
                         (cAlias)->B1_DESC,;
                         (cAlias)->C6_QTDVEN,;
                         (cAlias)->C6_LOCAL,;
                         "";
                        })
		
	(cAlias)->(dbSkip())
	end
	
	(cAlias)->(dbCloseArea())

    if len(aOrcPriori) == 0
        AAdd(aOrcPriori, {1,"","",ctod("//"),"","","","","","","",0,"",""})
    endif

    oBrwSup:SetArray(aOrcPriori)

    oBrwSup:bLine := {|| {   cValToChar(aOrcPriori[oBrwSup:nAt,01]) ,; 
                                aOrcPriori[oBrwSup:nAt,02] ,;
                                aOrcPriori[oBrwSup:nAt,03] ,;
                                aOrcPriori[oBrwSup:nAt,04] ,;
                                aOrcPriori[oBrwSup:nAt,05] ,;
                                aOrcPriori[oBrwSup:nAt,06] ,;
                                aOrcPriori[oBrwSup:nAt,07] ,;
                                aOrcPriori[oBrwSup:nAt,08] ,;
                                aOrcPriori[oBrwSup:nAt,09] ,;
                                aOrcPriori[oBrwSup:nAt,10] ,;
                                aOrcPriori[oBrwSup:nAt,11] ,;
                                aOrcPriori[oBrwSup:nAt,12] ,;
                                aOrcPriori[oBrwSup:nAt,13] ,;
                                aOrcPriori[oBrwSup:nAt,14] ;
                        }}
    
    oBrwSup:Align := CONTROL_ALIGN_ALLCLIENT

    oBrwSup:Refresh()

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fCarrItInf
Description //Carrega itens do painel Inferior - Pedidos não liberados
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 30/11/2018 /*/
//--------------------------------------------------------------
Static Function fCarrItInf()

    Local cAlias := getNextAlias()
    Local cQuery := ""
    Local nCount := 0

    cQuery := "SELECT FILIAL,C6_NUM,C5_EMISSAO,C5_CLIENT,C5_LOJACLI,A1_NOME,C6_ITEM,C6_PRODUTO,B1_DESC,B1_01FORAL,C6_QTDVEN,C6_LOCAL,SC6.R_E_C_N_O_ AS RECSC6" + ENTER
	cQuery += " FROM "+ RetSqlName("SC6")+" SC6" + ENTER
	cQuery += " INNER JOIN SM0010 SM0 ON SC6.C6_MSFIL = SM0.FILFULL" + ENTER
    cQuery += " INNER JOIN "+ RetSqlName("SC5")+" SC5 ON SC5.C5_MSFIL = SC6.C6_MSFIL AND SC5.C5_NUM = SC6.C6_NUM " + ENTER
    cQuery += " LEFT JOIN "+ RetSqlName("SC9")+" SC9 ON SC6.C6_NUM = SC9.C9_PEDIDO AND SC6.C6_PRODUTO = SC9.C9_PRODUTO AND SC6.C6_ITEM = SC9.C9_ITEM AND SC9.D_E_L_E_T_ = ''" + ENTER
    cQuery += " INNER JOIN "+ RetSqlName("SB1")+" B1 ON B1_COD = C6_PRODUTO" + ENTER
    cQuery += " INNER JOIN "+ RetSqlName("SA10")+" SA1 ON SA1.A1_COD = C5_CLIENT AND SA1.A1_LOJA = SC5.C5_LOJACLI" + ENTER
	cQuery += "	WHERE SC6.D_E_L_E_T_ = ' '" + ENTER
	cQuery += "	AND C5_XPRIORI <> '1'" + ENTER
	cQuery += "	AND C5_NOTA = ''" + ENTER
//	cQuery += "	AND C5_CLIENTE NOT IN ('000001')" + ENTER
	cQuery += "	AND SC5.D_E_L_E_T_ = ' '" + ENTER
	cQuery += "	AND (CASE WHEN C9_BLEST IS NULL THEN 'NAO-LIB' ELSE 'LIB' END) = 'NAO-LIB'" + ENTER
	cQuery += "	AND C6_BLQ <> 'R'" + ENTER
	cQuery += "	AND C6_NOTA = ''" + ENTER
	cQuery += "	AND C6_LOCAL = '01'" + ENTER
	cQuery += "	ORDER BY C5_EMISSAO, C6_NUM, C6_ITEM" + ENTER
		
	//MemoWrite( "C:\spool\khsac002pri.txt", cQuery )

	cAlias := getNextAlias()

	PLSQuery(cQuery, cAlias)
	
    aOrcFila := {}

	while (cAlias)->(!eof())

        nCount++
        aAdd(aOrcFila,{nCount,;
                         (cAlias)->FILIAL,;
                         (cAlias)->C6_NUM,;
                         (cAlias)->C5_EMISSAO,;
                         (cAlias)->C5_CLIENT,;
                         (cAlias)->C5_LOJACLI,;
                         (cAlias)->A1_NOME,;
                         (cAlias)->C6_ITEM,;
                         (cAlias)->B1_01FORAL,;
                         (cAlias)->C6_PRODUTO,;
                         (cAlias)->B1_DESC,;
                         (cAlias)->C6_QTDVEN,;
                         (cAlias)->C6_LOCAL,;
                         "";
                        })
		
	(cAlias)->(dbSkip())
	end
	
	(cAlias)->(dbCloseArea())

    if len(aOrcFila) == 0
        AAdd(aOrcFila, {1,"","",ctod("//"),"","","","","","","",0,"",""})
    endif

    oBrwInf:SetArray(aOrcFila)

    oBrwInf:bLine := {|| {   cValToChar(aOrcFila[oBrwInf:nAt,01]) ,; 
                                aOrcFila[oBrwInf:nAt,02] ,;
                                aOrcFila[oBrwInf:nAt,03] ,;
                                aOrcFila[oBrwInf:nAt,04] ,;
                                aOrcFila[oBrwInf:nAt,05] ,;
                                aOrcFila[oBrwInf:nAt,06] ,;
                                aOrcFila[oBrwInf:nAt,07] ,;
                                aOrcFila[oBrwInf:nAt,08] ,;
                                aOrcFila[oBrwInf:nAt,09] ,;
                                aOrcFila[oBrwInf:nAt,10] ,;
                                aOrcFila[oBrwInf:nAt,11] ,;
                                aOrcFila[oBrwInf:nAt,12] ,;
                                aOrcFila[oBrwInf:nAt,13] ,;
                                aOrcFila[oBrwInf:nAt,14] ;
                        }}
    
    oBrwInf:Align := CONTROL_ALIGN_ALLCLIENT

    oBrwInf:Refresh()

Return

//--------------------------------------------------------------
/*/{Protheus.doc} setTime
Description //Ativa e desativa o timer de atualização da tela
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 30/11/2018 /*/
//--------------------------------------------------------------
Static Function setTime(nOpcao)

    if nOpcao == 1
        oTimer:Activate()
    else
        oTimer:DeActivate()
    endif

Return


Static Function Reproc()

    Local nx := 0
    
    setTime(2) // Desabilito o Timer para realizar o reprocessamento da fila

    for nx := 1 to len(oBrwSup:aarray)

        // PEDIDO, ITEM, PRODUTO, ARMAZEM, QTD_PEDIDO
        processa({||;
        U_fSBF(oBrwSup:aarray[nx][3],; //PEDIDO
             oBrwSup:aarray[nx][8],; //ITEM
             oBrwSup:aarray[nx][10],; //PRODUTO
             oBrwSup:aarray[nx][13],; //ARMAZEM
             oBrwSup:aarray[nx][12]) })//QTD PEDIDO VENDA

    next nx

    for nx := 1 to len(oBrwInf:aarray)
        
        // PEDIDO, ITEM, PRODUTO, ARMAZEM, QTD_PEDIDO
        processa({||;
        U_fSBF(oBrwInf:aarray[nx][3],; //PEDIDO
             oBrwInf:aarray[nx][8],; //ITEM
             oBrwInf:aarray[nx][10],; //PRODUTO
             oBrwInf:aarray[nx][13],; //ARMAZEM
             oBrwInf:aarray[nx][12])}) //QTD PEDIDO VENDA
    next nx

    processa( bRefresh , "Aguarde...", "Atualizando Dados...", .f.)

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fSBF
Description //Verifica se existe saldo disponivel e realiza a liberação do pedido de venda
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 30/11/2018 /*/
//--------------------------------------------------------------
User Function fSBF(cPedido,cItem,cProduto,cArmazem,nQtdPed)

    Local cQuery := ""
    Local cAliasSBF := getNextAlias()
    Local lRet := .F.
    Local cDocEntrada := "AUTO"
    
    dbSelectArea("SC6")
    SC6->(dbSetOrder(1))//C6_FILIAL, C6_NUM, C6_ITEM, C6_PRODUTO, R_E_C_N_O_, D_E_L_E_T_

    cQuery := "SELECT * FROM "+retSqlName("SBF")+ ENTER
    cQuery += "WHERE BF_PRODUTO = '"+ cProduto +"'"+ ENTER
    cQuery += "AND BF_LOCAL = '"+ cArmazem +"'"+ ENTER
    cQuery += "AND (BF_QUANT - BF_EMPENHO) >= "+cValToChar(nQtdPed)+ ENTER
    cQuery += "AND D_E_L_E_T_ = ' '"+ ENTER

    PLSQuery(cQuery, cAliasSBF)

    if (cAliasSBF)->(!eof())

        if SC6->(dbSeek(xFilial("SC6")+cPedido+cItem+cProduto))

            lRet := .F.

            recLock("SC6",.F.)
                SC6->C6_LOCALIZ := (cAliasSBF)->BF_LOCALIZ
            msUnlock()		
            
            //Liberação do pedido de venda				
            FwMsgRun( ,{|| lRet := u_LibEst(SC6->C6_NUM,SC6->C6_ITEM,SC6->C6_PRODUTO,SC6->C6_QTDVEN,((cAliasSBF)->BF_QUANT - (cAliasSBF)->BF_EMPENHO),.F.) }, , "Realizando liberação do pedido "+ SC6->C6_NUM +" Item "+ SC6->C6_ITEM+", Por Favor Aguarde..." )

            if lRet
          /*      
                MemoWrite( "\PED_LIB_AUTO\"+cDocEntrada+"_"+SC6->C6_NUM+"_"+SC6->C6_ITEM+".txt",;
                            "Pedido:"+SC6->C6_NUM+;
                            " Produto:"+SC6->C6_PRODUTO+;
                            " Item:"+SC6->C6_ITEM+;
                            " Quant:"+cvaltochar(SC6->C6_QTDVEN)+;
                            " Endereço:"+ (cAliasSBF)->BF_LOCALIZ)
                
                //Verifica se o pedido ja foi liberado e Envia email para o responsavel pelo agendamento
            */
                vldPedLib(SC6->C6_NUM)
            else
                recLock("SC6",.F.)
                    SC6->C6_LOCALIZ := ""
                msUnlock()
                /*
                MemoWrite( "\PED_NAO_LIB_AUTO\"+cDocEntrada+"_"+SC6->C6_NUM+"_"+SC6->C6_ITEM+".txt",;
                            "Pedido:"+SC6->C6_NUM+;
                            " Produto:"+SC6->C6_PRODUTO+;
                            " Item:"+SC6->C6_ITEM+;
                            " Quant:"+cvaltochar(SC6->C6_QTDVEN)+;
                            " Endereço:"+ (cAliasSBF)->BF_LOCALIZ)
            
                    */
            endif

        endif

    endif

    (cAliasSBF)->(dbCloseArea())

Return

//--------------------------------------------------------------
/*/{Protheus.doc} vldPedLib
Description //Valida se o pedido esta liberado e envia email
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 30/11/2018 /*/
//--------------------------------------------------------------
Static Function vldPedLib(cPedido)

    Local cAssunto := "Pedido "+ cPedido +" Liberado para agendamento"
    Local cMsg := ""
    Local cPara := "isaias.gomes@komforthouse.com.br"

    cMsg += "Atenção," + ENTER
    cMsg += "O pedido "+ cPedido +" foi totalmente liberado e esta apto para o agendamento."+ ENTER
    
    dbSelectArea("SC5")
    SC5->(dbSetOrder(1))//C5_FILIAL, C5_NUM, R_E_C_N_O_, D_E_L_E_T_

    if SC5->(dbSeek(xFilial("SC5")+cPedido))
        if SC5->C5_LIBEROK == "S"
           /*
            processa( {|| U_sendMail( cPara, cAssunto, cMsg ) }, "Aguarde...", "Enviando email de Liberação..", .F.)
            */
        else
            Return
        endif
    endif

Return 

//--------------------------------------------------------------
/*/{Protheus.doc} fExcel
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 03/12/2018 /*/
//--------------------------------------------------------------
Static Function fExcel(aItens, cTitle)

	Local oExcel := FWMsExcel():New()
    Local cArqTemp := GetTempPath() + "FILA_"+substr(time(), 7, 2)+".XLS"
	Local aFields := {"C5_XDESCFI","C6_NUM","C5_EMISSAO","C5_CLIENT","C5_LOJACLI","A1_NOME","C6_ITEM","B1_01FORAL","C6_PRODUTO","B1_DESC","C6_QTDVEN","C6_LOCAL"}
    Local aCab := {}
    Local nx := 0

    if len(aItens) <= 0 
        Return(msginfo("Não ha dados para impressão...","ATENÇÃO"))
    endif

	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	For nx := 1 to Len(aFields)
		If SX3->(DbSeek(aFields[nx]))
	    	Aadd(aCab, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
	                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
	    Endif
	Next nx

	cNamePlan := cNameTable := cTitle

	oExcel:AddworkSheet(cNamePlan)
	oExcel:AddTable (cNamePlan,cNameTable)
	
	//Colunas do Excel ----------------------------------------
	for nx := 1 to Len(aCab)
		if aCab[nx][8] == "C"// Tipo Caracter
			oExcel:AddColumn(cNamePlan,cNameTable,aCab[nx][1],1,1)
		elseif aCab[nx][8] == "N"// Tipo Numerico
			oExcel:AddColumn(cNamePlan,cNameTable,aCab[nx][1],3,2)
		else // Tipo Data
			oExcel:AddColumn(cNamePlan,cNameTable,aCab[nx][1],1,3)			
		endif
	next nx

    for nx := 1 to len(aItens) 
	   	oExcel:AddRow(cNamePlan,cNameTable,{;
	   										aItens[nx][2],;
											aItens[nx][3],;
                                            aItens[nx][4],;
											aItens[nx][5],;
                                            aItens[nx][6],;
                                            aItens[nx][7],;
                                            aItens[nx][8],;
                                            aItens[nx][9],;
                                            aItens[nx][10],;
											aItens[nx][11],;
                                            aItens[nx][12],;
                                            aItens[nx][13];
											},{1,2,3,4,5,6,7,8,9,10,11,12})
	next nx
    
	oExcel:Activate()
	oExcel:GetXMLFile(cArqTemp)
	ShellExecute("open", cArqTemp, "", "C:\", 1 )
	
Return