#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³	SYVA104		ºAutor  ³  TOTVS         º Data ³  21/02/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Manutençcao de baixas de entrega no pedido de venda.       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SYVA104()

Local nX,nY,nPos
Local aPosObj   	:= {}
Local aObjects  	:= {}
Local aSize     	:= {}
Local aInfo     	:= {}
Local aCposAlt		:= {}
Local aCposVis		:= {}
Local bColor	 	:= &("{|| a105CorBrw(@aCorGrd,1) }")
Local nReg			:= SC5->(Recno())
Local nOpc			:= 2
Local nOpcao 		:= 0
Local oDlg
Local oPanel1
Local oPanel2
Local oFwLayerRes

Local aCorGrd := {	;
					{ Rgb(240,255,255)	, Nil , 'Azure'				} ,;
					{ Rgb(230,230,250) 	, Nil , 'Lavander'			} ,;
					{ Rgb(0,255,255) 	, Nil , 'Cyan'				} ,;
					{ Rgb(193,255,193) 	, Nil , 'Lavander'			} ,;
					{ Rgb(202,225,255)	, Nil , 'DarkSeaGreen1'		} ,;
					{ Rgb(192,255,62) 	, Nil , 'OliveDrab1'		} ,;
					{ Rgb(255,255,240)	, Nil , 'Ivory1'			} ,;
					{ Rgb(255,239,213)	, Nil , 'PapayaWhip' 		} ,;
					{ Rgb(255,250,205)	, Nil , 'LemonChiffon' 		} ,;
					{ Rgb(240,255,240)	, Nil , 'Honeydew' 			} ,;
					{ Rgb(127,255,212)	, Nil , 'Aquamarine1'		} ,;
					{ Rgb(245,255,250)	, Nil , 'MintCream' 		} ,;
					{ Rgb(255,240,245)	, Nil , 'LavenderBlush' 	} ,;
					{ Rgb(255,225,255)	, Nil , 'Thistle1' 			} ,;
					{ Rgb(255,250,250)	, Nil , 'Snow' 				} }

Private cPedido		:= SC5->C5_NUM
Private aHeader1 	:= {}
Private aCols1		:= {}
Private aAlter		:= {"DTENTOK"}					
Private o001Get

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ inicializa os campos do cabecalho. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RegToMemory( "SC5" , .F. , .F. )

SX3->(DbSetOrder(1))
SX3->(DbSeek('SC5'))
While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == 'SC5'
	IF ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL )		
		Aadd(aCposAlt,SX3->X3_CAMPO)		
		Aadd(aCposVis,SX3->X3_CAMPO)		
	EndIF
	SX3->(DbSkip())
EndDo

DEFINE FONT oFonteMemo 	NAME "Arial" SIZE 0,-15 BOLD

Aadd(aHeader1,{RetTitle('C6_ITEM')		,'ITEM' 		, PesqPict('SC6','C6_ITEM')		,TamSx3('C6_ITEM' )[1]		,X3Decimal('C6_ITEM')		,'','','C','','',''})
Aadd(aHeader1,{RetTitle('C6_PRODUTO')	,'PRODUTO' 		, PesqPict('SC6','C6_PRODUTO')	,TamSx3('C6_PRODUTO')[1]	,X3Decimal('C6_PRODUTO')	,'','','C','','',''})
Aadd(aHeader1,{RetTitle('C6_DESCRI')	,'DESCRICAO' 	, PesqPict('SB1','B1_DESC')		,TamSx3('B1_DESC')[1]		,X3Decimal('B1_DESC')		,'','','C','','',''})
Aadd(aHeader1,{RetTitle('C6_UM')		,'UNIDADE' 		, PesqPict('SC6','C6_UM')		,TamSx3('C6_UM')[1]			,X3Decimal('C6_UM')			,'','','C','','',''})
Aadd(aHeader1,{RetTitle('C6_QTDVEN')	,'QTDVEN' 		, PesqPict('SC6','C6_QTDVEN')	,TamSx3('C6_QTDVEN')[1]		,X3Decimal('C6_QTDVEN')		,'','','N','','',''})
Aadd(aHeader1,{RetTitle('C6_PRCVEN')	,'PRCVEN' 		, PesqPict('SC6','C6_PRCVEN')	,TamSx3('C6_PRCVEN')[1]		,X3Decimal('C6_PRCVEN')		,'','','N','','',''})
Aadd(aHeader1,{RetTitle('C6_VALOR')		,'VLRTOT' 		, PesqPict('SC6','C6_VALOR')	,TamSx3('C6_VALOR')[1]		,X3Decimal('C6_VALOR')		,'','','N','','',''})
Aadd(aHeader1,{RetTitle('C6_LOCAL')		,'LOCAL' 		, PesqPict('SC6','C6_LOCAL')	,TamSx3('C6_LOCAL')[1]		,X3Decimal('C6_LOCAL')		,'','','C','','',''})
Aadd(aHeader1,{RetTitle('C6_NOTA')		,'NOTA' 		, PesqPict('SC6','C6_NOTA')		,TamSx3('C6_NOTA')[1]		,X3Decimal('C6_NOTA')		,'','','C','','',''})
Aadd(aHeader1,{RetTitle('C6_SERIE')		,'SERIE' 		, PesqPict('SC6','C6_SERIE')	,TamSx3('C6_SERIE')[1]		,X3Decimal('C6_SERIE')		,'','','C','','',''})
Aadd(aHeader1,{RetTitle('C6_ENTREG')	,'DTENT' 		, PesqPict('SC6','C6_ENTREG')	,TamSx3('C6_ENTREG')[1]		,X3Decimal('C6_ENTREG')		,'','','D','','',''})
Aadd(aHeader1,{RetTitle('C6_DTENTOK')	,'DTENTOK' 		, PesqPict('SC6','C6_DTENTOK')	,TamSx3('C6_DTENTOK')[1]	,X3Decimal('C6_DTENTOK')	,'U_A104VLD1()','','D','','',''})
Aadd(aHeader1,{""						,"VAZIO"		,"@!",1,0,".F.","","C","","","","",""})

SC6->(DbSetOrder(1))
SC6->(DbSeek(xFilial("SC6") + cPedido ))
While SC6->( !Eof() ) .And. SC6->C6_FILIAL + SC6->C6_NUM == xFilial("SC6")+cPedido

	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1") + SC6->C6_PRODUTO ))
	
	Aadd(aCols1,Array(Len(aHeader1)+1))
	nPos := Len(aCols1)
	
	aCols1[nPos,01] := SC6->C6_ITEM
	aCols1[nPos,02] := SC6->C6_PRODUTO
	aCols1[nPos,03] := SB1->B1_DESC
	aCols1[nPos,04] := SC6->C6_UM
	aCols1[nPos,05] := SC6->C6_QTDVEN
	aCols1[nPos,06] := SC6->C6_PRCVEN
	aCols1[nPos,07] := SC6->C6_VALOR
	aCols1[nPos,08] := SC6->C6_LOCAL	
	aCols1[nPos,09] := SC6->C6_NOTA
	aCols1[nPos,10] := SC6->C6_SERIE
	aCols1[nPos,11] := SC6->C6_ENTREG
	aCols1[nPos,12] := SC6->C6_DTENTOK	
	aCols1[nPos,13] := ""
	aCols1[nPos,Len(aHeader1)+1] := .F.

	SC6->( dbSkip() )			
EndDo

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
aPosObj[1][3] := 230

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Dialogo.		                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG oDlg TITLE "Pedido de Venda: "+cPedido FROM 0,0 TO aSize[6],aSize[5] OF oMainWnd PIXEL

oFwLayerRes:= FwLayer():New()

oFwLayerRes:Init(oDlg,.T.)

oFwLayerRes:addLine("PEDIDO", 095, .F.)

oFwLayerRes:addCollumn( "COL1",100, .T. , "PEDIDO")

oFwLayerRes:addWindow ( "COL1", "WIN1", "Cabeçalho do Pedido"	, 050 , .T., .F., , "PEDIDO")

oFWLayerRes:addWindow ( "COL1", "WIN2", "Itens do Pedido"		, 050 , .T., .F., , "PEDIDO")

oPanel1:= oFwLayerRes:GetWinPanel("COL1","WIN1","PEDIDO")

oMsMGet := MsMGet():New("SC5",nReg,nOpc,,,,aCposVis,aPosObj[1],aCposAlt,1,,,,oPanel1,,.F.,.T.)
oMsMGet:oBox:Align := CONTROL_ALIGN_ALLCLIENT

oPanel2:= oFwLayerRes:GetWinPanel("COL1","WIN2","PEDIDO")

o001Get:= MsNewGetDados():New(0,0,0,0,GD_UPDATE,"Allwaystrue","AllWaysTrue","",aAlter,,Len(aCols1),,,,oPanel2,@aHeader1,@aCols1)
o001Get:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
o001Get:oBrowse:SetBlkBackColor(bColor)

ACTIVATE MSDIALOG oDlg CENTERED ON INIT ( EnchoiceBar(oDlg,{|| nOpcao := 1 , oDlg:End() }, {|| nOpcao := 0 , oDlg:End() },,) )

If nOpcao == 1

	a104Grava()	

Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³a038CorBrwºAutor  ³Microsiga           º Data ³  21/02/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao de cores na GetDados.                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function a105CorBrw(aCorGrd,nOrig)

IF nOrig == 1	
	IF Empty(o001Get:aCols[o001Get:nAt,1])
		Return(Rgb(255,255,0))
	Else
		Return(Rgb(240,255,255))
	EndIF	
EndIF

Return(cCor)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ A104VLD1 ºAutor  ³Microsiga           º Data ³  21/02/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao de cores na GetDados.                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A104VLD1()

Local lRet 			:= .T.
Local nPosNF  		:= aScan(aHeader1,{ |x| Alltrim(x[2])=="NOTA"})
Local nPosDtEntOk	:= aScan(aHeader1,{ |x| Alltrim(x[2])=="DTENTOK"})
Local nAviso		:= 0

If Empty( o001Get:aCols[o001Get:nAt,nPosNF] )
	MsgStop("Não é possivel baixar este item, porque não foi gerado Nota Fiscal.","Atenção")
	lRet := .F.
Endif

IF lRet
	
	nAviso := Aviso( 'Confirmação de Baixa(s) de Entrega(s)' , 'Deseja replicar este Valor para?' , { 'Todos' , 'Só Neste' } )
	
	IF nAviso == 1 //Todos
		
		For nX := 1 To Len(o001Get:aCols)
			If !Empty( o001Get:aCols[o001Get:nAt,nPosNF] )
				o001Get:aCols[nX,nPosDtEntOk] := M->DTENTOK
			Endif
		Next
		
	Else
		o001Get:aCols[o001Get:nAt,nPosDtEntOk] := M->DTENTOK
	EndIF
	o001Get:oBrowse:Refresh()
	
EndIF

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ a104GravaºAutor  ³Microsiga           º Data ³  21/02/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Grava os dados na tabela do pedido.                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function a104Grava()	

Local aArea 		:= GetArea()
Local nX
Local nPosIt		:= aScan(aHeader1,{ |x| Alltrim(x[2])=="ITEM"})
Local nPosProd		:= aScan(aHeader1,{ |x| Alltrim(x[2])=="PRODUTO"})
Local nPosDtEntOk	:= aScan(aHeader1,{ |x| Alltrim(x[2])=="DTENTOK"})
Local nItens		:= 0

For nX := 1 To Len(o001Get:aCols)

	If !Empty(o001Get:aCols[nX,nPosDtEntOk])
	
		nItens++		
	
		SC6->(DbSetOrder(1))
		If SC6->(DbSeek(xFilial("SC6") + cPedido + o001Get:aCols[nX,nPosIt] + o001Get:aCols[nX,nPosProd] ))
			Reclock("SC6",.F.)
			SC6->C6_DTENTOK := o001Get:aCols[nX,nPosDtEntOk]
			Msunlock()
		Endif
	
	Endif

Next 
   
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualiza o Status do Cabecalho do Pedido                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nItens == Len(o001Get:aCols)
	Reclock("SC5",.F.)
	SC5->C5_STATENT := '2'
	Msunlock()
Else
	Reclock("SC5",.F.)
	SC5->C5_STATENT := '1'
	Msunlock()	
Endif

RestArea(aArea)

Return