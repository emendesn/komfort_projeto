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
Function u_KHX001()

    Local dDateGet := Date()
    Local aSize := MsAdvSize()
    Local cTitle := "Entrada de Produto"
    Local bRefresh:= {|| oCalend:carregaItens(oCalend:dDate) }
    Local nMilissegundos := 10000 // Disparo será de 20 em 20 segundos
	
	Private oGetDoc
	Private cGetDoc := space(9)

	Private oGetPv
	Private cGetPv := space(6)

	Private oGetProduto
	Private cGetProduto := space(15)

	Private oGetDescri
	Private cGetDescri := space(100)
	
	Private oGetQtdRegs
	Private nGetQtdRegs := 0
	
	Private oGetQtdPedN
	Private nQtdPedN := 0
	
	Private oRadPedFat
	Private nProSN := 1
	
	Private oTimer

    SET DATE BRITISH
    __SetCentury("ON")
			
	//Define Dialog oDlg Title cTitle From 000,000 To aSize[6],aSize[5] Pixel COLORS 0, 16777215 PIXEL
    DEFINE MSDIALOG oDlg FROM 0,0 TO aSize[6],aSize[5] TITLE cTitle Of oMainWnd PIXEL
    oTimer := TTimer():New(nMilissegundos, {|| bRefresh }, oDlg )   
		
    oMsgBar  := TMsgBar():New(oDlg,,,,,, RGB(116,116,116),,,.F.)
    oMsgItem := TMsgItem():New( oMsgBar, "Selecionada: " + DtoC( Date() ), 120,,,,.T., {|| oCalend:fDate(dDateGet) } )
        
    oCalend := CalendBar():New( oDlg, 0, 0, 200, 30, {|dDate| oMsgItem:SetText( "Selecionada: " + DtoC( dDate ) ) }, Date() )
    oCalend:Align := CONTROL_ALIGN_TOP

    @ 035, 006 SAY oSayDoc PROMPT "Documento" SIZE 030, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 045, 006 MSGET oGetDoc VAR cGetDoc SIZE 050, 010 OF oDlg VALID {|| oCalend:carregaItens(oCalend:dDate) } COLORS 0, 16777215 PIXEL
	
	@ 035, 060 SAY oSayPv PROMPT "PV" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 045, 060 MSGET oGetPv VAR cGetPv SIZE 050, 010 OF oDlg VALID {|| oCalend:carregaItens(oCalend:dDate) } COLORS 0, 16777215 PIXEL
    
	@ 035, 115 SAY oSayProduto PROMPT "Produto" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 045, 115 MSGET oGetProduto VAR cGetProduto SIZE 100, 010 OF oDlg PICTURE "@!" VALID {|| oCalend:carregaItens(oCalend:dDate) } COLORS 0, 16777215 PIXEL

	@ 035, 220 SAY oSayDescri PROMPT "Descrição" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 045, 220 MSGET oGetDescri VAR cGetDescri SIZE 170, 010 OF oDlg PICTURE "@!" VALID {|| oCalend:carregaItens(oCalend:dDate) } COLORS 0, 16777215 PIXEL
    
    @ 048, 410 SAY oProduCPv PROMPT "Produtos C/ Pv" SIZE 060, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 042, 450 RADIO oRadPedFat VAR nProSN ITEMS "Sim","Nao" SIZE 45, 25 OF oDlg VALID {|| oCalend:carregaItens(oCalend:dDate) }  COLOR 0, 16777215 PIXEL
    
    @ 048, 510 SAY oSayRegs PROMPT "Reg Sim" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 045, 530 MSGET oGetQtdRegs VAR nGetQtdRegs SIZE 040, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
    
    @ 048, 580 SAY oSayRegs PROMPT "Reg Não" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 045, 600 MSGET oGetQtdPedN VAR nQtdPedN SIZE 040, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
    
    
    
    OBrwItens := TwBrowse():New(060, 000, aSize[3], aSize[4]-75,, {;
																'-',;
                                                                'Documento',;
                                                                'Pedido Venda',;
                                                                'Item',;
                                                                'Produto',;
                                                                'Descrição',;
                                                                'Quantidade',;
                                                                'Endereço',;
                                                                'Data endereçamento',;
                                                                '';
                                                                },,oDlg,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
    
    oCalend:carregaItens(dDateGet)
    
    oCalend:Activate()

	SetKey(VK_F4, {|| processa( {|| fExcel(oCalend:aItens, cTitle+ " Data - " + dtoc(oCalend:dDate), "Aguarde...", "Gerando Dados...", .f.) })})
	SetKey(VK_F5, {|| processa( {|| oCalend:carregaItens(oCalend:dDate), "Aguarde...", "Atualizando Dados...", .f. })})
	SetKey(VK_F6, {|| setTime(1) })
    SetKey(VK_F7, {|| setTime(2) })

    Activate Dialog oDlg Centered
	
Return                                            

//-------------------------------------------------------------------
// Barra de Calendario 
//-------------------------------------------------------------------
Class CalendBar From TPanel
	
    DATA dDate		// Data selecionada
	DATA aButtons	// Vetor com os botoes do calendario
	DATA oBtnPanel	// Container dos botoes
	DATA oBtnSelect	// Botao selecionado
	DATA bClickDate	// bloco de código de selecao da data
	DATA OBrwItens  // TwBrowse
	DATA aItens 

	Method New()
	Method Activate()
	Method ChangeDate()
	Method SetDate()
    Method fDate()
    Method carregaItens()

Endclass

//-------------------------------------------------------------------
// Construtor
//-------------------------------------------------------------------
Method New( oWnd, nRow, nCol, nWidth, nHeight, bClickDate, dDate ) Class CalendBar 

    :Create( oWnd, nRow, nCol,,,,,,, nWidth, nHeight )
    
    Local oBtnLeft, oBtnRight

	::aButtons := {}
	::bClickDate := bClickDate
	::dDate := dDate
	
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
Method Activate() Class CalendBar 

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
	
	//Define data inicial do primeiro botao a esquerda
	//mantendo a data selecionada o mais centralizada possivel 
	dDate := ::dDate - int( int( nWidTotal / BTN_WIDTH ) / 2 )
	
	// Inclui botoes enquanto houver espaco no container
	While ( nWidTotal >= BTN_WIDTH .Or. nWidTotal > 0 )
		nWidTotal -= BTN_WIDTH
		
		cDayW := WEEK_DAYS[ DoW( dDate ) ]  
		nDay  := Day( dDate )

		oCalendBtn := CalendBtn():New( ::oBtnPanel, cDayW +chr(10)+ cValToChar(nDay), dDate)
		oCalendBtn:Align  := CONTROL_ALIGN_LEFT
		oCalendBtn:dDate := dDate  
		oCalendBtn:setSelect(oCalendBtn, .F.)
		Aadd( ::aButtons, oCalendBtn )

		// Ajusto o botao com a data selecionada
		if oCalendBtn:dDate == ::dDate
			::oBtnSelect = oCalendBtn
			::oBtnSelect:setSelect(::oBtnSelect, .T.)
		endif
		
		dDate++
	end       
	
	::setUpdatesEnable(.T.) // Reabilita pintura
	
Return

//-------------------------------------------------------------------
// Navegacao entre as datas através dos botões laterais
//-------------------------------------------------------------------
Method ChangeDate( nSide, nQtdDias ) Class CalendBar 

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
		oBtn := CalendBtn():New( ::oBtnPanel, cDayW +chr(10)+ cValToChar(nDay), dDate)
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
		oBtn := CalendBtn():New( ::oBtnPanel, cDayW+chr(10)+cValToChar(nDay), dDate)
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
Method SetDate( dDate ) Class CalendBar 

	if ::dDate != dDate
		eval(::bClickDate, dDate)
		::dDate := dDate
		::Activate()
	endif

Return  

//-------------------------------------------------------------------
// Botoes do CalendBar 
//-------------------------------------------------------------------
Class CalendBtn From TButton
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
Method New( oWnd, cStr, dDate) Class CalendBtn

    :Create( oWnd,0,0,cStr,,BTN_WIDTH,20,,,,.T.,,DtoC(dDate))

	::lFocused 		:= .F.
	::oFather 		:= ::oParent:oParent
	::lCanGotFocus 	:= .F. // Inibe foco
	::blClicked 	:= {|| ::Clicked() }

Return

//-------------------------------------------------------------------
// Evento de Clique no botão
//-------------------------------------------------------------------
Method Clicked() Class CalendBtn

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
	    
        oCalend:carregaItens(::dDate)
    endif 
	
Return

//-------------------------------------------------------------------
// Define Status e CSS do botao
//-------------------------------------------------------------------
Method SetSelect(oCalButton, lSelect) Class CalendBtn

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
Method fDate() Class CalendBar

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
    	oCalend:carregaItens(ddData)
	endif
    
    //oCalend:carregaItens(ddData)

Return

//-------------------------------------------------------------------
// Carrega os itens na tela
//-------------------------------------------------------------------
Method carregaItens(_dData) Class CalendBar
    
    Local cAlias := ""
    Local cAliAju := ""
    Local cQuery := ""
    Local aItens := {}
    Local aRotina := {}
    Local dDtCorte := Ctod("18/06/2019")
	Local oSt1 	 := LoadBitmap(GetResources(),'BR_VERDE') //AGENDADO
	local oSt2 	 := LoadBitmap(GetResources(),'BR_VERMELHO') //NÃO AGENDADO
     
    
    if nProSN == 1
    
    nQtdPedN := 0
    
	dbSelectArea("SB1")

    cQuery := " SELECT  DB_DOC, C6_NUM, C6_ITEM, DB_PRODUTO,B1_DESC,C6_QTDVEN, DB_LOCALIZ, DB_DATA FROM SC6010 (NOLOCK) SC6 " + ENTER
    cQuery += " INNER JOIN SDB010 (NOLOCK) DB ON DB_PRODUTO=C6_PRODUTO AND DB_LOCAL=C6_LOCAL AND DB_LOCALIZ=C6_LOCALIZ " + ENTER
    cQuery += " INNER JOIN SB1010 (NOLOCK) B1 ON B1.B1_COD = DB.DB_PRODUTO " + ENTER
    cQuery += " WHERE DB_DATA='"+dtos(_dData)+"' AND SC6.D_E_L_E_T_='' AND SC6.C6_NOTA = ''  AND SC6.C6_BLQ <> 'R' " + ENTER	
	cQuery += " AND DB.D_E_L_E_T_='' AND B1.D_E_L_E_T_=''  AND DB_TM < '500' AND DB_LOCAL = '01' " +ENTER
	cQuery += " AND DB_LOCALIZ NOT IN ('9999', 'MOSTRUARIO', 'DEVOLUCAO') AND DB_ESTORNO <> 'S' AND DB_DOC <> ''" + ENTER
		 
	if !empty(alltrim(cGetDoc))
		cQuery += " AND DB_DOC = '"+ cGetDoc +"'"+ ENTER
	endif

	if !empty(alltrim(cGetPv))
		cQuery += " AND C6_NUM = '"+ cGetPv +"'"+ ENTER
	endif
	
	if !empty(alltrim(cGetProduto))
		cQuery += " AND DB_PRODUTO = '"+ cGetProduto +"'"+ ENTER
	endif

	if !empty(alltrim(cGetDescri))
		cQuery += " AND B1_DESC LIKE '%"+ alltrim(cGetDescri) +"%'"+ ENTER
	endif
    cQuery += " ORDER BY 1,2,3"+ ENTER
    
	cAlias := getNextAlias()

	PLSQuery(cQuery, cAlias)
	
    aItens := {}
	nGetQtdRegs := 0
									
    while (cAlias)->(!eof())
        
        aAdd(aItens,{ 	fStAgend((cAlias)->C6_NUM, (cAlias)->C6_ITEM, (cAlias)->DB_PRODUTO),;
						(cAlias)->DB_DOC,;
                        (cAlias)->C6_NUM,;
                        (cAlias)->C6_ITEM,;
                        (cAlias)->DB_PRODUTO,;
                        (cAlias)->B1_DESC,;
                        (cAlias)->C6_QTDVEN,;
                        (cAlias)->DB_LOCALIZ,;
                        (cAlias)->DB_DATA,;
                        "";
                    })
		
		nGetQtdRegs++

	(cAlias)->(dbSkip())
	end
	
	(cAlias)->(dbCloseArea())

    if len(aItens) == 0
        AAdd(aItens, {"","","","","","",0,"",ctod("//"),""})
    endif

    OBrwItens:SetArray(aItens)
	
	::aItens := aItens
    
	OBrwItens:bLine := {|| {    iif(aItens[OBrwItens:nAt,01]=='1',oSt1,oSt2) ,; 
                                aItens[OBrwItens:nAt,02] ,;
                                aItens[OBrwItens:nAt,03] ,;
                                aItens[OBrwItens:nAt,04] ,;
                                aItens[OBrwItens:nAt,05] ,;
                                aItens[OBrwItens:nAt,06] ,;
                                aItens[OBrwItens:nAt,07] ,;
                                aItens[OBrwItens:nAt,08] ,;
								aItens[OBrwItens:nAt,09] ,;
                                aItens[OBrwItens:nAt,10] ;
                        }}
    
	oGetQtdRegs:refresh()

    //OBrwItens:Align := CONTROL_ALIGN_ALLCLIENT

    OBrwItens:refresh()
    
    ElseIf nProSN == 2 .AND. _dData > dDtCorte
     nGetQtdRegs := 0

    
    /*
     cQuery := " SELECT  DB_DOC, DB_ITEM, DB_PRODUTO,DB_QUANT, DB_LOCALIZ, DB_DATA FROM SDB010 (NOLOCK) DB " + ENTER 
     cQuery += "  WHERE DB_DATA='"+dtos(_dData)+"' AND DB.D_E_L_E_T_='' AND DB_TM < '500' AND DB_LOCAL = '01' " + ENTER 
     cQuery += "  AND DB_LOCALIZ NOT IN ('9999', 'MOSTRUARIO', 'DEVOLUCAO') AND DB_ESTORNO <> 'S' AND DB_DOC <> '' "+ ENTER
     cQuery += "  AND DB_LOCALIZ NOT IN (SELECT C6_LOCALIZ FROM SC6010 (NOLOCK) WHERE D_E_L_E_T_ = ''AND C6_BLQ <> 'R' AND C6_NOTA = ''AND C6_LOCAL = '01'  ) "+ ENTER
     cAliAju := getNextAlias()
     PLSQuery(cQuery, cAliAju)  									
     while (cAliAju)->(!eof())
       U_KHAJUSAC((cAliAju)->DB_PRODUTO,(cAliAju)->DB_LOCALIZ,(cAliAju)->DB_DOC,(cAliAju)->DB_DATA)
	(cAliAju)->(dbSkip())
	end
	(cAliAju)->(dbCloseArea()) 
     */

   
     dbSelectArea("SDB")
     cQuery := " SELECT  DB_DOC, DB_ESTORNO,DB_ITEM,DB_PRODUTO,B1_DESC,DB_QUANT, DB_LOCALIZ,DB_DATA  FROM SDB010 (NOLOCK) DB " + ENTER
     cQuery += " INNER JOIN SB1010 (NOLOCK) B1 ON B1.B1_COD = DB.DB_PRODUTO " + ENTER
     cQuery += " WHERE DB_DATA ='"+dtos(_dData)+"' " + ENTER
     cQuery += " AND DB_TM < '500' " + ENTER
     cQuery += " AND DB_LOCAL = '01' " + ENTER
     cQuery += " AND DB_LOCALIZ NOT IN ('9999', 'MOSTRUARIO', 'DEVOLUCAO')" + ENTER
     cQuery += " AND DB.D_E_L_E_T_ = '' " + ENTER
     cQuery += " AND DB_ESTORNO <> 'S' " + ENTER
     cQuery += " AND DB_DOC <> ''" + ENTER
     cQuery += " AND DB_LOCALIZ  NOT IN (SELECT C6_LOCALIZ FROM SC6010 (NOLOCK) WHERE D_E_L_E_T_ = ''AND C6_BLQ <> 'R' AND C6_NOTA = ''AND C6_LOCAL = '01'  ) " + ENTER
    
    
    cAlias := getNextAlias()

	PLSQuery(cQuery, cAlias)
	
    aItens := {}
	nQtdPedN := 0

    while (cAlias)->(!eof())
        
        aAdd(aItens,{ 	 "2",;
						(cAlias)->DB_DOC,;
                        (cAlias)->DB_ESTORNO,;
                        (cAlias)->DB_ITEM,;
                        (cAlias)->DB_PRODUTO,;
                        (cAlias)->B1_DESC,;
                        (cAlias)->DB_QUANT,;
                        (cAlias)->DB_LOCALIZ,;
                        (cAlias)->DB_DATA,;
                        "",;
                        oSt2;
                    })
		
		nQtdPedN++
		
	(cAlias)->(dbSkip())
	end
	
	(cAlias)->(dbCloseArea())

    if len(aItens) == 0
        AAdd(aItens, {"","","","","","",0,"",ctod("//"),""})
    endif
    
    
     OBrwItens:SetArray(aItens)
	
	::aItens := aItens
    
	OBrwItens:bLine := {|| {    aItens[OBrwItens:nAt,11] ,; 
                                aItens[OBrwItens:nAt,02] ,;
                                aItens[OBrwItens:nAt,03] ,;
                                aItens[OBrwItens:nAt,04] ,;
                                aItens[OBrwItens:nAt,05] ,;
                                aItens[OBrwItens:nAt,06] ,;
                                aItens[OBrwItens:nAt,07] ,;
                                aItens[OBrwItens:nAt,08] ,;
								aItens[OBrwItens:nAt,09] ,;
                                aItens[OBrwItens:nAt,10] ;
                        }}
    
	oGetQtdRegs:refresh()

    //OBrwItens:Align := CONTROL_ALIGN_ALLCLIENT

    OBrwItens:refresh()
      
        
    Else
    Alert("Data de Corte para pesquisa de Itens não Empenhados: 19/06/2019")
    Return .F.
    EndIf
    
    

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fStAgend
Description //Retorna o campo C6_01AGEND
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since dd/mm/aaaa /*/
//--------------------------------------------------------------
Static Function fStAgend(cPedido, cItem, cProd)

	Local aArea := getarea()
	Local cAgend := '2' // não agendado

	dbSelectArea("SC6")
	SC6->(DbSetOrder(1))

	if SC6->(dbSeek(xFilial() + cPedido + cItem + cProd ))
		cAgend := SC6->C6_01AGEND
	endif

	restArea(aArea)

Return cAgend


//--------------------------------------------------------------
/*/{Protheus.doc} fExcel
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 04/12/2018 /*/
//--------------------------------------------------------------
Static Function fExcel(aItens, cTitle)

	Local oExcel := FWMsExcel():New()
    Local cArqTemp := GetTempPath() + "Pedido_"+substr(time(), 7, 2)+".XLS"
	Local aFields := {"C6_01AGEND", "ZK2_DOCENT", "ZK2_PEDIDO", "ZK2_ITEM", "ZK2_PROD", "B1_DESC", "ZK2_QUANT", "ZK2_LOCALI", "ZK2_DTENT"}
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
	   										iif(aItens[nx][1]=='1',"AGENDADO","NAO AGENDADO"),;
											aItens[nx][2],;
                                            aItens[nx][3],;
											aItens[nx][4],;
                                            aItens[nx][5],;
                                            aItens[nx][6],;
                                            aItens[nx][7],;
                                            aItens[nx][8],;
                                            aItens[nx][9] })
	next nx
    
	oExcel:Activate()
	oExcel:GetXMLFile(cArqTemp)
	ShellExecute("open", cArqTemp, "", "C:\", 1 )
	
Return

Static Function setTime(nOpcao)

    if nOpcao == 1
        oTimer:Activate()
		apMsgAlert("Timer Ativo","KOMFORT HOUSE")
    else
        oTimer:DeActivate()
		apMsgAlert("Timer Inativo","KOMFORT HOUSE")
    endif

Return

