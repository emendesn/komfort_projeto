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


user function KHX002()
	
    Local dDateGet := Date()
    Local aSize := MsAdvSize()
    Local cTitle := "Agendamento Técnico"
    Local bRefresh:= {|| oCalend:carregaProduto(oCalend:dDate) }
    Local nMilissegundos := 10000 // Disparo será de 20 em 20 segundos
	Local aButtons := {}
	local aInfocab :={}
	local nQtd := 0
	Private lEst := .T.
	Private cUserEst := SUPERGETMV("KH_AGELOG", .T., "000870|000136|000374|000455") // BLOQUEIO DE USUÁRIOS DA LOGISTICA PARA O CADASTRO DA TELAS 
	Private oTimer

	if __cUserid $ cUserEst
	lEst := .F.
	endif

    SET DATE BRITISH
    __SetCentury("ON")
    
    
    
    
			
	//Define Dialog oDlg Title cTitle From 000,000 To aSize[6],aSize[5] Pixel COLORS 0, 16777215 PIXEL
    DEFINE MSDIALOG oDlg FROM 0,0 TO aSize[6],aSize[5] TITLE cTitle Of oMainWnd PIXEL           
    oTimer := TTimer():New(nMilissegundos, {|| bRefresh }, oDlg )   
	oMsgBar  := TMsgBar():New(oDlg,,,,,, RGB(116,116,116),,,.F.)
    oMsgItem := TMsgItem():New( oMsgBar, "Selecionada: " + DtoC( Date() ), 120,,,,.T., {|| oCalend:fDate(dDateGet) } )
    oFont := TFont():New('Courier new',,16,.T.)//cria fonte para o label
    oTButton1 := TButton():New( 035, aSize[3]-100, "Cad Agendamento Técnico",oDlg,{||U_KMSACA12()}, 100,20,,,.F.,.T.,.F.,,.F.,{|| oTButton3:lActive := lEst},,.F. )   
    oTButton3 := TButton():New( 035, aSize[3]-210, "Cad Visita Técnica",oDlg,{||U_KMSACA15()}, 100,20,,,.F.,.T.,.F.,,.F.,{|| oTButton3:lActive := lEst},,.F.)
        
    oCalend := CALENDBAR01():New( oDlg, 0, 0, 200, 30, {|dDate| oMsgItem:SetText( "Selecionada: " + DtoC( dDate ) ) }, Date() )
    oCalend:Align := CONTROL_ALIGN_TOP
    //aInfocab:= TMKCAB(oCalend:dDate)
    
    OBrwItens := TwBrowse():New(060, 000, aSize[3], aSize[4]-75,, {;
																'-',;
																'Qtd',;
																'Código',;
                                                                'Chamado',;
                                                                'Pedido de Venda',;
                                                                'Produto',;
                                                                'Descrição',;
                                                                'Cliente',;
                                                                'Autorizado',;
                                                                'Serviço',;
                                                                'CEP',;
                                                                'Observação',;
                                                                'Responsável',;
                                                                'Técnico',;
                                                                'Status',;
                                                                'Região',;
                                                                'Data',;
                                                                },,oDlg,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
    
    oCalend:carregaProduto(dDateGet)
    oCalend:TMKCAB(dDateGet)
    nQtd:= RETAGDIA(dDateGet)
    oSay1:= TSay():New(35,20,{||'Região:'+ oCalend:cLabelRegiao },oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)//
    oSay2:= TSay():New(35,300,{||'CEP: '+ oCalend:cLabelcep },oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)//
    oSay3:= TSay():New(42,20,{||'Limite de Visitas:' + cvaltochar(oCalend:nlabelVis) },oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)//
    //oSay4:= TSay():New(35,150,{||'Agendados:' + cvaltochar(nQtd) },oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)//
    
    oCalend:Activate()

	SetKey(VK_F4, {|| U_KMSACR05() }) // Incluida função para gerar o relatorio KMSACR05 na tecla F4 - Everton Santos - 06/06/2019
	//SetKey(VK_F5, {|| processa( {|| oCalend:carregaProduto(oCalend:dDate), "Aguarde...", "Atualizando Dados...", .f. })})
	//SetKey(VK_F6, {|| setTime(1) })
    //SetKey(VK_F7, {|| setTime(2) })

    Activate Dialog oDlg Centered 
	
return

//-------------------------------------------------------------------
// Barra de Calendario 
//-------------------------------------------------------------------
Class CALENDBAR01 From TPanel
	
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
    Method TMKCAB()
Endclass

//-------------------------------------------------------------------
// Construtor
//-------------------------------------------------------------------
Method New( oWnd, nRow, nCol, nWidth, nHeight, bClickDate, dDate ) Class CALENDBAR01

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
Method Activate() Class CALENDBAR01

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

		oCALENDBTN01 := CALENDBTN01():New( ::oBtnPanel, cDayW +chr(10)+ cValToChar(nDay), dDate)
		oCALENDBTN01:Align  := CONTROL_ALIGN_LEFT
		oCALENDBTN01:dDate := dDate  
		oCALENDBTN01:setSelect(oCALENDBTN01, .F.)
		Aadd( ::aButtons, oCALENDBTN01 )

		// Ajusto o botao com a data selecionada
		if oCALENDBTN01:dDate == ::dDate
			::oBtnSelect = oCALENDBTN01
			::oBtnSelect:setSelect(::oBtnSelect, .T.)
		endif
		
		dDate++
	end       
	
	::setUpdatesEnable(.T.) // Reabilita pintura
	
Return

//-------------------------------------------------------------------
// Navegacao entre as datas através dos botões laterais
//-------------------------------------------------------------------
Method ChangeDate( nSide, nQtdDias ) Class CALENDBAR01

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
		oBtn := CALENDBTN01():New( ::oBtnPanel, cDayW +chr(10)+ cValToChar(nDay), dDate)
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
		oBtn := CALENDBTN01():New( ::oBtnPanel, cDayW+chr(10)+cValToChar(nDay), dDate)
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
Method SetDate( dDate ) Class CALENDBAR01

	if ::dDate != dDate
		eval(::bClickDate, dDate)
		::dDate := dDate
		::Activate()
	endif

Return  

//-------------------------------------------------------------------
// Botoes do CALENDBAR01
//-------------------------------------------------------------------
Class CALENDBTN01 From TButton
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
Method New( oWnd, cStr, dDate) Class CALENDBTN01

    :Create( oWnd,0,0,cStr,,BTN_WIDTH,20,,,,.T.,,DtoC(dDate))

	::lFocused 		:= .F.
	::oFather 		:= ::oParent:oParent
	::lCanGotFocus 	:= .F. // Inibe foco
	::blClicked 	:= {|| ::Clicked() }

Return

//-------------------------------------------------------------------
// Evento de Clique no botão
//-------------------------------------------------------------------
Method Clicked() Class CALENDBTN01

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
        oCalend:TMKCAB(::dDate)
    endif 
	
Return

//-------------------------------------------------------------------
// Define Status e CSS do botao
//-------------------------------------------------------------------
Method SetSelect(oCalButton, lSelect) Class CALENDBTN01

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
Method fDate() Class CALENDBAR01

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
// Carrega os itens na tela
//-------------------------------------------------------------------
Method carregaProduto(_dData) Class CalendBar01
    
    Local cAlias := ""
    Local cQuery := ""
    Local aItens := {}
	Local oSt1 := LoadBitmap(GetResources(),'BR_VERMELHO') //PENDENTE
	local oSt2 := LoadBitmap(GetResources(),'BR_VERDE') //VERDE
    Local oSt3 := LoadBitmap(GetResources(),'BR_PRETO') //NÃO RESOLVIDO
    Local oSt4 := LoadBitmap(GetResources(),'BR_AZUL') //CONSERTO
    Local oSt5 := LoadBitmap(GetResources(),'BR_AMARELO') //VISITA
    Local oSt6 := LoadBitmap(GetResources(),'BR_BRANCO') //QUANDO NÃO TIVER LEGENDA CADASTRADA
	Local oStatus 
	Local nNum := 0
	
	dbSelectArea("ZK5")

    cQuery := "SELECT ZK4_COD, ZK4_CHAMAD, ZK4_PED, ZK4_PROD, ZK4_DESCPR, ZK4_CLI,ZK4_AUT ,ZK4_SERVC , ZK4_CEP, ZK4_OBS, ZK4_RESP, ZK4_TEC, ZK4_STATUS, ZK4_REGIAO, ZK4_DATA"+ ENTER
    cQuery += " FROM "+ retSqlName("ZK4")+ " ZK4"+ ENTER
   // cQuery += " INNER JOIN "+ retSqlName("SC6")+ " SC6 ON ZK2.ZK2_PEDIDO = SC6.C6_NUM AND ZK2.ZK2_PROD = SC6.C6_PRODUTO AND ZK2.ZK2_ITEM = SC6.C6_ITEM"+ ENTER
    cQuery += " WHERE ZK4_DATA = '"+dtos(_dData)+"'"+ ENTER
    cQuery += " AND ZK4.D_E_L_E_T_ = ' '"+ ENTER
    //cQuery += " AND SC6.D_E_L_E_T_ = ' '"+ ENTER
    cQuery += " ORDER BY ZK4_COD, ZK4_CHAMAD, ZK4_PED, ZK4_PROD, ZK4_DESCPR, ZK4_CLI,ZK4_AUT ,ZK4_SERVC , ZK4_CEP, ZK4_OBS, ZK4_RESP, ZK4_TEC, ZK4_STATUS, ZK4_REGIAO, ZK4_DATA"+ ENTER
    
	cAlias := getNextAlias()

	PLSQuery(cQuery, cAlias)
	DbSelectArea(cAlias)
	(cAlias)->(DbGoTop())
	
    aItens := {}

    while (cAlias)->(!eof())
      		
    
      
        
        aAdd(aItens,{ 	oStatus,;
        				 nNum += 1,;
        				(cAlias)->ZK4_COD,;
						(cAlias)->ZK4_CHAMAD,;
                        (cAlias)->ZK4_PED,;
                        (cAlias)->ZK4_PROD,;
                        (cAlias)->ZK4_DESCPR,;
                        (cAlias)->ZK4_CLI,;
						(cAlias)->ZK4_AUT,;
                        (cAlias)->ZK4_SERVC,;
                        (cAlias)->ZK4_CEP,;
                        (cAlias)->ZK4_OBS,;
                        (cAlias)->ZK4_RESP,;
                        (cAlias)->ZK4_TEC,;
                        (cAlias)->ZK4_STATUS,;
                        (cAlias)->ZK4_REGIAO,;
                        (cAlias)->ZK4_DATA})
		
	(cAlias)->(dbSkip())
	end
	
	(cAlias)->(dbCloseArea())

    if len(aItens) == 0
        AAdd(aItens, {""," ","","","","","",""," ","","","","","","","",ctod("//")})
    endif

    OBrwItens:SetArray(aItens)
	
	
	
	::aItens := aItens
 
    		
    		
	
	OBrwItens:bLine := {|| {    iiF(aItens[OBrwItens:nAt,15]=='1',oSt1,;
								iiF(aItens[OBrwItens:nAt,15]=='2',oSt2,;
								iiF(aItens[OBrwItens:nAt,15]=='3',oSt3,;
								iiF(aItens[OBrwItens:nAt,15]=='4',oSt4,;
								iiF(aItens[OBrwItens:nAt,15]=='5',oSt5, oSt6))))),;
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
                                aItens[OBrwItens:nAt,13] ,;
                                aItens[OBrwItens:nAt,14] ,;
                                aItens[OBrwItens:nAt,15] ,;
                                aItens[OBrwItens:nAt,16] ,;
								aItens[OBrwItens:nAt,17] }};
    
    //OBrwItens:Align := CONTROL_ALIGN_ALLCLIENT

    OBrwItens:refresh()

Return

//iif(se==a,t,iif(se==b,t,iif(se==c,t,f)))

//-------------------------------------------------------------------
// Carrega os itens no cabeçario do agendameto técnico
//-------------------------------------------------------------------


Method TMKCAB(_dData) Class CALENDBAR01
    
    Local cAlias := ""
    Local cQuery := ""
   	    
	dbSelectArea("ZK5")

    cQuery := "SELECT ZK5_REGIAO, ZK5_DATA, ZK5_CEP, ZK5_VIS"+ ENTER
    cQuery += " FROM "+ retSqlName("ZK5")+ " ZK5"+ ENTER
    cQuery += " WHERE ZK5_DATA = '"+dtos(_dData)+"'"+ ENTER
    cQuery += " AND ZK5.D_E_L_E_T_ = ' '"+ ENTER
    
    
	cAlias := getNextAlias()

	PLSQuery(cQuery, cAlias)
	DbSelectArea(cAlias)
	(cAlias)->(DbGoTop())
	
    if (cAlias)->(!eof())
        
        ::cLabelRegiao := (cAlias)->ZK5_REGIAO
		::cLabelCep := (cAlias)->ZK5_CEP
        ::nLabelVis := (cAlias)->ZK5_VIS
	
	else
		::cLabelRegiao := ""
		::cLabelCep := ""
        ::nLabelVis := 0
	
	
	endif
	
	(cAlias)->(dbCloseArea())

    

return 


Static Function fExcel(aItens, cTitle)

	Local oExcel := FWMsExcel():New()
    Local cArqTemp := GetTempPath() + "Agendamento Técnico"+substr(time(), 7, 2)+".XLS"
	Local aFields := {"ZK4_CHAMAD", "ZK4_CHAMAD", "ZK4_PED", "ZK4_PROD", "ZK4_DESCPR", "ZK4_CLI", "ZK4_AUT", "ZK4_SERVC", "ZK4_CEP", "ZK4_OBS" , "ZK4_RESP" , "ZK4_TEC" , "ZK4_STATUS" , "ZK4_REGIAO" , "ZK4_DATA"}
    Local aCab := {}
    Local nx := 0
    Local cStatus := ""

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
    
	   do case
	    	case aItens[nx][1]=='1'
	    		cStatus:="PENDENTE"
	    	case aItens[nx][1]=='2'
	    		cStatus:="VERDE"
	    	case aItens[nx][1]=='3'
	    		cStatus:="NÃO RESOLVIDO"
	    	case aItens[nx][1]=='4'
	    		cStatus:="CONSERTO"
	    	case aItens[nx][1]=='5'
	    		cStatus:="VISITA"
	    endcase
	    			
    		
	   	oExcel:AddRow(cNamePlan,cNameTable,{;
	   										cStatus,;
	   										aItens[nx][1],;
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
                                            aItens[nx][14],;
                                           },{1,2,3,4,5,6,7,8,9,10,11,12,14})
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
   

Static function RETAGDIA(_dData) 
    
    Local cAlias := ""
    Local cQuery := ""
   	Local nQtd := 0
   	    
	dbSelectArea("ZK4")

    cQuery := "SELECT COUNT(*) AS QTD "+ ENTER
    cQuery += " FROM "+ retSqlName("ZK4")+ " ZK4"+ ENTER
    cQuery += " WHERE ZK4_DATA = '"+dtos(_dData)+"'"+ ENTER
    cQuery += " AND ZK4.D_E_L_E_T_ = ' '"+ ENTER
    
    
	cAlias := getNextAlias()

	PLSQuery(cQuery, cAlias)
	DbSelectArea(cAlias)
	(cAlias)->(DbGoTop())
	
    if (cAlias)->(!eof())
        
        nQtd := (cAlias)->QTD
		
	
	else
		nQtd := 0
	
	
	endif
	
	(cAlias)->(dbCloseArea())

    

return nQtd
   
  
   
   
  