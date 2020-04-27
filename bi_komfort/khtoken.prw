#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#INCLUDE "JPEG.CH"

#DEFINE ENTER (Chr(13)+Chr(10))


//--------------------------------------------------------------
// Luis Artuso - 23/10/2019
// Tela de Liberação de Analise do Cancela Substitui.
//--------------------------------------------------------------
USER FUNCTION KHTOKEN()

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
	Private nPFlag := nPFilial := nPosCham := nPEmissao := nPCliente := nPChamado:= 0
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

    bAction := {|| fCarItens(Left(oGridCS:acols[oGridCS:nat][nPFilial] , 4) , oGridCS:acols[oGridCS:nat][nPosCham]),;
    			   SetCab1(oGridCS:acols[oGridCS:nat][nPosCham]),;
    			   SetCab2(oGridCS:acols[oGridCS:nat][nPosCham])}

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
    aAdd(aHeaderCS,{"Vendedor","VENDEDOR","@!",TamSX3("ZL3_VENDED")[1],TamSX3("ZL3_VENDED")[2],,"",TamSX3("ZL3_VENDED")[3]	,"","","","",,'V',,,})
    aAdd(aHeaderCS,{"Cliente","ZL3_CLIENT","@!",TamSX3("ZL3_CLIENT")[1],TamSX3("ZL3_CLIENT")[2],,"",TamSX3("ZL3_CLIENT")[3]	,"","","","",,'V',,,})
    aAdd(aHeaderCS,{"Orcamento","ZL3_CHAMAD","@!",TamSX3("ZL3_CHAMAD")[1],TamSX3("ZL3_CHAMAD")[2],,"",TamSX3("ZL3_CHAMAD")[3]	,"","","","",,'V',,,})
    aAdd(aHeaderCS,{"Solicitacao","ZL3_DTLIBS","@!",TamSX3("ZL3_DTLIBS")[1],TamSX3("ZL3_DTLIBS")[2],,"",TamSX3("ZL3_DTLIBS")[3]	,"","","","",,'V',,,})
    aAdd(aHeaderCS,{"Total","ZL3_VALTOT","@E 99,999,999,999.99",TamSX3("ZL3_VALTOT")[1],TamSX3("ZL3_VALTOT")[2],,"",TamSX3("ZL3_VALTOT")[3]	,"","","","",,'V',,,})
    aAdd(aHeaderCS,{"% Desc","ZL3_DESCON","@!",TamSX3("ZL3_DESCON")[1],TamSX3("ZL3_DESCON")[2],,"",TamSX3("ZL3_DESCON")[3]	,"","","","",,'V',,,})
	aAdd(aHeaderCS,{"","","",1,0,,"","C"	,"","","","",,'V',,,})

    nPFlag    := GdFieldPos("FLAG",aHeaderCS)
    nPFilial  := GdFieldPos("FILIAL",aHeaderCS)
	nPosCham   := GdFieldPos("ZL3_CHAMAD",aHeaderCS)
	nPEmissao := GdFieldPos("C5_EMISSAO",aHeaderCS)
	nPCliente := GdFieldPos("A1_NOME",aHeaderCS)
	nPChamado := GdFieldPos("UC_CODIGO",aHeaderCS)

Return()

//------------------------------------
Static Function fHeadIt()

	aHeadItens := {}

	aAdd(aHeadItens,{"Produto","ZL4_PROD",PesqPict("ZL4","ZL4_PROD"),TamSX3("ZL4_PROD")[1],TamSX3("ZL4_PROD")[2],,"",TamSX3("ZL4_PROD")[3]	,"","","","",,'V',,,})
	aAdd(aHeadItens,{"Descrição","ZL4_DESCP",PesqPict("ZL4","ZL4_DESCP"),TamSX3("ZL4_DESCP")[1],TamSX3("ZL4_DESCP")[2],,"",TamSX3("ZL4_DESCP")[3]	,"","","","",,'V',,,})
	aAdd(aHeadItens,{"Quantidade","ZL4_QUANT",PesqPict("ZL4","ZL4_QUANT") /*"@E 9,999.99"*/,TamSX3("ZL4_QUANT")[1],TamSX3("ZL4_QUANT")[2],,"",TamSX3("ZL4_QUANT")[3]	,"","","","",,'V',,,})
	aAdd(aHeadItens,{"Preço","ZL4_VALOR",PesqPict("ZL4","ZL4_VALOR")/*"@E 99,999,999,999.99"*/,TamSX3("ZL4_VALOR")[1],TamSX3("ZL4_VALOR")[2],,"",TamSX3("ZL4_VALOR")[3]	,"","","","",,'V',,,})
	aAdd(aHeadItens,{"Desconto","ZL4_DESCON",PesqPict("ZL4","ZL4_DESCON"),TamSX3("ZL4_DESCON")[1],TamSX3("ZL4_DESCON")[2],,"",TamSX3("ZL4_DESCON")[3]	,"","","","",,'V',,,})
	aAdd(aHeadItens,{"","","",1,0,,"","C"	,"","","","",,'V',,,})

Return
//--------------------------------------

//Carrega os dados referentes aos itens para liberação
Static Function fCarr()

	Local cAlias 		:= "TMP01"
	Local nRegistros	:= 0
	Local nCount 		:= 0
	Local cQuery		:= ""
	Local aCansub 		:= {}

	cQuery 	:=	" SELECT ZLD_XCODFI FILIAL , ZL3_VENDED VENDEDOR, ZL3_CLIENT CLIENTE, ZL3_CHAMAD ORCAMENTO, "
	cQuery	+=	" ZL3_VALTOT TOTAL, ZL3_DESCON DESCONTO, ZL3.R_E_C_N_O_ RECZL3, "
	cQuery	+=	" ZL3_LIBERA LIBERA, ZL3_DTLIBS SOLICITACAO, ZL3_FILCH CODFIL "

	cQuery 	+= 	" FROM ZL3010 ZL3 (NOLOCK) "

	cQuery	+= " INNER JOIN ZLD010 ZLD ON ZLD_XCODFI = ZL3_FILCH "
	cQuery	+= " WHERE ZL3.D_E_L_E_T_ = '' AND ZL3_DTLIBS = '20190922' "
	cQuery	+= " ORDER BY FILIAL , ORCAMENTO "

	cQuery	:= StrTran(cQuery , Space(2) , Space(1))
	
	If (Select(cAlias) > 0)
	
		(cAlias)->(dbCloseArea())
	
	EndIf

	PLSQuery(cQuery, cAlias)

	(cAlias)->(dbEval({|| nRegistros++}))
	(cAlias)->(dbgotop())

    procregua(nRegistros)

	If (cAlias)->(!EOF())

	   Do While (cAlias)->(!Eof())

			nCount++
			incproc("Atualizando Dados... " + cValtoChar(nCount) + " de " + cValtoChar(nRegistros))

			aAdd(aCansub,{ IIF((cAlias)->LIBERA == "1" , "LBTIK", "LBNO"),;
						 AllTrim((cAlias)->FILIAL) + "-" + FWFilialName(cEmpAnt , AllTrim((cAlias)->FILIAL)),;
						 (cAlias)->VENDEDOR,;
						 (cAlias)->CLIENTE,;
						 (cAlias)->ORCAMENTO,;
						 (cAlias)->SOLICITACAO,;
						 (cAlias)->TOTAL,;
						 (cAlias)->DESCONTO,;
						  "",;
						  .F. })

			(cAlias)->(dbSkip())

		EndDo

		(cAlias)->(dbCloseArea())

	Else

		aAdd(aCansub,{"LBNO","","",CTOD(""),"","","",.F.})

	EndIf

	oGridCS:SetArray(aCansub)
	oGridCS:oBrowse:SetFocus()
	oGridCS:ForceRefresh()

	fCarItens(Left(oGridCS:acols[oGridCS:nat][nPFilial] , 4) , oGridCS:acols[oGridCS:nat][nPosCham])
	SetCab1(oGridCS:acols[oGridCS:nat][nPosCham])
	SetCab2(oGridCS:acols[oGridCS:nat][nPosCham])
	oLayer:Refresh()

Return

//-------------------------------------------------------------
Static Function fCarItens(cFilOrc , cOrcamento)

	Local cAlias 		:= "TMP02"
	Local cQuery 		:= ""
	Local nRegistros 	:= 0
	Local nCount 		:= 0

	aItens := {}

	cQuery := " SELECT ZL4_PROD PRODUTO, ZL4_DESCP DESCP , ZL4_QUANT QUANTIDADE , ZL4_VALOR VALOR , ZL4_DESCON DESCONTO"
	cQuery += " FROM ZL4010 ZL4 (NOLOCK) "
	cQuery += " WHERE ZL4.D_E_L_E_T_ = '' AND ZL4_FILIAL = '" + cFilOrc + "' AND ZL4_CHAMAD = '" + cOrcamento + " ' "

	cQuery	:= StrTran(cQuery , Space(2) , Space(1))
	
	If (Select(cAlias) > 0)
	
		(cAlias)->(dbCloseArea())
	
	EndIf	

	PlsQuery(cQuery, cAlias)

	(cAlias)->(dbEval({|| nRegistros++}))
	(cAlias)->(dbgotop())

	procregua(nRegistros)

    if (cAlias)->(!eof())

		while (cAlias)->(!eof())

			nCount++
			incproc("Atualizando Dados... " + cValtoChar(nCount) + " de " + cValtoChar(nRegistros))

			aAdd(aItens,{ (cAlias)->PRODUTO,;
						  (cAlias)->DESCP,;
						  (cAlias)->QUANTIDADE,;
						  (cAlias)->VALOR,;
						  (cAlias)->DESCONTO,;
						   "",;
						  .F. })

			(cAlias)->(dbSkip())

		end

	Else

    	aAdd(aItens,{"","",CTOD(""),"","","","","",.F.})

    endif

	(cAlias)->(dbCloseArea())

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
		cCab :="Orçamento: " + Alltrim(cParam1)
		oLayer:setWinTitle('Col01_01' ,'C1_Win01_01',cCab ,"L01" )
	endif

Return
//--------------------------------------------------------------

//--------------------------------------------------------------
Static Function SetCab2(cParam1)

	if !(empty(cParam1))
		cCab :="Itens do Orçamento: " + Alltrim(cParam1)
		oLayer:setWinTitle('Col02_01' ,'C2_Win02_01',cCab ,"L02" )
	endif

Return
//--------------------------------------------------------------

//--------------------------------------------------------------
Static Function fLibCs()

	Local lReproc	:= .F.
	Local nX		:= 0

	For nx := 1 to Len(oGridCS:aCols)

		if oGridCS:aCols[nx][nPFlag] == "LBTIK"

			if ZL3->(dbSeek(xFilial("ZL3")+oGridCS:aCols[nx][nPosCham])) .AND. (RecLock("ZL3" , .F.))
				ZL3->ZL3_USRLIB		:= UsrRetName(RetCodUsr())
				ZL3->ZL3_DTLIB		:= dDataBase
				ZL3->ZL3_LIBERA 	:= '1'
				ZL3->(MsUnlock())
			endif

			lReproc := .T.

		endif

	Next nx
	
	if lReproc
		processa( {|| fCarr() }, "Aguarde...", "Atualizando Dados...", .f.)
	else
		msgAlert("Não existem Itens selecionados para Liberação.")
	endif

Return
//--------------------------------------------------------------

//--------------------------------------------------------------
Static Function fRecCs()

	Local lReproc := .F.

	dbSelectArea("SC5")
	SC5->(dbSetorder(1))// C5_FILIAL, C5_NUM, R_E_C_N_O_, D_E_L_E_T_

	For nx := 1 to Len(oGridCS:aCols)

		if oGridCS:aCols[nx][nPFlag] == "LBTIK"

			if SC5->(Dbseek(xFilial("SC5")+oGridCS:aCols[nx][nPosCham]))
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