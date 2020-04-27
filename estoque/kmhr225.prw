#INCLUDE "MATR225.CH"
#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR225  � Autor � Marcos V. Ferreira    � Data � 08/09/92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao simplificada das estruturas                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR225			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function KMHR225()

Local oReport
Private nOpNum:=''

If TRepInUse()
	//������������������������������������������������������������������������Ŀ
	//�Interface de impressao                                                  �
	//��������������������������������������������������������������������������
	oReport:= ReportDef()
	oReport:PrintDialog()
Else
	U_KMH225R3()
EndIf

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor � Marcos V. Ferreira    � Data �16.05.2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR225			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef()
Local oReport
Local oSection1
Local oSection2
Local oSection3
//������������������������������������������������������������������������Ŀ
//�Criacao do componente de impressao                                      �
//�                                                                        �
//�TReport():New                                                           �
//�ExpC1 : Nome do relatorio                                               �
//�ExpC2 : Titulo                                                          �
//�ExpC3 : Pergunte                                                        �
//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
//�ExpC5 : Descricao                                                       �
//�                                                                        �
//��������������������������������������������������������������������������
oReport:= TReport():New("KMHR225",OemToAnsi(STR0001),"KHR225", {|oReport| ReportPrint(oReport)},OemToAnsi(STR0002)+" "+OemToAnsi(STR0003)+" "+OemToAnsi(STR0004))  //"Este programa emite a relacao de estrutura de um determinado produto"##"selecionado pelo usuario. Esta relacao nao demonstra custos. Caso o"##"produto use opcionais, sera listada a estrutura com os opcionais padrao."
oReport:SetLandscape()

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
//��������������������������������������Ŀ
//� Variaveis utilizadas para parametros �
//� mv_par01   // Produto de             �
//� mv_par02   // Produto ate            �
//� mv_par03   // Tipo de                �
//� mv_par04   // Tipo ate               �
//� mv_par05   // Grupo de               �
//� mv_par06   // Grupo ate              �
//� mv_par07   // Salta Pagina: Sim/Nao  �
//� mv_par08   // Qual Rev da Estrut     �
//� mv_par09   // Imprime Ate Nivel ?    �
//����������������������������������������
Pergunte(oReport:uParam,.F.)

//������������������������������������������������������������������������Ŀ
//�Criacao da secao utilizada pelo relatorio                               �
//�                                                                        �
//�TRSection():New                                                         �
//�ExpO1 : Objeto TReport que a secao pertence                             �
//�ExpC2 : Descricao da se�ao                                              �
//�ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   �
//�        sera considerada como principal para a secao.                   �
//�ExpA4 : Array com as Ordens do relatorio                                �
//�ExpL5 : Carrega campos do SX3 como celulas                              �
//�        Default : False                                                 �
//�ExpL6 : Carrega ordens do Sindex                                        �
//�        Default : False                                                 �
//��������������������������������������������������������������������������

//��������������������������������������������������������������Ŀ
//� Sessao 1                                                     �
//����������������������������������������������������������������
oSection1 := TRSection():New(oReport,STR0036,{"SG1","SB1"}) //"Detalhes do produto Pai"
oSection1:SetLineStyle()

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SB1")
While !Eof() .And. (x3_arquivo == "SB1")
	If X3_CAMPO == 'B1_COD    '
		nB1_cod = SX3->X3_TAMANHO
		nB1_cod = nB1_cod + 1
	EndIf
	
	If X3_CAMPO == 'B1_DESC   '
		nB1_desc = SX3->X3_TAMANHO
		nB1_desc = nB1_desc + 1
	EndIf
	
	If X3_CAMPO == 'B1_TIPO   '
		nB1_tipo = SX3->X3_TAMANHO
		nB1_tipo = nB1_tipo + 1
	EndIf
	
	If X3_CAMPO == 'B1_GRUPO  '
		nB1_grupo = SX3->X3_TAMANHO
		nB1_grupo = nB1_grupo + 1
	EndIf
	
	If X3_CAMPO == 'B1_UM     '
		nB1_um = SX3->X3_TAMANHO
		nB1_um = nB1_um + 1
	EndIf
	
	If X3_CAMPO == 'B1_QB     '
		nB1_qb = SX3->X3_TAMANHO
		nB1_qb = nB1_qb + 1
	EndIf
	
	If X3_CAMPO == 'B1_OPC    '
		nB1_opc = SX3->X3_TAMANHO
		nB1_opc = nB1_opc + 1
	EndIf
	
	dbSkip()
End

TRCell():New(oSection1,'G1_COD'	    ,'SG1',/*Titulo*/,/*Picture*/,nB1_cod,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B1_DESC'   	,'SB1',/*Titulo*/,/*Picture*/,nB1_desc,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B1_TIPO'   	,'SB1',/*Titulo*/,/*Picture*/,nB1_tipo,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection1,'MV_PAR03'   	,'SB1',"ORDEM PROD",/*Picture*/,nB1_tipo,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection1,'B1_GRUPO'  	,'SB1',/*Titulo*/,/*Picture*/,nB1_grupo,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B1_UM'	    ,'SB1',/*Titulo*/,/*Picture*/,nB1_um,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection1,'B1_QB'		,'SB1',/*Titulo*/,/*Picture*/,nB1_qb,/*lPixel*/, {|| IIf(RetFldProd(SB1->B1_COD,"B1_QB")==0,1,RetFldProd(SB1->B1_COD,"B1_QB"))})
//TRCell():New(oSection1,'B1_OPC'		,'SB1',/*Titulo*/,/*Picture*/,nB1_opc,/*lPixel*/, {|| RetFldProd(SB1->B1_COD,"B1_OPC")})

oSection1:SetNoFilter("SB1")
//��������������������������������������������������������������Ŀ
//� Sessao 2                                                     �
//����������������������������������������������������������������
oSection2 := TRSection():New(oSection1,STR0037,{'SG1','SB1'}) // "Estruturas"

TRCell():New(oSection2,'NIVEL'		,'   ',STR0019	,/*Picture*/					,10			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'G1_COMP'	,'SG1',STR0020	,/*Picture*/					,nB1_cod,/*lPixel*/,/*{|| code-block de impressao }*/) //B1_COD deve ter o mesmo tamanho que G1_COMP, por isso usei a vari�vel que j� tinha a informa��o na mem�ria, sem realizar a busca novamente na tabela
TRCell():New(oSection2,'G1_TRT'		,'SG1',STR0021	,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'B1_TIPO'	,'SB1',STR0022	,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'B1_GRUPO'	,'SB1',STR0023	,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
If nB1_desc > 30
  TRCell():New(oSection2,'B1_DESC'	,'SB1',STR0024 + " ORDEM NUMER." + MV_PAR03	,/*Picture*/					,30,/*lPixel*/,/*{|| code-block de impressao }*/)
Else
	TRCell():New(oSection2,'B1_DESC'	,'SB1',STR0024 + " ORDEM NUMER." + MV_PAR03	,/*Picture*/					,nB1_desc,/*lPixel*/,/*{|| code-block de impressao }*/)
EndIf

//TRCell():New(oSection2,'G1_OBSERV'	,'SG1',STR0025	,/*Picture*/					,25			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'QUANTITEM'	,'   ',STR0026	,PesqPict('SG1','G1_QUANT',14)	,14	   		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'B1_UM'		,'SB1',STR0027	,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection2,'G1_PERDA'	,'SG1',STR0028	,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection2,'G1_QUANT'	,'SG1',STR0029	,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection2,'B1_QB'		,'SB1',STR0030	,/*Picture*/					,/*Tamanho*/,/*lPixel*/,{||If(RetFldProd(SB1->B1_COD,"B1_QB")==0,1,RetFldProd(SB1->B1_COD,"B1_QB"))})
//TRCell():New(oSection2,'G1_FIXVAR'	,'SG1',STR0031	,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection2,'G1_INI'		,'SG1',STR0032	,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection2,'G1_FIM'		,'SG1',STR0033	,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection2,'G1_GROPC'	,'SG1',STR0034	,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection2,'G1_OPC'		,'SG1',STR0035	,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

oSection2:SetHeaderPage()
oSection2:SetNoFilter("SB1")

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrint � Autor �Marcos V. Ferreira   � Data �16.05.2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportPrint devera ser criada para todos  ���
���          �os relatorios que poderao ser agendados pelo usuario.       ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relatorio                           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR225			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(1):Section(1)
Local cProduto 	:= ""
Local nNivel   	:= 0
Local lContinua := .T.
Local cQuery:=""
Local cAlias:=GetNextAlias()
Private lNegEstr:=GETMV("MV_NEGESTR")
Private nQtdOp:=0
Private cPrdOP:=""



cQuery := "SELECT SC2.C2_PRODUTO PRODUTO, (SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN) SC2NUM, SC2.C2_QUANT SC2QUANT"
cQuery += "FROM "+RetSqlName("SC2")+" SC2 "
cQuery += "WHERE "
cQuery += "SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN = '"+MV_PAR03+"' AND SC2.C2_PRODUTO >='"+MV_PAR01+"' AND SC2.C2_PRODUTO <='"+MV_PAR02+"' AND "
cQuery += "SC2.D_E_L_E_T_='' "

cQuery    := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

//Verifica se existe alguma nota de retira vinculada a carga
dbselectarea(cAlias)

If Empty((cAlias)->SC2QUANT)
nQtdOp:=MV_PAR04
cPrdOP:=MV_PAR01
Else
nQtdOp:=(cAlias)->SC2QUANT
cPrdOP:=(cAlias)->PRODUTO
Endif
nOpNum:=MV_PAR03

//��������������������������������������������������������������Ŀ
//�	Processando a Sessao 1                                       �
//����������������������������������������������������������������
dbSelectArea('SG1')
dbSetOrder(1)
MsSeek(xFilial('SG1')+mv_par01,.T.)
oReport:SetMeter(SG1->(LastRec()))
oSection1:Init(.F.)

While !oReport:Cancel() .And. !Eof() .And. SG1->G1_FILIAL+SG1->G1_COD <= xFilial('SG1')+mv_par02
	
	oReport:IncMeter()
	
	cProduto := SG1->G1_COD
	nNivel   := 2
	lContinua:=.T.
	
	dbSelectArea('SB1')
	MsSeek(xFilial('SB1')+cProduto)

	If lContinua
		
		oSection1:Init(.F.)
		oReport:SkipLine()
		
		//--  Imprime grupo de opcionais.
	  //	If !Empty(RetFldProd(SB1->B1_COD,"B1_OPC"))
		//	oSection1:Cell('B1_OPC'):Show()
		//Else
		//	oSection1:Cell('B1_OPC'):Hide()
		//EndIf
		
		oSection1:PrintLine()
		oReport:SkipLine()
		oSection1:Finish()
		
		oSection2:Init()
		
		//-- Explode Estrutura
		MR225ExplG(oReport,oSection2,cProduto,nQtdOp,nNivel,RetFldProd(SB1->B1_COD,"B1_OPC"),nQtdOp)
		
		oSection2:Finish()
		
		oReport:ThinLine() //-- Impressao de Linha Simples
	
	EndIf
	dbSelectArea("SG1")
EndDo

//-- Devolve a condicao original do arquivo principal
dbSelectArea("SG1")
Set Filter To
dbSetOrder(1)
Return

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   �MR225ExplG� Autor � Marcos V. Ferreira    � Data � 17/05/06 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Faz a explosao de uma estrutura                            ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  � MR225Expl(ExpO1,ExpO2,ExpC3,ExpN4,ExpN5,ExpC6,ExpN7,ExpC8) ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpO1 = Objeto do Relatorio                                ���
���          � ExpO2 = Sessao a ser impressa                              ���
���          � ExpC3 = Codigo do produto a ser explodido                  ���
���          � ExpN4 = Quantidade do pai a ser explodida                  ���
���          � ExpN5 = Nivel a ser impresso                               ���
���          � ExpC6 = Opcionais do produto                               ���
���          � ExpN7 = Quantidade do Produto Nivel Anterior               ���
���          � ExpC8 = nQtdOpNumero da Revisao                                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
Static Function MR225ExplG(oReport,oSection2,cProduto,nQtdOp,nNivel,cOpcionais,nQuantPai,cRevisao)
Local nReg 		  := 0
Local nQuantItem  := 0
Local nPrintNivel := 0
Local cAteNiv     := "006"

dbSelectArea('SG1')
While !oReport:Cancel() .And. !Eof() .And. G1_FILIAL+G1_COD == xFilial('SG1')+cProduto
	oSection2:IncMeter()
	nReg       := Recno()
	nQuantItem := ExplEstr(nQuantPai,,cOpcionais,cRevisao)
	dbSelectArea('SG1')
	
	If nNivel <= Val(cAteNiv) // Verifica ate qual Nivel devera ser impresso
		If (lNegEstr .Or. (!lNegEstr .And. QtdComp(nQuantItem,.T.) > QtdComp(0) )) .And. (QtdComp(nQuantItem,.T.) # QtdComp(0,.T.))
			
			dbSelectArea('SB1')
			dbSetOrder(1)
			MsSeek(xFilial('SB1')+SG1->G1_COMP)
			
			//�������������������������������������������������Ŀ
			//� Impressao da Sessao 2			                �
			//���������������������������������������������������
			nPrintNivel:=IIf(nNivel>17,17,nNivel-2)
			oSection2:Cell('NIVEL'		):SetValue(Space(nPrintNivel)+StrZero(nNivel,3))
			oSection2:Cell('QUANTITEM'	):SetValue(nQuantItem)
			oSection2:PrintLine()
			
			//�������������������������������������������������Ŀ
			//� Verifica se existe sub-estrutura                �
			//���������������������������������������������������
			dbSelectArea('SG1')
			MsSeek(xFilial('SG1')+G1_COMP)
			If Found()
				MR225ExplG(oReport,oSection2,G1_COD,nQuantItem,nNivel+1,cOpcionais,nQuantPai)
			EndIf
			
			dbGoto(nReg)
			
		EndIf
	EndIf
	
	dbSkip()
EndDo

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR225R3� Autor � Marcos V. Ferreira    � Data � 08/09/92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao simplificada das estruturas - Release 3            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR225			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function KMH225R3

//��������������������������������������������������������������Ŀ
//� Variaveis obrigatorias dos programas de relatorio            �
//����������������������������������������������������������������
LOCAL Tamanho  := "G"
LOCAL titulo   := STR0001 + "Ordem de Prod." + nOpNum	//"Relacao Simplificada das Estruturas"
LOCAL cDesc1   := STR0002	//"Este programa emite a rela��o de estrutura de um determinado produto"
LOCAL cDesc2   := STR0003	//"selecionado pelo usu�rio. Esta rela��o n�o demonstra custos. Caso o"
LOCAL cDesc3   := STR0004	//"produto use opcionais, ser� listada a estrutura com os opcionais padr�o."
LOCAL cString  := "SG1"
LOCAL wnrel	   := "KHR225" 
PRIVATE lNegEstr:=GETMV("MV_NEGESTR")
PRIVATE aReturn := {OemToAnsi(STR0005), 1,OemToAnsi(STR0006), 2, 2, 1, "",1 }		//"Zebrado"###"Administracao"
PRIVATE nLastKey:= 0 ,cPerg := "KHR225"
Pergunte(cPerg,.F.)

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey = 27
	Set Filter to
	Return
EndIf

SetDefault(aReturn,cString)

If nLastKey = 27
	Set Filter to
	Return
EndIf

RptStatus({|lEnd| C225Imp(@lEnd,wnRel,titulo,Tamanho)},titulo)

Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � C225IMP  � Autor � Rodrigo de A. Sartorio� Data � 11.12.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR225			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function C225Imp(lEnd,WnRel,titulo,Tamanho)

LOCAL cRodaTxt  := STR0007	//"ESTRUTURA(S)"
LOCAL nCntImpr  := 0
LOCAL nTipo     := 0
LOCAL cProduto  := ""
LOCAL nNivel    := 0
LOCAL cPictQuant:=""
LOCAL cPictPerda:=""
LOCAL nX        := 0
LOCAL nPosCnt	:= 0
LOCAL nPosOld	:= 0
LOCAL i 		:= 0
LOCAL nEstouro
LOCAL nLen
LOCAL nCol      :=0
LOCAL aAreaSG1 := {}
PRIVATE li := 80 ,m_pag := 1

nTipo  := IIf(aReturn[4]==1,15,18)

cabec1   := STR0008	//"NIVEL                CODIGO          TRT TP GRUP DESCRICAO                          OBSERVACAO                                        QUANTIDADE UM PERDA     QUANTIDADE QTD. BASE  TIPO DE     INICIO      FIM    GRP. ITEM"
cabec2   := STR0009	//"                                                                                                                                      NECESSARIA      %                  ESTRUTURA QUANTIDADE  VALIDADE   VALIDADE OPCI  OPCI"
//                      99999999999999999999 999999999999999 999 99 9999 9999999999999999999999999999999999 XXXXXXXXX1XXXXXXXXX2XXXXXXXXX3XXXXXXXXX4XXXXX 9999999.999999 XX 99.99 9999999.999999   9999999  XXXXXXXX  99/99/9999 99/99/9999 XXX  XXXX
//                      0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
//                      01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

//��������������������������������������������������������������Ŀ
//� Pega a Picture da quantidade (maximo de 14 posicoes)         �
//����������������������������������������������������������������
dbSelectArea("SX3")
dbSetOrder(2)
dbSeek("G1_QUANT")
If X3_TAMANHO >= 14
	For nX := 1 To 14
		If (nX == X3_TAMANHO - X3_DECIMAL) .And. X3_DECIMAL > 0
			cPictQuant := cPictQuant+"."
		Else
			cPictQuant := cPictQuant+"9"
		EndIf
	Next nX
Else
	For nX := 1 To 14
		If (nX == (X3_DECIMAL + 1)) .And. X3_DECIMAL > 0
			cPictQuant := "."+cPictQuant
		Else
			cPictQuant := "9"+cPictQuant
		EndIf
	Next nX
EndIf
dbSeek("G1_PERDA")
If X3_TAMANHO >= 6
	For nX := 1 To 6
		If (nX == X3_TAMANHO - X3_DECIMAL) .And. X3_DECIMAL > 0
			cPictPerda := cPictPerda+"."
		Else
			cPictPerda := cPictPerda+"9"
		EndIf
	Next nX
Else
	For nX := 1 To 6
		If (nX == (X3_DECIMAL + 1)) .And. X3_DECIMAL > 0
			cPictPerda := "."+cPictPerda
		Else
			cPictPerda := "9"+cPictPerda
		EndIf
	Next nX
EndIf
dbSetOrder(1)
dbSelectArea("SG1")
SetRegua(LastRec())
Set SoftSeek On
dbSeek(xFilial("SG1")+mv_par01)
Set SoftSeek Off
While !Eof() .And. G1_FILIAL+G1_COD <= xFilial("SG1")+mv_par02
	If lEnd
		@ PROW()+1,001 PSAY STR0010	//"CANCELADO PELO OPERADOR"
		Exit
	EndIf
	IncRegua()
	cProduto := G1_COD
	nNivel   := 2
	dbSelectArea("SB1")
	
	aAreaSG1:=GetArea("SG1")
	
	dbSeek(xFilial("SB1")+cProduto)
	While cProduto == SG1->G1_COD
		SG1->(dbSkip())
		IncRegua()
	EndDo
	Loop
	
	dbSelectArea("SB1")

	If li > 58
		Cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
	EndIf
	//�������������������������������������������������������Ŀ
	//� Adiciona 1 ao contador de registros impressos         �
	//���������������������������������������������������������
	//nCntImpr++
	dbSelectArea("SB1")
	
	nEstouro := .F.
	
	nLen := LEN(RTRIM(cProduto))
	
	if nLen > 15
		nEstouro := .T.
	endif
	
	@ li,004 PSAY cProduto 
	
	nCol := 0
	if nEstouro
		@ li,036 PSAY '-'
		@ li,038 PSAY SubStr(SB1->B1_DESC,1,34)
		if Len(RTrim(SB1->B1_DESC)) > 34
			@ li, 038 PSay SubStr(SB1->B1_DESC,35,34)
		EndIf
	else
		nCol := 1
	endif
	
	@ li,024 + nCol PSAY SB1->B1_TIPO
	@ li,027 + nCol PSAY SB1->B1_GRUPO
	
	if !nEstouro
		@ li,032 + nCol PSAY SubStr(SB1->B1_DESC,1,34)
		if Len(RTrim(SB1->B1_DESC)) > 34
			@ li, 032 PSay SubStr(SB1->B1_DESC,35,34)
		EndIf
	endif
	
	@ li,105 + nCol PSAY SB1->B1_UM
	@ li,129 + nCol PSAY If(RetFldProd(SB1->B1_COD,"B1_QB")==0,1,RetFldProd(SB1->B1_COD,"B1_QB")) Picture PesqPict("SB1","B1_QB",11)
	//�������������������������������������������������������Ŀ
	//� Imprime grupo de opcionais.                           �
	//���������������������������������������������������������
	If !Empty(RetFldProd(SB1->B1_COD,"B1_OPC"))
		@ li,137 + nCol PSAY "Opc. "
		@ li,142 + nCol PSAY RetFldProd(SB1->B1_COD,"B1_OPC") Picture PesqPict("SB1","B1_OPC",80)
	EndIf
	//Li += 2
	nPosOld:=nPosCnt
	nPosCnt+=MR225Expl(cProduto,nQuantPai,nNivel,cPictQuant,cPictPerda,RetFldProd(SB1->B1_COD,"B1_OPC"),nQuantPai,titulo,cabec1,cabec2,wnrel,Tamanho,nTipo,If(Empty(mv_par08),SB1->B1_REVATU,mv_par08))
	For i:=nPosOld to nPosCnt
		IncRegua()
	Next I
	
	//-- Verifica se salta ou nao pagina
  	@ li,000 PSAY __PrtThinLine()
	//Li +=2
	dbSelectArea("SG1")
EndDo
If li != 80
	Roda(nCntImpr,cRodaTxt,Tamanho)
EndIf

//��������������������������������������������������������������Ŀ
//� Devolve a condicao original do arquivo principal             �
//����������������������������������������������������������������
dbSelectArea("SG1")
Set Filter To
dbSetOrder(1)

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
EndIf
MS_FLUSH()

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   �MR225Expl � Autor � Eveli Morasco         � Data � 08/09/92 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Faz a explosao de uma estrutura                            ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  � MR225Expl(ExpC1,ExpN1,ExpN2,ExpC2,ExpC3,ExpC4,ExpN3)       ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Codigo do produto a ser explodido                  ���
���          � ExpN1 = Quantidade do pai a ser explodida                  ���
���          � ExpN2 = Nivel a ser impresso                               ���
���          � ExpC2 = Picture da quantidade                              ���
���          � ExpC3 = Picture da perda                                   ���
���          � ExpC4 = Opcionais do produto                               ���
���          � ExpN3 = Quantidade do Produto Nivel Anterior               ���
���          � As outras 6 variaveis sao utilizadas pela funcao Cabec     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
Static Function MR225Expl(cProduto,nQuantPai,nNivel,cPictQuant,cPictPerda,cOpcionais,nQtdOp,Titulo,cabec1,cabec2,wnrel,Tamanho,nTipo,cRevisao)
LOCAL nReg,nQuantItem,nCntItens := 0
LOCAL nPrintNivel
LOCAL nX        := 0
LOCAL aObserv   := {}
LOCAL aAreaSB1:={}
LOCAL cAteNiv   := If(mv_par09=Space(3),"999",mv_par09)
LOCAL nEstouro
LOCAL nLen
LOCAL cComp
LOCAL nCol := 0

dbSelectArea("SG1")
While !Eof() .And. G1_FILIAL+G1_COD == xFilial("SG1")+cProduto
	nReg       := Recno()
	nQuantItem := ExplEstr(nQuantPai,,cOpcionais,cRevisao)
	dbSelectArea("SG1")
	If nNivel <= Val(cAteNiv) // Verifica ate qual Nivel devera ser impresso
		If (lNegEstr .Or. (!lNegEstr .And. QtdComp(nQuantItem,.T.) > QtdComp(0) )) .And. (QtdComp(nQuantItem,.T.) # QtdComp(0,.T.))
			If li > 58
				Cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
				dbSelectArea("SB1")
				aAreaSB1:=GetArea()
				dbSeek(xFilial("SB1")+cProduto)
				
				nEstouro := .F.
				
				nLen := LEN(RTRIM(cProduto))
				
				if nLen > 15
					nEstouro := .T.
				endif
				
				@ li,004 PSAY cProduto
				
				if nEstouro
					@ li,036 PSAY '-'
					@ li,038 PSAY SubStr(SB1->B1_DESC,1,34)
					li++
					if Len(RTrim(SB1->B1_DESC)) > 34
						@ li, 038 PSay SubStr(SB1->B1_DESC,35,34)
					EndIf
				else
					nCol := 1
				endif
				
				@ li,024 + nCol PSAY SB1->B1_TIPO
				@ li,027 + nCol PSAY SB1->B1_GRUPO
				
				if !nEstouro
					@ li,032 + nCol PSAY SubStr(SB1->B1_DESC,1,34)
					if Len(RTrim(SB1->B1_DESC)) > 34
						@ li, 032 PSay SubStr(SB1->B1_DESC,35,34)
					EndIf
				endif
				
				@ li,105 + nCol PSAY SB1->B1_UM
				//�������������������������������������������������������Ŀ
				//� Imprime grupo de opcionais.                           �
				//���������������������������������������������������������
				If !Empty(RetFldProd(SB1->B1_COD,"B1_OPC"))
					@ li,137 + nCol PSAY "Opc. "
					@ li,142 + nCol PSAY RetFldProd(SB1->B1_COD,"B1_OPC") Picture PesqPict("SB1","B1_OPC",80)
				EndIf
				RestArea(aAreaSB1)
				Li += 2
				dbSelectArea("SG1")
			EndIf
			
			//-- Divide a Observa��o em Sub-Arrays com 45 posi��es
			aObserv := {}
			
			For nX := 1 to MlCount(AllTrim(G1_OBSERV),45)
				aAdd(aObserv, MemoLine(AllTrim(G1_OBSERV),45,nX))
			Next nX
			
			nPrintNivel:=IIF(nNivel>17,17,nNivel-2)
			@ li,nPrintNivel PSAY StrZero(nNivel,3)
			SB1->(dbSeek(xFilial("SB1")+SG1->G1_COMP))
			
			nEstouro := .F.
			
			cComp = G1_COMP
			nLen := LEN(RTRIM(cComp))
			
			if nLen > 15
				nEstouro := .T.
			endif
			
			@ li,21  PSay G1_COMP
			
			nCol := 0
			if nEstouro
				@ li,052 PSAY '-'
				@ li,054 PSAY SubStr(SB1->B1_DESC,1,34)
				li++
				if Len(RTrim(SB1->B1_DESC)) > 34
					@ li, 054 PSay SubStr(SB1->B1_DESC,35,34)
				EndIf
			else
				nCol := 1
			endif
			
			@ li,37 + nCol PSay Substr(G1_TRT,1,3)
			@ li,41 + nCol PSay SB1->B1_TIPO
			@ li,44 + nCol  PSay SB1->B1_GRUPO
			
			if !nEstouro
				@ li,49 + nCol PSay SubStr(SB1->B1_DESC,1,34)
				if Len(RTrim(SB1->B1_DESC)) > 34
					li++
					@ li, 49 PSay SubStr(SB1->B1_DESC,35,34)
				EndIf
			endif
			
			@ li,84 + nCol  PSay If(Len(aObserv)>0,aObserv[1],Left(G1_OBSERV,45))
			@ li,130 + nCol PSay nQuantItem Picture cPictQuant
			@ li,145 + nCol PSay SB1->B1_UM
			@ li,147 + nCol PSay G1_PERDA   Picture cPictPerda
			@ li,152 + nCol PSay G1_QUANT   Picture cPictQuant
			@ li,168 + nCol PSay If(RetFldProd(SB1->B1_COD,"B1_QB")==0,1,RetFldProd(SB1->B1_COD,"B1_QB")) Picture PesqPict("SB1","B1_QB",11)
			@ li,180 + nCol PSay If(G1_FIXVAR $' �V',STR0011,STR0012)		//"VARIAVEL"###"FIXA"
			@ li,190 + nCol PSay G1_INI	Picture PesqPict("SG1","G1_INI",10)
			@ li,201 + nCol PSay G1_FIM	Picture PesqPict("SG1","G1_FIM",10)
			@ li,212 + nCol PSay G1_GROPC	Picture PesqPict("SG1","G1_GROPC",3)
			@ li,216 + nCol PSay G1_OPC	Picture PesqPict("SG1","G1_OPC",4)
			//-- Caso existam, Imprime as outras linhas da Observa��o
			If Len(aObserv) > 1
				For nX := 2 to Len(aObserv)
					Li ++
					@ li,84 + nCol PSAY aObserv[nX]
				Next nX
			EndIf
			
			Li++
			
			//�������������������������������������������������Ŀ
			//� Verifica se existe sub-estrutura                �
			//���������������������������������������������������
			dbSelectArea("SG1")
			dbSeek(xFilial("SG1")+G1_COMP)
			If Found()
				MR225Expl(G1_COD,nQuantItem,nNivel+1,cPictQuant,cPictPerda,cOpcionais,nQuantPai,titulo,cabec1,cabec2,wnrel,Tamanho,nTipo,If(!Empty(SB1->B1_REVATU),SB1->B1_REVATU,mv_par08))
			EndIf
			dbGoto(nReg)
		EndIf
	EndIf
	dbSkip()
	nCntItens++
EndDo
nCntItens--
Return nCntItens
