#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#INCLUDE "JPEG.CH"

#DEFINE ENTER (Chr(13)+Chr(10))


//--------------------------------------------------------------
// Everton Santos - 15/10/2019
// Tela de Liberação de Analise do Cancela Substitui.	
//--------------------------------------------------------------
USER FUNCTION KHCANSUB()

    Local cDescricao := "Painel Cancela\Substitui"
    Private nOrder := 0 
    Private oTela
    Private aInfo := {}
	Private oLayer := FWLayer():new()
	Private aSize := FWGetDialogSize(oMainWnd)
    Private aAlter := {}
	Private oItens
    Private oAcoes
    Private oPedidos
    Private oGridCS := nil
    Private aHeaderCS := {}
    Private aCansub := {}
    Private aItens := {}
   	Private oGridItens := nil
    Private aHeadItens := {}
    Private oSay 
    Private oGet
    Private oSay1
    Private oGet1
    Private oMarc
    Private oAprov
    Private oReprov
    Private oSair
  	Private oFont11
	Private nPFlag := nPFilial := nPPedido := nPEmissao := nPCliente := nPChamado:= 0
    Private aObjects := {}
    Private aPosObj  := {}
    
    AAdd( aObjects, { 100 , 100, .T. , .T. , .F. } )
    AAdd( aObjects, { 100 , 100, .T. , .T. , .F. } )
    AAdd( aObjects, { 100 , 100, .T. , .T. , .F. } )
    AAdd( aObjects, { 100 , 100, .T. , .T. , .F. } )

    aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5 , 5 , 5 , 5 }
    
    aPosObj := MsObjSize( aInfo, aObjects, .T. , .F. )
   
    oTela := tDialog():New(aSize[1],aSize[2],aSize[3],aSize[4],OemToAnsi(cDescricao),,,,,/*nClrText*/,/*nClrBack*/,,,.T.)
    
    DEFINE FONT oFont11 NAME "Arial" SIZE 0, -11 BOLD

    //Inicializa o FWLayer com a janela que ele pertencera e se sera exibido o botao de fechar
	oLayer:init(oTela,.F.)
	
	//Cria as Linhas do Layer
    oLayer:AddLine("L01",40,.F.)
	oLayer:AddLine("L02",40,.F.)
	oLayer:AddLine("L03",20,.F.)

    //Cria as colunas do Layer
	oLayer:addCollumn('Col01_01',100,.F.,"L01")//Pedidos
	oLayer:addCollumn('Col02_01',100,.F.,"L02")//Itens
    oLayer:addCollumn('Col03_01',100,.F.,"L03")//Ações
    
    //Cria as Janelas do Layer
    oLayer:addWindow('Col01_01','C1_Win01_01','Pedidos',100,.F.,.F.,/**/,"L01",/**/)
    oLayer:addWindow('Col02_01','C2_Win02_01','Itens',100,.F.,.F.,/*{|| }*/,"L02",/**/)
    oLayer:addWindow('Col03_01','C3_Win03_01','Totais',100,.F.,.F.,/**/,"L03",/**/)
 

    oPedidos := oLayer:getWinPanel('Col01_01','C1_Win01_01',"L01")
    oItens   := oLayer:getWinPanel('Col02_01','C2_Win02_01',"L02")
	oAcoes   := oLayer:getWinPanel('Col03_01','C3_Win03_01',"L03")
    
    CriaBotoes()
    fHeadCS()
    fHeadIt()
    
    bAction := {|| fCarItens(oGridCS:acols[oGridCS:nat][nPPedido]),;
    			   SetCab1(oGridCS:acols[oGridCS:nat][nPPedido]),;
    			   SetCab2(oGridCS:acols[oGridCS:nat][nPPedido])}
    
    oGridCS := MsNewGetDados():New(aSize[1],aSize[2],oPedidos:nClientWidth/2,oPedidos:nClientHeight/2,0,"","","",aAlter,0,9999,"","","",oPedidos,aHeaderCS,aCansub,{|| Eval(bAction)})			
	
	oGridCS:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	oGridCS:oBrowse:bLDblClick	:= {|| fMarc(oGridCS:NAT) }
	oGridCS:oBrowse:bHeaderClick := {|o, iCol| fMarcHeader(iCol), oGridCS:Refresh()}
	
	oGridItens := MsNewGetDados():New(aSize[1],aSize[2],oItens:nClientWidth/2,oItens:nClientHeight/2,,"","","",aAlter,0,9999,"","" ,"",oItens,aHeadItens,aItens)
	oGridItens:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
    
    fCarr()
    
    oTela:Activate(,,,.T.,/*valid*/,,{|| } )

Return()

//--------------------------------------------------------------
Static Function fHeadCS()

    aHeaderCS := {}
	
	aAdd(aHeaderCS,{"","FLAG","@BMP",1,0,"","€€€€€€€€€€€€€€","C","","R","","","","V","","",""})
	aAdd(aHeaderCS,{"Filial","FILIAL","@!",30,0,"","","C","","","","","",'V',,,})
    aAdd(aHeaderCS,{"Pedido","C5_NUM",PesqPict("SC5","C5_NUM"),TamSX3("C5_NUM")[1],TamSX3("C5_NUM")[2],,"",TamSX3("C5_NUM")[3]	,"","","","",,'V',,,})
    aAdd(aHeaderCS,{"Emissao","C5_EMISSAO",PesqPict("SC5","C5_EMISSAO"),TamSX3("C5_EMISSAO")[1],TamSX3("C5_EMISSAO")[2],,"",TamSX3("C5_EMISSAO")[3]	,"","","","",,'V',,,})
    aAdd(aHeaderCS,{"Cliente","A1_NOME",PesqPict("SA1","A1_NOME"),TamSX3("A1_NOME")[1],TamSX3("A1_NOME")[2],,"",TamSX3("A1_NOME")[3]	,"","","","",,'V',,,})
    aAdd(aHeaderCS,{"Chamado","UC_CODIGO",PesqPict("SUC","UC_CODIGO"),TamSX3("UC_CODIGO")[1],TamSX3("UC_CODIGO")[2],,"",TamSX3("UC_CODIGO")[3]	,"","","","",,'V',,,})
    aAdd(aHeaderCS,{"","","",1,0,,"","C"	,"","","","",,'V',,,})
    
    nPFlag    := GdFieldPos("FLAG",aHeaderCS)
    nPFilial  := GdFieldPos("FILIAL",aHeaderCS)
	nPPedido  := GdFieldPos("C5_NUM",aHeaderCS)
	nPEmissao := GdFieldPos("C5_EMISSAO",aHeaderCS)
	nPCliente := GdFieldPos("A1_NOME",aHeaderCS)
	nPChamado := GdFieldPos("UC_CODIGO",aHeaderCS)
    
Return()

//------------------------------------
Static Function fHeadIt()

	aHeadItens := {}
	
	aAdd(aHeadItens,{"Produto","C6_PRODUTO",PesqPict("SC6","C6_PRODUTO"),TamSX3("C6_PRODUTO")[1],TamSX3("C6_PRODUTO")[2],,"",TamSX3("C6_PRODUTO")[3]	,"","","","",,'V',,,})
	aAdd(aHeadItens,{"Descrição","B1_DESC",PesqPict("SB1","B1_DESC"),TamSX3("B1_DESC")[1],TamSX3("B1_DESC")[2],,"",TamSX3("B1_DESC")[3]	,"","","","",,'V',,,})
	aAdd(aHeadItens,{"Entrega","C6_ENTREG",PesqPict("SC6","C6_ENTREG"),TamSX3("C6_ENTREG")[1],TamSX3("C6_ENTREG")[2],,"",TamSX3("C6_ENTREG")[3]	,"","","","",,'V',,,})
	aAdd(aHeadItens,{"Quantidade","C6_QTDVEN",PesqPict("SC6","C6_QTDVEN"),TamSX3("C6_QTDVEN")[1],TamSX3("C6_QTDVEN")[2],,"",TamSX3("C6_QTDVEN")[3]	,"","","","",,'V',,,})
	aAdd(aHeadItens,{"Preço","C6_PRCVEN",PesqPict("SC6","C6_PRCVEN"),TamSX3("C6_PRCVEN")[1],TamSX3("C6_PRCVEN")[2],,"",TamSX3("C6_PRCVEN")[3]	,"","","","",,'V',,,})
	aAdd(aHeadItens,{"Desconto","C6_XPDSBKP",PesqPict("SC6","C6_XPDSBKP"),TamSX3("C6_XPDSBKP")[1],TamSX3("C6_XPDSBKP")[2],,"",TamSX3("C6_XPDSBKP")[3]	,"","","","",,'V',,,})
	aAdd(aHeadItens,{"Custo","CUSTO",PesqPict("SB1","B1_01CUSTO"),TamSX3("B1_01CUSTO")[1],TamSX3("B1_01CUSTO")[2],,"",TamSX3("B1_01CUSTO")[3]	,"","","","",,'V',,,})
	aAdd(aHeadItens,{"","","",1,0,,"","C"	,"","","","",,'V',,,})
	
Return
//--------------------------------------

//Carrega os dados referentes aos pedidos de venda para liberação da diretoria
Static Function fCarr()
    
Local cAlias := getNextAlias()
Local nRegistros := 0
Local nCount := 0        
aCansub := {}
    
cQuery := " SELECT FILIAL , C5_NUM, C5_EMISSAO, A1_NOME, UC_CODIGO" + CRLF
cQuery += " FROM SC5010 SC5 (NOLOCK)" + CRLF
cQuery += " INNER JOIN SC6010 SC6 (NOLOCK) ON SC6.D_E_L_E_T_ = '' AND C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM" + CRLF
cQuery += " INNER JOIN SA1010 SA1 (NOLOCK) ON SA1.D_E_L_E_T_ = '' AND C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA" + CRLF
cQuery += " INNER JOIN SB1010 SB1 (NOLOCK) ON SB1.D_E_L_E_T_ = '' AND B1_FILIAL = '' AND B1_COD = C6_PRODUTO" + CRLF
cQuery += " INNER JOIN SUC010 SUC (NOLOCK) ON SUC.D_E_L_E_T_ = '' AND UC_01PED = C5_MSFIL+C5_NUM  AND UC_STATUS = '11'" + CRLF
cQuery += " LEFT OUTER JOIN SM0010 SM0 (NOLOCK) ON C5_MSFIL = SM0.FILFULL" + CRLF
cQuery += " WHERE SC5.D_E_L_E_T_ = ''" + CRLF 
cQuery += " AND C6_BLQ = ''" + CRLF 
cQuery += " AND C6_QTDVEN-C6_QTDENT > 0" + CRLF 
cQuery += " AND C6_NOTA = ''" + CRLF
cQuery += " AND C5_TIPO = 'N'" + CRLF
cQuery += " AND C5_XBLQCAN = 'B'" + CRLF
cQuery += " AND C5_CLIENTE <> '000001'" + CRLF
cQuery += " AND C5_NUMTMK <> ''" + CRLF
cQuery += " GROUP BY FILIAL, C5_NUM , C5_EMISSAO , A1_NOME, UC_CODIGO" + CRLF
	
PLSQuery(cQuery, cAlias)
	
(cAlias)->(dbEval({|| nRegistros++}))
(cAlias)->(dbgotop())
    
    procregua(nRegistros)
    
    while (cAlias)->(!eof())
		
		nCount++
		incproc("Atualizando Dados... " + cValtoChar(nCount) + " de " + cValtoChar(nRegistros))
		
		aAdd(aCansub,{ "LBNO",;
					 (cAlias)->FILIAL,;
					 (cAlias)->C5_NUM,;
					 (cAlias)->C5_EMISSAO,;
					 (cAlias)->A1_NOME,;
					 (cAlias)->UC_CODIGO,;
					  "",;
					  .F. })
	(cAlias)->(dbskip())		
	end
	
	(cAlias)->(dbCloseArea())
    
    if len(aCansub) <= 0
    	aAdd(aCansub,{"LBNO","","",CTOD(""),"","","",.F.})
    endif
    
	oGridCS:SetArray(aCansub) 
	oGridCS:oBrowse:SetFocus()
	oGridCS:ForceRefresh()
	
	fCarItens(oGridCS:acols[oGridCS:nat][nPPedido])
	SetCab1(oGridCS:acols[oGridCS:nat][nPPedido])
	SetCab2(oGridCS:acols[oGridCS:nat][nPPedido])
	oLayer:Refresh()
	
Return

//-------------------------------------------------------------
Static Function fCarItens(_cNumPv)

Local cAlias := GetNextAlias()
Local cQuery := ""
Local nRegistros := 0
Local nCount := 0
Local nTotal := 0
Local nCusto := 0
Default _cNumPv := 'X'

 

aItens := {}

cQuery := " SELECT C6_PRODUTO, B1_DESC , C6_ENTREG , C6_QTDVEN , C6_PRCVEN , C6_XPDSBKP , ISNULL(C5_XLIBOBS,'') C5_XLIBOBS , (B1_01CUSTO+(B1_01CUSTO*B1_IPI/100)) CUSTO " + CRLF
cQuery += " FROM SC6010 SC6 (NOLOCK)" + CRLF 
cQuery += " INNER JOIN SC5010 SC5 (NOLOCK) ON SC5.D_E_L_E_T_ = '' AND C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM " + CRLF
cQuery += " INNER JOIN SB1010 SB1 (NOLOCK) ON SB1.D_E_L_E_T_ = '' AND B1_FILIAL = '' AND B1_COD = C6_PRODUTO " + CRLF
cQuery += " WHERE SC6.D_E_L_E_T_ = '' " + CRLF 
cQuery += " AND C6_NUM = '" + _cNumPv + "' " + CRLF
cQuery += " ORDER BY C6_PRODUTO " + CRLF

PlsQuery(cQuery, cAlias)

(cAlias)->(dbEval({|| nRegistros++}))
(cAlias)->(dbgotop())
    
procregua(nRegistros)

	while (cAlias)->(!eof())
		
		nCount++
		incproc("Atualizando Dados... " + cValtoChar(nCount) + " de " + cValtoChar(nRegistros))
		
		nTotal += ((cAlias)->C6_QTDVEN * (Calias)->C6_PRCVEN)
		
		nCusto += ((cAlias)->C6_QTDVEN * (cALias)->CUSTO)
		
		aAdd(aItens,{ (cAlias)->C6_PRODUTO,;
					  (cAlias)->B1_DESC,;
					  (cAlias)->C6_ENTREG,;
					  (cAlias)->C6_QTDVEN,;
					  (cAlias)->C6_PRCVEN,;
					  (cAlias)->C6_XPDSBKP,;
					  (cAlias)->CUSTO,;
					   "",;
					  .F. })
	(cAlias)->(dbskip())		
	end
	
	(cAlias)->(dbCloseArea())
    
    if len(aItens) <= 0
    	aAdd(aItens,{"","",CTOD(""),"","","","","",.F.})
    endif
                     // V   H
    oSay  := TSay():New(005,005,{||'Valor Total:'},oAcoes,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
    oGet  := TGet():New(005,035,{|u| If( PCount() == 0, nTotal, nTotal := u ) },oAcoes,060, 010, "@E 999,999.99",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"nTotal",,,,.F.)
    oSay1 := TSay():New(020,005,{||'Custo Total:'},oAcoes,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
    oGet1 := TGet():New(020,035,{|u| If( PCount() == 0, nCusto, nCusto := u ) },oAcoes,060, 010, "@E 999,999.99",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"nCusto",,,,.F.)
    
	oGridItens:SetArray(aItens)  
	oGridItens:ForceRefresh()	
	oLayer:Refresh()
	

Return
//-------------------------------------------------------------

//--------------------------------------------------------------    
Static Function CriaBotoes()

    oMarc   := tButton():New(005,(aSize[3]-260),"&Des(Marcar Todos)",oAcoes,{||fMarcAll()} ,60,20,,,,.T.,,,,{|| })
    oAprov  := tButton():New(005,(aSize[3]-180),"&Liberar Marcados" ,oAcoes,{|| fLibCs() } ,60,20,,,,.T.,,,,{|| })
    oReprov := tButton():New(005,(aSize[3]-100),"&Recusar Marcados" ,oAcoes,{|| fRecCs() } ,60,20,,,,.T.,,,,{|| })
    oSair   := tButton():New(005,(aSize[3]-020),"&Sair",oAcoes,{|| oTela:end() },45,20,,,,.T.,,,,{|| })
    
    oLayer:Refresh()

Return

//--------------------------------------------------------------
Static Function fMarcHeader(nColuna)

	Local nx := 0
	
	if nOrder++ == 0
		if nColuna == nPFlag
			for nx := 1 To Len(oGridCS:aCols)
				if oGridCS:aCols[nx,nPFlag] == "LBNO"
					oGridCS:aCols[nx,nPFlag] := "LBTIK"
				else
					oGridCS:aCols[nx,nPFlag] := "LBNO"
				endif
			next nx
		endif
	else
		nOrder := 0
	endif

	oGridCS:Refresh()

Return
//--------------------------------------------------------------

//--------------------------------------------------------------
Static Function fMarcAll()

	Local nx := 0
	
	nPFlag := GdFieldPos("FLAG",oGridCS:aheader)

	for nx := 1 To Len(oGridCS:aCols)
		if oGridCS:aCols[nx,nPFlag] == "LBNO"
			oGridCS:aCols[nx,nPFlag] := "LBTIK"
		else
			oGridCS:aCols[nx,nPFlag] := "LBNO"
		endif
	next nx

	oGridCS:Refresh()

Return
//--------------------------------------------------------------

//--------------------------------------------------------------
Static Function fMarc(nLin) 

	if (oGridCS:aCols[nLin,nPFlag] == "LBNO")
		oGridCS:aCols[nLin,nPFlag] := "LBTIK"
	else
		oGridCS:aCols[nLin,nPFlag] := "LBNO"
	endif
	
	oGridCS:Refresh()
	
Return
//--------------------------------------------------------------

//--------------------------------------------------------------
Static Function SetCab1(cParam1)
	
	if !(empty(cParam1))
		cCab :="Pedido: " + Alltrim(cParam1)
		oLayer:setWinTitle('Col01_01' ,'C1_Win01_01',cCab ,"L01" )
	endif

Return
//--------------------------------------------------------------

//--------------------------------------------------------------
Static Function SetCab2(cParam1)
	
	if !(empty(cParam1))
		cCab :="Itens do Pedido: " + Alltrim(cParam1)
		oLayer:setWinTitle('Col02_01' ,'C2_Win02_01',cCab ,"L02" )
	endif

Return
//--------------------------------------------------------------

//Função que libera o cancela Substitui. Altera o campo C5_XBLQCAN para L e altera o status do chamado para 12.
//--------------------------------------------------------------
Static Function fLibCs()

	Local lReproc := .F.
	
	dbSelectArea("SC5")
	SC5->(dbSetorder(1))// C5_FILIAL, C5_NUM, R_E_C_N_O_, D_E_L_E_T_
	
	dbSelectArea("SUC")
	SUC->(dbSetOrder(1))// UC_FILIAL, UC_CODIGO, R_E_C_N_O_, D_E_L_E_T_

	For nx := 1 to Len(oGridCS:aCols)

		if oGridCS:aCols[nx][nPFlag] == "LBTIK"
			
			if SC5->(Dbseek(xFilial("SC5")+oGridCS:aCols[nx][nPPedido]))
				RecLock("SC5",.F.)
                    SC5->C5_XBLQCAN := "L"                           
				SC5->(MsUnlock())
			endif
			
			if SUC->(Dbseek(xFilial("SUC")+oGridCS:aCols[nx][nPChamado]))
				RecLock("SUC",.F.)
					SUC->UC_STATUS := '12'  // Status de CS Liberado no Chamado
				SUC->(MsUnlock())	
			EndIf
			
			lReproc := .T.

		endif
		
	Next nx
	
	SC5->(dbCloseArea())
	SUC->(dbCloseArea())
	
	if lReproc
		processa( {|| fCarr() }, "Aguarde...", "Atualizando Dados...", .f.)
	else
		msgAlert("Não existem Itens selecionados para Liberação.")
	endif

Return
//--------------------------------------------------------------

//Função que recusa o cancela subtitui.
//--------------------------------------------------------------
Static Function fRecCs()

	Local lReproc := .F.
		
	dbSelectArea("SC5")
	SC5->(dbSetorder(1))// C5_FILIAL, C5_NUM, R_E_C_N_O_, D_E_L_E_T_

	For nx := 1 to Len(oGridCS:aCols)

		if oGridCS:aCols[nx][nPFlag] == "LBTIK"
			
			if SC5->(Dbseek(xFilial("SC5")+oGridCS:aCols[nx][nPPedido]))
				RecLock("SC5",.F.)
                    SC5->C5_XBLQCAN := "R"                          
				SC5->(MsUnlock())
			endif
			
			lReproc := .T.

		endif
		
	Next nx
	
	if lReproc
		processa( {|| fCarr() }, "Aguarde...", "Atualizando Dados...", .f.)
	else
		msgAlert("Não existem Itens selecionados para Recusa.")
	endif

Return
//--------------------------------------------------------------