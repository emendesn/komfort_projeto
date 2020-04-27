#INCLUDE "PROTHEUS.CH"

#DEFINE NUMCOLS 006
#DEFINE NUMLINH 002
#DEFINE LININI  010
#DEFINE COLINI	 010
#DEFINE LARFOT	 100
#DEFINE ALTFOT	 100

STATIC MVDirFoto:= SuperGetMV("MV_SYDIRFO",,"C:\FOTOS\BESNI\")
STATIC aMascara	:= Separa(SuperGetMV('MV_MASCGRD',,'09,04,02,02'),',')
STATIC nTamPai 	:= Val(aMascara[1])
STATIC nTamLin 	:= Val(aMascara[2])
STATIC nTamCol 	:= Val(aMascara[3])
STATIC nTamRef 	:= IIf(Len(aMascara)==4,Val(aMascara[4]),0)

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � SYTM006  �Autor  � SYMM Consultoria   � Data �  01/12/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Consulta de fotos dos produtos.                            ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function SYTM006A(cProdPai)

Local oDlg
Local oLayer
//Local aSetKey := U_GetSetKey()

Private aPosObj := {}
Private aObjects:= {}
Private aSize   := {}
Private aInfo   := {}

Private aCols	:= {}
Private aFotos  := {}
Private aButtons:= {}

Private aPanel	:= {}
Private aBitmap	:= {}

Private cCodProd:= AllTrim(cProdPai)
Private cDesc 	:= POSICIONE("SB4",1,xFilial("SB4")+cProdPai,"B4_DESC")

//���������������������������������������������Ŀ
//� Verifica a existencia do diretorio de foto. �
//�����������������������������������������������
If !EXISTDIR(MVDirFoto)
	MsgInfo("Diret�rio de foto n�o est� disponivel nesta m�quina. Favor informar o suporte interno.")

	//���������������������������������������������������Ŀ
	//� Retorna o Backup das Teclas de Funcoes.     	  �
	//�����������������������������������������������������
	//U_RestSetKey(aSetKey)
	
	Return .F.
EndIf

MontaBarra(cProdPai)

AAdd(aButtons,{	'',{|| U_VC006MAT(1) }, "Incluir"} )
AAdd(aButtons,{	'',{|| U_VC006MAT(3) }, "Excluir"} )
AAdd(aButtons,{	'',{|| U_MontaPainel(aFotos) }, "Painel de Fotos"} )

//������������������������������������������������������Ŀ
//� Faz o calculo automatico de dimensoes de objetos     �
//��������������������������������������������������������
aSize := MsAdvSize()

aObjects := {}
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 015, .t., .f. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )

DEFINE MSDIALOG oDlg TITLE "Manuten��o de Fotos" FROM 0,0 TO aSize[6],aSize[5] OF oMainWnd PIXEL
    
	//��������������������������Ŀ
	//� Estancia Objeto FWLayer. �
	//����������������������������
	oLayer := FWLayer():new()
	
	//��������������������������������������������������������
	//� Inicializa o objeto com a janela que ele pertencera. �
	//��������������������������������������������������������
	oLayer:init(oDlg,.F.)
	
	//����������������������Ŀ
	//� Cria Linha do Layer. �
	//������������������������
	oLayer:addLine('Lin01',16,.F.)
	oLayer:addLine('Lin02',81,.F.)
	
	//�������������������������Ŀ
	//� Cria a coluna do Layer. �
	//���������������������������
	oLayer:addCollumn('Col01',100,.F.,'Lin01')
	
	oLayer:addCollumn('Col01',30,.F.,'Lin02')
	oLayer:addCollumn('Col02',70,.F.,'Lin02')
	
	//�����������������������������������������������Ŀ
	//� Adiciona Janelas as suas respectivas Colunas. �
	//�������������������������������������������������
	oLayer:addWindow('Col01','L1_Win01','Produto',100,.F.,.F.,,'Lin01',)
	
	oLayer:addWindow('Col01','L2_Win01','Refer�ncias/Cores',100,.F.,.F.,,'Lin02',)
	oLayer:addWindow('Col02','L2_Win02','Foto',100,.F.,.F.,,'Lin02',) 
	
	oLayer:SetColSplit ('Col01',CONTROL_ALIGN_RIGHT,'Lin02')
	
	oBrowse   		:= TcBrowse():New(0,0,0,0,,{"Referencia/Acabamentos","Cor"},{60,50},oLayer:getWinPanel('Col01','L2_Win01','Lin02'),,,,,,,,,,,,.F.,,.T.,,.F.,,,.F.)
	oBrowse:Align	:= CONTROL_ALIGN_ALLCLIENT
	oBrowse:bChange	:= {|| U_VC006LOAD() }
	oBrowse:SetArray(aCols)
	oBrowse:bLine := {|| { 	aCols[oBrowse:nAt][1],;
							aCols[oBrowse:nAt][2] } }
	
	oScroll:=TSCROLLBOX():New(oLayer:getWinPanel('Col02','L2_Win02','Lin02'),0,0,0,0,.T.,.T.,.T.)
	oScroll:Align:= CONTROL_ALIGN_ALLCLIENT
	
	oWin01 := oLayer:getWinPanel('Col01','L1_Win01','Lin01')
	oFont12N := TFont():New('Courier',,-12,,.F.)
	
	@ 05, 005 SAY "Produto" OF oWin01 PIXEL FONT oFont12N
	@ 03, 032 MSGET cCodProd OF oWin01 PIXEL READONLY
	
	@ 05, 115 SAY "Descri��o" OF oWin01 PIXEL FONT oFont12N
	@ 03, 150 MSGET cDesc OF oWin01 PIXEL READONLY
	
	oBitmap1:= TBITMAP():New(0,0,1000,1000,,,,oScroll,,,.T.,.F.,,,,,.T.)

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| oDlg:End() },{|| oDlg:End() },,aButtons) CENTERED

//���������������������������������������������������Ŀ
//� Retorna o Backup das Teclas de Funcoes.     	  �
//�����������������������������������������������������
//T_RestSetKey(aSetKey)
	
Return .T.

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MontaBarra� Autor �    Alexandro Dias     � Data � 08/12/11 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Tela para cadastro do codigo de barras do produto.         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function MontaBarra(cProdPai)

Local nCont 	:= 0
Local nY 		:= 0
Local cProduto 	:= ""
Local cCor		:= ""
Local xAliasSB1 := {}
Local cLinha	:= Posicione("SB4",1,xFilial("SB4")+cProdPai,"B4_LINHA")

//�������������������������������������Ŀ
//� Linha vazia para representar o pai. �
//���������������������������������������
AADD(aFotos, {cProdPai,"","","",0,.T.} )
Aadd(aCols, {"","GENERICO"})

SB1->(DbOrderNickName("SYMMSB101"))
SB1->(DbSeek(xFilial("SB1")+RTrim(cProdPai)))
While SB1->(!EOF()) .And. RTrim(SB1->B1_FILIAL+SB1->B1_01PRODP) == RTrim(xFilial("SB1")+cProdPai)
	
	//��������������������������������������������������������������Ŀ
	//� Produto com Grade                                            �
	//����������������������������������������������������������������
	If Ascan(aFotos,{|x| x[1]+x[2] == SB1->B1_01PRODP+SB1->B1_01RFGRD} ) == 0		
		AADD(aFotos, {SB1->B1_01PRODP,SB1->B1_01RFGRD,'',SB1->B1_01DREF,0,.T.} )
		
		Aadd(aCols,Array(2))		
		aCols[Len(aCols)][1]:=	SB1->B1_01RFGRD
		aCols[Len(aCols)][2]:=	SB1->B1_01DREF
	EndIf		
	
	If Ascan(aFotos,{|x| x[1]+x[3] == SB1->B1_01PRODP+SB1->B1_01LNGRD} ) == 0		
		AADD(aFotos, {SB1->B1_01PRODP,'',SB1->B1_01LNGRD,'',0,.T.} )
		
		Aadd(aCols,Array(2))		
		aCols[Len(aCols)][1]:= SB1->B1_01LNGRD
		aCols[Len(aCols)][2]:= Posicione("SBV",1,xFilial("SBV")+cLinha+SB1->B1_01LNGRD,"BV_DESCRI")
	EndIf		
	
	SB1->(DbSkip())

EndDo

//�������������������������������Ŀ
//� Ordena coluna da referencia.  �
//���������������������������������
aSort(aCols,,,{ |x,y| y[1] > x[1] } )
aSort(aFotos,,,{ |x,y| y[4] > x[4] } )

Return .T.

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �VC006LOAD � Autor � SYMM Consultoria      � Data � 08/12/11 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Tela para cadastro do codigo de barras do produto.         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function VC006LOAD()

Local cFile

cFile := MVDirFoto
cFile += AllTrim(aFotos[oBrowse:nAt][1])
If !oBrowse:aArray[oBrowse:nAt][2]=="GENERICO"
	cFile += AllTrim(aCols[oBrowse:nAt][1])
Endif
cFile += ".JPG"

If File(cFile)
	oBitmap1:Load(,cFile)
	oBitmap1:Refresh()
Else
	oBitmap1:Load(,MVDirFoto+"SEMFOTO.JPG")
	oBitmap1:Refresh()
EndIf

Return .T.

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �VC006LOAD � Autor � SYMM Consultoria      � Data � 08/12/11 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Tela para cadastro do codigo de barras do produto.         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function VC006MAT(nOpca)

Local cNewFile
Local cFile

cFile := MVDirFoto
cFile += AllTrim(aFotos[oBrowse:nAt][1])
If !oBrowse:aArray[oBrowse:nAt][2]=="GENERICO"
	cFile += AllTrim(aCols[oBrowse:nAt][1])
Endif
cFile += ".JPG"

If EMPTY(cFile)
	Return .F.
EndIf

Do Case
	Case !File(cFile) .AND. nOpca==3
		MsgStop("N�o h� imagem para ser excluida!","Aten��o")
	Case File(cFile) .AND. nOpca==1
		MsgStop("N�o � poss�vel a inclus�o de foto, pois j� existe foto relacionada com este produto!","Aten��o")
	Case nOpca==1
		
		cNewFile := cGetFile("Entrada de Arquivo (*.JPG) | *.JPG" ,"Remote Path",,,.F.,GETF_LOCALFLOPPY+GETF_LOCALHARD+GETF_NETWORKDRIVE,.F.)
		/*
		If FRENAME(cNewFile,cFile) == -1
	   		MsgStop('Falha na inclus�o da foto ( FError'+STR(FERROR(),4)+ ')')
	   		Return .F.
		EndIf                     
		*/
		__CopyFile(cNewFile,cFile)
	Case nOpca==3		
		If FRENAME(cFile,cFile+"_old_"+DToS(Date())+"_"+STRTRAN(TIME(),':')) == -1
	   		MsgStop('Falha na exclus�o da foto ( FError'+STR(FERROR(),4)+ ')')		
	   		Return .F.
		EndIf
EndCase

U_VC006LOAD()

Return .T.       


/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MontaPainel� Autor � SYMM Consultoria    � Data � 08/12/11 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Tela para cadastro do codigo de barras do produto.         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function MontaPainel(aProduto)

Local nX, nY
Local nCont  := 1
Local nProd  := Len(aProduto)
Local aFotos := {}

Private aPaginas := {}
Private nPagShow := 1
Private lDown 	 := .F.

For nX:=1 To nProd
	cAux := AllTrim(aProduto[nX][1])+AllTrim(aProduto[nX][2])+AllTrim(aProduto[nX][3])
	If FILE(MVDirFoto+cAux+".JPG")
		AADD(aFotos, aProduto[nX])
	EndIf
Next nX

nFotos := Len(aFotos)

While nFotos >= nCont
	
	AADD(aPaginas, Array(NUMLINH))

	For nX:=1 To NUMLINH
		
		ATail(aPaginas)[nX] := Array(NUMCOLS)
		
		For nY:=1 To NUMCOLS
			If nFotos >= nCont
				ATail(aPaginas)[nX][nY] := aFotos[nCont]
			Else
				EXIT
			EndIf
		
			nCont++
		Next nY
	
		If nFotos < nCont
			EXIT
		EndIf
	Next nX
EndDo

AcMostraLts()

Return .T.

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �  MyEnchoBar  � Autor �   Alexandro Dias  � Data � 16/04/05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Botoes da Tela dos Paineis dos lotes.                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function MyEnchoBar()

Local oBar
Local oBtn[9]

DEFINE BUTTONBAR oBar SIZE 25,25 BUTTONSIZE 40,25 TOP OF oDlgFotos

DEFINE BUTTON oBtn[1] RESOURCE "TOP"	OF oBar ACTION AcPagina(1) //TOOLTIP "Primeira Pagina..."
DEFINE BUTTON oBtn[3] RESOURCE "PGPREV"	OF oBar ACTION AcPagina(2) //TOOLTIP "Pagina Anterior..."
DEFINE BUTTON oBtn[5] RESOURCE "PGNEXT"	OF oBar ACTION AcPagina(3) //TOOLTIP "Proxima Pagina..."
DEFINE BUTTON oBtn[7] RESOURCE "BOTTOM"	OF oBar ACTION AcPagina(4) //TOOLTIP "Ultima Pagina..."
DEFINE BUTTON oBtn[9] RESOURCE "OK"    	OF oBar ACTION (lDown:=.F.,oDlgFotos:End()) //TOOLTIP "Sair..."

oBar:bRClicked := {|| Alert("oBar:bRClicked") }

Return .T.                                     

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � AcMostraLts  � Autor �   Alexandro Dias  � Data � 08/04/05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Apresenta as paginas dos lotes.                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function AcMostraLts()

Local aPanel := {}
Local aBitmap:= {}
Local nLinha := LININI
Local nColuna:= COLINI
Local nEsp	 := 10
Local cTitulo:= "Painel de Fotos... [Pagina "+Alltrim(Str(nPagShow))+"/"+Alltrim(Str(Len(aPaginas)))+"]"
Local cFile
Local nX, nY

Private aPosObj   := {}
Private aObjects  := {}
Private aSize     := {}
Private aInfo     := {}

//������������������������������������������������������Ŀ
//� Faz o calculo automatico de dimensoes de objetos     �
//��������������������������������������������������������
aSize := MsAdvSize()

aObjects := {}
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 015, .t., .f. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )

If EMPTY(aPaginas)
	MsgInfo("N�o h� fotos para exibir!")
	Return .F.
EndIf

DEFINE MSDIALOG oDlgFotos FROM 0,0 TO aSize[6],aSize[5] TITLE cTitulo Of oMainWnd PIXEL
    
	oScroll:= TSCROLLBOX():New(oDlgFotos,0,0,0,0,.T.,.T.,.T.)
	oScroll:Align:= CONTROL_ALIGN_ALLCLIENT
		
	For nX:=1 To Len(aPaginas[nPagShow])
		
		AADD(aPanel, Array(NUMCOLS))
		AADD(aBitmap, Array(NUMCOLS))
		
		For nY:=1 To NUMCOLS			
			If !EMPTY(aPaginas[nPagShow][nX]) .AND. !EMPTY(aPaginas[nPagShow][nX][nY])
				ATail(aPanel)[nX] := TPanel():New(nLinha,nColuna,,oScroll,,,,,,LARFOT,ALTFOT,.F.,.T.)
				ATail(aBitmap)[nX]:= TBITMAP():New(0,0,0,0,,,,ATail(aPanel)[nX],,,.F.,.T.,,,,,.T.)
				ATail(aBitmap)[nX]:Align:= CONTROL_ALIGN_ALLCLIENT
				
				cFile := MVDirFoto
				cFile += AllTrim(aPaginas[nPagShow][nX][nY][1])
				cFile += AllTrim(aPaginas[nPagShow][nX][nY][2])
				cFile += AllTrim(aPaginas[nPagShow][nX][nY][3])
				cFile += ".JPG"
				
				ATail(aBitmap)[nX]:Load(,cFile)
				ATail(aBitmap)[nX]:CTOOLTIP := AcMsgFoto(aPaginas[nPagShow][nX][nY])
				ATail(aBitmap)[nX]:Refresh()
			EndIf
			
			nColuna+=(100+nEsp)
		Next ny
		
		nColuna:=COLINI
		nLinha+=(100+nEsp)
	Next nX

ACTIVATE MSDIALOG oDlgFotos ON INIT MyEnchoBar()

If lDown
	lDown := .F.
	AcMostraLts()
EndIf

Return .T.

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �  AcPagina    � Autor �   Alexandro Dias  � Data � 16/04/05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Controla a visualizacao das paginas dos lotes.             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function AcPagina(nSeta)

lDown := .T.

If nSeta == 1
	//���������������������������������������������������������Ŀ
	//� Primeira pagina.                                        �
	//�����������������������������������������������������������
	If nPagShow > 1
		nPagShow := 1
	Else
		lDown := .F.
	EndIf
ElseIf nSeta == 2
	//���������������������������������������������������������Ŀ
	//� Pagina anterior.                                        �
	//�����������������������������������������������������������
	nPagShow--
	If nPagShow <= 0
		nPagShow := 1
		lDown 	 := .F.
	EndIf
ElseIf nSeta == 3
	//���������������������������������������������������������Ŀ
	//� Proxima pagina.                                         �
	//�����������������������������������������������������������
	nPagShow++
	If nPagShow > Len(aPaginas)
		nPagShow := Len(aPaginas)
		lDown 	 := .F.
	EndIf
ElseIf nSeta == 4
	//���������������������������������������������������������Ŀ
	//� Ultima pagina.                                          �
	//�����������������������������������������������������������
	If nPagShow < Len(aPaginas)
		nPagShow := Len(aPaginas)
	Else
		lDown := .F.
	EndIf
	
EndIf

If lDown
	oDlgFotos:End()
EndIf

Return .T.

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � AcMsgFoto    � Autor � SYMM Consultoria  � Data � 19/12/11 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Cria mensagem para foto.                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function AcMsgFoto(aCampos)

Local cMsg 		:= ""
Local lPai		:= EMPTY(aCampos[2]) .AND. EMPTY(aCampos[3])
Local cAlias	:= IIF(lPai,"SB4","SB1")
Local lExist	:= .F.
Local cChave
Local cDescRef
Local nCarteira := 0

cChave := aCampos[1]
cChave += aCampos[2]
cChave += aCampos[3]

dbSelectArea(cAlias)
If lPai
	dbSetOrder(1)
	lExist := (dbSeek(xFilial(cAlias)+cChave))
	If aCampos[6] // Pra saber qual rotina esta sendo executada
		nCarteira:= TotalCart(SB4->B4_COD,,,lPai)
	Else
		nCarteira:= aCampos[5]
	EndIf
Else
	dbOrderNickName("SYMMSB102")
	lExist   := (dbSeek(xFilial(cAlias)+cChave))
	lExist   := (SB4->(dbSeek(xFilial("SB4")+cCodProd)))
	cDescRef := AllTrim(SB1->B1_01DREF)
	nCarteira:= TotalCart(aCampos[1],aCampos[2],aCampos[3],lPai)
EndIf

If lExist
	cMsg += "Produto: " 	+ SB4->B4_COD  + CRLF
	cMsg += "Descri��o: " 	+ SB4->B4_DESC + CRLF
	cMsg += IIF(!lPai,"Refer�ncia: "+cDescRef+CRLF,"")
	cMsg += "Marca: " 		+ AllTrim(POSICIONE("AY2",1,xFilial("AY2")+SB4->B4_01CODMA,"AY2_DESCR")) + CRLF
	//cMsg += "Cole��o: " 	+ AllTrim(POSICIONE("AYH",1,xFilial("AYH")+SB4->B4_01COLEC,"AYH_DESCRI")) + CRLF
	cMsg += "Qtde Carteira: "+ Transform(nCarteira, "@E 999,999,999.99") + CRLF
EndIf

Return(cMsg)

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � TotalCart    � Autor � SYMM Consultoria  � Data � 20/12/11 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna total em cartereira do produto.                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function TotalCart(cCodProd,cCodRef,cCodLin,lPai)

Local nRet	 := 0
Local cQuery := ""
Local cAlias := CriaTrab(,.F.)

cQuery := " SELECT "+CRLF
cQuery += " 	ISNULL(SUM(AYM.AYM_QUANT-AYM.AYM_QUJE),0) AS QTDECART "+CRLF

cQuery += " FROM "+RetSqlName("SC7")+" SC7 (NOLOCK) "+CRLF

cQuery += " INNER JOIN "+RetSqlName("AYM")+" AYM (NOLOCK) "+CRLF
cQuery += " 	ON AYM.AYM_FILORI = SC7.C7_FILIAL "+CRLF
cQuery += "		AND AYM.AYM_NUM = SC7.C7_NUM "+CRLF
cQuery += "		AND AYM.AYM_SKU = SC7.C7_PRODUTO "+CRLF
cQuery += "		AND AYM.AYM_FORNEC = SC7.C7_FORNECE "+CRLF
cQuery += "		AND AYM.AYM_LOJA = SC7.C7_LOJA "+CRLF
cQuery += "		AND SUBSTRING(AYM.AYM_GRADE,1,2) = SUBSTRING(SC7.C7_01GRADE,1,2) "+CRLF
cQuery += "		AND AYM.D_E_L_E_T_ <> '*' "+CRLF

cQuery += " WHERE "+CRLF
cQuery += " 	SC7.C7_FILIAL = '"+xFilial("SC7")+"' "+CRLF
cQuery += " 	AND SUBSTRING(SC7.C7_PRODUTO,1,"+cValToChar(nTamPai)+") = '"+cCodProd+"' "+CRLF
If !lPai
	cQuery += " 	AND SUBSTRING(SC7.C7_PRODUTO,"+cValToChar(nTamPai+1)+","+cValToChar(nTamLin)+") = '"+cCodLin+"' "+CRLF
	cQuery += " 	AND SUBSTRING(SC7.C7_PRODUTO,"+cValToChar(nTamPai+nTamLin+nTamCol+1)+","+cValToChar(nTamRef)+") = '"+cCodRef+"' "+CRLF
EndIf
cQuery += " 	AND SC7.C7_QUJE < SC7.C7_QUANT "+CRLF
cQuery += " 	AND SC7.C7_RESIDUO <> 'S' "+CRLF
cQuery += " 	AND SC7.D_E_L_E_T_ <> '*' "+CRLF

DbUseArea(.T.,"TOPCONN",TCGENQRY(,,ChangeQuery(cQuery)),cAlias,.F.,.T.)
While (cAlias)->(!EOF())
	nRet := (cAlias)->QTDECART
	
	(cAlias)->(dbSkip())
EndDo

(cAlias)->(DbCloseArea())
	
Return nRet

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VC006Painel�Autor  � SYMM Consultoria   � Data �  21/12/11  ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function SYTM006B(cProdPai)

Local aAreaAtu	:= GetArea() 
Local cPerg		:= "SYTM006"
Local aDados	:= {}
Local cEspecie

Private cArq	:= CriaTrab(,.F.)

Private cProdDe
Private cProdAte
Private cEspDe	
Private cEspAte
Private nOpcCart

//���������������������������������������������Ŀ
//� Verifica a existencia do diretorio de foto. �
//�����������������������������������������������
If !EXISTDIR(MVDirFoto)
	MsgInfo("Diret�rio de foto n�o est� disponivel nesta m�quina. Favor informar o suporte interno.")	
	Return .F.
EndIf

lPai := .T.

AjustaSx1(cPerg)
Pergunte(cPerg,.F.)

If !EMPTY(cProdPai)
	
	cEspecie := POSICIONE("SB4",1,xFilial("SB4")+cProdPai,"B4_01CAT4")
		
	dbSelectArea("SX1")
	dbSetOrder(1)
	dbSeek(cPerg)
	While SX1->(!EOF()) .OR. AllTrim(SX1->X1_GRUPO) == cPerg
		
		Do Case
			Case AllTrim(SX1->X1_VAR01) == "MV_PAR01"
				RecLock("SX1",.F.)
					SX1->X1_CNT01 := cProdPai
				SX1->(MSUNLOCK())
			Case AllTrim(SX1->X1_VAR01) == "MV_PAR02"
				RecLock("SX1",.F.)
					SX1->X1_CNT01 := cProdPai
				SX1->(MSUNLOCK())
			Case AllTrim(SX1->X1_VAR01) == "MV_PAR03"
				RecLock("SX1",.F.)
					SX1->X1_CNT01 := cEspecie
				SX1->(MSUNLOCK())
			Case AllTrim(SX1->X1_VAR01) == "MV_PAR04"
				RecLock("SX1",.F.)
					SX1->X1_CNT01 := cEspecie
				SX1->(MSUNLOCK())
		EndCase
		
		SX1->(dbSkip())
	EndDo	
EndIf

While Pergunte(cPerg)
	cProdDe := MV_PAR01
	cProdAte:= MV_PAR02
	cEspDe	:= MV_PAR03
	cEspAte	:= MV_PAR04
	nOpcCart:= MV_PAR05
	
	If Validacao()
		aDados := CargaDados()
		U_MontaPainel(aDados)
		EXIT
	Else
		LOOP
	EndIf
EndDo

RestArea(aAreaAtu)

Return .T. 

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CargaDados�Autor  � SYMM Consultoria	 � Data �  22/12/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � 															  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function CargaDados()

Local cQuery := ""
Local aDados := {}
Local cAlias := CriaTrab(,.F.)

cQuery := " SELECT "+CRLF
cQuery += " 	SB4.B4_COD, "+CRLF 
cQuery += " 	ISNULL(SUM(AYM.AYM_QUANT-AYM.AYM_QUJE),0) AS QTDECART "+CRLF

cQuery += " FROM "+RetSqlName("SB4")+" SB4 (NOLOCK) "+CRLF

If nOpcCart==1
	cQuery += " INNER JOIN "+RetSqlName("SC7")+" SC7 (NOLOCK) "+CRLF
Else
	cQuery += " LEFT JOIN "+RetSqlName("SC7")+" SC7 (NOLOCK) "+CRLF
EndIf

cQuery += " 	ON SC7.C7_FILIAL = '"+xFilial("SC7")+"' "+CRLF
cQuery += " 	AND SUBSTRING(SC7.C7_PRODUTO,1,"+StrZero(nTamPai,2)+") = SUBSTRING(SB4.B4_COD,1,"+StrZero(nTamPai,2)+") "+CRLF
cQuery += " 	AND SC7.C7_QUJE < SC7.C7_QUANT "+CRLF
cQuery += " 	AND SC7.C7_RESIDUO <> 'S' "+CRLF
cQuery += " 	AND SC7.D_E_L_E_T_ <> '*' "+CRLF

cQuery += " LEFT JOIN "+RetSqlName("AYM")+" AYM (NOLOCK) "+CRLF
cQuery += " 	ON AYM.AYM_FILORI = SC7.C7_FILIAL "+CRLF
cQuery += "		AND AYM.AYM_NUM = SC7.C7_NUM "+CRLF
cQuery += "		AND AYM.AYM_SKU = SC7.C7_PRODUTO "+CRLF
cQuery += "		AND AYM.AYM_FORNEC = SC7.C7_FORNECE "+CRLF
cQuery += "		AND AYM.AYM_LOJA = SC7.C7_LOJA "+CRLF
cQuery += "		AND SUBSTRING(AYM.AYM_GRADE,1,2) = SUBSTRING(SC7.C7_01GRADE,1,2) "+CRLF
cQuery += "		AND AYM.D_E_L_E_T_ <> '*' "+CRLF

cQuery += " WHERE "+CRLF
cQuery += " 	SB4.B4_FILIAL = '"+xFilial("SB4")+"' "+CRLF
cQuery += " 	AND SB4.B4_COD BETWEEN '"+cProdDe+"' AND '"+cProdAte+"' "+CRLF
cQuery += " 	AND SB4.B4_01CAT4 BETWEEN '"+cEspDe+"' AND '"+cEspAte+"' "+CRLF
cQuery += " 	AND SB4.D_E_L_E_T_ <> '*' "+CRLF

cQuery += " GROUP BY "+CRLF
cQuery += " 	SB4.B4_COD "+CRLF

cQuery += " ORDER BY "+CRLF
cQuery += " 	SB4.B4_COD "+CRLF

DbUseArea(.T.,"TOPCONN",TCGENQRY(,,ChangeQuery(cQuery)),cAlias,.F.,.T.)
While (cAlias)->(!EOF())
	AADD(aDados, {(cAlias)->B4_COD,"","","",(cAlias)->QTDECART,.F.})
	
	(cAlias)->(dbSkip())
EndDo

(cAlias)->(DbCloseArea())
	
Return aDados

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � Validacao�Autor  � SYMM Consultoria	 � Data �  22/12/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � 															  ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function Validacao()
Return .T.

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � AjustaSx1�Autor  � SYMM Consultoria	 � Data �  22/12/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cria Perguntas na SX1 atraves da funcao PUTSX1().          ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function AjustaSx1(cPerg)  

Local aHlpPor01 := {"Informe o c�digo do produto inicial."	,"",""}
Local aHlpPor02 := {"Informe o c�digo do produto final." 	,"",""}
Local aHlpPor03 := {"Informe o c�digo da esp�cie inicial." 	,"",""}
Local aHlpPor04 := {"Informe o c�digo da esp�cie final."  	,"",""}
Local aHlpPor05 := {"Selecione 'sim' se deseja apenas os " 	,"produtos em carteira.",""}

PutSx1(cPerg,"01","Produto de 			?","Produto de 			?","Produto de 			?","MV_CH1","C",TamSx3("B4_COD")[1] 	,, ,"G",,"SB4"		,,,"MV_PAR01",			,,,CriaVar("B4_COD",.F.)		 	  		,		,,,,,,,,,,,,aHlpPor01,aHlpPor01,aHlpPor01)
PutSx1(cPerg,"02","Produto ate	   		?","Produto ate	   		?","Produto ate	   		?","MV_CH2","C",TamSx3("B4_COD")[1]		,, ,"G",,"SB4"		,,,"MV_PAR02",  		,,,Replicate("Z",TamSx3("B4_COD")[1])		,		,,,,,,,,,,,,aHlpPor02,aHlpPor02,aHlpPor02)
PutSx1(cPerg,"03","Esp�cie de 			?","Esp�cie de 			?","Esp�cie de 			?","MV_CH3","C",TamSx3("B4_01CAT4")[1]	,, ,"G",,"AY0CA4"	,,,"MV_PAR03",			,,,CriaVar("B4_01CAT4",.F.)			 	,		,,,,,,,,,,,,aHlpPor03,aHlpPor03,aHlpPor03)
PutSx1(cPerg,"04","Esp�cie ate			?","Esp�cie ate			?","Esp�cie ate			?","MV_CH4","C",TamSx3("B4_01CAT4")[1]	,, ,"G",,"AY0CA4"	,,,"MV_PAR04",			,,,Replicate("Z",TamSx3("B4_01CAT4")[1]) 	,		,,,,,,,,,,,,aHlpPor04,aHlpPor04,aHlpPor04)
PutSx1(cPerg,"05","Produto em Carteira	?","Produto em Carteira	?","Produto em Carteira	?","MV_CH5","N",1					   	,,1,"C",,			,,,"MV_PAR05","1-SIM"	,,,											,"2-NAO",,,,,,,,,,,,aHlpPor05,aHlpPor05,aHlpPor05)

Return .T.
