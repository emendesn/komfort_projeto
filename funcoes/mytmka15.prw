#include 'totvs.ch'

// DEFINE UTILIZADO NAS ROTINAS
#DEFINE MERCADORIA 1
#DEFINE ACRESCIMO 2
#DEFINE DESPESA 3
#DEFINE DESCONTO 4
#DEFINE FRETE 5
#DEFINE TOTAL 6

//Quebra de linha
#DEFINE ENTER (CRLF)

//--------------------------------------------------------------
/*/{Protheus.doc} MYTMKA15
Description // Exclusão de pedidos lançados pelo Tele-Vendas
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since ??/11/2018 /*/
//--------------------------------------------------------------
User Function MyTMKA15()

// Manter identico a Legenda do Televendas
Local aCores2    := {	{"(EMPTY(SUA->UA_CODCANC) .AND. VAL(SUA->UA_OPER) == 1 .AND. Empty(SUA->UA_DOC))" 	, "BR_VERDE"   	},;	// Faturamento - VERDE
{"(EMPTY(SUA->UA_CODCANC) .AND. VAL(SUA->UA_OPER) == 1 .AND. !Empty(SUA->UA_DOC))"	, "BR_VERMELHO"	},;	// Faturado - VERMELHO
{"(EMPTY(SUA->UA_CODCANC) .AND. VAL(SUA->UA_OPER) == 2)"							, "BR_AZUL"   	},;	// Orcamento - AZUL
{"(EMPTY(SUA->UA_CODCANC) .AND. VAL(SUA->UA_OPER) == 3)"							, "BR_MARRON" 	},; // Atendimento - MARRON
{"(!EMPTY(SUA->UA_CODCANC))"														, "BR_PRETO"	}} 	// Cancelado - PRETO

Private cCadastro := "Exclusao"
Private aRotina   := fMenuDef() 	//Vetor aRotina utilizado na mBrowse

//Protege rotina para que seja usada apenas no SIGATMK ou SIGACRM.
If !AMIIn(13,73) // 13 = SIGATMK, 73 = SIGACRM
	msgAlert('Essa rotina so pode ser utilizada nos modulos SIGATMK e SIGACRM.','ATENÇÃO')
	Return(.F.)
Endif

mBrowse( 6, 1,22,75,"SUA",,,,,,aCores2)

Return(.T.)

//--------------------------------------------------------------
/*/{Protheus.doc} FMENUDEF
Description // Funcao de definição do aRotina
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since ??/11/2018 /*/
//--------------------------------------------------------------
Static Function fMenuDef()

aRotina :=	{{ "Pesquisa"	,"AxPesqui"  , 0 , 1 , , .F.},;	            //"Pesquisa"
{ "Exclusao"	,"u_fTK150Ex"   , 0 , 5 , , .T.},;	    //"Exclusao"
{ "Legenda"	,"Tk150Legenda"    , 0 , 2 , , .T.}}	//"Legenda"

Return(aRotina)

//--------------------------------------------------------------
/*/{Protheus.doc} FTK150EX
Description //Programa de exclusao de Pedidos Somente atendimentos do tipo ORCAMENTO e FATURAMENTO serao alterados
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since ??/11/2018 /*/
//--------------------------------------------------------------
User Function fTK150Ex(cAlias,nReg,nOpc,xPedido)

Local aSize      	:= MsAdvSize( .T., .F., 400 )					// Size da Dialog
Local aObjects   	:= {}											// Definicoes dos objetos
Local aPosObj    	:= {}											// Posicao dos Objetos Enchoice e Getdados
Local aInfo      	:= {}											// Dimensoes da area a ser dividida entre os objetos
Local aPosGet    	:= {}											// Posicoes dos Gets

Local oDlg															// Objeto para tela
Local oGet															// Objeto para GetDados
Local oEnchoice														// Objeto para Enchoice
Local cTipo		 	:= ""											// Tipo do Cliente ou Prospect (Consumidor, etc...)
Local lOrcamento 	:= .F.											// Flag para apontar se e um ORCAMENTO
Local cOpfat     	:= GetMV("MV_OPFAT") 							// Parametro que Gera ou nao a nota fiscal
Local cTmkLoj     	:= GetMV("MV_TMKLOJ")							// Parametro que indica integracao com SIGALOJA
Local lRet			:= .F.											// Retorno da funcao
Local cEstacao	:= ""												// Codigo da estacao

Local aAC        	:= {"Abandona","Confirma"}							// Usado nas Enchoices "Abandona","Confirma"
Local aObj[7]							  							// Array com os objetos utilizados no Folder do rodape
Local aTitlesRodape := {"Totais","Impostos"}							//"Totais","Impostos"
Local aPages        := {"HEADER","HEADER"}							// Carrega os valores da Funcao fiscal e executa o Refresh
Local bListRefresh  := {|| (MaFisToCols(aHeader,aCols,,"TMK271")),Eval(bRefresh),Eval(bGdRefresh)}	// Codigo para atualizar referencias fiscais
Local bRefresh		:= {|| (Tk150Refresh(aObj))}	    			// Efetua o Refresh da NF
Local aGrupos		:= {}											// Retorno de array
Local lApaga		:= .F.											// Flag de controle para delecao
Local lTmk150 		:= FindFunction("U_TMK150EXC")                 	// P.E. na exclusao do pedido de vendas, antes de qualquer validacao.
Local cAliasSUA := ""

Private aTELA[0][0]													// Vetor com informacoes genericas para a enchoice
Private aGETS[0]													// Vetor com informacoes genericas para a enchoice
Private aHeader[0]													// Cabecalho dos itens da getdados
Private aCols														// Itens da getdados
Private nUsado      := 0											// Contador de campos utilizados
Private aValores    := {0,0,0,0,0,0}         						// Array com os valores dos objetos utilizados no Folder do rodape

Private cPedido := SUA->UA_NUMSC5
//Tratamento PARA EXCLUSÃO do Orçamento via Afterlogin
If !Empty(xPedido)
	If cPedido <> xPedido
		cPedido:=xPedido
		DbSelectArea("SUA")
		DbSetOrder(1)
		Dbseek(xfilial("SUA")+xPedido)
	Endif
Endif

//Verifica se e apenas um ATENDIMENTO
If VAL(SUA->UA_OPER) == 3
	Help(" ",1,"TMKCANTLV")
	Return(lRet)
Endif

//Verifica se o atendimento NAO ESTA CANCELADO
If ALLTRIM(SUA->UA_CANC) == "S"
	Help(" ",1,"TMKCANTLV")
	Return(lRet)
Endif

//Verifica se a emissao da NF esta dentro da validade
If !Empty(SUA->UA_DOC) .AND. ALLTRIM(UA_STATUS) == "NF."
	If Month(SUA->UA_EMISSAO) <> Month(dDataBase) .OR. Year(SUA->UA_EMISSAO) <> Year(dDataBase)
		Help(" ",1,"FORA_MES")
		Return(lRet)
	Endif
Endif

//Se o operador for supervisor pode excluir a nota
If Val(Posicione( "SU7", 4, xFilial("SU7") + __cUserID, "U7_TIPO")) == 2
	lApaga := .T.
EndIf

//Se a senha for do ADMINISTRADOR ou o usuario pertencer
//So grupo de administradores o pedido pode ser apagado
If !lApaga
	If ( __cUserID == "000000" )
		lApaga := .T.
	Else
		// Para verificar se faz parte do grupo de administradores
		PswOrder(1)
		If (PswSeek(__cUserID) )
			aGrupos := Pswret(1)
			If ( Ascan(aGrupos[1][10],"000000") <> 0 )
				lApaga := .T.
			Endif
		Endif
	Endif
Endif

If !lApaga
	Help(" ",1,"OUTROVEND")
	Return(lRet)
Endif

//Verifico se um Orcamento ou um Faturamento
if VAL(SUA->UA_OPER) == 2
	lOrcamento := .T.
	
	//Se existe integracao com SIGALOJA nao exclui o orcamento ?
	If (cTmkLoj == "S")
		Help(" ",1,"ORC_LOJA")
		Return(lRet)
	Endif
	
	//Exclui Orçamento
	if lOrcamento
		Tk150ExcOrc()
	endif
	
elseif VAL(SUA->UA_OPER) == 1
	lOrcamento := .F.
	
	If lTmk150
		
		cAliasSUA := getArea("SUA")
		
		lRet := ExecBlock("TMK150EXC",.F.,.F.)
		
		If !lRet
			RestArea(cAliasSUA)
			Return(lRet)
		Endif
		
		RestArea(cAliasSUA)
	EndIf
endif

//Inicializa os dados do cliente na FUNCAO FISCAL
If (SUA->UA_PROSPEC)
	cTipo := Posicione("SUS",1,xFilial("SUS") + SUA->UA_CLIENTE + SUA->UA_LOJA,"US_TIPO")
Else
	cTipo := Posicione("SA1",1,xFilial("SA1") + SUA->UA_CLIENTE + SUA->UA_LOJA,"A1_TIPO")
Endif

//Inicializa os dados do cliente na FUNCAO FISCAL
MaFisIni(SUA->UA_CLIENTE,;	// 1-Codigo Cliente/Fornecedor
SUA->UA_LOJA,;		// 2-Loja do Cliente/Fornecedor
"C",;				// 3-C:Cliente , F:Fornecedor
"N",;				// 4-Tipo da NF
cTipo,;			// 5-Tipo do Cliente/Fornecedor
Nil,;				// 6-Relacao de Impostos que suportados no arquivo
Nil,;				// 7-Tipo de complemento
Nil,;				// 8-Permite Incluir Impostos no Rodape .T./.F.
Nil,;				// 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
Nil,;				// 10-Nome da rotina que esta utilizando a funcao
Nil,;				// 11-Tipo de documento
Nil,;  			// 12-Especie do documento
IIF(SUA->UA_PROSPEC,SUA->UA_CLIENTE+SUA->UA_LOJA,""))// 13- Codigo e Loja do Prospect


//Carrega o aHeader e o aCols.
//Tk150Config(SUA->UA_NUM, nOpc)

if lOrcamento
	Tk150ExcOrc()
else
	cAliasSUA := getArea("SUA")
	
	If ExistBlock("TMK150DEL")
		ExecBlock("TMK150DEL",.F.,.F.,{SUA->UA_NUM,SUA->UA_CLIENTE,SUA->UA_LOJA,SUA->UA_FILIAL})
	Endif
	
	RestArea(cAliasSUA)
	
	Tk150Grava()
	
endif

MaFisEnd()

Return(lRet)


//--------------------------------------------------------------
/*/{Protheus.doc} TK150GRAVA
Description // Efetua a atualização das tabela SC5, SC6, SL4 e SUA.
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since ??/11/2018 /*/
//--------------------------------------------------------------
Static Function Tk150Grava()

Local lTefOk     := .F.												// Retorno do comando de cancelamento quando o TEF esta sendo utilizado
Local lNaoBaixa  := .F.												// Verifica se a baixa podera ser realizada normalmente
Local aArea  	 := GetArea()										// Salva a area atual
Local cNumNota 	 := SUA->UA_DOC										// Numero da NF
Local cTextoCan	 := ""												// Texto para o cancelamento do atendimento
Local lTMK150VLD := FindFunction("U_TMK150VLD") 					// Ponto de Entrada antes da exclusao com retorno esperado
Private aTefDados:= {}												// Array com os dados da transacao TEF

//Efetua o estorno dos itens do pedido de venda
DbSelectArea("SC6")
SC6->(DbSetorder(1))

If DbSeek(xFilial("SC6")+ SUA->UA_NUMSC5 )
	
	While !Eof() .AND. SC6->C6_MSFIL == SUA->UA_FILIAL .AND. SC6->C6_NUM == SUA->UA_NUMSC5
		//Antes de excluir o SC6 apago o relacionamento do SUB - UB_NUMPV e UB_ITEMPV para manter a integridade referencial ?
		dbSelectArea("SUB")
		SUB->(dbSetOrder(3))	//UB_FILIAL + UB_NUMPV + UB_ITEMPV
		
		If SUB->(dbSeek(xFilial("SUB")+SC6->C6_NUM+SC6->C6_ITEM))
			Reclock("SUB",.F.)
			Replace SUB->UB_NUMPV	WITH ""
			Replace SUB->UB_ITEMPV	WITH ""
			SUB->(MsUnlock())
		EndIf
		
		BEGIN TRANSACTION
		RecLock("SC6",.F.)
		MaAvalSC6("SC6",2,"SC5")
		SC6->(DbDelete())
		SC6->(MsUnlock())
		END TRANSACTION
		
		FindPC(SC6->C6_NUM, SC6->C6_PRODUTO)
		
		SC6->(DbSkip())
	End
	
	//Atualiza os acumulados do SC5
	DbSelectArea("SC5")
	SC5->(dbSetOrder(1))
	
	If DbSeek(xFilial("SC5")+ SUA->UA_NUMSC5 )
		
		BEGIN TRANSACTION
		//Exclui o SC5
		RecLock("SC5",.F.)
		MaAvalSC5("SC5",2)
		SC5->(DbDelete())
		MsUnLock()
		END TRANSACTION
		
	Endif
Endif

//Efetuo a exclusão e estorno dos pedidos de tranferencia 	Wellington Raul Chamado:14710
SC5->(dbSetOrder(12))
	If SC5->(DbSeek(xFilial("SC5")+ SUA->UA_NUMSC5 ))
		If EMPTY(C5_NOTA)	
			BEGIN TRANSACTION
			//Exclui o SC5
			RecLock("SC5",.F.)
			MaAvalSC5("SC5",2)
			SC5->(DbDelete())
			SC5->(MsUnLock())
			END TRANSACTION
			_cNum := SC5->C5_NUM
			_cLoja := SC5->C5_MSFIL

			SC6->(DbSetorder(1))
			If SC6->(DbSeek(xFilial("SC6")+ Alltrim(_cNum)))
				While !SC6->(Eof()) .AND. SC6->C6_MSFIL == _cLoja .AND. SC6->C6_NUM == _cNum
					BEGIN TRANSACTION
					RecLock("SC6",.F.)
					MaAvalSC6("SC6",2,"SC5")
					SC6->(DbDelete())
					SC6->(MsUnlock())
					END TRANSACTION
					FindPC(SC6->C6_NUM, SC6->C6_PRODUTO)
					SC6->(DbSkip())
				End
			Endif
		Elseif  ! SC5->(C5_NOTA $ 'X')
			U_KHDEVCS(SC5->C5_NUM,SC5->C5_NOTA,SC5->C5_MSFIL)
		EndIf
	EndIf
//Fim da exclusão e estorno dos pedidos de tranferencia Wellington Raul Chamado:14710		


//Exclusao do cadastro de parcelas da condicao de pagamento?
DbSelectArea( "SL4" )
If DbSeek( xFilial("SL4")+ SUA->UA_NUM + "SIGATMK ")
	While !Eof() .AND. xFilial("SL4") == L4_FILIAL .AND. L4_NUM == SUA->UA_NUM .AND. L4_ORIGEM == "SIGATMK "
		BEGIN TRANSACTION
		SL4->(Reclock("SL4",.F.,.T.))
		SL4->(DbDelete())
		MsUnlock()
		END TRANSACTION
		SL4->(DbSkip())
	End
Endif

cTextoCan := "Esse atendimento foi cancelado pela rotina de exclusao de Pedido do Televendas (MYTMKA150) em : " + DTOC(date()) + " - "+ Time() + "Usuario: "+ LogUserName()

BEGIN TRANSACTION
Reclock( "SUA" ,.F.)
Replace UA_NUMSC5   WITH ""
Replace UA_DOC 	 	WITH ""
Replace UA_SERIE	WITH ""
Replace UA_EMISNF  	WITH CTOD("  /  /  ")
Replace UA_OPER	 	WITH "2"   				// Orcamento
Replace UA_CANC   	With "S"
Replace UA_STATUS 	With "CAN"
MSMM(,TamSx3("UA_OBSCANC")[1],,cTextoCan,1,,,"SUA","UA_CODCANC")
MsUnlock()
END TRANSACTION

//executa a exclusao do contrato de credito.
Tk150ExCred()

RestArea(aArea)

Return(.T.)

//--------------------------------------------------------------
/*/{Protheus.doc} TK150EXCORC
Description //Programa de exclusao de Orcamentos
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since ??/11/2018 /*/
//--------------------------------------------------------------
Static Function Tk150ExcOrc()

// Ponto de Entrada antes da exclusao com retorno esperado
Local lTMK150VLD := FindFunction("U_TMK150VLD")

If lTMK150VLD
	lRet := U_TMK150VLD(SUA->UA_NUM)
	// Se o retorno for .F. nao prossegue com o cancelamento
	If (ValType(lRet) <> "L")
		Return(.F.)
	ElseIf !lRet
		Return(lRet)
	Endif
Endif

//Exclusao do cadastro de parcelas da condicao de pagamento
DbSelectArea( "SL4" )
If DbSeek( xFilial("SL4")+ SUA->UA_NUM + "SIGATMK ")
	While !Eof() .AND. xFilial("SL4") == L4_FILIAL .AND. L4_NUM == SUA->UA_NUM .AND. L4_ORIGEM == "SIGATMK "
		
		Reclock("SL4",.F.,.T.)
		SL4->(DbDelete())
		MsUnlock()
		SL4->(DbSkip())
	End
Endif

//Exclusao dos itens do atendimento - Televendas
DbSelectArea("SUB")
DbSetorder(1)
If DbSeek(xFilial("SUB")+SUA->UA_NUM )
	While !Eof() .AND. xFilial("SUB") == UB_FILIAL .AND. UB_NUM == SUA->UA_NUM
		Reclock("SUB" ,.F.,.T.)
		SUB->(DbDelete())
		MsUnlock()
		SUB->(DbSkip())
	End
Endif

//Exclusao do cabecalho do atendimento Televendas
Reclock( "SUA" ,.F.,.T.)
SUA->(DbDelete())
MsUnlock()

//Executa a exclusao do contrato de credito.
Tk150ExCred()

Return(.T.)

//Executa o Refresh dos registros
//--------------------------------------------------------------
/*/{Protheus.doc} TK150REFRESH
Description // Executa o Refresh dos registros
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since ??/11/2018 /*/
//--------------------------------------------------------------
Static Function Tk150Refresh(aObj)

Local aArea	:= GetArea()	// Salva a area atual
Local nx    := 0			// Contador

aValores[MERCADORIA]	:= SUA->UA_VALMERC
aValores[ACRESCIMO]		:= SUA->UA_ACRESCI
aValores[DESPESA]	 	:= SUA->UA_DESPESA
aValores[DESCONTO]		:= SUA->UA_DESCONT
aValores[FRETE]			:= SUA->UA_FRETE
aValores[TOTAL]         := aValores[MERCADORIA] + (aValores[FRETE]+aValores[DESPESA]+aValores[ACRESCIMO]) - aValores[DESCONTO]

For nX := 1 TO Len(aObj)
	aObj[nx]:Refresh()
Next nX

RestArea(aArea)

Return(.T.)

//--------------------------------------------------------------
/*/{Protheus.doc} TK150LEGENDA
Description // Legendas do browse de Exclusao de NF
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since ??/11/2018 /*/
//--------------------------------------------------------------
Static Function Tk150Legenda()

// Legenda
BrwLegenda(cCadastro,"STATUS"  ,{	{"BR_VERDE"		,"Atendimento com Pedido    " },;		// "Atendimento com Pedido    "
{"BR_VERMELHO" 	,"Atendimento com NF emitida" },;		// "Atendimento com NF emitida"
{"BR_AZUL" 		,"Atendimento com Orçamento " },;      	// "Atendimento com Or?mento "
{"BR_MARRON"	,"Atendimento               " },;    	// "Atendimento               "
{"BR_PRETO"		,"Atendimento Cancelado" }}) 		// "Atendimento Cancelado"

Return(.T.)

//--------------------------------------------------------------
/*/{Protheus.doc} TK150EXCRED
Description // Realizar a exclusao do contrato de credito
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since ??/11/2018 /*/
//--------------------------------------------------------------
Static Function Tk150ExCred()

Local aARea		:= GetArea()   	// Salva a area atual
Local lRet		:= .T.			// Retorno da funcao
Local lSigaCRD	:= .F.			// Indica se o operador esta configurado para realizar a analise de credito pelo SIGACRD
Local cEstacao	:= ""			// Codigo da estacao
Local aRetCRD	:= {}			// Retorno da funcao de cancelamento do contrato

//Verifica se o operador realiza analise de credito atraves do SIGACRD
cEstacao:= TkPosto(SUA->UA_OPERADO,"U0_ESTACAO")

Dbselectarea("SLG")
DbSetOrder(1)

If DbSeek(xFilial("SLG")+cEstacao)
	If LG_CRDXINT == "1"	//Sim
		lSigaCrd:= .T.
	Endif
Endif

//Exclui a transacao de credito quando existiu
If lSigaCrd
	If SUA->(FieldPos("UA_CONTRA")) > 0
		If !Empty(SUA->UA_CONTRA)
			aRetCrd    := aClone(CrdxVenda( "3", {"",""}, SUA->UA_CONTRA, .F., Nil))
		Endif
	Endif
Endif

RestArea(aArea)

Return(lRet)

//--------------------------------------------------------------
/*/{Protheus.doc} FindPC
Description //Limpa o campo C7_01NUMPV.
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 19/03/2019 /*/
//--------------------------------------------------------------
Static Function FindPC(_cNumPv, _cProduto)

Local aARea := getArea()
Local cQuery := ""
Local cAlias := getNextAlias()
Local nStatus := 0

cQuery := "SELECT *"
cQuery += " FROM "+ retSqlName("SC7")
cQuery += " WHERE C7_01NUMPV = '"+ _cNumPv +"'"
cQuery += " AND C7_PRODUTO = '"+ _cProduto +"'"
cQuery += " AND D_E_L_E_T_ = ''"

PLSQuery(cQuery, cAlias)

if (cAlias)->(!eof())
	
	cUpdate := "UPDATE "+ retSqlName("SC7")+" SET C7_01NUMPV = ''"
	cUpdate += " WHERE C7_FILIAL = '"+ (cAlias)->C7_FILIAL +"'
	cUpdate += " AND C7_ITEM = '"+ (cAlias)->C7_ITEM +"'"
	cUpdate += " AND C7_PRODUTO = '"+ (cAlias)->C7_PRODUTO +"'"
	cUpdate += " AND C7_NUM = '"+ (cAlias)->C7_NUM +"'"
	cUpdate += " AND C7_01NUMPV = '"+ (cAlias)->C7_01NUMPV +"'"
	cUpdate += " AND D_E_L_E_T_ = ''"
	
	nStatus := TcSqlExec(cUpdate)
	
	if (nStatus < 0)
		msgAlert("Erro ao executar o update: " + TCSQLError(), "Atenção")
	endif
endif

RestArea(aARea)

Return
