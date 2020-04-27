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


//--------------------------------------------------------------
/*/{Protheus.doc} KHX005
Description //tele cobrança komforthouse
@param xParam Parameter Description
@return xRet Return Description
@author  - WELLINGTON RAUL
@since 11/03/2019 /*/
//--------------------------------------------------------------

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

user function KHX005()

	Local dDateGet := Date()
	Local aSize := MsAdvSize()
	Local cTitle := "Relatório de Cobrança"
	Local bRefresh:= {|| oCalend:carregaProduto(oCalend:dDate) }
	Local nMilissegundos := 10000 // Disparo será de 20 em 20 segundos
	Local aButtons := {}
	local aInfocab :={}
	Local cUserMv	:= SuperGetMV("KH_VISUCOB",.F.,"001079|000455|000950|000374")
	Local aResumo	:= {}
	Private cMV_PAR07 := SPACE(20)
	Private lEst := .F.
	Private oTimer
	//Private aItems1:= {'','Item1','Item2','Item3'}
	SET DATE BRITISH
	__SetCentury("ON")

	if __cUserid $ cUserMv
	lEst := .T.
	endif
	
	DEFINE FONT oFont11 NAME "Arial" SIZE 0, -11 BOLD

	DEFINE MSDIALOG oDlg FROM 0,0 TO aSize[6],aSize[5] TITLE cTitle Of oMainWnd PIXEL
	oTimer := TTimer():New(nMilissegundos, {|| bRefresh }, oDlg )
	oMsgBar  := TMsgBar():New(oDlg,,,,,, RGB(116,116,116),,,.F.)
	oMsgItem := TMsgItem():New( oMsgBar, "Selecionada: " + DtoC( Date() ), 120,,,,.T., {|| oCalend:fDate(dDateGet) } )
	@  035,  aSize[3]-190 Say  oSay Prompt 'Cliente:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oDlg Pixel
	@  035,  aSize[3]-160 MSGet oMV_PAR07	Var cMV_PAR07	FONT oFont11 COLOR CLR_BLUE Pixel SIZE  050, 05 When .T. Of oDlg 
	oTButton1 := TButton():New( 035, aSize[3]-110, "Pesquisar",oDlg,{|| processa( {|| oCalend:carregaProduto(oCalend:dDate,,cMV_PAR07), "Aguarde...", "Atualizando Dados...", .f. })}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	oTButton2 := TButton():New( 035, aSize[3]-060, "Propostas",oDlg,{|| U_KHFIN003()}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	oTButton3 := TButton():New( 035, 20, "Distribuição",oDlg,{||aResumo	:= fTipoSit(oCalend:dDate)}, 50,10,,,.F.,.T.,.F.,,.F.,{|| oTButton3:lActive := lEst},,.F. )
	oTButton4 := TButton():New( 035, 80, "Relatório",oDlg,{||U_KMCOBR01()}, 50,10,,,.F.,.T.,.F.,,.F.,{|| oTButton4:lActive := lEst},,.F. )
	oTButton5 := TButton():New( 035, 140,"Limpa Distri",oDlg,{||fLpred(oCalend:aItens)}, 50,10,,,.F.,.T.,.F.,,.F.,{|| oTButton5:lActive := lEst},,.F. )
	oTButton6 := TButton():New( 035, 200,"Resumo Distribuição",oDlg,{||fResDistr(aResumo)}, 50,10,,,.F.,.T.,.F.,,.F.,{|| oTButton5:lActive := lEst},,.F. )
	oCalend := CALENDBAR04():New( oDlg, 0, 0, 200, 30, {|dDate| oMsgItem:SetText( "Selecionada: " + DtoC( dDate ) ) }, Date() )
	oCalend:Align := CONTROL_ALIGN_TOP

	OBrwItens := TwBrowse():New(050, 000, aSize[3], aSize[4]-75,, {;
																	'-',;
																	'Pedido',;
																	'Codigo do Cliente',;
																	'Cliente',;
																	'CPF/CNPJ',;
																	'Data_Nasc',;
																	'Titulo',;
																	'Valor',;
																	'Parcela',;
																	'Prefixo',;
																	'Tipo',;
																	'Vencidos',;
																	'Vencimento',;
																	'Dias Vencidos',;
																	'Retorno',;
																	'Acordo',;
																	'Operador',;
																	'Loja',;
																	'Distribuição',;
																	'Filial';
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
Class CALENDBAR04 From TPanel

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
Method New( oWnd, nRow, nCol, nWidth, nHeight, bClickDate, dDate ) Class CALENDBAR04

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
Method Activate() Class CALENDBAR04

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

		oCALENDBTN04 := CALENDBTN04():New( ::oBtnPanel, cDayW +chr(10)+ cValToChar(nDay), dDate)
		oCALENDBTN04:Align  := CONTROL_ALIGN_LEFT
		oCALENDBTN04:dDate := dDate
		oCALENDBTN04:setSelect(oCALENDBTN04, .F.)
		Aadd( ::aButtons, oCALENDBTN04 )

		// Ajusto o botao com a data selecionada
		if oCALENDBTN04:dDate == ::dDate
			::oBtnSelect = oCALENDBTN04
			::oBtnSelect:setSelect(::oBtnSelect, .T.)
		endif

		dDate++
	end

	::setUpdatesEnable(.T.) // Reabilita pintura

Return

//-------------------------------------------------------------------
// Navegacao entre as datas através dos botões laterais
//-------------------------------------------------------------------
Method ChangeDate( nSide, nQtdDias ) Class CALENDBAR04

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
		oBtn := CALENDBTN04():New( ::oBtnPanel, cDayW +chr(10)+ cValToChar(nDay), dDate)
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
		oBtn := CALENDBTN04():New( ::oBtnPanel, cDayW+chr(10)+cValToChar(nDay), dDate)
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
Method SetDate( dDate ) Class CALENDBAR04

	if ::dDate != dDate
		eval(::bClickDate, dDate)
		::dDate := dDate
		::Activate()
	endif

Return

//-------------------------------------------------------------------
// Botoes do CALENDBAR04
//-------------------------------------------------------------------
Class CALENDBTN04 From TButton
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
Method New( oWnd, cStr, dDate) Class CALENDBTN04

	:Create( oWnd,0,0,cStr,,BTN_WIDTH,20,,,,.T.,,DtoC(dDate))

	::lFocused 		:= .F.
	::oFather 		:= ::oParent:oParent
	::lCanGotFocus 	:= .F. // Inibe foco
	::blClicked 	:= {|| ::Clicked() }

Return

//-------------------------------------------------------------------
// Evento de Clique no botão
//-------------------------------------------------------------------
Method Clicked() Class CALENDBTN04

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
Method SetSelect(oCalButton, lSelect) Class CALENDBTN04

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
Method fDate() Class CALENDBAR04

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
Method carregaProduto(_dData,_array,cCpfCnpj) Class CALENDBAR04

	Local cAlias := ""
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
	Local dRetotno
	Local cCpfFor
	Local cCpfFin
	Local lCod := .T.
	Local lLik := .T.
	Local nCpf := 0
	Private cUser := LogUserName()
	Private cUserEst := SUPERGETMV("KH_VISUCOB", .T., "000950|000374")
	
	If !Empty(AllTrim(cCpfCnpj))
		nCpf := Val(cCpfCnpj)
		If nCpf > 0
			if len(alltrim(cCpfCnpj)) > 6
				cCpfFor := StrTran(AllTrim(cCpfCnpj),"-","")
				cCpfFin	:= StrTran(AllTrim(cCpfFor),".","")
			Else
				lCod := .F.
				cCpfFin := cCpfCnpj
			EndIf
		Else
		lLik := .F.
		cCpfFin := cCpfCnpj
		EndIf
	EndIf
	
	

	cQuery := " SELECT  E1.E1_BAIXA AS BAIXA,E1.E1_PEDIDO AS PEDIDO,E1.E1_CLIENTE AS CLIENTE,E1.E1_NOMCLI AS NOMCLI,A1.A1_CGC AS CPFCNPJ,"+ ENTER
	cQuery += " SUBSTRING(A1.A1_DTNASC ,7,2)+'/'+SUBSTRING(A1.A1_DTNASC ,5,2)+'/'+SUBSTRING(A1.A1_DTNASC ,1,4) AS DTNASC,E1.E1_NUM AS NUM," + ENTER
	cQuery += " E1.E1_VALOR AS VALOR,E1.E1_PARCELA AS PARCELA,E1.E1_PREFIXO AS PREFIXO,E1.E1_TIPO AS TIPO, "+ ENTER
	cQuery += " (SELECT COUNT(E1_NUM) E1_CLIENTE FROM SE1010 WHERE E1_VENCTO < GETDATE() AND E1_CLIENTE = E1.E1_CLIENTE AND E1_BAIXA = '' AND D_E_L_E_T_ = '' AND E1_TIPO IN ('BOL','CHK')) AS VENCIDOS  , "+ ENTER
	cQuery += " SUBSTRING(E1.E1_VENCTO ,7,2)+'/'+SUBSTRING(E1.E1_VENCTO ,5,2)+'/'+SUBSTRING(E1.E1_VENCTO ,1,4) AS VENCTO, "+ ENTER
	cQuery += " DATEDIFF ( DD , E1.E1_VENCTO , GETDATE()  )as DIAS_VENC ,  "+ ENTER
	cQuery += " SUBSTRING(E1.E1_XDTNEGO ,7,2)+'/'+SUBSTRING(E1.E1_XDTNEGO ,5,2)+'/'+SUBSTRING(E1.E1_XDTNEGO ,1,4) AS XDTNEGO, " +ENTER
	cQuery += " SUBSTRING(ZK8.ZK8_PRIVEN ,7,2)+'/'+SUBSTRING(ZK8.ZK8_PRIVEN ,5,2)+'/'+SUBSTRING(ZK8.ZK8_PRIVEN ,1,4) AS PRIMVENCT, " +ENTER
	cQuery += "	E1.E1_XOPERAD AS OPERADOR, E1.E1_LOJA AS LOJA, E1.E1_XUSRCOB AS DISTRI ,E1.E1_FILORIG AS FILIAL,E1.E1_XDTCOBR AS DTCOBRANCA,E1.E1_XUSRCOB AS USERCOB,E1.R_E_C_N_O_ AS RECNO" +ENTER
	cQuery += " FROM "+ retSqlName("SE1")+ " E1 (NOLOCK)"+ ENTER
	cQuery += " LEFT JOIN "+ retSqlName("ZK8")+ " ZK8 (NOLOCK) "+ ENTER
	cQuery += " ON E1.E1_CLIENTE = ZK8.ZK8_CODCLI"+ ENTER
	cQuery += " INNER JOIN SA1010(NOLOCK) A1 " +ENTER
	cQuery += " ON A1.A1_COD = E1.E1_CLIENTE " +ENTER 
	If !Empty(AllTrim(cCpfFin))
		if lLik
			IF lCod
				cQuery += " WHERE E1.E1_CPFCNPJ = '"+cCpfFin+"' "+ ENTER
				cQuery += " AND E1.D_E_L_E_T_ = '' "+ ENTER
				cQuery += " AND E1.E1_TIPO IN ('BOL','CHK')"+ ENTER
				cQuery += " AND E1.E1_BAIXA = '' "+ ENTER
			Else
				cQuery += " WHERE E1.E1_CLIENTE = '"+cCpfFin+"' "+ ENTER
				cQuery += " AND E1.D_E_L_E_T_ = '' "+ ENTER
				cQuery += " AND E1.E1_TIPO IN ('BOL','CHK')"+ ENTER
				cQuery += " AND E1.E1_BAIXA = '' "+ ENTER	
			EndIf
		Else 
			cQuery += " WHERE E1.E1_NOMCLI LIKE '%"+UPPER(cCpfFin)+"%' "+ ENTER
			cQuery += " AND E1.D_E_L_E_T_ = '' "+ ENTER
			cQuery += " AND E1.E1_TIPO IN ('BOL','CHK')"+ ENTER
			cQuery += " AND E1.E1_BAIXA = '' "+ ENTER	
		EndIf
	Else
	cQuery += " WHERE (CASE WHEN E1.E1_XDTNEGO ='' THEN  E1.E1_VENCTO ELSE E1.E1_XDTNEGO END)= '"+dtos(_dData)+"'   "+ ENTER
	cQuery += " AND E1.D_E_L_E_T_ = '' "+ ENTER
	cQuery += " AND E1.E1_TIPO IN ('BOL','CHK')"+ ENTER
	cQuery += " AND E1.E1_BAIXA = '' "+ ENTER
		If !__cUserid $ cUserEst
			cQuery += " AND E1_XUSRCOB ='"+Alltrim(cUser)+"'"+ ENTER
		EndIf
	cQuery += " ORDER BY E1_NUM, E1_PARCELA, E1.E1_XDTNEGO "+ ENTER
	EndIf
	cAlias := getNextAlias()
	PLSQuery(cQuery, cAlias)
	DbSelectArea(cAlias)
	(cAlias)->(DbGoTop())

	aItens := {}

	while (cAlias)->(!eof())

		aAdd(aItens,{ 	(cAlias)->BAIXA,;
		(cAlias)->PEDIDO,;
		(cAlias)->CLIENTE,;
		(cAlias)->NOMCLI,;
		(cAlias)->CPFCNPJ,;
		(cAlias)->DTNASC,;
		(cAlias)->NUM,;
		(cAlias)->VALOR,;
		(cAlias)->PARCELA,;
		(cAlias)->PREFIXO,;
		(cAlias)->TIPO,;
		(cAlias)->VENCIDOS,;
		(cAlias)->VENCTO,;
		(cAlias)->DIAS_VENC,;
		(cAlias)->XDTNEGO,;
		(cAlias)->PRIMVENCT,;
		(cAlias)->OPERADOR,;
		(cAlias)->LOJA,;
		(cAlias)->DISTRI,;
		(cAlias)->FILIAL,;
		(cAlias)->DTCOBRANCA,;
		(cAlias)->USERCOB,;
		(cAlias)->RECNO })

		(cAlias)->(dbSkip())
	end

	(cAlias)->(dbCloseArea())

	if len(aItens) == 0
		AAdd(aItens, {"","","","","",CTOD("//")," ","","","","","","",0,"","","","","","","","",0}) //22
	endif

	OBrwItens:SetArray(aItens)

	::aItens := aItens

	OBrwItens:bLine := {|| {    iiF(aItens[OBrwItens:nAt,01]==' ',oSt2,;
								Iif(aItens[OBrwItens:nAt,16]<>' ',oSt1,;	
								Iif(aItens[OBrwItens:nAt,15]<>' ',oSt5,oSt2	))),;
									aItens[OBrwItens:nAt,02] ,;
									aItens[OBrwItens:nAt,03] ,;
									aItens[OBrwItens:nAt,04] ,;
									aItens[OBrwItens:nAt,05] ,;
									aItens[OBrwItens:nAt,06] ,;
									aItens[OBrwItens:nAt,07],;
									transform(aItens[OBrwItens:nAt,08],"@E 999,999.99") ,;
									aItens[OBrwItens:nAt,09] ,;
									aItens[OBrwItens:nAt,10] ,;
									aItens[OBrwItens:nAt,11] ,;
									aItens[OBrwItens:nAt,12] ,;
									aItens[OBrwItens:nAt,13] ,;
									iIf(aItens[OBrwItens:nAt,14]<= 0,0,aItens[OBrwItens:nAt,14]) ,;
									aItens[OBrwItens:nAt,15] ,;
									aItens[OBrwItens:nAt,16],;
									aItens[OBrwItens:nAt,17],;
									aItens[OBrwItens:nAt,18],;
									aItens[OBrwItens:nAt,19],;
									aItens[OBrwItens:nAt,20];
										}}
	//OBrwItens:Align := CONTROL_ALIGN_ALLCLIENT
	OBrwItens:refresh()



Return


Static Function fExcel(aItens, cTitle)

	Local oExcel := FWMsExcel():New()
    Local cArqTemp := GetTempPath() + "Retorno"+substr(time(), 7, 2)+".XLS"
	Local aFields := {"E1_PEDIDO","E1_CLIENTE","E1_NOMCLI","E1_CPFCNPJ","E1_NUM","E1_VALOR","E1_PARCELA","E1_PREFIXO","E1_TIPO","Vencidos","E1_XDTCOBR","E1_XUSRCOB"}
    Local aCab := {}
    Local nx := 0

    if len(aItens) <= 0 
        Return(msginfo("Não ha dados para impressão...","ATENÇÃO"))
    endif

	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	For nx := 1 to Len(aFields)
		If SX3->(DbSeek(aFields[nx]))
	    	Aadd(aCab, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		ELSE
			Aadd(aCab,{aFields[nx],"","","","","","","C","","","",""})
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
	   										aItens[nx][2],; //01  Pedido
											aItens[nx][3],; //02  Cod Cliente
                                            aItens[nx][4],; //03  Nome Cliente
											aItens[nx][5],; //04  CPF
                                            aItens[nx][7],; //05  Num Titulo
                                            aItens[nx][8],; //06  Valor Titulo
                                            aItens[nx][9],; //07  Parcela
                                            aItens[nx][10],;//08  Prefixo
                                            aItens[nx][11],;//09  Tipo
                                            aItens[nx][12],;//10  Vencidos
                                            DTOC(STOD(aItens[nx][21])),;//11  Data Cobrança
                                            aItens[nx][22]; //12  Usuario Cobrança
                                            })
	next nx
    

	oExcel:Activate()
	oExcel:GetXMLFile(cArqTemp)
	ShellExecute("open", cArqTemp, "", "C:\", 1 )
	
Return



Static Function zLegenda()

	Local aLegenda := {}

	//Monta as legendas (Cor, Legenda)

	aAdd(aLegenda,     {"BR_AZUL","Atendimento Planejado" })         //"Atendimento Planejado" --> Padrão
	aAdd(aLegenda,     {"BR_VERMELHO" 	,"Atendimento Pendente" }) //"Atendimento Pendente" --> Padrão
	aAdd(aLegenda,     {"BR_VERDE"		,"Atendimento Encerrado"}) //"Atendimento Encerrado" --> Padrão
	aAdd(aLegenda,     {"BR_PRETO"		,"Atendimento Cancelado"}) //"Atendimento Cancelado" --> Padrão
	aAdd(aLegenda,     {"BR_AMARELO"   ,"Em Andamento"  })           //"Em Andamento" --> Customizado Komfort
	aAdd(aLegenda,     {"BR_LARANJA"   ,"Visita Tecnica"})	        //"Visita Tec" --> Customizado Komfort
	aAdd(aLegenda,     {"BR_PINK"      ,"Devolucao"})	                //"Devolucao" --> Customizado Komfort
	aAdd(aLegenda,     {"BR_BRANCO"    ,"Retorno"})	                //"Retorno" --> Customizado Komfort
	aAdd(aLegenda,     {"BR_VIOLETA"   ,"Troca Autorizada"})          //"Troca Aut" --> Customizado Komfort
	aAdd(aLegenda,     {"BR_CINZA"		,"Compartilhamento" })	    //"Compartilhamento" --> Padrão
	aAdd(aLegenda,     {"BR_AZUL_CLARO","Email Fabricante"})          // Email Fabricante --> Customizado Komfort

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
Static Function fSetOPeracao(nColuna,_array)

Do Case

Case nColuna == 1 //Baixa

Case nColuna == 2 //Pedido
processa( {|| fInfocobr(_array) }, "Aguarde...", "Localizando Histórico...", .f.)
Case nColuna == 3 //Codigo Cliente

Case nColuna == 4 //Nome Cliente

Case nColuna == 5 //CPF
processa( {|| fInfCliente(_array) }, "Aguarde...", "Localizando cliente...", .f.)
Case nColuna == 6 //Data_Nasc

Case nColuna == 7 //Titulo
processa( {|| fPagto(_array) }, "Aguarde...", "Localizando Titulos...", .f.)

Case nColuna == 8 //Valor

Case nColuna == 9 //Parcela

Case nColuna == 10 //Prefixo

Case nColuna == 11 //Tipo

Case nColuna == 12 //Vencidos

Case nColuna == 13 //Vencimento

Case nColuna == 14 // Dias Vencidos

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

Static Function fInfCliente(_array)


	Private aCpos := {"A1_END","A1_BAIRRO","A1_EST","A1_CEP", "A1_MUN","A1_DDD","A1_TEL","A1_TEL2","A1_XTEL3","A1_CONTATO","A1_EMAIL","A1_COMPLEM","A1_NOME","A1_NREDUZ"}
	Private cCadastro := "Cadastro de Clientes - Alteração de Cadastro"

	dbSelectArea("SA1")
	SA1->(DbGoTop())
	SA1->(dbSetOrder(1)) //A1_FILIAL, A1_COD, A1_LOJA, R_E_C_N_O_, D_E_L_E_T_
	if SA1->(dbSeek(xFilial()+_array[3]+_array[18]))
		AxAltera("SA1",SA1->(Recno()),4,,aCpos)
	endif

//310268

Return



Static Function fPagto(_array)

	Local aSize := MsAdvSize()
    Local oTela as object
    Local oBrwForma as object
    Local oSay as object
    Local oGet as object
    Local lHasButton := .T. //Indica se, verdadeiro (.T.), o uso dos botões padrão, como calendário e calculadora.
    Local nTotal := 0
    Local aFormas := {}
    Local oFont := TFont():New('Courier new',,-18,.T.)
    Local cQuery := ""
    Local aPag := {}
    Local cAliasPag := ""
    Local oButton1
	Local oButton2
	Local oGet1
	Local nVlrParc := space(10)
	Local oGet2 
	Local _dDat := date()
	Local oGet3
	Local nQtdPar := 0
	Local oGet4
	Local nVlrEnt := space(10)
	Local oRadMenu1
	Local nRadMenu1 := 1
	Local oRadMenu2 
	Local nRadMenu2 := 2
	Local nRadMenu4 := 2
	Local nRadMenu3 := 1
	Local oSay1
	Local oSay2
	Local oSay3
	Local oSay4
	Local oSay5
	Local oSay6
	Local oSt1 := LoadBitmap(GetResources(),'BR_AZUL') //"Parcela em dia" --> Customizado
	Local oSt2 := LoadBitmap(GetResources(),'BR_VERMELHO')  //"Parcela Pendente" --> Customizado
	Local oGet5
	Local cObs := ""
	Local oGet6
	Local cNovaObs := " "
	Local nTaxa:= 0
	Local oGet7
	lOCAL oGet10
	Local oRadMenu4
	Local oRadMenu3
	Local oSay8
	Local oSay9
	 Local cZk8Anexo := ""
	Private cPasta := "\comprovantes_cobranca"
    Private cRaiz := GetSrvProfString("RootPath","")+cPasta
    Private oBrwPag


    DEFINE MSDIALOG oTela FROM 0,0 TO 600,1400 TITLE "TITULOS A RECEBER" Of oMainWnd PIXEL
        
    oBrwPag := TwBrowse():New(005, 005, 445, 220,, {;
    												'',;
                                                    'Cliente',;
                                                    'Nome',;
                                                    'Titulo',;
                                                    'Parcela',;
                                                    'Vencimento',;
                                                    'Dias Vencidos',;
                                                    'Valor',;
                                                    'Renegociação';
                                                    },,oTela,,,,,,,,,,,, .F.,, .T.,, .T.,,,)

                
                
                
          cQuery := " SELECT E1_BAIXA, E1_CLIENTE,E1_NOMCLI,E1_NUM,E1_PARCELA , E1_VENCTO,"+ ENTER
          cQuery += " DATEDIFF ( DD , E1_VENCTO , GETDATE()  )as DIAS_VENC,"+ ENTER
          cQuery += " E1_VALOR, E1_XDTNEGO"+ ENTER
          cQuery += " FROM SE1010"+ ENTER
          cQuery += " WHERE E1_BAIXA = '' "+ ENTER
          cQuery += " AND E1_CLIENTE = '"+_array[3]+"' "+ ENTER
          cQuery += " AND E1_TIPO IN ('BOL','CHK')"+ ENTER
          cQuery += " AND D_E_L_E_T_ = ''"+ ENTER
          cQuery += " ORDER BY E1_BAIXA DESC "+ ENTER


          cAliasPag := getNextAlias()
          PLSQuery(cQuery, cAliasPag)
          DbSelectArea(cAliasPag)
          (cAliasPag)->(DbGoTop())

          aPag := {}
          nValVdo  := 0
          nValAber := 0
          nTotVdo := 0
          nTotAber := 0
        while (cAliasPag)->(!eof())        
        	        	
			aAdd(aPag,{ 	(cAliasPag)->E1_BAIXA,;
			(cAliasPag)->E1_CLIENTE,;
			(cAliasPag)->E1_NOMCLI,;
			(cAliasPag)->E1_NUM,;
			(cAliasPag)->E1_PARCELA,;
			(cAliasPag)->E1_VENCTO,;
			(cAliasPag)->DIAS_VENC,;
			(cAliasPag)->E1_VALOR,;
			(cAliasPag)->E1_XDTNEGO})					
						
			If (cAliasPag)->DIAS_VENC > 0
				nValVdo += (cAliasPag)->E1_VALOR
				nTotVdo +=1
			Else
				nValAber += (cAliasPag)->E1_VALOR
				nTotAber +=1			
			EndIf
			(cAliasPag)->(dbSkip())
		end
		//Totais
	
		aAdd(aPag,{ 	1,;
			"Totais",;
			"",;
			"",;
			"Qtd Parcelas",;
			"",;
			0,;
			0,;
			""})
					
		If nValVdo > 0
			aAdd(aPag,{;
			 	1,;
				"Tot Vencido",;
				"",;
				"",;
				nTotVdo,;
				"",;
				0,;
				nValVdo,;
				""})
		EndIf
		If nValAber > 0
			aAdd(aPag,{ 	2,;
				"Tot Aberto",;
				"",;
				"",;
				nTotAber,;
				"",;
				0,;
				nValAber,;
				""})
		EndIf
		If nValAber > 0 .And. nValVdo > 0
			aAdd(aPag,{ 	3,;
				"Tot Geral",;
				"",;
				"",;
				nTotVdo+nTotAber,;
				"",;
				0,;
				nValAber+nValVdo,;
				""})
		EndIf

	(cAliasPag)->(dbCloseArea())
          

    if len(aPag) <= 0
        AAdd(aPag, {"","","","","",CTOD(""),0,"",CTOD("")})
    endif
    
    oBrwPag:SetArray(aPag)
    
    oBrwPag:bLine := {|| ;
                            { Iif(aPag[oBrwPag:nAt][07]<= 0,oSt1,oSt2),;
                              aPag[oBrwPag:nAt,02] ,; 
                              aPag[oBrwPag:nAt,03] ,;
                              aPag[oBrwPag:nAt,04] ,; 
                              aPag[oBrwPag:nAt,05] ,;
                              aPag[oBrwPag:nAt,06] ,;
                              Iif(aPag[oBrwPag:nAt][07]<= 0,0,aPag[oBrwPag:nAt,07]),;
                              aPag[oBrwPag:nAt,08] ,;
                              aPag[oBrwPag:nAt,09] ;
                            }}
    
    oBrwPag:Refresh()
    
    
    
    
    dbSelectArea("SA1")
	SA1->(dbSetOrder(3)) //A1_FILIAL, A1_CGC
	SA1->(dbSeek(xFilial()+_array[5]))
	cObs :=SA1->A1_XOBSCOB
	
	DbSelectArea('ZK8')
	ZK8->(DbSetOrder(1))//Filial + cod cliente 
	ZK8->(DbSeek(xFilial()+_array[3]))
	nQtdPar:= ZK8->ZK8_QTDPAR 
	nVlrParc := ZK8->ZK8_VLRPAR 
	nVlrEnt:= ZK8->ZK8_VLRENT 
	_dDat := ZK8->ZK8_PRIVEN 
	nRadMenu1:= ZK8->ZK8_COMPRO 
	nRadMenu3:=ZK8_WFRET
	If ZK8->ZK8_TAXA == 0
	nTaxa := (nTotVdo * 35)
	Else 
	nTaxa :=ZK8->ZK8_TAXA
	EndIf
  
    @ 232, 303 SAY oSay1 PROMPT "Vlr Parcelas:" SIZE 037, 007 OF oTela COLORS 0, 16777215 PIXEL
    @ 232, 353 MSGET oGet1 VAR nVlrParc Picture "@E 999,999,999.99"  SIZE 071, 010 OF oTela COLORS 0, 16777215 PIXEL
    @ 281, 142 SAY oSay2 PROMPT "1º Vencto:" SIZE 038, 007 OF oTela COLORS 0, 16777215 PIXEL
    @ 278, 198 MSGET oGet2 VAR _dDat SIZE 060, 010 OF oTela COLORS 0, 16777215 PIXEL
    @ 232, 143 SAY oSay3 PROMPT "Qtd Parcelas:" SIZE 037, 007 OF oTela COLORS 0, 16777215 PIXEL
    @ 232, 198 MSGET oGet10 VAR nQtdPar Picture "@E 99 "   SIZE 060, 010 OF oTela COLORS 0, 16777215 PIXEL 
    @ 253, 145 SAY oSay4 PROMPT "Comprovante:" SIZE 038, 007 OF oTela COLORS 0, 16777215 PIXEL
    @ 253, 305 SAY oSay5 PROMPT "Cobrar:" SIZE 025, 007 OF oTela COLORS 0, 16777215 PIXEL
    @ 255, 596 BUTTON oButton1 PROMPT "Salvar" SIZE 060, 017 OF oTela  ACTION (fGrava(cNovaObs,cObs,_array,_dDat,nQtdPar,nVlrParc,nVlrEnt,nRadMenu1,nRadMenu2,nValVdo,nValAber,nRadMenu4,nTaxa),oTela:End()) PIXEL
    @ 255, 500 BUTTON oButton2 PROMPT "Cancelar" SIZE  060, 017 OF oTela ACTION(oTela:End())  PIXEL
    @ 232, 011 SAY oSay6 PROMPT "Vlr Entrada" SIZE 037, 007 OF oTela COLORS 0, 16777215 PIXEL
    @ 232, 060 MSGET oGet4 VAR nVlrEnt Picture "@E 999,999,999.99" SIZE 060, 010 OF oTela COLORS 0, 16777215 PIXEL
    tButton():New(253,198,"&Anexo",oTela,{|| cZk8Anexo:= fAnexo(_array) },60,10,,,,.T.,,,,/*{|| }*/)
    @ 253, 352 RADIO oRadMenu2 VAR nRadMenu2 ITEMS "Vencidos","Todos" SIZE 072, 017 OF oTela COLOR 0, 16777215 PIXEL
    @ 024, 462 GET oGet5 VAR cObs MEMO SIZE 227, 085 WHEN .F. OF oTela COLORS 0, 16777215 PIXEL
    @ 127, 462 GET oGet6 VAR cNovaObs MEMO SIZE 226, 091 OF oTela COLORS 0, 16777215 PIXEL
    @ 280, 305 SAY oSay7 PROMPT "Taxa" SIZE 025, 007 OF oTela COLORS 0, 16777215 PIXEL
    @ 279, 356 MSGET oGet7 VAR nTaxa SIZE 068, 010 OF oTela COLORS 0, 16777215 PIXEL
   // If nRadMenu3 == 2
   // @ 253, 063 RADIO oRadMenu3 VAR nRadMenu3 ITEMS "Sim ","Não" SIZE 048, 018 OF oTela COLOR 0, 16777215 PIXEL
   //  EndIf
    @ 253, 010 SAY oSay8 PROMPT "Reaprovação" SIZE 035, 007 OF oTela COLORS 0, 16777215 PIXEL
    @ 279, 010 SAY oSay9 PROMPT "Altera Vencimento" SIZE 046, 007 OF oTela COLORS 0, 16777215 PIXEL
    @ 273, 064 RADIO oRadMenu4 VAR nRadMenu4 ITEMS "Sim","Não" SIZE 043, 017 OF oTela COLOR 0, 16777215 PIXEL
    @ 007, 535 SAY oSay1 PROMPT "Histórico de Atendimento" SIZE 064, 007 OF oTela COLORS 0, 16777215 PIXEL
    @ 111, 545 SAY oSay2 PROMPT "Nova Informação" SIZE 044, 009 OF oTela COLORS 0, 16777215 PIXEL


    ACTIVATE MSDIALOG oTela CENTERED

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

Static Function fInfocobr(_array)                        
Local oButton1
Local oButton2
Local oGet1
Local cHIs:= "" 
Local oGet2
Local cNovo := ""
Local oGet3
Local dRetor:= Date()
Local dBolet:= Date()
Local oSay1
Local oSay2
Local oSay3
Local nRadMenu4 := 1
Static oDlg

    dbSelectArea("SA1")
	SA1->(dbSetOrder(3)) //A1_FILIAL, A1_CGC
	SA1->(dbSeek(xFilial()+_array[5]))
	cHIs :=SA1->A1_XOBSCOB
	

  DEFINE MSDIALOG oDlg TITLE "Informações do Cliente" FROM 000, 000  TO 500, 500 COLORS 0, 16777215 PIXEL

    @ 027, 013 GET oGet1 VAR cHIs MEMO SIZE 226, 073 WHEN .F. OF oDlg COLORS 0, 16777215 PIXEL
    @ 122, 013 GET oGet2 VAR cNovo MEMO SIZE 221, 077 OF oDlg COLORS 0, 16777215 PIXEL
    @ 013, 089 SAY oSay1 PROMPT "Histórico de Atendimento" SIZE 064, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 107, 097 SAY oSay2 PROMPT "Nova Informação" SIZE 044, 009 OF oDlg COLORS 0, 16777215 PIXEL
    @ 221, 054 MSGET oGet3 VAR dRetor SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
    //@ 203, 054 MSGET oGet3 VAR dBolet SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 202, 054 RADIO oRadMenu4 VAR nRadMenu4 ITEMS "Sim","Não" SIZE 043, 017 OF oDlg COLOR 0, 16777215 PIXEL
    @ 203, 013 SAY oSay1 PROMPT "Boleto Itau" SIZE 035, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 221, 012 SAY oSay3 PROMPT "Retorno" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 212, 136 BUTTON oButton1 PROMPT "Cancelar" SIZE 037, 012 OF oDlg ACTION(oDlg:End())  PIXEL
    @ 212, 191 BUTTON oButton2 PROMPT "Salvar" SIZE 037, 012 OF oDlg ACTION (fGravaObs(cNovo,cHIs,_array,dRetor,nRadMenu4),oDlg:End()) PIXEL

  ACTIVATE MSDIALOG oDlg CENTERED

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

Static Function fGravaObs(cNovaObs,cObs,_array,dRetor,nRadMenu4)

	Local dData := DATE()
	Local cUser := LogUserName()
	local cObsNew := ""
	Local nDifParc := 0
	Local cAnexo := ""
	//cObsNew := cObs
	cObsNew += "Título: "+ALLTRIM(_array[7])+" Parcela: "+ALLTRIM(_array[9])+" Tipo: "+ALLTRIM(_array[11])+" Usuario: "+ALLTRIM(cUser)+" Data: "+ALLTRIM(DTOC(dData))+ENTER+cNovaObs
	
	
	If EMPTY(ALLTRIM(_array[5]))
	MSGINFO( "Cliente sem CPF, favor entrar em contato com a Tecnologia da Informação", "Aviso" )
	Return	
	EndIf	
	If !EMPTY(cNovaObs)
		DbSelectArea("SA1")
		SA1->(dbSetOrder(3)) //A1_FILIAL, A1_CGC
			If  SA1->(dbSeek(xFilial()+_array[5]))
				RecLock("SA1", .F.)
				SA1->A1_XOBSCOB += (cObsNew)+ENTER+ENTER
				MsUnLock() //Confirma e finaliza a operação
			EndIf
				DbSelectArea('SE1')
				SE1->(DbSetOrder(1))//E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, R_E_C_N_O_, D_E_L_E_T_
				If  SE1->(DbSeek(xFilial()+_array[10]+_array[7]+_array[9]+_array[11]))
					RecLock("SE1", .F.)
					SE1->E1_XOPERAD := cUser
					SE1->E1_XDTNEGO := dRetor
					SE1->E1_XUSRCOB := cUser	
					SE1->E1_XDTCOBR := dData
					If nRadMenu4 == 1
					SE1->E1_XUSEBOL := cUser
					SE1->E1_XQTDBOL += 1					
					EndIf
					MsUnLock() //Confirma e finaliza a operação
				EndIf
		Else
		MSGINFO( "Nenhuma Informação Inserida", "Aviso" )
		
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
Static Function fGrava(cNovaObs,cObs,_array,_dDat,nQtdPar,nVlrParc,nVlrEnt,nRadMenu1,nRadMenu2,nValVdo,nValAber,nRadMenu4,nTaxa)
	Local dData := DATE()
	Local cUser := LogUserName()
	local cObsNew := ""
	Local nDifParc := 0
	Local cAnexo := ""
	//cObsNew := cObs
	cObsNew += "Título: "+ALLTRIM(_array[7])+" Parcela: "+ALLTRIM(_array[9])+" Tipo: "+ALLTRIM(_array[11])+" Usuáio: "+ALLTRIM(cUser)+" Data: "+ALLTRIM(dtos(dData))+ENTER+cNovaObs
	
	 nDifParc := nVlrEnt +(nQtdPar*nVlrParc)
		
	If !EMPTY(cNovaObs)
		DbSelectArea("SA1")
		SA1->(dbSetOrder(3)) //A1_FILIAL, A1_CGC
			If  SA1->(dbSeek(xFilial()+_array[5]))
				RecLock("SA1", .F.)
				SA1->A1_XOBSCOB += (cObsNew)+ENTER+ENTER
				MsUnLock() //Confirma e finaliza a operação
			EndIf
				DbSelectArea('SE1')
				SE1->(DbSetOrder(1))//E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, R_E_C_N_O_, D_E_L_E_T_
				If  SE1->(DbSeek(xFilial()+_array[10]+_array[7]+_array[9]+_array[11]))
					RecLock("SE1", .F.)
					SE1->E1_XOPERAD := cUser
					SE1->E1_XDTNEGO := _dDat
					SE1->E1_XUSRCOB := cUser	
					SE1->E1_XDTCOBR := dData					
					MsUnLock() //Confirma e finaliza a operação
				EndIf
				
						DbSelectArea('ZK8')
						ZK8->(DbSetOrder(1))//Filial + cod cliente 
						If ZK8->(DbSeek(xFilial()+_array[3]))
							RecLock("ZK8",.F.)
						Else
							RecLock("ZK8",.T.)
						EndIf
							ZK8->ZK8_FILIAL:= xFilial()
							ZK8->ZK8_CODCLI := _array[3]
							ZK8->ZK8_NOMCLI := _array[4]
							ZK8->ZK8_CPFCNP := _array[5]
							ZK8->ZK8_QTDPAR := nQtdPar
							ZK8->ZK8_VLRPAR := nVlrParc
							ZK8->ZK8_VLRENT := nVlrEnt
							ZK8->ZK8_PRIVEN := _dDat
							ZK8->ZK8_COMPRO := cValToChar(nRadMenu1)
							ZK8->ZK8_XUSER  := cUser
							ZK8->ZK8_ALTVEN :=  cValToChar(nRadMenu4)
							ZK8->ZK8_TAXA := nTaxa
							ZK8->ZK8_XFILIA:= _array[20]
							ZK8->ZK8_DTCOBR := dData
								If nRadMenu2 == 1
									ZK8->ZK8_COBRAR:=  cValToChar(nRadMenu2)
									ZK8->ZK8_VLRDEV := nValVdo
								Else 
									ZK8->ZK8_COBRAR:= cValToChar(nRadMenu2)
									ZK8->ZK8_VLRDEV := nValAber+nValVdo
								EndIf
									If     nQtdPar > 0 .and. nRadMenu4 == 2
									ZK8->ZK8_WFRET := "1"
									else
									ZK8->ZK8_WFRET := "2"
									EndIf
									
									
							MsUnLock()
						
						/*
							ZK8_XFILIA:= Filial 
						
							ZK8_WFRET = 1 VAI DIRETO PARA O KHALED, VALOR NEGOCIADO MENOR QUE O VALOR DEVIDO 
							ZK8_WFRET = 2 VAI PARA O FINANCERIO, O VALOR NEGOCIADO É MAIOR OU IGUAL AO DEVIDO 
							ZK8_WFRET = 3 REPROVADO PELO APROVADOR DEVE RETORNAR PARA A COBRANCA 
							IF nDifParc < IIf (nRadMenu2 == 1,nValVdo,(nValAber+nValVdo))
										ZK8->ZK8_WFRET := "1"
									ElseIf nDifParc >= IIf (nRadMenu2 == 1,nValVdo,(nValAber+nValVdo))
										ZK8->ZK8_WFRET := "2"
									EndIf		
						
						*/
						
						
	Else
		MSGINFO( "Nenhuma Informação Inserida", "Aviso" )
		
	EndIf
	
Return


Static Function fAnexo(_array)

    Local cCaminho := space(150)
    Local oDlg
    Local nOpc := 0
    Local aMark := {}
    Local lCopy := .F.
    Local aGrava := {}
    Local cNovoCaminho := ""

   /* for nA := 1 to len(oBrwPag:AARRAY)
        if oBrwPag:AARRAY[nA][2]:CNAME == "LBOK"
            aAdd(aMark, "")
        endif
    next nA

    if len(aMark) > 1
        msgAlert("Não é possivel incluir mais de um CTR por linha.","Atenção")
        Return
    endif
    */
    DEFINE MSDIALOG oDlg TITLE "Comprovante de deposito Bancario" From 0,0 To 10,50 

    //--Caminho para importar o Arquivo CSV
    oSayArq := tSay():New(05,07,{|| "Informe o local onde se encontra o arquivo para importação:"},oDlg,,,,,,.T.,,,200,80)
    oGetArq := TGet():New(15,05,{|u| If(PCount()>0,cCaminho:=u,cCaminho)},oDlg,150,10,'@!',,,,,,,.T.,,,,,,,,,,'cCaminho')
    oBtnArq := tButton():New(15,165,"Abrir",oDlg,{|| cCaminho := AlocDlgArq(cCaminho)},30,12,,,,.T.) //&Abrir...

    oBtnImp := tButton():New(060,060,"Importar",oDlg,{|| nOpc:=1,oDlg:End()},40,12,,,,.T.) //Importar
    oBtnCan := tButton():New(060,110,"Cancelar",oDlg,{|| nOpc:=0,oDlg:End()},40,12,,,,.T.) //Cancelar

    ACTIVATE MSDIALOG oDlg CENTERED

    if nOpc == 1

        
        
            cCaminho := cNewString := alltrim(cCaminho)
            cNewString := StrTran(cCaminho,' ','_')
            
            if frename( cCaminho , cNewString ) == 0
                cCaminho := cNewString
            else
                MsgStop('Falha na operação 1 : FError '+str(ferror(),4))
                Return
            endif

            if CpyT2S(cCaminho, cPasta) // ALTERAR O NOME DO ARQUIVO PARA O NUMERO DO RECNO.
                
                cDe := alltrim(cPasta + substr(cCaminho,rat("\",cCaminho),len(cCaminho)))
                cPara := alltrim(cPasta +"\"+ cvaltochar(_array[3]) + substring(cCaminho,rat(".",cCaminho),len(cCaminho)))

                //Verifico se ja existe o arquivo na pasta, e removo
                if File( cPasta +"\"+ cValToChar(_array[3]) + substring(cCaminho,rat(".",cCaminho),len(cCaminho)) )
                    if fErase(cPasta +"\"+ cValToChar(_array[3]) + substring(cCaminho,rat(".",cCaminho),len(cCaminho))) == -1
                        MsgStop('Não foi possivel excluir o registro existente : FError '+str(ferror(),4))
                        Return
                    endif
                endif

                //Renomeio o arquivo com o nome do recno do registro
                nStatus1 := frename( cDe , cPara )
                
                if nStatus1 == -1
                    MsgStop('Falha na operação 2 : FError '+str(ferror(),4))
                    Return
                endif

                msgalert("Arquivo importado com sucesso!!")

               
                aAdd(aGrava,{;
                            _array[3],; //cod cliente
                            alltrim(cRaiz + substr(cPara,rat("\",cPara),len(cPara)))}) //Caminho do arquivo
                         
                          cNovoCaminho  := aGrava[1][2]
                          /*
			                DbSelectArea('SE1')
							SE1->(DbSetOrder(1))//E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, R_E_C_N_O_, D_E_L_E_T_            
							If SE1->(DbSeek(xFilial()+_array[9]+_array[6]+_array[8]+_array[10]))
			                recLock("SE1",.F.)
			                    SE1->E1_XANECOB := cNovoCaminho //gravação do caminho
			                SE1->(msUnlock())
			                EndIf
			                //oBrowse:refresh()
			               
			                */
			            DbSelectArea('ZK8')
						ZK8->(DbSetOrder(1))//Filial + cod cliente 
						If ZK8->(DbSeek(xFilial()+_array[3]))
							RecLock("ZK8",.F.)
						Else
							RecLock("ZK8",.T.)
						EndIf
						ZK8->ZK8_FILIAL:= xFilial()
						ZK8->ZK8_CODCLI := _array[3]
						ZK8->ZK8_ANEXO  := cNovoCaminho
                        ZK8->(msUnlock())
            endif
        
    endif

Return 



Static Function AlocDlgArq(cArquivo)

    Local cType := "Arquivos .PDF|*.pdf| Arquivos .jpeg|*.jpeg| Arquivos .jpg|*.jpg| Arquivos .bmp|*.bmp| Arquivos .png|*.png|"
    Local cArquivo := cGetFile(cType, "Arquivos Imagem")

    If !Empty(cArquivo)
        cArquivo += Space(150-Len(cArquivo))
    Else
        cArquivo := Space(150)
    EndIf

Return cArquivo


Static Function fTipoSit(_dData)    

//https://github.com/NaldoDj/BlackTDN/blob/master/templates/sxb/f_opcoes/f3f_Opcoes.prg

Local cTitulo 		:= "Selecione os Usuários"
Local MvPar			:= (Alltrim(ReadVar()))		 // Carrega Nome da Variavel do Get em Questao
Local mvRet			:= Alltrim(ReadVar())			 // Iguala Nome da Variavel ao Nome variavel de Retorno
Local MvParDef	:= ""
Local cArray 		:= ""   
Local _cAliRC		:= GetNextAlias()	      
Local _cAliasT		:= GetNextAlias()	                                                                              
Local _cAliasD	:= GetNextAlias()	                                                   
Local _cAliasU	:= GetNextAlias()	                                                   
Local cUserMv	:= SuperGetMV("KH_DISTCOB",.F.,"001079|000455|000374|000950") //Parametro responsável pelos usuários que não tem permissão de seleção
Local nItem 			:= 1  
Local aTotUsr		:= {}
Local aUsrResumo	:= {}
Local cUsrBkp		:= ""

Private aSit			:= {}

If !(__cUserID $ cUserMv)
	Alert("Usuário sem permissão para distribuir lista, entre em contato com o Responsavel da Cobrança.")
	Return .F.	 
EndIf

cQuery := " SELECT  U7_NREDUZ,U7_XUSRCOB FROM " + RETSQLNAME("SU7")
cQuery += " WHERE U7_XUSRCOB='1' AND D_E_L_E_T_ = ' ' "

If Select(_cAliRC) > 0
	(_cAliRC)->(DbCloseArea())
EndIf                                                                                                                                                                                                                                  

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),_cAliRC,.T.,.T.)

(_cAliRC)->(DbGoTop())
While (_cAliRC)->(!EOF())    
	cArray += Alltrim((_cAliRC)->U7_NREDUZ)
	cArray += ","
	MvParDef +=cValToChar(nItem)
	nItem +=1
	(_cAliRC)->(DbSkip())                                                                  	
EndDo

cArray := SUBSTR(cArray,0,Len(cArray)-1)//Limpa o array para retiar a ultima virgula   
aSit :=STRTOKARR(cArray,",") //Adiciona o array   
 
If f_Opcoes(@MvPar,cTitulo,aSit,MvParDef,12,49,.F.,,nItem,.F.)  // Chama funcao f_Opcoes
	MvRet := mvpar                                                // Devolve Resultado                                                                     
EndIf                                                           

//Adiciona total de usuários para divisão das tarefas
For nZ:=1 To Len(aSit)
	If cValToChar(nZ)$MvRet         
		AAdd(aTotUsr,{aSit[nZ]})
	EndIf
Next nZ                                                                                       

nTotSelUsr := Len(aTotUsr)                     

If (nTotSelUsr > 0)                                                        
                                                                                                                                              
	//Seleciona registros por dia para distribuição da Tele Cobrança
	cQueryD := " SELECT E1.E1_FILIAL, E1.E1_PREFIXO, E1.E1_NUM, E1.E1_PARCELA, E1.E1_TIPO, E1.E1_NOMCLI, E1.E1_XUSRCOB "
	cQueryD += "  FROM " + RETSQLNAME("SE1") + " E1 (NOLOCK) "
	cQueryD += "  LEFT JOIN "  + RETSQLNAME("ZK8") + " (NOLOCK) ZK8"
	cQueryD += "  ON E1.E1_CLIENTE = ZK8.ZK8_CODCLI "
	cQueryD += "  WHERE (CASE WHEN E1.E1_XDTNEGO ='' THEN  E1.E1_VENCTO ELSE E1.E1_XDTNEGO END)= '"+dtos(_dData)+"' "   
	cQueryD += "  AND E1.E1_XUSRCOB ='' "
	//cQueryD += "  AND E1.E1_TIPO IN ('BOL','CHK') "
	cQueryD += "  AND E1.D_E_L_E_T_ = '' " 
	cQueryD += "  AND E1.E1_BAIXA = '' "    
	
	cQueryD := ChangeQuery(cQueryD)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQueryD),_cAliasD,.T.,.T.)     
	          
	
	//Total por dia para distribuição COUNT                                                                                
	cQueryT := " SELECT COUNT(E1_CLIENTE) AS TOTALSE1 "
	cQueryT += "  FROM " + RETSQLNAME("SE1") + " E1 (NOLOCK) "
	cQueryT += "  LEFT JOIN "  + RETSQLNAME("ZK8") + " (NOLOCK) ZK8"
	cQueryT += "  ON E1.E1_CLIENTE = ZK8.ZK8_CODCLI "
	cQueryT += "  WHERE (CASE WHEN E1.E1_XDTNEGO ='' THEN  E1.E1_VENCTO ELSE E1.E1_XDTNEGO END)= '"+dtos(_dData)+"' "
	cQueryT += "  AND E1.E1_XUSRCOB ='' "
	//cQueryT += "  AND E1.E1_TIPO IN ('BOL','CHK') "
	cQueryT += "  AND E1.D_E_L_E_T_ = '' " 
	cQueryT += "  AND E1.E1_BAIXA = '' "                                          
	
	cQueryT := ChangeQuery(cQueryT)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQueryT),_cAliasT,.T.,.T.)
	
	(_cAliasD)->(DbGoTop())
	If (_cAliasD)->(!EOF())                                                    
		
		//Total SE1 para divisão
		nTotalSE1 := ((_cAliasT)->TOTALSE1 / nTotSelUsr)               
	
		//For Usuários
		For nX := 1 To nTotSelUsr	

			nQtUsr	:= 0
			
			cUsrBkp	:= aTotUsr[nX][1]
	
			//For Títulos
			For nY:= 1 To nTotalSE1   
			
				++nQtUsr		
			    
				cQueryU := "UPDATE " + RETSQLNAME("SE1") 
				cQueryU += " SET E1_XUSRCOB = '" + aTotUsr[nX][1] +"'"                 
				cQueryU += "  WHERE (CASE WHEN E1_XDTNEGO ='' THEN  E1_VENCTO ELSE E1_XDTNEGO END)= '"+dtos(_dData)+"' "
				cQueryU += "  AND E1_FILIAL = '"+(_cAliasD)->E1_FILIAL +"' AND E1_PREFIXO= '"+(_cAliasD)->E1_PREFIXO +"' AND E1_NUM= '"+Alltrim((_cAliasD)->E1_NUM)+"' AND E1_PARCELA= '"+(_cAliasD)->E1_PARCELA +"' AND E1_TIPO= '"+(_cAliasD)->E1_TIPO +"'"
				cQueryU += "  AND E1_XUSRCOB ='' "
				cQueryU += "  AND D_E_L_E_T_ = '' "                                 
				cQueryU += "  AND E1_BAIXA = '' "   
	            
				nStatus := TcSqlExec(cQueryU)

				If (nStatus < 0)
						MSGALERT("Erro ao executar o update: " + TCSQLError())
				EndIf	
				
				(_cAliasD)->(DbSkip())			
			Next nY 
			
			AADD(aUsrResumo	, {cUsrBkp , nQtUsr})
		
		Next nX    		                                                                                                                  
		MSGALERT("Atendimentos distribuídos.","Atençao")		
	Else
		MSGALERT("Não existem atendimento a serem distribuídos.","Atençao")			
	EndIf
Else
		MSGALERT("Operação Cancelada!  Nenhuma negociação Distribuida.","Atenção")  
EndIf
Return aUsrResumo


Static function fLpred(aItens)

	If  msgyesno("Deseja limpar a distribuição?","Atenção")
		dbSelectArea("SE1")
			for nx := 1 to len(aItens)				
			   SE1->(dbgoto(aItens[nx][23])) // Posiciona no Registo da SE1
					If empty(aItens[nx][17]) // não limpa os registro que possuem operador marcados 
					  IF !EOF()
		      		  	RecLock("SE1",.F.)
		      		  		SE1->E1_XUSRCOB :=  " "
		      		  	SE1->(msUnLock())
		      		  EndIF	
		      		EndIf
		    next nx
		SE1->(DBCloseArea())
	Else
	Return
	EndIf

Return 

/*
=====================================================================================
Programa.:              fResDistr (Resumo Distribuicao)
Autor....:              Luis Artuso
Data.....:              07/01/2020
Descricao / Objetivo:
Doc. Origem:            Exibe o resumo dos itens distribuidos por analista
Solicitante:
Uso......:
Obs......:
=====================================================================================
*/
Static Function fResDistr(aArray)

	Local nX	:= 0
	Local cMsg	:= ""
	
	If (Len(aArray) > 0)
		
		For nX := 1 TO Len(aArray)
		
			cMsg	+=	aArray[nX][1] + " : " + cValToChar(aArray[nX][2]) + CHR(13) + CHR(10)
		
		Next nX
		
		Aviso("Resumo de atendimentos" , cMsg)
	
	EndIf

Return