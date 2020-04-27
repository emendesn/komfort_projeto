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


user function KHX003()
	
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
    oCalend := CALENDBAR02():New( oDlg, 0, 0, 200, 30, {|dDate| oMsgItem:SetText( "Selecionada: " + DtoC( dDate ) ) }, Date() )
    oCalend:Align := CONTROL_ALIGN_TOP
       
    OBrwItens := TwBrowse():New(050, 000, aSize[3], aSize[4]-75,, {;
																'-',;
																'Chamado',;
																'Pedido',;
																'Departamento',;
																'Ocorrência',;
                                                                'Usuário',;
                                                                'Operador',;
                                                                'Erro',;    
                                                                'Status',;
                                                                'Data Abertura',;                        
                                                                'Cliente',;
                                                                'Vendedor',;                       
                                                                'Data Retorno',;
                                                                'Status PV';
                                                                },,oDlg,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
                                                                
                               
      

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
Class CALENDBAR02 From TPanel
	
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
Method New( oWnd, nRow, nCol, nWidth, nHeight, bClickDate, dDate ) Class CALENDBAR02

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
Method Activate() Class CALENDBAR02

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

		oCALENDBTN02 := CALENDBTN02():New( ::oBtnPanel, cDayW +chr(10)+ cValToChar(nDay), dDate)
		oCALENDBTN02:Align  := CONTROL_ALIGN_LEFT
		oCALENDBTN02:dDate := dDate  
		oCALENDBTN02:setSelect(oCALENDBTN02, .F.)
		Aadd( ::aButtons, oCALENDBTN02 )

		// Ajusto o botao com a data selecionada
		if oCALENDBTN02:dDate == ::dDate
			::oBtnSelect = oCALENDBTN02
			::oBtnSelect:setSelect(::oBtnSelect, .T.)
		endif
		
		dDate++
	end       
	
	::setUpdatesEnable(.T.) // Reabilita pintura
	
Return

//-------------------------------------------------------------------
// Navegacao entre as datas através dos botões laterais
//-------------------------------------------------------------------
Method ChangeDate( nSide, nQtdDias ) Class CALENDBAR02

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
		oBtn := CALENDBTN02():New( ::oBtnPanel, cDayW +chr(10)+ cValToChar(nDay), dDate)
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
		oBtn := CALENDBTN02():New( ::oBtnPanel, cDayW+chr(10)+cValToChar(nDay), dDate)
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
Method SetDate( dDate ) Class CALENDBAR02

	if ::dDate != dDate
		eval(::bClickDate, dDate)
		::dDate := dDate
		::Activate()
	endif

Return  

//-------------------------------------------------------------------
// Botoes do CALENDBAR02
//-------------------------------------------------------------------
Class CALENDBTN02 From TButton
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
Method New( oWnd, cStr, dDate) Class CALENDBTN02

    :Create( oWnd,0,0,cStr,,BTN_WIDTH,20,,,,.T.,,DtoC(dDate))

	::lFocused 		:= .F.
	::oFather 		:= ::oParent:oParent
	::lCanGotFocus 	:= .F. // Inibe foco
	::blClicked 	:= {|| ::Clicked() }

Return

//-------------------------------------------------------------------
// Evento de Clique no botão
//-------------------------------------------------------------------
Method Clicked() Class CALENDBTN02

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
Method SetSelect(oCalButton, lSelect) Class CALENDBTN02

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
Method fDate() Class CALENDBAR02

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
Method carregaProduto(_dData,cChamado,cPedido) Class CALENDBAR02
    
    Local cAlias := ""
    Local cQuery := ""
    Local aItens := {}
	Local oSt1 := LoadBitmap(GetResources(),'BR_VERMELHO') //PENDENTE
	local oSt2 := LoadBitmap(GetResources(),'BR_VERDE') //VERDE
    Local oSt6 := LoadBitmap(GetResources(),'BR_BRANCO') //QUANDO NÃO TIVER LEGENDA CADASTRADA
	Local oStatus 
	Private cUser := LogUserName()
	Private cUserEst := SUPERGETMV("KH_VISURET", .T., "000455|000567|001236")
	
	
	dbSelectArea("SUD")
	

    cQuery := "SELECT DISTINCT UC_STATUS,UD_CODIGO,A1_NOME,X5_DESCRI,U9_DESC,UD_XUSER,U7_NOME,UC_XTPERRO,UC_XFOLLOW,C5_EMISSAO,C5_NUM, A3_NOME,UC_XSATISF,UC_XSTATUS"+ ENTER
    cQuery += " FROM "+ retSqlName("SUD")+ " SUD"+ ENTER
    cQuery += " INNER JOIN "+ retSqlName("SUC")+ " SUC ON UC_FILIAL = UD_FILIAL AND UC_CODIGO = UD_CODIGO "+ ENTER
    cQuery += " INNER JOIN "+ retSqlName("SC5")+ " SC5 ON SUBSTRING(UC_01PED,5,10) = C5_NUM"+ ENTER 
    cQuery += " INNER JOIN "+ retSqlName("SUA")+ " SUA ON UA_NUMSC5 = C5_NUM "+ ENTER 
    cQuery += " INNER JOIN "+ retSqlName("SA3")+ " SA3 ON A3_COD = UA_VEND "+ ENTER 
    cQuery += " INNER JOIN "+ retSqlName("SU7")+ " SU7 ON U7_COD = UC_OPERADO "+ ENTER 
    cQuery += " INNER JOIN "+ retSqlName("SA1")+ " SA1 ON A1_COD + A1_LOJA = UC_CHAVE "+ ENTER 
    cQuery += " INNER JOIN "+ retSqlName("SX5")+ " SX5 ON X5_CHAVE = UD_ASSUNTO "+ ENTER 
    cQuery += " INNER JOIN "+ retSqlName("SU9")+ " SU9 ON U9_CODIGO = UD_OCORREN "+ ENTER 
    cQuery += " WHERE UD_FILIAL = '' "+ ENTER
    cQuery += " AND UC_FILIAL = '' "+ ENTER
    cQuery += " AND U7_FILIAL = '    ' "+ ENTER
    cQuery += " AND A1_FILIAL = '    ' "+ ENTER
    cQuery += " AND X5_FILIAL = '01  ' "+ ENTER
    cQuery += " AND U9_FILIAL = '    ' "+ ENTER
    cQuery += " AND UC_STATUS <> '3 ' "+ ENTER
    cQuery += " AND SUD.D_E_L_E_T_ = ' ' "+ ENTER
    cQuery += " AND SUC.D_E_L_E_T_ = ' ' "+ ENTER
    cQuery += " AND SU7.D_E_L_E_T_ = ' ' "+ ENTER
    cQuery += " AND SA1.D_E_L_E_T_ = ' ' "+ ENTER
    cQuery += " AND SA3.D_E_L_E_T_ = ' ' "+ ENTER
    cQuery += " AND SX5.D_E_L_E_T_ = ' ' "+ ENTER
    cQuery += " AND SU9.D_E_L_E_T_ = ' ' "+ ENTER
    cQuery += " AND X5_TABELA = 'T1' "+ ENTER
    cQuery += " AND UC_XSTATUS NOT IN ('PV ENCERRADO','TRATATIVA SAC')"+ ENTER
    cQuery += " AND UC_XFOLLOW = '"+dtos(_dData)+"'"+ ENTER
    cQuery += " AND UD_ASSUNTO IN ('000008', '000010') "+ ENTER
    if !__cUserid $ cUserEst
    cQuery += " AND UD_XUSER ='"+cUser+"'"+ ENTER
	endif
	if !EMPTY(alltrim(cChamado))
	cQuery += " AND UD_CODIGO ='"+cChamado+"'"+ ENTER
	ElseIf !EMPTY(alltrim(cPedido))
	cQuery += " AND C5_NUM ='"+cPedido+"'"+ ENTER
	EndIf
    //cQuery += " GROUP BY UC_STATUS,UD_CODIGO,UC_CHAVE,A1_NOME,X5_DESCRI,U9_DESC,UD_XUSER,UC_01PED,UC_XTPERRO,UC_XSATISF,UC_XFOLLOW  "+ ENTER
    //cQuery += " ORDER BY  UD_CODIGO" + ENTER
	cAlias := getNextAlias()

	PLSQuery(cQuery, cAlias)
	DbSelectArea(cAlias)
	(cAlias)->(DbGoTop())
	
    aItens := {}

    while (cAlias)->(!eof())
      		

        
        aAdd(aItens,{ 	(cAlias)->UC_STATUS,;
						(cAlias)->UD_CODIGO,;
                        (cAlias)->A1_NOME,;
                        (cAlias)->X5_DESCRI,;
						(cAlias)->U9_DESC,;
                        (cAlias)->UD_XUSER,;
                        (cAlias)->U7_NOME,;
                        (cAlias)->UC_XTPERRO,;
                        (cAlias)->UC_XFOLLOW,;
                        (cAlias)->C5_EMISSAO,;
                        (cAlias)->C5_NUM,;
                        (cAlias)->A3_NOME,;
                        (cAlias)->UC_XSATISF,;
                        (cAlias)->UC_XSTATUS})
		
	(cAlias)->(dbSkip())
	end
	
	(cAlias)->(dbCloseArea())

    if len(aItens) == 0
        AAdd(aItens, {"","","",""," ","","","",ctod("//"),ctod("//"),"","","",""})
    endif

    OBrwItens:SetArray(aItens)
	
	
	
	::aItens := aItens
 
    		
    		
	
	OBrwItens:bLine := {|| {    iiF(aItens[OBrwItens:nAt,01]=='2 ',oSt1,oSt1),;
                                aItens[OBrwItens:nAt,02] ,;
                                aItens[OBrwItens:nAt,11] ,;
                                aItens[OBrwItens:nAt,04] ,;
                                aItens[OBrwItens:nAt,05] ,;
                                aItens[OBrwItens:nAt,06] ,;
                                aItens[OBrwItens:nAt,07] ,;
								aItens[OBrwItens:nAt,08] ,;
								iiF(aItens[OBrwItens:nAt,13]=='1','Ótimo',;
								iiF(aItens[OBrwItens:nAt,13]=='2','Bom',;
								iiF(aItens[OBrwItens:nAt,13]=='3','Regular',;
								iiF(aItens[OBrwItens:nAt,13]=='5','Ruim','')))),;             
                                aItens[OBrwItens:nAt,10] ,;
								aItens[OBrwItens:nAt,03] ,;
								aItens[OBrwItens:nAt,12] ,;
								aItens[OBrwItens:nAt,09] ,;
								aItens[OBrwItens:nAt,14] ;
                              }}
    //OBrwItens:Align := CONTROL_ALIGN_ALLCLIENT
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
  