#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"

#Define GD_INSERT  1
#Define GD_UPDATE  2
#Define GD_DELETE  4

#Define MAXGETDAD 99999
#DEFINE CRLF	   CHR(10)+CHR(13)

STATIC nSel01 := 1

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � SYVA109  �Autor  � SYMM CONSULTORIA   � Data �  06/05/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cadastro de percentuais de comissoes.                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function SYVA109()

Local aArea			:= GetArea()

Private cCadastro  	:= "Cadastro de percentuais de comiss�es"
Private aRotina		:= MenuDef()
			
DbSelectArea('SZ4')
DbSetOrder(1)
mBrowse( 6, 1,22,75,"SZ4",,,,,,,,,,,,,,)

RestArea(aArea)

Return(.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MenuDef   �Autor  � SYMM CONSULTORIA   � Data �  28/03/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Utilizacao de menu Funcional                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function MenuDef()     
Return( a109MtMenu() )  

Static Function a109MtMenu()
Local aRotina := {}
Aadd(aRotina,{"Pesquisar"	,"PesqBrw"   	, 0, 1, 0, .F. }) 
Aadd(aRotina,{"Visualizar"	,"U_a109Manut"	, 0, 2, 0, Nil }) 
Aadd(aRotina,{"Incluir"		,"U_a109Manut"	, 0, 3, 0, Nil })
Aadd(aRotina,{"Alterar"		,"U_a109Manut"	, 0, 4, 6, Nil })
Aadd(aRotina,{"Excluir"		,"U_a109Manut"	, 0, 5, 7, Nil })
Return(aRotina)

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �a109Manut � Autor � SYMM CONSULTORIAi     � Data � 06/05/14 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Programa de Vis/Inc/Alt/Exclusao do Cadastro de Comissoes. ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
User Function A109Manut(cAlias,nReg,nOpc)

Local aButtons 		:= {}
Local aPosObj   	:= {}
Local aObjects  	:= {}
Local aSize     	:= {}
Local aPosGet   	:= {}
Local aInfo     	:= {}
Local nOpcA			:= 0
Local nI			:= 0
Local nStyle 	   	:= GD_INSERT+GD_UPDATE

Private oFolder
Private aTELA[0][0]
Private aGETS[0]

Private aHeadP1
Private aColsP1
Private aAltP1
Private oGetP1

Private oDlg
Private oEnchoice
Private oPanelGet      
Private oTipo
     	
If nOpc == 3
	MsgRun("Por favor, aguarde ...",, {|| FiltraSZ4(@aHeadP1,@aColsP1,"SZ4","Z4_ORDEM|Z4_TIPO|Z4_COND|Z4_PERCEN",1,nOpc,,{"Z4_TIPO","Z4_ORDEM"},,) })
	
	If Len(aColsP1)==0
		Aviso(cCadastro,"N�o existem registros para essa consulta.",{"OK"})
		Return
	EndIF
Else
	MsgRun("Por favor aguarde, filtrando produtos...",, {|| FiltraSZ4(@aHeadP1,@aColsP1,"SZ4","Z4_ORDEM|Z4_TIPO|Z4_COND|Z4_PERCEN",1,nOpc,"SZ4.Z4_TIPO = '"+SZ4->Z4_TIPO+"'",{"Z4_TIPO","Z4_ORDEM"},,) })
EndiF

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

DEFINE FONT oFntBut NAME "Arial" SIZE 0, -20

DEFINE MSDIALOG oDlg TITLE cCadastro FROM 0,0 TO aSize[6],aSize[5] OF oMainWnd PIXEL

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
oLayer:addLine('Lin01',97,.F.)

//�������������������������Ŀ
//� Cria a coluna do Layer. �
//���������������������������
oLayer:addCollumn('Col01',100,.F.,'Lin01')

//�����������������������������������������������Ŀ
//� Adiciona Janelas as suas respectivas Colunas. �
//�������������������������������������������������
oLayer:addWindow('Col01','L1_Win01','Comiss�es',100,.T.,.F.,,'Lin01',)

oPanel1:= oLayer:GetWinPanel("Col01","L1_Win01","Lin01")

oGetP1:=MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nStyle,"AlwaysTrue","AlwaysTrue","Z4_TIPO"+"+Z4_ORDEM",{"Z4_TIPO","Z4_COND","Z4_PERCEN"},,MAXGETDAD,,,,oPanel1,@aHeadP1,@aColsP1)
oGetP1:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
oGetP1:Refresh()

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg , {|| IIF( Obrigatorio(aGets,aTela) , (nOpca := 1 , oDlg:End() ) , .F. ) } , {|| oDlg:End() },,aButtons)

IF nOpcA == 1
		
	Begin Transaction  
	
	aColsP1 := aClone(oGetP1:aCols)
		
	A109Grava(nOpc)
	
	End Transaction	
EndIf

//��������������������������������������������������������������Ŀ
//� Restaura a integridade da janela                             �
//����������������������������������������������������������������
DbSelectArea(cAlias)

Return(.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FiltraSZ4 �Autor  �Microsiga           � Data �  07/17/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Filtra registros das notas fiscais de entrada.             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                                                           

Static Function FiltraSZ4(aHeader1,aCols1,cAlias,cCampos,nFolder,nOpc,cWhere,aOrder,cFilQry,cFilSeg)
				
Local cQuery	:= ""
Local nUsado 	:= 0
Local nCntFor

aHeader1 := {}
aCols1	 := {}
aAlter1	 := {}
aNoFields:= {}

DbSelectArea(cAlias)
DbSetOrder(1)

If nOpc <> 3
	//������������������������������������������������������Ŀ
	//� Carrega Dados da Tabela especifica.              	 �
	//��������������������������������������������������������
	CarregaDados(@aHeader1,@aCols1,cAlias,cWhere,aOrder,aNoFields,nOpc)
Else
	//������������������������������������������������������Ŀ
	//� Monta aHeader a partir dos campos do SX3         	 �
	//��������������������������������������������������������
	DbSelectArea("SX3")
	DbSetorder(1)
	MsSeek(cAlias)
	While !Eof() .And. (X3_ARQUIVO == cAlias)
		IF AllTrim(X3_CAMPO)$cCampos
			nUsado++
			Aadd(aHeader1, {	AllTrim(X3Titulo()),;
			SX3->X3_CAMPO,;
			SX3->X3_PICTURE,;
			SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL,;
			SX3->X3_VALID,;
			SX3->X3_USADO,;
			SX3->X3_TIPO,;
			SX3->X3_F3,;
			SX3->X3_CONTEXT,;
			SX3->X3_CBOX,;
			SX3->X3_RELACAO,;
			".T."	} )
		EndIF
		SX3->(DbSkip())
	EndDo
		
	CarregaItens(@aHeader1,@aCols1)
	
Endif
						
Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A109Grava �Autor  � SYMM CONSULTORIA   � Data �  06/05/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Realiza a gravacao.                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function A109Grava(nOpc) 

Local cFilSZ4 := xFilial("SZ4")
Local cChave  := If(INCLUI,"",SZ4->Z4_TIPO)
Local nCntFor := 0
Local nUsado  := 0
Local lRet	  := .T.
Local nCntFor2
Local nX, nY

Do Case
	
	Case nOpc == 3  //Incluir
		
		//Atualiza Itens da remarcacao.
		nUsado := Len(aHeadP1)
		For nCntFor := 1 To Len(aColsP1)
			If ( !aColsP1[nCntFor][nUsado+1] )
				dbSelectArea("SZ4")
				Reclock("SZ4",.T.)
				For nCntFor2 := 1 To nUsado
					If ( aHeadP1[nCntFor2][10] != "V" )
						FieldPut(FieldPos(aHeadP1[nCntFor2][2]),aColsP1[nCntFor][nCntFor2])
					EndIf
				Next nCntFor2
				SZ4->Z4_FILIAL	:= cFilSZ4
				MsUnlock()
			EndIf
		Next
		SZ4->(FKCommit())
						
	Case nOpc == 4  //Atualizar
		
		//��������������������������������������������������������������Ŀ
		//�Itens da Remarcacao.						                     �
		//����������������������������������������������������������������
		aRecNo:={}
		dbSelectArea("SZ4")
		dbSetOrder(1)
		DbSeek(xFilial("SZ4")+cChave)
		While ( !Eof() .And. xFilial("SZ4") == SZ4->Z4_FILIAL .And. cChave == SZ4->Z4_TIPO )
			aadd(aRecNo,RecNo())
			dbSelectArea("SZ4")
			dbSkip()
		EndDo
		
		nUsado := Len(aHeadP1)
		For nX := 1 To Len(aColsP1)
			lTravou := .F.
			If nX <= Len(aRecNo)
				dbSelectArea("SZ4")
				dbGoto(aRecNo[nX])
				RecLock("SZ4")
				lTravou := .T.
			EndIf
			If ( !aColsP1[nX][nUsado+1] )
				If !lTravou
					RecLock("SZ4",.T.)
				EndIf
				For nY := 1 to Len(aHeadP1)
					If aHeadP1[nY][10] <> "V"
						SZ4->(FieldPut(FieldPos(aHeadP1[nY][2]),aColsP1[nX][nY]))
					EndIf
				Next nY
				SZ4->Z4_FILIAL	:= cFilSZ4
				MsUnLock()
				lGravou := .T.
			Else
				If lTravou
					SZ4->(dbDelete())
				EndIf
			EndIf
			MsUnLock()
		Next nX
		
	Case nOpc == 5  //Exclusao
					
		dbSelectArea("SZ4")
		dbSetOrder(1)
		If DbSeek(cFilSZ4+cChave)
			While ( !Eof() .And. xFilial("SZ4") == SZ4->Z4_FILIAL .And. cChave == SZ4->Z4_TIPO )
				RecLock("SZ4", .F.)
				dbDelete()
				MsUnLock()
				dbSelectArea("SZ4")
				dbSkip()
			EndDo
		Endif
		SZ4->(FKCommit())
			
EndCase

Return(lRet)

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CarregaDados�Autor  � Eduardo Patriani � Data �  28/09/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Carrega dados da tabela especifica.                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function CarregaDados(aHeader1,aCols1,cAlias,cWhere,aOrder,aNoFields,nOpc)

Local cOrder := ""
Local cQuery := ""
Local nI,nX

//��������������Ŀ
//� Monta Query  �
//����������������
cQuery := "SELECT "+ cAlias +".* FROM "+ RetSQLName(cAlias) + " " + cAlias + " (NOLOCK) WHERE "
//���������������Ŀ
//� Filtra filial �
//�����������������
cQuery += cAlias+"."+"Z4_FILIAL = '"+xFilial(cAlias)+"' AND "
//�������������������������Ŀ
//� Verifica condicao Where �
//���������������������������
If !Empty(cWhere)
	cQuery += cWhere + " AND "
EndIf
//����������������������������Ŀ
//� Filtra refistros deletados �
//������������������������������
cQuery += cAlias+".D_E_L_E_T_ <> '*' "
//����������������������������Ŀ
//� Monta ordem dos registros  �
//������������������������������
If Len(aOrder) > 0
	For nX:=1 to len(aOrder)
		cOrder += aOrder[nX]+","
	next
	cQuery += "ORDER BY "+cAlias+"."+"R_E_C_N_O_"
EndIf
cQuery := ChangeQuery(cQuery)

//�������������������������Ŀ
//� Executa                 �
//���������������������������
FillGetDados(nOpc,cAlias,1,,,{|| .T. },aNoFields,,,cQuery,,,If(len(aHeader1)>0,NIL,aHeader1),aCols1)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CarregaItens�Autor  � Eduardo Patriani � Data �  14/01/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Carrega itens no aCols. 									  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function CarregaItens(aHeader1,aCols1)

Local nUsado 	:= 0
Local nCntFor

nUsado := Len(aHeader1)
AAdd(aCols1,Array(nUsado+1))

//�����������������������������������������������������Ŀ
//�Inicializa as variaveis da aCols (tratamento para    �
//�campos criados pelo usu�rio)							�
//�������������������������������������������������������
For nCntFor := 1 To nUsado
	If Alltrim(aHeader1[nCntFor][2])=="Z4_ORDEM"
		aCols1[Len(aCols1)][nCntFor] := "01"		
	ElseIf aHeader1[nCntFor][8] == "C"
		aCols1[Len(aCols1)][nCntFor] := Space(aHeader1[nCntFor][4])		
	ElseIf aHeader1[nCntFor][8] == "D"
		aCols1[Len(aCols1)][nCntFor] := dDatabase		
	ElseIf aHeader1[nCntFor][8] == "M"
		aCols1[Len(aCols1)][nCntFor] := ""		
	ElseIf aHeader1[nCntFor][8] == "N"
		aCols1[Len(aCols1)][nCntFor] := 0		
	Else
		aCols1[Len(aCols1)][nCntFor] := CriaVar(aHeader1[nCntFor,2])
	Endif
Next
aCols1[Len(aCols1)][nUsado+1] := .F.

Return

User Function A109VLD1()

Local lRet   	:= .T.
Local nPos 	 	:= oGetP1:nAt
Local nPosOrd	:= Ascan(aHeadP1,{|x|Alltrim(x[2])=="Z4_ORDEM"})
Local nPosCond	:= Ascan(aHeadP1,{|x|Alltrim(x[2])=="Z4_COND"})
Local nOrdem 	:= Val(oGetP1:aCols[n,nPosOrd])

If nOrdem > 1
	If M->Z4_COND < oGetP1:aCols[nPos-1,nPosCond]
		MsgStop("O valor informado n�o poder� ser menor que o valor do registro acima.","Aten��o")		
		lRet := .F.		
	Endif	
Endif

Return(lRet)