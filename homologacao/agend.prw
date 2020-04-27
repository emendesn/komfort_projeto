#include 'rwmake.ch'
#include 'totvs.ch'
#include 'protheus.ch'
#include 'topconn.ch'
#include 'tryexception.ch'
#include 'parmtype.ch'
#Include "ap5mail.ch"

#DEFINE ENTER CHR(13)+CHR(10)

Static nAltBot		:= 009
Static nDistPad		:= 001

//--------------------------------------------------------------
/*/{Protheus.doc} agend()
Description // Tela de agendamento de pedido
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 20/08/2018 /*/
//--------------------------------------------------------------
User Function agend()
	
	Local cDescricao := "Agendamento de Pedidos"
	Local cPerg      := "AGEND001"
	Local cUserAge   := SuperGetMv("KH_USRAGE" ,,"")
	Private nOrder   := 0
	Private aPedidos := {} 
	Private aItens   := {}
	Private aCampos  := {}
	Private aCamposIt := {}
	Private oTela
	Private oLayer := FWLayer():new()
	Private aCoord := FWGetDialogSize(oMainWnd) //ret. array com a area da tela
    Private aAlter := {}
	Private oDados
	Private oGridPed := Nil
	Private oGridIt := Nil
	
	Private aHeaderPed := {}
	Private nPStatus := nPPedido := nPCliente := nPLojaCli := nPNome := nPEmissao := nPMsFil := 0
	Private nPDescFi := nPTroca := nPCep := nPVendedor := nPValor := nPEmail := nPQtdEmail := 0
	
	Private aHeaderIt := {}          
	Private nPStatusIt := nPItem := nPProduto := nPDescriIt := nPQtdVend := nPValorIt := nPLocal := nPEntrega := nPQAtu := 0
	Private nPItemLib := nPTipoProd := nPForaLin := nPTermoRet := nPNota := nPLocaliz := nPNumSc := nPUsrAgend := 0
	
	Private aPerg01 := {"1-TODOS","2-SIM","3-NâO"}
	Private aPerg02 := {"1-C/ Pendência","2-S/ Pendência","3-Ambos"}
    Private nPedFi := val(aPerg02[3])
	Private aPerg03 := {"1-Sim","2-Não","3-Ambos"}    
    Private nMostrua := val(aPerg03[3])
	Private aPerg04 := {"1-C/ BLQ/Desconto","2-S/ BLQ/Desconto","3-Ambos"}
    Private nBlqDesc := val(aPerg04[3])
    Private cArmaze := '15'
    Private cNomeCli := space(100)
	Private oSt1 := LoadBitmap(GetResources(),'BR_VERDE')
	Private oSt2 := LoadBitmap(GetResources(),'BR_VERMELHO')
	Private oSt3 := LoadBitmap(GetResources(),'BR_AZUL')	 
	Private oSt4 := LoadBitmap(GetResources(),'BR_VIOLETA')
	Private oSt5 := LoadBitmap(GetResources(),'BR_AMARELO')		
	Private oSt6 := LoadBitmap(GetResources(),'BR_PRETO')		
	Private nRadio := 1
	Private nRadAgreg := 1
	Private nPedFat := 1
	Private cPesqProd := space(50)    
	Private nOpcoes := 1
	Private oOpcoes
	Private cCep := space(9)
	Private lEst := .F.
	Private cUserEst := SUPERGETMV("KH_ESTPED", .T., "000779|000478|000695")
	Private oEstorna := nil
	Private aTerRet := {}
	Private _cAtend := ""
	Private aTermAgend := {}
	Private dDataAgTerm := dDataBase
	Private aCores := {}
	Private cUserName := LogUserName()
	Private cUsGer := SUPERGETMV("KH_ALLPED", .T., "000455|000478")
	Private oComboBo11 
	
	If !(__cUserid $ cUserAge)	
		Aviso("Acesso n�o permitido - KH_USRAGE"  , "Usuário sem permiss�o de acesso")		
		Return		
	EndIf
	
	if __cUserid $ cUserEst 
		lEst := .T.
	endif

	DEFINE FONT oFont11 NAME "Arial" SIZE 0, -11 BOLD
	
	//Verifica e cria perguntes
	xPutSx1(cPerg)
	If !Pergunte(cPerg,.T.)
		Return
	Endif	
	
	Private cMV_PAR01 := MV_PAR01
	Private cMV_PAR02 := MV_PAR02
	Private cMV_PAR03 := MV_PAR03
	Private cMV_PAR04 := MV_PAR04
	Private cMV_PAR05 := MV_PAR05
	Private cMV_PAR06 := MV_PAR06
	Private cMV_PAR07 := MV_PAR07
	Private cMV_PAR08 := MV_PAR08
	Private cMV_PAR09 := MV_PAR09
	Private cMV_PAR10 := MV_PAR10
	Private cMV_PAR11 := MV_PAR11
	Private cMV_PAR12 := MV_PAR12
	Private cMV_PAR13 := MV_PAR13
	Private cMV_PAR14 := MV_PAR14

	Private lPendF := .F.	
	oTela := tDialog():New(aCoord[1],aCoord[2],aCoord[3],aCoord[4],OemToAnsi(cDescricao),,,,,/*nClrText*/,/*nClrBack*/,,,.T.)
	
	//Inicializa o FWLayer com a janela que ele pertencera e se sera exibido o botao de fechar
	oLayer:init(oTela,.F.)
	
	oLayer:AddLine("L01",24,.T.)
	oLayer:AddLine("L02",39,.T.)
	oLayer:AddLine("L03",37,.T.)
		
	//Cria as colunas do Layer
	oLayer:addCollumn('Col01',90,.F.,"L01")
	oLayer:addCollumn('Col02',10,.F.,"L01")
	oLayer:addCollumn('Col03',100,.F.,"L02")  
	oLayer:addCollumn('Col04',100,.F.,"L03")  
	
	//Adiciona Janelas as colunas
	oLayer:addWindow('Col01','C1_Win01','Parametros',100,.F.,.F.,/**/,"L01",/**/)
	oLayer:addWindow('Col02','C2_Win02','Botoes',100,.F.,.F.,/**/,"L01",/**/)
	oLayer:addWindow('Col03','C3_Win03','Pedidos',100,.F.,.F.,/**/,"L02",/**/)
	oLayer:addWindow('Col04','C4_Win04','Itens',100,.F.,.F.,/**/,"L03",/**/)
		
	oCampos := oLayer:getWinPanel('Col01','C1_Win01',"L01")
	oBotoes := oLayer:getWinPanel('Col02','C2_Win02',"L01")                             
	oPedidos := oLayer:getWinPanel('Col03','C3_Win03',"L02")
	oItens := oLayer:getWinPanel('Col04','C4_Win04',"L03")
	
	CriaParam()
	CriaBotoes()
	
	//Monta aHeader do Pedido
	fHeadPed()
	//Monta aHeader dos Itens
	fHeadIt() 

	oGridPed := MsNewGetDados():New(aCoord[1],aCoord[2],oPedidos:nClientWidth/2,oPedidos:nClientHeight/2,,"","","",aAlter,0,9999,"","" ,"",oPedidos,aHeaderPed,aPedidos,{|| fCarrIt(oGridPed:acols[oGridPed:nat][nPPedido],oGridPed:acols[oGridPed:nat][nPCliente],oGridPed:acols[oGridPed:nat][nPLojaCli]), SetCab1(oGridPed:acols[oGridPed:nat][nPPedido])})
	oGridPed:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	
	oGridPed:oBrowse:bLDblClick := {|| fSetOPCab(oGridPed:OBROWSE:COLPOS,oGridPed:acols[oGridPed:nat]) }
	
	//lPendF := vldPendF(oGridPed:acols[oGridPed:nat][7],oGridPed:acols[oGridPed:nat][2]),iif(lPendF,,TELMANU(oGridPed:acols[oGridPed:nat]) }
	
	oGridIt := MsNewGetDados():New(aCoord[1],aCoord[2],oItens:nClientWidth/2,oItens:nClientHeight/2,,"","","",aAlter,0,9999,"","" ,"",oItens,aHeaderIt,aItens)
	oGridIt:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	
	oGridIt:oBrowse:bLDblClick := {|| fSetOPIt(oGridIt:OBROWSE:COLPOS, oGridPed:acols[oGridPed:nat], oGridIt:acols[oGridIt:nat]) }
    
	SetKey(VK_F2, {|| zLegenda()})
	SetKey(VK_F4, {|| fBloqAgend()})
	SetKey(VK_F5, {|| RelExcel(aHeaderPed, oGridPed:acols, "AGENDAMENTO DE PEDIDOS")})
	SetKey(VK_F6, {|| atuDtAgend(oGridPed:acols[oGridPed:nat])})
	SetKey(VK_F7, {|| U_KHF3B1()})
	SetKey(VK_F8, {|| fExcelIt()})
	If (__cUserId = '000478') // Somente o Isa�as ter� acesso a rotina de consulta do log de estorno
		SetKey(VK_F10, {|| ConsEst()})
	EndIf
	SetKey(VK_F11, {|| ViewObserv(oGridPed:acols[oGridPed:nat])})
	SetKey(VK_F12, {|| oTela:end() })
		
	oTela:Activate(,,,.T.,/*valid*/,,{|| processa( {|| fCarr() }, "Aguarde...", "Atualizando Dados...", .f.)} )
	
Return

//--------------------------------------------------------------
/*/{Protheus.doc} vldPendF
Description //Descri��o da Fun��o
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 20/08/2018 /*/
//--------------------------------------------------------------
Static Function vldPendF(_cMsfil,_cPedido)

	Local lRet := .F.
	Local aArea := GetArea()
		
	dbselectArea("SC5")
	SC5->(dbSetOrder(10))
	
	SC5->(dbSeek(xFilial("SC5")+_cPedido+_cMsfil))
	cPedPend := SC5->C5_PEDPEND
	
	if cPedPend == '2'
		msgAlert("N�o � possivel agendar pedidos com Pend�ncia Financeira !!","ATEN��O")
		lRet := .T.
	endif	
	
	restArea(aArea)
	
Return lRet

//--------------------------------------------------------------
/*/{Protheus.doc} vldPendFC
Description //Descri��o da Fun��o
@author  - Marcio Nunes     
@since 02/09/2019 /*/
//--------------------------------------------------------------
Static Function vldPendFC(cCliente, cLoja)

	Local lRet 		:=  .T.
	Local cUserCh	 := SUPERGETMV("KH_SAC001", .T., "000478|000013|000553|000732|000774|000144|001148|001236")	
	Local cQuery 	:= ""     
	
	Default cCliente 	:= ""
	Default cLoja	 	:= ""
		
	//Caso o Cliente esteja com pend�ncia financeira n�o ser� permitido a abertura de chamados diferente dos assuntos 000008 e 000012
	//Marcio Nunes - 27/08/2019 - Chamado 11114
	
	//Posiciona SE1 para verificar pend�ncia financeira onnde a parcela � menor que a data atual e ainda n�o foi paga
	cQuery := "SELECT E1_CLIENTE, E1_NUM, E1_PARCELA, E1_PREFIXO, E1_TIPO, E1_CLIENTE, E1_EMISSAO, E1_VENCREA, E1_VALOR, E1_SALDO " + ENTER
	cQuery += " FROM SE1010(NOLOCK)  " + ENTER
	cQuery += " WHERE E1_TIPO IN('BOL','CH')  " + ENTER
	cQuery += " AND E1_CLIENTE='"+ cCliente +"' " + ENTER
	cQuery += " AND E1_LOJA='"+ cLoja +"' " + ENTER	
	cQuery += " AND E1_VENCREA < GETDATE ( )-1  " + ENTER //Considerar 1 dia para constar como atraso
	cQuery += " AND E1_SALDO > 0 " + ENTER
	cQuery += " AND D_E_L_E_T_='' " + ENTER    
	
	cAlias := GetNextAlias()               

	PLSQuery(cQuery, cAlias)
	If (cAlias)->(!Eof()) .And. (!RetCodUsr()$cUserCh)//Usu�rios chave podem abrir chamados diferentes de 000008 e 000012                                        
		MsgAlert("O Cliente possui pendencia financeira n�o ser� permitido o agendamento. KH_SAC001. Entre em contato com o supervisor da �rea","ATEN��O")
		lRet := .F.
	EndIf   	    		    
	(cAlias)->(DbCloseArea())                       
	                                                                                                                                            
Return lRet            
//Cria bot�es 
Static Function CriaBotoes()
    
	Local aTamBot := Array(4)
	Local cMsg := "Deseja realmente estornar a libera��o do pedido: "
	Local cTitulo := "ATEN��O"    

	Local bCodBloq := {|| cMsfilEst := oGridPed:acols[oGridPed:nat][nPMsFil],; 
						  cPedidoEst := oGridPed:acols[oGridPed:nat][nPPedido],; 
						  ConfEst();
					   }
		
	aFill(aTamBot,0)
	//Adpta o tamanho dos botoes na tela
	DefTamBot(@aTamBot)
	aTamBot[3] := (oBotoes:nClientWidth)
	aTamBot[4] := (oBotoes:nClientHeight)
    
	DefTamBot(@aTamBot,000,000,-100,nAltBot,.T.,oBotoes)
	tButton():New(aTamBot[1],aTamBot[2],"&Pesquisar",oBotoes,{|| processa( {|| fCarr() }, "Aguarde...", "Atualizando Dados...", .f.)},aTamBot[3],aTamBot[4],,,,.T.,,,,/*{||}*/)
	DefTamBot(@aTamBot,aTamBot[1] + nAltBot + nDistPad)
    oEstorna := tButton():New(aTamBot[1],aTamBot[2],"&Estornar Pedido",oBotoes,{|| ; 
    																				iif(oGridIt:acols[oGridIt:nat][nPLocal] ='15',MsgAlert("A��o n�o permitida para o Armaz�m 15"),iif(msgyesno(cMsg+oGridPed:acols[oGridPed:nat][nPPedido],cTitulo),;
																					eval(bCodBloq),.F.)),;
    																				fRetStatus(oGridPed:nat,oGridPed:acols[oGridPed:nat][nPPedido]),;
    																				fCarrIt(oGridPed:acols[oGridPed:nat][nPPedido],oGridPed:acols[oGridPed:nat][nPCliente],oGridPed:acols[oGridPed:nat][nPLojaCli]);
	    																			},aTamBot[3],aTamBot[4],,,,.T.,,,,{||oEstorna:lActive := lEst})

   	DefTamBot(@aTamBot,aTamBot[1] + nAltBot + nDistPad)
    tButton():New(aTamBot[1],aTamBot[2],"&Itens Agendados",oBotoes,{|| ITAGEND()},aTamBot[3],aTamBot[4],,,,.T.,,,,/*{|| }*/)
    
   	DefTamBot(@aTamBot,aTamBot[1] + nAltBot + nDistPad)
    tButton():New(aTamBot[1],aTamBot[2],"&Conhecimento",oBotoes,{|| fConhece(oGridPed:acols[oGridPed:nat][nPCliente],oGridPed:acols[oGridPed:nat][nPLojaCli])},aTamBot[3],aTamBot[4],,,,.T.,,,,/*{|| }*/)

	DefTamBot(@aTamBot,aTamBot[1] + nAltBot + nDistPad)
    oSair := tButton():New(aTamBot[1],aTamBot[2],"&Fechar",oBotoes,{|| oTela:end() },aTamBot[3],aTamBot[4],,,,.T.,,,,/*{|| }*/)
	//oSair:setCSS("QPushButton{color: #FFFFFF; border: 1px solid #A52A2A; border-radius: 4px; background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #FF0000, stop: 1 #FFA07A);} QPushButton:pressed {background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #FFA07A, stop: 1 #FF0000);}")
	
	oLayer:Refresh()
	
Return

//Cria parametros da tela
Static Function CriaParam()
	
	Local cParam := space(100)
	Private nOpcao := 1
	
	//'Filial De
	@  02,  00 Say  oSay Prompt 'Filial de:'		FONT oFont11 COLOR CLR_BLUE Size  30, 08 Of oCampos Pixel
	@  01,  32 MSGet oMV_PAR01	Var cMV_PAR01		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  12, 05 When .T. F3 "SM0" Of oCampos
	
	//'Filial Ate
	@  12,  00 Say  oSay Prompt 'Filial Ate:'		FONT oFont11 COLOR CLR_BLUE Size  30, 08 Of oCampos Pixel
	@  11,  32 MSGet oMV_PAR02	Var cMV_PAR02		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  12, 05 When .T. F3 "SM0" Of oCampos
	
	//'Data Abertura De
	@  02,  70 Say  oSay Prompt 'Data Abertura de:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oCampos Pixel
	@  01,  130 MSGet oMV_PAR03	Var cMV_PAR03		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  50, 05 When .T.	Of oCampos
	
	//'Data Abertura Ate
	@  12,  70 Say  oSay Prompt 'Data Abertura Ate:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oCampos Pixel
	@  11,  130 MSGet oMV_PAR04	Var cMV_PAR04		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  50, 05 When .T.	Of oCampos 
	
	//'Cliente De
	@  02,  190 Say  oSay Prompt 'Cliente de:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oCampos Pixel
	@  01,  225 MSGet oMV_PAR05	Var cMV_PAR05		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  50, 05 When .T.	F3 "SA1" Of oCampos 
	@  01,  275 MSGet oMV_PAR06	Var cMV_PAR06		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  10, 05 When .T. Of oCampos
	
	//'Cliente Ate
	@  12,  190 Say  oSay Prompt 'Cliente Ate:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oCampos Pixel
	@  11,  225 MSGet oMV_PAR07	Var cMV_PAR07		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  50, 05 When .T.	F3 "SA1"	Of oCampos 
	@  11,  275 MSGet oMV_PAR08	Var cMV_PAR08		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  10, 05 When .T.	Of oCampos
	
	//Pedido de
	@  02,  300 Say  oSay Prompt 'Pedido de:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oCampos Pixel
	@  01,  335 MSGet oMV_PAR09	Var cMV_PAR09		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  35, 05 When .T.	F3 "SC5" Of oCampos
	
	//Pedido Ate
	@  12,  300 Say  oSay Prompt 'Pedido Ate:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oCampos Pixel
	@  11,  335 MSGet oMV_PAR10	Var cMV_PAR10		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  35, 05 When .T.	F3 "SC5" Of oCampos 
   
	//'Data Abertura De
	@  02,  380 Say  oSay Prompt 'Data Entrega de:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oCampos Pixel
	@  01,  440 MSGet oMV_PAR11	Var cMV_PAR11		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  50, 05 When .T.	Of oCampos
	
	//'Data Abertura Ate
	@  12,  380 Say  oSay Prompt 'Data Entrega Ate:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oCampos Pixel
	@  11,  440 MSGet oMV_PAR12	Var cMV_PAR12		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  50, 05 When .T.	Of oCampos 
	
	//'Produto Agendado
	@  24,  380 Say  oSay Prompt 'Agendado?'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oCampos Pixel
   	TComboBox():New( 23,440, {|u|if(PCount()>0,cMV_PAR13:= val(u),cMV_PAR13)} ,aPerg01, 50, 05, oCampos, ,/*bMudaFiltro*/,,,,.T.,,,.F.,{||.T.},.T.,,)
	
	//'Produtos com saldo
    @  02,  495 RADIO oRadioSaldo VAR nRadio ITEMS "Ambos","Com Saldo" SIZE 45, 25 OF oCampos COLOR 0, 16777215 PIXEL
   	
	//'Nome Cliente
	@  24,  00 Say  oSay Prompt 'Nome Cliente:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oCampos Pixel
	@  23,  45 MSGet oCliente	Var cNomeCli		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  100, 05 When .T. Of oCampos PICTURE "@!" VALID {|| processa( {|| fCarr() }, "Aguarde...", "Atualizando Dados...", .f.)} 
	
	//'Codigo ou descri��o => Produto
    @  23,  180 MSCOMBOBOX oOpcoes VAR nOpcoes ITEMS {"Codigo","Descri��o"} SIZE 044, 010 OF oCampos COLORS 0, 16777215 PIXEL
  	@  23,  225 MSGet oCliente	Var cPesqProd		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T. Of oCampos PICTURE "@!" VALID {|| processa( {|| fCarr() }, "Aguarde...", "Atualizando Dados...", .f.)} 
	
	//'Cep
	@  24,  300 Say  oSay Prompt 'CEP:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oCampos Pixel
	@  23,  335 MSGet oCep	Var cCep		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  35, 05 When .T.	Of oCampos PICTURE "@R 99999-999" VALID {|| processa( {|| fCarr() }, "Aguarde...", "Atualizando Dados...", .f.)} 
	
	//'Agregados
    @  02,  540 RADIO oRadioAgreg VAR nRadAgreg ITEMS "Com Agregados","Sem Agregados" SIZE 55, 25 OF oCampos COLOR 0, 16777215 ON CHANGE {|| processa( {|| fCarr() }, "Aguarde...", "Atualizando Dados...", .f.)} PIXEL

	//'Legenda
	@  24,  540 Say  oSay Prompt 'Legenda F2'		FONT oFont11 COLOR CLR_RED Size  50, 08 Of oCampos Pixel
	
	If (__cUserId == '000478')
		//'Legenda
		@  44,  540 Say  oSay Prompt 'F10 - Consulta hist�rico de estorno'		FONT oFont11 COLOR CLR_RED Size  100, 08 Of oCampos Pixel
	EndIf

	//'Msg => Observa��es do Pedido e Entrega
	@  34,  540 Say  oSay Prompt 'Observa��es F11'		FONT oFont11 COLOR CLR_RED Size  50, 08 Of oCampos Pixel
	
	//'Pendencia Financeira
	@  36,  00 Say  oSay Prompt 'Pendencia Financeira:'		FONT oFont11 COLOR CLR_BLUE Size  70, 08 Of oCampos Pixel
   	TComboBox():New( 35,60, {|u|if(PCount()>0,nPedFi:= val(u),nPedFi)} ,aPerg02, 70, 05, oCampos, ,/*bMudaFiltro*/,,,,.T.,,,.F.,{||.T.},.T.,,)
    
	//'Mostruario
	@  36,  130 Say  oSay Prompt 'Mostruario:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oCampos Pixel
   	TComboBox():New( 35,165, {|u|if(PCount()>0,nMostrua:= val(u),nMostrua)} ,aPerg03, 65, 05, oCampos, ,/*bMudaFiltro*/,,,,.T.,,,.F.,{||.T.},.T.,,)
   	
	//'Bloqueio de credito
	@  36,  230 Say  oSay Prompt 'Desconto:'		FONT oFont11 COLOR CLR_BLUE Size  60, 08 Of oCampos Pixel
   	TComboBox():New( 35,260, {|u|if(PCount()>0,nBlqDesc:= val(u),nBlqDesc)} ,aPerg04, 70, 05, oCampos, ,/*bMudaFiltro*/,,,,.T.,,,.F.,{||.T.},.T.,,)
   	
   	//'Bloqueio de credito
	@  36,  330 Say  oSay Prompt 'Armaz�m:'		FONT oFont11 COLOR CLR_BLUE Size  60, 08 Of oCampos Pixel
   	//TComboBox():New( 35,360, {|u|if(PCount()>0,nArmaze:= val(u),nArmaze)} ,aPerg05, 70, 05, oCampos, ,/*bMudaFiltro*/,,,,.T.,,,.F.,{||.T.},.T.,,)
   	@ 035, 360 MSCOMBOBOX oComboBo11 VAR cArmaze ITEMS {"01","03","04","12","15","Todos"} SIZE 070, 005 OF oCampos COLORS 0, 16777215 PIXEL
   	
	//'Pedido Faturado
	@  36,  440 Say  oSay Prompt 'Pedido Faturado:'		FONT oFont11 COLOR CLR_BLUE Size  60, 08 Of oCampos Pixel
	@  30,  495 RADIO oRadPedFat VAR cMV_PAR14 ITEMS "Sim","N�o" SIZE 45, 25 OF oCampos COLOR 0, 16777215  ON CHANGE {|| processa( {|| fCarr() }, "Aguarde...", "Atualizando Dados...", .f.)} PIXEL

Return

//Fun��o utilizada para definir o tamanho dos botoes
Static Function DefTamBot(aTamBot,nTOP,nLEFT,nWIDTH,nBOTTOM,lAcVlZr,oObjAlvo)

	Local lRefPerc := .F.
	Local nDimen := 0

	PARAMTYPE 0	VAR aTamBot		AS Array		OPTIONAL	DEFAULT Array(4)
	PARAMTYPE 1	VAR nTOP		AS Numeric		OPTIONAL	DEFAULT 0
	PARAMTYPE 2	VAR nLEFT		AS Numeric		OPTIONAL	DEFAULT 0
	PARAMTYPE 3	VAR nWIDTH		AS Numeric		OPTIONAL	DEFAULT 0
	PARAMTYPE 4	VAR nBOTTOM		AS Numeric		OPTIONAL	DEFAULT 0
	PARAMTYPE 5	VAR	lAcVlZr		AS Logical		OPTIONAL	DEFAULT .F.
	PARAMTYPE 6	VAR	oObjAlvo	AS Object		OPTIONAL	DEFAULT Nil

	If ValType(oObjAlvo) == "O"
		lRefPerc := !lRefPerc
	Endif
	
	If Len(aTamBot) # 4
		aTamBot := Array(4)
	Endif
	
	If lAcVlZr .OR. (!lAcVlZr .AND. !Empty(nTOP))
		If lRefPerc
			If nTOP < 0
				nDimen := IIf(Type("oObjAlvo:nClientHeight") == "U",oObjAlvo:nHeight,oObjAlvo:nClientHeight)
				aTamBot[1] := (Abs(nTOP) / 100) * (nDimen / 2)
			Else
				aTamBot[1] := Abs(nTOP)
			Endif
		Else
			aTamBot[1] := Abs(nTOP)
		Endif
	Endif
	
	If lAcVlZr .OR. (!lAcVlZr .AND. !Empty(nLEFT))
		If lRefPerc
			If nLEFT < 0
				nDimen := IIf(Type("oObjAlvo:nClientWidth") == "U",oObjAlvo:nWidth,oObjAlvo:nClientWidth)
				aTamBot[2] := (Abs(nLEFT) / 100) * (nDimen / 2)
			Else
				aTamBot[2] := Abs(nLEFT)
			Endif
		Else
			aTamBot[2] := Abs(nLEFT)
		Endif
	Endif
	
	If lAcVlZr .OR. (!lAcVlZr .AND. !Empty(nWIDTH))
		If lRefPerc
			If nWIDTH < 0
				nDimen := IIf(Type("oObjAlvo:nClientWidth") == "U",oObjAlvo:nWidth,oObjAlvo:nClientWidth)
				aTamBot[3] := (Abs(nWIDTH) / 100) * (nDimen / 2)
			Else
				aTamBot[3] := Abs(nWIDTH)
			Endif
		Else
			aTamBot[3] := Abs(nWIDTH)
		Endif
	Endif
	
	If lAcVlZr .OR. (!lAcVlZr .AND. !Empty(nBOTTOM))
		If lRefPerc
			If nBOTTOM < 0
				nDimen := IIf(Type("oObjAlvo:nClientHeight") == "U",oObjAlvo:nHeight,oObjAlvo:nClientHeight)
				aTamBot[4] := (Abs(nBOTTOM) / 100) * (nDimen / 2)
			Else
				aTamBot[4] := Abs(nBOTTOM)
			Endif
		Else
			aTamBot[4] := Abs(nBOTTOM)
		Endif
	Endif

Return

//Monta o Header do Pedido
Static Function fHeadPed() 
					
	aHeaderPed := {}
	
	aAdd(aHeaderPed,{" ","Status","@BMP",2,0,,"","C","","","","",,'V',,,})
	aAdd(aHeaderPed,{"Pedido","C5_NUM",PesqPict("SC5","C5_NUM"),TamSX3("C5_NUM")[1],TamSX3("C5_NUM")[2],,"",TamSX3("C5_NUM")[3]	,"","","","",,'V',,,})
	aAdd(aHeaderPed,{"Cod.Cliente","C5_CLIENTE",PesqPict("SC5","C5_CLIENTE"),TamSX3("C5_CLIENTE")[1],TamSX3("C5_CLIENTE")[2],,"",TamSX3("C5_CLIENTE")[3]	,"","","","",,'V',,,})
	aAdd(aHeaderPed,{"Loja","C5_LOJACLI",PesqPict("SC5","C5_LOJACLI"),TamSX3("C5_LOJACLI")[1],TamSX3("C5_LOJACLI")[2],,"",TamSX3("C5_LOJACLI")[3]	,"","","","",,'V',,,})	
	aAdd(aHeaderPed,{"Nome","A1_NOME",PesqPict("SA1","A1_NOME"),TamSX3("A1_NOME")[1],TamSX3("A1_NOME")[2],,"",TamSX3("A1_NOME")[3]	,"","","","",,'V',,,})
	aAdd(aHeaderPed,{"Emiss�o","C5_EMISSAO",PesqPict("SC5","C5_EMISSAO"),TamSX3("C5_EMISSAO")[1],TamSX3("C5_EMISSAO")[2],,"",TamSX3("C5_EMISSAO")[3]	,"","","","",,'V',,,})
	aAdd(aHeaderPed,{"Filial","C5_MSFIL",PesqPict("SC5","C5_MSFIL"),TamSX3("C5_MSFIL")[1],TamSX3("C5_MSFIL")[2],,"",TamSX3("C5_MSFIL")[3]	,"","","","",,'V',,,})
	aAdd(aHeaderPed,{"Desc. Filial","C5_XDESCFI",PesqPict("SC5","C5_XDESCFI"),TamSX3("C5_XDESCFI")[1],TamSX3("C5_XDESCFI")[2],,"",TamSX3("C5_XDESCFI")[3]	,"","","","",,'V',,,})
	aAdd(aHeaderPed,{"Troca","TROCA","",3,0,,"","C"	,"","","","",,'V',,,})
	aAdd(aHeaderPed,{"CEP","A1_CEP",PesqPict("SA1","A1_CEP"),TamSX3("A1_CEP")[1],TamSX3("A1_CEP")[2],,"",TamSX3("A1_CEP")[3]	,"","","","",,'V',,,})		
	aAdd(aHeaderPed,{"Vendedor","C5_VEND1",PesqPict("SC5","C5_VEND1"),TamSX3("C5_VEND1")[1],TamSX3("C5_VEND1")[2],,"",TamSX3("C5_VEND1")[3]	,"","","","",,'V',,,})
	aAdd(aHeaderPed,{"Total Pedido","C6_VALOR",PesqPict("SC6","C6_VALOR"),TamSX3("C6_VALOR")[1],TamSX3("C6_VALOR")[2],,"",TamSX3("C6_VALOR")[3]	,"","","","",,'V',,,})
	aAdd(aHeaderPed,{"Email","A1_EMAIL",PesqPict("SA1","A1_EMAIL"),TamSX3("A1_EMAIL")[1],TamSX3("A1_EMAIL")[2],,"",TamSX3("A1_EMAIL")[3]	,"","","","",,'V',,,})
	aAdd(aHeaderPed,{"Qtd Emails Enviados","C5_MAILENV",PesqPict("SC5","C5_MAILENV"),TamSX3("C5_MAILENV")[1],TamSX3("C5_MAILENV")[2],,"",TamSX3("C5_MAILENV")[3]	,"","","","",,'V',,,})
	aAdd(aHeaderPed,{"","C5_MAILENV",PesqPict("SC5","C5_MAILENV"),TamSX3("C5_MAILENV")[1],TamSX3("C5_MAILENV")[2],,"",TamSX3("C5_MAILENV")[3]	,"","","","",,'V',,,})

	nPStatus := GdFieldPos("Status",aHeaderPed)
	nPPedido := GdFieldPos("C5_NUM",aHeaderPed)
	nPCliente := GdFieldPos("C5_CLIENTE",aHeaderPed)
	nPLojaCli := GdFieldPos("C5_LOJACLI",aHeaderPed)
	nPNome := GdFieldPos("A1_NOME",aHeaderPed)
	nPEmissao := GdFieldPos("C5_EMISSAO",aHeaderPed)
	nPMsFil := GdFieldPos("C5_MSFIL",aHeaderPed)
	nPDescFi := GdFieldPos("C5_XDESCFI",aHeaderPed)
	nPTroca := GdFieldPos("TROCA",aHeaderPed)
	nPCep := GdFieldPos("A1_CEP",aHeaderPed)
	nPVendedor := GdFieldPos("C5_VEND1",aHeaderPed)
	nPValor := GdFieldPos("C6_VALOR",aHeaderPed)
	nPEmail := GdFieldPos("A1_EMAIL",aHeaderPed)
	nPQtdEmail := GdFieldPos("C5_MAILENV",aHeaderPed)

Return

//Monta o Header dos Itens 
Static Function fHeadIt() 
					
	aHeaderIt := {}
	
	aAdd(aHeaderIt,{" ","Status","@BMP",2,0,,"","C","","","","",,'V',,,})
	aAdd(aHeaderIt,{"Item","C6_ITEM",PesqPict("SC6","C6_ITEM"),TamSX3("C6_ITEM")[1],TamSX3("C6_ITEM")[2],,"",TamSX3("C6_ITEM")[3]	,"","","","",,'V',,,})
	aAdd(aHeaderIt,{"Produto","C6_PRODUTO",PesqPict("SC6","C6_PRODUTO"),TamSX3("C6_PRODUTO")[1],TamSX3("C6_PRODUTO")[2],,"",TamSX3("C6_PRODUTO")[3]	,"","","","",,'V',,,})
	aAdd(aHeaderIt,{"Descri��o","C6_DESCRI","@!",30,0,,"","C"	,"","","","",,'V',,,})	
	aAdd(aHeaderIt,{"Qtd","C6_QTDVEN",PesqPict("SC6","C6_QTDVEN"),TamSX3("C6_QTDVEN")[1],TamSX3("C6_QTDVEN")[2],,"",TamSX3("C6_QTDVEN")[3]	,"","","","",,'V',,,})
	aAdd(aHeaderIt,{"Valor Item","C6_VALOR",PesqPict("SC6","C6_VALOR"),TamSX3("C6_VALOR")[1],TamSX3("C6_VALOR")[2],,"",TamSX3("C6_VALOR")[3]	,"","","","",,'V',,,})
	aAdd(aHeaderIt,{"Armazem","C6_LOCAL",PesqPict("SC6","C6_LOCAL"),TamSX3("C6_LOCAL")[1],TamSX3("C6_LOCAL")[2],,"",TamSX3("C6_LOCAL")[3]	,"","","","",,'V',,,})
	aAdd(aHeaderIt,{"Data Entrega","C6_ENTREG",PesqPict("SC6","C6_ENTREG"),TamSX3("C6_ENTREG")[1],TamSX3("C6_ENTREG")[2],,"",TamSX3("C6_ENTREG")[3]	,"","","","",,'V',,,})
	aAdd(aHeaderIt,{"Qtd Estoque","B2_QATU",PesqPict("SB2","B2_QATU"),TamSX3("B2_QATU")[1],TamSX3("B2_QATU")[2],,"",TamSX3("B2_QATU")[3]	,"","","","",,'V',,,})
	aAdd(aHeaderIt,{"Item Liberado","ITEMLIB","@!",3,0,,,"","C","","","","",,'V',,,})
	aAdd(aHeaderIt,{"Tipo Produto","TPPROD","@!",14,0,,,"","C","","","","",,'V',,,}) 
	aAdd(aHeaderIt,{"Fora de Linha","FORALINHA","@!",3,0,,,"","C","","","","",,'V',,,})
	aAdd(aHeaderIt,{"Termo Retira","TERRET","@!",3,0,,,"","C","","","","",,'V',,,})
	aAdd(aHeaderIt,{"Nota Fiscal","C6_NOTA",PesqPict("SC6","C6_NOTA"),TamSX3("C6_NOTA")[1],TamSX3("C6_NOTA")[2],,"",TamSX3("C6_NOTA")[3]	,"","","","",,'V',,,})
	aAdd(aHeaderIt,{"Endere�o","C6_LOCALIZ",PesqPict("SC6","C6_LOCALIZ"),TamSX3("C6_LOCALIZ")[1],TamSX3("C6_LOCALIZ")[2],,"",TamSX3("C6_LOCALIZ")[3]	,"","","","",,'V',,,})
	aAdd(aHeaderIt,{"Num. Solicit. Compra","C6_XNUMSC",PesqPict("SC6","C6_XNUMSC"),TamSX3("C6_XNUMSC")[1],TamSX3("C6_XNUMSC")[2],,"",TamSX3("C6_XNUMSC")[3]	,"","","","",,'V',,,})
	aAdd(aHeaderIt,{"User X Agendamento","C6_XUSRAGE",PesqPict("SC6","C6_XUSRAGE"),TamSX3("C6_XUSRAGE")[1],TamSX3("C6_XUSRAGE")[2],,"",TamSX3("C6_XUSRAGE")[3]	,"","","","",,'V',,,})

	nPStatusIt := GdFieldPos("Status",aHeaderIt)
	nPItem := GdFieldPos("C6_ITEM",aHeaderIt)
	nPProduto := GdFieldPos("C6_PRODUTO",aHeaderIt)
	nPDescriIt := GdFieldPos("C6_DESCRI",aHeaderIt)
	nPQtdVend := GdFieldPos("C6_QTDVEN",aHeaderIt)
	nPValorIt := GdFieldPos("C6_VALOR",aHeaderIt)
	nPLocal := GdFieldPos("C6_LOCAL",aHeaderIt)
	nPEntrega := GdFieldPos("C6_ENTREG",aHeaderIt)
	nPQAtu := GdFieldPos("B2_QATU",aHeaderIt)
	nPItemLib := GdFieldPos("ITEMLIB",aHeaderIt)
	nPTipoProd := GdFieldPos("TPPROD",aHeaderIt)
	nPForaLin := GdFieldPos("FORALINHA",aHeaderIt)
	nPTermoRet := GdFieldPos("TERRET",aHeaderIt)
	nPNota := GdFieldPos("C6_NOTA",aHeaderIt)
	nPLocaliz := GdFieldPos("C6_LOCALIZ",aHeaderIt)
	nPNumSc := GdFieldPos("C6_XNUMSC",aHeaderIt)
	nPUsrAgend := GdFieldPos("C6_XUSRAGE",aHeaderIt)

Return


//Carrega os dados referentes aos pedidos de venda, de acordo com os parametros informados
Static Function fCarr()
    
	Local cAlias := getNextAlias()
    
    dbSelectArea("ZK0")
	ZK0->(dbSetorder(5))
    
    aItens := {}
    aPedidos := {}
    
    cQuery := " SELECT C5_NUM, C5_CLIENTE, C5_LOJACLI, A1_NOME, A1_EMAIL, C5_EMISSAO, C5_MSFIL, FILIAL, C5_01SAC, C5_STATENT, C5_LIBEROK, C5_NOTA, C5_BLQ, C5_NOTA, C5_PEDPEND, C5_VEND1, C5_XLIBER, C5_MAILENV, " +CRLF
    cQuery += " (SELECT SUM(C6_VALOR) + C5_FRETE + C5_DESPESA FROM SC6010(NOLOCK) C6 INNER JOIN SC5010(NOLOCK) C5 ON C5_NUM = C6_NUM WHERE C6_NUM = SC5.C5_NUM AND C5.D_E_L_E_T_ = '' AND C6.D_E_L_E_T_ = '' GROUP BY C5_FRETE,C5_DESPESA) AS TOTAL " +CRLF
    cQuery += " FROM " + RETSQLNAME("SC5") + "(NOLOCK) SC5 " +CRLF
	cQuery += " INNER JOIN " + RETSQLNAME("SA1") + "(NOLOCK) SA1 ON A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI " +CRLF
	cQuery += " INNER JOIN " + RETSQLNAME("SC6") + "(NOLOCK) SC6 ON C6_FILIAL = C5_FILIAL " +CRLF
	cQuery += " AND C6_NUM = C5_NUM "+CRLF 
	cQuery += " AND C6_CLI = C5_CLIENTE "+CRLF
	cQuery += " AND C6_LOJA = C5_LOJACLI "+CRLF    
	cQuery += " INNER JOIN SB2010(NOLOCK) SB2 ON C6_PRODUTO = B2_COD  AND C6_LOCAL = B2_LOCAL"+CRLF
	cQuery += " INNER JOIN SB1010(NOLOCK) SB1 ON SC6.C6_PRODUTO = SB1.B1_COD"+CRLF
	cQuery += " INNER JOIN SM0010(NOLOCK) SM0 ON SC5.C5_MSFIL = SM0.FILFULL"+CRLF
	cQuery += " WHERE C5_FILIAL <> ' ' " +CRLF
	cQuery += " AND B2_FILIAL = '0101' " +CRLF	
	cQuery += " AND SB2.D_E_L_E_T_ = ' ' " +CRLF
	cQuery += " AND SC5.D_E_L_E_T_ = ' ' " +CRLF
	cQuery += " AND SA1.D_E_L_E_T_ = ' ' " +CRLF
	cQuery += " AND SC6.D_E_L_E_T_ = ' ' " +CRLF
	cQuery += " AND A1_01PEDFI <> '1' " +CRLF

	
    if !(nPedFi) == 3
		if (nPedFi) == 1
			cQuery += " AND C5_PEDPEND = '2'" +CRLF
		else
			cQuery += " AND C5_PEDPEND <> '2'" +CRLF    
		endif
	endif
    
	if !(nMostrua) == 3
    	if (nMostrua) == 1
			cQuery += " AND C6_LOCAL = '03'" +CRLF        
        else
			cQuery += " AND C6_LOCAL <> '03'" +CRLF        
        endif
	endif
    
	if !(nBlqDesc) == 3
		if (nBlqDesc) == 1
			cQuery += " AND C5_XLIBER = 'B'" +CRLF        		
		else
			cQuery += " AND C5_XLIBER <> 'B'" +CRLF        		
		endif	
	endif
	
	if cMV_PAR14 == 1
		cQuery += " AND C6_NOTA <> ' '"  +CRLF  
	else
		cQuery += " AND C6_NOTA = ' '"  +CRLF  
	endif
	
	If cArmaze == 'Todos'
		cQuery += " AND C6_LOCAL <> ''"+CRLF
	Else
		cQuery += " AND C6_LOCAL = '"+cArmaze+"'"+CRLF
	EndIf 
	
	cQuery += " AND C6_BLQ <> 'R'"+CRLF
	
	if !__cUserid $ cUsGer 
	cQuery += " AND C5_CLIENTE <> '000001'"+CRLF
	endif
	
	cQuery += " AND C5_MSFIL BETWEEN '" + cMV_PAR01 + "' AND '" + cMV_PAR02 + "' " +CRLF
	cQuery += " AND C5_EMISSAO BETWEEN '" + DTOS(cMV_PAR03) + "' AND '" + DTOS(cMV_PAR04) + "' " +CRLF
	cQuery += " AND C5_CLIENTE BETWEEN '" + cMV_PAR05 + "' AND '" + cMV_PAR07 + "' " +CRLF
	cQuery += " AND C5_LOJACLI BETWEEN '" + cMV_PAR06 + "' AND '" + cMV_PAR08 + "' " +CRLF
	cQuery += " AND C5_NUM BETWEEN '" + cMV_PAR09 + "' AND '" + cMV_PAR10 + "' " +CRLF   
	
	If !Empty(cMV_PAR11) .OR. !Empty(cMV_PAR12)  
		cQuery += " AND C6_ENTREG BETWEEN '" + DTOS(cMV_PAR11) + "' AND '" + DTOS(cMV_PAR12) + "' "  +CRLF
	Endif
	
	If cMV_PAR13 <> 1
		Iif ( cMV_PAR13 == 2, cQuery += " AND C6_01AGEND = '1' "  + CRLF,  cQuery += " AND C6_01AGEND = '2' "  + CRLF)
	Endif 
	
	if !__cUserid $ cUsGer 
	cQuery += " AND C5_XCONPED = '1' " +CRLF // TRAZ SOMENTE OS PEDIDOS CONFERIDOS - LUIZ EDUARDO F.C. - 01.02.2018 
	endif
	
	cQuery += " AND B2_FILIAL = '0101'"+CRLF

	if !empty(alltrim(cNomeCli))
		cQuery += " AND A1_NOME LIKE ('"+ alltrim(cNomeCli) +"%')"+CRLF
	endif

    if oOpcoes:nat == 1
		if !empty(alltrim(cPesqProd))
			cQuery += " AND C6_PRODUTO LIKE ('%"+ alltrim(cPesqProd) +"%')"	+CRLF
		endif
	else
		if !empty(alltrim(cPesqProd))
			cQuery += " AND C6_DESCRI LIKE ('%"+ alltrim(cPesqProd) +"%')"	+CRLF
		endif
	endif

	if nRadio == 2
		cQuery += " AND (B2_QATU - (B2_RESERVA + B2_QEMP + B2_QACLASS ) > 0 OR C6_QTDEMP > 0) "+CRLF  
	endif

	
	if !empty(alltrim(strTran(cCep,'-','')))
		cQuery += " AND A1_CEP LIKE ('"+ alltrim(strTran(cCep,'-','')) +"%')"+CRLF
	endif	
	
	if nRadAgreg == 2
		cQuery += " AND B1_XACESSO <> '1'"+CRLF
	endif
	
	cQuery += " GROUP BY C5_NUM, C5_CLIENTE, C5_LOJACLI, A1_NOME, A1_EMAIL, C5_EMISSAO,  C5_MSFIL, FILIAL, C5_01SAC, C5_STATENT, C5_LIBEROK, C5_NOTA, C5_BLQ, C5_NOTA, C5_PEDPEND, C5_VEND1, C5_XLIBER, C5_MAILENV" +CRLF
	cQuery += " ORDER BY C5_EMISSAO "+CRLF
	
	//MemoWrite( "C:\spool\agend.txt", cQuery )
	
	PLSQuery(cQuery, cAlias)
	
	nRegistros := 0
	nCount := 0
	
	(cAlias)->(dbEval({|| nRegistros++}))
    (cAlias)->(dbgotop())
    
    procregua(nRegistros)
    
    while (cAlias)->(!eof())
		
		nCount++
		incproc("Atualizando Dados... " + cValtoChar(nCount) + " de " + cValtoChar(nRegistros))
		
		if Empty((cAlias)->C5_LIBEROK) .And. Empty((cAlias)->C5_NOTA) .And. Empty((cAlias)->C5_BLQ) .And. (cAlias)->C5_STATENT == ' ' .and. (cAlias)->C5_PEDPEND <> '2'
			oStatus := oSt1
		elseif !Empty((cAlias)->C5_NOTA) .or. (cAlias)->C5_LIBEROK=='E' .And. Empty((cAlias)->C5_BLQ) .And. (cAlias)->C5_STATENT == ' ' 
			oStatus := oSt2		
		elseif !Empty((cAlias)->C5_LIBEROK) .And. Empty((cAlias)->C5_NOTA) .And. Empty((cAlias)->C5_BLQ) .And. (cAlias)->C5_STATENT == ' '
			oStatus := oSt5
		endif
		 
		if (cAlias)->C5_PEDPEND == '2'
			oStatus := oSt4
		endif
		
		if (cAlias)->C5_XLIBER == 'B'
			oStatus := oSt6		
		endif
		
		//Virifica se o pedido contem termo de retira
		if ZK0->(dbSeek(xFilial("ZK0")+(cAlias)->C5_01SAC))
			while alltrim(ZK0->ZK0_NUMSAC) == alltrim((cAlias)->C5_01SAC)
				if ZK0->ZK0_STATUS == '1'
					cTermo := "SIM"
					exit
				else
					cTermo := "N�O"
				endif
				
				ZK0->(dbSkip())
			end
		else
			cTermo := "N�O"
		endif
		
		aAdd(aPedidos,{ oStatus,;				//1
						(cAlias)->(C5_NUM),;	//2
						(cAlias)->(C5_CLIENTE),;//3
						(cAlias)->(C5_LOJACLI),;//4
						(cAlias)->(A1_NOME),;	//5
						(cAlias)->(C5_EMISSAO),;//6
						(cAlias)->(C5_MSFIL),;	//7
						(cAlias)->(FILIAL),;	//8
						cTermo,;				//9
						Posicione("SA1",1,xFilial("SA1")+(cAlias)->(C5_CLIENTE)+(cAlias)->(C5_LOJACLI),"A1_CEP"),; 	//10
						Posicione("SA3",1,xFilial("SA3")+(cAlias)->(C5_VEND1),"A3_NOME"),; 							//11
						(cAlias)->TOTAL,; 																			//12
						space(5) + AllTrim((cAlias)->A1_EMAIL),; 													//13
						(cAlias)->(C5_MAILENV),; 																	//14
						"",; 																						//15
						.F.}) 																						//16
	
	if nCount == 9999
		exit
	endif
	
	(cAlias)->(dbskip())		
	end
	
	(cAlias)->(dbCloseArea())
    
    if len(aPedidos) <= 0
	aAdd(aPedidos,{"","","","","",ctod(""),"","","","","",0,"","","",.F.})
    endif
    
	oGridPed:SetArray(aPedidos) 
	
	fCarrIt(oGridPed:acols[oGridPed:nat][nPPedido],oGridPed:acols[oGridPed:nat][nPCliente],oGridPed:acols[oGridPed:nat][nPLojaCli])

	SetCab1(oGridPed:acols[oGridPed:nat][nPPedido])

	oGridIt:SetArray(aItens)    
	oGridIt:oBrowse:SetFocus()
	oGridIt:ForceRefresh()

	oGridPed:oBrowse:SetFocus()
	oGridPed:ForceRefresh()
	oLayer:Refresh()
	
Return

//Carrega os itens do pedido de venda posicionado
Static Function fCarrIt(cPedido,cCliente,cLoja)
    
	Local cAlias := getNextAlias()
    Local cTipoProd := ""
	Local cForaLinha := ""
    Local cQuery := ""
    
    aItens := {}
    
	cQuery := " SELECT C5_01SAC, C6_PRODUTO, C6_ITEM, C6_DESCRI, C6_QTDVEN, C6_LOCAL, C6_PRCVEN, C6_VALOR, C6_ENTREG, C6_SALDO, C6_NUM, C6_01AGEND, C6_FILIAL, C6_CLI, C6_LOJA, C6_NUM, C6_NUMTMK, C6_MSFIL, C6_XNUMSC, C6_NOTA, C6_QTDEMP, C6_LOCALIZ, C6_XUSRAGE, B1_01FORAL"
	cQuery += " FROM " + retSqlName("SC6")+ "(NOLOCK) SC6"
	cQuery += " INNER JOIN "+ RetSqlName("SB1")+"(NOLOCK) SB1 ON SC6.C6_PRODUTO = SB1.B1_COD"
	cQuery += "	INNER JOIN "+ RetSqlName("SC5")+"(NOLOCK) SC5 ON SC6.C6_MSFIL = SC5.C5_MSFIL AND SC6.C6_NUM = SC5.C5_NUM"
	cQuery += " WHERE C6_FILIAL <> ' ' "
	cQuery += " AND SB1.D_E_L_E_T_ = ' ' " 
	cQuery += " AND SC6.D_E_L_E_T_ = ' ' "
	cQuery += " AND SC5.D_E_L_E_T_ = ' ' "
	cQuery += " AND C6_BLQ <> 'R'"
	cQuery += " AND C6_NUM = '" + cPedido + "' "
	cQuery += " AND C6_CLI = '" + cCliente + "' "                                        
	cQuery += " AND C6_LOJA = '" + cLoja + "' "
	
	if nRadAgreg == 2
		cQuery += " AND B1_XACESSO <> '1'"
	endif
	
	if !(nMostrua) == 3
    	if (nMostrua) == 1
			cQuery += " AND C6_LOCAL = '03'" +CRLF        
        else
			cQuery += " AND C6_LOCAL <> '03'" +CRLF        
        endif
	endif
	
	cQuery += " ORDER BY C6_ITEM, C6_PRODUTO"
	
	plsQuery(cQuery,cAlias)
	
	(cAlias)->(DbGoTop())
	While (cAlias)->(!eof())
		
		cEstoque := ""
		cTipoProd := ""
		cForaLinha := ""
		nEstoque := 0
		
		DbSelectArea("SC9")
		SC9->(DbSetOrder(2))
		if SC9->(DbSeek((cAlias)->C6_FILIAL+(cAlias)->C6_CLI+(cAlias)->C6_LOJA+(cAlias)->C6_NUM+(cAlias)->C6_ITEM))
			cEstoque := iif(Empty(alltrim(SC9->C9_BLEST)),"SIM","NAO")	
		else
			cEstoque := "NAO"
		endif
		
		DbSelectArea("SB2")
		SB2->(DbSetOrder(1))
		if SB2->(DbSeek(xFilial("SB2") + (cAlias)->C6_PRODUTO + (cAlias)->C6_LOCAL ))
			nEstoque := SB2->B2_QATU - (SB2->B2_RESERVA + SB2->B2_QEMP + SB2->B2_QACLASS) + iif(cEstoque=="SIM",(cAlias)->C6_QTDEMP,0)  //#AFD27062018.N
		else		
			nEstoque := 0	
		endif
	
		//#AFD27062018.BN
		dbselectArea("SUB")
		SUB->(dbsetorder(1))
		if SUB->(dbseek((cAlias)->C6_MSFIL+alltrim(substr((cAlias)->C6_NUMTMK,5,10))+(cAlias)->C6_ITEM+(cAlias)->C6_PRODUTO))
			cTipoProd := SUB->UB_MOSTRUA
		else
			cTipoProd := '0'
		endif
	
		Do Case
			case cTipoProd == '1'
				cDescTipo := "Pe�a Nova Loja"
			case cTipoProd == '2' 
				cDescTipo := "Mostruario"
			case cTipoProd == '3'
				cDescTipo := "Personalizado"
			case cTipoProd == '4'  	
				cDescTipo := "Acess�rio"
			otherwise
				cDescTipo := ""		
		endcase
		//#AFD27062018.EN
	    
		cQuery := "SELECT ZK0_COD, ZK0_PROD, ZK0_DESCRI, ZK0_NUMSAC, ZK0_CLI, ZK0_LJCLI, ZK0_DTAGEN, ZK0_NUMSAC, ZK0_STATUS, ZK0_CARGA"+ ENTER
		cQuery += " FROM "+RetSqlName("ZK0")+ ENTER
		cQuery += " WHERE ZK0_CLI = '"+ (cAlias)->C6_CLI +"'"+ ENTER
		cQuery += "	AND ZK0_LJCLI = '"+ (cAlias)->C6_LOJA +"'"+ ENTER
		cQuery += " AND D_E_L_E_T_ = ' '"
		
		cAlias1 := getNextAlias()
		
		plsQuery(cQuery,cAlias1)
		
		aTerRet := {}
		_cAtend := (cAlias1)->ZK0_NUMSAC // Numero do Atendimento SAC
				
		while (cAlias1)->(!eof())
			
			
			aAdd(aTerRet,{;
							(cAlias1)->ZK0_COD,;
							(cAlias1)->ZK0_PROD,;
							(cAlias1)->ZK0_DESCRI,;
							(cAlias1)->ZK0_NUMSAC,;
							(cAlias1)->ZK0_CLI,;
							(cAlias1)->ZK0_LJCLI,;
							(cAlias1)->ZK0_DTAGEN,;
							(cAlias1)->ZK0_STATUS,;
							(cAlias1)->ZK0_CARGA})
	
		(cAlias1)->(dbSkip())
		end
	    
	    (cAlias1)->(dbCloseArea())
	    
		//Verifica se existe termo retira
		for a := 1 to len(aTerRet)
			if aTerRet[a][8] == '1'
				cTermo := "SIM"
				exit
			else
				cTermo := "N�O"
			endif
		next a
		
		if len(aTerRet) == 0
			cTermo := "N�O"
		endif

		//Identifac��o de produtos fora de linha
		iif((cAlias)->B1_01FORAL == 'F',cForaLinha := "SIM",cForaLinha := "N�O")
		
		aAdd( aItens , { iif(!empty(alltrim((cAlias)->C6_NOTA)),oSt3,iif((cAlias)->C6_01AGEND =="1",oSt1,oSt2)) ,;  //1
						 (cAlias)->C6_ITEM,;																		//2
						 (cAlias)->C6_PRODUTO,;																		//3
						 Alltrim((cAlias)->C6_DESCRI),;																//4
						 (cAlias)->C6_QTDVEN,; 																		//5
		                 (cAlias)->C6_VALOR,;																		//6
						 (cAlias)->C6_LOCAL,;																		//7
						 (cAlias)->C6_ENTREG,;																		//8
						 nEstoque,;																					//9
						 cEstoque,;																					//10
						 cDescTipo,;																				//11
						 cForaLinha,;																				//12
						 cTermo,;																					//13
						 (cAlias)->C6_NOTA,;																		//14
	  					 (cAlias)->C6_LOCALIZ,;																		//15
	  					 (cAlias)->C6_XNUMSC,;																		//16
						 (cAlias)->C6_XUSRAGE,;																		//17					 						 
						 .F.} )																						//18
	
		
		(cAlias)->(DbSkip())
	EndDo
    
    if len(aItens) <= 0
    	aAdd(aItens,{"","","","",0,0,"",ctod(""),0,"","","","","","","","",.F.})
    endif 
    
	oGridIt:SetArray(aItens)    
	oGridIt:ForceRefresh()
	oLayer:Refresh()
	
Return

//Cria Perguntes
Static Function xPutSx1(cPerg)
	
	cPerg      := PADR(cPerg,10)
	aRegs       := {}
	
	DbSelectArea("SX1")
	DbSetOrder(1)
	
	If !Dbseek(cPerg)

		Aadd(aRegs,{cPerg,"01","Filial de  ?" 			,"","C","mv_ch1","C",04,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","SM0",""})
		Aadd(aRegs,{cPerg,"02","Filial at�  ?" 			,"","C","mv_ch2","C",04,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","SM0",""})
		Aadd(aRegs,{cPerg,"03","Data Abertura de ?"		,"","D","mv_ch3","D",08,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		Aadd(aRegs,{cPerg,"04","Data Abertura at� ?"	,"","D","mv_ch4","D",08,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		Aadd(aRegs,{cPerg,"05","Cliente de  ?" 			,"","C","mv_ch5","C",06,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","SA3",""})
		Aadd(aRegs,{cPerg,"06","Loja Cliente de  ?"		,"","C","mv_ch6","C",02,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		Aadd(aRegs,{cPerg,"07","Cliente at�  ?" 		,"","C","mv_ch7","C",08,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","SA3",""})
		Aadd(aRegs,{cPerg,"08","Loja Cliente at�  ?"	,"","C","mv_ch8","C",02,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		Aadd(aRegs,{cPerg,"09","Pedido de  ?" 			,"","C","mv_ch9","C",06,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","SC5",""})
		Aadd(aRegs,{cPerg,"10","Pedido at�  ?" 			,"","C","mv_ch10","C",06,0,0,"G","","MV_PAR10","","","","","","","","","","","","","","","","","","","","","","","","","SC5",""})
		Aadd(aRegs,{cPerg,"11","Data Entrega de ?"		,"","D","mv_ch11","D",08,0,0,"G","","MV_PAR11","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		Aadd(aRegs,{cPerg,"12","Data Entrega at� ?"		,"","D","mv_ch12","D",08,0,0,"G","","MV_PAR12","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		Aadd(aRegs,{cPerg,"13","Agendado ?"				,"","N","mv_ch13","N",01,0,0,"C","","MV_PAR13","Todos","","","","","Sim","","","","","N�o","","","","","","","","","","","","","","",""})
		aAdd(aRegs,{cPerg,"14","Pedido Faturado ?"		,"","N","mv_ch14","N",01,0,0,"C","","MV_PAR14","Sim","","","","","N�o","","","","","","","","","","","","","","","","","","","",""})
	Endif

	For i:=1 to LEN(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= LEN(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Else
					exit
				Endif
			Next
			MsUnlock()
		Endif
	Next

Return

//--------------------------------------------------------------
/*/{Protheus.doc} ITAGEND
Description => //Fun��o responsavel por apresentar os Itens agendados
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 18/07/2018
/*/
//--------------------------------------------------------------

Static Function ITAGEND()

	Local aPerg  	:= {}
	Local aButtons  := {}
	Local aItens 	:= {}  
	Local oTelIT, oBrwIT
	Local aCabIt := {}
	Local aFields := {"C6_QTDVEN","C6_ENTREG","C6_QTDVEN","C6_QTDVEN"}

	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	For nX := 1 to Len(aFields)
		If SX3->(DbSeek(aFields[nX]))
	    	Aadd(aCabIt, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
	                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
	    Endif
	Next nX

	Aadd(aPerg,{PadR("ITAGEND",10),"01","Empresa  ?" 			,"MV_CH01" ,"C",004,00,"G","MV_PAR01",""     ,""      ,""			,"","","SM0EMP",""			})
	Aadd(aPerg,{PadR("ITAGEND",10),"02","Empresa  ?" 			,"MV_CH02" ,"C",004,00,"G","MV_PAR02",""     ,""      ,""			,"","","SM0EMP",""			})
	Aadd(aPerg,{PadR("ITAGEND",10),"03","Data Entrega de ?"		,"MV_CH03" ,"D",008,00,"G","MV_PAR03",""     ,""      ,""			,"","",""	,""   		})
	Aadd(aPerg,{PadR("ITAGEND",10),"04","Data Entrega at� ?"	,"MV_CH04" ,"D",008,00,"G","MV_PAR04",""     ,""      ,""			,"","",""	,""   		})
	
	VldSX1(aPerg)
	
	If !Pergunte(aPerg[1,1],.T.)
		Return(Nil)
	EndIf                            
	
	cQuery := " SELECT SUM(C6_QTDVEN) QTDE, C6_ENTREG  FROM " + RETSQLNAME("SC6") + "(NOLOCK) SC6 "
	cQuery += " INNER JOIN " + RETSQLNAME("SC5") + "(NOLOCK) SC5 ON SC5.C5_FILIAL = SC6.C6_FILIAL "
	cQuery += " AND SC5.C5_MSFIL = SC6.C6_MSFIL "
	cQuery += " AND SC5.C5_NUM = SC6.C6_NUM "
	cQuery += " AND SC5.C5_CLIENTE = SC6.C6_CLI "
	cQuery += " AND SC5.C5_LOJACLI = SC6.C6_LOJA "
	cQuery += " AND SC5.D_E_L_E_T_ = ' ' "   
	cQuery += " INNER JOIN " + RETSQLNAME("SB1") + "(NOLOCK) SB1 ON SB1.B1_COD = SC6.C6_PRODUTO " //#AFD26072018.N
	cQuery += " AND SB1.B1_XACESSO <> '1' " //#AFD26072018.N
	cQuery += " AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE SC6.C6_FILIAL <> ' ' "
	cQuery += " AND SC6.C6_ENTREG  BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "' "
	cQuery += " AND SC6.C6_MSFIL BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
	cQuery += " AND SC6.C6_01AGEND = '1' "
	cQuery += " AND SC6.C6_BLQ <> 'R'"                           
	cQuery += " AND SC6.D_E_L_E_T_ = ' ' "
	cQuery += " GROUP BY C6_ENTREG "    
	cQuery += " ORDER BY C6_ENTREG "
	
	If Select("TRB") > 0                                                                       
		TRB->(DbCloseArea())
	EndIf
	
	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
	
	While TRB->(!EOF())
		aAdd( aItens , { TRB->QTDE, TRB->C6_ENTREG,0,0 } )
		TRB->(DbSkip())
	EndDo   
	
	cQry := " SELECT SUM(C6_QTDVEN) FAT, C6_ENTREG  FROM " + RETSQLNAME("SC6") + "(NOLOCK) SC6 "
	cQry += " INNER JOIN " + RETSQLNAME("SC5") + "(NOLOCK) SC5 ON SC5.C5_FILIAL = SC6.C6_FILIAL "
	cQry += " AND SC5.C5_MSFIL = SC6.C6_MSFIL "
	cQry += " AND SC5.C5_NUM = SC6.C6_NUM "
	cQry += " AND SC5.C5_CLIENTE = SC6.C6_CLI "
	cQry += " AND SC5.C5_LOJACLI = SC6.C6_LOJA "
	cQry += " AND SC5.D_E_L_E_T_ = ' ' "   
	cQry += " INNER JOIN " + RETSQLNAME("SB1") + "(NOLOCK) SB1 ON SB1.B1_COD = SC6.C6_PRODUTO " //#AFD26072018.N
	cQry += " AND SB1.B1_XACESSO <> '1' " //#AFD26072018.N
	cQry += " AND SB1.D_E_L_E_T_ = ' ' "	
	cQry += " WHERE SC6.C6_FILIAL <> ' ' "
	cQry += " AND SC6.D_E_L_E_T_ = ' ' "
	cQry += " AND SC6.C6_ENTREG  BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "' "
	cQry += " AND SC6.C6_MSFIL BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
	cQry += " AND SC6.C6_01AGEND = '1' "
	cQry += " AND SC6.C6_BLQ <> 'R'"   
	cQry += " AND SC6.C6_NOTA <> ''"                           
	cQry += " GROUP BY C6_ENTREG "    
	cQry += " ORDER BY C6_ENTREG "
	
	If Select("_TRB1_") > 0
		_TRB1_->(DbCloseArea())
	EndIf
	
	cQry := ChangeQuery(cQry)
	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQry),"_TRB1_",.F.,.T.)
	
	While _TRB1_->(!EOF())
		For _NX :=1 to len(aItens)
		
		IF _TRB1_->C6_ENTREG == aItens[_NX,2]
		aItens[_NX,3] :=_TRB1_->FAT
		aItens[_NX,4] :=aItens[_NX,1]-_TRB1_->FAT
		EndIf		
		Next _NX 
		_TRB1_->(DbSkip())
	EndDo   
	
	
	IF Len(aItens) > 0
		//��������������������������������������������������Ŀ
		//� MONTA A TELA PRINCIPAL DE AGENDAMENTO DE PEDIDOS �
		//����������������������������������������������������
		DEFINE MSDIALOG oTelIT FROM 0,0 TO 600,400 TITLE "Itens Agendados" Of oMainWnd PIXEL 
		
		oBrwIT:= TwBrowse():New(005, 005, 200, 150,, {'Quantidade','Dt.Entrega','FAT','NFAT'},,oTelIT,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
		oBrwIT:SetArray(aItens)
		oBrwIT:bLine      := {|| { 	Transform(aItens[oBrwIT:nAt,01],PesqPict('SC6','C6_QTDVEN')) ,;
									DTOC(STOD(aItens[oBrwIT:nAt,02])),;
									Transform(aItens[oBrwIT:nAt,03],PesqPict('SC6','C6_QTDVEN')) ,;
									Transform(aItens[oBrwIT:nAt,04],PesqPict('SC6','C6_QTDVEN')) }}
		
		
		oBrwIT:bLDblClick := {|| ITAGEND2(aItens[oBrwIT:nAt,02]) } 
		
		oBrwIT:Align      := CONTROL_ALIGN_ALLCLIENT 
		
		aadd(aButtons,{"", {|| RelExAgIt(aCabIt, aItens, "ITENS AGENDADOS POR FILIAL") },"Imprimir","Imprimir"})
		
		ACTIVATE MSDIALOG oTelIT ON INIT EnchoiceBar( oTelIT, { || oTelIT:End() } , { || oTelIT:End() },, aButtons)
	
	Else
		MsgInfo("N�o foram encontrados dados para os parametros informados.","ATEN��O")
	EnDIF	

Return()

//--------------------------------------------------------------
/*/{Protheus.doc} ITAGEND2
Description => Cria Tela com os pedidos agendados com base base na data informada
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 18/07/2018
/*/
//--------------------------------------------------------------
Static Function ITAGEND2(_cData)
	
	Local oGet
	Local cGet := space(6)
	Local oSay1
	Local oBtnImprimir
	Local oFont11
	
	DEFINE FONT oFont11 NAME "Arial" SIZE 0, -11 BOLD

	Static oTelIT2
	
	DEFINE MSDIALOG oTelIT2 TITLE "Itens Agendados" FROM 000, 000  TO 400, 800 COLORS 0, 16777215 PIXEL

    @ 006, 002 Say  oSay Prompt 'Pesquisar Pedido:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oGet Pixel
    @ 004, 065 MSGET oGet VAR cGet SIZE 049, 010 OF oTelIT2 COLORS 0, 16777215 PIXEL VALID {|| findPedido(cGet)} 
    @ 004, 115 BUTTON oBtnImprimir PROMPT "Imprimir" SIZE 053, 012 OF oTelIT2 ACTION {|| RelExcelAg(oNewAgend2:aHeader, oNewAgend2:aCols, "Pedidos Agendados")} PIXEL
	
	fNewAgend2(_cData)

 	ACTIVATE MSDIALOG oTelIT2 CENTERED

Return 

//--------------------------------------------------------------
/*/{Protheus.doc} fNewAgend2
Description => Popula a Tela com os pedidos agendados com base base na data informada
@param (Caracter) Parameter Description (Data)
@return xRet Return Description
@author  - Alexis Duarte
@since 18/07/2018
/*/
//--------------------------------------------------------------
Static Function fNewAgend2(_cData)

	Local nX
	Local aHeader := {}
	Local aFieldFill := {}
	Local aFields := {"C5_XDESCFI","C5_NUM","C6_QTDVEN","C5_NOTA","C6_ENTREG"}
	Local aAlterFields := {}
    Local cQuery := ""
    
   	Private aColsAg := {}
    
    Static aColsBkp := {}
    Static oNewAgend2

	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	For nX := 1 to Len(aFields)
		If SX3->(DbSeek(aFields[nX]))
	    	Aadd(aHeader, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
	                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
	    Endif
	Next nX
	
	cQuery := "SELECT FILIAL, C5_NUM AS PEDIDO, SUM(C6_QTDVEN) AS QTD, C5_NOTA AS NOTA ,C6_ENTREG ,SC5.R_E_C_N_O_"
	cQuery += " FROM "+retSqlName("SC6")+"(NOLOCK) SC6"
	cQuery += " INNER JOIN "+retSqlName("SC5")+"(NOLOCK) SC5 ON C5_FILIAL = C6_FILIAL"
	cQuery += " AND SC5.C5_MSFIL = C6_MSFIL"
	cQuery += " AND SC5.C5_NUM = C6_NUM"
	cQuery += " AND SC5.C5_CLIENTE = C6_CLI "
	cQuery += " AND SC5.C5_LOJACLI = C6_LOJA"
	cQuery += " AND SC5.D_E_L_E_T_ = ' ' "
	cQuery += " INNER JOIN " + retSqlName("SB1") + "(NOLOCK) SB1 ON B1_COD = C6_PRODUTO " //#AFD26072018.N
	cQuery += " AND SB1.B1_XACESSO <> '1' " //#AFD26072018.N
	cQuery += " AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += " INNER JOIN SM0010 SM0 ON SM0.FILFULL = SC6.C6_MSFIL"
	cQuery += " WHERE SC6.D_E_L_E_T_ = ' ' "
	cQuery += " AND SC6.C6_ENTREG = '"+ _cData +"'"
	cQuery += " AND SC6.C6_01AGEND = '1'  "
	cQuery += " AND SC6.C6_BLQ <> 'R'"
	cQuery += " GROUP BY FILIAL, C5_NUM, C5_NOTA, C6_ENTREG, SC5.R_E_C_N_O_"
	cQuery += " ORDER BY PEDIDO"

	If Select("TRB") > 0                                                                     
		TRB->(DbCloseArea())
	EndIf
	
	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
	
	While TRB->(!EOF())
		aAdd( aColsAg , { TRB->FILIAL,;
						 TRB->PEDIDO,;
						 TRB->QTD,;
						 TRB->NOTA,;
						 dtoc(stod(TRB->C6_ENTREG)),;
						 .F. } )
		TRB->(DbSkip())
	EndDo   
    
	aColsBkp := aColsAg
	
	oNewAgend2 := MsNewGetDados():New( 019, 004, 196, 396, , "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oTelIT2, aHeader, aColsAg)
	
	oNewAgend2:oBrowse:SetFocus()

Return

//--------------------------------------------------------------
/*/{Protheus.doc} findPedido
Description => Pesquisa o pedido informado, filtra somente ele na tela
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 18/07/2018
/*/
//--------------------------------------------------------------
Static Function findPedido(_cPedido)
	
	Local nPos := 0
	Local aCols := {}

	nPos := aScan(oNewAgend2:acols ,{|x|x[2] == _cPedido }) 
	
	if nPos > 0
		
		aColsAg := {}
				
		aAdd(aCols,{;
					oNewAgend2:acols[nPos][1],; 
					oNewAgend2:acols[nPos][2],;
					oNewAgend2:acols[nPos][3],;
					oNewAgend2:acols[nPos][4],;
					oNewAgend2:acols[nPos][5],;
					.F.})
		
		oNewAgend2:SetArray(aCols)
		oNewAgend2:REFRESH()
	else
		MsgAlert("Pedido n�o encontrado..","ATEN��O")
		aColsAg := {}
		oNewAgend2:SetArray(aColsBkp)
		oNewAgend2:REFRESH()
	endif
	
Return

//--------------------------------------------------------------
/*/{Protheus.doc} VldSX1
Description => Cria ou atualiza o pergunte dos itens agendados
@param (Array) Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 18/07/2018
/*/
//--------------------------------------------------------------
Static Function VldSX1(aPergunta)

	Local i
	Local aAreaBKP := GetArea()
	
	dbSelectArea("SX1")
	
	SX1->(dbSetOrder(1))
	
	For i := 1 To Len(aPergunta)
		SX1->(RecLock("SX1",!dbSeek(aPergunta[i,1]+aPergunta[i,2])))
			SX1->X1_GRUPO 		:= aPergunta[i,1]
			SX1->X1_ORDEM		:= aPergunta[i,2]
			SX1->X1_PERGUNT		:= aPergunta[i,3]
			SX1->X1_VARIAVL		:= aPergunta[i,4]
			SX1->X1_TIPO		:= aPergunta[i,5]
			SX1->X1_TAMANHO		:= aPergunta[i,6]
			SX1->X1_DECIMAL		:= aPergunta[i,7]
			SX1->X1_GSC			:= aPergunta[i,8]
			SX1->X1_VAR01		:= aPergunta[i,9]
			SX1->X1_DEF01		:= aPergunta[i,10]
			SX1->X1_DEF02		:= aPergunta[i,11]
			SX1->X1_DEF03		:= aPergunta[i,12]
			SX1->X1_DEF04		:= aPergunta[i,13]
			SX1->X1_DEF05		:= aPergunta[i,14]
			SX1->X1_F3			:= aPergunta[i,15]
		SX1->(MsUnlock())
	Next i
	
	RestArea(aAreaBKP)

Return

//--------------------------------------------------------------
/*/{Protheus.doc} TELMANU
Description => Tela de agendamento do pedido de venda, com dados do pedido e cliente.
@param: aCols -  Parameter Description: acols com o cabe�alho contendo as informa�es do pedido de venda
@return: NULL - Return Description: Nenhum
@author - Alexis Duarte                                              
@since 12/09/2018                                                   
/*/                                                             
//--------------------------------------------------------------
Static Function TELMANU(aCols)                        

	Local cTitulo := "Agendamento de Pedido"
	Local cCliente   := aCols[nPCliente]
	Local cLoja      := aCols[nPLojaCli]
	Local oGroup1
	Local oGroup2
	Local oGroup3
	Local oGroup4
	Local oGroup5
	Local oRegCon
	Local oBtnAgendar
	Local oBtnAltCli
	Local oBtnSair
	Local oGetBairro
	Local cBairro := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_BAIRRO")
	Local oGetCidade
	Local oGetDtAgend
	Local dGetDtAgend := dDataBase
	Local oGetEstado
	Local oGetRua
	Local cRua := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_END")
	Local cDDD := '('+ alltrim(Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_DDD")) +') '
	Local oGetTel1
	Local cTel1 := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_TEL")
	Local oGetTel2
	Local cTel2 := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_TEL2")
	Local oGetTel3
	Local cTel3 := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_XTEL3")
	Local oSay12
	Local oSayBairro
	Local oSayCep
	Local cCep := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_CEP")
	Local oSayCidade
	Local cCidade := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_MUN")
	Local oSayDtAgend
	Local oSayEstado
	Local cEstado := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_EST")
	Local oSayObs
	Local oSayRua
	Local oTelefone1
	Local oTelefone2 
	Local oTelefone3
    Local xPedCar := aCols[nPPedido]
	//Informa��es do pedido de venda
	Local oMsgPed
	Local cMsgObsPed := ""
		
	//Informa��es de entrega
	Local oMsgEnt
	Local cMsgObsEnt := ""
	Local cRegCon    := Space(240)
	
	Local nCont := 0
	Local cUsados := ""
	Local lGrava := .F.
	Local lRet := .F.
	Local nx := 0

	Static oDlg
	
	if nRadAgreg == 2
		MsgAlert("N�o � possivel realizar agendamentos com a op��o (Sem Agregados) selecionada.","ATEN��O")
		Return
	endif
	
	If nMostrua == 2
		MsgAlert("N�o � possivel realizar agendamentos com o filtro Mostruario igual a N�O selecionado.","ATEN��O")
		Return
	EndIf                                  
	
	// P.E. p/ bloquear o agendamento - Cristiam Rossi em 07/04/2017
	if existBlock("SYTM01BLQ") .and. ExecBlock("SYTM01BLQ",.F.,.F.,{ xFilial("SC5"), aCols[nPPedido] })
		Return nil
	endif
    
	DbSelectArea("SC6")
	SC6->(DbSetOrder(1))
		
	for nx := 1 To Len(aItens)
		if SC6->(DbSeek(xFilial("SC6") + aCols[nPPedido] + aItens[nx][nPItem] + aItens[nx][nPProduto])) //Pedido + Item + Produto
			if SC6->C6_ENTREG == stod('66660606') .AND. SC6->C6_LOCAL <> '12'
				msgAlert("Itens de desmontagem so podem sair do armazem 12, altere o armazem do item ("+ aItens[nx][nPItem] +").","Aten��o")
				nCont++
				loop
			endif
		endif
	//xPedCar:=aCols[nPPedido]
	next nx
	
	//Altera��o solicitada pelo chamado 9628
	DbselectArea("DAI")
	DAI->(dbsetorder(4))
	If DAI->(DbSeek(xFilial("DAI")+xPedCar))
		cMsgCarga := "O pedido: "+ xPedCar +" ja possui carga montada"+ENTER
		cMsgCarga += "N�o � permitido sua alteracao. Entre em contato com a Logistica!"
		msgStop(cMsgCarga,"ATEN��O")
		return
	Endif
	
	if nCont > 0
		Return
	endif

	fGetMsg(aCols,@cMsgObsPed,@cMsgObsEnt)
	
	Private aCpos := {"A1_END","A1_BAIRRO","A1_EST","A1_CEP", "A1_MUN","A1_DDD","A1_TEL","A1_TEL2","A1_XTEL3","A1_CONTATO","A1_EMAIL","A1_COMPLEM" }
	Private cCadastro := "Cadastro de Clientes - Altera��o de Cadastro"
    
  	//Montagem da Tela
  	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 000, 000  TO 600, 390 COLORS 0, 16777215 PIXEL

    @ 004, 003 GROUP oGroup1 TO 042, 192 PROMPT " Agendamento do Pedido - " + aCols[nPPedido] OF oDlg COLOR 0, 16777215 PIXEL
    @ 016, 009 SAY oSayObs PROMPT "Deseja agendar todos os itens disponiveis ?" SIZE 110, 007 OF oDlg COLORS 692766, 16777215 PIXEL
    @ 029, 010 SAY oSayDtAgend PROMPT "Data do agendamento:" SIZE 056, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 027, 069 MSGET oGetDtAgend VAR dGetDtAgend PICTURE PesqPict("SC6","C6_ENTREG") SIZE 056, 010 OF oDlg  VALID vldDate(dGetDtAgend) COLORS 0, 16777215 PIXEL
    @ 027, 135 BUTTON oBtnAgendar PROMPT "Agendar" SIZE 047, 012 OF oDlg PIXEL
    
    oBtnAgendar:BLCLICKED:= {|| lGrava := .T. , (oGridIt:ForceRefresh(),oDlg:End())  }
	oGridIt:ForceRefresh()
	
    @ 046, 003 GROUP oGroup2 TO 115, 192 PROMPT " Informa��es do Cliente - " + alltrim(aCols[nPNome])  OF oDlg COLOR 0, 16777215 PIXEL
    
    //Rua
    @ 054, 010 SAY oSayRua PROMPT "Rua:" SIZE 015, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 054, 024 SAY oGetRua PROMPT cRua SIZE 162, 007 OF oDlg COLORS 0, 16777215 PIXEL
    
    //Bairro
    @ 061, 010 SAY oSayBairro PROMPT "Bairro:" SIZE 018, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 061, 027 SAY oGetBairro PROMPT cBairro SIZE 089, 007 OF oDlg COLORS 0, 16777215 PIXEL
    
 	//Cidade
    @ 069, 010 SAY oSayCidade PROMPT "Cidade:" SIZE 021, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 069, 030 SAY oGetCidade PROMPT cCidade SIZE 055, 007 OF oDlg COLORS 0, 16777215 PIXEL

	//Estado  
    @ 077, 010 SAY oSayEstado PROMPT "Estado:" SIZE 021, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 077, 031 SAY oGetEstado PROMPT cEstado SIZE 015, 007 OF oDlg COLORS 0, 16777215 PIXEL
    
    //Cep
    @ 085, 010 SAY oSayCep PROMPT "CEP:" SIZE 014, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 085, 024 SAY oSay12 PROMPT cCep SIZE 035, 007 OF oDlg COLORS 0, 16777215 PIXEL
	
	//Telefone 1  
    @ 092, 010 SAY oTelefone1 PROMPT "Telefone 1:" SIZE 030, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 092, 039 SAY oGetTel1 PROMPT cDDD + cTel1 SIZE 060, 007 OF oDlg COLORS 0, 16777215 PIXEL

	//Telefone 2
    @ 099, 010 SAY oTelefone2 PROMPT "Telefone 2:" SIZE 030, 007 OF oGroup2 COLORS 0, 16777215 PIXEL
    @ 099, 039 SAY oGetTel2 PROMPT cDDD + cTel2 SIZE 060, 007 OF oDlg COLORS 0, 16777215 PIXEL
    
  	//Telefone 3
    @ 107, 010 SAY oTelefone3 PROMPT "Telefone 3:" SIZE 030, 007 OF oGroup2 COLORS 0, 16777215 PIXEL
    @ 107, 039 SAY oGetTel3 PROMPT cDDD + cTel3 SIZE 060, 007 OF oDlg COLORS 0, 16777215 PIXEL

	//Botao com a a��o para alterar informa��es do cadastro do cliente    
    @ 099, 124 BUTTON oBtnAltCli PROMPT "Alterar dados do Cliente" SIZE 064, 012 OF oDlg PIXEL
	oBtnAltCli:BLCLICKED:= {|| AxAltera("SA1",SA1->(Recno()),4,,aCpos) }    

	//Informa��es do pedido de venda
    @ 118, 003 GROUP oGroup3 TO 172, 192 PROMPT " Observa��es do Pedido de venda " OF oDlg COLOR 0, 16777215 PIXEL
	@ 125, 006 GET oMsgPed VAR cMsgObsPed MEMO SIZE 182, 044 PIXEL OF oDlg
	
	//Informa��es de entrega, informadas pelo SAC
    @ 176, 003 GROUP oGroup4 TO 243, 192 PROMPT " Observa��es de Entrega " OF oDlg COLOR 0, 16777215 PIXEL
	@ 184, 006 GET oMsgEnt VAR cMsgObsEnt MEMO SIZE 182, 057 PIXEL OF oDlg	
	
	//Restri��o de Entrega
	@ 246, 003 GROUP oGroup5 TO 270, 192 PROMPT " Restri��o de Entrega " OF oDlg COLOR 0, 16777215 PIXEL
	@ 253, 006 GET oRegCon VAR cRegCon SIZE 182, 010 PIXEL OF oDlg 
	
	//Bot�o Sair
    @ 280, 004 BUTTON oBtnSair PROMPT "Sair" SIZE 187, 016 OF oDlg ACTION {|| oDlg:End() } PIXEL
    
    ACTIVATE MSDIALOG oDlg CENTERED
    
    If Empty(cRegCon)
			MsgAlert('Campo restri��o de entrega vazio. Agendamento n�o efetuado.' ,'Aten��o')
			Return
	EndIf
	
	if lGrava
		
		fGravaAll()
		
		DbSelectArea("SC6")
		SC6->(DbSetOrder(1))
		
		for nx := 1 To Len(aItens)
			if SC6->(DbSeek(xFilial("SC6") + aCols[nPPedido] + aItens[nx][nPItem] + aItens[nx][nPProduto])) //Pedido + Item + Produto
				if empty(alltrim(SC6->C6_NOTA))
					if aItens[nx][nPQAtu] > 0 // Verifica se tem estoque
						nSaldo := 0
						cEndereco := ""
						lRet := .F.
						//Obs: incluida valida��o devido o campo estar Negativo
	
		                if SC6->C6_QTDEMP < 0
			                RecLock("SC6",.F.)
								SC6->C6_QTDEMP := 0	
		   					MsUnlock()
	                    endif
						
						//Verifico se o item ja esta liberado
		                if SC6->C6_QTDEMP > 0 .and. aItens[nx][nPItemLib] == "SIM"
							
							fAtuMsg(aCols,@cMsgObsPed,@cMsgObsEnt)
							
							RecLock("SC6",.F.)
								SC6->C6_ENTREG  := dGetDtAgend
								SC6->C6_DTAGEND := dDataBase
								SC6->C6_XUSRAGE := cUserName
								SC6->C6_01AGEND := "1"
							MsUnlock()
	
							aItens[nx][nPStatusIt] := "1" 
							aItens[nx][nPEntrega] := dGetDtAgend
							aItens[nx][nPUsrAgend] := cUserName
							
							dDataAgTerm := dGetDtAgend
	
						else 
							cEndereco := u_getEnd(SC6->C6_PRODUTO, SC6->C6_LOCAL, SC6->C6_QTDVEN, @cUsados, @nSaldo)
							
							//Libera o pedido de venda e Cria a reserva no SB2_RESERVA
							lRet := u_LibEst(SC6->C6_NUM,SC6->C6_ITEM,SC6->C6_PRODUTO,SC6->C6_QTDVEN,nSaldo)
	                    endif
	
						if lRet
							fAtuMsg(aCols,@cMsgObsPed,@cMsgObsEnt)

							RecLock("SC6",.F.)
								SC6->C6_ENTREG  := dGetDtAgend
								SC6->C6_DTAGEND := dDataBase
								SC6->C6_01AGEND := "1"
								SC6->C6_XUSRAGE := cUserName
								SC6->C6_LOCALIZ := cEndereco
							MsUnlock()
							
							aItens[nx][nPStatusIt] := "1" 
							aItens[nx][nPEntrega] := dGetDtAgend
							aItens[nx][nPUsrAgend] := cUserName
							
							U_SYTMOV15(SC6->C6_NUM,SC6->C6_ITEM,SC6->C6_PRODUTO,"3")
							dDataAgTerm := dGetDtAgend
						endif	                    
					else
						nCont++
					endif
				endif				
			endif
		next nx                                                               
		
		//------------------------------------------------------------------
		DbSelectArea("SC5")
		SC5->(DbSetOrder(1))
			If SC5->( dbSeek( xFilial("SC5") + xPedCar ) )//Filial + Pedido
				RecLock("SC5", .F.)
					 SC5->C5_XREGCON := Alltrim(cRegCon)
				MsUnlock()
			EndIf
		SC5->(dbCloseArea())		
		//-------------------------------------------------------------------
		
		AlterDtAgend()
		
		fRetStatus(oGridPed:nat,oGridPed:acols[oGridPed:nat][nPPedido])
		
		fCarrIt(oGridPed:acols[oGridPed:nat][nPPedido],oGridPed:acols[oGridPed:nat][nPCliente],oGridPed:acols[oGridPed:nat][nPLojaCli])
		oGridIt:ForceRefresh()
		
	EndIf
	
	if nCont > 0
		MsgAlert("Existem produtos nesse pedido com bloqueio de estoque, o agendamento ocorrer� somente nos itens com saldo","Aten��o")
	endif
	
	oGridIt:ForceRefresh()
	
Return

//--------------------------------------------------------------
/*/{Protheus.doc} vldDate
Description //Valida a data digitada no agendamento                                                    
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 03/10/2018
/*/
//--------------------------------------------------------------
Static Function vldDate(dGetDtAgend,cCombo)
	
	Local lRet := .T.
	Local lBlq := .F.
	Local _cUser := SUPERGETMV("KH_USBLQAG", .T., "000478")
	
	Default cCombo := ''
	
	If !Empty(cCombo)
	
		dGetDtAgend := CTOD(Substring(cCombo,1,10))
	
	EndIf
	
	If  !__cUserid $ _cUser  //valida��o para apenas os usuarios do parametro KH_USBLQAG conseguirem agendar sem validar a data de bloqueio de agendamento.
		
		dbSelectArea("ZK7")
		ZK7->(dbsetorder(1))
		
		//Se a data estiver cadastrada, bloqueia o agendamento
		if ZK7->(dbseek(xFilial()+dtos(dGetDtAgend)))
			lBlq := .T.
		endif
		
	EndIf
	
	if dGetDtAgend < dDataBase
		apMsgAlert("N�o � possivel informar uma data menor que a data base.","WARNING")
		return(.F.)
	endif 

	if lBlq
		apMsgAlert("A data informada "+ dtoc(dGetDtAgend) +" esta bloqueada para agendamentos!","WARNING")
		return(.F.)
	endif

	If !dtoc(dGetDtAgend) == '22/12/2222' .and. !dtoc(dGetDtAgend)  == '08/08/8888' //Valida��o para excluir estas duas datas da valida��o de domingo.N�mero do ticket: 13057
		if alltrim(DiaSemana(dGetDtAgend)) == 'Domingo'
			apMsgAlert("N�o � possivel agendar entrega aos domingos.","WARNING")
			return(.F.)
		endif
	EndIf	

Return lRet

//--------------------------------------------------------------
/*/{Protheus.doc} fGravaAll
Description                                                     

@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 16/07/2018
/*/
//--------------------------------------------------------------
Static Function fGravaAll()
	
	Local nx

	aTermAgend := {}
	
	for nx := 1 to len(aTerRet) 
		if aTerRet[nx][8] == '1'
			aAdd(aTermAgend,{aTerRet[nx][1],aTerRet[nx][2],aTerRet[nx][3]})	
		endif
	next nx
	
	if len(aTermAgend) > 0
		msgInfo("Todos os termos retira pendentes, ser�o agendados juntamente com o pedido.","ATEN��O")	
	endif
	
Return

//--------------------------------------------------------------
/*/{Protheus.doc} AlterDtAgend
Description                                                     

@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 16/07/2018
/*/
//--------------------------------------------------------------
Static Function AlterDtAgend()
	
	Local aArea := getArea()
	Local nx

	dbSelectArea("ZK0")
	ZK0->(dbSetOrder(1))

	for nx := 1 to len(aTermAgend)
		if ZK0->(dbSeek(xFilial("ZK0")+aTermAgend[nx][1]))
			if ZK0->ZK0_STATUS == '1'
				RecLock("ZK0",.F.)
					ZK0->ZK0_DTAGEN := dDataAgTerm	
				msUnLock()
			endif
		endif
	next nx
	
	restArea(aArea)
		
Return

Static Function AGENDITEM(aCols, aColsItem)
    
	Local cTitulo := "Agendamento de Pedido"
   	Local cCliente := aCols[nPCliente]
	Local cLoja := aCols[nPLojaCli]
	Local cPedido := aCols[nPPedido]
	Local cNomeCli := aCols[nPNome]
    
	Local oGroup1
	Local oSayItem
	Local oGetItem
	Local cItem := aColsItem[nPItem]
	Local oCodigo
	Local ogetCod
	Local cCodigo := aColsItem[nPProduto]
	Local oSayDesc
	Local ogetDesc
	Local cDescricao := aColsItem[nPDescriIt]
	Local oSayDtAgend
	Local dGetDtAgend := Date()		
	Local oBtnAgendar

	Local cItemLib := aColsItem[nPItemLib]
	
	Local oGroup2
	Local cDDD := '('+ alltrim(Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_DDD")) +') '
	Local oSayRua
	Local oGetRua
	Local cRua := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_END")
	Local oSayBairro
	Local oGetBairro			
	Local cBairro := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_BAIRRO")
	Local oSayCidade
	Local oGetCidade	
	Local cCidade := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_MUN")
	Local oSayEstado
	Local oGetEstado			            
	Local cEstado := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_EST")
	Local oSayCep		            
	Local ogetCep
	Local cCep := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_CEP")
	Local oTelefone1
	Local oGetTel1
	Local cTel1 := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_TEL")
	Local oGetTel2                      
	Local oTelefone2
	Local cTel2 := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_TEL2")
	Local oGetTel3	
	Local oTelefone3
	Local cTel3 := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_XTEL3")
	Local oBtnAltCli
    
	//Informa��es do pedido de venda
	Local oGroup3
	Local oMsgPed
	Local cMsgObsPed := ""
	
	//Informa��es de entrega		
	Local oGroup4
	Local oMsgEnt
	Local cMsgObsEnt := ""
	Local oGroup5
	Local oRegCon
	Local cRegCon    := Space(240)

	Local oBtnSair
	Local lGrava := .F.
	Local cUsados := ""
	Local nSaldo := 0
	Local lSaldo := .F.
	Local cEndereco := ""
	Local cMsgBipar := ""
	Local lRet := .F.	
		
	Static oDlgItem
	
	dbSelectArea("SC5")
	SC5->( dbSetOrder(1) )
	if SC5->( dbSeek( xfilial() + cPedido ) ) 
		if SC5->C5_XLIBER == "B"
			msgAlert( "O Pedido de Venda: "+ cPedido +" est� Bloqueado por conta de Desconto nos itens, verificar!", "Agendamento de Pedidos" )
			return
		endif
	endif

	lPendF := vldPendF(aCols[nPMsFil],aCols[nPPedido])
	
	//Veriica se o cliente possiu t�tulos em aberto de pagamento ipedindo o agendamento de entrega dos produtos  - Marcio Nunes - 03/09/2019
	lPendFC := vldPendFC(aCols[nPCliente],aCols[nPLojaCli])                                      			
		
	If lPendF .Or. !lPendFC 
		Return
	Endif

	DbSelectArea("SC6")
	DbSetOrder(1)
	DbSeek(xFilial("SC6") + cPedido + cItem + cCodigo)

	if SC6->C6_ENTREG == stod('66660606') .AND. SC6->C6_LOCAL <> '12'
		msgAlert("Itens de desmontagem so podem sair do armazem 12, altere o armazem do item ("+ cItem +").","Aten��o")
		Return
	endif

	// Valida��o// N�o permitir agendar produtos Bipartidos no agendamento por item.
	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))

	if SB1->(dbSeek(xfilial("SB1")+cCodigo))
		if SB1->B1_01BIPAR == '1'
			cMsgBipar := "O Produto: "+ cCodigo +" Esta cadastrado como Bipartido"+ENTER
			cMsgBipar += "N�o � possivel agendar somente uma das partes !!!"			
			msgStop(cMsgBipar,"ATEN��O")
			return
		endif
	else
		msgStop("Produto: "+ cCodigo +" N�o foi localizado!!" ,"ATEN��O")	
	endif
	
//N�o permitir alteracao para pedidos que j� tenham carga montada chamado 9628
DbselectArea("DAI")
DAI->(dbsetorder(4))
If DAI->(DbSeek(xFilial("DAI") + cPedido))
	cMsgCarga := "O pedido: "+ cPedido +" ja possui carga montada"+ENTER
	cMsgCarga += "N�o � permitido sua alteracao. Entre em contato com a Logistica!"
	msgStop(cMsgCarga,"ATEN��O")
	return
Endif
	fGetMsg(aCols,@cMsgObsPed,@cMsgObsEnt)

	//Selecionar os itens de termo retira que ser�o agendados na mesma data
	fViewTerRe(_cAtend, aTerRet)
		
	if len(aTerRet) > 0 .and. len(aTermAgend) == 0
		if !msgYesNo("Nenhum Termo foi selecionado, deseja prosseguir com o agendamento?","ATEN��O")
			Return
		endif
	endif
	
	Private aCpos := {"A1_END","A1_BAIRRO","A1_EST","A1_CEP", "A1_MUN","A1_DDD","A1_TEL","A1_TEL2","A1_XTEL3","A1_CONTATO","A1_EMAIL","A1_COMPLEM" }
	Private cCadastro := "Cadastro de Clientes - Altera��o de Cadastro"
	
  	//Montagem da Tela	
	DEFINE MSDIALOG oDlgItem TITLE cTitulo FROM 000, 000  TO 600, 390 COLORS 0, 16777215 PIXEL

    @ 002, 003 GROUP oGroup1 TO 055, 192 PROMPT "Informa��es do pedido - " + cPedido OF oDlgItem COLOR 0, 16777215 PIXEL
    @ 009, 010 SAY oSayItem PROMPT "Item :" SIZE 016, 007 OF oDlgItem COLORS 723931, 16777215 PIXEL
    @ 009, 025 SAY oGetItem PROMPT cItem SIZE 019, 007 OF oDlgItem COLORS 0, 16777215 PIXEL
    @ 016, 010 SAY oSay3 PROMPT "Codigo :" SIZE 023, 007 OF oDlgItem COLORS 723931, 16777215 PIXEL
    @ 016, 032 SAY oSay4 PROMPT cCodigo SIZE 085, 007 OF oDlgItem COLORS 0, 16777215 PIXEL
    @ 024, 010 SAY oSayDesc PROMPT "Descri��o :" SIZE 029, 007 OF oDlgItem COLORS 723931, 16777215 PIXEL
    @ 024, 040 SAY oSay5 PROMPT cDescricao SIZE 146, 015 OF oDlgItem COLORS 0, 16777215 PIXEL
    @ 043, 010 SAY oSayDtAgend PROMPT "Data do agendamento:" SIZE 056, 007 OF oDlgItem COLORS 0, 16777215 PIXEL
    @ 040, 070 MSGET oGetDtAgend VAR dGetDtAgend PICTURE PesqPict("SC6","C6_ENTREG") SIZE 056, 010 OF oDlg  VALID vldDate(dGetDtAgend) COLORS 0, 16777215 PIXEL
    @ 040, 136 BUTTON oBtnAgendar PROMPT "Agendar" SIZE 047, 012 OF oDlgItem PIXEL

    oBtnAgendar:BLCLICKED:= {|| lGrava := .T. , oDlgItem:End()  }
	    
    @ 057, 003 GROUP oGroup2 TO 126, 192 PROMPT " Informa��es do Cliente - " + cNomeCli OF oDlgItem COLOR 0, 16777215 PIXEL
    @ 064, 010 SAY oSayRua PROMPT "Rua:" SIZE 015, 007 OF oDlgItem COLORS 0, 16777215 PIXEL
    @ 065, 024 SAY oGetRua PROMPT cRua SIZE 162, 007 OF oDlgItem COLORS 0, 16777215 PIXEL
    @ 072, 010 SAY oSayBairro PROMPT "Bairro:" SIZE 018, 007 OF oDlgItem COLORS 0, 16777215 PIXEL
    @ 072, 027 SAY oGetBairro PROMPT cBairro SIZE 089, 007 OF oDlgItem COLORS 0, 16777215 PIXEL
    @ 079, 010 SAY oSayCidade PROMPT "Cidade:" SIZE 021, 007 OF oDlgItem COLORS 0, 16777215 PIXEL
    @ 080, 030 SAY oGetCidade PROMPT cCidade SIZE 055, 007 OF oDlgItem COLORS 0, 16777215 PIXEL
    @ 086, 010 SAY oSayEstado PROMPT "Estado:" SIZE 021, 007 OF oDlgItem COLORS 0, 16777215 PIXEL
    @ 086, 030 SAY oGetEstado PROMPT cEstado SIZE 015, 007 OF oDlgItem COLORS 0, 16777215 PIXEL
    @ 094, 010 SAY oSayCep PROMPT "CEP:" SIZE 014, 007 OF oDlgItem COLORS 0, 16777215 PIXEL
    @ 094, 024 SAY oSay12 PROMPT cCep SIZE 035, 007 OF oDlgItem COLORS 0, 16777215 PIXEL
    @ 102, 010 SAY oTelefone1 PROMPT "Telefone 1:" SIZE 030, 007 OF oDlgItem COLORS 0, 16777215 PIXEL
    @ 102, 039 SAY oGetTel1 PROMPT cDDD + cTel1 SIZE 060, 007 OF oDlgItem COLORS 0, 16777215 PIXEL
    @ 110, 010 SAY oTelefone2 PROMPT "Telefone 2:" SIZE 030, 007 OF oGroup2 COLORS 0, 16777215 PIXEL
    @ 110, 039 SAY oGetTel2 PROMPT cDDD + cTel2 SIZE 060, 007 OF oDlgItem COLORS 0, 16777215 PIXEL
    @ 118, 010 SAY oTelefone3 PROMPT "Telefone 3:" SIZE 030, 007 OF oGroup2 COLORS 0, 16777215 PIXEL
    @ 118, 039 SAY oGetTel3 PROMPT cDDD + cTel3 SIZE 060, 007 OF oGroup2 COLORS 0, 16777215 PIXEL
    
    @ 110, 124 BUTTON oBtnAltCli PROMPT "Alterar dados do Cliente" SIZE 064, 012 OF oDlg PIXEL
	oBtnAltCli:BLCLICKED:= {|| AxAltera("SA1",SA1->(Recno()),4,,aCpos) }    
	
	@ 128, 003 GROUP oGroup3 TO 174, 192 PROMPT " Observa��es do Pedido de venda " OF oDlgItem COLOR 0, 16777215 PIXEL
	@ 136, 006 GET oMsgPed VAR cMsgObsPed MEMO SIZE 182, 037 PIXEL OF oDlgItem
	
    @ 176, 003 GROUP oGroup4 TO 243, 192 PROMPT " Observa��es de Entrega " OF oDlgItem COLOR 0, 16777215 PIXEL
	@ 184, 006 GET oMsgEnt VAR cMsgObsEnt MEMO SIZE 182, 057 PIXEL OF oDlgItem
	
	//Restri��o de entrega
	@ 246, 003 GROUP oGroup5 TO 270, 192 PROMPT " Restri��o de Entrega " OF oDlgItem COLOR 0, 16777215 PIXEL
	@ 253, 006 GET oRegCon VAR cRegCon SIZE 182, 010 PIXEL OF oDlgItem
	
	//Bot�o Sair
    @ 280, 004 BUTTON oBtnSair PROMPT "Sair" SIZE 187, 016 OF oDlg ACTION {|| oDlgItem:End() } PIXEL	
	
    
	ACTIVATE MSDIALOG oDlgItem CENTERED
	
	If Empty(cRegCon)
			MsgAlert('Campo restri��o de entrega vazio. Agendamento n�o efetuado.' ,'Aten��o')
			Return
	EndIf	

	if lGrava
		
		DbSelectArea("SC6")
		DbSetOrder(1)
		DbSeek(xFilial("SC6") + cPedido + cItem + cCodigo)

		if empty(alltrim(SC6->C6_NOTA))
			
			//Verifico se o item ja esta liberado
			if SC6->C6_QTDEMP < 0
				RecLock("SC6",.F.)
					SC6->C6_QTDEMP := 0	
				MsUnlock()
	        endif
							
			//Verifico se o item ja esta liberado
			if SC6->C6_QTDEMP > 0 .and. oGridIt:acols[oGridIt:nat][nPItemLib] == "SIM"

				fAtuMsg(aCols,@cMsgObsPed,@cMsgObsEnt)

				RecLock("SC6",.F.)
					SC6->C6_ENTREG  := dGetDtAgend
					SC6->C6_DTAGEND := dDataBase
					SC6->C6_XUSRAGE := cUserName
					SC6->C6_01AGEND := "1"
				MsUnlock()
			
				oGridIt:acols[oGridIt:nat][nPStatusIt] := oSt1 //Agendado 1=SIM,2=NAO;
				oGridIt:acols[oGridIt:nat][nPEntrega] := dGetDtAgend
				oGridIt:acols[oGridIt:nat][nPUsrAgend] := cUserName
				
				dDataAgTerm := dGetDtAgend
		
			else 
				cEndereco := u_getEnd(SC6->C6_PRODUTO, SC6->C6_LOCAL, SC6->C6_QTDVEN, @cUsados, @nSaldo)
								
				//Libera o pedido de venda e Cria a reserva no SB2_RESERVA
				lRet := u_LibEst(SC6->C6_NUM,SC6->C6_ITEM,SC6->C6_PRODUTO,SC6->C6_QTDVEN,nSaldo)
	        endif
			
			if lRet 
				
				fAtuMsg(aCols,@cMsgObsPed,@cMsgObsEnt)

				RecLock("SC6",.F.)
					SC6->C6_ENTREG  := dGetDtAgend
					SC6->C6_DTAGEND := dDataBase
					SC6->C6_01AGEND := "1"
					SC6->C6_XUSRAGE := cUserName
					SC6->C6_LOCALIZ := cEndereco
				MsUnlock()
	
				oGridIt:acols[oGridIt:nat][nPDescriIt] := oSt1 //Agendado 1=SIM,2=NAO;
				oGridIt:acols[oGridIt:nat][nPEntrega] := dGetDtAgend
				oGridIt:acols[oGridIt:nat][nPUsrAgend] := cUserName
								                   
				U_SYTMOV15(aCols[nPPedido], cItem, cCodigo,"3")
				
				dDataAgTerm := dGetDtAgend
				AlterDtAgend()
				
			endif
			
			fRetStatus(oGridPed:nat,oGridPed:acols[oGridPed:nat][nPPedido])
				
			fCarrIt(oGridPed:acols[oGridPed:nat][nPPedido],oGridPed:acols[oGridPed:nat][3],oGridPed:acols[oGridPed:nat][4])
			oGridIt:ForceRefresh()
			
			//------------------------------------------------------------------
			DbSelectArea("SC5")
			SC5->(DbSetOrder(1))
			If SC5->( dbSeek( xFilial("SC5") + cPedido ) )//Filial + Pedido
				RecLock("SC5", .F.)
					 SC5->C5_XREGCON := Alltrim(cRegCon)
				MsUnlock()
			EndIf
			SC5->(dbCloseArea())		
			//-------------------------------------------------------------------
		
		endif
	endif

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fViewTerRe
Description                                                     

@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 16/07/2018
/*/
//--------------------------------------------------------------
Static Function fViewTerRe(_cAtend, aTermos)
	
	Local cAtend := _cAtend
	Local oButton1
	Local oButton2
	Local oSay1
	Local oText
	
	Static oDlg1

	DEFINE MSDIALOG oDlg1 TITLE "Termos Retira" FROM 000, 000  TO 500, 500 COLORS 0, 16777215 PIXEL

    @ 008, 006 SAY oSay1 PROMPT "Atendimento:" SIZE 030, 007 OF oDlg1 COLORS 16711680, 16777215 PIXEL
    @ 006, 040 MSGET cAtend VAR cAtend SIZE 062, 010 OF oDlg1 COLORS 0, 16777215 PIXEL
    @ 006, 193 BUTTON oButton2 PROMPT "Sair" SIZE 051, 013 OF oDlg1 ACTION {|| oDlg1:end() } PIXEL

	if len(aTermos) > 0 
		fSelectTer(aTermos)
    else
		Return
	endif
	
	@ 024, 004 SAY oText PROMPT "Selecione os Termos Retira que ser�o agendados e procione o bot�o (Gravar Itens)." SIZE 150, 014 OF oDlg1 COLORS 255, 15658734 PIXEL
    @ 022, 193 BUTTON oButton1 PROMPT "Gravar Itens" SIZE 051, 013 OF oDlg1 ACTION {|| 	fGravaTerm(), oDlg1:end() } PIXEL

	ACTIVATE MSDIALOG oDlg1 CENTERED

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fGravaTerm
Description                                                     

@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 16/07/2018
/*/
//--------------------------------------------------------------
Static Function fGravaTerm()
	
	Local nPFlag := Ascan(oMSNew1:aHeader,{|x|AllTrim(x[2])=="FLAG"}) 
	Local nPCod := Ascan(oMSNew1:aHeader,{|x|AllTrim(x[2])=="ZK0_COD"})
	Local nPProd := Ascan(oMSNew1:aHeader,{|x|AllTrim(x[2])=="ZK0_PROD"})
	Local nPDescri := Ascan(oMSNew1:aHeader,{|x|AllTrim(x[2])=="ZK0_DESCRI"})
	
	aTermAgend := {}
		
	for nx := 1 to len(oMSNew1:aCols)
		if oMSNew1:aCols[nx,nPFlag] == "LBTIK"
			aAdd(aTermAgend,{oMSNew1:aCols[nx,nPCod],oMSNew1:aCols[nx,nPProd],oMSNew1:aCols[nx,nPDescri]})	
		endif
	next nx
	
Return

//--------------------------------------------------------------
/*/{Protheus.doc} fSelectTer
Description                                                     

@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 16/07/2018
/*/
//--------------------------------------------------------------
Static Function fSelectTer(aTermos)

	Local nX
	Local aHeader := {}
	Local aCols := {}
	Local aFields := {"ZK0_COD","ZK0_PROD","ZK0_DESCRI","ZK0_NUMSAC","ZK0_CLI","ZK0_LJCLI","ZK0_DTAGEN","ZK0_STATUS","ZK0_CARGA"}
	Local aAlterFields := {}

	Static oMSNew1

	Aadd(aHeader,{"","FLAG","@BMP",1,0,"","��������������","C","","R","","","","V","","",""})
	  
	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	For nX := 1 to Len(aFields)
		If SX3->(DbSeek(aFields[nX]))
			Aadd(aHeader, {AllTrim(X3Titulo()),;
								SX3->X3_CAMPO,;
								SX3->X3_PICTURE,;
								SX3->X3_TAMANHO,;
								SX3->X3_DECIMAL,;
								SX3->X3_VALID,;
								SX3->X3_USADO,;
								SX3->X3_TIPO,;
								SX3->X3_F3,;
								SX3->X3_CONTEXT,;
								SX3->X3_CBOX,;
								SX3->X3_RELACAO})
		Endif
	Next nX

	For nX := 1 to Len(aTermos)
		
		Aadd(aCols,{;
					"LBNO",;
					aTermos[nX][1],;
					aTermos[nX][2],;
					aTermos[nX][3],;
					aTermos[nX][4],;
					aTermos[nX][5],;
					aTermos[nX][6],; 
					aTermos[nX][7],;
					aTermos[nX][8],;
					aTermos[nX][9],;
					iif(aTermos[nX][8] == '3',.T.,.F.)})
		
	Next nX

	oMSNew1 := MsNewGetDados():New( 040, 003, 238, 246, , "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg1, aHeader, aCols)
	
	oMSNew1:oBrowse:bLDblClick := {|| fMarcOne(oMSNew1:nat) }
	
Return


//--------------------------------------------------------------
/*/{Protheus.doc} fMarcOne
Description                                                     

@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 16/07/2018
/*/
//--------------------------------------------------------------
//fMarcOne: Marca o checkbox da linha posicionada
Static Function fMarcOne(nLin) 

	Local nPFlag := Ascan(oMSNew1:aHeader,{|x|AllTrim(x[2])=="FLAG"})
	Local nPStatus := Ascan(oMSNew1:aHeader,{|x|AllTrim(x[2])=="ZK0_STATUS"})
	
	if oMSNew1:aCols[nLin,nPStatus] == "3"
		MsgAlert("Este termo ja foi Finalizado.","ATEN��O !!")
	else
		if oMSNew1:aCols[nLin,nPFlag] == "LBTIK"
			oMSNew1:aCols[nLin,nPFlag] := "LBNO"
		else
			oMSNew1:aCols[nLin,nPFlag] := "LBTIK"
		endif
	endif
	
	oMSNew1:Refresh()
	
Return

Static Function fRetStatus(nLinhaP,cPedidoP)
    
	dbSelectArea("SC5")
	SC5->(dbSetOrder(1))
	SC5->(dbGoTop())
	
	if SC5->(dbSeek(xFilial("SC5")+cPedidoP))
		if Empty(SC5->C5_LIBEROK) .And. Empty(SC5->C5_NOTA) .And. Empty(SC5->C5_BLQ) .And. SC5->C5_STATENT == ' ' .and. SC5->C5_PEDPEND <> '2'
			oStatusP := oSt1
		elseif !Empty(SC5->C5_NOTA) .or. SC5->C5_LIBEROK=='E' .And. Empty(SC5->C5_BLQ) .And. SC5->C5_STATENT == ' ' 
			oStatusP := oSt2		
		//elseif SC5->C5_PEDPEND == '2'
		//	oStatusP := oSt4
		//elseif SC5->C5_XLIBER == 'B'
		//	oStatus := oSt6		
		elseif !Empty(SC5->C5_LIBEROK) .And. Empty(SC5->C5_NOTA) .And. Empty(SC5->C5_BLQ) .And. SC5->C5_STATENT == ' '
			oStatusP := oSt5
		endif
		
		if SC5->C5_PEDPEND == '2'
			oStatusP := oSt4
		endif
		
		if SC5->C5_XLIBER == 'B'
			oStatusP := oSt6		
		endif
		
		oGridPed:acols[nLinhaP][nPStatus] := oStatusP
		oGridPed:refresh()
	endif

Return
                                                            
Static Function zLegenda()
    
    Local aLegenda := {}
     
    //Monta as legendas (Cor, Legenda)
    aAdd(aLegenda,{"BR_AMARELO",    "Pedido Liberado"})
    aAdd(aLegenda,{"BR_VERDE",      "Pedido em Aberto"})
    aAdd(aLegenda,{"BR_VERMELHO",   "Pedido Finalizado"})
    aAdd(aLegenda,{"BR_VIOLETA",  	"Pedido C/ Pendencia Financeira"})
    aAdd(aLegenda,{"BR_PRETO",     	"Bloqueio de Desconto"})
     
    //Chama a fun��o que monta a tela de legenda
    BrwLegenda("STATUS PEDIDO", "Status Pedido", aLegenda) 
    
Return                                

//--------------------------------------------------------------
/*/{Protheus.doc} fTerRet
Description                                                     
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 16/07/2018
/*/
//--------------------------------------------------------------

Static Function fTerRet(_cAtend, aTermos)

	Local cAtend := _cAtend
	Local oSay1
	Static oDlg

	DEFINE MSDIALOG oDlg TITLE "Rela��o de Termos Retira" FROM 000, 000  TO 500, 500 COLORS 0, 16777215 PIXEL

		@ 009, 008 SAY oSay1 PROMPT "Atendimento:" SIZE 030, 007 OF oDlg COLORS 16711680, 16777215 PIXEL
		@ 008, 050 MSGET cAtend VAR cAtend SIZE 062, 010 OF oDlg COLORS 0, 16777215 PIXEL
		
		if len(aTermos) > 0                                                       
			fNewTerRet(aTermos)
        else
			msgAlert("N�o existe termo retira para esse Pedido.","ATEN��O..")
			Return
        endif
        
	ACTIVATE MSDIALOG oDlg CENTERED

Return


//--------------------------------------------------------------
/*/{Protheus.doc} fNewTerRet
Description                                                     

@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 16/07/2018
/*/
//--------------------------------------------------------------

Static Function fNewTerRet(aTermos)

	Local nX
	Local aHeader := {}
	Local aCols := {}
	Local aFieldFill := {}
	Local aFields := {"ZK0_COD","ZK0_PROD","ZK0_DESCRI","ZK0_NUMSAC","ZK0_CLI","ZK0_LJCLI","ZK0_DTAGEN","ZK0_STATUS","ZK0_CARGA"}
	Local aAlterFields := {}
	Static oMSTerRet

	  // Define field properties
	  DbSelectArea("SX3")
	  SX3->(DbSetOrder(2))
	  For nX := 1 to Len(aFields)
		If SX3->(DbSeek(aFields[nX]))
		  Aadd(aHeader, {AllTrim(X3Titulo()),;
		  					SX3->X3_CAMPO,;
		  					SX3->X3_PICTURE,;
		  					SX3->X3_TAMANHO,;
		  					SX3->X3_DECIMAL,;
		  					SX3->X3_VALID,;
						   	SX3->X3_USADO,;
						   	SX3->X3_TIPO,;
						   	SX3->X3_F3,;
						   	SX3->X3_CONTEXT,;
						   	SX3->X3_CBOX,;
						   	SX3->X3_RELACAO})
		Endif
	  Next nX

	  // Define field values
	  For nX := 1 to Len(aTermos)
		
		  Aadd(aCols,{;
						aTermos[nX][1],;
						aTermos[nX][2],;
						aTermos[nX][3],;
						aTermos[nX][4],;
						aTermos[nX][5],;
						aTermos[nX][6],; 
						aTermos[nX][7],; 
						aTermos[nX][8],;
						aTermos[nX][9],;
						.F.})
		
	  Next nX
	  
	  oMSTerRet := MsNewGetDados():New( 021, 003, 245, 245, , "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg, aHeader, aCols)

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fConhece
Description //Banco de conhecimento
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 28/09/2018
/*/
//--------------------------------------------------------------
Static Function fConhece(_cCli, _cLoja)
    
    Local aArea := getArea()
    Local cAlias := "SA1"
    Local lExcelConnect := .F.
	Local aRecACB := {}
	Local nOper := 1
	Local nOpc := 4
	
	Private aRotina := {}
	
	dbSelectArea("SA1")
	SA1->(dbSetOrder(1))
	
	SA1->(dbSeek(xFilial()+_cCli+_cLoja))
    
    for nx := 1 to 4
		Aadd(aRotina,{"Conhecimento","MsDocument('SA1',SA1->(RecNo()), 4)", 0, 4,0,NIL})
	next nx
		
	MsDocument( cAlias, SA1->(RecNo()), nOpc, , nOper, aRecACB , lExcelConnect)	
                
	restArea(aArea)
	
Return

//--------------------------------------------------------------
/*/{Protheus.doc} ViewObserv
Description //Tela de consulta da observa��es (observa��es do pedido) e (observa��es do Entrega)
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 28/09/2018
/*/
//--------------------------------------------------------------
Static Function ViewObserv(aCols)
	
	Local oBtnSair
	Local oGroup1
	Local oGroup2
	
	Local oMsgPed
	Local cMsgObsPed := ""
	Local oMsgEnt
	Local cMsgObsEnt := ""
	Local lGrava := .F.

	Local oDlgView
    
	dbSelectArea("SUA")
	dbSetOrder(8)
    
	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))

	if SUA->(dbseek(aCols[nPMsFil]+aCols[nPPedido]))
		cMsgObsPed := MSMM(SUA->UA_CODOBS,TamSx3("UA_OBS")[1],,,3)
	else
		if SC5->(DbSeek(xFilial("SC5") + aCols[nPPedido]))
			cMsgObsPed := MSMM(SC5->C5_XCODOBS,TamSx3("C5_XCODOBS")[1],,,3)
		else
			cMsgObsPed := ""
		endif
	endif
	 
	SC5->(DbSeek(xFilial("SC5") + aCols[nPPedido]))
	
	cMsgObsEnt := MSMM(SC5->C5_XOBSENT,TamSx3("C5_XCODOBS")[1],,,3)
	
	cMsgUser :=  cUserName + ' - ' + dtoc(date()) + ' - ' + time() + ENTER
	cMsgUser += replicate('-',60) + ENTER

	if empty(alltrim(cMsgObsEnt))
		cMsgObsEnt := cMsgUser + cMsgObsEnt  
	else
		cMsgObsEnt := cMsgObsEnt + ENTER + cMsgUser
	endif
	
	DEFINE MSDIALOG oDlgView TITLE "Observa��es do Pedido " + aCols[nPPedido] FROM 000, 000  TO 500, 390 COLORS 0, 16777215 PIXEL
	
		@ 003, 002 GROUP oGroup1 TO 108, 192 PROMPT " Observa��es do Pedido " OF oDlgView COLOR 0, 16777215 PIXEL
    	@ 011, 006 GET oMsgPed VAR cMsgObsPed MEMO SIZE 182, 95 PIXEL OF oDlgView	    
    	
	    @ 112, 003 GROUP oGroup2 TO 230, 192 PROMPT " Observa��es de Entrega " OF oDlgView COLOR 0, 16777215 PIXEL
		@ 120, 006 GET oMsgEnt VAR cMsgObsEnt MEMO SIZE 182, 105 PIXEL OF oDlgView
		    
	    @ 232, 003 BUTTON oBtnSair PROMPT "Salvar" SIZE 188, 014 OF oDlgView ACTION {|| lGrava := .T., oDlgView:end() } PIXEL
	
	ACTIVATE MSDIALOG oDlgView CENTERED

	if lGrava
		MSMM(,TamSx3("C5_XCODOBS")[1],,cMsgObsEnt,1,,,"SC5","C5_XOBSENT")
	endif

Return 

//--------------------------------------------------------------
/*/{Protheus.doc} SetCab1
Description //seta o pedido posicionado no cabe�alho
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 28/09/2018
/*/
//--------------------------------------------------------------
Static Function SetCab1(cParam1)
	
	if !(empty(cParam1))
		cCab :="Pedido: " + Alltrim(cParam1)
		oLayer:setWinTitle('Col03' ,'C3_Win03',cCab ,"L02" )
	endif

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fGetMsg
Description //carrega as observa��es do pedido de venda
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 28/09/2018
/*/
//--------------------------------------------------------------
Static Function fGetMsg(acols,cMsgObsPed,cMsgObsEnt)

	Local aArea := getArea()

	dbSelectArea("SUA")
	dbSetOrder(8)
    
	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))

	if SUA->(dbseek(aCols[nPMsFil]+aCols[nPPedido]))
		cMsgObsPed := MSMM(SUA->UA_CODOBS,TamSx3("UA_OBS")[1],,,3)
	else
		if SC5->(DbSeek(xFilial("SC5") + aCols[nPPedido]))
			cMsgObsPed := MSMM(SC5->C5_XCODOBS,TamSx3("C5_XCODOBS")[1],,,3)
		else
			cMsgObsPed := ""
		endif
	endif
	
	SC5->(DbSeek(xFilial("SC5") + aCols[nPPedido]))
	cMsgObsEnt := MSMM(SC5->C5_XOBSENT,TamSx3("C5_XCODOBS")[1],,,3)
	
	cMsgUser :=  cUserName + ' - ' + dtoc(date()) + ' - ' + time() + ENTER
	cMsgUser += replicate('-',60) + ENTER

	if empty(alltrim(cMsgObsEnt))
		cMsgObsEnt := cMsgUser + cMsgObsEnt  
	else
		cMsgObsEnt := cMsgObsEnt + ENTER + ENTER + cMsgUser
	endif

	restArea(aArea)

Return 

	
//--------------------------------------------------------------
/*/{Protheus.doc} fAtuMsg
Description //Atualiza as observa��es do pedido de venda e observa��es de entrega
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 28/09/2018
/*/
//--------------------------------------------------------------
Static Function fAtuMsg(aCols,cMsgObsPed,cMsgObsEnt)

	Local aArea := getArea()
	Local cTerRet := ""

	DBSELECTAREA("SUA")
	SUA->(DBSETORDER(8))
		
	if SUA->(DBSEEK(aCols[nPMsFil]+aCols[nPPedido]))
		MSMM(,TamSx3("UA_CODOBS")[1],,cMsgObsPed,1,,,"SUA","UA_CODOBS")
	endif
		
	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))

	if SC5->(DbSeek(xFilial("SC5") + aCols[nPPedido]))
		MSMM(,TamSx3("C5_XCODOBS")[1],,cMsgObsPed,1,,,"SC5","C5_XCODOBS")
			
		if len(aTermAgend) > 0
			cTerRet := ENTER +ENTER + "**OBSERVA��O: TERMO RETIRA N�:"+aTermAgend[1][1]+" - RETIRAR OS ITENS ABAIXO NO CLIENTE;" + ENTER
			
			for nx := 1 to len(aTermAgend)
				cTerRet += cValToChar(nx) +"-PRODUTO: "+ aTermAgend[nx][2] + ENTER 
				cTerRet += cValToChar(nx) +"-DESCRI��O: "+ aTermAgend[nx][3] + ENTER 
			next

			MSMM(,TamSx3("C5_XCODOBS")[1],,cMsgObsEnt+cTerRet,1,,,"SC5","C5_XOBSENT")
		else
			MSMM(,TamSx3("C5_XCODOBS")[1],,cMsgObsEnt,1,,,"SC5","C5_XOBSENT")
		endif

	endif

	restArea(aArea)

Return 

//--------------------------------------------------------------
/*/{Protheus.doc} fBloqAgend
Description //Tela de bloqueio do agendamento
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 02/10/2018
/*/
//--------------------------------------------------------------

Static Function fBloqAgend()

	Local lSalvar		:= .F.
	Local lSair			:= .F.

	private oBtnExcluir
	private oBtnIncluir
	private oBtnSair
	private oGroup1
	private oGroup2
	private oSay1
	private cSay1 := "Informe a data do bloqueio"
	private cTitle := "Bloqueio de agendamento Komfort House"
	private cUserBlq := superGetMv("KH_USBLQAG", .T., "000000", )
	
	Private oDataBlq
	Private dDataBlq := ctod('//')
	Private oWBrowse
	Private aWBrowse := {}
	
	Static oDlgBlq

	If !__cUserId $ cUserBlq
		return(apMsgAlert("Usuario sem permiss�o para utilizar esse recurso!!!","WARNING"))
	EndIf

	DEFINE MSDIALOG oDlgBlq TITLE cTitle FROM 000, 000  TO 500, 350 COLORS 0, 16777215 PIXEL STYLE 128

		@ 003, 003 GROUP oGroup1 TO 039, 172 OF oDlgBlq COLOR 0, 16777215 PIXEL
		@ 011, 008 SAY oSay1 PROMPT cSay1 SIZE 069, 007 OF oDlgBlq COLORS 32768, 16777215 PIXEL
		@ 010, 075 MSGET oDataBlq VAR dDataBlq SIZE 049, 010 OF oDlgBlq VALID {|| } COLORS 0, 16777215 PIXEL
		@ 009, 129 BUTTON oBtnIncluir PROMPT "Incluir" SIZE 037, 012 OF oDlgBlq ACTION { || lSalvar	:= fSalvar(dDataBlq, 1) } PIXEL
		@ 024, 129 BUTTON oBtnExcluir PROMPT "Excluir" SIZE 037, 012 OF oDlgBlq ACTION {|| lSalvar	:= fSalvar(dDataBlq, 2) } PIXEL
		@ 043, 003 GROUP oGroup2 TO 226, 171 PROMPT " Datas Bloqueadas para o agendamento " OF oDlgBlq COLOR 0, 16777215 PIXEL
		@ 229, 121 BUTTON oBtnSair PROMPT "Sair" SIZE 049, 018 OF oDlgBlq ACTION {|| lSair := .T. , oDlgBlq:end() } PIXEL
		
		If (lSalvar)
			
			oDlgBlq:end()
			
		EndIf
			
		If !(lSair)
		
			fWBrow()			
		
		EndIf

	ACTIVATE MSDIALOG oDlgBlq CENTERED

Return

//--------------------------------------------------------------
/*/{Protheus.doc} NomeDaFuncao
Description //Descri��o da Fun��o
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since dd/mm/aaaa /*/
//--------------------------------------------------------------
Static Function fWBrow()

	dbSelectArea("ZK7")
	ZK7->(dbSetOrder(1))
	ZK7->(DbGoTop())
	
	while ZK7->(!eof()) 
		if ZK7->ZK7_DTBLQ >= dDataBase
			aAdd(aWBrowse,{ZK7->ZK7_DTBLQ, fQtdAgend(ZK7->ZK7_DTBLQ) })
		endif
	ZK7->(DbSkip())
	end
			
	if len(aWBrowse) == 0
		aAdd(aWBrowse,{ctod('//'), 0 })
	endif
    
    oWBrowse := TwBrowse():New(051, 006, 160, 169,, {"Data","Pedidos agendados"},,oDlgBlq,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
	
	oWBrowse:SetArray(aWBrowse)

    oWBrowse:bLine := {|| { aWBrowse[oWBrowse:nAt,01] ,; 
                            aWBrowse[oWBrowse:nAt,02] ;
						}}
    
    oWBrowse:Refresh()

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fSalvar
Description //Atualiza a data de bloqueio do agendamento
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 02/10/2018
/*/
//--------------------------------------------------------------
Static Function fSalvar(dDataBlq, nOpc) //nOpc --> 1=Incluir, 2=Excluir
	
	Local cPara := superGetMv("KH_MAILBLQ", .T., "sac@komforthouse.com.br;lojas@komforthouse.com.br", )
	Local cAssunto := "Periodos Bloqueados para agendamentos"
	Local cMensagem := ""
	Local Ablqs := {}
	
	dbSelectArea("ZK7")
	ZK7->(dbSetOrder(1))

	if nOpc == 1 //Enclus�o

		if dDataBlq < dDataBase
			return(apMsgAlert("N�o � permitido informar data menor que data base!","WARNING"))
		endif

		if ZK7->(dbSeek(xFilial()+dtos(dDataBlq)))
			return(apMsgAlert("Data Informada ja existe!","WARNING"))
		else

			RecLock("ZK7",.T.)
				ZK7->ZK7_DTBLQ := dDataBlq
			ZK7->(msUnLock())

			ZK7->(dbgotop())
			while ZK7->(!eof()) 
				if ZK7->ZK7_DTBLQ >= dDataBase
					aAdd(Ablqs,{ZK7->ZK7_DTBLQ, fQtdAgend(ZK7->ZK7_DTBLQ) })
				endif
			ZK7->(DbSkip())
			end
			
			if len(Ablqs) == 0
				aAdd(Ablqs,{ctod('//'), 0 })
			endif

			oWBrowse:SetArray(Ablqs)
			oWBrowse:bLine := {|| { Ablqs[oWBrowse:nAt,01] ,; 
                            		Ablqs[oWBrowse:nAt,02] ;
								}}
			oWBrowse:Refresh() //Atualiza grid com as datas de bloqueio 
			
		endif

	else // Exclus�o  

		ZK7->(dbgotop())
		if ZK7->(dbSeek(xFilial()+dtos(dDataBlq)))
			RecLock("ZK7",.F.)
				ZK7->(dbDelete())
			ZK7->(msUnLock())
		else
			return(apMsgAlert("Data Informada n�o existe para exclus�o!","WARNING"))
		endif

		ZK7->(dbgotop())
		while ZK7->(!eof()) 
			if ZK7->ZK7_DTBLQ >= dDataBase
				aAdd(Ablqs,{ZK7->ZK7_DTBLQ, fQtdAgend(ZK7->ZK7_DTBLQ) })
			endif
		ZK7->(DbSkip())
		end
		
		if len(Ablqs) == 0
			aAdd(Ablqs,{ctod('//'), 0 })
		endif

		oWBrowse:SetArray(Ablqs)
		oWBrowse:bLine := {|| { Ablqs[oWBrowse:nAt,01] ,; 
                            	Ablqs[oWBrowse:nAt,02] ;
							}}
		oWBrowse:Refresh() //Atualiza grid com as datas de bloqueio 

	endif
	
	dDataBlq := ctod('//')
	oDataBlq:refresh()

	//--------------------------------------------------------
	cMensagem += "Aten��o,"+ ENTER
	cMensagem += "O Agendamento ja encontra-se encerrado para o dias: "+ ENTER
	
	for nx := 1 to len(Ablqs)
		cMensagem += dtoc(Ablqs[nx][1]) + ENTER
	next nx

	cMensagem += "Para novos agendamentos utilizar datas diferentes das informadas acima"+"."+ ENTER+ ENTER
	cMensagem += "Atenciosamente"+ ENTER
	cMensagem += "Isaias Gomes"+ ENTER
	cMensagem += "Coordenador de Sac"+ ENTER+ ENTER
	cMensagem += "Isaias.gomes@komforthouse.com.br"+ ENTER

	processa( {|| U_sendMail( cPara, cAssunto, cMensagem ) }, "Aguarde...", "Enviando email de bloqueio do agendamento...", .F.)

Return .T.

//--------------------------------------------------------------
/*/{Protheus.doc} NomeDaFuncao
Description //Descri��o da Fun��o
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since dd/mm/aaaa /*/
//--------------------------------------------------------------
Static Function fQtdAgend(cDataBlq)

	Local cALias := getNextAlias()
	Local cQuery := ""
	Local nQtd := 0

	default cDataBlq := ctod('//')
	
	cQuery := "SELECT SUM(C6_QTDVEN) QTDE FROM "+ retSqlName("SC6") +"(NOLOCK) SC6"
	cQuery += " INNER JOIN "+ retSqlName("SC5")+ "(NOLOCK) SC5 ON SC5.C5_FILIAL = SC6.C6_FILIAL "
	cQuery += " AND SC5.C5_MSFIL = SC6.C6_MSFIL "
	cQuery += " AND SC5.C5_NUM = SC6.C6_NUM "
	cQuery += " AND SC5.C5_CLIENTE = SC6.C6_CLI "
	cQuery += " AND SC5.C5_LOJACLI = SC6.C6_LOJA "
	cQuery += " AND SC5.D_E_L_E_T_ = ' ' "
	cQuery += " INNER JOIN "+ retSqlName("SB1") +" SB1 ON SB1.B1_COD = SC6.C6_PRODUTO "
	cQuery += " AND SB1.B1_XACESSO <> '1' "
	cQuery += " AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE SC6.C6_FILIAL <> ' ' " 
	cQuery += " AND SC6.C6_ENTREG = '"+ dtos(cDataBlq) +"' "
	cQuery += " AND SC6.C6_01AGEND = '1' "
	cQuery += " AND SC6.C6_BLQ <> 'R' "                      
	cQuery += " AND SC6.D_E_L_E_T_ = ' ' "

	PLSQuery(cQuery, cAlias)
  
	if (cAlias)->(!eof())
		nQtd := (cALias)->QTDE
	endif

	(cAlias)->(dbCloseArea())

return nQtd

//--------------------------------------------------------------
/*/{Protheus.doc} RelExcel
Description //extrai os pedidos filtrados no browser
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 02/10/2018
/*/
//--------------------------------------------------------------
Static Function RelExcel(aCab, aItens, cTitle)

	Local oExcel := FWMsExcel():New()
    Local cArqTemp := GetTempPath() + ProcName()+'.XLS'     
	
	cNamePlan := cNameTable := cTitle

	oExcel:AddworkSheet(cNamePlan)
	oExcel:AddTable (cNamePlan,cNameTable)
	
	//Colunas do Excel ----------------------------------------
	for nx := 2 to Len(aCab)
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
	   										aItens[nx][nPPedido],;
	   										aItens[nx][nPCliente],;
	   										aItens[nx][nPLojaCli],;
	   										aItens[nx][nPNome],;
	   										aItens[nx][nPEmissao],;
	   										aItens[nx][nPMsFil],;
	   										aItens[nx][nPDescFi],;
	   										aItens[nx][nPTroca],;
	   										aItens[nx][nPCep],;
	   										aItens[nx][nPVendedor],;
	   										aItens[nx][nPValor],;
											aItens[nx][nPEmail],;
											aItens[nx][nPQtdEmail],;
	   										},{1,2,3,4,5,6,7,8,9,10,11})
	next nx
    
	oExcel:Activate()
	oExcel:GetXMLFile(cArqTemp)
	ShellExecute("open",  cArqTemp, "", "C:\", 1 )
	
Return

//--------------------------------------------------------------
/*/{Protheus.doc} RelExcelAg
Description //extrai o total de pedidos agendados por Filial
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 02/10/2018
/*/
//--------------------------------------------------------------
Static Function RelExcelAg(aCab, aItens, cTitle)

	Local oExcel := FWMsExcel():New()
    Local cArqTemp := GetTempPath() + ProcName()+'.XLS'     
	
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
	   										aItens[nx][1],;
											aItens[nx][2],;
	   										aItens[nx][3],;
	   										aItens[nx][4],;
	   										aItens[nx][5];
	   										},{1,2,3,4,5})
	next nx
    
	oExcel:Activate()
	oExcel:GetXMLFile(cArqTemp)
	ShellExecute("open",  cArqTemp, "", "C:\", 1 )
	
Return

//--------------------------------------------------------------
/*/{Protheus.doc} RelExAgIt
Description //extrai o total de pedidos agendados por Data
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 02/10/2018
/*/
//--------------------------------------------------------------
Static Function RelExAgIt(aCab, aItens, cTitle)

	Local oExcel := FWMsExcel():New()
    Local cArqTemp := GetTempPath() + ProcName()+'.XLS'     
	
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
	   										aItens[nx][1],;
											stod(aItens[nx][2]) ,;
											aItens[nx][3],;
											aItens[nx][4];
											},{1,2,3,4})
	next nx
    
	oExcel:Activate()
	oExcel:GetXMLFile(cArqTemp)
	ShellExecute("open",  cArqTemp, "", "C:\", 1 )
	
Return


//--------------------------------------------------------------
/*/{Protheus.doc} fExcelIt
Description //Utiliza os pedidos filtrados para trazer as informa��es referente aos produtos
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul
@since 11/02/2020
/*/
//--------------------------------------------------------------
Static Function fExcelIt()

	Local oExcel := FWMsExcel():New()
    Local cArqTemp := GetTempPath() + ProcName()+'.XLS'
    local _cQuery := ""   
    local aItPed := {}
    local cAliEm := GetNextAlias()
    Local cTitle := "Relatorio itens tela de Agendamento"
    LOcal aCab:= {}
   
	_cQuery := " SELECT C5_NUM, C6_PRODUTO, C6_ITEM, C6_DESCRI, C6_QTDVEN, C6_LOCAL, C6_VALOR, " +CRLF
	_cQuery += " C6_ENTREG, C6_01AGEND,C6_CLI,A1_NOME, C6_LOJA,C6_NUMTMK, " +CRLF
	_cQuery += " C6_MSFIL,C6_FILIAL,C6_NOTA, C6_QTDEMP, C6_LOCALIZ, C6_XUSRAGE,C6_XNUMSC, B1_01FORAL " +CRLF
    _cQuery += " FROM " + RETSQLNAME("SC5") + "(NOLOCK) SC5 " +CRLF
	_cQuery += " INNER JOIN " + RETSQLNAME("SA1") + "(NOLOCK) SA1 ON A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI " +CRLF
	_cQuery += " INNER JOIN " + RETSQLNAME("SC6") + "(NOLOCK) SC6 ON C6_FILIAL = C5_FILIAL " +CRLF
	_cQuery += " AND C6_NUM = C5_NUM "+CRLF 
	_cQuery += " AND C6_CLI = C5_CLIENTE "+CRLF
	_cQuery += " AND C6_LOJA = C5_LOJACLI "+CRLF    
	_cQuery += " INNER JOIN SB2010(NOLOCK) SB2 ON C6_PRODUTO = B2_COD  AND C6_LOCAL = B2_LOCAL"+CRLF
	_cQuery += " INNER JOIN SB1010(NOLOCK) SB1 ON SC6.C6_PRODUTO = SB1.B1_COD"+CRLF
	_cQuery += " INNER JOIN SM0010(NOLOCK) SM0 ON SC5.C5_MSFIL = SM0.FILFULL"+CRLF
	_cQuery += " WHERE C5_FILIAL <> ' ' " +CRLF
	_cQuery += " AND B2_FILIAL = '0101' " +CRLF	
	_cQuery += " AND SB2.D_E_L_E_T_ = ' ' " +CRLF
	_cQuery += " AND SC5.D_E_L_E_T_ = ' ' " +CRLF
	_cQuery += " AND SA1.D_E_L_E_T_ = ' ' " +CRLF
	_cQuery += " AND SC6.D_E_L_E_T_ = ' ' " +CRLF
	_cQuery += " AND A1_01PEDFI <> '1' " +CRLF
    if !(nPedFi) == 3
		if (nPedFi) == 1
			_cQuery += " AND C5_PEDPEND = '2'" +CRLF
		else
			_cQuery += " AND C5_PEDPEND <> '2'" +CRLF    
		endif
	endif
	if !(nMostrua) == 3
    	if (nMostrua) == 1
			_cQuery += " AND C6_LOCAL = '03'" +CRLF        
        else
			_cQuery += " AND C6_LOCAL <> '03'" +CRLF        
        endif
	endif
	if !(nBlqDesc) == 3
		if (nBlqDesc) == 1
			_cQuery += " AND C5_XLIBER = 'B'" +CRLF        		
		else
			_cQuery += " AND C5_XLIBER <> 'B'" +CRLF        		
		endif	
	endif
	if cMV_PAR14 == 1
		_cQuery += " AND C6_NOTA <> ' '"  +CRLF  
	else
		_cQuery += " AND C6_NOTA = ' '"  +CRLF  
	endif
	If cArmaze == 'Todos'
		_cQuery += " AND C6_LOCAL <> ''"+CRLF
	Else
		_cQuery += " AND C6_LOCAL = '"+cArmaze+"'"+CRLF
	EndIf 
	_cQuery += " AND C6_BLQ <> 'R'"+CRLF
	if !__cUserid $ cUsGer 
	_cQuery += " AND C5_CLIENTE <> '000001'"+CRLF
	endif
	_cQuery += " AND C5_MSFIL BETWEEN '" + cMV_PAR01 + "' AND '" + cMV_PAR02 + "' " +CRLF
	_cQuery += " AND C5_EMISSAO BETWEEN '" + DTOS(cMV_PAR03) + "' AND '" + DTOS(cMV_PAR04) + "' " +CRLF
	_cQuery += " AND C5_CLIENTE BETWEEN '" + cMV_PAR05 + "' AND '" + cMV_PAR07 + "' " +CRLF
	_cQuery += " AND C5_LOJACLI BETWEEN '" + cMV_PAR06 + "' AND '" + cMV_PAR08 + "' " +CRLF
	_cQuery += " AND C5_NUM BETWEEN '" + cMV_PAR09 + "' AND '" + cMV_PAR10 + "' " +CRLF   
	If !Empty(cMV_PAR11) .OR. !Empty(cMV_PAR12)  
		_cQuery += " AND C6_ENTREG BETWEEN '" + DTOS(cMV_PAR11) + "' AND '" + DTOS(cMV_PAR12) + "' "  +CRLF
	Endif
	If cMV_PAR13 <> 1
		Iif ( cMV_PAR13 == 2, _cQuery += " AND C6_01AGEND = '1' "  + CRLF,  _cQuery += " AND C6_01AGEND = '2' "  + CRLF)
	Endif 
	if !__cUserid $ cUsGer 
	_cQuery += " AND C5_XCONPED = '1' " +CRLF 
	endif
	_cQuery += " AND B2_FILIAL = '0101'"+CRLF
	if !empty(alltrim(cNomeCli))
		_cQuery += " AND A1_NOME LIKE ('"+ alltrim(cNomeCli) +"%')"+CRLF
	endif
    if oOpcoes:nat == 1
		if !empty(alltrim(cPesqProd))
			_cQuery += " AND C6_PRODUTO LIKE ('%"+ alltrim(cPesqProd) +"%')"	+CRLF
		endif
	else
		if !empty(alltrim(cPesqProd))
			_cQuery += " AND C6_DESCRI LIKE ('%"+ alltrim(cPesqProd) +"%')"	+CRLF
		endif
	endif
	if nRadio == 2
		_cQuery += " AND (B2_QATU - (B2_RESERVA + B2_QEMP + B2_QACLASS ) > 0 OR C6_QTDEMP > 0) "+CRLF  
	endif
	if !empty(alltrim(strTran(cCep,'-','')))
		_cQuery += " AND A1_CEP LIKE ('"+ alltrim(strTran(cCep,'-','')) +"%')"+CRLF
	endif	
	if nRadAgreg == 2
		_cQuery += " AND B1_XACESSO <> '1'"+CRLF
	endif
	_cQuery += " ORDER BY C5_EMISSAO "+CRLF
	
	 PLSQuery(_cQuery, cAliEm)
		
		aItPed := {}
		
		while (cAliEm)->(!eof())
			
			cEstoque := ""
			cTipoProd := ""
			cForaLinha := ""
			cAgend := ""
			nEstoque := 0
			cTermo := "Nao"
			
			DbSelectArea("SC9")
			SC9->(DbSetOrder(2))
			if SC9->(DbSeek((cAliEm)->C6_FILIAL+(cAliEm)->C6_CLI+(cAliEm)->C6_LOJA+(cAliEm)->C5_NUM+(cAliEm)->C6_ITEM))
				cEstoque := iif(Empty(alltrim(SC9->C9_BLEST)),"SIM","NAO")	
			else
				cEstoque := "NAO"
			endif
			
			DbSelectArea("SB2")
			SB2->(DbSetOrder(1))
			if SB2->(DbSeek(xFilial("SB2") + (cAliEm)->C6_PRODUTO + (cAliEm)->C6_LOCAL ))
				nEstoque := SB2->B2_QATU - (SB2->B2_RESERVA + SB2->B2_QEMP + SB2->B2_QACLASS) + iif(cEstoque=="SIM",(cAliEm)->C6_QTDEMP,0)  //#AFD27062018.N
			else		
				nEstoque := 0	
			endif
		
			dbselectArea("SUB")
			SUB->(dbsetorder(1))
			if SUB->(dbseek((cAliEm)->C6_MSFIL+alltrim(substr((cAliEm)->C6_NUMTMK,5,10))+(cAliEm)->C6_ITEM+(cAliEm)->C6_PRODUTO))
				cTipoProd := SUB->UB_MOSTRUA
			else
				cTipoProd := '0'
			endif
		
			Do Case
				case cTipoProd == '1'
					cDescTipo := "Peca Nova Loja"
				case cTipoProd == '2' 
					cDescTipo := "Mostruario"
				case cTipoProd == '3'
					cDescTipo := "Personalizado"
				case cTipoProd == '4'  	
					cDescTipo := "Acessorio"
				otherwise
					cDescTipo := ""		
			endcase
			
			if (cAliEm)->(C6_01AGEND) == '1'
				cAgend := "SIM"
			Else
				cAgend := "NAO"
			EndIf
							
				
			Aadd(aItPed,{	(cAliEm)->C5_NUM,;		//1										
							(cAliEm)->C6_PRODUTO,; 	//2
							(cAliEm)->C6_ITEM,; 	//3
							(cAliEm)->C6_DESCRI,; 	//4
							(cAliEm)->C6_QTDVEN,;	//5
							(cAliEm)->C6_LOCAL,;  	//6
							(cAliEm)->C6_VALOR,;	//7
							(cAliEm)->C6_ENTREG,; 	//8
							nEstoque,;				//9																	
							cEstoque,;				//10																	
							cDescTipo,;				//11																
							cForaLinha,;			//12																	
							cTermo,;				//13
							cAgend,;				//14
							(cAliEm)->C6_CLI,; 		//15
							(cAliEm)->A1_NOME,;  	//16
							(cAliEm)->C6_NOTA,;  	//17
							(cAliEm)->C6_LOCALIZ,;	//18
							(cAliEm)->C6_XNUMSC,; 	//19
							(cAliEm)->C6_XUSRAGE}) 	//20
				(cAliEm)->(DbSkip())
		end 
				(cAliEm)->(dbCloseArea())
	
		
	 aCab := {{"Pedido","C5_NUM","C"},; 			//1
	 		  {"Produto","C6_PRODUTO","C"},;		//2
	 		  {"Item","C6_ITEM","C"},;				//3
	 		  {"Descricao","C6_DESCRI","C"},;		//4
	 		  {"Qtd Ven","C6_QTDVEN","C"},;			//5
	 		  {"Local","C6_LOCAL","C"},;			//6
	 		  {"Valor","C6_VALOR","N"},;			//7
	 		  {"Entrega","C6_ENTREG","D"},;			//8
	 		  {"Saldo","C6_SALDO","N"},;			//9
	 		  {"Estoque","C6_SALDO","C"},;			//10																	
			  {"DescTipo","C6_DESCRI","C"},;		//11																
			  {"ForaLinha","B1_01_FORAL","C"},;		//12																	
			  {"Termo","C6_01AGEND","C"},;			//13
			  {"Agenda","C6_01AGEND","C"},;			//14
			  {"Cod_cli","C6_CLI","C"},; 			//15
			  {"Nome","A1_NOME","C"},;  			//16
			  {"Nota","C6_NOTA","C"},;  			//17
			  {"Ender","C6_LOCALIZ","C"},;			//18
			  {"Ped_comp","C6_XNUMSC","C"},; 		//19
			  {"Usr_Agend","C6_XUSRAGE","C"}}  		//20
				
	cNamePlan := cNameTable := cTitle

	oExcel:AddworkSheet(cNamePlan)
	oExcel:AddTable (cNamePlan,cNameTable)
	
	//Colunas do Excel ----------------------------------------
	for nx := 1 to Len(aCab)
		if aCab[nx][3] == "C"// Tipo Caracter
			oExcel:AddColumn(cNamePlan,cNameTable,aCab[nx][1],1,1)
		elseif aCab[nx][3] == "N"// Tipo Numerico
			oExcel:AddColumn(cNamePlan,cNameTable,aCab[nx][1],3,2)
		else // Tipo Data
			oExcel:AddColumn(cNamePlan,cNameTable,aCab[nx][1],1,3)			
		endif
	next nx

    for nx := 1 to len(aItPed) 
	   	oExcel:AddRow(cNamePlan,cNameTable,{;
	   										aItPed[nx][1],;
	   										aItPed[nx][2],;
	   										aItPed[nx][3],;
	   										aItPed[nx][4],;
	   										aItPed[nx][5],;
	   										aItPed[nx][6],;
	   										aItPed[nx][7],;
	   										aItPed[nx][8],;
	   										aItPed[nx][9],;
	   										aItPed[nx][10],;
	   										aItPed[nx][11],;
											aItPed[nx][12],;
											aItPed[nx][13],;
	   										aItPed[nx][14],;
	   										aItPed[nx][15],;
	   										aItPed[nx][16],;
	   										aItPed[nx][17],;
	   										aItPed[nx][18],;
	   										aItPed[nx][19],;
	   										aItPed[nx][20];
	   										},{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20})
	next nx
    
	oExcel:Activate()
	oExcel:GetXMLFile(cArqTemp)
	ShellExecute("open",  cArqTemp, "", "C:\", 1 )
	
Return


//--------------------------------------------------------------
/*/{Protheus.doc} atuDtAgend
Description //Atualiza data do agendamento
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 02/10/2018
/*/
//--------------------------------------------------------------
Static Function atuDtAgend(acols)

	Local oDataAtu
	Local dDataAtu := ctod("//")
	Local cCombo   := ''
	Local lfConfirm := .F.
	Local oSayData
	Local cSayTitle := "Atualiza��o da data de agendamento"
	Local oComboDt
	Local aItens := {'22/12/2222-Sem Previs�o','03/03/3333-Cancelamento','04/04/4444-Bloqueado','05/05/5555-Procon-TJ','06/06/6666-Desmontagem','07/07/7777-Vistoria','08/08/8888-Contato sem Sucesso','09/09/9999-N�o Agendado'}
	Local _cUser := SUPERGETMV("KH_SAC001", .T., "000478")
	Local nMarca := 0
	Private oDlgAtuData
	Private aHeaderD := {}
	private aColsD := {}

//Altera��o solicitada no chamado 9628
DbselectArea("DAI")
DAI->(dbsetorder(4))
If DAI->(DbSeek(xFilial("DAI") + aCols[nPPedido]))
	cMsgCarga := "O pedido: "+ aCols[nPPedido] +" ja possui carga montada"+ENTER
	cMsgCarga += "N�o � permitido sua alteracao. Entre em contato com a Logistica!"
	msgStop(cMsgCarga,"ATEN��O")
	return
Endif

	dbSelectArea("SC6")
	SC6->(dbSetOrder(1))
	
 	DEFINE MSDIALOG oDlgAtuData TITLE "DATA AGENDAMENTO" FROM 000, 000  TO 300, 600 COLORS 0, 16777215 PIXEL

	@ 007, 005 SAY oSaytexto PROMPT cSayTitle SIZE 104, 007 OF oDlgAtuData COLORS 15493632, 16777215 PIXEL
	
    if __cUserid $ _cUser
    	@ 020, 005 SAY oSayData PROMPT "Data :" SIZE 025, 007 OF oDlgAtuData COLORS 0, 16777215 PIXEL
        @ 018, 033 MSGET cDate VAR dDataAtu SIZE 052, 010 OF oDlgAtuData /*VALID vldD(dDataAtu)*/ COLORS 0, 16777215 PIXEL
    Else
    	@ 020, 005 SAY oSayData PROMPT "Status :" SIZE 025, 007 OF oDlgAtuData COLORS 0, 16777215 PIXEL
    	@ 018, 033 MSCOMBOBOX oComboDt VAR cCombo ITEMS aItens SIZE 100, 005 OF oDlgAtuData COLORS 0, 16777215 PIXEL
    EndIf    
    @ 004, 186 BUTTON oBtnConfirm PROMPT "Confirmar" SIZE 050, 025 OF oDlgAtuData ACTION {|| lfConfirm := .T., lfConfirm := vldDate(@dDataAtu, cCombo), iif(lfConfirm,oDlgAtuData:end(),) } PIXEL
	@ 004, 242 BUTTON oBtnSair PROMPT "Sair" SIZE 050, 025 OF oDlgAtuData ACTION {|| oDlgAtuData:end() } PIXEL

	fItAltDate(aCols[nPPedido])

  	ACTIVATE MSDIALOG oDlgAtuData CENTERED

	if lfConfirm
		
		for nx := 1 to len(oMSNewGet:acols)
			If oMSNewGet:acols[nx][1] == "LBTIK"
				nMarca += 1
			EndIf
		Next nx
		
		If nMarca == 0
			msgAlert("Nenhum item foi selecionado!!","Aten��o")
			return
		endif
		
		
		for nx := 1 to len(oMSNewGet:acols)
			if oMSNewGet:acols[nx][1] == "LBTIK"
				if SC6->(dbSeek(xFilial("SC6")+aCols[nPPedido]+oMSNewGet:acols[nx][2]))
					if empty(SC6->C6_NOTA)
						RecLock("SC6",.F.)
							SC6->C6_ENTREG  := dDataAtu
							SC6->C6_DTAGEND := dDataBase
						MsUnlock()
					endif
				endif
			endif
		next nx
		
		fCarrIt(acols[nPPedido],acols[nPCliente],acols[nPLojaCli])
		oGridIt:ForceRefresh()
	
		faTuDtZK0(acols[nPPedido], dDataAtu , .F.)
	endif

Return


//--------------------------------------------------------------
/*/{Protheus.doc} fItAltDate
Description //Descri��o da Fun��o
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since dd/mm/aaaa /*/
//--------------------------------------------------------------
Static Function fItAltDate(cPedido)

	Local nX
	Local aFieldFill := {}
	Local aFields := {"C6_ITEM","C6_PRODUTO","B1_DESC"}
	Local aAlterFields := {}
	
	Static oMSNewGet

//Altera��o solicitada pelo chamado 9628
DbselectArea("DAI")
DAI->(dbsetorder(4))
If DAI->(DbSeek(xFilial("DAI")+cPedido))
	cMsgCarga := "O pedido: "+ cPedido +" ja possui carga montada"+ENTER
	cMsgCarga += "N�o � permitido sua alteracao. Entre em contato com a Logistica!"
	msgStop(cMsgCarga,"ATEN��O")
	return
Endif
  	// Define field properties
  	DbSelectArea("SX3")
  	SX3->(DbSetOrder(2))
	
	Aadd(aHeaderD,{"","FLAG","@BMP",2,0,"","��������������","C","","R","","","","V","","",""})

	For nX := 1 to Len(aFields)
		If SX3->(DbSeek(aFields[nX]))
		Aadd(aHeaderD, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
						SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		Endif
	Next nX

	dbSelectArea("SC6")
	SC6->(dbSetOrder(1))

	aColsD := {}

	if SC6->(dbSeek(xfilial() + cPedido))
		while SC6->C6_NUM == cPedido 
			if empty(SC6->C6_NOTA)
				aAdd(aColsD,{"LBNO", SC6->C6_ITEM, SC6->C6_PRODUTO, Posicione('SB1',1,xFilial('SB1')+SC6->C6_PRODUTO,'B1_DESC'), .F.})
			endif
		SC6->(dbSkip())
		end
	endif

    oMSNewGet := MsNewGetDados():New( 033, 004, 146, 294, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlgAtuData, aHeaderD, aColsD)
	oMSNewGet:oBrowse:bLDblClick := {|| fMarcOneD(oMSNewGet:nat) }
	oMSNewGet:oBrowse:bHeaderClick := {|o, iCol| fMarcHeader(iCol), oMSNewGet:Refresh()}
Return

//fMarcOne: Marca o checkbox da linha posicionada
Static Function fMarcOneD(nLin) 

	Local nPFlag := Ascan(oMSNewGet:aHeader,{|x|AllTrim(x[2])=="FLAG"})
	
	if oMSNewGet:aCols[nLin,nPFlag] == "LBTIK"
		oMSNewGet:aCols[nLin,nPFlag] := "LBNO"
	else
		oMSNewGet:aCols[nLin,nPFlag] := "LBTIK"
	endif
	
	oMSNewGet:Refresh()
	
Return
//--------------------------------------------------------------
Static Function fMarcHeader(nColuna)

	Local nx := 0
	
	Local nPFlag := Ascan(oMSNewGet:aHeader,{|x|AllTrim(x[2])=="FLAG"})
	
	if nOrder++ == 0
		if nColuna == nPFlag
			for nx := 1 To Len(oMSNewGet:aCols)
				if oMSNewGet:aCols[nx,nPFlag] == "LBNO"
					oMSNewGet:aCols[nx,nPFlag] := "LBTIK"
				else
					oMSNewGet:aCols[nx,nPFlag] := "LBNO"
				endif
			next nx
		endif
	else
		nOrder := 0
	endif

	oMSNewGet:Refresh()

Return
//--------------------------------------------------------------
//--------------------------------------------------------------
/*/{Protheus.doc} faTuDtZK0
Description //Atualiza a data do agendamento do termo retira
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 24/10/2018 /*/
//--------------------------------------------------------------
Static Function faTuDtZK0(cPedido, dDataZk0 , lEstorno)

	Local cAliasZK0 := ""
	Local cNumSAC := ""
	Local cQueryZK0 := ""
	Local oMngData	:= MNGDATA():NEW()
	Local aGrava	:= {}
	Local oDLG
	Local oSay
	Local oTGet1
	Local cTGet1 	:= Space(300)
	Local cNomeCli	:= ""
	Local cCPFCli	:= ""
	Local lContinua	:= .F.
	
	If (lEstorno)
	
		Do While !lContinua
		
			oDlg	:= TDialog():New(80,10,200,400,'Motivo de estorno',,,,,CLR_BLACK,CLR_WHITE,,,.T.)
			oSay	:= TSay():New(01,01,{||"Informe o Motivo do estorno"},oDlg,,,,,,.T.,,,100,20,,,,,,)
			oTGet1	:= TGet():New( 01,01,{|u| If(PCount()>0,cTGet1:=u,cTGet1)},oDlg,180,20,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cTGet1,,,, )
			//Validacao para verificar se o motivo do estorno foi preenchido. Somente permitir� prosseguir se o motivo do estorno for informado.
			oBtnArq	:= tButton():New(40,155,"Confirmar",oDlg,{|| lRet := fVldSai(cTGet1 , oDlg) },30,12,,,,.T.)
			/*Criterios para validacao		
				1-Nao permitir que o motivo esteja vazio;
				2-Se preenchido, o conteudo deve ser superior a 20 caracteres.		
			*/		
			
			oDlg:Activate()
			
			If ( !(Empty(AllTrim(cTGet1))) .AND. (Len(AllTrim(cTGet1)) > 20))
				//Valida se o conteudo esta preenchido. Caso 'Esc' seja pressionada, valida se o conteudo da variavel � superior a 20. 
				//Se n�o for, for�a a digita��o do usu�rio
			
				lContinua	:= .T.
			
			EndIf
		
		EndDo
	
	EndIf

	cNumSAC := Posicione('SC5',1,xFilial('SC5')+cPedido,'C5_01SAC')

	cAliasZK0 := getNextAlias()

	//Atualiza dados do termos Retira em aberto
	cQueryZK0 := "SELECT ZK0_COD, ZK0_PROD, ZK0_DESCRI, ZK0_NUMSAC, ZK0_CLI, ZK0_LJCLI, ZK0_DTAGEN, ZK0_NUMSAC, ZK0_STATUS, ZK0_CARGA, R_E_C_N_O_ as RECNO"+ ENTER
	cQueryZK0 += "FROM "+RetSqlName("ZK0")+ ENTER
	cQueryZK0 += "WHERE ZK0_NUMSAC = '"+ cNumSAC +"'"+ ENTER
	cQueryZK0 += "AND ZK0_STATUS <> '3'"+ ENTER
	cQueryZK0 += "AND D_E_L_E_T_ = ' '"+ ENTER

	plsQuery(cQueryZK0,cAliasZK0)

	If ((cAliasZK0)->(!EOF()))

		While (cAliasZK0)->(!eof())

			dbgoto((cAliasZK0)->RECNO)

			RecLock("ZK0",.F.)
				ZK0->ZK0_DTAGEN := dDataZk0
			msUnLock()

			(cAliasZK0)->(dbskip())
		End

	EndIf

	If (lEstorno)
	
		//Atualiza a tabela de log de altera��es

		If (SA1->(dbSeek(xFilial("SA1") + SC5->C5_CLIENTE  + SC5->C5_LOJACLI)))

			cNomeCli	:= SA1->A1_NOME
			cCPFCli		:= SA1->A1_CGC

		Else

			cNomeCli	:= "Cliente Nao Localizado"
			cCPFCli		:= "Cliente Nao Localizado"

		EndIf

		aGrava	:=	{;
						{"ZLO_XHORA" 	, TIME()},;
						{"ZLO_XORC" 	, SC5->C5_NUMTMK},;
						{"ZLO_XCODCL" 	, SC5->C5_CLIENTE},;
						{"ZLO_XNOME" 	, cNomeCli},;
						{"ZLO_XUSER" 	, UsrRetName(RetCodUsr())},;
						{"ZLO_XDTEST" 	, dDataBase},;
						{"ZLO_XOBS" 	, AllTrim(cTGet1)},;
						{"ZLO_XPED" 	, SC5->C5_NUM},;
						{"ZLO_XCPF" 	, cCPFCli};
					}

		oMngData:GravaData("ZLO" , .T. , aGrava)	
	
	EndIf

	(cAliasZK0)->(dbCloseArea())

Return

//--------------------------------------------------------------
/*/{Protheus.doc} atuDtAgend
Description //Valida a data digitada na fun��o (atuDtAgend)
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 04/10/2018
/*/
//--------------------------------------------------------------
Static Function vldD(dDataAtu)

	if dDataAtu < dDataBase
		apMsgAlert("N�o � possivel informar uma data menor que a data base.","WARNING")
		return(.F.)
	endif 

Return(.T.)

//--------------------------------------------------------------
/*/{Protheus.doc} fSetOpCab
Description //Define a a��o com base na coluna clicada no Pedido
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 07/12/2018 /*/
//--------------------------------------------------------------
Static Function fSetOpCab(nColuna,_array)
	
	Local aArea := getArea()
	Local lRet := .F.
	Local cPedido := _array[nPPedido]// Pedido de venda
	Local cNome := _array[nPNome]// Nome do Cliente
	Local _cMsfil := _array[nPMsFil] //filial do sistema 
	Local nQtd := 0
	
	dbSelectArea("SC5")
	SC5->(dbsetorder(1)) //C5_FILIAL, C5_NUM, R_E_C_N_O_, D_E_L_E_T_

    Do Case
        case nColuna == nPEmail //Email
        iF ! empty(_array[nPEmail])
			if msgYesNo("Deseja Enviar email para: "+ alltrim(_array[nColuna]),"Contato Komfort House")
				
				cPara := alltrim(_array[nColuna]) //Email do cliente
				cAssunto := "Pedido Komfort House ("+ cPedido +") - "+ alltrim(cNome)
				
				//Retorna a mensagem de acordo com a op��o selecionada.
				cMensagem := getOpcMail()
				
				if !empty(alltrim(cMensagem))
					MsgRun("Aguarde... Enviando email para: "+ alltrim(_array[nColuna]) ,"Envio de email",{|| lRet := sendMail( cPara, cAssunto, cMensagem ) })
				endif
				
				if lRet
					if SC5->(dbSeek(xFilial()+cPedido))
						
						nQtd := SC5->C5_MAILENV
						
						RecLock("SC5",.F.)
							SC5->C5_MAILENV := nQtd + 1
						SC5->(msUnLock())

						oGridPed:acols[oGridPed:nat][nPQtdEmail] := SC5->C5_MAILENV
						oGridPed:refresh()
					endif
				endif
			endif
		Else
		MsgAlert("N�o existe nenhum registro selecionado","Aten��o")
		EndIf
			
		Otherwise
			
			//Valida��o de pedido com pendencia financeira
			lPendF := vldPendF(_array[nPMsFil],_array[nPPedido])
			
			//Veriica se o cliente possiu t�tulos em aberto de pagamento ipedindo o agendamento de entrega dos produtos
			lPendFC := vldPendFC(_array[nPCliente],_array[nPLojaCli])                                     
			
			if !lPendF .And. lPendFC
				TELMANU(_array)                                             
			endif

	EndCase

	restArea(aArea)

Return

//--------------------------------------------------------------
/*/{Protheus.doc} getOpcMail
Description //Descri��o da Fun��o
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 21/01/2019 /*/
//--------------------------------------------------------------
Static Function getOpcMail()

	Local lRet := .F.
	Local oBtnCancel
	Local oBtnConfirm
	Local oGroup
	Local oRadio
	Local nRadio := 1
	Local cEmail := ""

	Local oDlgHtml

	DEFINE MSDIALOG oDlgHtml TITLE "Komfort House" FROM 000, 000  TO 100, 300 COLORS 0, 16777215 PIXEL

	@ 000, 002 GROUP oGroup TO 030, 146 PROMPT " Op��es de notifica��o automatica " OF oDlgHtml COLOR 0, 16777215 PIXEL
	@ 033, 003 BUTTON oBtnCancel PROMPT "Cancelar" SIZE 069, 012 OF oDlgHtml ACTION {|| lRet := .F., oDlgHtml:end() } PIXEL
	@ 034, 077 BUTTON oBtnConfirm PROMPT "Confirmar" SIZE 069, 012 OF oDlgHtml ACTION {|| lRet := .T., oDlgHtml:end() } PIXEL
	@ 009, 004 RADIO oRadio VAR nRadio ITEMS "Tentativa de contato sem sucesso","Estofado disponivel para agendamento" SIZE 140, 018 OF oDlgHtml COLOR 0, 16777215 PIXEL

	ACTIVATE MSDIALOG oDlgHtml CENTERED

	if lRet
		
		//1= "Tentativa de contato sem sucesso"
		//2= "Estafado disponivel para agendamento"
		cEmail := getHtml(nRadio)

	endif

Return cEmail

//--------------------------------------------------------------
/*/{Protheus.doc} getHtml
Description //Descri��o da Fun��o
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 18/01/2019 /*/
//--------------------------------------------------------------
Static Function getHtml(nOpc)

	Local cbody := ""
	
	default nOpc := 1

	if nOpc == 1
	
		cbody := '<h1 style="font-family: Arial; color: #495157;">'
    	cbody += '	<br>Caro Cliente,'
    	cbody += '</h1>'
		
		cbody += '<hr>'
    
    	cbody += '<h3>'
      	cbody += '	<p style="font-family: Arial; color: #495157;">'
        cbody += '		Seu estofado j� esta dispon�vel para entrega. Estamos tentando entrar em contato nos telefones cadastrados, por�m sem sucesso.'
      	cbody += '	</p>'
    	cbody += '</h3>'

		cbody += '<h3>'
      	cbody += '	<p style="font-family: Arial; color: #495157;">'
        cbody += '		Por favor, entre em contato conosco e agende sua entrega nos telefones: <span style="font-family: Arial; color: black;">(11) 4280-4610 ou (11) 4343-3989</span>, de Segunda � Sexta- feira das 8hs �s 18hs e aos s�bados das 8hs �s 16h20.'
      	cbody += '	</p>'
    	cbody += '</h3>'
    
    	cbody += '<h3>'
      	cbody += '	<p style="font-family: Arial; color: #495157;">'
        cbody += '		Aproveite e atualize seus dados cadastrais(endere�o de entrega, e-mail e telefones) atrav�s de um e-mail Para o SAC:<span style="font-family: Arial; color: black;"> serviraocliente@komforthouse.com.br</span>'
        cbody += '	</p>'
		cbody += '</h3>'
    
    	cbody += '<h3>'
      	cbody += '	<p style="font-family: Arial; color: #495157;">'
        cbody += '		Obrigado.'
      	cbody += '	</p>'
		cbody += '</h3>'
	
	else
	
		cbody := '<h1 style="font-family: Arial; color: #495157;">'
		cbody += '	<br>Ol� Cliente!'
		cbody += '</h1>'
		
		cbody += '<h3>'
		cbody += '	<p style="font-family: Arial; color: #495157;">'
		cbody += '		Seu estofado j� esta dispon�vel em nosso Estoque.'
		cbody += '	</p>'
		cbody += '</h3>'

		cbody += '<h3>'
		cbody += '  <p style="font-family: Arial; color: #495157;">'
		cbody += '      Agende a sua entrega nos seguintes telefones:'
		cbody += '  </p>'
		cbody += '</h3>'
		
		cbody += '<h3>'
		cbody += ' <p style="font-family: Arial; color: #495157;">'
		cbody += '     <strong>'
		cbody += '          (11) 4343-3989 ou (11) 4280-4610'
		cbody += '      </strong>'
		cbody += '  </p>'
		cbody += '</h3>'
		
		cbody += '<h3>'
		cbody += '  <p style="font-family: Arial; color: red;">'
		cbody += '      De Segunda � sexta 8h �s 18h, S�bado das 8h �s 16h20.'
		cbody += '  </p>'
		cbody += '</h3>'

		cbody += '<h3>'
      	cbody += '	<p style="font-family: Arial; color: #495157;">'
        cbody += '		Obrigado.'
      	cbody += '	</p>'
		cbody += '</h3>'
	
	endif

	cbody += '<img style="width: 140px; height: 120px;" alt="Logo-KomfortHouse" src="http://www.komforthouse.com.br/wp-content/uploads/logo-topo-sticky.png">

Return cbody

//--------------------------------------------------------------
/*/{Protheus.doc} sendMail
Description //Fun��o responsavel pelo envio de email para os clientes
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 21/01/2019 /*/
//--------------------------------------------------------------
Static function sendMail( cPara, cAssunto, cMensagem )

	Local cAccount := AllTrim(SUPERGETMV("KH_MAILSAC", .F., "atendimentoaocliente@komforthouse.com.br"))	 // ExpC1 : Conta para conexao com servidor SMTP
	Local cPassword := AllTrim(SUPERGETMV("KH_PASSSAC", .F., "komfort01")) // ExpC2 : Password da conta para conexao com o servidor SMTP
	Local cServer := AllTrim(GetMV( "MV_RELSERV" ))	 // ExpC3 : Servidor de SMTP
	Local cError := ""
	Local lAutentica := GetMV( "MV_RELAUTH" )				// Necessita de autentica��o de e-mail
	Local lResult    := .F.	// Retorno se enviou ou n�o a mensagem
	Local cCco := AllTrim(SUPERGETMV("KH_MCCOSAC", .F., "isaias.gomes@komforthouse.com.br"))  // Email CCo, que recebera uma copia do email

	CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult 

	If lResult .and. lAutentica
		lResult := Mailauth(cAccount,cPassword)
	Endif

	If lResult           

		SEND MAIL	FROM cAccount;
		TO      	cPara;
		BCC			cCco; 
		SUBJECT 	cAssunto;
		BODY    	cMensagem;
		RESULT 		lResult

		If ! lResult //Erro no envio do email
			GET MAIL ERROR cError
		EndIf

		DISCONNECT SMTP SERVER
	endif

Return lResult


//--------------------------------------------------------------
/*/{Protheus.doc} fSetOPIt
Description //Define a a��o com base na coluna clicada no Item do pedido de venda
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 31/01/2018 /*/
//--------------------------------------------------------------
Static Function fSetOPIt(nColuna, arrayPed, arrayIt)
	Local _cProd := arrayIt[nPProduto]// Pedido de venda
	Local aArea := getArea()

	Do Case
		Case nColuna == nPTermoRet
			fTerRet(_cAtend, aTerRet)
		Case nColuna == nPProduto
			MaViewSB2(arrayIt[nPProduto],,arrayIt[nPLocal])
		case nColuna == nPQtdVend .AND. __cUserid $ cUsGer
			iF ! empty(arrayIt[nPProduto])	
					U_KHVISFIL(_cProd)
			Else
			MsgAlert("N�o existe nenhum registro selecionado","Aten��o")
			EndIf
		Otherwise
			AGENDITEM(arrayPed, arrayIt)
	EndCase

	restArea(aArea)

Return


//--------------------------------------------------------------
/*/{Protheus.doc} flibvend
Description //Libera os produtos dos pedidos para venda 
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul
@since 31/01/2018 /*/
//--------------------------------------------------------------
Static function flibvend(_cPed,_cMsfil)
Local cQuery := ""
Local cAlic6 := GetNextAlias()
Local aPed_	 := {}
cQuery := CRLF + "  SELECT SC6.R_E_C_N_O_ as RECNO, SC6.C6_PRODUTO as Produto, SC6.C6_MSFIL as Filial FROM SC6010(NOLOCK) SC6 "
cQuery += CRLF + " 	WHERE  SC6.D_E_L_E_T_ <> '*' "
cQuery += CRLF + " 	AND C6_NUM  = '"+_cPed+"' "
cQuery += CRLF + " 	AND C6_NOTA = ' ' "
cQuery += CRLF + " 	AND C6_BLQ <> 'R'  "
cQuery += CRLF + " 	AND C6_CLI <> '000001' "
cQuery += CRLF + " 	AND C6_MSFIL = '"+_cMsfil+"' "
PLSQuery(cQuery, cAlic6)
 while (cAlic6)->(!eof())
  aAdd(aPed_,{;
        				(cAlic6)->RECNO,;
                        (cAlic6)->Produto,;   
                        (cAlic6)->Filial})               
               (cAlic6)->(Dbskip())
 end
 				 (cAlic6)->(dbCloseArea())
If len(aPed_) > 0
		For nx := 1 to len(aPed_)
			dbSelectArea("SC6")
          	SC6->(dbgoto(aPed_[nx][1])) //Posicione no registro da SC6
     		  IF !EOF()
     		  	RecLock("SC6",.F.)
      		  		SC6->C6_XVENDA := '1'
      		  	SC6->(msUnLock())
      		  	MsgAlert("Produto Liberado com Sucesso!","Aten��o!")
      		  EndIF 		 
      	Next nx
Else
MsgAlert("Nenhum produto encontrado!","Aten��o!")
EndIf
SC6->(dbCloseArea())
Return 

//--------------------------------------------------------------
/*/{Protheus.doc} ConsEst
Description //Tela de consulta ao hist�rico de estornos
@param xParam Parameter Description
@return xRet Return Description
@author  - Luis Artuso
@since 19/12/2019 /*/
//--------------------------------------------------------------
Static Function ConsEst()

	Local cAlias 	:= "ZLO"
	Local cTitulo	:= "Consulta ao hist�rico de estornos"
	Local cVldExc	:= "U_fVldAge(1)" //Valida��o na Exclus�o
	Local cVldOk	:= "U_fVldAge(2)" //Valida��o na Inclus�o
	dbSelectArea(cAlias)
	AxCadastro(cAlias, cTitulo,cVldExc,cVldOk)

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fVldSai
Description //Validacao para verificar se o motivo de estorno foi preenchido
@param xParam Parameter Description
@return xRet Return Description
@author  - Luis Artuso
@since 26/12/2019 /*/
//--------------------------------------------------------------
Static Function fVldSai(cTGet1,oDlg)

	Local lRet	:= .F.
	Local cTmp	:= AllTrim(cTGet1)

	If !(Empty(cTMP))

		If (Len(cTMP) < 20)

			Aviso("Campo obrigat�rio" , "Informe quantidade superior a 20 caracteres para prosseguir com o estorno.")

		Else

			oDlg:End()

		EndIf

	Else

		Aviso("Campo obrigat�rio" , "� obrigat�rio informar o motivo do estorno do pedido.")

	EndIf

Return lRet

//--------------------------------------------------------------
/*/{Protheus.doc} fVldAge
Description //Validacao para impedir altera��es na tabela de log de estorno
@param xParam Parameter Description
@return xRet Return Description
@author  - Luis Artuso
@since 06/01/2020 /*/
//--------------------------------------------------------------
User Function fVldAge(nOp)

	Do Case

		Case (nOp == 1)

			MsgAlert("Nao � permitido excluir o registro")

		Case (nOp == 2)

			Do Case

				Case (INCLUI)

					MsgAlert("Somente ser� permitida a inclus�o atrav�s do estorno do pedido")

				Case(ALTERA)

					MsgAlert("Registro indispon�vel para manuten��o!")

			EndCase

	EndCase
	
Return


//--------------------------------------------------------------
/*/{Protheus.doc} ConfEst
Description //Validacao para verificar se o ha produtos fora de linha no processo de estorno
@param xParam Parameter Description
@return xRet Return Description
@author  - Luis Artuso
@since 06/02/2020 /*/
//--------------------------------------------------------------
Static Function ConfEst()
	Local aArray	:= oGridIt:aCols
	Local nX		:= 0
	Local lFLinha	:= .F.
	
	Do While (++nX <= Len(aArray)) .AND. (!lFLinha) 
	
		If ("SIM" $ aArray[nX,12] )
		
			lFLinha	:= .T.	
		
		EndIf
	
	EndDo

	If (lFLinha) 
		If (__cUserId $ superGetMv("KH_USBLQAG", .T., "000000", )) //Por excecao, somente usuarios cadastrados neste parametro poderao prosseguir com o estorno.
			staticCall(TMK150EXC,fAltPed,cMsfilEst,cPedidoEst,.T.)
			faTuDtZK0(cPedidoEst,stod('99910909') , .T.)
		Else
			Aviso("ESTORNO INV�LIDO" , "N�o � poss�vel prosseguir com o estorno, pois constam produtos fora de linha no pedido. Entre em contato com o gestor da �rea")
		EndIf
	Else	
		staticCall(TMK150EXC,fAltPed,cMsfilEst,cPedidoEst,.T.)
		faTuDtZK0(cPedidoEst,stod('99910909') , .T.)
	EndIf
Return