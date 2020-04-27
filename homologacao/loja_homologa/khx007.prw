#include "rwmake.ch"
#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#INCLUDE "JPEG.CH"


#DEFINE ENTER (Chr(13)+Chr(10))

#Define BTN_WIDTH   	32//16 // Largura dos botoes do calendario			 	
#Define BTN_L_WIDTH   	26//10 // Largura dos botoes laterais
#Define WEEK_DAYS     	{'dom','seg','ter','qua','qui','sex','sab'}
#Define MOVE_LEFT  		1
#Define MOVE_RIGHT 		2     

//-----------------------------
// CSS dos Botoes
//-----------------------------
// Padrão
#Define CSS_DEFAULT   "TButton{ background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #f0f2f3, stop: 1 #eceff0); } "+;  
                      "TButton{ border-bottom: 3px solid #cdd2e0; } TButton{ font: bold 12px arial; color: #525455; } "
// Fim de semana
#Define CSS_WE        "TButton{ background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #f0f2f3, stop: 1 #eceff0); } "+;  
                      "TButton{ border-bottom: 3px solid #cdd2e0; } TButton{ font: bold; color: #A5A5A5;} "
// Pressionado
#Define CSS_DOWN      "TButton{ background-color: #FEFEFE; } TButton{ border: 1px solid #DDDDDD; } "+;
                      "TButton{ border-bottom: transparent; } TButton{ font: bold 12px arial; color: #2A97BE; } "
// Botoes laterais                 
#Define CSS_LATERAL   "TButton{ background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #f0f2f3, stop: 1 #eceff0);  } "+;  
             	      "TButton{ border: 1px solid #cdd2e0; border-bottom: 3px solid #cdd2e0; } " 
// Separador de meses
#Define CSS_SEPARATOR "TButton{ border-left: 2px solid silver; }"		                     

//-------------------------------------------------------------------
// Funcao de teste para uso da classe
//-------------------------------------------------------------------


user function KHX007()
	
    Local dDateGet := Date()
    Local aSize := MsAdvSize()
    Local cTitle := "Retorno Ao Cliente"
    Local bRefresh:= {|| oCalend:carregaProduto(oCalend:dDate) }
    Local nMilissegundos := 10000 // Disparo será de 20 em 20 segundos
	Local aButtons := {}
	local aInfocab :={}
	local nQtd := 0
	local cChamado :=SPACE(6)
	local cPedido := SPACE(6)
	local oMV_PAR07
	Private lEst := .F. 
	Private oTimer
	//Private aItems1:= {'','Item1','Item2','Item3'}
	SET DATE BRITISH
    __SetCentury("ON")
    
    DEFINE FONT oFont11 NAME "Arial" SIZE 0, -11 BOLD
        	
	DEFINE MSDIALOG oDlg FROM 0,0 TO aSize[6],aSize[5] TITLE cTitle Of oMainWnd PIXEL           
    oTimer := TTimer():New(nMilissegundos, {|| bRefresh }, oDlg )   
	oMsgBar  := TMsgBar():New(oDlg,,,,,, RGB(116,116,116),,,.F.)
    oMsgItem := TMsgItem():New( oMsgBar, "Selecionada: " + DtoC( Date() ), 120,,,,.T., {|| oCalend:fDate(dDateGet) } )
    oTButton1 := TButton():New( 037, aSize[3]-060, "Call Center",oDlg,{||U_KMTMKA01()}, 060,10,,,.F.,.T.,.F.,,.F.,,,.F.)
    oTButton2 := TButton():New( 037, aSize[3]-125, "Novo Agendamento",oDlg,{||U_AGEND()}, 060,10,,,.F.,.T.,.F.,,.F.,,,.F.)
    oTButton3 := TButton():New( 037, aSize[3]-190, "Monitor de Clientes",oDlg,{||U_SYTMOV06()}, 060,10,,,.F.,.T.,.F.,,.F.,,,.F.)
    @  037,001 Say  oSay Prompt 'Chamado:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oDlg Pixel
	@  037,030  MSGet oMV_PAR07	Var cChamado		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  050, 05 When .T.	Of oDlg 
    @  037,080 Say  oSay Prompt 'Pedido:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oDlg Pixel
	@  037,102  MSGet oMV_PAR08	Var cPedido		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  050, 05 When .T.	Of oDlg 
    oTButton4 := TButton():New( 037, 155, "Pesquisar",oDlg,{||oCalend:carregaProduto(oCalend:dDate,cChamado,cPedido)}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F.)
       // Usando New
    //cCombo1:= aItems1[1]
    //oCombo1 := TComboBox():New(035, aSize[3]-430,{|u|if(PCount()>0,cCombo1:=u,cCombo1)},aItems1,100,20,oDlg,,{||Alert('Mudou item da combo')},,,,.T.,,,,,,,,,'cCombo1')
    oCalend := CALENDBAR07():New( oDlg, 0, 0, 200, 30, {|dDate| oMsgItem:SetText( "Selecionada: " + DtoC( dDate ) ) }, Date() )
    oCalend:Align := CONTROL_ALIGN_TOP
        
    OBrwItens := TwBrowse():New(050, 000, aSize[3], aSize[4]-75,, {;
																'-',;
																'Pedido Site',;
																'Data PV',;
																'Hora Pv',;
																'CodKit',;
                                                                'Pedido',;
                                                                'Itens_PV',;
                                                                'CT_Receber',;    
                                                                'CT_Pagar',;
                                                                'Orcamento',;                        
                                                                'Itens_orc',;
                                                                'For_pag';                       
                                                                },,oDlg,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
                                                                
                               
      
    OBrwItens:bLDblClick := {|| fSetOPeracao(OBrwItens:nColPos,oCalend:aItens[OBrwItens:nAt])  }                                                            
    oCalend:carregaProduto(dDateGet)
    oCalend:Activate()
    SetKey(VK_F4, {|| processa( {|| fExcel(oCalend:aItens,cTitle+" Data - "+dtoc(oCalend:dDate), "Aguarde...", "Gerando Dados...", .f.) })})
	SetKey(VK_F5, {|| processa( {|| oCalend:carregaProduto(oCalend:dDate), "Aguarde...", "Atualizando Dados...", .f. })})
    SetKey(VK_F3, {|| zLegenda(),.f.})
	Activate Dialog oDlg Centered 
	
return

//-------------------------------------------------------------------
// Barra de Calendario 
//-------------------------------------------------------------------
Class CALENDBAR07 From TPanel
	
    DATA dDate		// Data selecionada
	DATA aButtons	// Vetor com os botoes do calendario
	DATA oBtnPanel	// Container dos botoes
	DATA oBtnSelect	// Botao selecionado
	DATA bClickDate	// bloco de código de selecao da data
	DATA OBrwItens  // TwBrowse
	DATA aItens 
	DATA cLabelcep
	DATA cLabelRegiao
	DATA nlabelVis
	
	Method New()
	Method Activate()
	Method ChangeDate()
	Method SetDate()
    Method fDate()
    Method carregaProduto()
    
Endclass

//-------------------------------------------------------------------
// Construtor
//-------------------------------------------------------------------
Method New( oWnd, nRow, nCol, nWidth, nHeight, bClickDate, dDate ) Class CALENDBAR07

    :Create( oWnd, nRow, nCol,,,,,,, nWidth, nHeight )
    
    Local oBtnLeft, oBtnRight 

	::aButtons := {}
	::bClickDate := bClickDate
	::dDate := dDate
	::cLabelcep := ''
	::cLabelRegiao:= ''
	::nlabelVis:= 0
	// Botao esquerdo
	oBtnLeft := TButton():Create( self ,0,0,"<", {|| ::ChangeDate(MOVE_LEFT, 1) },BTN_L_WIDTH,10,,,,.T.,,,,,,)
	oBtnLeft:Align  := CONTROL_ALIGN_LEFT
	oBtnLeft:lCanGotFocus := .F.
	oBtnLeft:SetCss(CSS_LATERAL)
	
	// Container dos botoes do calendario
	::oBtnPanel := TPanel():New( ,,, self,,,,,, 0, 0 , .F. , .F. )
	::oBtnPanel:Align := CONTROL_ALIGN_ALLCLIENT
	::oBtnPanel:SetCss( "border:fake" ) 
	
	// Botao direito	
	oBtnRight := TButton():Create( self ,0,0,">", {|| ::ChangeDate(MOVE_RIGHT, 1) },BTN_L_WIDTH,10,,,,.T.,,,,,,)
	oBtnRight:Align  := CONTROL_ALIGN_RIGHT
	oBtnRight:lCanGotFocus := .F.
	oBtnRight:SetCss(CSS_LATERAL)
	
Return

//-------------------------------------------------------------------
// Constroi/Reconstroi calendario
//-------------------------------------------------------------------
Method Activate() Class CALENDBAR07

    Local dDate, cDayW, nDay
    Local nWidTotal := 0 
    Local nLen := Len( ::aButtons )
    Local nX
    Local nAlign
	
	::setUpdatesEnable(.F.) // Desabilita pintura

	// Deleta botoes anteriores
	For nX := 1 to nLen	
		FreeObj( ::aButtons[nX] )
	next nX
	::aButtons := {}	
	
	// Realinhamento eh necessario para recalculo da largura do container de botoes
	nAlign := ::Align
	::Align := CONTROL_ALIGN_NONE
	::ReadClientCoors()
	::Align := nAlign
	nWidTotal := (::nWidth-(BTN_L_WIDTH*4))/2
	
	// Define data inicial do primeiro botao a esquerda
	// mantendo a data selecionada o mais centralizada possivel 
	dDate := ::dDate - int( int( nWidTotal / BTN_WIDTH ) / 2 )
	
	// Inclui botoes enquanto houver espaco no container
	While ( nWidTotal >= BTN_WIDTH .Or. nWidTotal > 0 )
		nWidTotal -= BTN_WIDTH
		
		cDayW := WEEK_DAYS[ DoW( dDate ) ]  
		nDay  := Day( dDate )

		oCALENDBTN07 := CALENDBTN07():New( ::oBtnPanel, cDayW +chr(10)+ cValToChar(nDay), dDate)
		oCALENDBTN07:Align  := CONTROL_ALIGN_LEFT
		oCALENDBTN07:dDate := dDate  
		oCALENDBTN07:setSelect(oCALENDBTN07, .F.)
		Aadd( ::aButtons, oCALENDBTN07 )

		// Ajusto o botao com a data selecionada
		if oCALENDBTN07:dDate == ::dDate
			::oBtnSelect = oCALENDBTN07
			::oBtnSelect:setSelect(::oBtnSelect, .T.)
		endif
		
		dDate++
	end       
	
	::setUpdatesEnable(.T.) // Reabilita pintura
	
Return

//-------------------------------------------------------------------
// Navegacao entre as datas através dos botões laterais
//-------------------------------------------------------------------
Method ChangeDate( nSide, nQtdDias ) Class CALENDBAR07

    Local nLen := Len( ::aButtons )
    Local nX
    Local lFocused := .F. 
    Local dDate, cDayW, nDay, oBtn
	
	::setUpdatesEnable(.F.) // Desabilita pintura
    
	if ( nSide == MOVE_LEFT ) 
		
		dDate 	 := ::aButtons[1]:dDate - nQtdDias   // Guarda a data do primeiro(-1) botao para delecao
		lFocused := ::aButtons[nLen]:lFocused // Guarda foco do ultimo botao a direita 	
		
		// Deleta ultimo botao do vetor
		FreeObj( ::aButtons[nLen] )
		aDel( ::aButtons, nLen )
		
		// Desloca todos botoes do vetor pra direita e desabilita o alinhamento
		// para criar o novo botao na primeira posicao a esquerda
		for nX := nLen to 2 step -1
			::aButtons[nX] := ::aButtons[nX-1]
			::aButtons[nX]:Align := CONTROL_ALIGN_NONE
		next nX 

		// Cria novo botao
		cDayW := WEEK_DAYS[ DoW( dDate ) ]  
		nDay := Day( dDate )
		oBtn := CALENDBTN07():New( ::oBtnPanel, cDayW +chr(10)+ cValToChar(nDay), dDate)
		oBtn:dDate := dDate
		oBtn:SetSelect(oBtn, .F.)
		::aButtons[1] := oBtn // Insere novo botao na primeira posicao do vetor
		
		// Realinha todos a esquerda
		for nX := 1 to nLen
			::aButtons[nX]:Align := CONTROL_ALIGN_LEFT
		next nX 

		// Seleciona botao ao cria-lo (se necessario), para que ele nunca saia da visualizacao
		if lFocused
			::aButtons[nLen]:Clicked()			
		endif
		
	else
		
		dDate    := ::aButtons[nLen]:dDate + nQtdDias // Guarda a data do ultimo(+1) botao para delecao
		lFocused := ::aButtons[1]:lFocused     // Guarda foco do primeiro botao a esquerda		 	
		
		// Deleta primeiro botao do vetor
		FreeObj( ::aButtons[1] )
		aDel( ::aButtons, 1 )

		// Cria novo botao
		cDayW := WEEK_DAYS[ DoW( dDate ) ]  
		nDay := Day( dDate )
		oBtn := CALENDBTN07():New( ::oBtnPanel, cDayW+chr(10)+cValToChar(nDay), dDate)
		oBtn:Align  := CONTROL_ALIGN_LEFT
		oBtn:dDate := dDate
		oBtn:SetSelect(oBtn, .F.)
		::aButtons[nLen] := oBtn // Insere novo botao na ultima posicao do vetor
		
		// Seleciona botao ao cria-lo (se necessario), para que ele nunca saia da visualizacao
		if lFocused
			::aButtons[1]:Clicked()			
		endif
		
	endif
	
	::setUpdatesEnable(.T.) // Reabilita pintura
	
Return

//-------------------------------------------------------------------
// Define data atual
//-------------------------------------------------------------------
Method SetDate( dDate ) Class CALENDBAR07

	if ::dDate != dDate
		eval(::bClickDate, dDate)
		::dDate := dDate
		::Activate()
	endif

Return  

//-------------------------------------------------------------------
// Botoes do CALENDBAR07
//-------------------------------------------------------------------
Class CALENDBTN07 From TButton
	DATA dDate
	DATA lFocused
	DATA oFather
	
	Method New()
	Method Clicked()
	Method SetSelect()
Endclass

//-------------------------------------------------------------------
// Construtor
//-------------------------------------------------------------------
Method New( oWnd, cStr, dDate) Class CALENDBTN07

    :Create( oWnd,0,0,cStr,,BTN_WIDTH,20,,,,.T.,,DtoC(dDate))

	::lFocused 		:= .F.
	::oFather 		:= ::oParent:oParent
	::lCanGotFocus 	:= .F. // Inibe foco
	::blClicked 	:= {|| ::Clicked() }

Return

//-------------------------------------------------------------------
// Evento de Clique no botão
//-------------------------------------------------------------------
Method Clicked() Class CALENDBTN07

	// Impede disparo desnecessario
	if ::oFather:dDate != ::dDate

		// Dispara cloco de codigo do Pai
		eval(::oFather:bClickDate, ::dDate)
		::oFather:dDate := ::dDate

		// Retira selecao do botao anterior
		if ::oFather:oBtnSelect != NIL
			::SetSelect(::oFather:oBtnSelect, .F.)
		endif

		// Atualiza botao selecionado no componente Pai
		::oFather:oBtnSelect = self
		
		// Aplica css no botao indicando que foi pressionado
		::SetSelect(self, .T.)
	    
        oCalend:carregaProduto(::dDate)
        
    endif 
	
Return

//-------------------------------------------------------------------
// Define Status e CSS do botao
//-------------------------------------------------------------------
Method SetSelect(oCalButton, lSelect) Class CALENDBTN07

    local cCSS := ""

	if lSelect
		oCalButton:lFocused := .T.
		cCSS := CSS_DOWN 
	else
		oCalButton:lFocused := .F.
		cCSS := iif(isWeekEnd(oCalButton:dDate), CSS_WE, CSS_DEFAULT)
	endif

	oCalButton:SetCss( cCSS + iif(Day(oCalButton:dDate)==1, CSS_SEPARATOR, '' ) )
return

//-------------------------------------------------------------------
// Retorna .T. caso data seja fim de semana
//-------------------------------------------------------------------
Static Function isWeekEnd(dDate)
    
    Local nWeekDay := Dow(dDate)

return (nWeekDay==1 .Or. nWeekDay==7)

//-------------------------------------------------------------------
// Seleciona a data para o posicionamento
//-------------------------------------------------------------------
Method fDate() Class CALENDBAR07

    Local oTexto
    Local oData
    Local ddData := Date()
    Local oBtnConfirm
    Local lOk

    Static oDlgDate

    DEFINE MSDIALOG oDlgDate TITLE "KOMFORT HOUSE" FROM 000, 000  TO 085, 150 COLORS 0, 16777215 PIXEL

    @ 002, 002 SAY oTexto PROMPT "Selecione a data desejada." SIZE 070, 007 OF oDlgDate COLORS 225, 16777215 PIXEL
    @ 013, 002 MSGET oData VAR ddData SIZE 069, 010 OF oDlgDate COLORS 0, 16777215 PIXEL
    @ 027, 002 BUTTON oBtnConfirm PROMPT "Confirmar" SIZE 069, 012 OF oDlgDate ACTION {|| lOk:=.T., oDlgDate:end() } PIXEL
    oBtnConfirm:setCSS("QPushButton{color: #FFFFFF; border: 1px solid #6B8E23; border-radius: 4px; background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #008000, stop: 1 #00FF7F);} QPushButton:pressed {background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #00FF7F, stop: 1 #008000);}")

    ACTIVATE MSDIALOG oDlgDate CENTERED

    if lOk
        oCalend:SetDate(ddData)
    	oCalend:carregaProduto(ddData)
    endif
    
    oCalend:carregaProduto(ddData)
    
Return

//-------------------------------------------------------------------
// Carrega os itens na tela Pós venda
//-------------------------------------------------------------------
Method carregaProduto() Class CALENDBAR07
    
    Local _lStat := .T.
    Local cAlias :=  getNextAlias()
    Local cQuery := ""
    Local aItens := {}
	Local oSt1 := LoadBitmap(GetResources(),'BR_AZUL') //"Atendimento Planejado" --> Padrão
	Local oSt2 := LoadBitmap(GetResources(),'BR_VERMELHO')  //"Atendimento Pendente" --> Padrão
	Local oSt3 := LoadBitmap(GetResources(),'BR_VERDE') //"Atendimento Encerrado" --> Padrão
	Local oSt4 := LoadBitmap(GetResources(),'BR_PRETO') //"Atendimento Cancelado" --> Padrão
	Local oSt5 := LoadBitmap(GetResources(),'BR_AMARELO')  //"Em Andamento" --> Customizado Komfort
	Local oSt6 := LoadBitmap(GetResources(),'BR_LARANJA') //"Visita Tec" --> Customizado Komfort
	Local oSt7 := LoadBitmap(GetResources(),'BR_PINK') //"Devolucao" --> Customizado Komfort
	Local oSt8 := LoadBitmap(GetResources(),'BR_BRANCO') //"Retorno" --> Customizado Komfort
	Local oSt9 := LoadBitmap(GetResources(),'BR_VIOLETA')  //"Troca Aut" --> Customizado Komfort
	local oSt10 := LoadBitmap(GetResources(),'BR_CINZA') //"Compartilhamento" --> Padrão
    Local oSt11 := LoadBitmap(GetResources(),'BR_AZUL_CLARO')  // Email Fabricante --> Customizado Komfort
	Local oStatus 
	
	
	
	dbSelectArea("Z12")
	cQuery := " SELECT DISTINCT Z12_PEDERP AS PEDIDO_SITE, Z12_DTINC AS DATA_PV, Z12_HRINT AS HORA_PV,C6_DTAGEND AS DTAGEND," +ENTER	
	cQuery += " CASE WHEN C5_NOTA <> '' THEN 'SIM' WHEN ISNULL(CONVERT(VARCHAR,C5_NUM),'')='' THEN 'NAO' END FATURADO, Z12_PRODUT AS CODKIT, " +ENTER
	cQuery += " CASE WHEN C5_NUM <> '' THEN 'INTEGRADO' WHEN ISNULL(CONVERT(VARCHAR,C5_NUM),'')='' THEN 'NAO_INTEGRADO' END    PEDIDO, " +ENTER
	cQuery += " CASE WHEN C6_NUM <> '' THEN 'INTEGRADO' WHEN ISNULL(CONVERT(VARCHAR,C6_NUM),'')='' THEN 'NAO_INTEGRADO' END  ITENS_PV, " +ENTER
	cQuery += " CASE WHEN E1_NUM <> '' THEN 'INTEGRADO' WHEN ISNULL(CONVERT(VARCHAR,E1_NUM),'')='' THEN 'NAO_INTEGRADO' END CT_RECEBER, " +ENTER
	cQuery += " CASE WHEN E2_NUM <> '' THEN 'INTEGRADO' WHEN ISNULL(CONVERT(VARCHAR,E2_NUM),'')='' THEN 'NAO_INTEGRADO' END   CT_PAGAR, " +ENTER
	cQuery += " CASE WHEN UA_NUM <> '' THEN 'INTEGRADO' WHEN ISNULL(CONVERT(VARCHAR,UA_NUM),'')='' THEN 'NAO_INTEGRADO' END  ORCAMENTO, " +ENTER
	cQuery += " CASE WHEN UB_NUM <> '' THEN 'INTEGRADO' WHEN ISNULL(CONVERT(VARCHAR,UB_NUM),'')='' THEN 'NAO_INTEGRADO' END  ITENS_ORC, " +ENTER
	cQuery += " CASE WHEN L4_NUM <> '' THEN 'INTEGRADO' WHEN ISNULL(CONVERT(VARCHAR,L4_NUM),'')='' THEN 'NAO_INTEGRADO'  END     FOR_PAG " +ENTER
	cQuery += " FROM Z12010(NOLOCK) Z12 " +ENTER
	cQuery += " LEFT JOIN SC5010(NOLOCK) SC5 ON  Z12.Z12_PEDERP = SC5.C5_NUM  AND Z12.D_E_L_E_T_ = '' AND SC5.D_E_L_E_T_ = '' " +ENTER
	cQuery += " LEFT JOIN SC6010(NOLOCK) SC6 ON SC6.C6_NUM = SC5.C5_NUM AND SC6.D_E_L_E_T_ = '' " +ENTER
	cQuery += " LEFT JOIN SE1010(NOLOCK) SE1 ON SE1.E1_NUM = SC6.C6_NUM AND SE1.D_E_L_E_T_ = '' " +ENTER
	cQuery += " LEFT JOIN SE2010(NOLOCK) SE2 ON SE2.E2_NUM = SE1.E1_NUM AND SE2.D_E_L_E_T_ = '' " +ENTER
	cQuery += " LEFT JOIN SUA010(NOLOCK) SUA ON SUA.UA_NUM = SC5.C5_NUMTMK AND SUA.UA_FILIAL = '0142' AND SUA.UA_CANC = '' " +ENTER
	cQuery += " LEFT JOIN SUB010(NOLOCK) SUB ON SUB.UB_NUM = SUA.UA_NUM AND SUB.UB_FILIAL = '0142' AND SUB.D_E_L_E_T_ = '' " +ENTER
	cQuery += " LEFT JOIN SL4010(NOLOCK) SL4 ON SL4.L4_NUM = SUB.UB_NUM AND SL4.L4_FILIAL = '0142' AND SL4.D_E_L_E_T_ = '' " +ENTER
	cQuery += " WHERE Z12.D_E_L_E_T_ = '' AND SUA.UA_CANC = '' ORDER BY Z12_PEDERP " +ENTER
	

	
	
	
	PLSQuery(cQuery, cAlias)
	
	while (cAlias)->(!eof())
		_lStat := .T.
		Do Case
            Case (cAlias)->PEDIDO == "NAO_INTEGRADO" 
                _lStat := .F.
            Case fValSc6((cAlias)->PEDIDO_SITE,(cAlias)->CODKIT)== 2
             	 _lStat := .F.
            Case (cAlias)->CT_RECEBER == "NAO_INTEGRADO" 
                _lStat := .F.
            Case (cAlias)->CT_PAGAR ==   "NAO_INTEGRADO" 
                _lStat := .F.
            Case (cAlias)->ORCAMENTO ==  "NAO_INTEGRADO" 
                _lStat := .F.
            Case (cAlias)->ITENS_ORC == "NAO_INTEGRADO" 
                _lStat := .F.
            Case (cAlias)->FOR_PAG ==    "NAO_INTEGRADO" 
                _lStat := .F.
        EndCase
		
	
	 aAdd(aItens,{  iif(_lStat ,oSt1,oSt2)    ,;	                        //1
						(cAlias)->PEDIDO_SITE ,;	//2
						(cAlias)->DATA_PV    ,;     //3
						(cAlias)->HORA_PV    ,;     //4
						(cAlias)->DTAGEND     ,;     //5
						(cAlias)->FATURADO     ,;     //5
						(cAlias)->CODKIT     ,;     //5
						(cAlias)->PEDIDO     ,;	    //6
	 iif (fValSc6((cAlias)->PEDIDO_SITE,(cAlias)->CODKIT)== 1 ,(cAlias)->ITENS_PV ,"NAO_INTEGRADO")  ,;     //7
						(cAlias)->CT_RECEBER ,;	    //7
						(cAlias)->CT_PAGAR   ,;	    //8
						(cAlias)->ORCAMENTO  ,; 	//9
						(cAlias)->ITENS_ORC  ,; 	//10
						(cAlias)->FOR_PAG ;			//11
						})	//11
						 						
	 (cAlias)->(dbskip())		
	end
	
	(cAlias)->(dbCloseArea())
    
    if len(aItens) <= 0
	aAdd(aItens,{"","",ctod("//"),"","",ctod("//"),"","","","","","",""})
    endif
    
    
    OBrwItens:SetArray(aItens)
    
    ::aItens := aItens

    OBrwItens:bLine := {|| {    aItens[OBrwItens:nAt,01] ,;
        						aItens[OBrwItens:nAt,02] ,;  
                                aItens[OBrwItens:nAt,03] ,;
                                aItens[OBrwItens:nAt,04] ,;
                                aItens[OBrwItens:nAt,05] ,;
                                aItens[OBrwItens:nAt,06] ,;
                                aItens[OBrwItens:nAt,07] ,;
                                aItens[OBrwItens:nAt,08] ,;
                                aItens[OBrwItens:nAt,09] ,;
                                aItens[OBrwItens:nAt,10] ,;
                                aItens[OBrwItens:nAt,11] ,;
                                aItens[OBrwItens:nAt,12] ,;
                                aItens[OBrwItens:nAt,13] ;
                                }}
    
    OBrwItens:refresh()

Return




   
Static Function fExcel(aItens, cTitle)

	Local oExcel := FWMsExcel():New()
    Local cArqTemp := GetTempPath() + "Retorno"+substr(time(), 7, 2)+".XLS"
	Local aFields := {"UC_STATUS","UD_CODIGO","C5_NUM","X5_DESCRI","U9_DESC","UD_XUSER","U7_NOME","UC_XTPERRO","UC_XSATISF","C5_EMISSAO","A1_NOME", "A3_NOME","UC_XFOLLOW","UC_XSTATUS"}
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
		elseif aCab[nx][8] == "D" // Tipo Data
			oExcel:AddColumn(cNamePlan,cNameTable,aCab[nx][1],1,3)			
		else
			oExcel:AddColumn(cNamePlan,cNameTable,aCab[nx][1],1,1)
		endif
	next nx

    for nx := 1 to len(aItens) 
	   	oExcel:AddRow(cNamePlan,cNameTable,{;
	   										iif(aItens[nx][1]=='2 ',"Pendente"," "),;
											aItens[nx][2],;
                                            aItens[nx][11],;
											aItens[nx][4],;
                                            aItens[nx][5],;
                                            aItens[nx][6],;
                                            aItens[nx][7],;
                                            aItens[nx][8],;
                                            iif(aItens[nx][13]=='1',"Ótimo",;
                                            iif(aItens[nx][13]=='2',"Bom",; 
                                            iif(aItens[nx][13]=='3',"Regular",; 
                                            iif(aItens[nx][13]=='5',"Ruim","")))),;    
                                            aItens[nx][10],;
                                            aItens[nx][3],;
                                            aItens[nx][12],;
                                            aItens[nx][9],;
                                            aItens[nx][14];  
											},{1,2,3,4,5,6,7,8,9,10,11,12,13,14})
	next nx
    

	oExcel:Activate()
	oExcel:GetXMLFile(cArqTemp)
	ShellExecute("open", cArqTemp, "", "C:\", 1 )
	
Return

Static Function zLegenda()
    
    Local aLegenda := {}
     
    //Monta as legendas (Cor, Legenda)
  
    aAdd(aLegenda,{"BR_VERMELHO",   "Retorno Pendente"})
 
     
    //Chama a função que monta a tela de legenda
    BrwLegenda("STATUS CHAMADO", "Status Chamado", aLegenda) 
    
Return  

Static function fValSc6(cNum,cNumKit)

local cQuery := ""
Local cQryc6 := ""
Local cAliazkc := getNextAlias()
Local cAliaSc6 := getNextAlias()
local nRowsb1 :=  0
local nRowsC6 :=  0
Local nRet := 0

dbSelectArea("ZKC")
cQuery := " SELECT COUNT(B1_COD) AS QTDKIT FROM ZKC010 (NOLOCK)  ZKC INNER JOIN ZKD010 (NOLOCK) ZKD ON ZKD_FILIAL = ''  "
cQuery += " AND ZKD_CODPAI = ZKC_CODPAI AND ZKD.D_E_L_E_T_ = '' INNER JOIN SB1010 (NOLOCK) SB1 ON B1_FILIAL = '  '  " 
cQuery += " AND B1_COD = ZKD_CODFIL AND SB1.D_E_L_E_T_ = '' WHERE ZKC_FILIAL = '' AND ZKC_SKU= '"+cNumKit+"' AND ZKC.D_E_L_E_T_ = ' ' "

PLSQuery(cQuery, cAliazkc)

while (cAliazkc)->(!eof())
	nRowsb1 := (cAlias)->(QTDKIT)
	(cAliazkc)->(dbskip())
End

dbSelectArea("SC6")
cQryc6 := " SELECT  COUNT(C6_PRODUTO) AS PRODUTO FROM SC5010(NOLOCK) SC5 "
cQryc6 += " INNER JOIN SC6010(NOLOCK) SC6 ON C5_NUM = C6_NUM  "
cQryc6 += " WHERE C6_NUM = '"+cNum+"' AND SC6.D_E_L_E_T_ = '' "


PLSQuery(cQryc6, cAliaSc6)

while (cAliaSc6)->(!eof())
		nRowsC6 := (cAlias)->(PRODUTO)
	(cAliaSc6)->(dbskip())
End
	
	if nRowsb1 == nRowsC6
		nRet := 1
	Else
		nRet := 2
	EndIf

(ZKC)->(DbCloseArea())	
(SC6)->(DbCloseArea())	
return nRet




//--------------------------------------------------------------
/*/{Protheus.doc} fSetOperacao
Description //Define a ação com base na coluna clicada
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul
@since 11/02/2019 /*/
//--------------------------------------------------------------
Static Function fSetOPeracao(nColuna,_array)

Do Case

Case nColuna == 1 //Status

Case nColuna == 2 //Pedido_site
processa( {|| fInfocobr(_array) }, "Aguarde...", "Localizando Histórico...", .f.)
Case nColuna == 3 //data do pv

Case nColuna == 4 //hora do pv

Case nColuna == 5 //codigo do kit
processa( {|| findKit(_array) }, "Aguarde...", "Localizando kit...", .f.)
Case nColuna == 6 //Pedido

Case nColuna == 7 //itens pv
processa( {|| findItPv(_array) }, "Aguarde...", "Localizando Titulos...", .f.)
Case nColuna == 8 //Contas a receber

Case nColuna == 9 //Contas a pagar

Case nColuna == 10 //Orçamento

Case nColuna == 11 //Itens Orçamento

Case nColuna == 12 //Forma de pagamento
If MSGYESNO( "Deseja Ajustar as formas de PAgamento", "Ajuste Formas" )
 processa( {|| fGerSl4(_array) }, "Aguarde...", "Localizando Titulos...", .f.)
Endif

EndCase

Return

//--------------------------------------------------------------
/*/{Protheus.doc} findKit
Description //Trás todos os produtos do kit
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul
@since 11/02/2019 /*/
//--------------------------------------------------------------


Static Function findKit(_array)                        

Local cQuery := ""	
Local _cCod := ""
Local _cDesc := ""
Local cAlias := GetNextAlias()
Local oTela
Local 	aProd := {}
Private oBrwPro

DEFINE MSDIALOG oTela FROM 0,0 TO 200,600 TITLE "Produtos do kit" Of oMainWnd PIXEL
        
    oBrwPro := TwBrowse():New(005, 005, 445, 220,, {;
                                                    'Codigo',;
                                                    'Descrição',;
                                                    },,oTela,,,,,,,,,,,, .F.,, .T.,, .T.,,,)

dbSelectArea("ZKC")
cQuery := " SELECT B1_COD,B1_DESC FROM ZKC010 (NOLOCK)  ZKC INNER JOIN ZKD010 (NOLOCK) ZKD ON ZKD_FILIAL = ''  "
cQuery += " AND ZKD_CODPAI = ZKC_CODPAI AND ZKD.D_E_L_E_T_ = '' INNER JOIN SB1010 (NOLOCK) SB1 ON B1_FILIAL = '  '  " 
cQuery += " AND B1_COD = ZKD_CODFIL AND SB1.D_E_L_E_T_ = '' WHERE ZKC_FILIAL = '' AND ZKC_SKU= '"+_array[5]+"' AND ZKC.D_E_L_E_T_ = ' ' "

PLSQuery(cQuery, cAlias)

while (cAlias)->(!eof())

	aAdd(aProd,{(cAlias)->(B1_COD),;
	            (cAlias)->(B1_DESC);
	})
	(cAlias)->(dbskip())
End
(cAlias)->(DbCloseArea())
  oBrwPro:SetArray(aProd)
    
    oBrwPro:bLine := {||{     aProd[oBrwPro:nAt,01] ,; 
                              aProd[oBrwPro:nAt,02] ;
                            }}
    
    oBrwPro:Refresh()



ACTIVATE MSDIALOG oTela CENTERED

	

Return


//--------------------------------------------------------------
/*/{Protheus.doc} findKit
Description //Trás todos os produtos do kit
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul
@since 11/02/2019 /*/
//--------------------------------------------------------------


Static Function findItPv(_array)                        

Local cQuery := ""	
Local _cCod := ""
Local _cDesc := ""
Local cAlias := GetNextAlias()
Local oTela
Local 	aProd := {}
Private oBrwPro

DEFINE MSDIALOG oTela FROM 0,0 TO 200,600 TITLE "Itens do Pedido" Of oMainWnd PIXEL
        
    oBrwPro := TwBrowse():New(005, 005, 445, 220,, {;
                                                    'Codigo',;
                                                    'Descrição',;
                                                    },,oTela,,,,,,,,,,,, .F.,, .T.,, .T.,,,)

dbSelectArea("SC6")
cQuery := " SELECT C6_PRODUTO,C6_DESCRI  FROM SC5010(NOLOCK) SC5 "
cQuery += " INNER JOIN SC6010(NOLOCK) SC6 ON C5_NUM = C6_NUM  "
cQuery += " WHERE C6_NUM = '"+_array[2]+"' AND SC6.D_E_L_E_T_ = '' "


PLSQuery(cQuery, cAlias)

while (cAlias)->(!eof())

	aAdd(aProd,{(cAlias)->(C6_PRODUTO),;
	            (cAlias)->(C6_DESCRI);
	})
	(cAlias)->(dbskip())
End
(cAlias)->(DbCloseArea())
  oBrwPro:SetArray(aProd)
    
    
    oBrwPro:bLine := {||{     aProd[oBrwPro:nAt,01] ,; 
                              aProd[oBrwPro:nAt,02] ;
                            }}
    
    oBrwPro:Refresh()



ACTIVATE MSDIALOG oTela CENTERED

	

Return

//--------------------------------------------------------------
/*/{Protheus.doc} findKit
Description //CRIA A SL4 APARTIR DA SE1
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul
@since 11/02/2019 /*/
//--------------------------------------------------------------


Static function fGerSl4(_array)

Local _lRet := .T.
Local nFormPag := 0
Local nQtdPar  := 0
LocaL nPos     := 0
Local nPosOper := 0
Local cAlias := GetNextAlias()
Local aOpera   := {}




aAdd(aOpera,{1,"American Express"})
aAdd(aOpera,{3,"Bradesco"})
aAdd(aOpera,{4,"Dinners"})
aAdd(aOpera,{8,"MasterCard"})
aAdd(aOpera,{9,"Visa"})
aAdd(aOpera,{41,"ELO"})
								
cQuery := " SELCT E1_NUMSUA,E1_EMISSAO,E1_VALOR,E1_TIPO,E1_DOCTEF,E1_PARCELA " + ENTER
cQuery += " FROM "+RetSqlName("SE1")+"(NOLOCK) WHERE E1_NUM = '"+_array[2]+"' AND D_E_L_E_T_ = '' AND E1_FILORIG = '0142' " + ENTER 


DbSelectArea("Z12")
Z12->(dbSetOrder(1))//E4_FILIAL+E4_CODIGO
if Z12->(DbSeek(xFilial()+_array[2]))
 nFormPag := Z12->Z12_PAGECO
 nQtdParc  := Z12->Z12_QTDPAR
 cAutoriz := Z12->Z12_AUTORI
 cCCID    := Z12->Z12_IDCART
endiF

if nFormPag == 1
	IF nQtdParc == 1
			cCodAd := "115"
	elseif nQtdParc > 1   .AND. nQtdParc <= 6
			cCodAd := "115"
	elseif nQtdParc > 6 .AND. nQtdParc <= 10
			cCodAd := "115"
	EndIf

elseif nFormPag == 2
	cCodAd := "116"
endif


DbSelectArea("SAE")
SAE->(dbSetOrder(1))//E4_FILIAL+E4_CODIGO

if SAE->(DbSeek(xFilial()+cCodAd))
	cPortado  := SAE->AE_XPORTAD
	cAdmins := SAE->AE_DESC
Endif


PLSQuery(cQuery, cAlias)

	iF EMPTY (cAlias->(E1_NUMSUA))
		MsgAlert("Para ajustar as Formas de Pagamento é necessário o ajuste do Contas a Receber Primeiro")
		_lRet := .F.
		Return _lRet
	EndIf

while (cAlias)->(!eof())
	
		DbSelectArea("SL4")
        SL4->(dbSetOrder(1))//L4_FILIAL, L4_NUM, L4_ORIGEM, R_E_C_N_O_, D_E_L_E_T_
		If SL4->(DbSeek(xFilial()+cAlias->(E1_NUMSUA)+"SITE"))
		SL4->(RecLock("SL4",.F.))
		Else
		SL4->(RecLock("SL4",.T.))
		EndIf	
		SL4->L4_FILIAL  := "0142"
		SL4->L4_NUM     := cAlias->(E1_NUMSUA)
		SL4->L4_DATA    := cAlias->(E1_EMISSAO)
		SL4->L4_VALOR   := cAlias->(E1_VALOR)
		SL4->L4_FORMA   := cAlias->(E1_TIPO)
		SL4->L4_ADMINIS := cAdmins//BUSCAR SAE
		SL4->L4_OBS     := "RAKUTEN PAY"
		SL4->L4_TERCEIR := .F.
		SL4->L4_AUTORIZ := cAlias->(E1_DOCTEF)
		SL4->L4_MOEDA   := 1
		SL4->L4_ORIGEM  := "SITE"
		SL4->L4_DESCMN  := 0
		SL4->L4_XFORFAT := "1"
		SL4->L4_XPARC   := cValToChar(nQtdParc)
		SL4->L4_XPARNSU := cAlias->(E1_PARCELA)
		SL4->L4_XNCART4 := Right(cCCID,4)//4 ULTIMOS CARTÃO 
		SL4->L4_XFLAG   := Iif(nPosOper > 0,aOpera[nPosOper][2],"")
		SL4->(MsUnlock())
	
	(cAlias)->(dbskip())
End
	(cAlias)->(DbCloseArea())
	Z12->(DbCloseArea())
    SL4->(DbCloseArea())	
    SAE->(DbCloseArea())
Return _lRet



