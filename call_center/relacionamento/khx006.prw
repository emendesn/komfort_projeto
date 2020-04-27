#include "rwmake.ch"
#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#INCLUDE "JPEG.CH"
#INCLUDE "FWMVCDEF.CH"

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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ KHX006   ºAutor  ³ Artuso	         º Data ³  16/08/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina responsavel por gerar em tela os clientes que devem º±±
±±º          ³ ser contactados apos um determinado periodo.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//-------------------------------------------------------------------
// Funcao de teste para uso da classe
//-------------------------------------------------------------------
User function KHX006()

	Local nMilissegundos	:= 10000 // Disparo será de 20 em 20 segundos
	Local dDateGet 			:= Date()
	Local aSize 			:= MsAdvSize()
	Local cTitle			:= "Relacionamento e Atendimento"
	Local bRefresh			:= {|| oCalend:carregaProduto(oCalend:dDate) }
	Local cUserMv			:= SuperGetMV("KH_VISUCOB",.F.,"001079|000455|000950|000374")
	Local nInc				:= 0
	Local nAtOld			:= 0
	Local nPosBut			:= 0
	Local nIncPos			:= 50
	Local oMsgBar
	Local oMsgItem
	Static oTButton1
	Static oTButton2
	Static oTButton3
	Static oTButton4
	Static oTButton5
	Static oTButton6
	Static oTButton7
	Static oTButton8

	Private aItens			:= {}
	Private cMV_PAR07 		:= SPACE(50)
	Private aZL5			:= {}//O array 'aZL5' é um array auxiliar que ira armazenar os itens digitados/escolhidos no browse.
	Private oTimer
	Private lIniAtend		:= .F.
	Private lFimAtend		:= .F.
	Private lSuspect		:= .F.
	Private oAzul 			:= LoadBitmap(GetResources(),'BR_AZUL') //"Atendimento Planejado" --> Padrão
	Private oVermelho		:= LoadBitmap(GetResources(),'BR_VERMELHO')  //"Atendimento Pendente" --> Padrão
	Private oVerde	 		:= LoadBitmap(GetResources(),'BR_VERDE') //"Atendimento Encerrado" --> Padrão
	Private oPreto			:= LoadBitmap(GetResources(),'BR_PRETO') //"Atendimento Cancelado" --> Padrão
	Private oAmarelo		:= LoadBitmap(GetResources(),'BR_AMARELO')  //"Em Andamento" --> Customizado Komfort
	Private oLaranja		:= LoadBitmap(GetResources(),'BR_LARANJA') //"Visita Tec" --> Customizado Komfort
	Private oRosa 			:= LoadBitmap(GetResources(),'BR_PINK') //"Devolucao" --> Customizado Komfort
	Private oBranco 		:= LoadBitmap(GetResources(),'BR_BRANCO') //"Retorno" --> Customizado Komfort
	Private oVioleta 		:= LoadBitmap(GetResources(),'BR_VIOLETA')  //"Troca Aut" --> Customizado Komfort
	Private oCinza 			:= LoadBitmap(GetResources(),'BR_CINZA') //"Compartilhamento" --> Padrão
	Private oAzulClaro 		:= LoadBitmap(GetResources(),'BR_AZUL_CLARO')  // Email Fabricante --> Customizado Komfort
	Private oRoxo	 		:= LoadBitmap(GetResources(),'BR_ROXO')  // Email Fabricante --> Customizado Komfort
	Private lCalend			:= .F.
	Private lReagend		:= .F.
	Private cFiltro			:= ""
	Private oCalend
	Private aItBKP			:= {}
	Private nQtFields		:= 0

	DEFINE FONT oFont11 NAME "Arial" SIZE 0, -11 BOLD

	DEFINE MSDIALOG oDlg FROM 0,0 TO aSize[6],aSize[5] TITLE cTitle Of oMainWnd PIXEL

		oTimer := TTimer():New(nMilissegundos, {|| bRefresh }, oDlg )
		oMsgBar  := TMsgBar():New(oDlg,,,,,, RGB(116,116,116),,,.F.)
		oMsgItem := TMsgItem():New( oMsgBar, "Selecionada: " + DtoC( Date() ), 120,,,,.T., {|| oCalend:fDate(dDateGet) } )
		oTButton1 := TButton():New( 035, nPosBut := 5, "F2-Cons. Cliente",oDlg,{|| fSetOPeracao(2,oCalend:aItens[OBrwItens:nAt])},50,10,,,.F.,.T.,.F.,,.F.,{|| oTButton1:lActive := .T.},,.F. )
		oTButton2 := TButton():New( 035, nPosBut += 55, "F3-Cons. Ped. de Vendas",oDlg,{|| fSetOPeracao(10,oCalend:aItens[OBrwItens:nAt])} , 70,10,,,.F.,.T.,.F.,,.F.,{|| oTButton2:lActive := .T.},,.F. )
		oTButton3 := TButton():New( 035, nPosBut += 75, "F4-Cons. Legenda",oDlg,{|| zLegenda()}, 60,10,,,.F.,.T.,.F.,,.F.,{|| oTButton3:lActive := .T.},,.F. )
		oTButton4 := TButton():New( 035, nPosBut += 65 , "F11-Reg. Atendimento",oDlg,{|| fSetOPeracao(15,oCalend:aItens[OBrwItens:nAt]) }, 60,10,,,.F.,.T.,.F.,,.F.,{|| oTButton4:lActive := .T.},,.F. )
		oTButton5 := TButton():New( 035, nPosBut += 65 , "Filtrar situações",oDlg,{|| KHX00606(@cFiltro)}, 60,10,,,.F.,.T.,.F.,,.F.,{|| oTButton5:lActive := .T.},,.F. )

		nPosBut	:= aSize[3]

		@  035,  nPosBut -= 350 Say  oSay Prompt 'Cliente:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oDlg Pixel
		@  035,  nPosBut += 30 MSGet oMV_PAR07	Var cMV_PAR07	FONT oFont11 COLOR CLR_BLUE Pixel SIZE  120 , 07 When .T. Of oDlg

		oTButton6 := TButton():New( 035, nPosBut += nIncPos + 70 , "Pesquisar",oDlg,{|| processa( {|| oCalend:carregaProduto(oCalend:dDate,cMV_PAR07 ,, .T.), "Aguarde...", "Atualizando Dados...", .f. })}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
		oTButton7 := TButton():New( 035, nPosBut += nIncPos , "Iniciar Atendimento",oDlg,{|| KHX00605(oCalend:aItens[OBrwItens:nAt] , .T. , .F.,OBrwItens:nAt)}, 60,10,,,.F.,.T.,.F.,,.F.,,,.F. )
		oTButton8 := TButton():New( 035, nPosBut += nIncPos + 20, "Encerrar Atendimento",oDlg,{|| KHX00605(oCalend:aItens[OBrwItens:nAt] , .F. , .T.,OBrwItens:nAt)}, 60,10,,,.F.,.T.,.F.,,.F.,,,.F. )
		oCalend := CALENDBAR05():New( oDlg, 0, 0, 200, 30, {|dDate| oMsgItem:SetText( "Selecionada: " + DtoC( dDate ) ) }, Date() )
		oCalend:Align := CONTROL_ALIGN_TOP

		OBrwItens := TwBrowse():New(050, 000, aSize[3], aSize[4]-75,, {	"" 							,;//1
																		"Cód. Cliente"				,;//2
																		"Loja"						,;//3
																		"Cliente"					,;//4
																		"CPF"						,;//5
																		"Dt.Cad. (Cliente)"			,;//6
																		"Tel. Contato 1"			,;//7
																		"Tel. Contato 2"			,;//8
																		"Tel. Relacionamento"		,;//9
																		"Ped. de Venda"				,;//10
																		"Dt. Últ. Compra" 			,;//11
																		"Dt.Chamado"				,;//12
																		"Cód. Chamado(SAC)"			,;//13
																		"Assunto do Chamado"		,;//14
																		"Obs." 						,;//15
																		"Nível Satisfação" 			,;//16
																		"Nota de Satisfação" 		,;//17
																		"Status Contato" 			,;//18
																		"Status WhatsApp"			,;//19
																		"Ch. Ocorrência"			,;//20
																		"Cupom"						,;//21
																		"Perc. de Desconto"			,;//22
																		"Tp. do Brinde"				,;//23
																		"Pend. de Contato"			,;//24
																		"Suspect enviado"			,;//25
																		"Operador"					,;//26
																		"Data de Agendamento"		;//27
																		},,oDlg,,,,,,,,,,,,.F.,, .T.,, .T.,,,)

		OBrwItens:bLDblClick := {|| fSetOPeracao(OBrwItens:nColPos,oCalend:aItens[OBrwItens:nAt], OBrwItens:nAt)   }

		//Calend:carregaProduto(dDateGet)
		If !(lCalend)

			Processa( {|| oCalend:carregaProduto(oCalend:dDate), "Aguarde..." , "Atualizando Dados...", .f. })

		Else

			lCalend	:= .F.

		EndIf
		oCalend:Activate()
		SetKey(VK_F2, {|| processa( {|| fSetOPeracao(2,oCalend:aItens[OBrwItens:nAt]) })})//Consulta Cadastro de Clientes
		SetKey(VK_F3, {|| processa( {|| fSetOPeracao(10,oCalend:aItens[OBrwItens:nAt]) })}) //Consulta ao Pedido de Vendas
		SetKey(VK_F4, {|| zLegenda()}) //Consulta Legenda
		SetKey(VK_F5, {|| processa( {|| oCalend:carregaProduto(oCalend:dDate), "Aguarde...", "Atualizando Dados...", .f. })}) //Atualização dos dados
		SetKey(VK_F11, {|| processa( {|| fSetOPeracao(15,oCalend:aItens[OBrwItens:nAt] ,,oCalend:dDate) })}) // Observacoes

	Activate Dialog oDlg Centered

return

//-------------------------------------------------------------------
// Barra de Calendario
//-------------------------------------------------------------------
Class CALENDBAR05 From TPanel

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
Method New( oWnd, nRow, nCol, nWidth, nHeight, bClickDate, dDate ) Class CALENDBAR05

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
Method Activate() Class CALENDBAR05

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

		oCALENDBTN04 := CALENDBTN05():New( ::oBtnPanel, cDayW +chr(10)+ cValToChar(nDay), dDate)
		oCALENDBTN05:Align  := CONTROL_ALIGN_LEFT
		oCALENDBTN05:dDate := dDate
		oCALENDBTN05:setSelect(oCALENDBTN05, .F.)
		Aadd( ::aButtons, oCALENDBTN05 )

		// Ajusto o botao com a data selecionada
		if oCALENDBTN05:dDate == ::dDate
			::oBtnSelect = oCALENDBTN05
			::oBtnSelect:setSelect(::oBtnSelect, .T.)
		endif

		dDate++
	end

	::setUpdatesEnable(.T.) // Reabilita pintura

Return

//-------------------------------------------------------------------
// Navegacao entre as datas através dos botões laterais
//-------------------------------------------------------------------
Method ChangeDate( nSide, nQtdDias ) Class CALENDBAR05

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
		oBtn := CALENDBTN05():New( ::oBtnPanel, cDayW +chr(10)+ cValToChar(nDay), dDate)
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
		oBtn := CALENDBTN05():New( ::oBtnPanel, cDayW+chr(10)+cValToChar(nDay), dDate)
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
Method SetDate( dDate ) Class CALENDBAR05

	if ::dDate != dDate
		eval(::bClickDate, dDate)
		::dDate := dDate
		::Activate()
	endif

Return

//-------------------------------------------------------------------
// Botoes do CALENDBAR05
//-------------------------------------------------------------------
Class CALENDBTN05 From TButton
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
Method New( oWnd, cStr, dDate) Class CALENDBTN05

	:Create( oWnd,0,0,cStr,,BTN_WIDTH,20,,,,.T.,,DtoC(dDate))

	::lFocused 		:= .F.
	::oFather 		:= ::oParent:oParent
	::lCanGotFocus 	:= .F. // Inibe foco
	::blClicked 	:= {|| ::Clicked() }

Return

//-------------------------------------------------------------------
// Evento de Clique no botão
//-------------------------------------------------------------------
Method Clicked() Class CALENDBTN05

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
Method SetSelect(oCalButton, lSelect) Class CALENDBTN05

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
Method fDate() Class CALENDBAR05

	Local oTexto
	Local oTextoResp
	Local oData
	Local oOperado
	Local ddData := Date()
	Local cOperado
	Local oBtnConfirm
	Local lOk

	Static oDlgDate

	DEFINE MSDIALOG oDlgDate TITLE "KOMFORT HOUSE" FROM 000, 000  TO 085, 150 COLORS 0, 16777215 PIXEL

	@ 002, 002 SAY oTexto PROMPT "Selecione a data desejada." SIZE 070, 007 OF oDlgDate COLORS 0, 16777215 PIXEL
	@ 013, 002 MSGET oData VAR ddData SIZE 069, 010 OF oDlgDate COLORS 0, 16777215 PIXEL
	@ 027, 002 BUTTON oBtnConfirm PROMPT "Confirmar" SIZE 069, 012 OF oDlgDate ACTION {|| lOk:=.T., oDlgDate:end() } PIXEL
	//oBtnConfirm:setCSS("QPushButton{color: #FFFFFF; border: 1px solid #6B8E23; border-radius: 4px; background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #008000, stop: 1 #00FF7F);} QPushButton:pressed {background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #00FF7F, stop: 1 #008000);}")

	ACTIVATE MSDIALOG oDlgDate CENTERED

	If (lOk)
		oCalend:SetDate(ddData)
		lCalend		:= .T.
	endif

	oCalend:carregaProduto(ddData)

Return

//-------------------------------------------------------------------
// Carrega os clientes para contactar na data
//-------------------------------------------------------------------
Method carregaProduto(_dData,cCpfCnpj,lFiltro,lPesquisa) Class CALENDBAR05

	Local cAlias := ""
	Local cQuery := ""
	Local aItTMP		:= {}
	Local xRet			:= ""
	Local cFieldName	:= ""
	Local nDiasPrz		:= Val(SuperGetMv('KH_PRZCON' , NIL , '120'))
	Local dDataX		:= Val(SuperGetMv('KH_PRZCON' , NIL , '120'))
	Local cQry01		:= ""

	DEFAULT _dData		:= dDataBase
	DEFAULT cCpfCnpj	:= ""
	DEFAULT lFiltro		:= .F.
	DEFAULT lPesquisa	:= .F.

	If !(lFiltro)

		If ((!Empty(cAlias)) .AND. (Select(cAlias) > 0))

			(cAlias)->(dbCloseArea())

		EndIf

		//Este trecho determina a ordem dos campos na tela (o preenchimento foi feito atraves da funcao FieldGet.
		cQuery 	:= " SELECT " //TOP 10
		cQuery	+= 		" CASE "
		cQuery	+=			" WHEN MAX(ZL5.ZL5_STATUS) = '1' THEN 'VERDE' " //1=Efetivo;2=Nao Efetivo;3=Não Comprou;4=Não Ligar; 5=Proc.Juridico;6=Tratativa com o SAC;7=Nro. Errado
		cQuery	+=			" WHEN MAX(ZL5.ZL5_STATUS) = '2' THEN 'VERMELHO' "
		cQuery	+=			" WHEN MAX(ZL5.ZL5_STATUS) = '4' THEN 'PRETO' "
		cQuery	+=			" WHEN MAX(ZL5.ZL5_CODOPE) <> '" + Space(5) + "' AND MAX(ZL5.ZL5_CODOPE) <> '" + RetCodUsr() + "' THEN 'LARANJA' "
		cQuery	+=			" WHEN MAX(ZL5.ZL5_DTAGEN) = '" + dToS(_dData) + "' THEN 'BRANCO' "
		cQuery	+=		" ELSE 'AMARELO' "
		cQuery	+=		" END AS LEGENDA, "
		cQuery	+= 		" MAX(SA1.A1_COD) COD,"
		cQuery	+= 		" MAX(SA1.A1_LOJA) LOJA, "
		cQuery	+= 		" MAX(SA1.A1_NOME) NOME,"
		cQuery	+= 		" MAX(SA1.A1_CGC) CPF,"
		cQuery	+= 		" MAX(SA1.A1_DTCAD) DTSA1, "
		cQuery	+= 		" MAX(SA1.A1_TEL) TELCLI1, "
		cQuery	+= 		" MAX(SA1.A1_TEL2) TELCLI2, "
		cQuery	+= 		" '' TELCLI3, "
		cQuery	+=		" MAX(SC5.C5_NUM) AS PEDIDO, "
		cQuery	+=		" MAX(SC5.C5_EMISSAO) DT_COMPRA, "
		cQuery	+=		" MAX(SUC.UC_DATA) AS DT_CHAMADO, "
		cQuery	+=		" MAX(SUC.UC_CODIGO) AS COD_CHAMADO, "
		cQuery	+=		" MAX(SUD.UD_ASSUNTO) AS ASSUNTO_CHAMADO, " //--assunto 4 procon e 5 cancelamento 6 reclame aqui
		cQuery	+=		" 'OBS' OBS, "
		cQuery	+= 		" MAX(ZL5.ZL5_NIVEL) NIVEL, " //1=Totalmente Satisfeito;2=Insatisfeito c/ Entrega;3=Insatisfeito c/ Produto;4=Insatisfeito c/ Atendimento
		cQuery	+= 		" MAX(ZL5.ZL5_NOTA) NOTA, "
		cQuery	+= 		" MAX(ZL5.ZL5_STATUS) STATUS, "
		cQuery	+= 		" '' STATUS_WHATSAPP, "
		cQuery	+= 		" MAX(ZL5.ZL5_CHAMAD) ZL5CHAMADO, "
		cQuery	+= 		" 'CUPOM' CUPOM, "
		cQuery	+= 		" MAX(ZL5.ZL5_PERC) PERCENTUAL, "
		cQuery	+= 		" MAX(ZL5.ZL5_BRINDE) BRINDE, " //1=Esteira;2=Almofada;3=Puff;4=Puff-Pet
		cQuery	+= 		" MAX(ZL5.ZL5_PEND) PENDENCIA, " //1=Abrir Chamado;2=Enviar Pesquisa;3=Enc. P/ Loja;4=Env.cupom de Brinde;5=Env. Cupom Inf.
		cQuery	+= 		" MAX(ACH.ACH_XCUPOM) SUSPECT_ENVIADO, "
		cQuery	+=		" 'OPERADOR' AS OPERADOR, "
		cQuery	+=		" MAX(ZL5.ZL5_DTAGEN) AS DT_AGENDAMENTO, "

		//A partir desta linha, os campos nao serao exibidos em tela. Foram adicionados apenas para relacionamentos nas demais tabelas.
		cQuery	+=		" MAX(SA1.A1_CGC) AS CPF, "
		cQuery	+=		" MAX(SA1.A1_DDD) AS DDD, "
		cQuery	+=		" MAX(ZL5.ZL5_CODCLI) AS CODCLIZL5, "
		cQuery	+=		" MAX(ZL5.ZL5_DTCON) AS DT_CONTATO, "
		cQuery	+=		" MAX(ZL5.ZL5_CODOPE) AS CODOPE "

		cQuery 	+=	" FROM " + RetSqlName("SA1")+ " SA1 (NOLOCK) "
		cQuery	+=	" LEFT JOIN " + RetSqlName("SC5")+ " SC5 (NOLOCK) "
		cQuery	+=		" ON SC5.D_E_L_E_T_= '' AND SC5.C5_CLIENTE = SA1.A1_COD "
		cQuery	+=		" AND SC5.R_E_C_N_O_= "
		cQuery	+=			" (SELECT MAX(SC5.R_E_C_N_O_) FROM SC5010 SC5 WHERE SC5.C5_CLIENTE = SA1.A1_COD AND D_E_L_E_T_= '' GROUP BY SC5.C5_CLIENTE) "
		cQuery	+=		" AND SC5.D_E_L_E_T_= '' "
		cQuery	+=	" LEFT JOIN " + RetSqlName("SUC") + " SUC (NOLOCK) "
		cQuery	+=		" ON SUC.D_E_L_E_T_ = '' AND SUC.UC_MSFIL = SC5.C5_MSFIL AND SUC.UC_01PED = SC5.C5_MSFIL + SC5.C5_NUM AND SUC.UC_STATUS = '3' "
		cQuery	+=		" AND SUC.D_E_L_E_T_= ''
		cQuery	+=	" LEFT JOIN " + RetSqlName("SUD") + " SUD "
		cQuery	+=		" ON SUD.D_E_L_E_T_= '' AND SUC.UC_CODIGO = SUD.UD_CODIGO "
		cQuery	+=	" LEFT JOIN " + RetSqlName("ZL5") + " ZL5 "
		cQuery	+=		" ON ZL5.D_E_L_E_T_= '' AND SA1.A1_COD = ZL5.ZL5_CODCLI "
		cQuery	+=	" LEFT JOIN " + RetSqlName("ZL7") + " ZL7 "
		cQuery	+=		" ON ZL7.D_E_L_E_T_= '' AND SA1.A1_COD = ZL7.ZL7_CODCLI AND SA1.A1_LOJA = ZL7.ZL7_LOJA "
		cQuery	+=		" AND ZL7.R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_) FROM ZL7010 WHERE SA1.A1_COD = ZL7.ZL7_CODCLI AND SA1.A1_LOJA = ZL7.ZL7_LOJA) "
		cQuery	+=	" LEFT JOIN " + RetSqlName("ACH") + " ACH "
		cQuery	+=		" ON ACH.D_E_L_E_T_= '' AND ZL7.ZL7_CUPOM = ACH.ACH_XCUPOM "
		cQuery	+=		" AND ACH.R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_) FROM ACH010 WHERE ZL7.ZL7_CUPOM = ACH.ACH_XCUPOM) "

		cQuery	+=	" WHERE SA1.D_E_L_E_T_ = ' ' "
		cQuery	+=		" AND SA1.A1_TIPO = 'F' "

		cCpfCnpj	:= AllTrim(cCpfCnpj)

		If !(Empty(cCpfCnpj))

			//Caso a pesquisa seja feita por: CPF, CNPJ, nome ou telefone

			cCpfCnpj	:= StrTran(cCpfCnpj , "-" , "")

			//Foram adicionadas as validacoes com 'Left' e 'Right', pois alguns registros dos campos A1_TEL E A1_TEL2 tem um "-" contido.

			cQuery += " AND (SA1.A1_CGC = '"+cCpfCnpj+"' )"
			cQuery += " OR ("
			cQuery +=		" SA1.A1_TEL  LIKE '%" + Left(cCpfCnpj , 4) + '%' + Right(cCpfCnpj , 4) + "%'"  // Verifica telefone fixo
			cQuery +=		" OR SA1.A1_TEL2  LIKE '%" + Left(cCpfCnpj , 4) + '%' + Right(cCpfCnpj , 4) + "%'"  // Verifica telefone fixo
			cQuery +=		" OR SA1.A1_TEL  LIKE '%" + Left(cCpfCnpj , 5) + '%' + Right(cCpfCnpj , 4) + "%'"  // Verifica telefone fixo
			cQuery +=		" OR SA1.A1_TEL2  LIKE '%" + Left(cCpfCnpj , 5) + '%' + Right(cCpfCnpj , 4) + "%'" // Verifica telefone fixo
			cQuery += 		" OR SA1.A1_NOME LIKE '%" + Upper(cCpfCnpj)+"%' "
			cQuery += " ) "

		EndIf

		//cQuery	+= " AND SA1.A1_COD = '277684' "

		cQuery	+=	" GROUP BY SA1.A1_NOME , SA1.A1_CGC "
		cQuery	+=	" ORDER by SA1.A1_NOME "

		cQuery	:= StrTran(cQuery , Space(2) , Space(1))

		cAlias := "TMP01" //getNextAlias()

		If (Select(cAlias) > 0)

			TMP01->(dbCloseArea())

		EndIf

		PLSQuery(cQuery , cAlias)
		DbSelectArea(cAlias)
		(cAlias)->(DbGoTop())

		aItTMP 	:= {} //aItTMP -> Array auxiliar utilizado para preenchimento dos itens que serao exibidos no grid

		If (cAlias)->(!Eof())

			nQtFields	:= (cAlias)->(fCount())

			aItens	:= {}

			Do While (cAlias)->(!Eof())

				If (Empty(cCpfCnpj))// Quando for disparada a ação de pesquisa, ignorar os critérios de validação de datas, pois trata-se de cliente agendado ou cliente que retornou contato.

					lGrava	:= .F.

					Do Case
						//Regras:
						//1 - Se o cliente não tiver pedido, chamado e zl5 acrescenta 4 meses a partir do campo A1_DTCAD
						//2 - Se o cliente tiver pedido e não tiver chamado e não tiver zl5 acrescenta  4 meses a partir do campo C5_EMISSAO
						//3 - Se o cliente tiver pedido e chamado e não tiver zl5 acrescenta  4 meses a partir do campo UC_DATA
						//4 - Se o cliente tiver pedido e chamado e zl5 e o campo ZL6_DTAGEN estiver preenchido acrescenta  4 meses a partir do campo ZL6_DTAGEN
						//5 - Se o ZL6_DTAGEN estiver preenchido, analisar entre os campos ZL6_DTCON e ZL6_DTAGEN se foi gerada alguma venda, caso exista, considerar 4 meses à partir das regras 2 e 3

						Case ( !Empty((cAlias)->(DT_COMPRA)) )

							If ( (!Empty((cAlias)->(DT_CONTATO))) .AND. (!Empty((cAlias)->(DT_AGENDAMENTO))) )//Verifica se ambas as datas(Contato com cliente e Agendamento) estao preenchidas

								If (((cAlias)->(DT_COMPRA) >=  (cAlias)->(DT_CONTATO)) .AND. ;
									((cAlias)->(DT_COMPRA) <=  (cAlias)->(DT_AGENDAMENTO)) )
									//Houve compra entre a data do contato e a data agendada

									lGrava	:= ((sToD((cAlias)->(DT_COMPRA)) + nDiasPrz) == _dData) //Se a data apurada (somada com o periodo informado no parametro KH_PRZCON)é a data solicitada na pesquisa (Calendário)

								Else

									lGrava	:= sToD((cAlias)->(DT_AGENDAMENTO)) == _dData //Senao, verifica se ha algum atendimento agendado para a data informada

								EndIf

							Else

								dDataX		:= Max(Val((cAlias)->(DT_CHAMADO)) , Val((cAlias)->(DT_AGENDAMENTO)))//Verifica a maior data entre: Chamado aberto no SAC e Contato realizado pela área de relacionamento;

								dDataX		:= Max(dDataX , Val((cAlias)->(DT_COMPRA)))//Verifica a maior data entre: Data apurada acima e a data de compra

								dDataX		:= sToD(AllTrim(Str(dDataX)))

								lGrava		:= (dDataX + nDiasPrz) == _dData //Se a data apurada (somada com o periodo informado no parametro KH_PRZCON)é a data solicitada na pesquisa (Calendário)

							EndIf

						OtherWise

							If !(lGrava	:= sToD((cAlias)->(DT_AGENDAMENTO)) == _dData) //Senao, verifica se ha algum atendimento agendado para a data informada

								dDataX		:= Max(Val((cAlias)->(DT_CHAMADO)) , Val((cAlias)->(DT_AGENDAMENTO))) //Verifica a maior data entre Chamado aberto(SAC) e a Data do contato agendado;

								dDataX		:= Max(dDataX , Val((cAlias)->(DTSA1))) //Verifica a maior data entre a data apurada acima e a data do cadastro do cliente

								dDataX		:= sToD(AllTrim(Str(dDataX)))

								lGrava		:= (dDataX + nDiasPrz) == _dData //Se a data apurada (somada com o periodo informado no parametro KH_PRZCON)é a data solicitada na pesquisa (Calendário)

							EndIf

					EndCase

				Else

					lGrava	:= .T.

				EndIf

				If (lGrava)

					For nX := 1 TO (cAlias)->(fCount())

						cFieldName	:= (cAlias)->(FieldName(nX))

						xRet		:= AllTrim((cAlias)->(FieldGet(nX)))

						Do Case

							Case (cFieldname == "CUPOM")

								AADD(aItTMP , U_KHCodAleat()) //Gera o codigo do cupom em tempo de execucao. A rotina esta no fonte KHXFUN

							Case (cFieldname $ "TELCLI1|TELCLI2")

								If !(Empty(xRet))

									AADD(aItTMP , "(" + AllTrim((cAlias)->(DDD)) +  ")" + xRet )

								Else

									AADD(aItTMP , '')

								EndIf

							Case (cFieldname $ "DTSA1|DT_CHAMADO|DT_COMPRA|DT_AGENDAMENTO")

								xRet	:= sToD(xRet)

								AADD(aItTMP , xRet)

							Case (cFieldname $ "OBS")

								AADD(aItTMP , '')

							Case (cFieldname == "PEDIDO")

								If (Empty(xRet) )

									AADD(aItTMP , 'NETGERA')

								Else

									AADD(aItTMP , xRet)

								EndIf

							Case (cFieldname == "SUSPECT_ENVIADO")

								cQryZL7	:= " SELECT "
								cQryZL7	+=		" ZL7.ZL7_XTIPO SUSPECT "
								cQryZL7	+=	" FROM "
								cQryZL7	+=		" ZL7010 ZL7 "
								cQryZL7	+=	" WHERE "
								cQryZL7	+=		" ZL7.R_E_C_N_O_= ( "
								cQryZL7	+=			" SELECT MAX(ZL7.R_E_C_N_O_) FROM ZL7010 ZL7 WHERE ZL7.D_E_L_E_T_ = '' AND ZL7.ZL7_XCPF = '" + (cAlias)->CPF + "' AND "
								cQryZL7	+=			" ZL7.ZL7_XTIPO = '1' "
								cQryZL7	+= 		" ) " 

								cQryZL7	:= StrTran(cQryZL7 , Space(2) , Space(1))

								If (Select("TMP02") > 0)

									TMP02->(dbCloseArea())

								EndIf

								dbUseArea(.T. , "TOPCONN" , TcGenQry(,,cQryZL7) , "TMP02" , .T. , .F.)

								If ( TMP02->(!EOF()) )

									xRet	:= "SIM"

								Else

									xRet	:= "NÃO"

								EndIf

								AADD(aItTMP , xRet)

							Case (cFieldName == "OPERADOR")

								xRet	:= UsrRetName((cAlias)->CODOPE)

								AADD(aItTMP , xRet)

							Case (cFieldname == "STATUS_WHATSAPP")

								cQryZL7	:= " SELECT "
								cQryZL7	+=		" ZL7.ZL7_WAPP WHATS "
								cQryZL7	+=	" FROM "
								cQryZL7	+=		" ZL7010 ZL7 "
								cQryZL7	+=	" WHERE "
								cQryZL7	+=		" ZL7.R_E_C_N_O_= "
								cQryZL7	+=			" (SELECT MAX(ZL7.R_E_C_N_O_) FROM ZL7010 ZL7 WHERE ZL7.D_E_L_E_T_ = '' AND ZL7.ZL7_XCPF = '" + (cAlias)->CPF + "' ) " //02293620875

								cQryZL7	:= StrTran(cQryZL7 , Space(2) , Space(1))

								If (Select("TMP02") > 0)

									TMP02->(dbCloseArea())

								EndIf

								dbUseArea(.T. , "TOPCONN" , TcGenQry(,,cQryZL7) , "TMP02" , .T. , .F.)

								If ( TMP02->WHATS == "X" )

									xRet	:= "SIM"

								Else

									xRet	:= "NÃO"

								EndIf

								AADD(aItTMP , xRet)

							OtherWise

								aRetSX3		:= {}

								Do Case

									Case (cFieldName == "NIVEL")

										aRetSX3 := RetSX3Box(GetSX3Cache("ZL5_NIVEL", "X3_CBOX"),,,1)

									Case (cFieldName == "NOTA")

										aRetSX3 := RetSX3Box(GetSX3Cache("ZL5_NOTA", "X3_CBOX"),,,1)

									Case (cFieldName == "STATUS")

										aRetSX3 := RetSX3Box(GetSX3Cache("ZL5_STATUS", "X3_CBOX"),,,1)

									Case (cFieldName == "BRINDE")

										aRetSX3 := RetSX3Box(GetSX3Cache("ZL5_BRINDE", "X3_CBOX"),,,1)

									Case (cFieldName == "PENDENCIA")

										aRetSX3 := RetSX3Box(GetSX3Cache("ZL5_PEND", "X3_CBOX"),,,1)

								EndCase

								If (Len(aRetSX3) > 0)

									nPos	:=	Ascan(aRetSX3 , {|x| x[2] == xRet})

									If (nPos > 0)

										xRet	:= AllTrim(aRetSX3[nPos , 3])

									EndIf

								EndIf

								AADD(aItTMP , xRet)

						EndCase

					Next nX

					AADD(aItens , aClone(aItTMP)) //A variavel 'aItens' e' declarada como 'private'.

				EndIf

				(cAlias)->(dbSkip())

				aItTMP		:= {}

			EndDo

			aItBKP	:= aClone(aItens)

		Else

			MsgAlert("Dados não localizados. Faça uma nova pesquisa")

			aItens	:= Array(1 , (cAlias)->(fCount()))

			For nX := 1 TO (cAlias)->(fCount())

				aItens[1,nX]	:= ''

			Next nX

		EndIf

	Else

		If (Len(aItens) > 0)

			aItTMP	:= {}

			For nX := 1 TO Len(aItens)

				If (aItens[nX,1] $ cFiltro)

					AADD(aItTMP , aClone(aItens[nX]))

				EndIf

			Next nX

			If (Len(aItTMP) > 0)

				aItens	:= aClone(aItTMP)

			Else

				aItens	:= {}

			EndIf

		EndIf

	EndIf

	If (Len(aItens) == 0)

		MsgAlert("Não foram localizados registros para o período solicitado")

		aItens		:= Array(1 , nQtFields)

		For nX := 1 TO nQtFields

			aItens[1,nX]	:= ''

		Next nX

	EndIf

	::aItens := aClone(aItens)

	OBrwItens:SetArray(aItens)

	OBrwItens:bLine := {|| {    	IIF(aItens[OBrwItens:nAt,1] == "AMARELO" , oAmarelo ,;
									IIF(aItens[OBrwItens:nAt,1] == "AZUL" , oAzul,;
									IIF(aItens[OBrwItens:nAt,1] == "BRANCO" , oBranco,;
									IIF(aItens[OBrwItens:nAt,1] == "VERMELHO" , oVermelho,;
									IIF(aItens[OBrwItens:nAt,1] == "LARANJA" , oLaranja,;
									IIF(aItens[OBrwItens:nAt,1] == "PRETO" , oPreto,;
									IIF(aItens[OBrwItens:nAt,1] == "VERDE" , oVerde , oAmarelo))))))),;
									aItens[OBrwItens:nAt,2] ,;
									aItens[OBrwItens:nAt,3] ,;
									aItens[OBrwItens:nAt,4] ,;
									aItens[OBrwItens:nAt,5] ,;
									aItens[OBrwItens:nAt,6] ,;
									aItens[OBrwItens:nAt,7] ,;
									aItens[OBrwItens:nAt,8] ,;
									aItens[OBrwItens:nAt,9] ,;
									aItens[OBrwItens:nAt,10],;
									aItens[OBrwItens:nAt,11],;
									aItens[OBrwItens:nAt,12],;
									aItens[OBrwItens:nAt,13],;
									aItens[OBrwItens:nAt,14],;
									aItens[OBrwItens:nAt,15],;
									aItens[OBrwItens:nAt,16],;
									aItens[OBrwItens:nAt,17],;
									aItens[OBrwItens:nAt,18],;
									aItens[OBrwItens:nAt,19],;
									aItens[OBrwItens:nAt,20],;
									aItens[OBrwItens:nAt,21],;
									aItens[OBrwItens:nAt,22],;
									aItens[OBrwItens:nAt,23],;
									aItens[OBrwItens:nAt,24],;
									aItens[OBrwItens:nAt,25],;
									aItens[OBrwItens:nAt,26],;
									aItens[OBrwItens:nAt,27];
										}}
	//OBrwItens:Align := CONTROL_ALIGN_ALLCLIENT
	OBrwItens:refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ zLegenda   ºAutor  ³Microsiga         º Data ³  09/06/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria array com as cores/legendas                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function zLegenda()

	Local aLegenda := {}

	//Monta as legendas (Cor, Legenda)

	aAdd(aLegenda,     {"BR_AMARELO"	, 	"Livre"  })
	aAdd(aLegenda,     {"BR_AZUL"		,	"Em Atendimento" })
	aAdd(aLegenda,     {"BR_VERMELHO" 	,	"Sem Resposta" })
	aAdd(aLegenda,     {"BR_VERDE"		,	"Ligação efetiva"})
	aAdd(aLegenda,     {"BR_PRETO"		,	"Não Ligar"})
	aAdd(aLegenda,     {"BR_LARANJA"	,	"Em Atendimento com outro operador"})
	aAdd(aLegenda,     {"BR_BRANCO"     ,	"Cliente agendado para a data"})

	/*
	aAdd(aLegenda,     {"BR_LARANJA"   ,"Visita Tecnica"})	        //"Visita Tec" --> Customizado Komfort
	aAdd(aLegenda,     {"BR_PINK"      ,"Devolucao"})	                //"Devolucao" --> Customizado Komfort
	aAdd(aLegenda,     {"BR_BRANCO"    ,"Retorno"})	                //"Retorno" --> Customizado Komfort
	aAdd(aLegenda,     {"BR_VIOLETA"   ,"Troca Autorizada"})          //"Troca Aut" --> Customizado Komfort
	aAdd(aLegenda,     {"BR_CINZA"		,"Compartilhamento" })	    //"Compartilhamento" --> Padrão
	aAdd(aLegenda,     {"BR_AZUL_CLARO","Email Fabricante"})          // Email Fabricante --> Customizado Komfort
	*/
	//Chama a função que monta a tela de legenda
	BrwLegenda("STATUS CHAMADO", "Status Chamado", aLegenda)

Return


//--------------------------------------------------------------
/*/{Protheus.doc} fSetOperacao
Description //Define a ação com base na coluna clicada
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul
@since 11/02/2019 /*/
//--------------------------------------------------------------
Static Function fSetOPeracao(nColuna,_array , nLinha , _dData)

	Local cColuna		:= StrZero(nColuna,2)

	DEFAULT nLinha		:= 0 //A variavel 'nLinha' e proveniente do atributo 'nAt' e so sera recebida no evento 'duplo click' no browse
	DEFAULT _dData		:= dDataBase

	Do Case

		Case (cColuna == '15') //Observação

			If (lIniAtend) // A variavel 'lIniAtend' é alterada ao disparar a ação de 'Iniciar Atendimento (Rotina: KHX00602)

				Processa( {|| fInfocobr(_array , _dData) }, "Aguarde...", "Localizando Histórico...", .f.)

			EndIf

		Case cColuna $ '09|16|17|18|20|22|23|24' //Colunas disponiveis para escolha do Combo

			If (lIniAtend)

				fInfCliente(nColuna,nLinha)

			EndIf

		Case StrZero(nColuna , 2) $ "02|10" //Permite consulta ao cadastro de clientes e Pedido de Vendas

			KHX00603(_array , nColuna)

	EndCase

Return
//--------------------------------------------------------------
/*/{Protheus.doc} fInfCliente
Description //Define a ação com base na coluna clicada
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul
@since 11/02/2019 /*/
//--------------------------------------------------------------

Static Function fInfCliente(nColuna,nLinha)

	Local aNivel	:= {}
	Local aBkp		:= {}
	Local nX		:= 500
	Local nY		:= 280
	Local nXB		:= 105
	Local nYB		:= 5
	Local nZ		:= 0
	Local cCombo1	:= ""
	Local nRet		:= 0
	Local cTitulo	:= ""
	Local cPrompt	:= ""
	Local lCombo	:= .T.
	Local cCodigo	:= Space(20)
	Local oCombo1

	cTitulo			:= "Selecione "

	Do Case

		Case (StrZero(nColuna , 2) $ '09|20') //Colunas: Data de Reagendamento e Código do chamado (caso seja aberto algum)

			lCombo	:= .F. //Inibe a geração do combo para as demais rotinas

			Do Case

				Case (nColuna == 9)

					cTitulo		:= "Contato do Suspect"
					cPrompt		:= "Informe o contato do Suspect"

				Case (nColuna == 20)

					cTitulo		:= "Cadastro do código do chamado"
					cPrompt		:= "Informe o código do chamado aberto."

			EndCase

			DEFINE MSDIALOG oDlgDate TITLE cTitulo FROM 000, 000  TO 085, 200 COLORS 0, 16777215 PIXEL

				@ 002, 002 SAY oTexto PROMPT cPrompt SIZE 150, 070 OF oDlgDate COLORS 225, 16777215 PIXEL
				@ 013, 002 MSGET oCodigo VAR cCodigo SIZE 069, 010 OF oDlgDate COLORS 0, 16777215 PIXEL
				@ 027, 002 BUTTON oBtnConfirm PROMPT "Confirmar" SIZE 069, 012 OF oDlgDate ACTION {|| lOk:=.T., oDlgDate:end() } PIXEL

				//oBtnConfirm:setCSS("QPushButton{color: #FFFFFF; border: 1px solid #6B8E23; border-radius: 4px; background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #008000, stop: 1 #00FF7F);} QPushButton:pressed {background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #00FF7F, stop: 1 #008000);}")

			ACTIVATE MSDIALOG oDlgDate CENTERED

			If !(Empty(cCodigo))

				//OBrwItens:aArray[OBrwItens:nAt,nColuna] := cCodigo
				aZL5[nColuna]		:= cCodigo

			EndIf

		Case (nColuna == 16)

			aNivel		:= RetSX3Box(GetSX3Cache("ZL5_NIVEL", "X3_CBOX"),,,1)
			cTitulo		+= "o Nível de Satisfação"

		Case (nColuna == 17)

			aNivel		:= RetSX3Box(GetSX3Cache("ZL5_NOTA", "X3_CBOX"),,,1)
			cTitulo		+= "a Nota de Satisfação"

		Case (nColuna == 18)

			aNivel		:= RetSX3Box(GetSX3Cache("ZL5_STATUS", "X3_CBOX"),,,1)
			cTitulo		+= "o Status Contato"

		Case (nColuna == 22)

			aNivel		:= RetSX3Box(GetSX3Cache("ZL5_PERC", "X3_CBOX"),,,1)
			cTitulo		+= "o Percentual de Desconto"

		Case (nColuna == 23)

			aNivel		:= RetSX3Box(GetSX3Cache("ZL5_BRINDE", "X3_CBOX"),,,1)
			cTitulo		+= "o Tipo do Brinde"

		Case (nColuna == 24)

			aNivel		:= RetSX3Box(GetSX3Cache("ZL5_PEND", "X3_CBOX"),,,1)
			cTitulo		+= "a Pendencia de Contato"

	End Case

	/* O box referente ao whats app não sera mais exibido. O campo sera gravado no momento de gerar o relatorio.
	Case (nColuna == 19)

		aNivel		:= RetSX3Box(GetSX3Cache("ZL5_WAPP", "X3_CBOX"),,,1)
		cTitulo		+= "o Status WhatsApp"
	*/

	If (lCombo)

		aBkp	:= aClone(aNivel)

		aNivel	:= {}

		For nZ := 1 TO Len(aBkp)

			If !(Empty(AllTrim(aBkp[nZ , 3])))

				AADD(aNivel , aBkp[nZ,3])

			EndIf

		Next nZ

		nY		+= Len(aNivel) * 2

		DEFINE DIALOG oDlg TITLE cTitulo FROM 180,180 TO nY,nX PIXEL

			oCombo1 := TComboBox():New(02,02,{|u|if(PCount()>0,cCombo1:=u,cCombo1)},;
			aNivel,100,20,oDlg,,{||nRet := oCombo1:nAT};
			,,,,.T.,,,,,,,,,'cCombo1')

			@ nYB,nXB BUTTON oButton PROMPT 'Ok' OF oDlg PIXEL ACTION oDlg:End()

		ACTIVATE DIALOG oDlg CENTERED

		If (nRet == 0)

			++nRet

		EndIf

		OBrwItens:aArray[OBrwItens:nAt,nColuna] := cCombo1

		If (Empty(cCombo1))

			aZL5[nColuna]	:= ""

		Else

		Do Case

			Case (nColuna == 17) // "Nota de Satisfação"

				If !(Empty(cCombo1))

					aZL5[nColuna]	:= AllTrim(aNivel[Ascan(aNivel , cCombo1)])

				EndIf

			Case (nColuna == 18) // Status de pendencia

				aZL5[nColuna]		:= 	AllTrim(aBkp[Ascan(aBkp , {|x| x[2] == AllTrim(Str(nRet))} ) , 2])

				Do Case

					Case (nRet == 1)//Efetivo

						OBrwItens:aArray[nLinha,1]	:= "VERDE"

					Case (nRet == 2)//Nao Efetivo

						OBrwItens:aArray[nLinha,1]	:= "VERMELHO"

					Case (nRet == 4)//Não ligar

						OBrwItens:aArray[nLinha,1]	:= "PRETO"

				EndCase

			Case (nColuna == 22)// "Perc. de Desconto"

				aZL5[nColuna] 	:= cCombo1

			OtherWise

				aZL5[nColuna]		:= 	AllTrim(aBkp[Ascan(aBkp , {|x| x[2] == AllTrim(Str(nRet))} ) , 2])

			EndCase

		EndIf

	Else

		If !(nColuna == 9)

			OBrwItens:aArray[OBrwItens:nAt,nColuna] := cCodigo

		EndIf

	EndIf

Return


//--------------------------------------------------------------
/*/{Protheus.doc} MyFunction
Description

@param xParam Parameter Description
@return xRet Return Description
@author  -Wellington Raul
@since 11/02/2019
/*/
//--------------------------------------------------------------
Static Function fInfocobr(_array , _dData)
	Local oButton1
	Local oButton2
	Local oGet1
	Local cHIs:= ""
	Local oGet2
	Local cNovo := ""
	Local oGet3
	Local dRetor:= Date()
	Local oSay1
	Local oSay2
	Local oSay3
	Local cChaveZL5	:= xFilial("ZL5")+_array[2] + _arraY[3]
	Local lFound	:= .F.
	Local aArea		:= {}
	Local lConfirma	:= .F.
	Local oDlg

	aArea	:= ZL5->(GetArea())
	ZL5->(dbSetOrder(1)) // FILIAL + COD.CLIENTE
	lFound	:= (ZL5->(dbSeek(cChaveZL5)))
	cHIs 	:=ZL5->ZL5_OBS

	DEFINE MSDIALOG oDlg TITLE "Informações do Cliente" FROM 000, 000  TO 500, 500 COLORS 0, 16777215 PIXEL

		@ 027, 013 GET oGet1 VAR cHIs MEMO SIZE 226, 073 WHEN .F. OF oDlg COLORS 0, 16777215 PIXEL
		@ 122, 013 GET oGet2 VAR cNovo MEMO SIZE 221, 077 OF oDlg COLORS 0, 16777215 PIXEL
		@ 013, 089 SAY oSay1 PROMPT "Histórico de Atendimento" SIZE 064, 007 OF oDlg COLORS 0, 16777215 PIXEL
		@ 107, 097 SAY oSay2 PROMPT "Nova Informação" SIZE 044, 009 OF oDlg COLORS 0, 16777215 PIXEL
		@ 221, 012 SAY oSay3 PROMPT "Retorno" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
		@ 221, 054 MSGET oGet3 VAR dRetor SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
		@ 212, 136 BUTTON oButton1 PROMPT "Cancelar" SIZE 037, 012 OF oDlg ACTION (oDlg:End())  PIXEL
		@ 212, 191 BUTTON oButton2 PROMPT "Salvar" SIZE 037, 012 OF oDlg ACTION (lConfirma := .T. , oDlg:End()) PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED

	If ( (!Empty(cNovo)) .OR. (dRetor > dDataBase) )

		If (lConfirma)

			lReagend	:= .T.

			If (RecLock("ZL5" , !lFound))

				cNovo	:= IIf(!Empty(AllTrim(cHis)) , cHis + CHR(13) + CHR(10) + dToC(_dData) + ' - ' + UsrRetName(RetCodUsr()) + " : " + cNovo + CHR(13) + CHR(10) + REPLICATE('-' , 100) ,;
					dToC(_dData) + ' - ' + UsrRetName(RetCodUsr()) + " : " + cNovo + CHR(13)+CHR(10) + Replicate('-' , 100) )

				ZL5->ZL5_CODCLI		:= _array[2]
				ZL5->ZL5_LOJA		:= _array[3]
				ZL5->ZL5_CODOPE		:= RetCodUsr()
				ZL5->ZL5_HRINI		:= TIME()
				ZL5->ZL5_OBS		:= cNovo

				If (dRetor > _dData)

					ZL5->ZL5_DTAGEN	:= dRetor

				EndIf

				ZL5->(MsUnlock())

			EndIf

		EndIf

	EndIf

	RestArea(aArea)

Return

/*
=====================================================================================
Programa.:              KHX00602
Autor....:              Luis Artuso
Data.....:              12/09/2019
Descricao / Objetivo:   Efetua a gravação nas tabelas de contato: Cabecalho (ZL5) e Historico de contatos (ZL6)
Doc. Origem:
Obs......:
=====================================================================================
*/
Static Function KHX00602(aArray , lReserva , lLibera , cTipo)

	Local aFieldsZL5	:= {}
	Local nX			:= 0
	Local cCodCli		:= ""
	Local cCodLoja		:= ""
	Local cHrIni		:= ""
	Local cHrFim		:= ""
	Local cGrava		:= ""
	Local cChaveZL5		:= aArray[2] + aArray[3] // Codigo e loja do cliente
	Local oGrava		:= MNGDATA():NEW()

	DEFAULT cTipo	:= ""

	ZL5->(dbSetOrder(1))
	ZL5->(dbGoTop())

	If (ZL5->(dbSeek(xFilial("ZL5") + cChaveZL5)))

		If (RecLock("ZL5" , .F.))

			Do Case

				Case (lReserva)

					ZL5->ZL5_HRINI		:= TIME()

				Case (lLibera)

					/*
					*Estrutura do Array aDados*
						{	"" 						,;1
						"Cód. Cliente"				,;2
						"Loja"						,;3
						"Cliente"					,;4
						"CPF"						,;5
						"Dt.Cad. (Cliente)"			,;6
						"Tel. Contato 1"			,;7
						"Tel. Contato 2"			,;8
						"Tel. Relacionamento"		,;9
						"Ped. de Venda"				,;10
						"Dt. Últ. Compra" 			,;11
						"Dt.Chamado"				,;12
						"Cód. Chamado"				,;13
						"Assunto do Chamado"		,;14
						"Obs." 						,;15
						"Nível Satisfação" 			,;16
						"Nota de Satisfação" 		,;17
						"Status Contato" 			,;18
						"Status WhatsApp"			,;19
						"Ch. Ocorrência"			,;20
						"Cupom"						,;21
						"Perc. de Desconto"			,;22
						"Tp. do Brinde"				,;23
						"Pend. de Contato"			; 24
					*/

					ZL5->ZL5_CODCLI		:= aArray[2]
					ZL5->ZL5_DTCAD		:= aArray[6]
					ZL5->ZL5_STATUS		:= IIF(!Empty(aZL5[18]) , aZL5[18] , ZL5->ZL5_STATUS)
					ZL5->ZL5_NIVEL		:= IIF(!Empty(aZL5[16]) , aZL5[16] , ZL5->ZL5_NIVEL)
					ZL5->ZL5_CHAMAD		:= IIF(!Empty(aZL5[20]) , aZL5[20] , ZL5->ZL5_CHAMAD)
					ZL5->ZL5_PEND		:= IIF(!Empty(aZL5[24]) , aZL5[24] , ZL5->ZL5_PEND)
					ZL5->ZL5_WAPP		:= IIF(!Empty(aZL5[19]) , aZL5[19] , ZL5->ZL5_WAPP)
					ZL5->ZL5_BRINDE		:= IIF(!Empty(aZL5[23]) , aZL5[23] , ZL5->ZL5_BRINDE)
					ZL5->ZL5_IMP		:= ""
					ZL5->ZL5_LOJA		:= aArray[3]
					ZL5->ZL5_PERC		:= IIF(!Empty(aZL5[22]) , aZL5[22] , ZL5->ZL5_PERC)
					ZL5->ZL5_NOTA		:= IIF(!Empty(aZL5[17]) , aZL5[17] , ZL5->ZL5_NOTA)
					ZL5->ZL5_CODOPE		:= RetCodUsr()
					ZL5->ZL5_DTCON		:= dDataBase
					ZL5->ZL5_XTELS1		:= aArray[7]
					ZL5->ZL5_XTELS2		:= aArray[8]
					ZL5->ZL5_XTELS3		:= aArray[9]
					ZL5->ZL5_LIGAR		:= ""
					ZL5->ZL5_HRFIM		:= TIME()

					If (RecLock("ZL6" , .T.))

						ZL6->ZL6_CODCLI		:= ZL5->ZL5_CODCLI
						ZL6->ZL6_DTCON		:= ZL5->ZL5_DTCON
						ZL6->ZL6_DTAGEN		:= ZL5->ZL5_DTAGEN
						ZL6->ZL6_CODOP		:= ZL5->ZL5_CODOPE
						ZL6->ZL6_LOJA		:= ZL5->ZL5_LOJA
						ZL6->ZL6_HRINI		:= ZL5->ZL5_HRINI
						ZL6->ZL6_HRFIM		:= ZL5->ZL5_HRFIM
						ZL6->ZL6_NIVEL		:= ZL5->ZL5_NIVEL
						ZL6->ZL6_NOTA		:= ZL5->ZL5_NOTA
						ZL6->ZL6_STATUS		:= ZL5->ZL5_STATUS
						ZL6->ZL6_WAPP		:= ZL5->ZL5_WAPP
						ZL6->ZL6_PERC		:= ZL5->ZL5_PERC
						ZL6->ZL6_BRINDE		:= ZL5->ZL5_BRINDE
						ZL6->ZL6_PEND		:= ZL5->ZL5_PEND

						ZL6->(MsUnlock())

					EndIf

				If (!Empty(cTipo))

					//Grava o rastreamento do cupom. Com isto, sera possivel identificar:
					// - Em qual loja o cupom foi utilizado(se utilizado);
					// - Em qual data;
					// - Quem utilizou;
					// - Qual usuario inseriu o cupom

					aGravar		:= {{"ZL7_CODCLI"	, aArray[2]},;
									{"ZL7_LOJA" 	, aArray[3]},;
									{"ZL7_CODOPE" 	, RetCodUsr()},;
									{"ZL7_CUPOM" 	, aArray[21]},;
									{"ZL7_DATA" 	, dDataBase},;
									{"ZL7_PERC" 	, aZL5[22]},;
									{"ZL7_XCPF" 	, aArray[5]},;
									{"ZL7_XTIPO" 	, cTipo}; //1->Suspect;2->Brinde;3->Informativo
									}
									//{"ZL7_TPBRIN" 	, IIF(aZL5[24] == "5" , "1" , "2" )},; // 1-> P/ Cupom de brinde; 2-> Informativo
					//* O metodo 'GravaData' encontra-se no fonte KHCLAFUN
					oGrava:GravaData(	"ZL7" 	,; 	//Alias
										.T. 	,; 	//'.T.' para novo registro. '.F.' para atualização
										aGravar) 	// Array com os campos/conteúdos para gravação.

				EndIf

			EndCase

			ZL5->(MsUnlock())

		EndIf

	Else

		If (lReserva) //Se disparada a ação de reserva(e registro nao existente na ZL5), grava um novo registro, com hora inicial do atendimento

			If (RecLock("ZL5" , .T.))

				ZL5->ZL5_HRINI		:= TIME()
				ZL5->ZL5_CODCLI		:= aArray[2]
				ZL5->ZL5_LOJA		:= aArray[3]

				ZL5->(MsUnlock())

			EndIf

		EndIf

	EndIf

Return

/*
=====================================================================================
Programa.:              KHX00603
Autor....:              Luis Artuso
Data.....:              12/09/2019
Descricao / Objetivo:   Permite a consulta aos cadastros: Clientes e pedido de vendas
Obs......:
=====================================================================================
*/
Static Function KHX00603(aArray,nColuna)

	Local aArea			:= {}
	Local cFilQuery		:= ""
	Local cField		:= ""
	Local cTmp			:= ""
	Local cAlias		:= ""
	Private cCadastro	:= ""
	Private aRotina		:= {}

	cTmp		:= aArray[nColuna]

	Do Case

		Case (nColuna == 2) //Consulta ao cadastro de clientes

			cAlias		:= "SA1"

			aArea		:= (cAlias)->(GetArea())

			cField		:= "A1_COD"

			cCadastro	:= "Consulta Cadastro de Clientes"

			AADD( aRotina, { "Visualizar" ,"AxVisual" ,0,2,0 ,NIL})

			cFilQuery	:= cField + " = " +  "'" + cTmp  + "'"

			aArea		:= (cAlias)->(GetArea())

			mBrowse( 6, 1 ,22 , 75,cAlias,,,,,,,,,,,,,,cFilQuery)

			RestArea( aArea )

		Case (nColuna == 10) //Consulta ao pedido de vendas

			cAlias		:= "SC5"

			aArea		:= (cAlias)->(GetArea())

			cCadastro	:= "Consulta Pedido de Vendas"

			(cAlias)->(dbSetOrder(1))

			If ((cAlias)->(dbSeek(xFilial(cAlias) + cTmp)))

				MatA410(Nil, Nil, Nil, Nil, "A410Visual")

			Else

				MsgAlert("Não existem pedidos de venda para este cliente")

			EndIf

	EndCase

	RestArea( aArea )

Return

/*
=====================================================================================
Programa.:              KHX00604
Autor....:              Luis Artuso
Data.....:              12/09/2019
Descricao / Objetivo:   Permite a gravação do suspect
Obs......:
=====================================================================================
*/
Static Function KHX00604(aDados)

	Local cPrompt	:= "Nome do Cliente :"
	Local cPrompt1	:= "Telefone 1 : "
	Local cPrompt2	:= "Telefone 2 : "
	Local cPrompt3	:= "Telefone 3 : "
	Local cPrompt4	:= "Filial:"
	Local cPrompt5	:= "Obs:"
	Local cCodigo	:= Space(50)
	Local cCodigo1	:= Space(10)
	Local cCodigo2	:= Space(20)
	Local cCodigo3	:= Space(30)
	Local cCodigo4	:= Space(10)
	Local cCodigo5	:= Space(100)
	Local nLI		:= 0
	Local nCI		:= 0
	Local nLF		:= 0
	Local nCF		:= 0
	Local lOk		:= .F.
	Local cCodSus	:= ""

	If !(lSuspect)

		Aviso("Atendimento em aberto" , "Para gravar o Suspect, é necessário que o atendimento esteja encerrado. ")

	Else

		DEFINE MSDIALOG oDlgDate TITLE "Dados de Contato do Suspect" FROM nLI , nCI  TO nLF	:= 400 , nCF := 500 COLORS 0, 16777215 PIXEL

			nCi		:= 80

			@ nLI += 15 , 20 SAY oTexto PROMPT cPrompt SIZE 70 , 50 OF oDlgDate PIXEL //COLORS 225, 16777215
			@ nLi , nCi MSGET oCodigo VAR cCodigo := aDados[4] SIZE 150 , 010 OF oDlgDate PIXEL//COLORS 0, 16777215

			@ nLI += 15 , 20 SAY oTexto1 PROMPT cPrompt1 SIZE 70 , 50 OF oDlgDate PIXEL//COLORS 225, 16777215
			@ nLi , nCi MSGET oCodigo1 VAR cCodigo1 := aDados[9] SIZE 60 , 010 OF oDlgDate PIXEL //COLORS 0, 16777215

			@ nLI += 15 , 20 SAY oTexto2 PROMPT cPrompt2 SIZE 70 , 50 OF oDlgDate PIXEL//COLORS 225, 16777215
			@ nLi , nCi MSGET oCodigo2 VAR cCodigo2 := aDados[7] SIZE 60 , 010 OF oDlgDate PIXEL//COLORS 0, 16777215

			@ nLI += 15 , 20 SAY oTexto3 PROMPT cPrompt3 SIZE 70 , 50 OF oDlgDate PIXEL//COLORS 225, 16777215
			@ nLi , nCi MSGET oCodigo3 VAR cCodigo3 := aDados[8] SIZE 60, 010 OF oDlgDate PIXEL//COLORS 0, 16777215

			@ nLI += 15 , 20 SAY oTexto4 PROMPT cPrompt4 SIZE 70 , 50 OF oDlgDate PIXEL//COLORS 225, 16777215
			cCodigo4	:= "0101"
			@ nLi , nCi MSGET oCodigo4 VAR cCodigo4 SIZE 30 , 10 When .T. F3 "SM0" OF oDlgDate VALID KHX00608(cCodigo4) PIXEL//COLORS 0, 16777215
			@ nLi , nCi + 40 SAY oTexto5 VAR SM0->M0_FILIAL SIZE 70 , 10 OF oDlgDate PIXEL//COLORS 0, 16777215

			@ nLI += 15 , 20 SAY oTexto6 PROMPT cPrompt5 SIZE 10 , 10 OF oDlgDate PIXEL//COLORS 225, 16777215
			@ nLI , nCi GET oGet1 VAR cCodigo5 MEMO SIZE  130 , 80 OF oDlgDate PIXEL//COLORS 0, 16777215

			@ nLI += 90, nCi+40 BUTTON oBtnConfirm PROMPT "Confirmar" SIZE 069, 012 OF oDlgDate ACTION {|| lOk := oDlgDate:end() } PIXEL

		ACTIVATE MSDIALOG oDlgDate CENTERED

		If (lOk)

			__lSx8	:= .F.

			cCodSus := GetSxeNum("ACH","ACH_CODIGO")

			If (__lSx8)

				If (RecLock('ACH',.T.))

					ConfirmSx8()

					ACH->ACH_CODIGO		:= cCodSus
					ACH->ACH_RAZAO		:= cCodigo
					ACH->ACH_MIDIA		:= "000014"
					ACH->ACH_TEL		:= IIF(!Empty(cCodigo1) , cCodigo1 , aDados[9]  )//Se o telefone nao for preenchido, grava o telefone de relacionamento
					ACH->ACH_XOBSIN		:= cCodigo5
					ACH->ACH_XDTINC		:= dDataBase
					ACH->ACH_XUSER		:= UsrRetName(RetCodUsr())
					ACH->ACH_XFILIA		:= cCodigo4
					ACH->ACH_XTELS1		:= cCodigo2
					ACH->ACH_XTELS2		:= cCodigo3
					ACH->ACH_XTELS3		:= ""
					ACH->ACH_LOJA		:= aDados[3]
					ACH->ACH_XCUPOM		:= aDados[21]
					ACH->ACH_TIPO		:= "1"
					ACH->ACH_CIDADE		:= "MUNICIPIO"
					ACH->ACH_MSFIL		:= cCodigo4
					ACH->ACH_DTCAD		:= dDataBase
					ACH->ACH_HRCAD		:= Time()
					ACH->ACH_XMIMKT		:= "Relaciona"
					ACH->ACH_XORIGE		:= "Relacionamento"

				Else

					RollBackSx8()

				EndIf

				ACH->(MsUnlock())

			EndIf

		EndIf

	EndIf

	lSuspect	:= .F.

Return

/*
=====================================================================================
Programa.:              KHX00605
Autor....:              Luis Artuso
Data.....:              12/09/2019
Descricao / Objetivo:   Executa ação de encerramento do chamado
Obs......:
=====================================================================================
*/
Static Function KHX00605(aArray , lReserva , lLibera , nLinha)

	Local cChaveZL5		:= aArray[2] + aArray[3] // Codigo e loja do cliente
	Local bRefresh		:= {|| oCalend:carregaProduto(oCalend:dDate) }
	Local nLoop			:= 0
	Local lContinua		:= .T.
	Local lGrava		:= .F.
	Local cMsg			:= ""
	Local lPercDesc		:= .F.
	Local oGrava		:= MNGDATA():NEW()
	Local cTipo			:= ""

	Do Case

		Case (lReserva) //Se disparada a acao de iniciar o atendimento

			If !(lIniAtend) //Se o atendimento nao foi iniciado

				aZL5		:= Array(Len(OBrwItens:aArray[OBrwItens:nAt])) //Armazena no array aZL5 o item posicionado em tela.

				For nLoop	:= 1 TO Len(aZL5)

					aZL5[nLoop]	:= ""

				Next nLoop

			EndIf

			If (ZL5->(dbSeek(xFilial("ZL5") + cChaveZL5)))

				If (!(Empty(ZL5->ZL5_CODOPE)) .AND. !(ZL5->ZL5_CODOPE == RetCodUsr()) )
					//Se estiver tentando reservar um atendimento e o codigo do operador NAO for o codigo anteriormente gravado

					Aviso("Cliente reservado" , "O cliente está em atendimento com o operador : " + UsrRetName(ZL5->ZL5_CODOPE) , {} ,  1)

				Else

					If (!lIniAtend)

						lIniAtend	:= .T.

						lFimAtend	:= .F.

						KHX00602(aArray , lReserva , lLibera )

					EndIf

					OBrwItens:aArray[nLinha,1]	:= "AZUL" //Altera a legenda em tempo de execução

					Aviso("Ok" , "Atendimento inicializado pelo Operador : " + UsrRetName(RetCodUsr()) , {} ,  1)

				EndIf

			Else

				If (!lIniAtend)

					lIniAtend	:= .T.

					lFimAtend	:= .F.

					OBrwItens:aArray[nLinha,1]	:= "AZUL"

					Aviso("Ok" , "Atendimento inicializado pelo Operador : " + UsrRetName(RetCodUsr()) , {} ,  1)

				EndIf

				KHX00602(aArray , lReserva , lLibera )

			EndIf

		Case ( lLibera )

			If !(lIniAtend)

				Aviso("Erro" , "Não é possível encerrar atendimento sem que tenha sido iniciado")

			Else

				If !(Empty(OBrwItens:aArray[nLinha,24])) //Se preencheu o campo de pendencia de contato (enviar brinde, etc...)

					Do Case

						Case (Val(aZL5[24]) == 3) //Se enviar um cupom de desconto, exibe a tela do cadastro do Suspect

							If (Empty(aZL5[22])) //Verifica se informou o percentual de desconto

								cMsg	:= "Para Gravação do Suspect, é obrigatório informar o percentual de desconto"

							Else

								//Grava o Suspect

								//If (MsgYesNo("Cadastrar Suspect","Deseja cadastrar o Suspect ?"))

								lSuspect	:= .T. //Indica que o atendimento foi encerrado. Permite que o Suspect seja gravado APENAS apos o encerramento do atendimento.

								cTipo		:= '1' // Suspect: Encaminha para a loja

								lGrava		:= .T.

								KHX00604(oCalend:aItens[OBrwItens:nAt]) //Grava o Suspect

								OBrwItens:aArray[nLinha,1]	:= ""

								For nLoop	:= 1 TO Len(aZL5)

									aZL5[nLoop]	:= ""

								Next nLoop

							EndIf

						Case (Val(aZL5[24]) == 4) // Cupom de Brinde, obrigar o preenchimento do tipo do brinde

							If (Empty(aZL5[23])) //Verifica se informou o tipo do brinde

								cMsg	:= "Para envio do brinde, é obrigatório informar o tipo do brinde"

							Else

								lGrava	:= .T.

								cTipo	:= "2" //Cupom de brinde

							EndIf

						Case (Val(aZL5[24]) == 5) // Cupom informativo, obriga preencher o percentual e não gera Suspect

							If (Empty(aZL5[22]))

								cMsg	:= "Para envio do cupom Informativo, é obrigatório preencher o percentual de desconto"

							Else

								lGrava	:= .T.

								cTipo	:= "3" //Informativo

							EndIf

						OtherWise

							lGrava	:= .T.

					EndCase

				Else

					lGrava	:= .T.

				EndIf

				If (lGrava)

					OBrwItens:aArray[nLinha,1]	:= ""

					Aviso("Ok" , "Atendimento finalizado" )

					OBrwItens:aArray[nLinha,1]	:= ""

					lFimAtend	:= .T.

					KHX00602(aArray , lReserva , lLibera , cTipo)

					For nLoop	:= 1 TO Len(aZL5)

						aZL5[nLoop]	:= ""

					Next nLoop

					Eval(bRefresh) //Atualiza a tela apos gravacao do registro nas tabelas (ZL5 e ZL6)

					lIniAtend	:= .F.

				Else

					Aviso("Atenção" , cMsg)

				EndIf

			EndIf

	EndCase

Return

/*
=====================================================================================
Programa.:              KHX00606
Autor....:              Luis Artuso
Data.....:              11/09/2019
Descricao / Objetivo:   Permite filtrar os clientes por situação
Doc. Origem:
Obs......:
=====================================================================================
*/
Static Function KHX00606(cFiltro)

	Local aBrowse 	:= {}
	Local aHeader 	:= {}
	Local aDados 	:= {}
	Local nX		:= 0
	Local nY		:= 0
	Local nPosArray	:= 0
	Local oOK		:= LoadBitmap(GetResources(),"LBOK")
	Local oNO		:= LoadBitmap(GetResources(),"LBNO")
	Local oWBrowse1
	Local nX		:= 0
	Local oButton1

	aHeader	:= array(1,2)
	aDados	:= {}
	cFiltro	:= ""

	DEFINE MSDIALOG oDlg TITLE "Filtro de situações." FROM 000, 000  TO 230, 300 COLORS 0, 16777215 PIXEL

		aHeader	:= {"" , "PENDÊNCIA" }

		AADD(aDados , {.F. , 'LIVRE'})
		AADD(aDados , {.F. , 'EM ATENDIMENTO'})
		AADD(aDados , {.F. , 'SEM RESPOSTA'})
		AADD(aDados , {.F. , 'CHAMADO EM ABERTO'})
		AADD(aDados , {.F. , 'NÃO LIGAR'})

		aBrowse	:= aClone(aDados)

		@ 007, 007 LISTBOX oWBrowse1 Fields HEADER aHeader[++nPosArray],;
			aHeader[++nPosArray];
			SIZE 140 , 80 OF oDlg PIXEL ColSizes 20,35,25

		oWBrowse1:SetArray(aBrowse)

		oWBrowse1:bLine := {|| {;
			If(aBrowse[oWBrowse1:nAt,01],oOK,oNO),;
				aBrowse[oWBrowse1:nAt,02];
			}}
		// DoubleClick event
		oWBrowse1:bLDblClick := {|| aBrowse[oWBrowse1:nAt,1] := !aBrowse[oWBrowse1:nAt,1],;
		oWBrowse1:DrawSelect()}

		oWBrowse1:Refresh()

		oButton1 := TButton():New( 95 , 90 , "OK" , oDlg,{|| oDlg:End()},50,10,,,.F.,.T.,.F.,,.F.,{|| oTButton1:lActive := .T.},,.F. )

	ACTIVATE MSDIALOG oDlg CENTERED

	For nX := 1 TO Len(aBrowse)

		If (aBrowse[nX,1])

			Do Case

				Case (nX == 1)

					cFiltro	+= 'AMARELO'

				Case (nX == 2)

					cFiltro	+= 'AZUL'

				Case (nX == 3)

					cFiltro	+= 'BRANCO'

				Case (nX == 4)

					cFiltro	+= 'VERMELHO'

				Case (nX == 5)

					cFiltro	+= 'LARANJA'

				Case (nX == 6)

					cFiltro	+= 'PRETO'

				Case (nX == 7)

					cFiltro	+= 'VERDE'

			EndCase

			cFiltro	+= "|"

		EndIf

	Next nX

	If !(Empty(cFiltro))

		oCalend:carregaProduto(,,.T.)

	EndIf

Return


/*
=====================================================================================
Programa.:              KHX00608
Autor....:              Luis Artuso
Data.....:              11/09/2019
Descricao / Objetivo:   Verifica se o campo filial (cadastro do suspect) esta em branco.
Doc. Origem:
Obs......:
=====================================================================================
*/
Static Function KHX00608(cCodFil)

	Local lRet	:= .F.

	Do Case

		Case (Empty(cCodFil))

			Aviso("Atenção" , "O preenchimento do campo Filial('loja') é obrigatório")

		Case (cCodFil = "0101")

			Aviso("Atenção" , "Filial Inválida - Selecione alguma das lojas para envio do cupom")

		OtherWise

			lRet	:= .T.

	EndCase

Return lRet