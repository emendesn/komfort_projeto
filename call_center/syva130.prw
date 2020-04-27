#Include "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ SYVA130  ³Revisor³   Eduardo Patriani    ³Data  ³18/11/2014³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Tela de Atendimento do Televendas					  	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SYVA130()

Local aArea			:= GetArea()
Local aCores       	:= {}
Local aIndexSUA	   	:= {}
Local cFilQuery	   	:= ""  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Declaracao das variaveis                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aCores    := {	{"(EMPTY(SUA->UA_CODCANC) .AND. VAL(SUA->UA_OPER) == 1 .AND. Empty(SUA->UA_DOC))" , "BR_VERDE"   },;// Faturamento - VERDE
						{"(EMPTY(SUA->UA_CODCANC) .AND. VAL(SUA->UA_OPER) == 1 .AND. !Empty(SUA->UA_DOC))", "BR_VERMELHO"},;// Faturado - VERMELHO
   						{"(EMPTY(SUA->UA_CODCANC) .AND. VAL(SUA->UA_OPER) == 2)"	, "BR_AZUL"   },;						// Orcamento - AZUL
   						{"(EMPTY(SUA->UA_CODCANC) .AND. VAL(SUA->UA_OPER) == 3)"	, "BR_MARRON" },; 						// Atendimento - MARRON
   						{"(!EMPTY(SUA->UA_CODCANC))","BR_PRETO"		}} 														// Cancelado

Private cCadastro  	:= "Atendimento"
Private aRotina		:= MenuDef()                                                                                    
Private cLocDep 	:= GetMv("MV_SYLOCDP",,"100001")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtra somente os PV com Grade.                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
cFilQuery := " UA_FILIAL = '"+xFilial("SUA")+"'"
cFilQuery += " AND UA_DOC 	<> ' '"
cFilQuery += " AND UA_SERIE <> ' '"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Endereca a funcao de BROWSE                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea('SUA')
DbSetOrder(1)
mBrowse(6,1,22,75,"SUA",,,,,,aCores,,,,,,,,IIF(!Empty(cFilQuery),cFilQuery,Nil))


If ( Len(aIndexSUA)>0 )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza o uso da FilBrowse e retorna os indices padroes.  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	EndFilBrw("SUA",aIndexSUA)
EndIf			

RestArea(aArea)

Return(.T.) 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MenuDef   ³ Autor ³   Eduardo Patriani    ³ Data ³14/08/2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Utilizacao de menu Funcional                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Array com opcoes da rotina.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Parametros do array a Rotina:                               ³±±
±±³          ³1. Nome a aparecer no cabecalho                             ³±±
±±³          ³2. Nome da Rotina associada                                 ³±±
±±³          ³3. Reservado                                                ³±±
±±³          ³4. Tipo de Transa‡„o a ser efetuada:                        ³±±
±±³          ³	  1 - Pesquisa e Posiciona em um Banco de Dados           ³±±
±±³          ³    2 - Simplesmente Mostra os Campos                       ³±±
±±³          ³    3 - Inclui registros no Bancos de Dados                 ³±±
±±³          ³    4 - Altera o registro corrente                          ³±±
±±³          ³    5 - Remove o registro corrente do Banco de Dados        ³±±
±±³          ³5. Nivel de acesso                                          ³±±
±±³          ³6. Habilita Menu Funcional                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function MenuDef()     
Return( A130MtMenu() )  

Static Function A130MtMenu(aRotina)
Local aRotina := {}
Aadd(aRotina,{"Pesquisar"		,"PesqBrw"   		, 0, 1, 0, .F. })
Aadd(aRotina,{"Visualizar"		,"TK271CallCenter"	, 0, 2, 0, Nil })
Aadd(aRotina,{"Cancelar"		,"U_A130Cancela"	, 0, 4, 7, Nil })
Aadd(aRotina,{"Legenda"			,"Tk271Legenda"		, 0, 2, 0, .F. })
Return(aRotina)  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SYVA130   ºAutor  ³Microsiga           º Data ³  11/18/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function A130Cancela(cAlias,nReg,nOpc)
Local aArea := GetArea()

If SUA->UA_CANC=='S'
	MsgStop("Atendimento Cancelado.","Atenção")
	RestArea(aArea)
	Return
Endif

If MsgYesNo("Deseja confirmar o cancelamento deste atendimento ?","Atenção")
	SyCancela()
Endif

RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SYVA130   ºAutor  ³Microsiga           º Data ³  11/18/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function SyCancela()

Local aArea   	:= GetArea()
Local cObs    	:= ""										//variavel com a descricao do MEMO
Local cMsg		:= ""
Local oMonoAs	:= TFont():New( "Courier New", 6, 0 )		//Fonte do MEMO
Local nOpcao	:= 0										//Opcao de escolha OK ou CANCELA
Local nVlrNCC	:= 0
Local nCancel	:= 0
Local nCont		:= 0
Local lRetorno	:= .T.
Local aCpos		:= {}
Local aHeader	:= {}
Local aTamanho	:= {}
Local aPosObj   := {}
Local aObjects  := {}
Local aSize     := {}
Local aInfo     := {}
Local aSx3Box1  := RetSx3Box( Posicione("SX3", 2, "UB_CONDENT", "X3CBox()" ),,, 1 )
Local aSx3Box2  := RetSx3Box( Posicione("SX3", 2, "UB_TPENTRE", "X3CBox()" ),,, 1 )
Local aSx3Box3  := RetSx3Box( Posicione("SX3", 2, "UB_XFORFAT", "X3CBox()" ),,, 1 )

Local oDlg													//Tela para cancelamento
Local oObs													//MEMO para observacao do cancelamento
Local cHist

Private aHead2 	 := {""	,"Item","Produto","Descricao","Quantidade","Tabela Preco","Preco Unit."	,"Vlr.Item","Cond.Entrega","Tp. Entrega","Filial Saida","Prazo Entreg","Data Entrega","Valor Frete"	,"Armazem","Ordem Compra","Linha","Cancelado","Cont.Interno"}
Private aRegs2	 :=	{}
Private oGetD2

Private oOk	 := LoadBitMap(GetResources(), "LBOK")
Private oNo	 := LoadBitMap(GetResources(), "LBNO")

SUA->(DbSetOrder(1))
SUA->(DbSeek(xFilial("SUA") + SUA->UA_NUM ))

SUB->(DbSetOrder(1))
SUB->(DbSeek(xFilial("SUB") + SUA->UA_NUM ))
While !Eof() .And. SUB->UB_FILIAL+SUB->UB_NUM==xFilial("SUB")+SUA->UA_NUM
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1") + SUB->UB_PRODUTO ))	
	AAdd( aRegs2, {	.F.,;
					SUB->UB_ITEM,;
					SUB->UB_PRODUTO,;
					SB1->B1_DESC,;
					SUB->UB_QUANT,;
					SUB->UB_01TABPA,;
					SUB->UB_VRUNIT,;
					SUB->UB_VLRITEM,;
					aSx3Box1[Ascan( aSX3BOX1 , {|x| x[2]==SUB->UB_CONDENT})][3],;
					aSx3Box2[Ascan( aSX3BOX1 , {|x| x[2]==SUB->UB_TPENTRE})][3],;
					SUB->UB_FILSAI,;
					SUB->UB_PE,;
					SUB->UB_DTENTRE,;
					SUB->UB_01VALFR,;
					SUB->UB_LOCAL,;
					SUB->UB_01PEDCO,;
					aSx3Box3[Ascan( aSX3BOX3 , {|x| x[2]==SUB->UB_XFORFAT})][1],;
					SUB->UB_01CANC,;
					SUB->(Recno())} )
	SUB->(DbSkip())	
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz o calculo automatico de dimensoes de objetos     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aSize := MsAdvSize()

aObjects := {}
AAdd( aObjects, { 100, 100, .T., .F. } )
AAdd( aObjects, { 070, 100, .F., .T. } )
AAdd( aObjects, { 100, 015, .T., .F. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )
//aPosObj[1][3] := 230

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Dialogo.		                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG oDlg TITLE cCadastro FROM 0,0 TO aSize[6],aSize[5] OF oMainWnd PIXEL

oFwLayer:= FwLayer():New()
oFwLayer:Init(oDlg,.T.)
oFwLayer:addLine("PEDIDO",095,.F.)
oFwLayer:addCollumn( "COL1",100,.T.,"PEDIDO")
oFwLayer:addWindow ( "COL1", "WIN1","Atendimento: "+SUA->UA_NUM+" Cliente: "+Posicione("SA1",1,xFilial("SA1")+SUA->UA_CLIENTE+SUA->UA_LOJA,"A1_NOME"),100,.T.,.F.,,"PEDIDO")
oPanel1:= oFwLayer:GetWinPanel("COL1","WIN1","PEDIDO")

oGetD2				:= TwBrowse():New(0,0,0,0,,aHead2,,oPanel1,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oGetD2:SetArray(aRegs2)
oGetD2:bLine		:= { || {	IIF(aRegs2[oGetD2:nAt,1],oOk,oNo),;							//Marca/Desmarca
								aRegs2[oGetD2:nAt,2],;											//Item                                                   
								aRegs2[oGetD2:nAt,3],;											//Produto
								aRegs2[oGetD2:nAt,4],;											//Descricao
								Transform(aRegs2[oGetD2:nAt,5],PesqPict('SUB','UB_QUANT')),;	//Quantodade
								aRegs2[oGetD2:nAt,6],;											//Tabela de Preco
								Transform(aRegs2[oGetD2:nAt,7],PesqPict('SUB','UB_VRUNIT')),;	//Preco Unitario
								Transform(aRegs2[oGetD2:nAt,8],PesqPict('SUB','UB_VLRITEM')),;	//Valor do Item
								aRegs2[oGetD2:nAt,9],;											//Cond.Entrega
								aRegs2[oGetD2:nAt,10],;											//Tp.Entrega
								aRegs2[oGetD2:nAt,11],;											//Filial Saida
								Transform(aRegs2[oGetD2:nAt,12],PesqPict('SUB','UB_PE')),;		//Prazo de Entrega
								aRegs2[oGetD2:nAt,13],;											//Data Entrega
								Transform(aRegs2[oGetD2:nAt,14],PesqPict('SUB','UB_01VALFR')),;//Valor Frete
								aRegs2[oGetD2:nAt,15],;											//Armazem								
								aRegs2[oGetD2:nAt,16],;											//Ordem de Compra
								aRegs2[oGetD2:nAt,17],;											//Linha
								aRegs2[oGetD2:nAt,18],;											//Cancelado
								aRegs2[oGetD2:nAt,19]}}											//Recno
oGetD2:bLDblClick 	:= { || If(Empty(aRegs2[oGetD2:nAt,18]),aRegs2[oGetD2:nAt,1]:= !aRegs2[oGetD2:nAt,1],(MsgStop("Item cancelado.","Atenção"),aRegs2[oGetD2:nAt,1]:=.F.)), oGetD2:Refresh()}
oGetD2:Align := CONTROL_ALIGN_ALLCLIENT								

ACTIVATE MSDIALOG oDlg CENTERED ON INIT ( EnchoiceBar(oDlg,{|| nOpcao := 1 , oDlg:End() }, {|| nOpcao := 0 , oDlg:End() },,) )

IF nOpcao == 1
	
	nOpcao := 0
	DEFINE MSDIALOG oDlg FROM 05,10 TO 270,470 TITLE "Motivo do Cancelamento" PIXEL
	
	cObs := MSMM(SUA->UA_CODCANC,TamSx3("UA_OBSCANC")[1])
	
	@ 03,04 To 129,228 LABEL "Digite a Informação" OF oDlg PIXEL
	@ 12,08 GET oObs VAR cObs OF oDlg MEMO SIZE 215,95 PIXEL Valid !Empty(cObs)
	
	oObs:oFont := oMonoAs
	
	DEFINE SBUTTON FROM 111,200 TYPE 1 ACTION (nOpcao := 1,oDlg:End()) ENABLE OF oDlg
	
	ACTIVATE MSDIALOG oDlg CENTER
	
	IF nOpcao == 1
		
		Begin Transaction
		
		For nX := 1 To Len(aRegs2)
			
			If aRegs2[nX][1]
				
				nVlrNCC += aRegs2[nX][8]
								
				DbSelectArea("SUB")
				DbGoto(aRegs2[nX][19])
				RecLock("SUB",.F.)
				SUB->UB_01CANC 	:= 'S'
				SUB->UB_01DTCAN	:= dDatabase
				SUB->UB_01USRCA	:= UsrRetName(__cUserID) + "|" + DtoC(dDataBase) + "|" + TIME()
				MsUnlock()
				
				If Left(aRegs2[nX][17],1)=='1'
					SC6->(DbSetOrder(1))
					If SC6->(DbSeek(xFilial("SC6") + SUB->UB_NUMPV + SUB->UB_ITEMPV ))
						RecLock("SC6",.F.)
						SC6->C6_BLQ	:= 'R'
						MsUnlock()						
					Endif
				Endif
				
				If Left(aRegs2[nX][17],1)=='2'
					SC6->(DbSetOrder(1))
					If SC6->(DbSeek(cLocDep + SUB->UB_NUMPV + SUB->UB_ITEMPV ))
						RecLock("SC6",.F.)
						SC6->C6_BLQ	:= 'R'
						MsUnlock()						
					Endif
				Endif
				
			Endif
			
		Next
		
		SUB->(DbSetOrder(1))
		SUB->(DbSeek(xFilial("SUB") + SUA->UA_NUM ))
		While !Eof() .And. SUB->UB_FILIAL+SUB->UB_NUM==xFilial("SUB")+SUA->UA_NUM
			If SUB->UB_01CANC=="S"
				nCancel	+= 1
			Endif
			SUB->(DbSkip())
		End
		
		If nCancel==Len(aRegs2)
			RecLock("SUA",.F.)
			SUA->UA_STATUS 	:= 'CAN'
			SUA->UA_CANC	:= 'S'
			MSMM(,TamSx3("UA_CODCANC")[1],,cObs,1,,,"SUA","UA_CODCANC")
			MsUnlock()
		Endif
		
		If nVlrNCC > 0
			If SUA->UA_DESCONT > 0
				SY130DESC(SUA->UA_DESCONT,@nVlrNCC)
			Endif			
			lRetorno := Ma1300NCC(SUA->UA_NUM, nVlrNCC, @cMsg)
		Endif
		
		If !lRetorno
			DisarmTransaction()
		Endif
		
		End Transaction
	Else
		MsgStop("Cancelamento não efetuado.","Atenção")
	EndIF
	
EndIF

If !lRetorno .and. !empty(cMsg)
	MsgAlert(cMsg, "Atenção")
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Ma1300NCC ³ Autor ³ Felipe Raposo         ³ Data ³23.06.2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gera NCC para pedidos gerados a partir do SigaLoja.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Logico, indicando se a rotina foi executada com sucesso.    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Numero do pedido de venda                            ³±±
±±³          ³ExpN2: Valor de NCC a ser gerado para esse pedido.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ma1300NCC(cPedido, nVlrNCC, cMsg)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lRetorno := .T.
Local aRegAuto[0]
Local nOpc := 0
Local aAreas[0]          
Local cParcela := "A"
Local nModOld  := nModulo
Private lMsHelpAuto := .F.
Private lMsErroAuto := .F.

// Armazena as condicoes das tabelas.
aAdd(aAreas, SL1->(GetArea()))
aAdd(aAreas, SC5->(GetArea()))
aAdd(aAreas, SE1->(GetArea()))
aAdd(aAreas, SUA->(GetArea()))
aAdd(aAreas, GetArea()) 

nModulo := 06

SE1->(dbSetOrder(1))  // E1_FILIAL + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO.

// Posiciona o pedido de venda.
SUA->(dbSetOrder(1))  // C5_FILIAL + C5_NUM.
If SUA->(dbSeek(xFilial("SUA") + cPedido, .F.))    
    
    If SE1->(DbSeek(xFilial("SE1") +;
             PadR("LJ",TamSX3("E1_PREFIXO")[1] ) +;
             PadR(cPedido, TamSX3("E1_NUM")[1] ) +;
             PadR(cParcela, TamSX3("E1_PARCELA")[1] ) +;
             PadR("NCC", TamSX3("E1_TIPO")[1] )))                          
                                           
             While !SE1->(Eof()) .and.;
                    SE1->E1_FILIAL  == xFilial("SE1") .and.;
                    SE1->E1_PREFIXO == PadR("LJ",TamSX3("E1_PREFIXO")[1] ) .and.;
                    SE1->E1_NUM     == PadR(cPedido, TamSX3("E1_NUM")[1] ) .and.;
                    SE1->E1_TIPO    == PadR("NCC", TamSX3("E1_TIPO")[1] )
                    
                cParcela := Soma1(SE1->E1_PARCELA)
                
                SE1->(DbSkip())
            End    
    Endif
    
	// Monta o array com as informacoes para a gravacao do titulo
	aAdd(aRegAuto, {"E1_FILIAL",	xFilial("SE1"), nil})
	aAdd(aRegAuto, {"E1_PREFIXO",	"LJ", nil})
	aAdd(aRegAuto, {"E1_NUM",		cPedido, nil})
	aAdd(aRegAuto, {"E1_PARCELA",	cParcela, nil})
	aAdd(aRegAuto, {"E1_TIPO",		"NCC", nil})
	aAdd(aRegAuto, {"E1_NATUREZ",	&(SuperGetMV("MV_NATNCC")), nil})
	aAdd(aRegAuto, {"E1_CLIENTE",	SUA->UA_CLIENTE, nil})
	aAdd(aRegAuto, {"E1_LOJA",		SUA->UA_LOJA, nil})
	aAdd(aRegAuto, {"E1_NOMCLI" ,	Posicione("SA1", 1, xFilial("SA1") + SUA->(UA_CLIENTE + UA_LOJA), "A1_NOME"), nil})
	aAdd(aRegAuto, {"E1_EMISSAO",	dDataBase, nil})
	aAdd(aRegAuto, {"E1_VENCTO",	dDataBase, nil})
	aAdd(aRegAuto, {"E1_VENCREA",	DataValida(dDataBase), nil})
	aAdd(aRegAuto, {"E1_VALOR",		nVlrNCC, nil})
	aAdd(aRegAuto, {"E1_HIST",		"CANC. DE ORCAM. " + SUA->UA_NUM, nil})
	aAdd(aRegAuto, {"E1_ORIGEM",	"FINA040", nil})
	
	nOpc := 3 // 3-Incluir.
	msExecAuto({|x, y| FINA040(x, y)}, aRegAuto, nOpc)
Else
	lMsErroAuto := .T.
Endif

// Verifica se houve erro.
If lMsErroAuto
	lRetorno := .F.
	cMsg := "Erro na geracao da NCC, valor: " + AllTrim(str(nVlrNCC))
	ConOut(cMsg)      
	MsgStop(cMsg)
Else
	cMsg := "NCC gerada - LJ " + cPedido + " " + cParcela + " - valor: " + AllTrim(str(nVlrNCC))
	ConOut(cMsg)
	MsgInfo(cMsg)
Endif

nModulo := nModOld

// Restaura as condicoes anteriores das tabelas.
aEval(aAreas, {|aArea| RestArea(aArea)})

Return lRetorno    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SY130DESC  ºAutor  ³ TOTVS              º Data ³  26/08/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Alterações na geração de NCC.   		  					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºPrograma. ³ MATA500  										   		  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function SY130DESC(nDesconto,nVlrNCC)

Local aArea   	:= GetArea()
Local nNewValor	:= 0
Local nVlrAbat	:= 0
Local nTotIt	:= 0
Local nPercen	:= 0
Local nPos		:= 0

If nDesconto > 0
    
	SUB->(DbSetOrder(1))
	SUB->(DbSeek(xFilial("SUB") + SUA->UA_NUM ))
	While !Eof() .And. SUB->UB_FILIAL+SUB->UB_NUM==xFilial("SUB")+SUA->UA_NUM
		nTotIt += SUB->UB_VLRITEM
		SUB->(DbSkip())
	End

	nPercen	 := Round(nDesconto/nTotIt,2)	 	
	nVlrAbat := Round((nVlrNCC*nPercen),2)		
	nNewValor:= Round(nVlrNCC-nVlrAbat,2)	
	nVlrNCC  := nNewValor
		
Endif

RestArea(aArea)

Return