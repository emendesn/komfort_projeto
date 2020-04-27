#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#INCLUDE "JPEG.CH"

#DEFINE ENTER (Chr(13)+Chr(10))

//--------------------------------------------------------------
// Everton Santos - 19/10/2019
// Tela Lista Vendas.	
//--------------------------------------------------------------
USER FUNCTION KHLISPED()

    Local cDescricao := "Lista de Vendas"
    Private oTela
    Private aInfo := {}
	Private oLayer := FWLayer():new()
	Private aSize := FWGetDialogSize(oMainWnd)
    Private aAlter := {}
	Private oItens
    Private aItens := {}
   	Private oGridItens := nil
    Private aHeadItens := {}
    Private oSay 
    Private oGerar
    Private dDateDe := date()
    Private dDateAte := date()
    Private oSair
  	Private oFont11
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
    oLayer:AddLine("L01",10,.F.)
	oLayer:AddLine("L02",90,.F.)
	
    //Cria as colunas do Layer
	oLayer:addCollumn('Col01_01',100,.F.,"L01") //Layer 1
	oLayer:addCollumn('Col02_01',100,.F.,"L02") //Layer 2
    
    //Cria as Janelas do Layer
    oLayer:addWindow('Col01_01','C1_Win01_01','',100,.F.,.F.,/*{|| }*/,"L01",/**/)
    oLayer:addWindow('Col02_01','C2_Win02_01','',100,.F.,.F.,/*{|| }*/,"L02",/**/)
    
    oParam  := oLayer:getWinPanel('Col01_01','C1_Win01_01',"L01")
    oItens  := oLayer:getWinPanel('Col02_01','C2_Win02_01',"L02")
    
    CriaParam()
    fHeadIt()
    
    oGridItens := MsNewGetDados():New(aSize[1],aSize[2],oItens:nClientWidth/2,oItens:nClientHeight/2,,"","","",aAlter,0,9999,"","" ,"",oItens,aHeadItens,aItens)
	oGridItens:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
    
    fCarr()
    
    oTela:Activate(,,,.T.,/*valid*/,,{|| } )

Return()

//Cabeçalho do Header
//------------------------------------
Static Function fHeadIt()

	aHeadItens := {}
	
	aAdd(aHeadItens,{"Filial","FILIAL","@!",30,0,"","","C","","","","","",'V',,,})
	aAdd(aHeadItens,{"Cliente","A1_NOME",PesqPict("SA1","A1_NOME"),TamSX3("A1_NOME")[1],TamSX3("A1_NOME")[2],,"",TamSX3("A1_NOME")[3]	,"","","","",,'V',,,})
	aAdd(aHeadItens,{"Vendedor","A3_NOME",PesqPict("SA3","A3_NOME"),TamSX3("A3_NOME")[1],TamSX3("A3_NOME")[2],,"",TamSX3("A3_NOME")[3]	,"","","","",,'V',,,})
	aAdd(aHeadItens,{"Orçamento","UA_NUM",PesqPict("SUA","UA_NUM"),TamSX3("UA_NUM")[1],TamSX3("UA_NUM")[2],,"",TamSX3("UA_NUM")[3]	,"","","","",,'V',,,})
	aAdd(aHeadItens,{"Pedido","C5_NUM",PesqPict("SC5","C5_NUM"),TamSX3("C5_NUM")[1],TamSX3("C5_NUM")[2],,"",TamSX3("C5_NUM")[3]	,"","","","",,'V',,,})
	aAdd(aHeadItens,{"Emissão","C5_EMISSAO",PesqPict("SC5","C5_EMISSAO"),TamSX3("C5_EMISSAO")[1],TamSX3("C5_EMISSAO")[2],,"",TamSX3("C5_EMISSAO")[3]	,"","","","",,'V',,,})
	aAdd(aHeadItens,{"Hora","UA_FIM",PesqPict("SUA","UA_FIM"),TamSX3("UA_FIM")[1],TamSX3("UA_FIM")[2],,"",TamSX3("UA_FIM")[3]	,"","","","",,'V',,,})
			
Return
//--------------------------------------

//Carrega os dados no grid.
Static Function fCarr(dDateDe, dDateAte)
    
Local cAlias := getNextAlias()
Local nRegistros := 0
Local nCount := 0
Default dDateDe := DATE()
Default dDateAte:= DATE()
        
aItens := {}
    
cQuery := " SELECT FILIAL,A1_NOME, ISNULL(A3_NOME,'SEM VENDEDOR') A3_NOME, UA_NUM , C5_NUM , C5_EMISSAO , UA_FIM " + CRLF 
cQuery += " FROM SUA010(NOLOCK) SUA " + CRLF
cQuery += " INNER JOIN SM0010 ON FILFULL = UA_FILIAL " + CRLF 
cQuery += " INNER JOIN SA1010(NOLOCK) SA1  ON UA_CLIENTE = A1_COD AND UA_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = '' " + CRLF
cQuery += " INNER JOIN SC5010(NOLOCK) SC5  ON UA_NUMSC5 = C5_NUM AND SC5.D_E_L_E_T_ = '' " + CRLF
cQuery += " LEFT  JOIN SA3010(NOLOCK) SA3  ON C5_VEND1 = A3_COD AND SA3.D_E_L_E_T_ = '' " + CRLF
cQuery += " WHERE SUA.D_E_L_E_T_ = '' " + CRLF 
cQuery += " AND UA_NUMSC5 <> '' " + CRLF
cQuery += " AND UA_STATUS <> 'CAN' " + CRLF 
cQuery += " AND UA_EMISSAO >= '20180903' " + CRLF
cQuery += " AND C5_EMISSAO BETWEEN '"+ DTOS(dDateDe) +"' AND '"+ DTOS(dDateAte) +"' " + CRLF
cQuery += " ORDER BY FILIAL " + CRLF
	
PLSQuery(cQuery, cAlias)
	
(cAlias)->(dbEval({|| nRegistros++}))
(cAlias)->(dbgotop())
    
    procregua(nRegistros)
    
    while (cAlias)->(!eof())
		
		nCount++
		incproc("Atualizando Dados... " + cValtoChar(nCount) + " de " + cValtoChar(nRegistros))
		
		aAdd(aItens,{ (cAlias)->FILIAL,;
					  (cAlias)->A1_NOME,;
					  (cAlias)->A3_NOME,;
					  (cAlias)->UA_NUM,;
					  (cAlias)->C5_NUM,;
					  (cAlias)->C5_EMISSAO,;
					  (cAlias)->UA_FIM,;
					   .F. })
	(cAlias)->(dbskip())		
	end
	
	(cAlias)->(dbCloseArea())
    
    if len(aItens) <= 0
    	aAdd(aItens,{"","","","","",CTOD(""),"",""})
    endif
    
	oGridItens:SetArray(aItens) 
	oGridItens:oBrowse:SetFocus()
	oGridItens:ForceRefresh()
	SetCab1(nRegistros)
	oLayer:Refresh()
	
Return

//--------------------------------------------------------------    
Static Function CriaParam()

    //'Data Abertura De
	@  02,  005 Say  oSay Prompt 'Emissão de:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oParam Pixel
	@  01,  045 MSGet oDataDe	Var dDateDe		    FONT oFont11 COLOR CLR_BLUE Pixel SIZE  50, 05 When .T.	Of oParam
	//'Data Abertura Ate
	@  02,  100 Say  oSay Prompt 'Emissão Ate:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oParam Pixel 
	@  01,  140 MSGet oDataAte	Var dDateAte		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  50, 05 When .T.	Of oParam
	// Botão Gerar
	oGerar   := tButton():New(002,200,"GERAR",oParam,{|| fCarr(dDateDe, dDateAte) } ,40,10,,,,.T.,,,,{|| })
	// Botao Sair
	oSair    := tButton():New(002,270,"&Sair",oParam,{|| oTela:end() },40,10,,,,.T.,,,,{|| })
	    
    oLayer:Refresh()

Return
//--------------------------------------------------------------

//--------------------------------------------------------------
Static Function SetCab1(cParam1)
	
	if !(empty(cParam1))
		cCab :="Total de Pedidos: " + Alltrim(cValToChar((cParam1)))
		oLayer:setWinTitle('Col02_01' ,'C2_Win02_01',cCab ,"L02" )
	endif

Return
//--------------------------------------------------------------
