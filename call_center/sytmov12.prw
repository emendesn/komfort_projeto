#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "JPEG.CH"
#INCLUDE "Topconn.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "TbiCode.ch"
#INCLUDE "rwmake.ch"


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �a410Visual� Rev.  �Eduardo Riera          � Data �26.08.2001���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Visualizacao do Pedido de Venda                             ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpC1: Alias do cabecalho do pedido de venda                ���
���          �ExpN2: Recno do cabecalho do pedido de venda                ���
���          �ExpN3: Opcao do arotina                                     ���                                                                           	
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Esta rotina tem como objetivo efetuar a interface com o usua���
���          �rio e o pedido de vendas                                    ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Observacao�                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Materiais/Distribuicao/Logistica                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
USER FUNCTION SYTMOV12(nReg)

Local cAlias   := "SC5"
Local nOpc     := 2
Local aArea    := GetArea()
Local aCpos1   := {"C6_QTDVEN ","C6_QTDLIB"}
Local aCpos2   := {}  
Local aBackRot := aClone(aRotina)
Local aPosObj  := {}
Local aObjects := {}
Local aSize    := {}
Local aPosGet  := {}
Local aInfo    := {}

Local lContinua:= .T.
Local lGrade   := MaGrade()
Local lQuery   := .F.
Local lFreeze  := (SuperGetMv("MV_PEDFREZ",.F.,0) <> 0)

Local nGetLin  := 0
Local nOpcA    := 0
Local nTotPed  := 0
Local nTotDes  := 0
Local nCntFor  := 0
Local nNumDec  := TamSX3("C6_VALOR")[2]
Local nColFreeze:= SuperGetMv("MV_PEDFREZ",.F.,0)
Local nCont    := 0

Local cArqQry  := "SC6"
Local cCadastro:= IIF(Type('cCadastro') == 'U',OemToAnsi("STR0007"),cCadastro) //"Atualiza��o de Pedidos de Venda"
Local oGetd
Local oSAY1
Local oSAY2
Local oSAY3
Local oSAY4
Local oDlg
Local lMt410Ace:= Existblock("MT410ACE")

Local bCond     := {|| .T. }
Local bAction1  := {|| Mta410Vis(cArqQry,@nTotPed,@nTotDes,lGrade) }	
Local bAction2  := {|| .T. }
Local cSeek     := ""
Local aNoFields := {"C6_NUM","C6_QTDEMP","C6_QTDENT","C6_QTDEMP2","C6_QTDENT2"}		// Campos que nao devem entrar no aHeader e aCols
Local bWhile    := {|| }
Local cQuery    := ""
Local lGrdOk	:= If(lGrade.And.MatOrigGrd()=="SB4",VldDocGrd(1,SC5->C5_NUM),.T.)
Local aRecnoSE1RA
Local aHeadAGG    := {}
Local aColsAGG    := {}
Local cMemo       := ''
Local cCampo      := ''

//������������������������������������������������������Ŀ
//� Inicializa a Variaveis Privates.                     �
//��������������������������������������������������������
PRIVATE aTrocaF3  := {}
PRIVATE aTELA[0][0],aGETS[0]
PRIVATE aHeader	  := {}
PRIVATE aCols	  := {}
PRIVATE aHeadFor  := {}
PRIVATE aColsFor  := {}
PRIVATE N         := 1
PRIVATE aGEMCVnd  := {"",{},{}} //Template GEM - Condicao de Venda 
PRIVATE oGetPV	  := Nil        


//���������������������������������������������������Ŀ
//�Verifica se o campo de codigo de lancamento cat 83 �
//�deve estar visivel no acols                        �
//�����������������������������������������������������
If !SuperGetMV("MV_CAT8309",,.F.)
	aAdd(aNoFields,"C6_CODLAN")
EndIf

//���������������������������������������������������������������Ŀ
//� Agroindustria  									                 �
//�����������������������������������������������������������������
If FindFunction("OGXUtlOrig") //Encontra a fun��o
	If OGXUtlOrig()
		If (FindFunction("OGX220"))//Encontra a fun��o
			lContinua := OGX220()
		EndIf
	EndIf
EndIf

//���������������������������������������������������������������Ŀ
//� Agroindustria  									                 �
//�����������������������������������������������������������������
If FindFunction("OGXUtlOrig") //Encontra a fun��o
	If OGXUtlOrig()
	   If FindFunction("OGX225")//Encontra a fun��o
	      lContinua := OGX225()
	   EndIf
	EndIf
EndIf
//�����������������������������������������������������������Ŀ
//� Ponto de entrada para validar acesso do usuario na funcao �
//�������������������������������������������������������������
If lMt410Ace
	lContinua := Execblock("MT410ACE",.F.,.F.,{nOpc})
Endif

//������������������������������������������������������Ŀ
//� Cria Ambiente/Objeto para tratamento de grade        �
//��������������������������������������������������������        
If IsAtNewGrd()
		PRIVATE oGrade	  := MsMatGrade():New('oGrade',,"C6_QTDVEN",,"a410GValid()",;
							{ 	{VK_F4,{|| A440Saldo(.T.,oGrade:aColsAux[oGrade:nPosLinO][aScan(oGrade:aHeadAux,{|x| AllTrim(x[2])=="C6_LOCAL"})])}} },;
	  						{ 	{"C6_QTDVEN",.T., {{"C6_UNSVEN",{|| ConvUm(AllTrim(oGrade:GetNameProd(,nLinha,nColuna)),aCols[nLinha][nColuna],0,2) } }} },;
	  							{"C6_QTDLIB",NIL,NIL},;
	  							{"C6_QTDENT",NIL,NIL},;
	  							{"C6_ITEM"	,NIL,NIL},;                                                                                                                             	
	  							{"C6_UNSVEN",NIL, {{"C6_QTDVEN",{|| ConvUm(AllTrim(oGrade:GetNameProd(,nLinha,nColuna)),0,aCols[nLinha][nColuna],1) }}} },;
	  							{"C6_OPC",NIL,NIL},;
								{"C6_NUMOP",NIL,NIL},;
								{"C6_ITEMOP",NIL,NIL},;
	  							{"C6_BLQ",NIL,NIL}})	
	//-- Inicializa grade multicampo
	A410InGrdM()
Else
	PRIVATE aColsGrade:= {}
	PRIVATE aHeadGrade:= {}
EndIf

If Type("Inclui") == "U"
	Inclui := .F.
	Altera := .F.
EndIf
Pergunte("MTA410",.F.) 
//Carrega as variaveis com os parametros da execauto
Ma410PerAut()

//If ( lGrade )
	//aRotina[nOpc][4] := 6
//EndIf

If lGrdOk
	//������������������������������������������������������Ŀ
	//� Inicializa a Variaveis da Enchoice.                  �
	//��������������������������������������������������������
	RegToMemory( "SC5", .F., .F. )
	
	//������������������������������������������������������Ŀ
	//� Filtros para montagem do aCols                       �
	//��������������������������������������������������������
	dbSelectArea("SC6")
	dbSetOrder(1)
	#IFDEF TOP
		lQuery  := .T.
		cQuery := "SELECT * "
		cQuery += "FROM "+RetSqlName("SC6")+" SC6 "
		cQuery += "WHERE SC6.C6_FILIAL='"+xFilial("SC6")+"' AND "
		cQuery += "SC6.C6_NUM='"+SC5->C5_NUM+"' AND "
		cQuery += "SC6.D_E_L_E_T_<>'*' "
		cQuery += "ORDER BY "+SqlOrder(SC6->(IndexKey()))
	
		dbSelectArea("SC6")
		dbCloseArea()
	#ENDIF
	cSeek  := xFilial("SC6")+SC5->C5_NUM
	bWhile := {|| C6_FILIAL+C6_NUM }
	
	//�������������������������������������������������������Ŀ
	//� Montagem do aHeader e aCols                           �
	//���������������������������������������������������������
	//������������������������������������������������������������������������������������������������������������Ŀ
	//�FillGetDados( nOpcx, cAlias, nOrder, cSeekKey, bSeekWhile, uSeekFor, aNoFields, aYesFields, lOnlyYes,       �
	//�				  cQuery, bMountFile, lInclui )                                                                �
	//�nOpcx			- Opcao (inclusao, exclusao, etc).                                                         �
	//�cAlias		- Alias da tabela referente aos itens                                                          �
	//�nOrder		- Ordem do SINDEX                                                                              �
	//�cSeekKey		- Chave de pesquisa                                                                            �
	//�bSeekWhile	- Loop na tabela cAlias                                                                        �
	//�uSeekFor		- Valida cada registro da tabela cAlias (retornar .T. para considerar e .F. para desconsiderar �
	//�				  o registro)                                                                                  �
	//�aNoFields	- Array com nome dos campos que serao excluidos na montagem do aHeader                         �
	//�aYesFields	- Array com nome dos campos que serao incluidos na montagem do aHeader                         �
	//�lOnlyYes		- Flag indicando se considera somente os campos declarados no aYesFields + campos do usuario   �
	//�cQuery		- Query para filtro da tabela cAlias (se for TOP e cQuery estiver preenchido, desconsidera     �
	//�	           parametros cSeekKey e bSeekWhiele)                                                              �
	//�bMountFile	- Preenchimento do aCols pelo usuario (aHeader e aCols ja estarao criados)                     �
	//�lInclui		- Se inclusao passar .T. para qua aCols seja incializada com 1 linha em branco                 �
	//�aHeaderAux	-                                                                                              �
	//�aColsAux		-                                                                                              �
	//�bAfterCols	- Bloco executado apos inclusao de cada linha no aCols                                         �
	//�bBeforeCols	- Bloco executado antes da inclusao de cada linha no aCols                                     �
	//�bAfterHeader -                                                                                              �
	//�cAliasQry	- Alias para a Query                                                                           �
	//��������������������������������������������������������������������������������������������������������������
	FillGetDados(nOPc,"SC6",1,cSeek,bWhile,{{bCond,bAction1,bAction2}},aNoFields,/*aYesFields*/,/*lOnlyYes*/,cQuery,/*bMontCols*/,.F.,/*aHeaderAux*/,/*aColsAux*/,{|| AfterCols(cArqQry) },/*bBeforeCols*/,/*bAfterHeader*/,"SC6")
	
	If"MATA410" $ SuperGetMV("MV_GRDMULT",.F.,"") .And. lGrade
		aCols := aColsGrade(oGrade,aCols,aHeader,"C6_PRODUTO","C6_ITEM","C6_ITEMGRD",aScan(aHeader,{|x| AllTrim(x[2]) == "C6_DESCRI"}))
	EndIf

	A410FRat(@aHeadAGG,@aColsAGG)	
	
	If lQuery
		dbSelectArea("SC6")
		dbCloseArea()
		ChkFile("SC6",.F.)
	EndIf
	
	
	For nCntFor := 1 To Len(aHeader)
		If aHeader[nCntFor][8] == "M"
			aAdd(aCpos1,aHeader[nCntFor][2])
		EndIf
	Next nCntFor

	nTotDes  += A410Arred(nTotPed*M->C5_PDESCAB/100,"C6_VALOR")
	nTotPed  -= A410Arred(nTotPed*M->C5_PDESCAB/100,"C6_VALOR")	
	nTotPed  -= M->C5_DESCONT
	nTotDes  += M->C5_DESCONT

	If ( lQuery )
		dbSelectArea(cArqQry)
		dbCloseArea()
		ChkFile("SC6",.F.)
		dbSelectArea("SC6")
	EndIf
	//�����������������������������������������������Ŀ
	//�Monta o array com as formas de pagamento       �
	//�������������������������������������������������
	Ma410MtFor(@aHeadFor,@aColsFor)
	//������������������������������������������������������Ŀ
	//� Caso nao ache nenhum item , abandona rotina.         �
	//��������������������������������������������������������
	If ( Len(aCols) == 0 )
		Help(" ",1,"A410SEMREG")
		lContinua := .F.
	EndIf
	//�������������������������������������������������������Ŀ
	//� Ponto de Entrada para visualizao do pedido de vendas  �
	//���������������������������������������������������������
	
	If ExistBlock("M410VIS")
		ExecBlock("M410VIS",.F.,.F.)
	EndIf
	
	If ( lContinua )
		//������������������������������������������������������Ŀ
		//� Faz o calculo automatico de dimensoes de objetos     �
		//��������������������������������������������������������
		aSize := MsAdvSize()
		aObjects := {}
		aAdd( aObjects, { 100, 100, .t., .t. } )
		aAdd( aObjects, { 100, 100, .t., .t. } )
		aAdd( aObjects, { 100, 020, .t., .f. } )
	
		aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
		aPosObj := MsObjSize( aInfo, aObjects )
	
		aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,;
			{{003,033,160,200,240,263}} )
	
		DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL STYLE nOr(WS_VISIBLE,WS_POPUP)
		//������������������������������������������������������������������������Ŀ
		//� Estabelece a Troca de Clientes conforme o Tipo do Pedido de Venda      �
		//��������������������������������������������������������������������������
		If ( M->C5_TIPO $ "DB" )
			aTrocaF3 := {{"C5_CLIENTE","SA2"}}
		Else
			aTrocaF3 := {}
		EndIf
		oGetPV:=MSMGet():New( cAlias, nReg, nOpc, , , , , aPosObj[1],aCpos2,3,,,"A415VldTOk")
		nGetLin := aPosObj[3,1]
		@ nGetLin,aPosGet[1,2]  SAY oSAY1 VAR Space(40)						    SIZE 120,09 PICTURE "@!" OF oDlg PIXEL
		@ nGetLin,aPosGet[1,3]  SAY OemToAnsi("Total : ")						SIZE 020,09 OF oDlg PIXEL	//"Total :"
		@ nGetLin,aPosGet[1,4]  SAY oSAY2 VAR 0 PICTURE TM(0,22,Iif(cPaisloc=="CHI" .And. M->C5_MOEDA == 1,NIL,nNumDec))		SIZE 060,09 OF oDlg	PIXEL
		@ nGetLin,aPosGet[1,5]  SAY OemToAnsi("Desc. :")						SIZE 030,09 OF oDlg PIXEL	//"Desc. :"
		@ nGetLin,aPosGet[1,6]  SAY oSAY3 VAR 0 PICTURE TM(0,22,Iif(cPaisloc=="CHI" .And. M->C5_MOEDA == 1,NIL,nNumDec))		SIZE 060,09 OF oDlg	PIXEL RIGHT
		@ nGetLin+10,aPosGet[1,5] SAY OemToAnsi("=")							SIZE 020,09 OF oDlg PIXEL
		@ nGetLin+10,aPosGet[1,6] SAY oSAY4 VAR 0								SIZE 060,09 PICTURE TM(0,22,Iif(cPaisloc=="CHI" .And. M->C5_MOEDA == 1,NIL,nNumDec)) OF oDlg PIXEL RIGHT
		oDlg:Cargo	:= {|c1,n2,n3,n4| oSay1:SetText(c1),;
			oSay2:SetText(n2),;
			oSay3:SetText(n3),;
			oSay4:SetText(n4) }
		oGetd   := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,,,"",,aCpos1,nColFreeze,,,"A410FldOk(1)",,,,,lFreeze)	
		//���������������������������������������������������������������������������������������Ŀ
		//�Desabilitar os gets de cliente e loja de entrega na visualiza��o para quando utilizado �
		//�pedidos do tipo D ou B pois � utilizado fornecedores		                                 �
		//�����������������������������������������������������������������������������������������
		If SC5->C5_TIPO $ "D|B"
			nPosCliEnt := AsCan(oGetPV:aENTRYCTRLS,{|x| UPPER(TRIM(x:cReadVar))=="SC5->C5_CLIENT"})
			nPosLojEnt := AsCan(oGetPV:aENTRYCTRLS,{|x| UPPER(TRIM(x:cReadVar))=="SC5->C5_LOJAENT"})
		 	If nPosCliEnt > 0 .And. nPosLojEnt > 0
				oGetPV:AENTRYCTRLS[nPosCliEnt]:LACTIVE := .F.
				oGetPV:AENTRYCTRLS[nPosLojEnt]:LACTIVE := .F.
			EndIf	
		EndIf
	   
	   	A410Bonus(2)
		Ma410Rodap(oGetd,nTotPed,nTotDes)
		ACTIVATE MSDIALOG oDlg ON INIT (A410Limpa(.F.,M->C5_TIPO),Ma410Bar(oDlg,{||nOpcA:=1,oDlg:End()},{||oDlg:End()},nOpc,oGetD,nTotPed,@aRecnoSE1RA,@aHeadAGG,@aColsAGG))
	EndIf

EndIf	

aRotina := aClone(aBackRot)
RestArea(aArea)

Return( nOpcA )