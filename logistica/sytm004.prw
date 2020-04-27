#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWIZARD.CH" 
#DEFINE USADO CHR(0)+CHR(0)+CHR(1)
#DEFINE TEF_CLISITEF			"6"		//Utiliza a DLL CLISITEF

//���������������������������Ŀ
//| Posicao do array aDevol   |
//�����������������������������
#DEFINE _DESCMOEDA	1	// Descricao da moeda
#DEFINE _SALDO		2	// Saldo a devolver
#DEFINE _VALORDEV	3	// Valor efetivamente devolvido
#DEFINE _SOMADEV	4	// Somatorio da devolucao convertido                                                               
#DEFINE _VLRORIG	5	// Valor original da devolucao(backup)
#DEFINE _MOEDA		6	// Moeda

Static lTroca			// Controla se a operacao eh de troca ou devolucao
Static lConfirma		// Controla se usuario confirmou a operacao
Static oGetdDEV			// Objeto da MsGetDb do panel da devolucao
Static oGetdTRC		   	// Objeto da MsGetDb do panel da troca
Static aRecnoSD2		:= {}	// Array utilizado para enviar o registro do SD2 as funcoes do SIGACUSA.PRX
Static nTamRecTrb 		:= 10	// Tamanho do campo RecNo do TRB
Static cMvLjTGar		:= SuperGetMV("MV_LJTPGAR",,"GE")
Static lCenVenda 		:= SuperGetMv("MV_LJCNVDA",,.F.)
Static lNovaLj720 		:= .T. // Indica se deve executar a NOVA rotina LOJA720
Static oVlrTotal
Static nVlrTotal		:= 0															// Valor total de produtos a serem trocados ou devolvidos
Static oCliAus
Static aCliAus			:= {'2-Nao','1-Sim'}
Static cCliAus			:= ""
Static aRecValTroca     := {}

/*/
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Funcao	 �SYTM004   � Autor � 				        � Data � 16.08.05  ���
��������������������������������������������������������������������������Ĵ��
���Descricao � Rotina para realizacao de troca e devolucao de mercadorias. ���
��������������������������������������������������������������������������Ĵ��
���Sintaxe	 � LOJA720(ExpC1, ExpC2, EXpL3, EXpA4, ExpN5)                  ���
��������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1: Codigo do Cliente                                    ���
���          � ExpC2: Loja do Cliente                                      ���
���          � EXpA3: Armazena a serie, numero e cliente+loja da NF de     ���
���          � 		  devolucao e o tipo de operacao(1=troca;2=devolucao)  ��� 
���          � ExpN4: Opcao selecionada                                    ���
��������������������������������������������������������������������������Ĵ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
User Function SYTM004( cCodCli,cLojaCli,aDocDev,nOpc,cCodFil)  			

//������������������������������Ŀ
//�Declaracao de variaveis locais�
//��������������������������������
Local aArea			:= GetArea()  												// Salva a area atual
Local lRet			:= .T.														// Retorno da Funcao
Local cNomeCli		:= CriaVar("A1_NOME",.F.)									// Nome do Cliente
Local cNumDoc       := CriaVar("F1_DOC",.F.)									// Numero do documento quando nao eh formulario proprio para documento de entrada
Local cSerieDoc		:= CriaVar("F1_SERIE",.F.)                                	// Serie  do documento quando nao eh formulario proprio para documento de entrada
Local cFormaDev     := Space(3)													// Numerario para devolucao
Local dDataIni		:= dDataBase										        // Data Inicial para filtrar as Notas de saida do cliente
Local dDataFim		:= dDataBase										        // Data Final para filtrar as Notas de saida do cliente
Local cMarca  		:= GetMark()	                                         	// Marca da MsSelect
Local cAliasTRB		:= "TRB" 													// Alias do arquivo temporario
Local nTpProc		:= 1      													// Opcao selecionada. 1-Troca ou 2-Devolucao
Local nNfOrig		:= 1  														// Opcao selecionada. 1-Com NF de origem ou 2-Sem NF de origem
Local nI			:= 0														// Contador do FOR
Local nPosProd		:= 0														// Posicao do campo Produto no aHeader
Local nPosTES		:= 0                                                     	// Posicao do campo TES no aHeader
Local aHeaderSD2	:= {}          												// aHeader obrigatorio para o objeto MsGetDB
Local aRecSD2       := {}          												// Contem a Quantidade e o Recno dos produtos na tabela SD2 que estao marcados para carregar na NewGetDados
Local aCpoBrw 		:= {}       												// Campos da tabela SD2 que serao exibidos na MsSelect                                                  
Local aStruTRB		:= {}        												// Campos da estrutura do arquivo temporario
Local aNomeTMP		:= {}   													// Nomes das tabelas temporarias gravadas em disco
Local lFormul 		:= .T.														// Indica se utilizara formulario proprio para a Nota Fiscal de Entrada.                             
Local lCompCR		:= SuperGetMv( "MV_LJCMPCR", NIL, .T. )						// Indica se ira compensar o valor da NCC gerada com o titulo da nota fiscal original
Local cCad	  		:= If( Type("cCadastro") 	== "U",Nil,cCadastro) 			// Salva o cCadastro atual
Local aRots   		:= If( Type("aRotina")   	== "U",Nil,aClone(aRotina))    	// Salva o aRotinas atual	
Local aSavHead  	:= If( Type("aHeader") 		== "U",Nil,aClone(aHeader))    	// Salva o aHeader se existir
Local nBkpLin   	:= If( Type("n") 		    == "U",Nil,n)				   	// Salva o n se existir
Local nRecnoTRB                                                                	// Recno da area de trabalho
Local nFormaDev     := 2 														// Define a forma de devolucao ao cliente: 1-Dinheiro;2-NCC
Local cMV_DEVNCC    := AllTrim(SuperGetMV("MV_DEVNCC"))                        	// Define a forma de devolucao default: "1"-Dinheiro;"2"-NCC
Local cMV_LJCHGDV   := AllTrim(SuperGetMV("MV_LJCHGDV",,"1"))                  	// Define se permite ou nao modificar a forma de devolucao ao cliente("0"-nao permite;"1"-permite)
Local cMV_LJCMPNC   := AllTrim(SuperGetMV("MV_LJCMPNC",,"1"))                  	// Define se permite ou nao modificar a opcao para compensar a NCC com o titulo da NF original("0"-nao permite;"1"-permite)
Local lDevMoeda		:= .F.														// Se devolve em outra moeda
Local nTxMoedaTr 	:= 0														// Taxa da moeda
Local nMoedaCorT	:= 1														// Moeda corrente
Local aMoeda		:= {}														// Moedas validas
Local cMoeda		:= ""														// Armazena moeda na digitacao
Local nDecimais		:= 0														// Decimais
Local nX            := 0														// Contador de For
Local nPosLote		:= 0 														// Posicao do Campo Lote no aHeader no Panel3
Local lMv_Rastro	:= (SuperGetMv( "MV_RASTRO", Nil, "N" ) == "S")			// Flag de verificacao do rastro
Local aTamNF        := {} 														// Tamanho do campo de nota fiscal.
Local aTamCupom     := {}														// Tamanho do campo de cupom.
Local cCodDia       := ""                                        // Codigo do Diario
Local cDescrDia     := ""                                        // Descricao do Diario
Local lAliasCVL     := AliasInDic( "CVL" )                       // Verifica existencia da tabela
Local cCodprod      := ""                                        // Guarda o campo do D2_COD
//�����������������������Ŀ
//�Declaracao dos Objetos �
//�������������������������
Local oWizard	   																// Objeto principal do Wizard
Local oTpProc					   												// Tipo do Processo de Troca. Troca ou Devolucao
Local oNfOrig	   				   												// Indica se possui uma nota fiscal de origem 
Local oCodCli 					   												// Codigo do Cliente
Local oLojaCli																	// Loja do Cliente
Local oNomeCli		   															// Nome do cliente
Local oDataIni																	// Data Inicial para filtro das Notas Fiscais de Saida
Local oDataFim        											             	// Data Final para filtro das Notas Fiscais de Saida
Local oNumDoc		                                                    		// Numero do documento quando nao eh formulario proprio para documento de entrada
Local oSerieDoc                                                                	// Serie do documento quando nao eh formulario proprio para documento de entrada
Local oFormaDev																	// Objeto do Radio para forma de devolucao 
Local oCompCR    																// Indica se ira compensar o valor da NCC gerada com o titulo da nota fiscal original
Local oDevMoeda																	// Se devolve em outra moeda
Local oMoeda																	// Moeda
Local oTxMoeda																	// Taxa da moeda
Local oCodDia                                                 					// Codigo do Diario (PTG)
Local oDescrDia                                               					// Descricao do Diario (PTG)
Local oLblPedido  := Nil
Local oPedido     	:= Nil
Local cPedido     	:= Space(06)
Local lMotDevol		:= .F.														// Motivo de Devolucao
Local lNrChamado	:= .F.
Local oMotivo 	
Local cMotivo		:= ""                           
Local oDescMot 	
Local cDescMot  	:= Space(40) 
Local cNrChamado	:= ""
Local oNrChamado
Local cTpAcao		:= Space(6)
Local cOcorr		:= ""
Local oTpAcao		
Local cObs			:= Space(200)
Local oObs
Local oNfOri, oSerOri, oChvOri
Local nImpostos		:= 0                                                        // Total de impostos
Local oChvNFE																	// Objeto do campo "Chave da NFE" do documento quando nao eh formulario proprio para documento de entrada
Local M->F1_CHVNFE	:= "" 						                               	// Chave da NFE do documento quando nao eh formulario proprio para documento de entrada
Local oTpEspecie																// objeto Get que armazena a especie da nota fiscal de entrada
Local cTpEspecie	:= CriaVar("F1_ESPECIE",.F.)								// armazena a Especie da nota fiscal de entrada
Local oCodFil
Local oDescrFil
Local cDescrFil		:= ""														// Descricao da Filial
Local nFiltroPor	:= 1  														// Opcao selecionada no filtro da busca da venda
Local oSayClient
Local oSayDtIni
Local oSayDtFim
Local oSayNumNF
Local oSaySerie
Local oCodNumNF
Local oSerieNF
Local cNumNF 		:= Space(TamSx3("F2_DOC")[1])
Local cSerieNF		:= Space(TamSx3("F2_SERIE")[1])
Local oBotaoPesq
Local cConPadCli 	:= "SA1"
Local aControls 	:= {} //Array com os objetos de controle da tela que permitem algumas configuracoes atraves do Ponto e Entrada "LJ720CTRL"
Local lAltModo		:= .T.	   
//�������������������������������������������������������������������������������������Ŀ
//� VARIAVEIS PARA TRATAR O TIPO DE FRETE NA DEVOLUCAO - LUIZ EDUARDO F.C. - 06.12.2017 �
//���������������������������������������������������������������������������������������
Local aSx3Box       := {}                                   
Local aTpFrete      := {}
Local oCbTpFrete

Private cNfOri        := SPACE(9)
Private cSerOri       := SPACE(3)
Private cChvOri       := SPACE(300)												// Se pode alterar o modo
Private cCbTpFrete    := ""
Private cTrans        := ""

Private _cTitulo := ""	//#AFD20180619

Default	cCodCli 	:= CriaVar("A1_COD",.F.)									// Codigo do Cliente
Default cLojaCli    := CriaVar("A1_LOJA",.F.) 									// Loja do Cliente
Default aDocDev     := {}                                                       // Armazena a serie, numero e cliente+loja da NF de devolucao e o tipo de operacao(1=troca;2=devolucao)
Default nOpc        := 3                                                        // Opcao do aRotina
Default cCodFil 	:= cFilAnt													// Codigo da Filial

aRecValTroca := {} // Limpa variavel static ao iniciar a rotina.

//Array com os objetos de controle da tela que permitem algumas configuracoes atraves do Ponto e Entrada "LJ720CTRL"
//                  Nome do objeto          , Valor padrao  , Permite Editar (.T.=Sim, .F.=Nao)
aAdd( aControls, { "RadioButton " + "Processo"			, nTpProc		, .T. 	} ) //01 - RadioButton "Processo"
aAdd( aControls, { "RadioButton " + "Origem"			, nNfOrig		, .T. 	} ) //02 - RadioButton "Origem"
aAdd( aControls, { "RadioButton " + "Buscar venda por"	, nFiltroPor	, .T. 	} ) //03 - RadioButton "Buscar venda por"
aAdd( aControls, { "Consulta Padrao Cliente"			, cConPadCli	, .T. 	} ) //04 - Consulta Padrao Cliente

oVlrTotal := Nil
nVlrTotal := 0 // Valor total de produtos a serem trocados ou devolvidos

If SF1->(FieldPos("F1_MOTIVO")) > 0
	lMotDevol	:= .T.					//Habilita na Tela o Campo para o usuario informar o motivo da devolucao/Troca
	cMotivo		:= CriaVar("F1_MOTIVO",.F.)
Endif

If SF1->(FieldPos("F1_01SAC")) > 0
	lNrChamado	:= .T.					//Habilita na Tela o Campo para o usuario informar o numero do chamado
	cNrChamado	:= CriaVar("F1_01SAC",.F.)	
Endif

If AliasInDic( "SLX" )
	aTamCupom  := TamSx3("LX_CUPOM")
	aTamNF     := TamSx3("D1_DOC")
	//��������������������������������������������������������������Ŀ
	//� Verifica se o campo LX_CUPOM esta com o tamanho correto.     �
	//����������������������������������������������������������������
	If aTamCupom[1] <> aTamNF[1] .OR. aTamCupom[2] <> aTamNF[2]
		//"Corrigir o tamanho do campo LX_CUPOM para "
		MsgStop("Corrigir o tamanho do campo LX_CUPOM para "  + "[" + AllTrim(STR(aTamNF[1])) + "," + AllTrim(STR(aTamNF[2])) + "]")
		lRet := .F.
	Endif
EndIf
//��������������������������������������������������������������Ŀ
//�Nao habilitar a rotina quando for Visualizacao(nOpc=2).       �
//����������������������������������������������������������������
If nOpc == 2 .AND. lRet  
   //"Nao e possivel acessar a rotina de troca/devolucao no modo Visualizacao."
   MsgStop("Nao e possivel acessar a rotina de troca/devolucao no modo Visualizacao.")
   lRet := .F.
Endif

//������������������������������������������������������������������������������������Ŀ
//�A rotina nao podera ser executada caso o usuario nao esteja cadastrado como um caixa�
//��������������������������������������������������������������������������������������
If lRet 
	cMV_LJCHGDV := "0"		
	cMV_DEVNCC	:= "2"
	nTpProc		:= 2
	lAltModo	:= .T.
Endif

//��������������������������������Ŀ
//� Verifica se ha troca pendente  �
//����������������������������������
If lRet .AND. Len(aDocDev) > 0
   If aDocDev[5] == 1  //Troca
      //"Aten��o", "H� uma opera��o de troca pendente. Saia da rotina de venda para estornar a transa��o ou finalize a venda para conclui-la.", "Ok"
      Aviso("Aten��o","H� uma opera��o de troca pendente. Saia da rotina de venda para estornar a transa��o ou finalize a venda para conclui-la.",{"Ok"})
      lRet  := .F.
   Else
      aDocDev  := {}
   Endif   
Endif

//��������������������������������������������������������������Ŀ
//� A ocorrencia 31 verificara a permissao do usuario p/ efetuar �
//� ou nao uma Troca.											 �
//����������������������������������������������������������������
If lRet .AND. ChkPsw( 31 )
	
	If lNovaLj720
		cCodCli 	:= SuperGetMV("MV_CLIPAD",,"")	// Cliente padrao
		cLojaCli 	:= SuperGetMV("MV_LOJAPAD")		// Loja do cliente padrao
	EndIf
	
	If !Empty(cCodCli) .AND. !Empty(cLojaCli)
		cNomeCli:= Posicione("SA1",1,xFilial("SA1")+cCodCli+cLojaCli,"A1_NOME") 
	Endif
		
	Private	aRotina		:= MenuDef()  			        // Array de opcoes
	Private cCadastro	:= ""  				           // Cabecalho da tela
	
		
	//������������������������������������������������������������������������������������������Ŀ
	//� Monta a estrutura e o arquivo temporario para a GetDados dos produtos exibida no panel 3.�
	//��������������������������������������������������������������������������������������������
	Lj720GetStru(@aHeaderSD2,	@aStruTRB,	cAliasTRB,	@aNomeTMP)
	
	nPosProd  :=Ascan(aHeaderSD2, {|x| AllTrim( x[2] ) == "TRB_CODPRO"})
	nPosTES	  :=Ascan(aHeaderSD2, {|x| AllTrim( x[2] ) == "TRB_TES"}) 
	
	If lMv_Rastro
		nPosLote  := aScan(aHeaderSD2, {|x| AllTrim( x[2] ) == "TRB_LOTECT"})
	Endif	
	
	aDocDev   := {}  //Inicializar o array caso faca duas ou mais operacoes 
	lTroca    := nTpProc == 1
	lConfirma := .F.
	//������������������������������������������������������������������������������������������Ŀ
	//� Se o parametro MV_DEVNCC estiver preenchido com "1" ou "2", assume o valor como default  �
	//� para a forma de devolucao																 �	
	//��������������������������������������������������������������������������������������������	
	If cMV_DEVNCC $ "12"
	    nFormaDev  := VAL(cMV_DEVNCC)
	Endif
	
	Private aHeader := aHeaderSD2                        // Cabecalho do grid de itens devolvidos
		

		//�������Ŀ
		//�Panel 1�
		//���������
		DEFINE WIZARD oWizard SIZE 0,0,600,800 TITLE "Troca e Devolu��o de Mercadorias" HEADER "Defini��o do Processo" ;	//"Troca e Devolu��o de Mercadorias" ## "Defini��o do Processo"
				MESSAGE "Informe os dados para o processo de troca ou devolu��o"; 										//"Informe os dados para o processo de troca ou devolu��o"
				TEXT " " NEXT {|| 	L720NextPn( oWizard:nPanel 	, nNfOrig  		, cCodCli 		, cLojaCli  ,;
												@oWizard       	, nTpProc  		, Nil			, Nil		,;
									            cCodFil			, nFiltroPor 	, aRecSD2 ) .AND. ;
									Lj720GetOk( cAliasTRB, @aRecSD2, @nVlrTotal, nRecnoTRB, nNfOrig, nTpProc ) } ;
				FINISH {||  .T. } NOFIRSTPANEL	PANEL 
				
				oWizard:GetPanel(1)
			    
			    //--------------------------
			    // Label "Processo"
			    //--------------------------
				@ 005,010 TO 050,120 LABEL "Processo" OF oWizard:GetPanel(1) COLOR CLR_HBLUE PIXEL //"Processo"
				@ 010,015 RADIO oTpProc VAR nTpProc ITEMS "Troca","Devolu��o","Nota Credito (NCC)","Nota D�bito (NDC)" SIZE 60,10 PIXEL OF oWizard:GetPanel(1) ;
						WHEN ( lAltModo .AND. aControls[1][3]);
						ON CHANGE ( L720ChgPrc( cAliasTRB		, @aRecSD2		, oGetdTRC  	, @lFormul  , ;
				        						@lCompCR   		, @nRecnoTRB	, nTpProc		, nNfOrig	, ;
				        						oWizard:nPanel 	, @oBotaoPesq) 	, @oFiltroPor 	, @nFiltroPor) //"Troca", "Devolu��o"
				
			    //--------------------------
			    // Label "Origem"
			    //--------------------------
				@ 005,145 TO 050,255 LABEL "Origem" OF oWizard:GetPanel(1) COLOR CLR_HBLUE PIXEL //"Origem"
				@ 020,150 RADIO oNfOrig VAR nNfOrig ITEMS "Com Documento de Entrada","Sem Documento de Entrada" SIZE 80,10 PIXEL OF oWizard:GetPanel(1) ;
						 WHEN ((nTpProc==1 .or. nTpProc==2) .and. aControls[2][3]); //WHEN (aControls[2][3]); //#RVC20180406.o
				         ON CHANGE ( L720ChgOri( nNfOrig  	, @oDataIni		, @oDataFim		, @dDataIni  	,;
				                                @dDataFim	, @oCodFil   	, @cCodFil  	, @oDescrFil 	,;
				                                @cDescrFil	, @oFiltroPor	, @oBotaoPesq	, cAliasTRB  	,;
				                                @aRecSD2  	, oGetdTRC  	, @lFormul		, @lCompCR   	,;
				                                @nRecnoTRB	, nTpProc 		, oWizard:nPanel, @nFiltroPor 	,;
				                                @oSayClient	, @oCodCli		, @oLojaCli		, @oNomeCli		,;
				                                @oSayDtIni	, @oSayDtFim	, @oSayNumNF 	, @oCodNumNF	,;
				                                @oSaySerie	, @oSerieNF		, oLblPedido  	,oPedido  ) )//"Com Documento de Entrada" , "Sem Documento de Entrada"
				
			    //--------------------------
			    // Label "Buscar venda por"
			    //--------------------------
				@ 005,280 TO 050,390 LABEL "Buscar venda por" OF oWizard:GetPanel(1) COLOR CLR_HBLUE PIXEL //"Buscar venda por"
				
				If Val(GetVersao(.F.)) >= 12 // Caso a versao seja maior ou igual a 12, tera a opcao de vale-troca.
					@ 020,285 RADIO oFiltroPor VAR nFiltroPor ITEMS "Cliente e Data","Nota Fiscal","Pedido de Venda" SIZE 80,10 PIXEL OF oWizard:GetPanel(1) ; //"Cliente e Data","No. Cupom / Nota","Vale-Troca"
							 WHEN (/*nNfOrig==1 .And.*/ aControls[3][3]); //#RVC20180406.n
					         ON CHANGE ( L720ChgFil( nFiltroPor	, @oSayClient	, @oCodCli		, @oLojaCli		,;
					         						 @oNomeCli	, @oSayDtIni	, @oDataIni		, @oSayDtFim	,;
					         						 @oDataFim	, @oSayNumNF	, @oCodNumNF	, @oSaySerie	,;
					         						 @oSerieNF 	, cAliasTRB		, @aRecSD2		, oGetdTRC		,;
					         						 @lFormul	, @lCompCR		, @nRecnoTRB	, nTpProc 		,;
					         						 nNfOrig	, oWizard:nPanel, oLblPedido  ,oPedido ) ) 
				Else
					@ 020,285 RADIO oFiltroPor VAR nFiltroPor ITEMS "Cliente e Data","Nota Fiscal" SIZE 80,10 PIXEL OF oWizard:GetPanel(1) ; //"Cliente e Data","No. Cupom / Nota"
							 WHEN (nNfOrig==1 .And. aControls[3][3]);
					         ON CHANGE ( L720ChgFil( nFiltroPor	, @oSayClient	, @oCodCli		, @oLojaCli		,;
					         						 @oNomeCli	, @oSayDtIni	, @oDataIni		, @oSayDtFim	,;
					         						 @oDataFim	, @oSayNumNF	, @oCodNumNF	, @oSaySerie	,;
					         						 @oSerieNF 	, cAliasTRB		, @aRecSD2		, oGetdTRC		,;
					         						 @lFormul	, @lCompCR		, @nRecnoTRB	, nTpProc 		,;
					         						 nNfOrig	, oWizard:nPanel, oLblPedido  ,oPedido ) )
				EndIf	         						 
				
			    //--------------------------
			    // Label "Dados da venda"
			    //--------------------------
				@ 055,010  TO 124,390 LABEL "Dados da venda" OF oWizard:GetPanel(1) COLOR CLR_HBLUE PIXEL //"Dados da venda"
				
				
				Lj720NomFi( cCodFil, @cDescrFil, .F. )
				
				//Campo ""Filial"
				@ 067,020 SAY  "Loja:" OF oWizard:GetPanel(1) PIXEL SIZE 50,9 //"Filial:" 
				@ 065,070 MSGET oCodFil	VAR cCodFil SIZE 50,10 Picture "@!" F3 "DLB" OF oWizard:GetPanel(1) ;
				         VALID ( If(Lj720NomFi(cCodFil, @cDescrFil, .T.), oDescrFil:Refresh(), .F.) ) ;
				         PIXEL  WHEN (nNfOrig==1)
				
				@ 065,135 MSGET oDescrFil VAR cDescrFil SIZE 200,10 Picture "@!" OF oWizard:GetPanel(1) PIXEL WHEN .F.
				
				//Campo "Cliente"
				@ 087,020 SAY oSayClient Var "Cliente:" OF oWizard:GetPanel(1) PIXEL SIZE 50,09 //"Cliente:"
				@ 085,070 MSGET oCodCli VAR cCodCli SIZE 40,10 Picture "@!" F3 cConPadCli OF oWizard:GetPanel(1) ;
				         VALID (L720ChgCli( "CODCLI"		, cAliasTRB		, @aRecSD2	, oGetdTRC  , ;
				         					@lFormul  		, lCompCR   	, @nRecnoTRB, nTpProc	, ;
				         					nNfOrig			, oWizard:nPanel, cCodCli 	, @cLojaCli	, ;
				         					cCodFil			, @oLojaCli		, @oNomeCli	, @cNomeCli));
				         PIXEL WHEN (nFiltroPor==1 .And. aControls[4][3])
				
				//Campo "Loja"
				@ 085,115 MSGET oLojaCli VAR cLojaCli SIZE 10,10 Picture "@!" OF  oWizard:GetPanel(1) ;
				         VALID (L720ChgCli( "CODLOJA"		, cAliasTRB		, @aRecSD2	, oGetdTRC  , ;
				         					@lFormul  		, lCompCR   	, @nRecnoTRB, nTpProc	, ;
				         					nNfOrig			, oWizard:nPanel, cCodCli 	, @cLojaCli	, ;
				         					cCodFil			, @oLojaCli		, @oNomeCli	, @cNomeCli));
				          PIXEL WHEN (nFiltroPor==1 .And. aControls[4][3])
				
				//Campo "Nome do cliente"
				@ 085,135 MSGET oNomeCli VAR cNomeCli SIZE 200,10 Picture "@!" OF oWizard:GetPanel(1) PIXEL WHEN .F.
				
				//Campo "Data Inicial Compra"
				@ 107,020 SAY oSayDtIni Var "Dt Inicial Venda:" OF oWizard:GetPanel(1) PIXEL SIZE 50,09 //"Data Inicial Compra:"
				@ 105,060 MSGET oDataIni VAR dDataIni SIZE 40,10 OF oWizard:GetPanel(1) VALID( If(nNfOrig == 1,!EMPTY(dDataIni),.T.) , IIf(!Empty(dDataFim),dDataFim >= dDataIni,.T.)) PIXEL 
				
				//Campo "Data Final Compra"
				@ 107,105 SAY oSayDtFim Var "Dt Final Venda:" OF oWizard:GetPanel(1) PIXEL SIZE 50,09 //"Data Final Compra:"
				@ 105,145 MSGET	oDataFim VAR dDataFim SIZE 40,10 OF oWizard:GetPanel(1) VALID( If(nNfOrig == 1,!EMPTY(dDataFim),.T.) ,  dDataFim >= dDataIni) PIXEL 	
				
				//Campo "No. Cupom / Nota"
				@ 107,020 SAY oSayNumNF Var "Nota Fiscal:" OF oWizard:GetPanel(1) PIXEL SIZE 50,09 //"No. Cupom / Nota":
				@ 105,070 MSGET oCodNumNF VAR cNumNF SIZE 50,10 Picture "@!" OF oWizard:GetPanel(1) PIXEL
				
				//Campo "Serie"
				@ 107,135 SAY oSaySerie Var "S�rie:" OF oWizard:GetPanel(1) PIXEL SIZE 50,09 //"S�rie":                   
				@ 105,155 MSGET oSerieNF VAR cSerieNF SIZE 15,10 Picture "@!" OF oWizard:GetPanel(1) PIXEL
				
				//Campo "Codigo do Pedido"
				@ 087,020 SAY oLblPedido Var "Pedido de Venda: " OF oWizard:GetPanel(1) PIXEL SIZE 50,09 //"Vale-Troca"
				@ 085,070 MSGET oPedido VAR cPedido SIZE 50,10 Picture "@!" OF oWizard:GetPanel(1) PIXEL
				
				//Campo "Cliente Ausente" caso seja cliente ausente o cr?ito precisa ser gerado na NCC
				@ 107,189 SAY "(NCC)Cliente Ausente/Entre. Barrada? : " OF oWizard:GetPanel(1)  PIXEL	//Campo que impede o desconto do frete + agregado da NCC  
    			@ 105,283 ComboBox cCliAus Items aCliAus Size 040,010 PIXEL OF oWizard:GetPanel(1)   //Marcio Nunes - 11569              

				If nFiltroPor == 1
					//Oculta campos "No. Cupom / Nota" e "Serie"
					oSayNumNF:Hide()
					oCodNumNF:Hide()
					oSaySerie:Hide()
					oSerieNF:Hide()
					oLblPedido:Hide()
					oPedido:Hide()
				Else
					//Oculta campos "Data Inicial Compra" e "Data Final Compra"
					oSayDtIni:Hide()
					oDataIni:Hide()
					oSayDtFim:Hide()
					oDataFim:Hide()
					oLblPedido:Hide()
					oPedido:Hide()
				EndIf
				
			    //--------------------------
			    // Botao "Pesquisar"
			    //--------------------------
				@ 110,345 BUTTON oBotaoPesq PROMPT "Pesquisar" SIZE 040,11 OF oWizard:GetPanel(1) PIXEL ;
					WHEN ( /*nNfOrig==1 .And.*/ (nTpProc==1 .Or. nTpProc==2 .Or. nTpProc==3 .Or. nTpProc==4 ) );//#RVC20180406.n
					ACTION ( Lj720AltProc( 	cAliasTRB  , @aRecSD2  	, oGetdTRC  ,@lFormul  ,;
				 							@lCompCR   , @nRecnoTRB	, nTpProc ) ,;
							L720SelIte( cCodFil		, @aRecSd2	, nNfOrig	, nFiltroPor, ;
										@cCodCli	, @cLojaCli	, @cNomeCli	, oNomeCli	, ;
										dDataIni  	, dDataFim	, @aNomeTMP , cAliasTRB , ;
										@nRecnoTRB 	, cNumNF 	, cSerieNF 	, @nVlrTotal, cPedido )) //"Pesquisar"
				
			    //--------------------------
			    // Label dos Itens da Venda
			    //--------------------------
				@ 128,010  TO 237,390 LABEL "" OF oWizard:GetPanel(1) PIXEL
				
				DbSelectArea(cAliasTRB)
				//���������������������������������������������������������������������������������������Ŀ
				//�Sempre setar o indice que nao possui o campo TRB_ITEM na chave, para quando estiver    �
				//� em modo de edicao do objeto, seja incrementado mais um ao conteudo do campo ITEM.     �
				//�����������������������������������������������������������������������������������������
				DbSetOrder(1)
	
			  	oGetdTRC := MsGetDB():New(			133		,	015		,		205		,		385		,;
			  										3		,"AllwaysTrue"	,"AllwaysTrue"	,"+TRB_ITEM"	,;
			  										.T.		,{"TRB_QUANT","TRB_TES"}, NIL	,     .T.		,;
			  										999		,cAliasTRB	        	, NIL	,	 NIL        ,;
			  										.T.     ,oWizard:GetPanel(1)	, NIL	,		.T.		,;
			  										"U_L720VldDel" )
	  			oGetdTRC:oBrowse:nColPos := GetMV("MV_LJ720FC",,1)
			  	
				//��������������������Ŀ
				//�Consulta Padr�o (F3)�
				//����������������������
				oGetdTRC:aInfo[nPosProd][1]		:= "SL2"
				oGetdTRC:aInfo[nPosTES][1]		:= "SF4"		  	
				oGetdTRC:lDeleta				:= .F. 
				oGetdTRC:lNewLine				:= .F. 		
		        oGetdTRC:ForceRefresh()
						        
				//Campo "Valor Total de Mercadorias"
				@ 225,250 SAY "Valor Total de Mercadorias : " OF oWizard:GetPanel(1)  PIXEL							//"Valor Total de Mercadorias : "
				@ 223,325 MSGET oVlrTotal VAR nVlrTotal SIZE 60,8 Picture "@E 999,999.99" OF oWizard:GetPanel(1) PIXEL //WHEN .F.//#RVC20180406.o
								
				//�����������������������������������������������������������������������������Ŀ
				//�Se MV_RASTRO estiver como "S", habilita consulta do lote atraves da tecla F4.�
				//�������������������������������������������������������������������������������
		        If lMv_Rastro
					Set Key VK_F4 To Lj720Lote()
				EndIf
				
			//�������Ŀ
			//�Panel 2�
			//���������
			CREATE PANEL oWizard  HEADER "Dados do Documento de Entrada" ;  	//"Dados do Documento de Entrada"
				MESSAGE "Informe os dados para gera��o da nota de entrada" ; 					//"Informe os dados para gera��o da nota de entrada"
				 BACK {|| .T.};
				 NEXT {|| .F.};
				 FINISH {|| If(!lFormul,!Empty(cNumDoc) .AND. !Empty(cSerieDoc) .AND. !Empty(cTpEspecie),.T.) .AND. ;
							L720NextPn( oWizard:nPanel 	, nNfOrig  		, cCodCli 		, cLojaCli  ,;
										@oWizard       	, nTpProc  		, Nil			, Nil		,;
							            cCodFil			, nFiltroPor 	, aRecSD2 ) .AND. ;				            
					            Lj720ValDev( lCompCR,nFormaDev,nTpProc,nNfOrig,lFormul,	aRecSD2,cMotivo,cObs,cNrChamado,cTpAcao )    .AND. ;					 			
					 			Lj720Concluir(	nTpProc		, nNfOrig		, cCodCli   	, cLojaCli		,;
						 						aRecSD2		, lFormul		, cNumDoc   	, cSerieDoc		,;
						 					 	lCompCR		, @aDocDev   	, nFormaDev		,;
						 					 	nVlrTotal	, @lDevMoeda	, nMoedaCorT	, nTxMoedaTr	,; 
						 					 	cCodDia		, cMotivo 	 	, @nImpostos  	, M->F1_CHVNFE	,;
						 					 	cTpEspecie	, cCodFil		, cNrChamado	, cObs			,;
						 					 	cTpAcao, cOcorr )} PANEL
				
				oWizard:GetPanel(2)
				
			    //------------------------------------------------
			    // Label "Dados para gera��o da nota de entrada"
			    //------------------------------------------------
				@ 005,010  	TO   070,390 LABEL "Dados para gera��o da nota de entrada"	OF oWizard:GetPanel(2) COLOR CLR_HBLUE PIXEL //"Dados para gera��o da nota de entrada"
				@ 017,015	 	SAY  "Cliente:"     		    OF oWizard:GetPanel(2) 	PIXEL SIZE 50,9 		//"Cliente:" 
				@ 015,090	 	MSGET 	oCodCli_1  	VAR cCodCli  	SIZE 40,10 		Picture "@!" F3 cConPadCli OF  oWizard:GetPanel(2) ;
						 	VALID (Lj720ValCli(cCodCli,cLojaCli),cNomeCli := Lj720VldCli(cCodCli,cLojaCli,cCodFil),oNomeCli:Refresh()) 	;
						 	PIXEL  WHEN If(nNfOrig == 1, .T., .F.)
				@ 015,135	MSGET 	oLojaCli_1 	VAR cLojaCli 	SIZE 10,10 	Picture "@!" 			OF  oWizard:GetPanel(2) ;
						 	VALID (Lj720ValCli(cCodCli,cLojaCli),cNomeCli := Lj720VldCli(cCodCli,cLojaCli,cCodFil),oNomeCli:Refresh()) 	;
						 	PIXEL WHEN If(nNfOrig == 1, .T., .F.)
				@ 015,165 MSGET oNomeCli_1 VAR cNomeCli SIZE 200,10 Picture "@!" OF oWizard:GetPanel(2) PIXEL WHEN .F.
				
				//Campo "Valor Total de Mercadorias"
				@ 035,015 SAY "Valor Total de Mercadorias : " OF oWizard:GetPanel(2)  PIXEL							//"Valor Total de Mercadorias : "
				@ 033,090 MSGET oVlrTotal_1 VAR nVlrTotal SIZE 60,9 Picture "@E 999,999.99" OF oWizard:GetPanel(2) PIXEL WHEN .F.
				
	 			@ 057,25  SAY "Utiliza a Nota de Cr�dito(NCC) da devolu��o para compensar com o t�tulo da Nota Debito Cliente(NDC)?"  OF oWizard:GetPanel(2) PIXEL SIZE 250,9  
	 			@ 055,15  CHECKBOX oCompCR VAR lCompCR SIZE 8,8 PIXEL OF oWizard:GetPanel(2) ;
	 			          WHEN nTpProc == 2 .AND. cMV_LJCMPNC == "1" .AND. nNfOrig == 1
									         		         	
				@ 80,10  TO 230,390 		LABEL "" OF oWizard:GetPanel(2)  PIXEL
		        @ 83,25  SAY "Utiliza formul�rio pr�prio para documento de entrada?" OF oWizard:GetPanel(2) PIXEL SIZE 150,9   //"Utiliza formul�rio pr�prio para documento de entrada?"
				@ 81,15  CHECKBOX oFormul VAR lFormul SIZE 8,8 PIXEL OF oWizard:GetPanel(2) ON CHANGE Lj720AltForm(lFormul,oNumDoc,oSerieDoc,@cNumDoc,@cSerieDoc,oChvNFE,@M->F1_CHVNFE, oTpEspecie, @cTpEspecie);
						WHEN (nTpProc == 1 .OR. nTpProc == 2 ) .AND. cMV_LJCMPNC == "1" .AND. nNfOrig == 1 //#RVC20180406.n
	 			
	 			@ 93,25  SAY "Numero do Documento"  OF oWizard:GetPanel(2) PIXEL SIZE 150,9  //"Numero do Documento"
	 			@ 92,80  MSGET oNumDoc 		VAR cNumDoc 	SIZE 35,8 	Picture "@!" PIXEL OF oWizard:GetPanel(2) VALID IIf(!lFormul,!Empty(cNumDoc),.T.) When !lFormul
	 			
	 			@ 93,125 SAY "S�rie"  OF oWizard:GetPanel(2) PIXEL SIZE 150,9 	//"S�rie"
	 			@ 92,140 MSGET oSerieDoc 	VAR cSerieDoc 	SIZE 15,8 	Picture "@!" PIXEL OF oWizard:GetPanel(2) VALID IIf(!lFormul, LjSerieOk(cSerieDoc,@cTpEspecie), .T.) When !lFormul
	
	 			@ 93,165 SAY "Esp�cie"  OF oWizard:GetPanel(2) PIXEL SIZE 180,9 	//"Esp�cie"?
	 			@ 92,185 MSGET oTpEspecie	VAR cTpEspecie SIZE 15,8	Picture "@!" PIXEL OF oWizard:GetPanel(2) VALID IIf(!lFormul, LjEspecOk(cTpEspecie), .T.) F3 "42" When !lFormul
	 			
	 			If SF1->(FieldPos("F1_CHVNFE")) > 0
		 			M->F1_CHVNFE := CriaVar("F1_CHVNFE",.F.)
		 			@ 107,25  SAY "Chave NFe"  OF oWizard:GetPanel(2) PIXEL SIZE 150,9  //"Chave NFe"
		 			@ 105,55 MSGET oChvNFE 	VAR M->F1_CHVNFE  SIZE 150,8 	Picture "@!" PIXEL OF oWizard:GetPanel(2) When !lFormul
	 			EndIf
		
				@ 120,15 GROUP oGroup TO 155,90 LABEL "Forma de devolu��o" OF oWizard:GetPanel(2) PIXEL   //"Forma de devolu��o"
	
				@ 129,18 RADIO oFormaDev VAR nFormaDev SIZE 60,10 PROMPT "Dinheiro","Nota de Cr�dito" PIXEL ;       //"Dinheiro", "Nota de Cr�dito"
				OF oWizard:GetPanel(2) WHEN nTpProc == 2 .AND. cMV_LJCHGDV == "1" ;
				ON CHANGE Lj720AltMd(nFormaDev,oDevMoeda)
								
	    		//Habilita o Campo de Motivo da Devolucao
				If lMotDevol
					@ 122,100  SAY  "Motivo:"	OF oWizard:GetPanel(2) PIXEL SIZE 50,9 //"Motivo:"					                                                                                    
					@ 120,132  MSGET 	oMotivo  	VAR cMotivo  	SIZE 40,10 	Picture "@!" F3 "O1" 	OF  oWizard:GetPanel(2) VALID ( Lj720VldMot(cMotivo, @cDescMot), oDescMot:Refresh()) PIXEL 				         		          			          
					@ 122,178 SAY 	oDescMot 	Var cDescMot 	OF oWizard:GetPanel(2) COLOR CLR_RED PIXEL SIZE 180,9 												
				Endif
				
	    		//Habilita o Campo numero do chamado
				If lNrChamado
					@ 142,100  SAY  "Nr Chamado:"	OF oWizard:GetPanel(2) PIXEL SIZE 50,9					                                                                                    
					@ 140,132  MSGET oNrChamado VAR cNrChamado SIZE 40,10 Picture "@!" F3 "SUC01" OF  oWizard:GetPanel(2) PIXEL VALID( LjVldAcao( cNrChamado,@cTpAcao,nTpProc,@cOcorr ),oTpAcao:Refresh() )
				Endif                        
				
				@ 162,250  SAY  "Tipo A��o:" OF oWizard:GetPanel(2) PIXEL SIZE 50,9										//@ 142,180  SAY  "Tipo A��o:" OF oWizard:GetPanel(2) PIXEL SIZE 50,9										//#RVC20180406.n				                                                                                    
				@ 160,320  MSGET oTpAcao VAR cTpAcao SIZE 40,10 Picture "@!" F3 "Z01DEV" OF  oWizard:GetPanel(2) PIXEL	//@ 140,250  MSGET oTpAcao VAR cTpAcao SIZE 40,10 Picture "@!" F3 "Z01DEV" OF  oWizard:GetPanel(2) PIXEL 	//#RVC20180406.n
				
				@ 162,15   SAY  "Ocorr�ncia:"	OF oWizard:GetPanel(2) PIXEL SIZE 50,9					                                                                                    
				@ 160,50  MSGET oObs VAR cObs SIZE 160,10 Picture "@!" OF oWizard:GetPanel(2) PIXEL 

				//�����������������������������������������������������������������������������������Ŀ
				//� FAZ O TRATAMENTO PARA TIPO DE FRETE NA DEVOLUCAO - LUIZ EDUARDO F.C. - 06.12.2017 �
				//�������������������������������������������������������������������������������������
				aSx3Box  := RetSx3Box(Posicione("SX3",2,"C5_TPFRETE","X3CBox()" ),,, 1 )  
				    
				aTpFrete := {}
				For nX:=1 To Len(aSx3Box)
					aAdd(aTpFrete , aSx3Box[nX,1] )
				Next     
				
				cCbTpFrete := aSx3Box[1,1]
									
				@ 142,250 SAY "Selecione o Tipo de Frete" SIZE 100,10 PIXEL OF oWizard:GetPanel(2)						//@ 122,180 SAY "Selecione o Tipo de Frete" SIZE 100,10 PIXEL OF oWizard:GetPanel(2)
				@ 140,320 MSCOMBOBOX oCbTpFrete VAR cCbTpFrete ITEMS aTpFrete SIZE 040,013 OF oWizard:GetPanel(2) PIXEL;	//@ 120,250 MSCOMBOBOX oCbTpFrete VAR cCbTpFrete ITEMS aTpFrete SIZE 040,013 OF oWizard:GetPanel(2) PIXEL
					WHEN (nTpProc == 1 .OR. nTpProc == 2 ) .AND. cMV_LJCMPNC == "1" .AND. nNfOrig == 1 //#RVC20180406.n
				//�����������������������������������������������������������������������������������������������������������������������������Ŀ
				//� DIGITACAO DA NOTA FISCAL DE ORIGEM/SERIE DA NF/ CHAVE DA NF NO PROCESSO DE TROCA/DEVOLUCAO - LUIZ EDUARDO F.C. - 04/07/2017 �
				//�������������������������������������������������������������������������������������������������������������������������������
				IF GetMv("KH_NFDEVO",,.T. )                                                                         
					@ 187,015  SAY  "NF Origem :"	OF oWizard:GetPanel(2) PIXEL SIZE 50,9					                                                                                    
					@ 185,050  MSGET oNfOri VAR cNfOri SIZE 080,010 Picture "@!" OF oWizard:GetPanel(2) PIXEL ;
						WHEN (nTpProc == 1 .OR. nTpProc == 2 ) .AND. cMV_LJCMPNC == "1" .AND. nNfOrig == 1 //#RVC20180406.n
					@ 187,135   SAY  "S�rie Origem"	OF oWizard:GetPanel(2) PIXEL SIZE 50,9							//@ 187,200   SAY  "S�rie Origem"	OF oWizard:GetPanel(2) PIXEL SIZE 50,9					  //#RVC20180406.o                                                                                   
					@ 185,170  MSGET oSerOri VAR cSerOri SIZE 040,010 Picture "@!" OF oWizard:GetPanel(2) PIXEL;	//@ 185,250  MSGET oSerOri VAR cSerOri SIZE 040,010 Picture "@!" OF oWizard:GetPanel(2) PIXEL //#RVC20180406.o
						WHEN (nTpProc == 1 .OR. nTpProc == 2 ) .AND. cMV_LJCMPNC == "1" .AND. nNfOrig == 1 //#RVC20180406.n
					//@ 202,15   SAY  "Chave:"	OF oWizard:GetPanel(2) PIXEL SIZE 50,9					                                                                                    
					//@ 200,50  MSGET oChvOri VAR cChvOri SIZE 200,10 Picture "@!" OF oWizard:GetPanel(2) PIXEL  
					
					//aaDD(aNFEDanfe, iif(FieldPos("F1_TPFRETE")>0, RetTipoFrete(SF1->F1_TPFRETE),""))                                                                                        				
					//aaDD(aNFEDanfe, RetTipoFrete(CriaVar("F1_TPFRETE")))             
				EndIF
								        
	ACTIVATE WIZARD oWizard CENTERED  WHEN {||.T.} VALID {|| Lj720AtuTrc()}

	//�����������������������������Ŀ
	//�Apaga os arquivos temporarios�
	//�������������������������������
	DbSelectArea(cAliasTRB)
	DbSetOrder(2)
	DbCloseArea()

    DbSelectArea("SD2")
    RetIndex("SD2")
    DbClearFilter()

	If Len(aNomeTMP) > 0
		For nI:= 1 to Len(aNomeTMP)
			If File(aNomeTMP[nI])
	     		FErase(aNomeTMP[nI])
	     	Endif
	    Next nI 		
	Endif

    Lj720BkpArea(cCad, aRots, aSavHead, nBkpLin)
Endif

RestArea(aArea)

Return(Nil)  

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    |MenuDef	� Autor � Vendas Cliente        � Data �27/12/06  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao de defini��o do aRotina                             ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � aRotina   retorna a array com lista de aRotina             ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGALOJA                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MenuDef() 

Local aRotina := {	{ "Pesquisar"  	,"AxPesqui" ,0 , 1 , , .F. },;		// "Pesquisar"
					{ "Visualizar" 	,"AxVisual" ,0 , 2 , , .T. },;		// "Visualizar"
					{ "Incluir"  	,"AxInclui" ,0 , 3 , , .T. },;		// "Incluir"
					{ "Alterar"  	,"AxAltera" ,0 , 4 , , .T. } }		// "Alterar"
Return(ARotina)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Lj720VldCli �Autor  � Vendas Cliente     � Data �  16/08/05 ���
�������������������������������������������������������������������������͹��
���Desc.     � Devolve o nome do cliente baseado no codigo que foi        ���
���          � digitado.                                                  ���
�������������������������������������������������������������������������͹��
���Parametros�ExpC1 - Codigo do Cliente                                   ���
���          �ExpC2 - Loja do Cliente                                     ���
�������������������������������������������������������������������������͹��
���Uso       � SIGALOJA - VENDA ASSISTIDA                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Lj720VldCli(cCodCli, cCodLoja, cFilCli)
Local cDesc := CRIAVAR("A1_NOME",.F.)                //Nome do cliente
Local aArea	:= GetArea()                             //Area atual para restaurar no final da funcao

cFilCli := FWxFilial("SA1",cFilCli)

If !Empty(cCodCli) .AND. !Empty(cCodLoja)
	DbSelectArea("SA1")
	If DbSeek(cFilCli+cCodCli+cCodLoja)
		cDesc := SA1->A1_NOME
	Endif	
Endif

RestArea(aArea)

Return(cDesc)                       

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Lj720AltForm�Autor  � Vendas Cliente     � Data �  25/08/05 ���
�������������������������������������������������������������������������͹��
���Desc.     �Habilita / Desabilita a edicao dos campos Numero do documen-���
���          �to e serie do documento para formulario proprio igual a NAO.���
�������������������������������������������������������������������������͹��
���Parametros�ExpN1 - Indica se utiliza ou nao formulario proprio         ���
���          �ExpO2 - Objeto Numero do documento                          ���
���          �ExpO3 - Objeto Serie do documento                           ���
���          �ExpC4 - Numero do documento de entrada                      ���
���          �ExpC5 - Serie do documento de entrada                       ���
�������������������������������������������������������������������������͹��
���Uso       � SIGALOJA - VENDA ASSISTIDA                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Lj720AltForm(	lFormul		, oNumDoc, oSerieDoc, cNumDoc	,;
								cSerieDoc	, oChvNFE, cChvNFE	, oTpEspecie,;
								cTpEspecie	)

Local lRet	:= .T.                                // Retorno da funcao

If lFormul		// Utiliza formulario proprio
	cNumDoc		:= CriaVar("F1_DOC"		,.F.)
	cSerieDoc	:= CriaVar("F1_SERIE"	,.F.)
	cTpEspecie	:= CriaVar("F1_ESPECIE"	,.F.)
	
	oNumDoc:Refresh()
	oSerieDoc:Refresh()
	oTpEspecie:Refresh()
	
	oNumDoc:Disable()
	oSerieDoc:Disable()
	oTpEspecie:Disable()

	If ValType(oChvNFE) <> "U"
		cChvNFE	:= CriaVar("F1_CHVNFE",.F.)    
		oChvNFE:Refresh()
		oChvNFE:Disable()
	EndIf
Else
	oNumDoc:Enable()
	oSerieDoc:Enable()
	oTpEspecie:Enable()
	
	If ValType(oChvNFE) <> "U"
		oChvNFE:Enable()
	EndIf
Endif	

oNumDoc:Refresh()          
oSerieDoc:Refresh()
oTpEspecie:Refresh()

Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Lj720AltProc �Autor  � Vendas Cliente  � Data �  08/22/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao utilizada para tratar as seguintes situacoes:       ���
���          �1- Quando o usuario  trocar o tipo de processo (Troca ou De-���
���          �volucao), limpa a getdados para nao exibir dados anteriores.���
���          �2- Quando o usuario trocar a origem do processo (Com NF de  ���
���          �Origem ou Sem NF de Origem.)                                ���
�������������������������������������������������������������������������͹��
���Parametros�ExpA1 - Alias do arquivo de trabalho					      ���
���          �ExpC2 - Alias do arquivo de trabalho temporario.            ���
���          �ExpO3 - Objeto da MsGetDB                                   ���
���          �ExpL4 - Formulario proprio                                  ���
���          �ExpL5 - Compensa o titulo da NF original                    ���
���          �ExpN6 - Recno da area de trabalho                           ���
���          �ExpN7 - Tipo de operacao: 1=troca;2=devolucao				  ���
�������������������������������������������������������������������������͹��
���Uso       �SIGALOJA - VENDA ASSISTIDA.                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Lj720AltProc( cAliasTRB  ,aRecSD2   ,oGetdTRC  ,lFormul  ,;
                              lCompCR    ,nRecnoTRB ,nTpProc   )
            
Local lRet	:= .T.               // Retorno da funcao
Local nX	:= 0                 // Controle de loop

//�����������������������������������������������������������������������������Ŀ
//�Desmarca todos os produtos que foram marcados no panel de selecao de produtos�
//�������������������������������������������������������������������������������
If Len(aRecSD2) > 0
	For nX:= 1 to Len(aRecSD2)
		DbSelectArea("SD2")
		DbGoTo(aRecSD2[nX][2])
		RecLock("SD2",.F.)
		REPLACE	SD2->D2_OK WITH Space(Len(SD2->D2_OK))
		MsUnlock()                                                             
	Next nX
	aRecSD2:= {}
Endif

//��������������������������������������������������������������Ŀ
//�Limpa o arquivo de trabalho quando alterar o processo de troca�
//�e sempre inclui um registro para nao ter problemas com EOF(). �
//����������������������������������������������������������������
DbSelectArea(cAliasTRB)
If (cAliasTRB)->(LastRec()) > 0
	(cAliasTRB)->(__dbZap())
	If lNovaLj720
		nVlrTotal := 0
		oVlrTotal:Refresh()
	EndIf
	
	RecLock(cAliasTRB,.T.)
	REPLACE	TRB->TRB_ITEM WITH StrZero(1,TamSX3("D2_ITEM")[1])
	MsUnlock()  
	oGetdTRC:nCount:=(cAliasTRB)->(LastRec())
	nRecnoTRB  := Recno()
Endif
	
//��������������������������������������������������������������������������Ŀ
//�Reinicializa as variaveis do ultimo panel que foram alteradas pelo usuario�
//����������������������������������������������������������������������������
lFormul	:= .T.
lCompCR	:= SuperGetMv( "MV_LJCMPCR", NIL, .T. )
lTroca  := nTpProc == 1

Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Lj720FilSD2 �Autor  � Vendas Cliente     � Data �  16/08/05 ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza um filtro atraves da IndRegua na tabela SD2         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Parametros�ExpC1 - Codigo do Cliente                                   ���
���          �ExpC2 - Loja do Cliente                                     ���
���          �ExpD3 - Data Inicial de Compra                              ���
���          �ExpD4 - Data Final de Compra                                ���
���          �ExpO5 - Objeto Mark                                         ���
���          �ExpA6 - Array com os arquivos gravados em disco para excluir���
���          �ExpC7 - Alias da area de trabalho							  ���
���          �ExpC8 - Nome do cliente          							  ���
���          �ExpO9 - Objeto do nome do cliente          				  ���
�������������������������������������������������������������������������͹��
���Uso       �SIGALOJA - VENDA ASSISTIDA                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Lj720FilSD2( cCodCli  , cLojaCli , dDataDe   , dDataAte ,;
							 oMark    , aNomeTMP , cAliasTRB , cNomeCli ,;
							 oNomeCli , cCodFil  , nFiltroPor, cNumNF 	,;
							 cSerieNF ,	cPedido  )

Local aArea  	:= GetArea()					// Guarda area de origem
Local xRet      := {}                  			// Retorno do PE LJ720FLT       
Local lRet		:= .T.   						// Retorno da Funcao	
Local cCond 	:= ""							// Filtro da selecao do SD2
Local cIndex    := ""   						// Indice da IndRegua
Local lLJ720Flt := ExistBlock("LJ720FLT")  		// Controla se o PE LJ720FLT existe
Local lMVLJPRDSV:= SuperGetMv("MV_LJPRDSV",.F.,.F.) // Verifica se esta ativa a implementacao de venda com itens de "produto" e itens de "servico" em Notas Separadas
Local aAreaSL1 	:= {}							// Guarda area de origem do SL1
Local cDocsNot	:= "" 							// Relacao de documentos que nao devem ser trazidos no filtro do SD2
Local cFilSD2 	:= FWxFilial("SD2",cCodFil)
Local cFilSL1 	:= FWxFilial("SL1",cCodFil)

Default nFiltroPor 	:= 1
Default cNumNF		:= ""
Default cSerieNF 	:= ""

//Para selecao das NFs originais deve estar setado com 2
DbSelectArea(cAliasTRB)	
DbSetOrder(2)
	
DbSelectArea("SD2")
cIndex := CriaTrab(NIL,.F.)
cCond := "D2_FILIAL == '" + cFilSD2 + "' "
cCond += ".AND. D2_TIPO <> 'D' "
//cCond += ".AND. (D2_QUANT - D2_QTDEDEV) >= 0 "
cCond += ".AND. D2_QUANT <> D2_QTDEDEV "
If cPaisLoc == "BRA"
   cCond += ".AND.  SD2->D2_TOTAL > 0 "
Else
	cCond += ".AND. SD2->D2_REMITO <> 'NFCUP' "
Endif   

If lLJ720Flt
   xRet  := ExecBlock("LJ720FLT",.F.,.F.,{ dDataDe, dDataAte, cCodCli, cLojaCli })         
   If ValType(xRet) == "C"
      cCond  += xRet
   ElseIf ValType(xRet) == "A" .AND. LEN(xRet) == 4   
      cCond     += xRet[1]      
      cCodCli   := xRet[2]
	  cLojaCli  := xRet[3]       
	  cNomeCli  := xRet[4]       
	  oNomeCli:Refresh()
   Endif
Else
	If nFiltroPor == 1
		If !Empty(cCodCli)
		  	cCond += " .AND. D2_CLIENTE == '" + cCodCli + "' "
		Endif
		If !Empty(cLojaCli)
		  	cCond += " .AND. D2_LOJA    == '" + cLojaCli    + "' "
		Endif
		If !Empty(dDataDe)
		  	cCond += " .AND. DtoS(D2_EMISSAO) >= '" + DtoS(dDataDe)  + "'"
		Endif
		If !Empty(dDataAte)
			cCond += " .AND. DtoS(D2_EMISSAO) <= '" + DtoS(dDataAte) + "' "
		Endif
	ElseIf nFiltroPor == 2
		If !Empty(cNumNF)
		  	cCond += " .AND. D2_DOC == '" + cNumNF + "' "
		Endif
		If !Empty(cSerieNF)
		  	cCond += " .AND. D2_SERIE == '" + cSerieNF + "' "
		Endif
	Else
		If !Empty(cPedido)
		  	cCond += " .AND. D2_PEDIDO == '" + cPedido + "' "
		Endif		
	EndIf
Endif
If lMVLJPRDSV
	If !Empty(cCodCli) .And. !Empty(cLojaCli)
		aAreaSL1 := SL1->( GetArea() )			// Guarda area de origem do SL1
		
		SL1->(DbSetOrder(6)) //L1_FILIAL + L1_CLIENTE + L1_LOJA
		If SL1->(DbSeek(cFilSL1+cCodCli+cLojaCli))
			While SL1->(!EoF()) .And. SL1->L1_FILIAL+SL1->L1_CLIENTE+SL1->L1_LOJA == cFilSL1+cCodCli+cLojaCli
				If !Empty(SL1->L1_DOCRPS)
					cDocsNot += "|"+SL1->L1_DOCRPS+"|"
				EndIf
				SL1->(DbSkip())
			End
		EndIf
		
		RestArea(aAreaSL1) //Restaura a area do SL1
		
		If !Empty(cDocsNot)
			cCond += ".AND. !(SD2->D2_DOC $ '"+cDocsNot+"') " //Desconsidera os Documentos relacionados ao RPS (Nota Fiscal de Servico)
		EndIf
	EndIf
EndIf

DbSelectArea("SD2")
IndRegua("SD2",cIndex,"D2_DOC+D2_SERIE",,cCond)
#IFNDEF TOP
	dbSetIndex(cIndex+OrdBagExt())
#Endif	
DbGoTop()

If !lNovaLj720
	oMark:oBrowse:Refresh()
EndIf

//����������������������������������������������������������������Ŀ
//�Guarda os nomes dos arquivos temporarios para posterior exclusao�
//������������������������������������������������������������������
AADD(aNomeTMP,cIndex+OrdBagExt())

RestArea(aArea)

Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Lj720Mark   �Autor  � Vendas Cliente     � Data �  16/08/05 ���
�������������������������������������������������������������������������͹��
���Desc.     � Atualiza os dados do acols de acordo com os produtos       ���
���          � selecionados na NF de origem.                              ���
�������������������������������������������������������������������������͹��
���Parametros�ExpC1 - Marca do produto selecionado                        ���
���          �ExpA2 - Array com os Recnos da tabela SD2                   ���
�������������������������������������������������������������������������͹��
���Uso       �SIGALOJA - VENDA ASSISTIDA                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Lj720Mark( cMarca  ,aRecSd2, oMark, cCodFil )
Local nPosRec := 0                // Posicao do recno do SD2 no array aRecSD2 

Local nRecnoSD2 := SD2->(RECNO()) // Recno da SD2
Local nRergSL2 	:= SL2->(RECNO()) // Recno da SL2
Local cMarcaSD2	:= SD2->D2_OK   
Local aRet		:= {}
Local aSl2Area 	:= {} // Amazena a area do sl2
Local aSd2Area	:= {} // Amazena a area do sd2
Local lGE			:=  FindFunction("LjUP104OK") .AND. LjUP104OK() 		// Indica se o release e 11.5
Local cOk		:= "" 
Local cFilSL2 	:= FWxFilial("SL2",cCodFil)
local cGarantia := '' // Armazena o codigo da garantia
Default cMarca := ""
 
DbSelectArea("SD2")
RecLock("SD2",.F.)
If SD2->D2_OK <> cMarca
    If HasTemplate("OTC")
    	If !T_OTC720Mark( SD2->D2_SERIE, SD2->D2_DOC, SD2->D2_COD )	//Funcao localizado no fonte TOTCFUNC.prw
	    	MsgAlert("Produto com Movimentacao no Laboratorio","Atne��o")	//"Produto com Movimentacao no Laboratorio"
	    Else
		    REPLACE SD2->D2_OK WITH cMarca	
	    Endif
    Else
		REPLACE SD2->D2_OK WITH cMarca
	Endif 
Else                                                                                  
	REPLACE SD2->D2_OK WITH Space(Len(SD2->D2_OK))
Endif

MsUnlock()                                                             

If lGE
	aSl2Area 	:= GetArea("SL2") 
	aSd2Area	:= GetArea("SD2")

	If (SL2->(DbSetOrder(3), DbSeek( cFilSL2+SD2->D2_SERIE+SD2->D2_DOC+SD2->D2_COD ))) .And. !Empty(SL2->L2_GARANT)
		                            
		If dDataBase <= (SL2->L2_EMISSAO+SL2->L2_VLGAPRO)         				                            
			cOk := SD2->D2_OK
			SD2->(DbSkip())
			
			If	Alltrim(SD2->D2_COD)==Alltrim(SL2->L2_GARANT) .AND. !Empty(AllTrim(cOk))
			    If  SD2->D2_OK <> cOk
				Alert("Produto com Garantia Estendida. A Garantia Estendida ser� Adicionada ao Processo") //Produto com Garantia Estendida. A Garantia Estendida ser� Adicionada ao Processo
				RecLock("SD2",.F.)
				REPLACE SD2->D2_OK WITH cMarca
				MsUnlock() 
				Aadd(aRecSD2,{SD2->D2_QUANT, SD2->(Recno())})			
				EndIf			
		
			Else
				Alert("Produto com Garantia Estendida. A Garantia Estendida ser� Desmarcada do Processo") //Produto com Garantia Estendida. A Garantia Estendida ser� Desmarcada do Processo
				RecLock("SD2",.F.)
				REPLACE SD2->D2_OK WITH Space(Len(SD2->D2_OK))		
				MsUnlock()                 
			EndIf
				                      
			If Empty(SD2->D2_OK)
				nPosRec := Ascan( aRecSD2, {|x| x[2] == SD2->(Recno()) } )
				If nPosRec > 0
					aDel(aRecSd2, nPosRec )
					aSize(aRecSd2, Len( aRecSd2 ) - 1 )		
				Endif			
			EndIf
			  	
		Else
			Alert("O produto esta for� da garantia de fabrica.")//"O produto esta for� da garantia de fabrica."
			RecLock("SD2",.F.)
			REPLACE SD2->D2_OK WITH Space(Len(SD2->D2_OK))		
			MsUnlock()    			
		EndIf		
	Else
	//-- Valida o produto garantia selecionado se esta na garantia de fabrica
		cGarantia := SD2->D2_COD 			
		//Verifica se o produto e garantia
		If (SB1->(DbSetOrder(1), DbSeek( xFilial("SB1")+SD2->D2_COD ))) .And. SB1->B1_TIPO == 'GE'
		    cItPrd := StrZero( Val(SD2->D2_ITEM)-1 ,TamSx3("L2_ITEM")[1] )
			//Produra o produto vendido da garantia
			If (SL2->(DbSetOrder(3), DbSeek( cFilSL2+SD2->D2_SERIE+SD2->D2_DOC)))			
				While SL2->(!EOF()) .And. SL2->L2_DOC+SL2->L2_SERIE == SD2->D2_DOC+SD2->D2_SERIE
					If SL2->L2_ITEM == cItPrd .And. SL2->L2_GARANT == cGarantia .And. dDataBase <= (SL2->L2_EMISSAO+SL2->L2_VLGAPRO)
						Exit
					ElseIf dDataBase > (SL2->L2_EMISSAO+SL2->L2_VLGAPRO)
						Alert("O produto esta for� da garantia de fabrica.")//"O produto esta for� da garantia de fabrica."
						RecLock("SD2",.F.)
						REPLACE SD2->D2_OK WITH Space(Len(SD2->D2_OK))		
						MsUnlock()  						
						Exit
					EndIf
					SL2->(DbSkip())
				EndDo
			EndIf	
		EndIf		
	EndIf	
	RestArea(aSl2Area)
	RestArea(aSd2Area)
EndIF

If !Empty(SD2->D2_OK)
	Aadd(aRecSD2,{SD2->D2_QUANT, SD2->(Recno()) })
Else
	nPosRec := Ascan( aRecSD2, {|x| x[2] == SD2->(Recno()) } )
	If nPosRec > 0
		aDel(aRecSd2, nPosRec )
		aSize(aRecSd2, Len( aRecSd2 ) - 1 )		
	Endif
Endif	

oMark:oBrowse:refresh() 
Return 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Lj720GetStru�Autor  � Vendas Cliente     � Data �  17/08/05 ���
�������������������������������������������������������������������������͹��
���Desc.     � Monta a GetDados dos produtos a serem lancados a partir    ���
���          � da tabela SD2.                                             ���
�������������������������������������������������������������������������͹��
���Parametros�ExpA1 - aHeader necessaria para a MsGetDB                   ���
���          �ExpA2 - Array com a estrutura  da tabela temporaria         ���
���          �ExpC3 - Alias do arquivo de trabalho                        ���
���          �ExpA4 - Array com os arquivos gerados em disco para excluir.���
�������������������������������������������������������������������������͹��
���Uso       � SIGALOJA - VENDA ASSISTIDA                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Lj720GetStru(aHeaderSD2,	aStruTRB,	cAliasTRB,	aNomeTMP)
Local cNomeTRB			:= ""							// Nome do arquivo de trabalho gerado em disco.           
Local aTamD2_ITEM		:= TamSx3("D2_ITEM")			// Tamanho do campo D2_ITEM
Local aTamD2_COD		:= TamSx3("D2_COD")				// Tamanho do campo D2_COD
Local aTamB1_DESC		:= TamSx3("B1_DESC")			// Tamanho do campo B1_DESC
Local aTamD2_QTD		:= TamSx3("D2_QUANT")			// Tamanho do campo D2_QUANT
Local aTamD2_PRC		:= TamSx3("D2_PRCVEN")			// Tamanho do campo D2_PRCVEN
Local aTamD2_TOT		:= TamSx3("D2_TOTAL")			// Tamanho do campo D2_TOTAL
Local aTamD2_UM			:= TamSx3("D2_UM")				// Tamanho do campo D2_UM
Local aTamD2_TES		:= TamSx3("D2_TES")				// Tamanho do campo D2_TES
Local aTamD2_DOC		:= TamSx3("D2_DOC")				// Tamanho do campo D2_DOC
Local aTamD2_SERIE		:= TamSx3("D2_SERIE") 			// Tamanho do campo D2_SERIE
Local aTamD2_LOCAL		:= TamSx3("D2_LOCAL")			// Tamanho do campo D2_LOCAL
Local aTamD2_LOTECTL	:= TamSx3("D2_LOTECTL")			// Tamanho do campo D2_LOTECTL
Local aTamD2_NUMLOTE	:= TamSx3("D2_NUMLOTE")			// Tamanho do campo D2_NUMLOTE     
Local aTamD2_DTVALID	:= TamSx3("D2_DTVALID")			// Tamanho do campo D2_DTVALID   
Local aTamD2_CGENE      := {}					        // Tamanho do campo D2_CODGENE  
Local lMv_Rastro		:= (SuperGetMv("MV_RASTRO", Nil, "N") == "S")		// Flag de verificacao do rastro
Local nX				:= 0
Local aTamD2_VALACRS	:= TamSx3("D2_VALACRS")			// Tamanho do campo D2_VALACRS

If Hastemplate("OTC")
	aTamD2_CGENE   := TamSx3("D2_CODGENE")
Endif


AADD(aHeaderSD2, {"Item"			, "TRB_ITEM",   PesqPict("SD2","D2_ITEM"),   aTamD2_ITEM[1], aTamD2_ITEM[2], "", USADO, "C", "", " "})																				// "Item"
AADD(aHeaderSD2, {"Produto"			, "TRB_CODPRO", PesqPict("SD2","D2_COD"),    aTamD2_COD[1],  aTamD2_COD[2],  "NaoVazio() .AND. U_Lj720VldProd(M->TRB_CODPRO,TRB->TRB_QUANT)", USADO, "C", "SB1", " "})					// "Produto"
AADD(aHeaderSD2, {"Descri��o"		, "TRB_DESPRO", PesqPict("SB1","B1_DESC"),   aTamB1_DESC[1], aTamB1_DESC[2], "", USADO,"C", nil, " "})																				// "Descri��o"
AADD(aHeaderSD2, {"Quantidade"		, "TRB_QUANT",  PesqPict("SD2","D2_QUANT"),  aTamD2_QTD[1],  aTamD2_QTD[2],  "NaoVazio() .AND. Positivo() .AND. U_Lj720Trigger('TRB_QUANT',M->TRB_QUANT)",   USADO, "N", nil, " "})	// "Quantidade"
AADD(aHeaderSD2, {"Pre�o Unitario"	, "TRB_PRCVEN", PesqPict("SD2","D2_PRCVEN"), aTamD2_PRC[1],  aTamD2_PRC[2],  "NaoVazio() .AND. Positivo() .AND. U_Lj720Trigger('TRB_PRCVEN',M->TRB_PRCVEN)"	, USADO, "N", nil, " "})	// "Pre�o Unitario"
AADD(aHeaderSD2, {"Vl Acrescimo"	, "TRB_VALACR", PesqPict("SD2","D2_VALACRS"),aTamD2_VALACRS[1],aTamD2_VALACRS[2],  "Positivo()", USADO, "N", nil, " "} )															// "Vl Acrescimo"
AADD(aHeaderSD2, {"Valor do Item"	, "TRB_VLRTOT", PesqPict("SD2","D2_TOTAL"),  aTamD2_TOT[1],  aTamD2_TOT[2],  " ", USADO, "N", nil, " "} )																			// "Valor do Item"
AADD(aHeaderSD2, {"Unidade"			, "TRB_UM",     PesqPict("SD2","D2_UM"),     aTamD2_UM[1],   aTamD2_UM[2],   " ", USADO, "C", nil, " "} )																			// "Unidade"
AADD(aHeaderSD2, {"TES"				, "TRB_TES",    PesqPict("SD2","D2_TES"),    aTamD2_TES[1],  aTamD2_TES[2],  "NaoVazio() .AND. ExistCpo('SF4')", USADO, "C", "SF4", " "} )											// "TES"

//���������������������������������������Ŀ
//�Adiciona campos referentes ao Walk-Trhu�
//�����������������������������������������
AdHeadRec( "TRB", aHeaderSD2 )
//����������������������������������������������������������Ŀ
//�Se estiver utilizando rastreablidade, mostra os campos de �
//�controle de lote.                                         �
//������������������������������������������������������������
If lMv_Rastro
	AADD(aHeaderSD2,{"Lote"				,"TRB_LOTECT"	,PesqPict("SD2","D2_LOTECTL")	,aTamD2_LOTECTL[1]	,aTamD2_LOTECTL[2]	," ",USADO,"C",""," "} ) 	 //"Lote"
	AADD(aHeaderSD2,{"Sub Lote"			,"TRB_NUMLOT"	,PesqPict("SD2","D2_NUMLOTE")	,aTamD2_NUMLOTE[1]	,aTamD2_NUMLOTE[2]	," ",USADO,"C",""," "} ) 	 //"Sub Lote"
	AADD(aHeaderSD2,{"Validade do lote"	,"TRB_DTVALI"	,PesqPict("SD2","D2_DTVALID")	,aTamD2_DTVALID[1]	,aTamD2_DTVALID[2]	," ",USADO,"D",""," "} )	 //"Validade do lote"
Endif

AADD(aStruTRB,{"TRB_ITEM"		,"C",aTamD2_ITEM[1]			,aTamD2_ITEM[2]		,"01"})
AADD(aStruTRB,{"TRB_CODPRO"		,"C",aTamD2_COD[1]			,aTamD2_COD[2]		,"02"})
AADD(aStruTRB,{"TRB_DESPRO" 	,"C",aTamB1_DESC[1]			,aTamB1_DESC[2]		,"03"})
AADD(aStruTRB,{"TRB_QUANT" 		,"N",aTamD2_QTD[1]			,aTamD2_QTD[2]		,"04"})
AADD(aStruTRB,{"TRB_PRCVEN"		,"N",aTamD2_PRC[1]			,aTamD2_PRC[2]		,"05"})
AADD(aStruTRB,{"TRB_VLRTOT"		,"N",aTamD2_TOT[1]			,aTamD2_TOT[2]		,"06"})
AADD(aStruTRB,{"TRB_UM"			,"C",aTamD2_UM[1]			,aTamD2_UM[2]		,"07"})
AADD(aStruTRB,{"TRB_TES"   		,"C",aTamD2_TES[1]			,aTamD2_TES[2]		,"08"})
AADD(aStruTRB,{"TRB_NFORI"  	,"C",aTamD2_DOC[1]			,aTamD2_DOC[2]		,"10"})
AADD(aStruTRB,{"TRB_SERORI" 	,"C",aTamD2_SERIE[1]		,aTamD2_SERIE[2]	,"11"})
AADD(aStruTRB,{"TRB_LOCAL"	 	,"C",aTamD2_LOCAL[1]		,aTamD2_LOCAL[2]	,"12"})     
//����������������������������������������������������������Ŀ
//�Se estiver utilizando rastreablidade, mostra os campos de �
//�controle de lote.                                         �
//������������������������������������������������������������

If lMv_Rastro
	AADD(aStruTRB,{"TRB_LOTECT" 	,"C",aTamD2_LOTECTL[1]		,aTamD2_LOTECTL[2]	,"13"})  
	AADD(aStruTRB,{"TRB_NUMLOT" 	,"C",aTamD2_NUMLOTE[1]		,aTamD2_NUMLOTE[2]	,"14"})   
	AADD(aStruTRB,{"TRB_DTVALI" 	,"D",aTamD2_DTVALID[1]		,aTamD2_DTVALID[2]	,"15"})
	AADD(aStruTRB,{"TRB_RECNO"      ,"C",nTamRecTrb				,0					,"16"})
	AADD(aStruTRB,{"TRB_FLAG"       ,"L",1						,0					,"17"})
	//���������������������������������������Ŀ
	//�Adiciona campos referentes ao Walk-Trhu�
	//�����������������������������������������
	aAdd(aStruTRB,{"TRB_REC_WT"		,"N",10						,0,"18"})
	aAdd(aStruTRB,{"TRB_ALI_WT"		,"C",3						,0,"19"})
Else
	AADD(aStruTRB,{"TRB_RECNO"      ,"C",nTamRecTrb				,0					,"13"})
	AADD(aStruTRB,{"TRB_FLAG"       ,"L",1						,0					,"14"})
	//���������������������������������������Ŀ
	//�Adiciona campos referentes ao Walk-Trhu�
	//�����������������������������������������
	aAdd(aStruTRB,{"TRB_REC_WT"		,"N",10						,0,"15"})
	aAdd(aStruTRB,{"TRB_ALI_WT"		,"C",3						,0,"16"})
EndIf	

 If Hastemplate ("OTC")
    AADD(aStruTRB,{"TRB_CODGEN"	 	,"C",aTamD2_CGENE[1]		,aTamD2_CGENE[2]	, If(lMv_Rastro, "20","17")})  
 EndIf
 
aAdd(aStruTRB,{"TRB_VALACR", "N", aTamD2_VALACRS[1], aTamD2_VALACRS[2], "18"})

//+-------------------------------------------+
//|Ponto de Entrada para modificar a estrutura|
//+-------------------------------------------+
If FindFunction("U_LJ720STR")
   xRet  := U_LJ720STR(aHeaderSD2, aStruTRB)
   If ValType(xRet) == "A" .AND. Len(xRet) == 2 .AND. ValType(xRet[1]) == "A" .AND. ValType(xRet[2]) == "A"
      For nX := 1 To Len(xRet[1])
      	If ValType(xRet[1, nX]) == "A" .AND. Len(xRet[1, nX]) == 10
				aAdd(aHeaderSD2, xRet[1, nX])
			EndIf
		Next
      For nX := 1 To Len(xRet[2])
      	If ValType(xRet[2, nX]) == "A" .AND. Len(xRet[2, nX]) == 5
				aAdd(aStruTRB, xRet[2, nX])
			EndIf
		Next
   Endif
EndIf 
 
//�����������������������������������������������Ŀ
//�Cria o arquivo temporario com base na estrutura�
//�������������������������������������������������
If Select(cAliasTRB) > 0
	(cAliasTRB)->( DbCloseArea() )
Endif

cNomeTrb	:= CriaTrab(aStruTRB,.T.)
DbUseArea(.T.,,cNomeTrb,cAliasTRB,.F.)

cNomInd1:=Left(cNomeTRB,7)+"A"
IndRegua(cAliasTRB,cNomInd1,"TRB_RECNO") 

cNomInd2:=Left(cNomeTRB,7)+"B"
IndRegua(cAliasTRB,cNomInd2,"TRB_ITEM")   

DbClearIndex()
DbSetIndex(cNomInd1+OrdBagExt())
DbSetIndex(cNomInd2+OrdBagExt())

//����������������������������������������������������������������Ŀ
//�Guarda os nomes dos arquivos temporarios para posterior exclusao�
//������������������������������������������������������������������
AADD(aNomeTMP,cNomeTrb+GetDbExtension())

Return(.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Lj720GetDB  �Autor  � Vendas Cliente     � Data �  16/08/05 ���
�������������������������������������������������������������������������͹��
���Desc.     � Atualiza os dados na tabela temporaria de acordo com os    ���
���          � produtos selecionados na NF de origem.                     ���
���          � Executado no Next do panel 2 (MsSelect da selecao dos prod)���
�������������������������������������������������������������������������͹��
���Parametros�ExpA1 - Array com os Recno de registros da tabela SD2       ���
���          �ExpA2 - Alias do arquivo de trabalho                        ���
���          �ExpO3 - Objeto da MsGetDB                                   ���
���          �ExpN4 - Recno da area de trabalho                           ���
�������������������������������������������������������������������������͹��
���Uso       �SIGALOJA - VENDA ASSISTIDA                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Lj720GetDB(aRecSd2, cAliasTRB, oGetdTRC, nRecnoTRB, cCodFil, nVlrTotal, lValTroca)
Local nX          := 0			// Contador do for
Local lRet        := .T.		// Retorno da funcao
Local lSeek       := .T.		// Controle de lock na tabela de trabalho
Local cMV_LJDVACR := AllTrim(SuperGetMV("MV_LJDVACR",,""))  // Define se considera acrescimo financeiro na devolucao
Local lMv_Rastro  := (SuperGetMv( "MV_RASTRO", Nil, "N" ) == "S")		// Flag de verificacao do rastro
Local cFilSB1 	  := ""

Default cCodFil   := cFilAnt
Default lValTroca := .F.

cFilSB1 := FWxFilial("SB1",cCodFil)

If lNovaLj720
	nVlrTotal := 0
EndIf

DbSelectArea(cAliasTRB)
DbSetOrder(2)
DbGoTop()

(cAliasTRB)->(__dbZap())

If Len(aRecSD2) > 0
	ASort(aRecSD2,,,{|x,y| x[2]< y[2]})
Endif

For nX := 1 to Len(aRecSd2)

	DbSelectArea("SD2")
	DbGoTo(aRecSd2[nX][2])
	RecLock(cAliasTRB,lSeek)

	REPLACE	TRB->TRB_CODPRO	WITH SD2->D2_COD
	REPLACE	TRB->TRB_ITEM	WITH SD2->D2_ITEM
	REPLACE	TRB->TRB_DESPRO	WITH Posicione("SB1",1,cFilSB1+SD2->D2_COD,"B1_DESC")
	REPLACE	TRB->TRB_QUANT 	WITH IIf(lValTroca,1,Max(SD2->D2_QUANT - SD2->D2_QTDEDEV, 0))
	//�����������������������������������������������������������������������Ŀ
	//�Se  par�metro MV_LJDVACR=="1" Deve desconsiderar o acrescimo financeiro�
	//�������������������������������������������������������������������������
	If cMV_LJDVACR == "1"
		REPLACE	TRB->TRB_PRCVEN	WITH SD2->D2_PRCVEN - SD2->D2_VALACRS
	Else
		REPLACE	TRB->TRB_PRCVEN	WITH SD2->D2_PRCVEN
	Endif

	//Calculo quando o Juros esta seprado do Valor total (MV_LJICMJR):
	If GetRpoRelease() >= "R5" .And. cPaisLoc == "BRA" .And. SuperGetMv("MV_LJICMJR",,.F.)
		REPLACE	TRB->TRB_VALACR	WITH A410Arred(LJ720VlAcresc(SD2->D2_SERIE+SD2->D2_DOC, (TRB->TRB_QUANT * TRB->TRB_PRCVEN)) ,"D2_VALACRS")
		REPLACE	TRB->TRB_VLRTOT	WITH A410Arred((TRB->TRB_QUANT * TRB->TRB_PRCVEN)+TRB->TRB_VALACR ,"D2_TOTAL")
	Else
		REPLACE	TRB->TRB_VLRTOT	WITH A410Arred(TRB->TRB_QUANT * TRB->TRB_PRCVEN ,"D2_TOTAL")
	EndIf

	REPLACE	TRB->TRB_UM    	WITH SD2->D2_UM
	REPLACE	TRB->TRB_TES   	WITH SD2->D2_TES
	REPLACE	TRB->TRB_NFORI 	WITH SD2->D2_DOC
	REPLACE	TRB->TRB_SERORI	WITH SD2->D2_SERIE

	If lMv_Rastro
		REPLACE	TRB->TRB_LOTECT	WITH SD2->D2_LOTECTL
		REPLACE	TRB->TRB_NUMLOT	WITH SD2->D2_NUMLOTE
		REPLACE	TRB->TRB_DTVALI WITH SD2->D2_DTVALID
	EndIf

	REPLACE	TRB->TRB_LOCAL 	WITH SD2->D2_LOCAL
	REPLACE	TRB->TRB_RECNO 	WITH AllTrim(StrZero(aRecSd2[nX][2],nTamRecTrb))
	REPLACE TRB->TRB_REC_WT	WITH SD2->( Recno() )
	REPLACE TRB->TRB_ALI_WT	WITH "SD2"
	If HasTemplate("OTC")
		REPLACE TRB->TRB_CODGENE WITH SD2->D2_CODGENE
	EndIf		
	MsUnlock()
	
	If lNovaLj720
		nVlrTotal += TRB->TRB_VLRTOT
	EndIf
	
	oGetdTRC:nCount++
	If nX == 1
		nRecnoTRB  := Recno()
	Endif
Next nX

DbSelectArea(cAliasTRB)
DbSetOrder(2)
oGetdTRC:nMax:=(cAliasTRB)->(RecCount())
DbGoTop()

oGetdTRC:oBrowse:Refresh()
oGetdTRC:ForceRefresh()
oGetdTRC:oBrowse:SetFocus()

Return (lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Lj720GetOk  �Autor  � Vendas Cliente   � Data �  08/23/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida os itens digitados ou selecionados no panel 3       ���
���          �que contem os produtos a serem trocados/devolvidos.         ���
�������������������������������������������������������������������������͹��
���Parametros�ExpC1 - Alias do arquivo temporario.                        ���
���          �ExpA2 - Array com o Recno e a quantidade a ser devolvida    ���
���          �ExpN3 - Valor total de mercadorias.                         ���
���          �ExpN4 - Recno da area de trabalho                           ���
�������������������������������������������������������������������������͹��
���Uso       � SIGALOJA - VENDA ASSISTIDA                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Lj720GetOk( cAliasTRB  	,aRecSD2   	,nVlrTotal  ,nRecnoTRB,;
							nNfOrig		,nTpProc	 )

Local lRet			:= .T.       								// Retorno da funcao
Local aAreaTRB		:= (cAliasTRB)->(GetArea())   				// Guarda a area
Local cCampos		:= "TRB_UM/TRB_TES/TRB_ALI_WT/TRB_REC_WT"	// Campos que nao sao obrigatorios
Local nPos			:= 0										// Posicao do Recno.
Local nX			:= 0										// Controle do For 
Local lContinua 	:= .T.										// Se passa para a proxima tela
Local cMV_LJDVACR	:= AllTrim(SuperGetMV("MV_LJDVACR",,""))  	// Define se considera acrescimo financeiro na devolucao
Local lMv_Rastro	:= If( SuperGetMv( "MV_RASTRO", Nil, "N" ) == "S", .T., .F. )		// Flag de verificacao do rastro
Local lGE			:=  FindFunction("LjUP104OK") .AND. LjUP104OK() 		// Indica se o release e 11.5

If (nTpProc==3 .Or. nTpProc==4) .And. nVlrTotal==0
	lRet:= .F.
	MsgStop("� necess�rio informar o campo valor das mercadorias.","Aten��o")
Endif

If lRet

	DbSelectArea(cAliasTRB)
	DbGoTo(nRecnoTRB)
	If TRB->(Eof())
		lRet:= .F.
		MsgStop("Algum campo obrigat�rio n�o foi informado.","Aten��o")//"Algum campo obrigat�rio n�o foi informado." ##"Aten��o"
	Else 
		If(nTpProc <> 3 .And. nTpProc <> 4)
			DbGoTo(nRecnoTRB)
			While TRB->(!Eof()) .AND. lContinua
				If !TRB->TRB_FLAG .AND. !Empty(TRB->TRB_CODPRO)
					lContinua := .F.
				Endif
				TRB->(DbSkip())		
			End
		Else
			lContinua := .F.
		Endif
		If lContinua 
			lRet:= .F.	
			MsgStop("Algum campo obrigat�rio n�o foi informado.","Aten��o")//"Algum campo obrigat�rio n�o foi informado." ##"Aten��o"
		Endif
	Endif

Endif

//If (nTpProc<>3 .And. nTpProc<>4)
nVlrTotal:= 0
//Endif

If cMV_LJDVACR == "1"

	DbGoTo(nRecnoTRB)	
	While !Eof() .AND. lRet
	
		If nNfOrig == 2   
			//�����������������������������������������������������������Ŀ
			//�Para Devol sem doc de entrada , valida se o codigo do prod �
			//�������������������������������������������������������������
        	If !TRB->TRB_FLAG .AND. Empty( TRB->TRB_CODPRO ) 
				RecLock("TRB",.F.)     	
				REPLACE TRB_FLAG WITH .T.          // Marca como deletado
				MsUnlock()
			EndIf

			If !TRB->TRB_FLAG
				If !Empty(TRB->TRB_RECNO)
					nPos := Ascan( aRecSD2, {|x| StrZero(x[2],nTamRecTrb) == TRB->TRB_RECNO } )  
			        If nPos > 0
			        	If aRecSD2[nPos][1] <> TRB->TRB_QUANT
							lRet := .F.
							//"O par�metro MV_LJDVACR est� habilitado. N�o ser� poss�vel realizar uma devolu��o parcial, somente total."
							MsgAlert("O par�metro MV_LJDVACR est� habilitado. N�o ser� poss�vel realizar uma devolu��o parcial, somente total.","Atne��o")
						EndIf
			        Endif
			    Endif    	
			Endif    
	    
	    Else
			If !TRB->TRB_FLAG
				If !Empty(TRB->TRB_RECNO)
					nPos := Ascan( aRecSD2, {|x| StrZero(x[2],nTamRecTrb) == TRB->TRB_RECNO } )  
			        If nPos > 0
			        	If aRecSD2[nPos][1] <> TRB->TRB_QUANT
							lRet := .F.
							//����������������������������������������������������������������������������������������������������������Ŀ
							//�"O par�metro MV_LJDVACR est� habilitado. N�o ser� poss�vel realizar uma devolu��o parcial, somente total."�
							//������������������������������������������������������������������������������������������������������������
							MsgAlert("O par�metro MV_LJDVACR est� habilitado. N�o ser� poss�vel realizar uma devolu��o parcial, somente total.","Atne��o")
						EndIf
			        Endif
			    Endif    	
            EndIf
		EndIf
    
		DbSkip()    	
	    Loop
    End

Else

	DbGoTo(nRecnoTRB)	
	While !Eof() .AND. lRet
	    
	    If nNfOrig == 2
			//�����������������������������������������������������������Ŀ
			//�Para Devol sem doc de entrada , valida se o codigo do prod �
			//�������������������������������������������������������������
        	If !TRB->TRB_FLAG .AND. Empty( TRB->TRB_CODPRO ) 
				RecLock("TRB",.F.)     	
				REPLACE TRB_FLAG WITH .T.		// Marca como deletado
				MsUnlock()
			EndIf
			
			If !TRB->TRB_FLAG
				If SuperGetMv("MV_LJFNGE",,.F.) .AND. lGe .And. FindFunction("LJ7GrvMFI") .And. AliasIndic("MFI")
					
					//Valida o valor a ser pago para o cliente com garantia estendida
					SL2->(DbSetOrder(3))	
					If SL2->(DbSeek(xFilial("SL2")+TRB->TRB_SERORI+TRB->TRB_NFORI+TRB->TRB_CODPRO+TRB->TRB_ITEM))
						SB1->(DbSetOrder(1))
						SB1->(DbSeek(xFilial("SB1")+TRB->TRB_CODPRO))
						//Valida se o produto eh garantia
						If SB1->B1_TIPO == 'GE'
							MFI->(DbSetOrder(2))
							//Efetua as conficoes de vigencia para somar no valor total
							//If MFI->(DbSeek(xFilial("MFI")+TRB->TRB_NFORI+TRB->TRB_SERORI+TRB->TRB_ITEM))								
							If MFI->(DbSeek(xFilial("MFI")+cFilAnt+TRB->TRB_NFORI+TRB->TRB_SERORI+TRB->TRB_ITEM))//verifica aqui a filial origem								
								//Valida se esta na vigencia
								If MFI->MFI_DTVIGE < dDataBase .And. dDataBase <= MFI->MFI_FIMVIG 
									//nCalcGar:=	MFI->MFI_VLRITE - ( (MFI->MFI_VLRITE/MFI->MFI_DIAGAR)*(dDataBase-MFI->MFI_DTVIGE) ) 
									nVlrTotal+=	MFI->MFI_VLRITE - ( (MFI->MFI_VLRITE/MFI->MFI_DIAGAR)*(dDataBase-MFI->MFI_DTVIGE) ) 
								ElseIf dDataBase > MFI->MFI_FIMVIG 
									nVlrTotal+= 0
								ElseIf  MFI->MFI_DTVIGE > dDataBase
									nVlrTotal+= TRB_VLRTOT	
								EndIf	
							EndIf
						Else
					   		nVlrTotal+= TRB_VLRTOT			
						EndIf
						
					EndIf			
				Else
					nVlrTotal+= TRB_VLRTOT
			    EndIf
				
				//Calculo quando o Juros esta seprado do Valor total (MV_LJICMJR):
				If GetRpoRelease() >= "R5" .And. cPaisLoc == "BRA" .And. SuperGetMv("MV_LJICMJR",,.F.)
					nVlrTotal-=	TRB->TRB_VALACR
				EndIf
				
				//����������������������������������������������������������������������������������������Ŀ
				//�Atualiza no array aRecSD2 a quantidade a ser devolvida de acordo com o que foi digitado �
				//������������������������������������������������������������������������������������������
				If !Empty(TRB->TRB_RECNO)
					nPos := Ascan( aRecSD2, {|x| StrZero(x[2],nTamRecTrb) == TRB->TRB_RECNO } )  
			        If nPos > 0
			        	aRecSD2[nPos][1]:= TRB->TRB_QUANT
			        Endif
			    Endif    	
				
				For nX:= 1 to Len(aHeader)
			    	If Empty(&(aHeader[nX][2])) .AND. !(AllTrim(aHeader[nX][2]) $ cCampos) .AND. Rastro( TRB->TRB_CODPRO, "S" ) 
			    		lRet:= .F.
			    		MsgStop("Algum campo obrigat�rio n�o foi informado.","Aten��o")//"Algum campo obrigat�rio n�o foi informado." ##"Aten��o"
			    		Exit
			    	Endif	
				Next nX
				If lMv_Rastro
					//�����������������������������������������������������������Ŀ
					//�Verifica se os produtos da troca/devolucao possuem controle�
					//�de lote e/ou sub-lote.                                     �
					//�������������������������������������������������������������
					For nX:= 1 to Len(aHeader)
				    	If ( aHeader[nX][2] == "TRB_NUMLOT" .AND. Empty(&(aHeader[nX][2])) .AND.  Rastro( TRB->TRB_CODPRO, "S" ) ) .OR.; 
				    		( aHeader[nX][2] == "TRB_LOTECT" .AND. Empty(&(aHeader[nX][2])) .AND.  Rastro( TRB->TRB_CODPRO ) ) 
				    		lRet:= .F.
				    		MsgStop("Numero do lote/sub-lote nao informado.","Aten��o")//"Numero do lote/sub-lote nao informado." ##"Aten��o"
				    		Exit
				    	Endif	 
					Next nX   
				
					//�����������������������������������������������������������Ŀ
					//�Verifica se o produto usa Rastreabilidade, se nao usar deve�
					//�zerar o TRB->TRB_DTVALI.                                   �
					//�������������������������������������������������������������

					If !Rastro( TRB->TRB_CODPRO )
						RecLock("TRB",.F.)     	
						REPLACE TRB_DTVALI WITH CToD( " " ) 
						MsUnlock()
					EndIf	
				EndIf
			Endif    
		Else
			If !TRB->TRB_FLAG
				nVlrTotal+= TRB_VLRTOT

				//Calculo quando o Juros esta seprado do Valor total (MV_LJICMJR):
				If GetRpoRelease() >= "R5" .And. cPaisLoc == "BRA" .And. SuperGetMv("MV_LJICMJR",,.F.)
					nVlrTotal-=	TRB->TRB_VALACR
				EndIf
				//����������������������������������������������������������������������������������������Ŀ
				//�Atualiza no array aRecSD2 a quantidade a ser devolvida de acordo com o que foi digitado �
				//������������������������������������������������������������������������������������������
				If !Empty(TRB->TRB_RECNO)
					nPos := Ascan( aRecSD2, {|x| StrZero(x[2],nTamRecTrb) == TRB->TRB_RECNO } )  
			        If nPos > 0
			        	aRecSD2[nPos][1]:= TRB->TRB_QUANT
			        Endif
			    Endif    	
				
				If lMV_Rastro .AND. Rastro(TRB->TRB_CODPRO)
					For nX:= 1 to Len(aHeader)
						If AllTrim(aHeader[nX][2]) == "TRB_LOTECT" .AND. Rastro(TRB->TRB_CODPRO, "L") .AND. Empty(TRB->TRB_LOTECT)
	                    	lRet := .F.
						ElseIf AllTrim(aHeader[nX][2]) == "TRB_NUMLOT" .AND. Rastro(TRB->TRB_CODPRO, "S") .AND. Empty(TRB->TRB_NUMLOT)
							lRet := .F.
				    	Endif	
						If !lRet
							Exit
						EndIf
					Next nX
					If !lRet
				    	MsgStop("Algum campo obrigat�rio n�o foi informado.","Aten��o")//"Algum campo obrigat�rio n�o foi informado." ##"Aten��o"
					EndIf
				EndIf 
			EndIf									
		Endif    
	
		DbSkip()
	End
EndIf

RestArea(aAreaTRB)
Return (lRet)
                          
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Lj720MsSelOk�Autor  � Vendas Cliente   � Data �  08/23/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida se os itens selecionados na MsSelect pertencem ao   ���
���          �mesmo documento de saida.                                   ���
�������������������������������������������������������������������������͹��
���Parametros�ExpA1: Array com os recnos da tabela SD2                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � SIGALOJA - VENDA ASSISTIDA                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Lj720MsSelOk(aRecSD2)
Local aAreaSD2	:= SD2->(GetArea())     	// Area atual do SD2
Local lRet		:= .T.                  	// Retorno da funcao
Local cDoc		:= ""                   	// Numero do documento de NF original
Local nX		:= 0                    	// Controle de loop
                                 
If Len(aRecSD2) >0
	
	For nX:= 1 to Len(aRecSD2)
		        
		DbSelectArea("SD2")
		DbGoTo(aRecSD2[nX][2])
		
		If Empty(cDoc)
			cDoc:= SD2->D2_DOC	
		Endif
			
		If !Empty(cDoc) .AND. cDoc <> SD2->D2_DOC
			MsgStop("Favor selecionar apenas mercadorias que perten�am a um mesmo documento de sa�da","Aten��o")//"Favor selecionar apenas mercadorias que perten�am a um mesmo documento de sa�da"##"Aten��o"
			lRet:= .F.		
		Endif	
				   
	Next nX
Else
	MsgAlert("Pelo menos um item deve ser selecionado.","Atne��o") //"Pelo menos um item deve ser selecionado."
	lRet:= .F.
Endif
		
RestArea(aAreaSD2)

Return (lRet)

/*                        
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Lj720CfgDb�Autor  � Vendas Cliente     � Data �  08/23/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Altera a propriedade do objeto quando for alterado o       ���
���          �processo de troca.                                          ���
�������������������������������������������������������������������������͹��
���Parametros�ExpN1 - Origem do documento de entrada.                     ���
���          �ExpO2 - Objeto da MsGetDB                                   ���
�������������������������������������������������������������������������͹��
���Uso       � SIGALOJA - VENDA ASSISTIDA                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Lj720CfgDb(nNfOrig, oGetdTRC , nPanel , aRecSd2 , nTpProc )

Local lMv_Rastro 	:= (SuperGetMv( "MV_RASTRO", Nil, "N" ) == "S")		// Flag de verificacao do rastro.
Local nX			:= 0
Local nCount        := 0                                                // Contador
Local lConsPadr     := .F.                                              // Verifica se possui consulta padrao

Default nPanel 		:=	0
Default aRecSd2		:=  {}

Do Case

	Case nNfOrig == 1    //Com NF de Origem
		oGetdTRC:lNewLine 		:= .F.
		oGetdTRC:lDeleta  		:= .F.
		oGetdTRC:nMax     		:= 999
		oGetdTRC:aAlter			:= {"TRB_QUANT","TRB_TES"}   //Campos que podem ser alterados
		oGetdTRC:oBrowse:aAlter	:= {"TRB_QUANT","TRB_TES"}  
	Case nNfOrig == 2  	  // Sem NF de Origem		
		oGetdTRC:lNewLine 		:= .F.
		oGetdTRC:lDeleta  		:= .T.
		oGetdTRC:nMax     		:= 999
		oGetdTRC:aAlter			:= {"TRB_CODPRO","TRB_QUANT","TRB_PRCVEN","TRB_TES"} //Campos que podem ser alterados
		oGetdTRC:oBrowse:aAlter	:= {"TRB_CODPRO","TRB_QUANT","TRB_PRCVEN","TRB_TES"} //Campos que podem ser alterados
	   
		If lMv_Rastro 
			aAdd( oGetdTRC:aAlter, "TRB_LOTECT")
			aAdd( oGetdTRC:oBrowse:aAlter, "TRB_LOTECT") 
		Endif			
Endcase

//Desabilitar Grid quando selecionaod a op��o NCC ou NDC
If nTpProc == 3 .Or. nTpProc == 4
	oGetdTRC:lNewLine 		:= .F.
	oGetdTRC:lDeleta  		:= .F.
	oGetdTRC:nMax     		:= 999
	oGetdTRC:aAlter			:= {} //Campos que podem ser alterados
	oGetdTRC:oBrowse:aAlter	:= {} //Campos que podem ser alterados
Endif

//+------------------------------------------------+
//|Ponto de Entrada para permitir edicao de colunas|
//+------------------------------------------------+
If FindFunction("U_LJ720ALT")
	xRet  := U_LJ720ALT(@lConsPadr)
    If ValType(xRet) == "A" .AND. Len(xRet) == 2 .AND. ValType(xRet[1]) == "A" .AND. ValType(xRet[2]) == "A" .AND. !lConsPadr
	  	For nX := 1 To Len(xRet[1])
	  		If ValType(xRet[1, nX]) == "C"
				aAdd(oGetdTRC:aAlter, xRet[1, nX])
			   
	   		EndIf	  
		Next
	   	For nX := 1 To Len(xRet[2])
	   		If ValType(xRet[2, nX]) == "C"
				aAdd(oGetdTRC:oBrowse:aAlter, xRet[2, nX])
			EndIf
		Next  
	ElseIf ValType(xRet) == "A" .AND. lConsPadr    // Caso possua consulta padrao F3
		For  nCount := 1 To Len(xRet)
	  		aAdd(oGetdTRC:aAlter, xRet[nCount,1][1])
			aAdd(oGetdTRC:oBrowse:aAlter, xRet[nCount,2][1])
			oGetdTRC:aInfo[xRet[nCount,3,1]][1] := xRet[nCount,4][1]
		Next nCount
	EndIf			  
EndIf

oGetdTRC:oBrowse:Refresh()
oGetdTRC:ForceRefresh()
	
If nPanel == 1
	//�����������������������������������������������������������������������������Ŀ
	//�Desmarca todos os produtos que foram marcados no panel de selecao de produtos�
	//�������������������������������������������������������������������������������
	If Len(aRecSD2) > 0
		For nX:= 1 to Len(aRecSD2)
			DbSelectArea("SD2")
			DbGoTo(aRecSD2[nX][2])
			RecLock("SD2",.F.)
			REPLACE	SD2->D2_OK WITH Space(Len(SD2->D2_OK))
			MsUnlock()                                                             
		Next nX
		aRecSD2:= {}
	Endif
EndIf	
	
Return(.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Lj720Trigger�Autor  � Vendas Cliente     � Data �  08/24/05 ���
�������������������������������������������������������������������������͹��
���Desc.     �- Gatilha o campo descricao do produto, UM e TES.           ���
���          �- Executa o calculo do valor total do item baseado na       ���
���          � quantidade e no preco unitario digitado.                   ���
�������������������������������������������������������������������������͹��
���Parametros�ExpC1 - Campo a ser tratado                                 ���
���          �ExpC2 - Valor referente ao campo                            ���
���          �ExpN3 - Quantidade referente ao campo                       ���
�������������������������������������������������������������������������͹��
���Uso       � SIGALOJA - VENDA ASSISTIDA.                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Lj720Trigger( cCampo  ,cValor  ,nQuant )

Local lRet			:= 	.T.								// Retorno da funcao
Local cTesSai		:= SuperGetMV("MV_TESSAI")			// Pega do parametro o TES padrao para saida
Local cTesInt		:= ""								// Codigo do Tes de saida
Local cTabPrecos    := ""                               // Tabela de preco utilizada no caso de possuir cenario de venda
Local nPrcVenda     := ""                               // Preco de venda
Local cCliente      := ""                               // Cliente 
Local cLoja      	:= ""                               // Loja 
Local nMoeda        := 1                                // Moeda definada como 1 pois o cenario de venda somente existe para o Brasil

Default nQuant  		:= 1
     
If TRB->TRB_FLAG //Se tiver DELETADO nao permite alterar
	MsgStop("Item exclu�do n�o pode ser alterado.") //"Item exclu�do n�o pode ser alterado."
	lRet:= .F.
EndIf

If lRet
	
	Do Case
	
		Case cCampo $ "TRB_CODPRO"
	
			SB1->(DbSetOrder(1))
			SB1->(DbSeek(xFilial("SB1")+cValor))
			cCliente := SA1->A1_COD
			cLoja    := SA1->A1_LOJA
			//�������������������������������������������Ŀ
			//�Parametro da funcao MaTesInt               �
			//�ExpN1 = Documento de 1-Entrada / 2-Saida   �
			//�ExpC1 = Tipo de Operacao Tabela "DJ" do SX5�
			//�ExpC2 = Codigo do Cliente ou Fornecedor    �
			//�ExpC3 = Codigo do gracao E-Entrada         �
			//�ExpC4 = Tipo de Operacao E-Entrada         �
			//���������������������������������������������
			cTesInt := MaTesInt( 2	,Padr("6",2)	,cCliente	,cLoja	,;
							     "C",SB1->B1_COD	,NIL)
	
			If !Empty(cTesInt)
				cTesPad := cTesInt
			Else
				If Empty( SB1->B1_TS )
					cTesPad := cTesSai
				Else
					cTesPad := SB1->B1_TS
				EndIf
			Endif
			
			If lNovaLj720 .And. !Empty(TRB->TRB_CODPRO)
				nVlrTotal -= TRB->TRB_VLRTOT
			EndIf
			
			RecLock("TRB",.F.)
			REPLACE	TRB->TRB_CODPRO	WITH cValor
			REPLACE	TRB->TRB_DESPRO	WITH SB1->B1_DESC
			REPLACE	TRB->TRB_UM		WITH SB1->B1_UM
			REPLACE	TRB->TRB_TES	WITH cTesPad
			REPLACE	TRB->TRB_QUANT	WITH nQuant
		   	
		   	// No caso de utilizar o cenario de venda busca o preco da tabela de preco utilizada 
		   	If lCenVenda
				cTabPrecos := LjXETabPre(cCliente, cLoja) 
				//�����������������������������������������������������������������������Ŀ
				//�Retorna o valor da tabela de preco DA1 de acordo com a moeda utilizada.�
				//�caso nao encontre a tabela de preco retorna o valor do B0_PRV          �
	   			//�������������������������������������������������������������������������
		   		nPrcVenda := MaTabPrVen( cTabPrecos		,cValor		,nQuant			,cCliente	,; 
										cLoja			,nMoeda		, /*dDataVld*/	,/*nTipo*/	,;
										/*lExec*/	)
	   		Else                                                      
				nPrcVenda := Posicione("SB0",1,xFilial("SB0")+cValor,"B0_PRV1")
	   		EndIf 
	   		
			REPLACE	TRB->TRB_PRCVEN	WITH nPrcVenda
			REPLACE	TRB->TRB_VLRTOT	WITH A410Arred(TRB->TRB_QUANT * TRB->TRB_PRCVEN ,"D2_TOTAL")		
			MsUnlock()
			
			If lNovaLj720
				nVlrTotal += TRB->TRB_VLRTOT
			EndIf
	
		Case cCampo $ "TRB_QUANT"
	        
			//�����������������������������������������������������������������������������������������������������������������������Ŀ
			//�Nao permite que a quantidade seja alterada com um valor maior que o saldo a devolver existente na nota fiscal original.�
			//�������������������������������������������������������������������������������������������������������������������������
			If !Empty(TRB->TRB_RECNO) 
				DbSelectArea("SD2")
				DbGoTo(Val(TRB->TRB_RECNO))
				If cValor > ( SD2->D2_QUANT - SD2->D2_QTDEDEV )
					lRet:= .F.
					MsgStop("A quantidade digitada � insuficiente de acordo com o saldo disponivel para devolu��o","Aten��o")//"A quantidade digitada � insuficiente de acordo com o saldo disponivel para devolu��o"##"Aten��o"
				Else
					If lNovaLj720
						nVlrTotal -= TRB->TRB_VLRTOT
					EndIf
					RecLock("TRB",.F.)
					REPLACE TRB->TRB_VLRTOT	WITH A410Arred(cValor * TRB->TRB_PRCVEN ,"D2_TOTAL")
					MsUnlock()
					If lNovaLj720
						nVlrTotal += TRB->TRB_VLRTOT
					EndIf
				Endif
			Else 		
				If lNovaLj720
					nVlrTotal -= TRB->TRB_VLRTOT
				EndIf
				RecLock("TRB",.F.)
				REPLACE	TRB->TRB_VLRTOT	WITH A410Arred(cValor * TRB->TRB_PRCVEN ,"D2_TOTAL")
				MsUnlock()
				If lNovaLj720
					nVlrTotal += TRB->TRB_VLRTOT
				EndIf
		    Endif
	
		Case cCampo $ "TRB_PRCVEN"
			
			If lNovaLj720
				nVlrTotal -= TRB->TRB_VLRTOT
			EndIf
			
			RecLock("TRB",.F.)
			REPLACE	TRB->TRB_VLRTOT	WITH A410Arred(TRB->TRB_QUANT * cValor ,"D2_TOTAL")
			MsUnlock()
	
			If lNovaLj720
				nVlrTotal += TRB->TRB_VLRTOT
			EndIf
	EndCase
	
	If lNovaLj720
		oVlrTotal:Refresh()
	EndIf
	
EndIf

Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Lj720concluir �Autor  � Vendas Cliente  � Data �  17/08/05  ���
�������������������������������������������������������������������������͹��
���Desc.     �Execucao da rotina que ira gerar a nota fiscal de entrada e ���
���          �chamada da rotina de venda assistida.                       ���
�������������������������������������������������������������������������͹��
���Parametros�ExpN1 - Tipo do processo de troca.                          ���
���          �ExpN2 - Origem do documento de entrada                      ���
���          �ExpC3 - Codigo do cliente                                   ���
���          �ExpC4 - Codigo da loja                                      ���
���          �ExpA5 - Array com os Recnos da tabela SD2                   ���
���          �ExpL6 - Indica se eh formulario proprio ou nao              ���
���          �ExpC7 - Numero do documento de entrada                      ���
���          �ExpO8 - Serie do documento de entrada                       ���
���          �ExpL9 - Indica se ira compensar a NCC com o titulo da NF.   ���
���          �ExpL10- Se a rotina foi executada pela venda assistida.     ���
���          �EXpA11: Armazena a serie, numero e cliente+loja da NF de    ���
���          � 		  devolucao e o tipo de operacao(1=troca;2=devolucao) ��� 
���          �ExpN12- Forma de devolucao ao cliente: 1-Dinheiro;2-NCC     ���
���          �ExpN13- Valor total de produtos a serem trocados ou         ���
���          �        devolvidos    								      ���
���          �ExpL14- Devolve em varias moedas.                           ���
���          �ExpN15- Moeda corrente                                      ���
���          �ExpN16- Taxa da moeda corrente                              ���
�������������������������������������������������������������������������͹��
���Uso       � SIGALOJA - VENDA ASSISTIDA                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Lj720Concluir(	nTpProc		, nNfOrig	, cCodCli  		, cLojaCli	,;
 								aRecSD2		, lFormul	, cNumDoc  		, cSerieDoc	,;
 								lCompCR		, aDocDev   , nFormaDev	,;
 								nVlrTotal	, lDevMoeda	, nMoedaCorT	, nTxMoedaTr,;
 								cCodDia		, cMotivo 	, nImpostos  	, cChvNFE	,;
 								cTpEspecie 	, cCodFil 	, cNrChamado	, cObs		,;
 								cTpAcao, cOcorr	)

Local lRet			:= .T.							   		//Retorno da funcao
Local aArea			:= GetArea()							//Armazena o posicionamento atual
Local aAreaSD2		:= SD2->(GetArea())					//Guarda a area do SD2
Local nI			:= 0					   				//Contador 
Local lMv_LJVLDEV   := SuperGetMv("MV_LJVLDEV")				//Indica se sera validado a existencia de saldo em dinheiro em caixa para realizar a devolucao.
Local lRestArea     := .F.                    				//Controla se deve restaurar a area da MATXFIS
Local lLojr860	    := ExistBlock("LOJR860") .And. SuperGetMv("MV_LJLOCNC",.F.,.F.) 	//Controla se o PE LOJR860 existe, chamado no final do processo
Local aPosSd2		:= {}									//Guarda a posicao do SD2
Local cPrefixoEnt	:= ""									//Prefixo de entrada
Local cPrefixoSaida	:= ""									//Prefixo de Saida
Local aDevol 		:= {}									//Dados da devolucao
Local aSldItens		:= {}									//Itens da venda original
Local nPos			:= 0									//Resultado da busca no array aSldItens
Local cDocOri		:= ""									//Documento original da venda
Local cSerOri		:= ""									//Serie original da venda
Local cCliOri		:= ""									//Cliente original da venda
Local cLojOri		:= ""									//Loja original da venda
Local cFilSD2		:= FWxFilial("SD2",cCodFil)				//Filial da tabela SD2
Local aOtcTroca     := {}									//array para guardar dados para troca de mercadoria de Otica
Local nCount		:= 0
Local cPadrao		:= "704"								// Codigo Padrao
Local lPadrao  		:= VerPadrao(cPadrao)					// verifica padrao
Local nHdlPrv  		:= 0									// Contabilizacao
Local nTotal   		:= 0									// Contabilizacao
Local cArquivo 		:= ""									// Contabilizacao
Local lAglutina 	:= .T.					
Local lGeraNCC		:= .F.
Local lGeraNDC		:= .F.
Local cCliPad 		:= SuperGetMV("MV_CLIPAD",,"")			// Cliente padrao 
Local cLojPad	 	:= SuperGetMV("MV_LOJAPAD")				// Loja do cliente padrao					
Local nX 			:= 0
Local lR5			:= GetRpoRelease() >= "R5"		 		// Indica se o release e 11.5
Local aNCC			:= {} 									// Array com as NCCs utilizadas na devolucao
Local lGeraOP		:= SuperGetMV("MV_GROPOTC ",.F.,.F.) 	// Par�metro para verificar a necessidade de criar ou n�o Ordem de Produ��o para o template Otica
Local cDocSaida		:= ""									//Devolucao de Retira posterio
Local cSerieSaida	:= ""									//Devolucao de Retira posterio
Local lGE			:= FindFunction("LjUP104OK") .AND. LjUP104OK()// Garantia estendida
Local aRetSUD		:= {}

PRIVATE INCLUI 	:= .T.
                                                                           	
Default lDevMoeda  	:= .F.							//Devolve em varias moedas (localizacoes)
Default nMoedaCorT 	:= 1							//Moeda
Default nTxMoedaTr	:= 0							//Taxa da moeda
Default cCodDia    	:= ""							//Codigo do Diario
Default cMotivo		:= ""
Default nImpostos	:= 0
Default cChvNFE 	:= ""
Default cTpEspecie	:= ""

//����������������������������������������������������������������������Ŀ
//�Realiza um backup das variaveis fiscais para depois restaura-las, pois�
//�a rotina automatica reinicializa a funcao fiscal.                     �
//������������������������������������������������������������������������
If MaFisFound()
	MafisSave()
	MafisEnd()
	lRestArea  := .T.
Endif	

//���������������������������Ŀ
//�Limpa a ordem do IndRegua()�
//�����������������������������
DbSelectArea("SD2")
RetIndex("SD2")
DbClearFilter()


//�������������������������Ŀ
//�Soma os produtos vendidos�
//���������������������������
If (nTpProc == 2) .AND. (Len(aRecSd2) >= 1) .AND. (Len(aRecSd2[1]) >= 2)
	SD2->(DbGoTo(aRecSd2[1][2]))

	cDocOri		:= SD2->D2_DOC
	cSerOri		:= SD2->D2_SERIE
	cCliOri		:= SD2->D2_CLIENTE
	cLojOri		:= SD2->D2_LOJA

	SD2->(DbSetOrder(3)) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
	SD2->(DbSeek(cFilSD2 + cDocOri + cSerOri + cCliOri + cLojOri))

	While !SD2->(Eof())				.AND.;
		SD2->D2_DOC		== cDocOri	.AND.;
		SD2->D2_SERIE	== cSerOri	.AND.;
		SD2->D2_CLIENTE	== cCliOri	.AND.;
		SD2->D2_LOJA	== cLojOri

		If (nPos := aScan( aSldItens, {|x| x[1] == SD2->D2_COD })) > 0
			aSldItens[nPos][2] += (SD2->D2_QUANT - SD2->D2_QTDEDEV)
		Else
			AAdd(aSldItens,{ SD2->D2_COD, (SD2->D2_QUANT - SD2->D2_QTDEDEV) })
		EndIf	

		SD2->(DbSkip())
	End

	RestArea(aAreaSD2)
	RestArea(aArea)
EndIf


//�������������������������������Ŀ
//�Geracao do documento de entrada�
//���������������������������������
If (nTpProc <> 3 .And. nTpProc <> 4)

	If nNfOrig == 1             
	
		MsgRun("Aguarde, gerando documento de entrada..." ,,{||lRet:=Lj720DevSD2(	cCodCli   	, cLojaCli   	, aRecSD2  		, lFormul 		,;
																					@cNumDoc  	, @cSerieDoc	, @aDocDev 		, nTpProc 		,;
																					nFormaDev	, nVlrTotal  	, @aPosSd2		, @lDevMoeda	,;
																					@aDevol   	, cCodDia		, cMotivo		, @nImpostos 	,;
																					cChvNFE 	, cTpEspecie	, cCodFil 		, Nil			,;
																					Nil			, nNFOrig		, cNrChamado	, cObs			,;
																					cTpAcao, cOcorr		)})  	 //"Aguarde, gerando documento de entrada..."	
		//�����������������������������������������Ŀ
		//�Elimina do laboratorio Registro Devolvido�
		//�������������������������������������������  
		If Hastemplate("OTC") 
			If nTpProc == 2  
		    	T_OtcDelDev(aDocDev)   
		    Else 
		        TRB->(DbGoTo(1))  
				While !TRB->(Eof())
		   			AADD(aOtcTroca ,{TRB->TRB_CODPRO,TRB->TRB_SERORI,TRB->TRB_NFORI,TRB->TRB_CODGEN })   
		   			TRB->(DbSkip())
				End	 
				If Len(aDocDev) > 6  
					aDocDev[7] := aClone(aOtcTroca)
				Else
			    	AADD(aDocDev , aOtcTroca) 
				EndIf
			EndIf	   	
	
			If lGeraOP .And. lRet 
			        TRB->(DbGoTo(1)) 
				While !TRB->(Eof())
		   			EstOPOtc(TRB->TRB_CODPRO,TRB->TRB_NFORI,TRB->TRB_SERORI,TRB->TRB_ITEM,SD2->D2_CLIENTE,SD2->D2_LOJA,5,cCodFil)
		   			TRB->(DbSkip())
				End	 
			Endif
	
		EndIf	
		
		//���������������������������������Ŀ
		//�Recalcula para comissao em aberto�
		//�����������������������������������
		If lRet
			LJ720RecComis( aPosSd2 , nFormaDev, cCodFil )	
	    Endif

	Else
		//���������������������������������������������Ŀ
		//�Deleta do tempor�rio os arquivos selecionados�
		//�����������������������������������������������
		DbSelectArea("TRB") 
		DbGoTo(1)
		While !Eof() 
			If TRB->TRB_FLAG
				RecLock( "TRB",.F.,.T.)
				DbDelete()
				MsUnlock()
			Endif                  
			DbSkip()
		End
	
		MsgRun("Aguarde, gerando documento de entrada..." ,,{||lRet:=Lj720DevTRB(	cCodCli   	, cLojaCli	, lFormul	, @cNumDoc  	,;
																					@cSerieDoc	, @aDocDev	, nTpProc	, nFormaDev 	,;
																					nVlrTotal	, lDevMoeda	, @aDevol	, nMoedaCorT	,;
																					nTxMoedaTr	, cMotivo	, @nImpostos, cChvNFE		,;
																					cTpEspecie	, Nil		, nNFOrig	, cNrChamado	,; 
																					cObs		,cTpAcao, cOcorr	)}	)	//"Aguarde, gerando documento de entrada..."
	Endif
Endif
	
//�����������������������������������������������������������������������������������Ŀ
//�Restaura a funcao fiscal com base nos dados backupados anteriormente.              �
//�������������������������������������������������������������������������������������
If lRestArea
	MafisRestore()
Endif
                               	
//������������������������������������������������������������������������������Ŀ
//�Executar a interface da venda assistida quando a rotina for chamada pelo Menu.�
//��������������������������������������������������������������������������������
If lRet
	lConfirma := .T.
	If nTpProc == 1  //Troca De Mercadorias
		//������������������������������������������������������������Ŀ
		//�Limpa o filtro ativo criado na tabela SD2                   �
		//�antes de executar a rotina de Atendimento da Venda Assistida�
		//��������������������������������������������������������������
		DbSelectArea("SD2")
		RetIndex("SD2")
		DbClearFilter()
		
		//����������������������������������������������������������������������Ŀ
		//�Executa a funcao que compensa NCC com o titulo do documento de origem �
		//�apenas quando for Devolucao, foi informada a nota fiscal de origem e  �
		//�a forma de devolucao foi NCC										     �
		//������������������������������������������������������������������������
	ElseIf nTpProc == 2 .AND. nNfOrig == 1 .AND. nFormaDev == 2
		
		//�����������������������������������������������������������Ŀ
		//�Pega o prefixo da nota de entrada para fazer a baixa da NCC�
		//�������������������������������������������������������������
		DbSelectArea("SF1")
		DbSetOrder(1)
		If DbSeek(xFilial("SF1")+ cNumDoc + cSerieDoc + cCodCli + cLojaCli )
			cPrefixoEnt := SF1->F1_PREFIXO
		Else
			cPrefixoEnt := cSerieDoc
		Endif
		
		//��������������������������������������Ŀ
		//�Carrega as NCCs utilizada na Devolucao�
		//����������������������������������������
		aNCC := Lj720aNCC(cCodCli, cLojaCli, cPrefixoEnt, cNumDoc)
		
		If GetRpoRelease() >= "R5" .And. cPaisLoc == "BRA" .And. SuperGetMv("MV_LJICMJR",,.F.)
			Lj720NccIcmJr(aNCC, SD2->D2_SERIE+SD2->D2_DOC, nVlrTotal, lCompCR)
		EndIf
		
		If lCompCR
			DbSelectArea("SD2")
			DbGoTo(aRecSd2[1][2])
			
			//��������������������������������������������������������������Ŀ
			//�Pega o prefixo da nota de entrada para fazer a baixa do Titulo�
			//����������������������������������������������������������������
			DbSelectArea("SF2")
			DbSetOrder(1)
			If DbSeek(FWxFilial("SF2",cCodFil)+SD2->D2_DOC+SD2->D2_SERIE+cCodCli+cLojaCli)
				cPrefixoSaida := SF2->F2_PREFIXO
			ElseIf DbSeek(FWxFilial("SF2",cCodFil)+SD2->D2_DOC+SD2->D2_SERIE+cCliPad+cLojPad)
				cPrefixoSaida := SF2->F2_PREFIXO
			Else
				cPrefixoSaida := SD2->D2_SERIE
			Endif
			
			cDocSaida	:= IIf( Empty(cDocSaida)  , SD2->D2_DOC  , cDocSaida )
			cSerieSaida	:= IIf( Empty(cSerieSaida), SD2->D2_SERIE, cSerieSaida)
			
			//�����������������������������������������������������������������Ŀ
			//�Elimina residuos referente as taxas cobradas pela adm. financeira�
			//�������������������������������������������������������������������
			/*
			Lj720Resid(	@aSldItens	, SD2->D2_DOC	, SD2->D2_SERIE	, cPrefixoSaida	,;
			nMoedaCorT	, nVlrTotal		, cCodCli		, cLojaCli 		,;
			cCodFil	)*/
			
			//���������������������������������������������������������������������������������������������������Ŀ
			//�Chama a funcao que ira compensar as NCCs com os titulos ja gerados pela saida somente na devolucao.�
			//�����������������������������������������������������������������������������������������������������
			Lj720Comp(	cNumDoc		, cSerieDoc		, cDocSaida		, cSerieSaida	,;
			cCodCli		, cLojaCli		, SD2->D2_PDV	, nVlrTotal		,;
			cPrefixoEnt	, cPrefixoSaida	, aNCC			, cCodFil 		)
		Endif
		
		//���������������������������������������������������Ŀ
		//�Gera Nota Credito Cliente (NCC) de forma automatica�
		//�����������������������������������������������������
	ElseIf nTpProc == 3
		
		MsgRun("Aguarde, gerando Nota Credito (NCC)....",,{|| lGeraNCC := CriaTit(nVlrTotal,cCodCli,cLojaCli,cMotivo,cNrChamado,cObs,"NCC") })
		
		If lGeraNCC
			AAdd( aRetSUD , {cNrChamado,cTpAcao}  )

			//Atualiza os chamado no SAC				
			LjAtuSUD(aRetSUD,nTpProc)

			MsgInfo("Foi gerado o titulo "+ SE1->E1_PREFIXO + " / " + SE1->E1_NUM + " / " + SE1->E1_TIPO + " / " + SE1->E1_PARCELA,"Aten��o")
		Endif
		
		//���������������������������������������������������Ŀ
		//�Gera Nota DEbito Cliente (NDC) de forma automatica �
		//�����������������������������������������������������
	ElseIf nTpProc == 4

		MsgRun("Aguarde, gerando Nota Debito (NDC)....",,{|| lGeraNDC := CriaTit(nVlrTotal,cCodCli,cLojaCli,cMotivo,cNrChamado,cObs,"NDC") })
		
		If lGeraNDC
			AAdd( aRetSUD , {cNrChamado,cTpAcao}  )
			
			//Atualiza os chamado no SAC				
			LjAtuSUD(aRetSUD,nTpProc)

			MsgInfo("Foi gerado o titulo "+ SE1->E1_PREFIXO + " / " + SE1->E1_NUM + " / " + SE1->E1_TIPO + " / " + SE1->E1_PARCELA,"Aten��o")
		Endif
		
	Endif
Endif

//��������������������������������������������������������������������Ŀ
//�Se usar data de validade na NCC altera data de vencimento da NCC	   �
//����������������������������������������������������������������������
If lR5 .AND. SuperGetMV("MV_LJVLNCC",,.F.)
	DbSelectArea("SE1")
   	SE1->( DbSetOrder(1) ) //E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO   	
	For nCount := 1 To Len(aNCC)
		DbGoTo(aNCC[nCount])
		RecLock( "SE1", .F. )	
		Replace SE1->E1_VENCTO With (dDataBase + SuperGetMV("MV_LJDTNCC",,0))    
		Replace SE1->E1_VENCREA With DataValida((dDataBase + SuperGetMV("MV_LJDTNCC",,0)))
		MsUnLock()
	Next nCount      
Endif

If  SuperGetMv("MV_LJFNGE",,.F.) .AND. lGE .And. FindFunction("LJ7GrvMFI")  .And. !lTroca
	LJ7GrvMFI(4,aDocDev)
EndIf

If lLojr860
   ExecBlock("LOJR860",.F.,.F.,{aDocDev,aRecSD2})   
Endif
nRecSD2 := SD2->(Recno())
			
SD2->(DbGoTo(nRecSD2))	

RestArea(aAreaSD2)
RestArea(aArea)	

Return (lRet)               

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Lj720DevSD2�Autor  � Vendas Cliente    � Data �  23/08/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gera o documento de entrada baseado na Nota fiscal de      ���
���Desc.     � origem existente no SD2.                                   ���
�������������������������������������������������������������������������͹��
���Parametros�ExpN1 - Codigo do cliente                       			  ���
���          �ExpN2 - Codigo da loja                       				  ���
���          �ExpC3 - Array com os Recnos da tabela SD2                   ���
���          �ExpC4 - Indica se eh formulario proprio ou nao              ���
���          �ExpN5 - Numero do documento de entrada                      ���
���          �ExpN6 - Serie do documento de entrada                       ���
���          �EXpA7 - Armazena a serie, numero e cliente+loja da NF de    ���
���          �   	  devolucao e o tipo de operacao(1=troca;2=devolucao) ��� 
���          �ExpN8 - Opcao selecionada. 1-Troca ou 2-Devolucao           ���
���          �ExpN9 - Forma de devolucao ao cliente: 1-Dinheiro;2-NCC     ���
���          �ExpN10- Valor total de produtos trocados ou devolvidos      ���
���          �ExpA11- Guarda a posicao do SD2                             ���
���          �Expl12- Devolucao em varias moedas (localizazoes)           ���
���          �ExpA13- Dados da devolucao                                  ���
�������������������������������������������������������������������������͹��
���Uso       � SIGALOJA - VENDA ASSISTIDA                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Lj720DevSD2( cCliente  	, cLoja     , aRecSD2  		, lFormul  	,;
							 cNumDoc   	, cSerieDoc	, aDocDev  		, nTpProc  	,;
							 nFormaDev	, nVlrTotal	, aPosSd2		, lDevMoeda	,;
							 aDevol    	, cCodDia	, cMotivo		, nImpostos ,;
							 cChvNFE 	, cTpEspecie, cCodFil		, lDevNF	,;
							 lDevFrete	, nNFOrig	, cNrChamado	, cObs		,;
							 cTpAcao, cOcorr	)

Local lRet			:= .T.		                                	// Retorno da funcao, valida rotina automatica
Local aArea     	:= GetArea()		                          	// Area corrente
Local aAreaSF2  	:= SF2->(GetArea()) 		                  	// Area do arquivo SF2
Local aCab      	:= {}                       		          	// Contem os campos e valores correspondentes para geracao da NF de devolucao
Local aLinha    	:= {}                               		  	// Contem os itens do documento de entrada utilizado para a rotina automatica
Local aItens    	:= {}		     							   	// Contem os itens do documento de entrada utilizado para a rotina automatica
Local cTipoNF   	:= ""       		                          	// Tipo do documento de entrada
Local nSldDev   	:= 0                		                  	// Saldo a devolver
Local nCntSD2   	:= 0                        		          	// Contador de numero de itens
Local lDevolucao	:= .T.		                                	// Controla se dados invalidos
Local lPoder3   	:= .T.                              		  	// Valida se o TES controla poder de terceiros
Local nX        	:= 0        		                          	// Controle de loop
Local cTesDev   	:= ""
Local cSerie    	:= Padr(SuperGetMv("MV_LJNFTRO"),3) 		 	// Serie padrao para troca/devolucao
Local cNewDoc		:= CriaVar("F1_DOC",.F.)						// Numero do documento de entrada gerado
Local cMv_CondPad	:= ""											// Condicao de pagamento padrao
Local lUsafd      	:= SuperGetMV("MV_LJUSAFD",,.F.) 				// Parametro que define se o cliente utiliza Vale Compra
Local cNotaOri		:= ""											// Nota de origem
Local cSerieOri		:= ""						 					// Serie de origem
Local cOldDoc       := TRB->TRB_NFORI                 		      	// Numero do Documento anterior de venda
Local lGeraOP		:= SuperGetMV("MV_GROPOTC ",.F.,.F.) 			// Par�metro para verificar a necessidade de criar ou n�o Ordem de Produ��o para o template Otica
Local aRetDados		:= {}		 									// Array Utilizado para verificar se a Ordem de Servi�o pode ou n�o ser exclu�da do template Otica

Local cGrupoProd	:= ""	 										//Grupo de produtos
Local aProdCri		:= {}											// Array com os produtos para analise de criterio de pontos
Local nTotDev		:= 0    		                                // Total devolvido para controle da pontuacao da fidelidade
Local cMV_TPNRNFS	:= LJTpNrNFS()	  								// Retorno do parametro MV_TPNRNFS, utilizado pela Sx5NumNota() de onde serah controlado o numero da NF  1=SX5  2=SXE/SXF  3=SD9
Local cCliPad 		:= SuperGetMV("MV_CLIPAD",,"")    				// parametro que indica o CLIENTE PADRAO
Local cTipo			:= "2"						 					// Tipo da Operacao: 2 = devolucao
Local nPosTot		:= 0											// Posicao do total da devolucao
Local nPosIteOri	:= 0											// Posicao do item de origem da devolucao
Local nPosItem 		:= 0											// Posicao do item do array aItens
Local nPosProd		:= 0					   						// Posicao do produto
Local nPosQtd		:= 0 					   						// Posicao da quantidade
Local cFormul       := ""                      			             // Formulario proprio
Local cTipoDoc      := ""                      			             // Tipo da NF
Local aAreaSF4								  						// Area do arquivo SF4
Local cCfOpF4		:= ""					  						// Codigo Fiscal do SF4
Local cMV_LJDVACR	:= AllTrim(SuperGetMV("MV_LJDVACR",,""))// Define se considera acrescimo financeiro na devolucao
Local aRecAltSD2	:= {}									// alterada valor do SD2
Local nMoedaOri     := 1                                    // Moeda da Nota Fiscal de Origem
Local nTxMoedaOri   := 1                                    // Taxa da moeda a nota fiscal de Origem
Local cCliOri		:= ""                                   // Cliente da Nota Fiscal de Origem
Local cLojCliOri    := ""                                   // Loja da Nota fiscal de Origem
Local aVales        := {}									// Array com os vales compras utilizado na venda
Local cOper
Local nCount     	:= 0										// Usada em lacos For..Next
Local nPosSign 		:= 0										// Posicao do sinal dentro da string
Local aCFD			:= {}
Local aDados		:= {}
Local aRetCF		:= {}
Local aRetSUD		:= {}
Local lContrFol     :=	SF1->(FieldPos("F1_NUMAUT")) > 0 .And. SF1->(FieldPos("F1_CODCTR")) > 0 .And.;
						SF2->(FieldPos("F2_NUMAUT")) > 0 .And. SF2->(FieldPos("F2_CODCTR")) > 0 .And.;
						SF2->(FieldPos("F2_LIMEMIS")) > 0 .And. SF3->(FieldPos("F3_NUMAUT")) > 0 .And.;
						SF3->(FieldPos("F3_CODCTR")) > 0 .And. GetNewPar("MV_CTRLFOL",.F.)
						
Local lMotDevol		:= SF1->(FieldPos("F1_MOTIVO")) > 0
Local lNrChamado	:= SF1->(FieldPos("F1_01SAC"))  > 0
Local lObs			:= SF1->(FieldPos("F1_01OBS"))  > 0

//���������������������������������������Ŀ
//�Release 11.5 - Controle de Formularios �
//�Paises:Chile/Colombia  - F1CHI		  �
//�����������������������������������������
Local lCFolLocR5	:=	GetRpoRelease() >= "R5" .AND. ;
SuperGetMv("MV_CTRLFOL",,.F.) .AND. ;
cPaisLoc$"CHI" .AND.;
!lFiscal

Local cFilDocOri 	:= "" //Filial do Documento de Origem (D2_FILIAL)
Local nFrete  		:= 0
Local nSeguro		:= 0
Local nDespesa		:= 0
Local cTpFrete		:= ""
Local cLocDev		:= ""
Local aAreaSE1		:= {} 

Private lMsHelpAuto := .T.
Private lMsErroAuto := .F.

Default lFormul		:= .T.
Default cNumDoc		:= ""
Default cSerieDoc	:= ""
Default aDevol		:= {}
Default cCodDia     := ""
Default cMotivo		:= ""
Default nImpostos	:= 0
Default cTpEspecie	:= CriaVar("F1_ESPECIE",.F.)
Default	lDevNF		:= .F.
Default nNFOrig		:= 1	// 1-Com documento de Entrada / 2-Sem documento de entrada

//Abre a tabela de configuracoes de tipo de pedidos
LjFilAcao(cTpAcao,cOcorr)

//Retorna o armazem de devolucao conforme o motivo
cLocDev := TRB2->Z01_LOCAL

//Retorna a condi��o de pagamento conforne a configura��o de tipo de pedidos
IF !Empty(TRB2->Z01_CONDPG)
	cMv_CondPad	:= TRB2->Z01_CONDPG
Else
	cMv_CondPad	:= SuperGetMv("MV_CONDPAD")
EndIF

If lFormul
	cFormul  := "S"
Else
	cFormul  := "N"
Endif

aRecnoSD2	:= {}

For nX := 1 to Len(aRecSD2)
	//����������������������������������Ŀ
	//�Verifica se o produto foi deletado�
	//������������������������������������
	DbSelectArea("TRB")
	DbSetOrder(1)
	If DbSeek(StrZero( aRecSD2[nX][2],nTamRecTrb) )
		If !TRB->TRB_FLAG
			DbSelectArea("SD2")
			DbGoTo(aRecSD2[nX][2])
			
			//�����������������������Ŀ
			//�Guarda a posicao do SD2�
			//�������������������������
			If Len(aPosSd2) == 0
				Aadd(aPosSd2,{SD2->D2_DOC,SD2->D2_SERIE,SD2->D2_CLIENTE,SD2->D2_LOJA})
			Endif
			//��������������������������������������������������
			//�Verifica se existe saldo em aberto para devolver�
			//��������������������������������������������������
			If SD2->D2_QTDEDEV < SD2->D2_QUANT
			
				nFrete +=  SD2->D2_VALFRE//#CMG20181112.n
				nDespesa += SD2->D2_DESPESA
			
				//cTesDev  := TRB2->Z01_TES
				//��������������������������������������������������������������������������������������������Ŀ
				//� TRATAMENTO PARA CLIENTES FORA DO ESTADO NAO CONTRIBUINTES - LUIZ EDUARDO F.C. - 09.08.2017 �
				//����������������������������������������������������������������������������������������������
				DbSelectArea("SA1") 
				SA1->(DbSetOrder(1))
				SA1->(DbGoTop())
				SA1->(DbSeek(xFilial("SA1") + cCliente + cLoja))
				IF ALLTRIM(SA1->A1_EST) <> "SP"   
					IF SA1->A1_CONTRIB == "2"
						cTesDev  := TRB2->Z01_TESFOR
					EndIF
				Else
					cTesDev  := TRB2->Z01_TES
				EndIF
							
				aAreaSF4 := SF4->(GetArea())					
				//�������������������������������������Ŀ
				//�Posiciona no TES                     �
				//���������������������������������������
				DbSelectArea("SF4")                                   
				DbSetOrder(1)
				If !DbSeek(xFilial("SF4") + cTesDev)      
					lDevolucao := .F.
				Else
					cCfOpF4 := SF4->F4_CF
					If SF4->F4_PODER3<>"D"
						lPoder3 := .F.
					Endif
				Endif				
				SF4->(RestArea(aAreaSF4))
				
				cTipoNF := SD2->D2_TIPO
				
				//��������������������������������������������������������������������������Ŀ
				//�Calcula o saldo a devolver tanto normal como poder de terceiros           �
				//����������������������������������������������������������������������������
				nSldDev := aRecSD2[nX][1] //SD2->D2_QUANT-SD2->D2_QTDEDEV
				
				//��������������������������������������������������������������������������Ŀ
				//�Verifica se o saldo a devolver eh maior que zero para realizar a devolucao�
				//����������������������������������������������������������������������������
				If nSldDev > 0
					
					nCntSD2++
					If nCntSD2 > 900  // No. maximo de Itens
						Exit                  
						
					Endif
					
					Aadd(aRecAltSD2,{aRecSD2[nX][2],aRecSD2[nX][1],SD2->D2_CLIENTE,SD2->D2_LOJA})
					
					//������������������������������������������������Ŀ
					//�Monta a linha de devolucao que sera gerado o SD1�
					//��������������������������������������������������
					AAdd( aRetSUD , { cNrChamado , SD2->D2_COD })
					aLinha := {}
					AAdd( aLinha, { "D1_COD"    , SD2->D2_COD    , Nil } )
					AAdd( aLinha, { "D1_QUANT"  , nSldDev, Nil } )
					
					//�����������������������������������������������������Ŀ
					//�Parametro indica se retira o acrescimo (quando for 1)�
					//�������������������������������������������������������
					If cMV_LJDVACR == "1"
						AAdd( aLinha, { "D1_VUNIT"  , (SD2->D2_TOTAL + SD2->D2_DESCON + SD2->D2_DESCZFR - (SD2->D2_VALACRS * SD2->D2_QUANT))/SD2->D2_QUANT, Nil })
					Else
						AAdd( aLinha, { "D1_VUNIT"  , (SD2->D2_TOTAL + SD2->D2_DESCON + SD2->D2_DESCZFR)/SD2->D2_QUANT, Nil })
					EndIf
					
					//�������������������������������������������������������������������Ŀ
					//�Se for devolucao total nao calcula totais e descontos proporcionais�
					//���������������������������������������������������������������������
					If SD2->D2_QUANT==nSldDev
						
						If cMV_LJDVACR == "1"
							AAdd( aLinha, { "D1_TOTAL"  , SD2->D2_TOTAL + SD2->D2_DESCON + SD2->D2_DESCZFR - (SD2->D2_VALACRS * SD2->D2_QUANT),Nil } )
						Else
							AAdd( aLinha, { "D1_TOTAL"  , SD2->D2_TOTAL + SD2->D2_DESCON + SD2->D2_DESCZFR,Nil } )
						EndIf
						
						AAdd( aLinha, { "D1_VALDESC", SD2->D2_DESCON + SD2->D2_DESCZFR , Nil } )
					Else
						AAdd( aLinha, { "D1_TOTAL"  , A410Arred(nSldDev*aLinha[3][2],"D1_TOTAL"),Nil } )
						AAdd( aLinha, { "D1_VALDESC"  , A410Arred(SD2->D2_DESCON/SD2->D2_QUANT*nSldDev,"D1_VALDESC"),Nil } )
					Endif
					
					//������������������������������������������������Ŀ
					//�Monta a linha de devolucao que sera gerado o SD1�
					//��������������������������������������������������					
					AAdd( aLinha, { "D1_IPI"    , SD2->D2_IPI    , Nil } )
					AAdd( aLinha, { "D1_LOCAL"  , cLocDev  , Nil } )
					AAdd( aLinha, { "D1_TES" 	, cTesDev , Nil } )
					AAdd( aLinha, { "D1_CF" 	, cCfOpF4 , Nil } )
					AAdd( aLinha, { "D1_UM"     , SD2->D2_UM , Nil } )
					
					//������������������������������������������������Ŀ
					//�Verifica se existe rastreabilidade              �
					//��������������������������������������������������
					If Rastro(SD2->D2_COD)
						AAdd( aLinha, { "D1_LOTECTL", SD2->D2_LOTECTL	, ".T." } )
						AAdd( aLinha, { "D1_NUMLOTE", SD2->D2_NUMLOTE	, ".T." } )
						AAdd( aLinha, { "D1_DTVALID", SD2->D2_DTVALID	, ".T." } )
						AAdd( aLinha, { "D1_POTENCI", SD2->D2_POTENCI	, ".T." } )
					Endif
					cFilDocOri := SD2->D2_FILIAL
					AAdd( aLinha, { "D1_NFORI"  , SD2->D2_DOC    , Nil } )
					AAdd( aLinha, { "D1_SERIORI", SD2->D2_SERIE  , Nil } )
					AAdd( aLinha, { "D1_ITEMORI", SD2->D2_ITEM   , Nil } )
					AAdd( aLinha, { "D1_ICMSRET", SD2->D2_ICMSRET, Nil } )
					
					//������������������������������������������������Ŀ
					//�Verifica se o TES eh de poder de terceiro       �
					//��������������������������������������������������
//					If SF4->F4_PODER3=="D"
					If SF4->F4_PODER3<>"N" .OR. !EMPTY(SD2->D2_IDENTB6)
//						AAdd( aLinha, { "D1_IDENTB6", SD2->D2_NUMSEQ, Nil } )
						AAdd( aLinha, { "D1_IDENTB6", SD2->D2_IDENTB6, Nil } )
					Endif
					
					AAdd( aLinha, { "D1RECNO", SD2->(RECNO()), Nil } )
					
					//���������������������������������������������������������������������������������Ŀ
					//�Adiciona o item no array principal que sera levado para o Documento de entrada   �
					//�����������������������������������������������������������������������������������
					AAdd( aItens, aLinha )
					AAdd( aRecnoSD2, { 	SD2->D2_DOC		,; //01 - D2_DOC
					SD2->D2_SERIE	,; //02 - D2_SERIE
					SD2->D2_ITEM	,; //03 - D2_ITEM
					aRecSD2[nX][2]	,; //04 - Recno SD2
					cCodFil			,; //05 - Filial de Origem da venda
					SD2->D2_QTDEDEV	,; //06 - D2_QTDEDEV
					SD2->D2_VALDEV } ) //07 - D2_VALDEV
					
					cNotaOri  := SD2->D2_DOC
					cSerieOri := SD2->D2_SERIE
					
				Endif
				
				//�������������������������������������������������Ŀ
				//�Se nao ha saldo para devolucao nao pode continuar�
				//���������������������������������������������������
			Else
				MsgInfo("Nao h� saldo suficiente para realizar a devolu��o do produto:  " + SD2->D2_COD,"Atne��o")//"Nao h� saldo suficiente para realizar a devolu��o do produto:  "
				lRet:= .F.
			Endif
		EndIf
	EndIf
Next nX

DbSelectArea("SD2")
If lDevolucao .AND. lRet
	
	//�����������������������������������������������������Ŀ
	//�Armazena nas variaveis a primeira posicao do aPosSd2,�
	//�pois somente esta posicao e' utiliza para o Seek     �
	//�������������������������������������������������������
	If Len(aPosSd2) > 0
		cCliOri		:= aPosSd2[1][3]
		cLojCliOri	:= aPosSd2[1][4]
		//�����������������������������������������������������������������������Ŀ
		//�Posiciona o SF2 para pegar o valor da moeda e sua taxa da NF de Origem �
		//�������������������������������������������������������������������������
		DbSelectArea("SF2")
		DbSetOrder(1)     		// FILIAL + DOCUMENTO+ SERIE + CLIENTE + LOJA
		If DbSeek(FWxFilial("SF2",cCodFil)+cNotaOri+cSerieOri+ cCliOri+cLojCliOri)
			nMoedaOri	:= SF2->F2_MOEDA
			nTxMoedaOri	:= SF2->F2_TXMOEDA
			
			//#CMG20181112.bn
			If nFrete == 0
			
				nFrete 	:= SF2->F2_FRETE
				
			EndIf
			//#CMG20181112.en	
			
			nSeguro := SF2->F2_SEGURO
			
			if nDespesa == 0
				nDespesa:= SF2->F2_DESPESA
			endif
			
			cTpFrete:= SF2->F2_TPFRETE
		EndIf
	EndIf
	
	If !Empty(cNumDoc) .AND. !Empty(cSerieDoc) .AND. !lFormul
		cNewDoc	:= cNumDoc
		cSerie	:= cSerieDoc
	Else
		//����������������������������������������������������������������������Ŀ
		//� Verifica se eh para fazer o controle do numero da nota pelo SD9 (qdo �
		//� cMV_TPNRNFS for igual a "3"                                          �
		//������������������������������������������������������������������������
		If cMV_TPNRNFS == "3"
			
			//se a nota fiscal vai ser transmitida, a nota/troca dever� ser vinculada a uma nota de sa�da
			If !LjNFeEntOk(cSerie, lFormul, nNfOrig)
				Return .F.
			EndIf
			
			cNumDoc := MA461NumNf( .T., cSerie )
		Else
			If !Lj720Nota(@cSerie, @cNumDoc, lFormul, nNFOrig)
				Return .F.
			Endif
		Endif
		
		cNewDoc    := cNumDoc
		cSerieDoc  := cSerie
	Endif
	
	//se formulario proprio, retornamos a especie baseada na serie padrao para Troca/Devolucao
	If lFormul
		cTpEspecie := LjEspecie(cSerie)
	EndIf
	
	If cTipoNF == "B"
		cTipoDoc  := "N"
	Else
		cTipoDoc  := "B"
	Endif
	
	//����������������������������������������������������Ŀ
	//�Verifica se a serie esta valida - Controle de folios�
	//������������������������������������������������������
	If lContrFol .AND. !ChkFolURU(cFilAnt,cSerie,cNewDoc,Nil,.F.,"NCC")
		lRet := .F.
		DisarmTransaction()
		//�����������������������������������������������������������Ŀ
		//�Cancela a Sequencia de nota utilizada conforme configuracao�
		//�������������������������������������������������������������
		Lj720CnSD9(cNewDoc, cSerie, cMV_TPNRNFS)
	EndIf
	
	//���������������������������������������Ŀ
	//�Release 11.5 - Controle de Formulario  �
	//�Verificar se existe um formulario 	  �
	//�valido para a serie/nota escolhida.    �
	//�Paises:Chile/Colombia - F1CHI		  �
	//�����������������������������������������
	If lCFolLocR5 .AND. lFormul
		If nTpProc == 2 .AND. nFormaDev == 1
			//�������������������������������������������������������������������������Ŀ
			//�Para DEVOLUCAO em dinheiro, nao importa a especie do formulario          �
			//�vinculado a serie informada no parametro MV_LJNFTRO   					�
			//���������������������������������������������������������������������������
			cListEspOp 	:= "1|2|3|4|5|6|7|8|9|A"
		Else
			//�����������������������������������������������������Ŀ
			//�Para TROCA ou DEVOLUCAO em NCC,a especie do  		�
			//�formulario escolhido vinculado a serie informada     �
			//�no parametro MV_LJNFTRO deve ser do tipo NCC (8)     �
			//�������������������������������������������������������
			cListEspOp := "8"
		EndIf
		
		If !ChkFolCHI(	xFilial("SFP")	,	cSerie, 	cNewDoc, 	cListEspOp,;
			NIL,		.F.)
			MsgAlert ("Verifique o par�metro MV_LJNFTRO.Informe uma s�rie de um controle de formul�rios v�lido.","Atne��o")//"Verifique o par�metro MV_LJNFTRO.Informe uma s�rie de um controle de formul�rios v�lido."
			lRet := .F.
			DisarmTransaction()
			//�����������������������������������������������������������Ŀ
			//�Cancela a Sequencia de nota utilizada conforme configuracao�
			//�������������������������������������������������������������
			Lj720CnSD9(cNewDoc, cSerie, cMV_TPNRNFS)
		EndIf
	EndIf
	If lRet
		
		Begin Transaction
		//�����������������������������������������������������������������Ŀ
		//� Montagem do Cabecalho da Nota fiscal de Devolucao/Retorno       �
		//�������������������������������������������������������������������
		AAdd( aCab, { "F1_DOC"    , cNewDoc		, Nil } )	// Numero da NF : Obrigatorio
		AAdd( aCab, { "F1_SERIE"  , cSerie		, Nil } )	// Serie da NF  : Obrigatorio
		If SF1->(FieldPos("F1_CHVNFE")) > 0 .And. !Empty(cChvNFE)
			AAdd( aCab, { "F1_CHVNFE" , cChvNFE	, Nil } )	// Chave da NFe
		EndIf
		
		//�����������������������������������������������������������������Ŀ
		//� Monta o cabecalho de acordo com o tipo da devolucao             �
		//�������������������������������������������������������������������
		If !lPoder3
			AAdd( aCab, { "F1_TIPO"   , "D"                  		, Nil } )	// Tipo da NF   : Obrigatorio
		Else
			AAdd( aCab, { "F1_TIPO"   , cTipoDoc	                , Nil } )	// Tipo da NF   : Obrigatorio
		Endif
		
		AAdd( aCab, { "F1_FORNECE", cCliente    					, Nil } )	// Codigo do Fornecedor : Obrigatorio
		AAdd( aCab, { "F1_LOJA"   , cLoja    	   					, Nil } )	// Loja do Fornecedor   : Obrigatorio
		AAdd( aCab, { "F1_EMISSAO", dDataBase           			, Nil } )	// Emissao da NF        : Obrigatorio
		AAdd( aCab, { "F1_FORMUL" , cFormul                        , Nil } )   // Formulario Proprio
		AAdd( aCab, { "F1_ESPECIE", cTpEspecie                     , Nil } )  // Especie
		AAdd( aCab, { "F1_COND"   , cMv_CondPad   	  				, Nil } )	// Condicao do Fornecedor
		AAdd( aCab, { "F1_FRETE"	, nFrete    					, Nil } )	// Frete
		AAdd( aCab, { "F1_SEGURO"	, nSeguro    					, Nil } )	// Seguro
		AAdd( aCab, { "F1_DESPESA"	, nDespesa    					, Nil } )	// Despesa
		//AAdd( aCab, { "F1_TPFRETE"	, cTpFrete    					, Nil } )	// Tipo Frete
		AAdd( aCab, { "F1_TPFRETE"	, cCbTpFrete    					, Nil } )	// Tipo Frete - PEGA AS INFORMACOES INDICADAS NA TELA - LUIZ EDUARDO F.C. - 13/12/2017		
		AAdd( aCab, { "F1_TRANSP"	, Posicione("Z01",1,xFilial("Z01")+cTpAcao,"Z01_TRANSP")    					, Nil } )	// PREENCHE A TRANSPORTADORA CADASTRADA NO TIPO DE ACAO - LUIZ EDUARDO F.C. - 13/12/2017		

		//����������������������������������Ŀ
		//�Tratamento para controle de Folios�
		//������������������������������������
		If lContrFol
			
			aDados := Array(6)
			
			aDados[1] := cSerie
			aDados[2] := cTpEspecie
			aDados[3] := cNewDoc
			If Alltrim(aDados[2]) $ "NDI/NCP"
				aDados[4] := GetAdvFVal("SA2","A2_CGC",xFilial("SA1")+cCliente+cLoja,1,"")
			Else
				aDados[4] := GetAdvFVal("SA1","A1_CGC",xFilial("SA1")+cCliente+cLoja,1,"")
			Endif
			aDados[5] := DtoS(dDataBase)
			aDados[6] := 0//Round(SL1->L1_VALBRUT,0)
			
			aRetCF := RetCF(aDados)
			
			AAdd( aCab, { "F1_NUMAUT"   , aRetCF[1]		, Nil } )
			AAdd( aCab, { "F1_CODCTR"   , aRetCF[2]		, Nil } )
			
		EndIf
		
		If	Alltrim(SF2->F2_ESPECIE) == "CF"
			AAdd( aCab, { "F1_EST" 	, SF2->F2_EST  	  	, Nil } )	// Estado de Origem para cupom fiscal
		EndIf
		
		If lMotDevol
			AAdd( aCab, { "F1_MOTIVO"   , cMotivo		, Nil } )
		Endif
		
		If lNrChamado	
			AAdd( aCab, { "F1_01SAC"   , cNrChamado		, Nil } )
		Endif
		
		If lObs
			AAdd( aCab, { "F1_01OBS"   , cObs			, Nil } )
		Endif
		
		//�����������������������������������������������������������������Ŀ
		//� Verifica se ha itens a serem devolvidos                         �
		//�������������������������������������������������������������������
		If Len(aItens) > 0 .AND. lRet
			
			RetIndex("SD2")
			
			If cPaisLoc == "BRA"
				Mata103( aCab, aItens , 3)
			Else
				Mata465n( aCab, aItens , 3)
			EndIf
			If !lMsErroAuto
				//��������������������������������������������������������������������������������������������������������������������Ŀ
				//�Acerta o campo de devolucao caso a filial de origem da venda seja diferente da filial de troca/devolucao (cFilAnt)  �
				//����������������������������������������������������������������������������������������������������������������������
				nPosTot		:= aScan(aItens[1],{|x| AllTrim(x[1])=="D1_TOTAL"})
				nPosIteOri	:= aScan(aItens[1],{|x| AllTrim(x[1])=="D1_ITEMORI"})
				nPosQtd		:= aScan(aItens[1],{|x| AllTrim(x[1])=="D1_QUANT"})
				
				If cCodFil <> cFilAnt
					DbSelectArea("SD2")
					For nX := 1 to Len(aRecAltSD2)
						DbGoTo(aRecAltSD2[nX][1])
						If (nPosItem := aScan(aItens,{|x| AllTrim(x[nPosIteOri,2])==SD2->D2_ITEM})) > 0 //Busca a posicao do array referente ao item de Origem
							RecLock("SD2",.F.)
							Replace D2_QTDEDEV 	With D2_QTDEDEV + aItens[nPosItem][nPosQtd][2]
							Replace D2_VALDEV 	With D2_VALDEV  + aItens[nPosItem][nPosTot][2] 							
							SD2->( MsUnLock() )
						EndIf
					Next nX
				EndIf
				
			EndIf
			
			If lMsErroAuto
				DisarmTransaction()
				//�����������������������������������������������������������Ŀ
				//�Cancela a Sequencia de nota utilizada conforme configuracao�
				//�������������������������������������������������������������
				Lj720CnSD9(cNewDoc, cSerie, cMV_TPNRNFS)
				
				MOSTRAERRO()
				lRet:= .F.
			Else
				
				lMsHelpAuto := Nil   //Limpa as variaveis automaticas.
				lMsErroAuto := Nil
				//������������������������������������������Ŀ
				//�Atualiza os campos do processo do SIGALOJA�
				//��������������������������������������������
				//������������������������������������������Ŀ
				//�BOPS 108277 - Inclusao do parametro       �
				//�nTpProc para a funcao LJ720ATUNFE.        �
				//��������������������������������������������
				Lj720AtuNFE( cNewDoc   	, cSerie	, cCliente	, cLoja 	, ;
				nFormaDev 	, nTpProc	, cMotivo	, @nImpostos, ;
				xNumCaixa(), .F.		, cFilDocOri )
				
				//�����������������������������������������������������������������������������������������Ŀ
				//�Se selecionar as opcoes "Devolucao" e "Dinheiro", exclui a NCC gerada e gera registro de �
				//�saida de numerario 																	    �
				//�������������������������������������������������������������������������������������������
				If nFormaDev == 1 .AND. nTpProc == 2
					Lj720DevDinh( cNewDoc   ,cSerie  ,cCliente  ,cLoja  ,;
					nVlrTotal	,@lDevMoeda	,@aDevol	,nImpostos, xNumCaixa())
				Endif
				
				aDocDev  := {cSerie,cNewDoc,cCliente, cLoja, nTpProc , cOldDoc , {} }
				
				//Envia os dados para integracao
				If SuperGetMv("MV_LJOFFLN", Nil, .F.)
					Lj720AtInt()
				Endif
				LjImpCNfisc( aDocDev, nVlrTotal )
				
				_cTitulo := cNewDoc //#AFD20180619.N

				LjAtuZk0(cNrChamado,cNewDoc,cSerie)

				//Atualiza os chamado no SAC				
				LjAtuSUD(aRetSUD,nTpProc)
				
			Endif
		EndIf
		
		aAreaSE1 := SE1->(GetArea())		
		SE1->(DbSetOrder(2))
		If SE1->(DbSeek(xFilial("SE1") + cCliente + cLoja + cSerie + cNewDoc ))
			RecLock("SE1",.F.)
			SE1->E1_PREFIXO	:= "MAN" 	//#AFD20180619.N
			SE1->E1_01SAC 	:= cNrChamado
			SE1->E1_01MOTIV	:= cMotivo
			SE1->E1_USRNAME	:= UsrRetName(__cUserID)
			SE1->E1_HIST	:= cObs
			SE1->E1_XPEDORI := RIGHT(POSICIONE("SUC",1,XFILIAL("SUC")+cNrChamado,"UC_01PED"),6) //#AFD26072018.N    

			//ATUALIZA O VALOR DA NCC DESCONTANDO O FRETE E DESPESAS CONFORME SELECIONADO - Marcio Nunes Chamado: 11569
			//A NCC � GERADA PELA NF DE DEVOLU��O POR ESTE MOTIVO EST� SENDO ATUALIZADA NESTE MOMENTO
			If "2"$cCliAus .And. cTpAcao == "DEVCCR"//desconsidera o frete 
				SE1->E1_VALOR	:= SE1->E1_VALOR -(nFrete+nDespesa)   
				SE1->E1_SALDO	:= SE1->E1_SALDO -(nFrete+nDespesa)
				SE1->E1_VLCRUZ	:= SE1->E1_VLCRUZ -(nFrete+nDespesa)   
				SE1->E1_XCLIAU	:= "2"//GRAVA O CAMPO COMO CLIENTE AUSENTE PARA CONFIRMAR A SELE��O NA GERA��O DA NCC	- Marcio Nunes alterar o campo 
			Else
				SE1->E1_XCLIAU	:= "1"//GRAVA O CAMPO COMO CLIENTE AUSENTE PARA CONFIRMAR A SELE��O NA GERA��O DA NCC	- Marcio Nunes alterar o campo			
			EndIf  
			SE1->E1_XCONFSC := "N"//INICIALIZA A NCC COMO BLOQUEADA PARA O SAC   
			Msunlock()	    		
		Endif
		RestArea(aAreaSE1)
				
		End Transaction
		
		If lRet
			MsgInfo("Foi gerado o documento de entrada "+ cNewDoc + " / " + cSerie,"Atne��o") //"Foi gerado o documento de entrada "
		EndIf
	Else
		Help(" ",1,"OMS320NFD") //Nota Fiscal de devolucao ja gerada
		lRet:= .F.
	Endif
Endif

RestArea( aArea )
RestArea( aAreaSF2 )

Return lRet


/* 
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Funcao	 �Lj720AtuNfe � Autor � Vendas Cliente      � Data � 16.08.05  ���
��������������������������������������������������������������������������Ĵ��
���Descricao � Autaliza dos dados do documento de   entrada de acordo com  ���
���          � os processos do loja                                        ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1: Numero do documento                                  ���
���          � ExpC2: Serie do documento                                   ���
���          � ExpC3: Codigo do cliente                                    ���
���          � ExpC4: Loja do cliente                                      ���
���          � ExpN5: Forma de devolucao: 1-Dinheiro;2-NCC                 ���
���          � ExpN6: Tipo da Operacao: 1-Troca; 2-Devolucao (opcional)    ���
��������������������������������������������������������������������������Ĵ��
���Uso		 � SIGALOJA - VENDA ASSISTIDA                                  ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
Static Function Lj720AtuNfe( 	cNewDoc   	, cSerie	, cCliente	, cLoja 	, ;
								nFormaDev 	, nTpProc	, cMotivo	, nImpostos	, ;
								cCaixa		, lEstorn	, cFilDocOri )
		
Local aArea         := GetArea()		//Salva ambiente
Local cPrefixoEnt	:= ""				//Prefixo da nota de entrada
Local lAchouSF1		:= .F.				//Se achou o SF1      
Local cUfCliDev		:= ""				// Uf do cliente da devolucao.
Local lMotDevol		:= SF1->(FieldPos("F1_MOTIVO")) > 0
Local aTesImp		:= {}				// Array de retorno da funcao TesImpInf()
Local nXImpostos	:= 0 				// Contador que varre os impostos
Local lD1FILORI		:= SD1->(FieldPos("D1_FILORI")) > 0
Local aDadosCFO		:= {}									//Dados da CF   
Local aAreaSF4		:= SF4->(GetArea())                     //WorkAreaSF4
Local cCfOpF4		:= ""									//CFOP do Item

Default nTpProc		:= 0										//1=Troca, 2=Devolucao
Default cMotivo		:= ""
Default nImpostos   	:= 0										//Valores dos Impostos do D1 a serem somados 
Default cCaixa 		:= xNumCaixa()
Default lEstorn 	:= .F.
Default cFilDocOri  := Nil

nImpostos := 0                         

SF4->(DbSetOrder(1)) //F4_FILIAL + F4_COD

DBSelectArea( "SA1" )
SA1->(DBSetOrder( 1 ))
If SA1->(DBSeek( xFilial("SA1") + cCliente + cLoja ))
	cUfCliDev	:= SA1->A1_EST
EndIf

//�����������������������������������������������������������������Ŀ
//�Busca os dados do SD1 criados e atualiza com os processos do loja�
//�������������������������������������������������������������������
DbSelectArea("SD1")
SD1->(DbSetOrder(1))
If SD1->(DbSeek( xFilial("SD1") + cNewDoc + cSerie + cCliente + cLoja ))
		
	While !SD1->(Eof()) .AND. SD1->D1_FILIAL  == xFilial("SD1")	.AND. ;
					    SD1->D1_DOC		== cNewDoc			.AND. ;
						SD1->D1_SERIE	== cSerie			.AND. ;
						SD1->D1_FORNECE	== cCliente			.AND. ;
						SD1->D1_LOJA	== cLoja
											
		RecLock("SD1", .F.)
		REPLACE	SD1->D1_ORIGLAN	WITH "LO"
		REPLACE	SD1->D1_NUMCQ	WITH xNumCaixa()	
		If lEstorn .and. FieldPos("D1_OPERADO") > 0
			REPLACE	SD1->D1_OPERADO	WITH cCaixa
		EndIf	
		If lD1FILORI .And. cFilDocOri <> Nil
			SD1->D1_FILORI := cFilDocOri
		EndIf	

		// Ajusta do CFOP
        // Devolu��o de Cliente fora do Estado da venda, estava gravando CFOP do Estado da venda.
        // Com o retorno da funcao MaFisCfoa, esta gravando corretamente CFOP de fora do Estado.
        SF4->(DbSeek(xFilial("SF4") + SD1->D1_TES))
		aDadosCfo := {}
		Aadd(aDadosCfo,{"OPERNF"	, "E"				})
		Aadd(aDadosCfo,{"TPCLIFOR"	, SA1->A1_TIPO		})
		Aadd(aDadosCfo,{"UFORIGEM"	, SF2->F2_EST		})//AFD20190201   // Tem que ser o estado de Origem da nota
		Aadd(aDadosCfo,{"INSCR"		, SA1->A1_INSCR		})
		
		If SA1->(FieldPos("A1_CONTRIB")) > 0 		 	
			Aadd(aDadosCfo,{"CONTR"	, SA1->A1_CONTRIB	})
		EndIf
		
		cCfOpF4	:= MaFisCfo(,SF4->F4_CF,aDadosCfo)
			
		If !Empty(cCfOpF4)
			Replace SD1->D1_CF With cCfOpF4
		EndIf	
	
		MsUnlock()    
		
		aTesImp := TesImpInf(SD1->D1_TES)					// Carrega retorno da fun��o no array de impostos

		For nXImpostos := 1 To Len(aTesImp)					// Le todos os impostos
			If aTesImp[nXImpostos][3] == '1'				// Verifica se o imposto sera agregado ao valor do item
				nImpostos += &(aTesImp[nXImpostos][2])		// Agrega a somatoria de impostos o valor do campo de imposto (ex: D1_VALIMP1)
			EndIf
		Next nXImpostos		
		DbSkip()							
	End										
Endif		                  
RestArea(aAreaSF4)

//���������������������������������������������������������������Ŀ
//�Busca os dados do SF1 criado para atulizar controle do Sigaloja�
//�����������������������������������������������������������������
DbSelectArea("SF1")
DbSetOrder(1)
If DbSeek( xFilial("SF1") + cNewDoc + cSerie + cCliente + cLoja )
	RecLock("SF1", .F.)
	REPLACE	SF1->F1_ORIGLAN	With "LO"
	REPLACE SF1->F1_EST     With cUfCliDev
	
	If lMotDevol
		REPLACE SF1->F1_MOTIVO	With cMotivo
	Endif
	
	MsUnlock() 

	lAchouSF1 := .T.
Endif		                  
 
//�����������������������������������������������������������Ŀ
//�Busca o prefixo da nota de entrada para atualizar a NCC    �
//�Forma de devolucao: NCC    								  �
//�������������������������������������������������������������
If nFormaDev == 2
	If lAchouSF1
		cPrefixoEnt := SF1->F1_PREFIXO
	Else
		cPrefixoEnt := cSerie
	Endif
	
	//�������������������������������������������������������������������������Ŀ
	//� Atualiza o portador da Nota de Credito de acordo com o Caixa da operacao�
	//���������������������������������������������������������������������������
	DbSelectArea("SE1")
	DbSetOrder( 2 )
	If DbSeek( xFilial("SE1") + cCliente + cLoja + cPrefixoEnt + cNewDoc  )
		
		While !Eof() .AND. 	SE1->E1_FILIAL 	    == xFilial("SE1")	.AND. ;
							SE1->E1_CLIENTE		== cCliente       	.AND. ;
							SE1->E1_LOJA		== cLoja          	.AND. ;
							SE1->E1_PREFIXO		== cPrefixoEnt    	.AND. ;
							SE1->E1_NUM			== cNewDoc
			
			If (SE1->E1_TIPO $ MV_CRNEG)
				RecLock("SE1",.F.)
				REPLACE SE1->E1_PORTADO WITH cCaixa
				REPLACE SE1->E1_NATUREZ WITH SuperGetMV("MV_NATNCC")
				REPLACE SE1->E1_ORIGEM	WITH "LOJA720"
				MsUnlock()
			Endif
			
			DbSkip()
		End
	Endif
Endif

Restarea( aArea )

Return( .T. )



/*/
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Funcao	 �Lj720Comp � Autor � Vendas Cliente        � Data � 16.08.05  ���
��������������������������������������������������������������������������Ĵ��
���Descricao � Rotina para realizacao de manutencao na NCC                 ���
��������������������������������������������������������������������������Ĵ��
���Parametros� ExpN1 : Parametro do processo desejado                      ���
���          �         1 - Exclui a NCC                                    ���
���          �         2 - Baixa a NCC                                     ���
���          �         3 - Exclui Titulos do contas a receber              ���
���          � ExpC2 : Serie da nota de Entrada                            ���
���          � ExpC3 : Numero do documento de saida                        ���
���          � ExpC4 : Serie da nota de Saida                              ���
���          � ExpC5 : Codigo do cliente                                   ���
���          � ExpC6 : Loja do cadastro do cliente                         ���
���          � ExpC7 : Numero do Caixa                                     ���  
���          � ExpC8 : Valor total de produtos trocados ou devolvidos      ���  
���          � ExpC9 : Prefixo de entrada                                  ���  
���          � ExpC10: Prefixo de Saida                                    ���
���          � ExpA11: NCC geradas na devolucao                            ���
��������������������������������������������������������������������������Ĵ��
���Uso		 � SIGALOJA - VENDA ASSISTIDA                                  ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Static Function Lj720Comp( cTitEnt		,	cSerieEnt		,	cTitSaida	,	cSerieSaida	,;
                           cCliente 	,	cLoja			,	cNumPDV		,	nVlrTotal	,;
                           cPrefixoEnt	,	cPrefixoSaida	,	aNCC		, 	cCodFil 	)

Local aSE1CPS			:= {}					// Array com os titulos do SE1
Local lRet				:= .T.					// Retorno da funcao
Local lCompensa			:= .T.					// Indica se o titulo deve ser compensado
Local cMV_CLIPAD  		:= SuperGetMV("MV_CLIPAD")			// Cliente padrao
Local cMV_LOJAPAD 		:= SuperGetMV("MV_LOJAPAD")			// Loja do cliente padrao
Local cFilSE1 			:= FWxFilial("SE1",cCodFil)
Local cFilSAE 			:= FWxFilial("SAE",cCodFil)
Local cLstDesc			:= FN022LSTCB(2)					//Lista das situacoes de cobranca (Descontada)
Local lljGerTx			:= SuperGetMV("MV_LJGERTX",,.F.) 							// indica se usa geracao de Contas a pagar para Adm. Financeira	
Local nx				:= 0  
Local aAreaSE1			:= {}

Default aNCC			:= {}     				// Array com as NCCs geradas na devolucao
Default cPrefixoEnt		:= cSerieEnt	
Default cPrefixoSaida	:= cSerieSaida

//�����������������������������������������������Ŀ
//�Traz os titulos do respectivo documento        �
//�������������������������������������������������
SE1->( DbSetOrder(2) ) //E1_CLIENTE + E1_LOJA
If SE1->( DbSeek(cFilSE1 + cCliente + cLoja) )	
	While SE1->(!Eof()) .AND. SE1->E1_FILIAL	== cFilSE1		.AND.;
								SE1->E1_CLIENTE	== cCliente 	.AND.;
								SE1->E1_LOJA	== cLoja

		lCompensa := .F.
		If (AllTrim(SE1->E1_TIPO) $ "NDC" )
			lCompensa := .T.
		Endif
				
		If lCompensa
		   	If !( SE1->E1_SITUACA $ cLstDesc .OR. SE1->E1_SALDO == 0 )	
	     		If ALLTRIM(SE1->E1_TIPO) $ "NDC" 
		   			Aadd( aSE1Cps, SE1->(Recno()) )
		   		Endif	
			Endif
		Endif
	    
		SE1->(DbSkip())
	End

Endif									

MaIntBxCR(3,aSE1Cps,Nil,aNCC)//,Nil,aParam,{|x,y| OmsGrvDAM(x,y,cCarga,cSeqcar,cLote,"3")})

Return( lRet )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Lj720DevTRB�Autor  � Vendas Cliente    � Data �  24/08/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gera o documento de entrada baseado na tabela temporaria   ���
���Desc.     � TRB onde foram digitados os dados para realizar a entrada. ���
�������������������������������������������������������������������������͹��
���Parametros�ExpN1 - Codigo do cliente                       			  ���
���          �ExpN2 - Codigo da loja                       				  ���
���          �ExpC3 - Indica se utiliza formulario proprio                ���
���          �ExpN4 - Numero do documento de entrada                      ���
���          �ExpN5 - Serie do  documento de entrada                      ���
���          �ExpA6 - Armazena a serie, numero e cliente+loja da NF de    ���
���          � 		  devolucao e o tipo de operacao(1=troca;2=devolucao) ���
���          �ExpN7 - Opcao selecionada. 1-Troca ou 2-Devolucao           ���
���          �ExpN8 - Forma de devolucao ao cliente: 1-Dinheiro;2-NCC     ���
���          �ExpN9 - Valor total de produtos trocados ou devolvidos      ���
���          �ExpL10- Devolucao em varias moedas (Localizacoes)           ���
���          �ExpA11- Dados da devolucao         (Localizacoes)           ���
���          �ExpN12- Moeda corrente             (Localizacoes)           ���
���          �ExpN13- Taxa da moeda              (Localizacoes)           ���
�������������������������������������������������������������������������͹��
���Uso       � SIGALOJA - VENDA ASSISTIDA                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Lj720DevTRB(cCliente 	, cLoja    	, lFormul	, cNumDoc   	,;
						 	cSerieDoc	, aDocDev  	, nTpProc	, nFormaDev 	,;
						 	nVlrTotal	, lDevMoeda	, aDevol 	, nMoedaCorT	,;
						 	nTxMoedaTr	, cMotivo   , nImpostos , cChvNFE 		,;
						 	cTpEspecie	, cMensagem , nNFOrig	, cNrChamado	,; 
						 	cObs		, cTpAcao, cOcorr	)

Local lRet			:= .T.                               	// Retorno da funcao, valida rotina automatica
Local aArea     	:= GetArea()                         	// Area corrente
Local aAreaSF2  	:= SF2->(GetArea())                 	// Area do arquivo SF2
Local aCab      	:= {}                               	// Contem os campos e valores correspondentes para geracao da NF de devolucao
Local aLinha    	:= {}                               	// Contem os itens do documento de entrada utilizado para a rotina automatica
Local aItens    	:= {}     								// Contem os itens do documento de entrada utilizado para a rotina automatica
Local cTipoNF   	:= "D"    								// Tipo do documento de entrada
Local lDevolucao	:= .T. 									// Indica se houve devolucao
Local cTesDev   	:= ""
Local cSerie    	:= Padr(SuperGetMv("MV_LJNFTRO"),3) 	// Serie padrao para o documento de entrada
Local cNewDoc		:= CriaVar("F1_DOC",.F.)				// Numero do documento de entrada gerado
Local cMV_TPNRNFS	:= LJTpNrNFS()							// Retorno do parametro MV_TPNRNFS, utilizado pela Sx5NumNota() de onde serah controlado o numero da NF  1=SX5  2=SXE/SXF  3=SD9
Local lUsafd      	:= SuperGetMV("MV_LJUSAFD",,.F.) 		// Parametro que define se o cliente utiliza Vale Compra
Local cMv_CondPad	:= ""									// Condicao de pagamento padrao
Local cGrupoProd	:= ""									// Grupo do produtos
Local aProdCri		:= {}									// Array com os produtos para analise de criterio de pontos
Local nTotDev		:= 0                                    // Total devolvido para controle da pontuacao da fidelidade
Local cTipo			:= "2"									// Tipo da Operacao: 2 = Devolucao
Local nX        	:= 0                                    // Contador utilizado na leitura dos produtos
Local cCliPad 		:= SuperGetMV("MV_CLIPAD",,"")  		// parametro que indica o CLIENTE PADRAO
Local nPosTot		:= 0									// Posicao do total da devolucao	
Local nPosProd		:= 0									// Posicao do produto 
Local nPosQtd		:= 0									// Posicao da Quantidade
Local cFormul       := ""                                   // Formulario proprio
Local lMv_Rastro	:= If( SuperGetMv( "MV_RASTRO", Nil, "N" ) == "S", .T., .F. )		// Flag de verificacao do rastro             
Local lLJ7042		:= .T.									// Retorno do Ponto de Entrada "LJ7042"
Local nCount     	:= 0										// Usada em lacos For..Next
Local lContrFol     :=	SF1->(FieldPos("F1_NUMAUT")) > 0 .And. SF1->(FieldPos("F1_CODCTR")) > 0 .And.;
						SF2->(FieldPos("F2_NUMAUT")) > 0 .And. SF2->(FieldPos("F2_CODCTR")) > 0 .And.;
						SF2->(FieldPos("F2_LIMEMIS")) > 0 .And. SF3->(FieldPos("F3_NUMAUT")) > 0 .And.;
						SF3->(FieldPos("F3_CODCTR")) > 0 .And. GetNewPar("MV_CTRLFOL",.F.)

Local lMotDevol		:= SF1->(FieldPos("F1_MOTIVO")) > 0
Local lNrChamado	:= SF1->(FieldPos("F1_01SAC"))  > 0
Local lObs			:= SF1->(FieldPos("F1_01OBS"))  > 0
Local aAreaSE1		:= {}
Local aRetSUD		:= {}
Local cLocDev		:= ""

//���������������������������������������Ŀ
//�Release 11.5 - Controle de Formularios �
//�Pais:Chile   - F1CHI					  �
//�����������������������������������������
Local lCFolLocR5	:=	GetRpoRelease() >= "R5" .AND. ;
					SuperGetMv("MV_CTRLFOL",,.F.) .AND. ;
					cPaisLoc$"CHI" .AND.;
					!lFiscal 

Default lFormul		:= .T.                 
Default cNumDoc 	:= ""
Default cSerieDoc 	:= ""
Default aDevol		:= {}
Default cMotivo		:= ""
Default nImpostos	:= 0
Default cTpEspecie	:= CriaVar("F1_ESPECIE",.F.)
Default nNFOrig		:= 1 // 1 - Com documento / 2 - Sem documento

Private lMsErroAuto	:= .F. 

//Abre a tabela de configuracoes de tipo de pedidos
LjFilAcao(cTpAcao,cOcorr)

//Retorna o armazem de devolucao conforme o motivo
cLocDev := TRB2->Z01_LOCAL

//Retorna a condi��o de pagamento conforne a configura��o de tipo de pedidos
IF Empty(TRB2->Z01_CONDPG)
	cMv_CondPad	:= TRB2->Z01_CONDPG
Else
	cMv_CondPad	:= SuperGetMv("MV_CONDPAD")
EndIF


If lFormul
   cFormul  := "S"
Else
   cFormul  := "N"
Endif   

//se formulario proprio, retornamos a especie baseada na serie padrao para Troca/Devolucao
If lFormul
	cTpEspecie := LjEspecie(cSerie)
EndIf

DbSelectArea("TRB")                                        
TRB->( DbGoTop() )
While TRB->( !Eof() )

	//cTesDev  := TRB2->Z01_TES
	//��������������������������������������������������������������������������������������������Ŀ
	//� TRATAMENTO PARA CLIENTES FORA DO ESTADO NAO CONTRIBUINTES - LUIZ EDUARDO F.C. - 09.08.2017 �
	//����������������������������������������������������������������������������������������������
	DbSelectArea("SA1") 
	SA1->(DbSetOrder(1))
	SA1->(DbGoTop())
	SA1->(DbSeek(xFilial("SA1") + cCliente + cLoja))
	IF ALLTRIM(SA1->A1_EST) <> "SP"
		IF SA1->A1_CONTRIB == "2"
			cTesDev  := TRB2->Z01_TESFOR
		EndIF
	Else
		cTesDev  := TRB2->Z01_TES
	EndIF
		
	aAreaSF4 := SF4->(GetArea())					
	//�������������������������������������Ŀ
	//�Posiciona no TES                     �
	//���������������������������������������
	DbSelectArea("SF4")
	DbSetOrder(1)
	If !DbSeek(xFilial("SF4") + cTesDev)
		lDevolucao := .F. 
		cCfOpF4 := SF4->F4_CF
	Else
		cCfOpF4 := SF4->F4_CF
		If SF4->F4_PODER3<>"D"
			lPoder3 := .F.
		Endif
	Endif				
	SF4->(RestArea(aAreaSF4))

	//������������������������������������������������Ŀ
	//�Monta a linha de devolucao que sera gerado o SD1�
	//��������������������������������������������������
	aLinha := {}
	AAdd( aRetSUD , { cNrChamado , SD2->D2_COD })
	AAdd( aLinha, { "D1_COD"    	, TRB->TRB_CODPRO 	, Nil } )
	AAdd( aLinha, { "D1_QUANT"  	, TRB->TRB_QUANT	, Nil } )					
	AAdd( aLinha, { "D1_VUNIT"  	, TRB->TRB_PRCVEN	, Nil } )					
	AAdd( aLinha, { "D1_TOTAL"  	, TRB->TRB_VLRTOT	, Nil } )
	AAdd( aLinha, { "D1_TES" 		, cTesDev 			, Nil } )
	AAdd( aLinha, { "D1_UM"     	, TRB->TRB_UM 		, Nil } )
	If lMv_Rastro
		AAdd( aLinha, { "D1_LOTECTL"  	, TRB->TRB_LOTECT          , ".T." } ) 
		AAdd( aLinha, { "D1_NUMLOTE"  	, TRB->TRB_NUMLOT          , ".T." } )   
		AAdd( aLinha, { "D1_DTVALID"  	, TRB->TRB_DTVALI          , ".T." } )
	EndIf	
	AAdd( aLinha, { "D1_LOCAL"  , cLocDev  , Nil } )
	AAdd( aLinha, { "D1_CF"     , cCfOpF4  , Nil } )	

	//���������������������������������������������������������������������������Ŀ
	//�Nao existe nota fiscal de saida (origem) pois a troca eh de outra loja.    �
	//�Para gerar o documento de entrada eh necessario passar as duas informacoes.�
	//�����������������������������������������������������������������������������
	//��������������������������������������������������������������������Ŀ
	//� MODIFICADO O TREHO DO PROGRAMA PARA QUE GRAVE AS INFORMACOES       �
	//� CORRETAS DA NOTA FISCAL DE ORIGEM - LUIZ EDUARDO F.C. - 06.07.2017 �
	//����������������������������������������������������������������������
	//AAdd( aLinha, { "D1_NFORI"  	, "XXXXXX"          , Nil } )
	//AAdd( aLinha, { "D1_SERIORI"	, "XX"         		, Nil } )          
	
	AAdd( aLinha, { "D1_NFORI"  	, cNfOri        , Nil } )
	AAdd( aLinha, { "D1_SERIORI"	, cSerOri   	, Nil } )
	AAdd( aLinha, { "D1_01SAC"	    , cNrChamado	, Nil } )	
	
	//���������������������������������������������������������������������������������Ŀ
	//�Adiciona o item no array principal que sera levado para o Documento de entrada   �
	//�����������������������������������������������������������������������������������
	AAdd( aItens, aLinha)
	DbSelectArea("TRB")
	DbSkip()

End
	
If lDevolucao        
    
    If !Empty(cNumDoc) .AND. !Empty(cSerieDoc)
		cNewDoc	:= cNumDoc
		cSerie	:= cSerieDoc
	Else
		//����������������������������������������������������������������������Ŀ
		//� Verifica se eh para fazer o controle do numero da nota pelo SD9 (qdo �
		//� cMV_TPNRNFS for igual a "3"                                          �
		//������������������������������������������������������������������������						
		If cMV_TPNRNFS == "3"
			
			//se a nota fiscal vai ser transmitida, a nota/troca dever� ser vinculada a uma nota de sa�da
			If !LjNFeEntOk(cSerie, lFormul, nNfOrig)
				Return .F.
			EndIf

			cNumDoc := MA461NumNf( .T., cSerie )
		Else				
		    If !Lj720Nota(@cSerie, @cNumDoc, lFormul, nNFOrig)
			   Return .F.
		    Endif        
		EndIf

        cNewDoc    := cNumDoc
		cSerieDoc  := cSerie
	Endif
	
	
	//�����������������������������������������������Ŀ
	//�Release 11.5 - Controle de Formularios         �
	//�Verificar se existe formulario do tipo NCC     �
	//�valido para a serie/nota escolhida.            �
	//�Paises:Chile	 - F1CHI		 				  �
	//�������������������������������������������������	
	If lCFolLocR5	.AND. lFormul	
		If !ChkFolCHI(	xFilial("SFP"),cSerie, cNewDoc,	"8",;
						NIL,	.F.)
			lRet := .F.
			DisarmTransaction()
			//�����������������������������������������������������������Ŀ
			//�Cancela a Sequencia de nota utilizada conforme configuracao�
			//�������������������������������������������������������������
		    Lj720CnSD9(cNewDoc, cSerie, cMV_TPNRNFS)
		EndIf	
	EndIf
	
	
	//�����������������������������������������������������������������Ŀ
	//� Montagem do Cabecalho da Nota fiscal de Devolucao/Retorno       �
	//�������������������������������������������������������������������
	AAdd( aCab, { "F1_DOC"    , cNewDoc						, Nil } )	// Numero da NF : Obrigatorio
	AAdd( aCab, { "F1_SERIE"  , cSerie						, Nil } )	// Serie da NF  : Obrigatorio
	If SF1->(FieldPos("F1_CHVNFE")) > 0 .And. !Empty(cChvNFE)
		AAdd( aCab, { "F1_CHVNFE" , cChvNFE					, Nil } )	// Chave da NFe
	EndIf

	//�����������������������������������������������������������������Ŀ
	//� Monta o cabecalho de acordo com o tipo da devolucao             �
	//�������������������������������������������������������������������
	AAdd( aCab, { "F1_TIPO"   , cTipoNF						, Nil } )	// Tipo da NF   		: Obrigatorio
	AAdd( aCab, { "F1_FORNECE", cCliente   					, Nil } )	// Codigo do Fornecedor : Obrigatorio
	AAdd( aCab, { "F1_LOJA"   , cLoja    					, Nil } )	// Loja do Fornecedor   : Obrigatorio
	AAdd( aCab, { "F1_EMISSAO", dDataBase					, Nil } )	// Emissao da NF        : Obrigatorio
	AAdd( aCab, { "F1_FORMUL" , cFormul                    	, Nil } )  	// Formulario Proprio 
	AAdd( aCab, { "F1_ESPECIE", cTpEspecie               	, Nil } )  	// Especie
	AAdd( aCab, { "F1_COND"   , cMv_CondPad					, Nil } )	// Condicao do Fornecedor
	AAdd( aCab, { "F1_TPFRETE", cCbTpFrete  				, Nil } )	// Tipo Frete - PEGA AS INFORMACOES INDICADAS NA TELA - LUIZ EDUARDO F.C. - 13/12/2017		
	AAdd( aCab, { "F1_TRANSP"	, Posicione("Z01",1,xFilial("Z01")+cTpAcao,"Z01_TRANSP")    					, Nil } )	// PREENCHE A TRANSPORTADORA CADASTRADA NO TIPO DE ACAO - LUIZ EDUARDO F.C. - 13/12/2017		


	//����������������������������������Ŀ
	//�Tratamento para controle de Folios�
	//������������������������������������
	If lContrFol
		
		aDados := Array(6)                                      
	
		aDados[1] := cSerie
		aDados[2] := cTpEspecie
		aDados[3] := cNewDoc
		If Alltrim(aDados[2]) $ "NDI/NCP"
			aDados[4] := GetAdvFVal("SA2","A2_CGC",xFilial("SA1")+cCliente+cLoja,1,"")
		Else
			aDados[4] := GetAdvFVal("SA1","A1_CGC",xFilial("SA1")+cCliente+cLoja,1,"")
		Endif
		aDados[5] := DtoS(dDataBase)
		aDados[6] := 0//Round(SL1->L1_VALBRUT,0)
		
		aRetCF := RetCF(aDados)
		
		AAdd( aCab, { "F1_NUMAUT"   , aRetCF[1]		, Nil } )
		AAdd( aCab, { "F1_CODCTR"   , aRetCF[2]		, Nil } )
	
	EndIf
    
	If lMotDevol
		AAdd( aCab, { "F1_MOTIVO"   , cMotivo		, Nil } )
	Endif
	
	If lNrChamado	
		AAdd( aCab, { "F1_01SAC"   , cNrChamado		, Nil } )
	Endif
		
	If lObs
		AAdd( aCab, { "F1_01OBS"   , cObs			, Nil } )
	Endif

	//�����������������������������������������������������������������Ŀ
	//� Verifica se ha itens a serem devolvidos                         �
	//�������������������������������������������������������������������
	If Len(aItens) > 0	
	    
		RetIndex("SD2")

		If cPaisLoc == "BRA"
			Mata103( aCab, aItens , 3)
		Else
			Mata465n( aCab, aItens , 3)		
		EndIf
				
		If  lMsErroAuto
		    DisarmTransaction()
			MOSTRAERRO()
			lRet:= .F. 
		Else		
			//������������������������������������������Ŀ
			//�Atualiza os campos do processo do SIGALOJA�
			//��������������������������������������������
			/*Lj720AtuNFE( cNewDoc   	, cSerie	, cCliente, cLoja , ;
			             nFormaDev	, Nil		, cMotivo	, @nImpostos, xNumCaixa(), .F.)*/

			//�����������������������������������������������������������������������������������������Ŀ
			//�Se selecionar as opcoes "Devolucao" e "Dinheiro", exclui a NCC gerada e gera registro de �
			//�saida de numerario 																	    �			
			//�������������������������������������������������������������������������������������������
			If nFormaDev == 1 .AND. nTpProc == 2
			   Lj720DevDinh( cNewDoc   ,cSerie  ,cCliente  ,cLoja  ,;
			                  nVlrTotal	,@lDevMoeda	,@aDevol	,nImpostos, xNumCaixa())
			Endif
		    
			aDocDev  := { cSerie  , cNewDoc , cCliente , cLoja , ;
			              nTpProc , Space(TamSX3("D1_DOC")[1]), {} } 
			LjImpCNfisc( aDocDev, nVlrTotal )
			
			aAreaSE1 := SE1->(GetArea())		
			SE1->(DbSetOrder(2))
			If SE1->(DbSeek(xFilial("SE1") + cCliente + cLoja + cSerie + cNewDoc ))
				RecLock("SE1",.F.)
				SE1->E1_01SAC 	:= cNrChamado
				SE1->E1_01MOTIV	:= cMotivo
				SE1->E1_USRNAME	:= UsrRetName(__cUserID)
				SE1->E1_HIST	:= cObs
				Msunlock()			
			Endif
			RestArea(aAreaSE1)			
			
			//Atualiza os chamado no SAC				
			LjAtuSUD(aRetSUD,nTpProc)
			
		    MsgInfo("Foi gerado o documento de entrada "+ cNewDoc + " / " + cSerie,"Atne��o")//"Foi gerado o documento de entrada "
	    Endif		
	Else
		Help(" ",1,"OMS320NFD") //Nota Fiscal de devolucao ja gerada
		lRet:= .F.
	Endif
Endif

RestArea( aArea ) 
RestArea( aAreaSF2 )

Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Lj720BkpAre�Autor  � Vendas Cliente    � Data �  24/08/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Recupera os valores do aRotina, aHeader, n e cCadastro apos ���
���			 �a operacao de troca ou devolucao                            ���
�������������������������������������������������������������������������͹��
���Parametros�Lj720BkpArea(ExpC1, ExpA2, ExpA3, ExpN4                     ���
���          �ExpC1 - descricao do cCadastro antes de entrar na rotina    ���
���          �ExpA2 - aRotina antes de entrar na rotina                   ���
���          �ExpA3 - aHeader antes de entrar na rotina                   ���
���          �ExpN4 - n(linha) antes de entrar na rotina                  ���
�������������������������������������������������������������������������͹��
���Uso       � SIGALOJA - VENDA ASSISTIDA                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Lj720BkpArea(cCad, aRots, aSavHead, nBkpLin)

//��������������������������������������������Ŀ
//�Restaura o aRotina, o cCadastro e o aHeader.�
//����������������������������������������������
If Type("cCadastro") <> "U" .AND. Type("aRotina") <> "U" 
   cCadastro	:= cCad
   aRotina  	:= AClone(aRots)
Endif
	
If Type("aHeader")  <> "U"
   aHeader   := aClone(aSavHead)
Endif

If Type("n") <> "U"
   n         := nBkpLin
Endif   

Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �Lj720EstTro� Autor � Vendas Cliente       � Data � 16/09/05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Estorna a rotina de troca caso o cliente desista da operacao���
�������������������������������������������������������������������������Ĵ��
���Parametros�Lj720EstTroc(ExpA1)								          ���
���			 �ExpA1 - Array com as informacoes:					          ���
���			 �	[1] - Serie da NF de devolucao                            ���
���			 �	[2] - Numero da NF de devolucao                           ���
���			 �	[3] - codigo do cliente da NF de devolucao                ���
���			 �	[4] - loja do cliente da NF de devolucao                  ���
���			 �	[5] - tipo de operacao: 1 - troca;2 - devolucao           ���
���			 �	[6] - Numero do Documento anterior de venda	              ���
�������������������������������������������������������������������������Ĵ��
���Uso		 � Automacao Comercial										  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Lj720EstTroc(aDocDev)	      
Local cSerieDev   := aDocDev[1]                        	// Serie do documento de devolucao
Local cNumDev     := aDocDev[2]                        	// Numero do documento de devolucao
Local cClienteDev := aDocDev[3]                        	// Cliente do documento de devolucao
Local cLojaDev    := aDocDev[4]                        	// Loja do cliente do documento de devolucao
Local cTipoNF     := "D"    							// Tipo do documento de entrada
Local cFormProp   := ""                               	// Controla se eh formulario proprio
Local cEspecie    := ""                               	// Especie do documento
Local aCab        := {}                              	// Dados do cabecalho para a rotina automatica
Local aItens      := {}                              	// Dados dos itens para a rotina automatica
Local aLinha      := {}                              	// Dados dos itens para a rotina automatica
Local xRet                                            	// Retorno do PE LJ720ANT
Local lUsafd      := SuperGetMV("MV_LJUSAFD",,.F.)		// Utiliza Fidelizacao de cliente ??
Local cMV_CLIPAD  := SuperGetMV("MV_CLIPAD")			// Cliente padrao
Local cMV_LOJAPAD := SuperGetMV("MV_LOJAPAD")			// Loja do cliente padrao
Local lLJ7042     := .T.								// Retorno do Ponto de Entrada "LJ7042"
Local cPdv		  := LjGetStation( "PDV" )				// Numero do PDV
Local cNumCup	  := aDocDev[6]							// Numero do cupom 
Local nX		  := 0

Private lMsErroAuto := .F.
   
DbSelectArea("SD1")
DbSetOrder(1)
DbSeek(xFilial("SD1") + cNumDev + cSerieDev + cClienteDev + cLojaDev)
While !Eof() .AND.  xFilial("SD1")	== SD1->D1_FILIAL 	.AND.	;
					cNumDev 		== SD1->D1_DOC 		.AND.	;
					cSerieDev 		== SD1->D1_SERIE 	.AND.	;
					cClienteDev 	== SD1->D1_FORNECE	.AND. 	;
					cLojaDev 		== SD1->D1_LOJA

	aLinha := {}				
	AAdd( aLinha, { "D1_DOC"    	, SD1->D1_DOC 	    , Nil } )	
	AAdd( aLinha, { "D1_SERIE"    	, SD1->D1_SERIE	    , Nil } )	
	AAdd( aLinha, { "D1_FORNECE"   	, SD1->D1_FORNECE 	, Nil } )	
	AAdd( aLinha, { "D1_LOJA"    	, SD1->D1_LOJA	    , Nil } )		
	AAdd( aLinha, { "D1_COD"    	, SD1->D1_COD 	    , Nil } )
	AAdd( aLinha, { "D1_ITEM"    	, SD1->D1_ITEM 	    , Nil } )	
    AAdd( aItens, aLinha)
      
    DbSkip()      
End

AAdd( aCab, { "F1_DOC"    , cNumDev						, Nil } )	// Numero da NF : Obrigatorio
AAdd( aCab, { "F1_SERIE"  , cSerieDev					, Nil } )	// Serie da NF  : Obrigatorio

//�����������������������������������������������������������������Ŀ
//� Monta o cabecalho de acordo com o tipo da devolucao             �
//�������������������������������������������������������������������
AAdd( aCab, { "F1_FORNECE", cClienteDev					, Nil } )	// Codigo do Fornecedor : Obrigatorio
AAdd( aCab, { "F1_LOJA"   , cLojaDev   					, Nil } )	// Loja do Fornecedor   : Obrigatorio
AAdd( aCab, { "F1_TIPO"   , cTipoNF						, Nil } )	// Tipo da NF   		: Obrigatorio

//������������������Ŀ
//�Limpa filtro ativo�
//��������������������
DbSelectArea("SD2")
RetIndex("SD2")
DbClearFilter()
  
If cPaisLoc == "BRA"
	//"Aguarde...Cancelando a Nota Fiscal de Devolu��o."
	MsgRun("Aguarde...Cancelando a Nota Fiscal de Devolu��o.",,{||MSExecAuto({|x,y,z| MATA103(x,y,z)}, aCab, aItens, 5)})
EndIf

If lMsErroAuto
	DisarmTransaction()
	MostraErro()
Else	
	//--------------------------------------------------------------------------------
	// Acerta os campos de devolucao (D2_QTDEDEV e D2_VALDEV) caso a filial de origem 
	// da venda seja diferente da filial de troca.
	//--------------------------------------------------------------------------------
	If Len(aRecnoSD2) > 0 .And. aRecnoSD2[1][5] <> cFilAnt
		DbSelectArea("SD2")
		For nX := 1 to Len(aRecnoSD2)
			SD2->(DbGoTo(aRecnoSD2[nX][4]))
			//Retorna os valores anteriores de backup dos campos
			RecLock("SD2",.F.)
			SD2->D2_QTDEDEV := aRecnoSD2[nX][6]
			SD2->D2_VALDEV 	:= aRecnoSD2[nX][7]
			SD2->( MsUnLock() )
		Next nX
	EndIf
	
	//������������������������������������
	//�Exclusao do registro da tabela SLX�
	//������������������������������������
	If AliasIndic("SLX")
		cPdv := Padr(cPdv,TamSx3("LX_PDV")[1])
		
		DbSelectArea("SLX")
		DbSetOrder(1)
		If DbSeek(xFilial("SLX")+cPdv+cNumCup)
			While SLX->(!EOF()) .AND. SLX->LX_FILIAL+SLX->LX_PDV+SLX->LX_CUPOM ==;
									   xFilial("SLX")+cPdv+cNumCup
	        	RecLock("SLX",.F.)   
				SLX->(DbDelete())
	        	MsUnlock()
	        	
	        	SLX->(DbSkip())									   
			End
		Endif	
	Endif	
	
    MsgInfo("Nota Fiscal de Devolu��o estornada com sucesso!","Atne��o")  //"Nota Fiscal de Devolu��o estornada com sucesso!"
Endif   
		   
Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �Lj720VldPro� Autor � Vendas Cliente       � Data � 16/09/05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Validacao do produto quando nao tem NF de origem   		  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Lj720VldProd(ExpC1, ExpN2)                                 ���
���			 � ExpC1 - Codigo do produto 							      ���
���			 � ExpN2 - Quantidade devolvida							      ���
�������������������������������������������������������������������������Ĵ��
���Uso		 � Automacao Comercial										  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Lj720VldProd(  cCodProd  ,nQuant   )
Local lRet := .T.   						//Variavel de retorno, controla se o produto foi validado

nQuant  := Max(nQuant,1)
If lRet  := LJSB1SLK(  @cCodProd  ,@nQuant   ,.F.     ) 
   lRet  := Lj720Trigger(  'TRB_CODPRO'  ,  cCodProd   ,nQuant   )  
   M->TRB_CODPRO := cCodProd
Endif   

Return (lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �lj720Nota � Autor � Vendas Cliente        � Data �22/10/05  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Controle de numeracao do documento de entrada, permitindo o ���
���			 �controle tanto pelo SXE/SXF quanto pelo SX5				  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Lj720Nota(ExpC1, ExpC2)       							  ���
���			 �ExpC1 - Serie padrao de devolucao							  ���
���			 �ExpC2 - Numero do documento de devolucao					  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �Automacao Comercial										  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Lj720Nota(cMVSerie, cNumDoc, lFormul, nNFOrig)

//������������������Ŀ
//� Variaveis Locais �
//��������������������
Local nOpcA 	 := 0									// Opcao da tela de selecao da serie
Local nSaveSx8 	 := GetSx8Len()							// Controle do SXE/SXF
Local nCntErro   := 0									// Contador de tentativas de lock do registro do SX5
Local nTamNota   := TamSx3("F1_DOC")[1]					// Tamanho do campo F1_DOC
Local aSerNf     := {}									// Series e numeros respectivos cadastrados na tabela 01 do SX5
Local cCadastro  := "Notas"								// Titulo da janela: "Notas"
Local cVarQ      := "  "								// Variavel da serie escolhida
Local cMV_LJNRNFS:= SuperGetMv("MV_LJNRNFS",.F.,"2")	// Parametro que controla o tipo de numeracao
														// 1 - Numeracao controla pelo SX5
														// 2 - Numeracao controla pelo SXE/SXF
														// 3 - Numeracao controla pelo SD9
Local lDone      := .F.									// Controle da tela de selecao da serie/numero
Local lAbandona  := .F.									// Controle da tela de selecao da serie/numero
Local lInterno   := .T.									// Controle da tela de selecao da serie/numero
Local lAvanca    := SuperGetMV("MV_LJAVANC")			// Controla se permite alterar o numero da NF sugerida
Local cMV_TPNRNFS:= LJTpNrNFS()							// Retorno do parametro MV_TPNRNFS, utilizado pela Sx5NumNota() de onde serah controlado o numero da NF  1=SX5  2=SXE/SXF  3=SD9
Local aLockSX5[0]										// Matriz com os recnos dos registros travados no SX5.
Local lReturn    := .T.									// Valor que sera retornado pela funcao.
Local oQual												// Objeto do list box das series cadastradas
Local oDlg												// Objeto do dialog
Local lLj720PrxNum := FindFunction("U_LJ720PRXNUM")		// Verifica se tem o PE LJ720PRXNUM 
Local cFilSx5		:= If(FindFunction("LjFilSX5"),LjFilSX5(),xFilial("SX5")) // Retorna Filial SX5	

Default lFormul		:= .T.								// indica Formulario Proprio
Default nNFOrig		:= 1								// 1- com documento / 2 - sem documento

//����������������������������������������������������������������������Ŀ
//� Faz um tratamento diferenciado para o controle de NF pelo SD9 quando �
//� o parametro MV_TPNRNFS for igual a "3"                               �
//������������������������������������������������������������������������
If cMV_TPNRNFS == "3"
	If Empty( cMvSerie )
		If !Sx5NumNota( Nil, cMV_TPNRNFS )
			Return .F.
		Else
			Return .T.
		Endif
	Else
		Return .T.
	Endif
Endif

//�����������������������������������������������������Ŀ
//� Caso o Par�metro MV_LJNFTRO estiver vazio, Desenha  �
//� a tela para escolha do Nota/Serie			        �
//�������������������������������������������������������
If SuperGetMV("MV_LJNFSXE")
	//��������������������������������������������������������������������������Ŀ
	//� Faz o tratamento de pegar o numero da nota via semaforo ou via           �
	//� SX5 (tabela 01)                                                          �
	//����������������������������������������������������������������������������
	//������������������������������������������������������������������Ŀ
	//�Se a serie estiver em branco abre a tela para a escolha do usuario�
	//��������������������������������������������������������������������
	If Empty(cMvSerie)
		If !Sx5NumNota(@cMvSerie, cMV_LJNRNFS)
			Return .F.
		Endif
	Endif

	//se a nota fiscal vai ser transmitida, a nota/troca dever� ser vinculada a uma nota de sa�da
	If !LjNFeEntOk(cMvSerie, lFormul, nNFOrig)
		Return .F.
	EndIf
	
	cNumDoc := NxtSX5Nota( cMVSerie,,cMV_LJNRNFS,lAvanca )
	cNumDoc := PadR( cNumDoc , TamSx3("F2_DOC")[1] )	
	
	If !LjValNota(cMVSerie,cNumDoc) // Varifica se jah existe a nota
		Return .F.	
	Endif

	While (GetSX8Len() > nSaveSx8 )
		ConfirmSX8()
	End
ElseIf Empty(cMvSerie)
	DbSelectArea("SX5")
	While !lAbandona .AND. DbSeek( cFilSx5+"01",.F. ) .AND. !lDone
		lInterno := .T.
		While cFilial+"01" == X5_FILIAL+X5_TABELA .AND. !lAbandona
			//�������������������������������������������������������������Ŀ
			//� Se a S�rie for CPF, n�o mostra no aChoice, pois � utilizada �
			//� internamente para emissao de Cupom Fiscal.	   			     �
			//���������������������������������������������������������������
			If (AllTrim(SX5->X5_CHAVE) == "CPF") .OR. ;
				(AllTrim(SX5->X5_CHAVE) == "CP")
			Else
				If !MsRLock()
					lInterno := .F.
					lDone    := .F.
					aSerNF   := {}
					If (++nCntErro > 10)
						lAbandona := .T.
					Endif
					Loop
				Else
					aAdd(aLockSX5, RecNo())
					
					If !lAbandona
						If !(ValType(aSerNF) == "A")
							aSerNF := {}
						Endif
						lDone := .T.
						AADD( aSerNF,{ Padr( X5_CHAVE, 3 ), StrZero( Val( X5Descri() ), nTamNota ) } )
					Endif
				Endif
			Endif
			DbSkip()
		End
	End
	
	If (Len(aSerNF) == 0) .OR. lAbandona
		MsUnlock()
		Help(" ",1,"A460FLOCK")
		lReturn := .F.
	Endif
	
	If lReturn
		nOpcA := 0
		While nOpcA <> 1
			DEFINE MSDIALOG oDlg TITLE cCadastro From 10,30 To 19,68 OF oMainWnd
			//"Serie"
			@ .5,.80 LISTBOX oQual VAR cVarQ Fields HEADER "Serie",cCadastro SIZE 130,42 ON DBLCLICK (aSerNF:=LjxDX5Troca(oQual:nAt,aSerNF),oQual:Refresh()) NOSCROLL
			oQual:SetArray(aSerNF)
			oQual:bLine := { || {aSerNf[oQual:nAT,1],aSerNf[oQual:nAT,2]}}
			
			DEFINE SBUTTON FROM 51,109	TYPE 1 ACTION ;
			(If(LjxDANf(oQual,aSerNF,@cMVSerie,@cNumDoc),( nOpcA := 1, oDlg:End()),)) ENABLE OF oDlg
			
			ACTIVATE MSDIALOG oDlg
		End
		
				//se a nota fiscal vai ser transmitida, a nota/troca dever� ser vinculada a uma nota de sa�da
		If !LjNFeEntOk(cMvSerie, lFormul, nNfOrig)
			Return .F.
		EndIf

		DbSelectArea("SX5")
		If SX5->( DbSeek( cFilSx5 + "01" + cMVSerie,.F.) )
			MsRLock()
		    REPLACE X5_DESCRI  WITH PadR( StrZero(Val(cNumDoc)+1,Len(AllTrim(cNumDoc))) , nTamNota)
		    REPLACE X5_DESCSPA WITH PadR( StrZero(Val(cNumDoc)+1,Len(AllTrim(cNumDoc))) , nTamNota)
		    REPLACE X5_DESCENG WITH PadR( StrZero(Val(cNumDoc)+1,Len(AllTrim(cNumDoc))) , nTamNota)
			MsUnlock()
		Else
			MsUnlock()
			Return(.F.)
		Endif
	Endif
	aEval( aLockSX5, {|x| dbGoTo(x), MsUnlock() })
Else
	//se a nota fiscal vai ser transmitida, a nota/troca dever� ser vinculada a uma nota de sa�da
	//If LjNFeEntOk(cMvSerie, lFormul, nNfOrig)
		DbSelectArea("SX5")

		If SX5->( DbSeek(cFilSx5 + "01" + cMvSerie) )			   
			cNumDoc := NxtSX5Nota( cMVSerie )

			// Quando a quantidade de digitos da NF for 6 (menor que o campo F1_DOC - 09),
	    	// preencher com espacos a direita do conteudo para efeito de pesquisa.
			cNumDoc := PadR( cNumDoc, TamSX3("F1_DOC")[1] )
		Else
			HELP(" ",1,"ERROSERIE")
			lReturn := .F.
		EndIf	
	//Else
		//Return .F.
	//EndIf
Endif

If lLj720PrxNum 
   U_LJ720PRXNUM(@cMVSerie, @cNumDoc)
EndIf
Return lReturn

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �Lj720DevDi� Autor � Vendas Cliente        � Data �27/12/05  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Exclui a NCC gerada e gera registro de devolucao em Dinheiro���
�������������������������������������������������������������������������Ĵ��
���Parametros�Lj720DevDinh(ExpC1, ExpC2, ExpC3, ExpC4, ExpN5)             ���
���			 �ExpC1 - numero do documento de entrada gerado               ���
���			 �ExpC2 - serie do documento de entrada gerado(prefixo titulo)���
���			 �ExpC3 - codigo do cliente								      ���
���			 �ExpC4 - loja do cliente								      ���
���			 �ExpN5 - valor devolvido								      ���
���			 �ExpL6 - Devolucao em varias moedas				          ���
���			 �ExpA7 - Dados da devolucao						          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �LOJA720               									  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Lj720DevDinh( cNewDoc   	,cSerie  	,cCliente  	,cLoja  ,;
                       nVlrTotal	, lDevMoeda	, aDevol	, nImpostos,;
                       cCaixa		, cTipoDoc	, cHistorico)

Local aArea     	:= GetArea()                          	// Area inicial
Local cParcela  	:= AllTrim(SuperGetMV("MV_1DUP"))     	// Inicializacao da primeira parcela
Local cSimb1    	:= AllTrim(SuperGetMV("MV_SIMB1"))    	// Simbolo da moeda principal
Local cNatDevol 	:= AllTrim(SuperGetMV("MV_NATDEV"))   	// Natureza da devolucao
Local cPrefixoEnt	:= ""									//Prefixo da nota de entrada
Local nDecs  		:= 0									// Decimais	
Local nX 			:= 1									// Contador

Default lDevMoeda 	:= .F.
Default aDevol 		:= {}
Default nImpostos 	:= 0
Default cCaixa 		:= xNumCaixa() 
Default cTipoDoc 		:= "LJ"
Default cHistorico 	:= "BAIXA REF. DEVOL. EM DINHEIRO"		//"BAIXA REF. DEVOL. EM DINHEIRO"
                  
//�����������������������������������������������������������Ŀ
//�Pega o prefixo da nota de entrada para fazer a baixa da NCC�
//�������������������������������������������������������������
DbSelectArea("SF1")
DbSetOrder(1)
If DbSeek(xFilial("SF1")+cNewDoc+cSerie+cCliente+cLoja ) 
	cPrefixoEnt := SF1->F1_PREFIXO
Else
	cPrefixoEnt := cSerie
Endif 
 
 
//�����������������������������������������������������������������������Ŀ
//� Exclui a Nota de Credito porque foi devolvido em dinheiro ao cliente  �
//� A Nota de Credito foi gerada pela rotina automatica do MATA103		  �
//�������������������������������������������������������������������������
DbSelectArea("SE1")
DbSetOrder( 2 )
If DbSeek( xFilial("SE1") + cCliente + cLoja + cPrefixoEnt + cNewDoc  )
	
	While !Eof() .AND. SE1->E1_FILIAL 	    == xFilial("SE1") .AND.;
	                    SE1->E1_CLIENTE		== cCliente       .AND.;
						SE1->E1_LOJA		== cLoja          .AND.;
						SE1->E1_PREFIXO		== cPrefixoEnt    .AND.;
						SE1->E1_NUM			== cNewDoc
										
       If (SE1->E1_TIPO $ MV_CRNEG) .AND. SE1->E1_VALOR == SE1->E1_SALDO
          RecLock("SE1",.F.)   
          DbDelete()
          MsUnlock()
	   Endif
	    
	   DbSkip()
	End
Endif	

If !lDevMoeda
	//�����������������������������������������������������������������������Ŀ
	//� Gera o registro correspondente a devolucao em dinheiro ao cliente     �
	//�������������������������������������������������������������������������
	RecLock("SE5",.T.)
	REPLACE	SE5->E5_FILIAL	WITH xFilial("SE5")
	REPLACE	SE5->E5_PREFIXO	WITH cPrefixoEnt
	REPLACE	SE5->E5_NUMERO	WITH cNewDoc
	REPLACE	SE5->E5_PARCELA	WITH cParcela
	REPLACE	SE5->E5_CLIFOR	WITH cCliente
	REPLACE	SE5->E5_LOJA	WITH cLoja
	REPLACE	SE5->E5_DOCUMEN	WITH cSerie+cNewDoc+cParcela+cSimb1+cLoja
	REPLACE	SE5->E5_DATA	WITH dDataBase
	REPLACE	SE5->E5_AGENCIA	WITH "."
	REPLACE	SE5->E5_TIPODOC	WITH cTipoDoc
	REPLACE	SE5->E5_TIPO	WITH cSimb1
	REPLACE	SE5->E5_HISTOR	WITH cHistorico                 //"BAIXA REF. DEVOLUCAO"
	REPLACE	SE5->E5_VALOR	WITH nVlrTotal + nImpostos
	REPLACE	SE5->E5_DTDIGIT	WITH dDataBase
	REPLACE	SE5->E5_NATUREZ	WITH &(cNatDevol)	
	REPLACE	SE5->E5_DTDISPO	WITH SE5->E5_DATA
	REPLACE	SE5->E5_BANCO	WITH cCaixa
	REPLACE	SE5->E5_CONTA	WITH "."
	REPLACE	SE5->E5_VENCTO	WITH dDataBase
	REPLACE	SE5->E5_RECPAG	WITH "P"
	REPLACE	SE5->E5_MOTBX	WITH "NOR"
	REPLACE	SE5->E5_BENEF	WITH cUserName
	REPLACE	SE5->E5_FILORIG	WITH cFilAnt
	MsUnLock()
	//�������������������������������Ŀ
	//� Atualiza saldo do BANCO Caixa �
	//���������������������������������
	AtuSalBco(	SE5->E5_BANCO	, SE5->E5_AGENCIA , SE5->E5_CONTA , SE5->E5_DTDISPO ,;
			  	SE5->E5_VALOR	,	"-"	) 
Else
	If Len(aDevol) > 0
		//������������������������������������������������������������Ŀ
		//� Criando registro de movimenta�ao no SE5 para acerto do     �
		//� numer�rio devolvido pelo Caixa, desde que nao gerou NCC    �
		//��������������������������������������������������������������
		For nX := 1 to Len(aDevol)
			If aDevol[nX][3] > 0
			
				nDecs := MsDecimais(nX,aDevol)
			
				RecLock("SE5",.T.)
				REPLACE E5_FILIAL  	WITH xFilial("SE5")
				REPLACE E5_DATA	 	WITH dDataBase
				REPLACE E5_CLIFOR  	WITH cCliente
				REPLACE E5_LOJA	 	WITH cLoja
				REPLACE E5_AGENCIA 	WITH If (nX==1,".",SuperGetMv("MV_SIMB"+Str(nX,1)))
				REPLACE E5_TIPODOC 	WITH cTipoDoc
				REPLACE E5_TIPO	 	WITH SuperGetMv("MV_SIMB"+Str(nX,1))
				REPLACE E5_VALOR	WITH aDevol[nX][3]
				REPLACE E5_DTDIGIT 	WITH dDataBase
				REPLACE E5_DTDISPO 	WITH SE5->E5_DATA
				REPLACE E5_BANCO	WITH cCaixa
				REPLACE E5_CONTA	WITH "."
				REPLACE E5_VENCTO  	WITH dDataBase
				REPLACE E5_RECPAG  	WITH "P"
				REPLACE E5_MOTBX	WITH "NOR"
				REPLACE E5_BENEF	WITH Substr(cUsuario,7,15)
				REPLACE E5_VLMOED2 	WITH Round(xMoeda(aDevol[nX][3],nX,1,SE5->E5_DATA,nDecs+1),nDecs)
				REPLACE E5_HISTOR  	WITH cHistorico //"BAIXA REF. DEVOL. EM DINHEIRO"
				REPLACE	SE5->E5_NATUREZ	WITH &(cNatDevol)	
				
				MsUnLock()
				//�������������������������������Ŀ
				//� Atualiza saldo do BANCO Caixa �
				//���������������������������������
				AtuSalBco(	SE5->E5_BANCO	, SE5->E5_AGENCIA , SE5->E5_CONTA , SE5->E5_DTDISPO ,;
						  	SE5->E5_VALOR	,	"-"	)
			EndIf
		Next nX
	EndIf
EndIf


RestArea(aArea)

Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �Lj720ValDe� Autor � Vendas Cliente        � Data �10/01/06  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Valida se as opcoes "Compensa NCC" e "Forma de devolucao"   ���
���          �estao consistentes										  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpL1 := Lj720ValDev(ExpL2, ExpN3, ExpN4, ExpN5, ExpN6)     ���
���			 �ExpL1 - retorna se as opcoes selecionadas sao validas       ���
���			 �ExpL2 - indica se selecionou compensacao da NCC             ���
���			 �ExpN3 - forma de devolucao(1-dinheiro;2-NCC)				  ���
���			 �ExpN4 - tipo de operacao(1-troca;2-devolucao)	              ���
���			 �ExpN5 - 1-Com NF de origem ou 2-Sem NF de origem            ���  
���			 �ExpN6 - array que traz a posicao do registro selecionado,   ���
���			 �		  a partir dele � poss�vel pegar o cNumDoc e cSerieDoc���
�������������������������������������������������������������������������Ĵ��
��� Uso      �LOJA720               									  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Lj720ValDev( lCompCR  	, nFormaDev		,nTpProc  	,nNfOrig 	,;
							 lFormul  	, aRecSD2		,cMotivo	,cObs		,;
							 cNrChamado	, cTpAcao)

Local lRet          := .T.														// Variavel de retorno.
Local cMV_LJCHGDV   := AllTrim(SuperGetMV("MV_LJCHGDV",,"1"))                  // Define se permite ou nao modificar a forma de devolucao ao cliente("0"-nao permite;"1"-permite)
Local cMV_LJCMPNC   := AllTrim(SuperGetMV("MV_LJCMPNC",,"1"))                  // Define se permite ou nao modificar a opcao para compensar a NCC com o titulo da NF original("0"-nao permite;"1"-permite)
Local xRet          := Nil                                                     // Retorno do ponto de entrada LJ720VLFIN

Default lFormul     := .F. 
Default aRecSD2		:= {}

If Empty(cMotivo)
	MsgStop("� obrigat�rio o preenchimento do campo motivo.","Aten��o")
	lRet   := .F.
Endif

If Empty(cNrChamado) .And. lRet
	MsgStop("� obrigat�rio o preenchimento do campo numero do chamado.","Aten��o")
	lRet   := .F.
Endif

If Empty(cObs) .And. lRet
	MsgStop("� obrigat�rio o preenchimento do campo observa��o.","Aten��o")
	lRet   := .F.
Endif

If Empty(cTpAcao) .And. lRet
	MsgStop("� obrigat�rio o preenchimento do campo tipo da a��o.","Aten��o")
	lRet   := .F.
Endif
	
If lRet .AND. nTpProc == 2   
   If lCompCR .AND. nFormaDev == 1 .AND. cMV_LJCMPNC == "1" .AND. cMV_LJCHGDV == "1" .AND. nNfOrig == 1
      //"H� uma incompatibilidade na sele��o das op��es. Para compensar a NCC deve ser selecionada a forma de devolu��o Nota de Cr�dito."		
      MsgStop("H� uma incompatibilidade na sele��o das op��es. Para compensar a NCC deve ser selecionada a forma de devolu��o Nota de Cr�dito.")   
      lRet   := .F.
   Endif
Endif

Return (lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �Lj720AtuTr� Autor � Vendas Cliente        � Data �08/02/06  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Atualiza o valor da variavel lTroca quando fecha o Dialog   ���
���			 �Se nao confirmou a operacao, deve setar para .F. uma vez que���
���			 �foi inicializada com .T.								      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �LOJA720               									  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Lj720AtuTrc()

//����������������������������������������������������������������������������������������Ŀ
//�Se a operacao nao foi confirmada, atualiza a variavel de Troca pois ja foi inicializada.�
//�Caso contrario,mantem o valor da variavel dependendo se foi troca(.T.) ou devolucao(.F.)�
//������������������������������������������������������������������������������������������
If !lConfirma .AND. lTroca
   lTroca  := .F.
End      

Return .T.
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LJ720RecCo�Autor  � Vendas Cliente     � Data � 26/04/2006  ���
�������������������������������������������������������������������������͹��
���Desc.     � Recalculo das comissoes no SE3.                            ���
�������������������������������������������������������������������������͹��
���Parametros�ExpA1 - Posicao no SD2     					              ���
�������������������������������������������������������������������������͹��
���Uso       � LOJA720                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function LJ720RecComis( aPosSd2, nFormaDev, cCodFil )
Local aArea   		:= GetArea()								//GetArea
Local aAreaL1 		:= SL1->(GetArea())						//GetArea do SL1
Local aAreaD2		:= SD2->(GetArea())						//GetArea do SD2
Local nDecs  		:= MsDecimais( 1 )							//Decimais
Local nBaseComis    := 0										//Base da comissao
Local cPrefixo		:= ""										//Prefixo
Local nValDevD2		:= 0										//Valor de devolucao no SD2
Local nValTotD2		:= 0										//Valor de venda no SD2
Local cNumNota		:= ""										//Armazena o numero da Nota
Local cSerie		:= ""										//Serie da nota
Local cCodCli		:= ""										//Codigo do Cliente
Local cLojCli		:= ""										//Loja do Cliente
Local cTpComiss		:= SuperGetMv("MV_LJTPCOM",,"1")			//Tipo de calculo de comissao utilizado (1-Para toda a venda (padrao),2-Por item)

Default nFormaDev	:= 1										//Define a forma de devolucao ao cliente: 1-Dinheiro; 2-NCC
Default cCodFil 	:= cFilAnt									//Filial de origem da venda

//�����������������������������������������������������Ŀ
//�Armazena nas variaveis a primeira posicao do aPosSd2,�
//�pois somente esta posicao sera utiliza para o Seek   �
//�������������������������������������������������������
If Len(aPosSd2) > 0
	cNumNota	:= aPosSd2[1][1]
	cSerie		:= aPosSd2[1][2]
	cCodCli		:= aPosSd2[1][3]
	cLojCli		:= aPosSd2[1][4]

	cNumNota    := PadR( cNumNota , TamSx3("D2_DOC")[1] )

	DbSelectArea("SD2")
	DbSetOrder(3)
	If DbSeek(FWxFilial("SD2",cCodFil) + cNumNota + cSerie + cCodCli + cLojCli)
		While !Eof() .AND.	cNumNota 	== SD2->D2_DOC 		.AND. ;
							cSerie 		== SD2->D2_SERIE 	.AND. ;
							cCodCli 	== SD2->D2_CLIENTE	.AND. ;
							cLojCli 	== SD2->D2_LOJA
			nValTotD2	+= 	SD2->D2_TOTAL
			nValDevD2 	+=	SD2->D2_VALDEV
			DbSkip()
			Loop
		End
	Endif
	//������������������������������������������������������Ŀ
	//�Verifica qual e a nova Base para o calculo da comissao�
	//��������������������������������������������������������
	nBaseComis := Abs(nValTotD2 - nValDevD2)
	
	DbSelectArea("SL1")
	DbSetOrder(2) 
	If DbSeek(FWxFilial("SL1",cCodFil)+cSerie+cNumNota)
		//�������������������������������������������Ŀ
		//�Posicao do Parametro de Geracao de Comissao�
		//���������������������������������������������
		If Substr(SL1->L1_CONFVEN,11,1) <> "N"
			cPrefixo := LJPREFIXO()
			DbSelectArea("SE3")
			DbSetOrder(1)                               
			If DbSeek(FWxFilial("SE3",cCodFil) + cPrefixo + SL1->L1_DOC)
				While (!Eof()) .AND. (!Empty(SL1->L1_VEND)) .AND. (cPrefixo + SL1->L1_DOC == E3_PREFIXO + E3_NUM)
					//���������������������������������Ŀ
					//�Nao estorna comissoes ja baixadas�
					//�����������������������������������
					If !Empty( E3_DATA )
						//A comiss�o do vendedor j� foi paga. Dever� ser revista"
						MsgInfo("A comiss�o do vendedor j� foi paga. Dever� ser revista","Atne��o")
						DbSkip()
						Loop
					Endif
					//��������������������������Ŀ
					//� Atualiza��o de Comiss�es �
					//����������������������������
					RecLock("SE3",.F.,.T.)
					//�����������������������������������������������
					//�Se a Base da Comissao for zero, entao deleta �
					//�o registro do SE3, caso contrario, atualiza. �
					//�����������������������������������������������
					//Se for Troca,e calculo da comissao pela baixa e for Dinheiro nao deleta o registro caso contrario deleta. 
				    If SE3->E3_BAIEMI <> "B" .OR. !lTroca .OR. (SE3->E3_BAIEMI == "B" .AND. !ISMONEY(SE3->E3_TIPO) )					
						If nFormaDev == 1 .OR. cTpComiss == "2"
							If nBaseComis == 0
								DbDelete()
							Else    
								REPLACE SE3->E3_BASE  	WITH nBaseComis
								REPLACE SE3->E3_COMIS	WITH Round( ( nBaseComis * SE3->E3_PORC ) / 100 ,nDecs)
							EndIf
						EndIf
					EndIf	
					MsUnlock()
					DbSkip()
				End
			Endif
		Endif
	Endif
Endif
RestArea(aAreaL1)
RestArea(aAreaD2)
RestArea(aArea)

Return Nil
          
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Lj720CnSD9�Autor  � Vendas Cliente     � Data � 11/09/2006  ���
�������������������������������������������������������������������������͹��
���Desc.     �Cancela a reserva do numero de nota na SD9                  ���
�������������������������������������������������������������������������͹��
���Parametros�ExpC1 - Numero do documento a ser limpo 		              ���
���          �ExpC2 - Serie do documento a ser Limpo		              ���
���          �ExpC3 - Tipo de controle de geracao de documentos           ���
�������������������������������������������������������������������������͹��
���Uso       � LOJA720                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Lj720CnSD9(cDoc, cSerie, cMV_TPNRNFS) 

Local lGrpCNPJ := MaIsNumCgc() // Verifica a utilizacao da numeracao por Agrupamento por CNPJ 

//����������������������������������������������������������������������Ŀ
//�So devera voltar a sequencia do SD9 quando estiver configurar para que�
//�ser utilizada conforme boletim 006 - LOJA - Numeracao de NF pelo SD9  �
//������������������������������������������������������������������������
If cMV_TPNRNFS == "3" .AND. SuperGetMV("MV_LJNFSXE")	

	SD9->( DbSetOrder( 2 ) )
	SD9->( DbSeek( xFilial( "SD9" ) + cSerie + cDoc ) )
	
	If !SD9->( Eof() )
		RecLock("SD9",.F.)
		REPLACE D9_DTUSO 	WITH Ctod("  /  /  ")
		REPLACE D9_HORA		WITH ""
		REPLACE D9_USUARIO 	WITH ""

		If lGrpCNPJ // Realiza a Liberacao conforme Agrupamento por CNPJ

			Replace D9_FILIAL    With ""
			Replace D9_FILORI    With ""

		Endif		
		
		MsUnlock()
	EndIf

Endif
	
Return .T.


/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �LjImpCNfisc �Autor  � Vendas Cliente     � Data �  07/11/06   ���
���������������������������������������������������������������������������͹��
���Desc.     �Imprime cupom nao fiscal nao vinculado quando utilizar troca  ���
���          �ou devolucao.                                                 ���
���������������������������������������������������������������������������͹��
���Parametro � ExpA1 - Informacoes do documento de troca                    ���
���          �    [1] - Serie do documento                                  ���
���          �    [2] - Novo documento                                      ���
���          �    [3] - Cliente                                             ���
���          �    [4] - Loja                                                ���
���          �    [5] - 1) Troca  2) Devolucao                              ���
���          � ExpN1 - Valor total a ser devolvido ou trocado               ���
���          �                                                              ���
���������������������������������������������������������������������������͹��
���Uso       � LOJA720                                                      ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
Static Function LjImpCNfisc( aDocDev, nVlrTotal	)
Local cTickForm := ""      	// String que guarda o que sera impresso.
Local nI 		:= 0       	// Contator para o For 
Local lImprime  := .T.		// Indica se imprime novamente o relatorio gerencial na impressora

If LjAnalisaLeg(22)[1]
	For nI := 1 To Len( aDocDev )
		Do Case
			Case nI == 1
				cTickForm += CHR(13) + CHR(10)
				cTickForm += PadR( "Serie....:" + aDocDev[nI], 40 ) + CHR(13) + CHR(10) // "Serie....: "
				cTickForm += CHR(13) + CHR(10)
			Case nI == 2
				cTickForm += PadR( "Documento: " + aDocDev[nI], 40 ) + CHR(13) + CHR(10) // "Documento: "
				cTickForm += CHR(13) + CHR(10)
			Case nI == 3
				cTickForm += PadR( "Cliente..: " + aDocDev[nI], 40 ) + CHR(13) + CHR(10) // "Cliente..: "
				cTickForm += CHR(13) + CHR(10)
			Case nI == 4
				cTickForm += PadR( "Loja.....: " + aDocDev[nI], 40 ) + CHR(13) + CHR(10) // "Loja.....: "
				cTickForm += CHR(13) + CHR(10)
			Case nI == 5		   
				If aDocDev[nI] == 1
					cTickForm += PadR( "Valor Total da Troca.....: R$ " + Transform(nVlrTotal, "99,999.99" ), 40 ) + CHR(13) + CHR(10) // "Valor Total da Troca.....: R$ "
				Else
					cTickForm += PadR( "Valor Total da Devolucao.: R$ " + Transform(nVlrTotal, "99,999.99" ), 40 ) + CHR(13) + CHR(10) // "Valor Total da Devolucao.: R$ "
				EndIf
				cTickForm += CHR(13) + CHR(10)
		EndCase
	Next nI

	While lImprime
		lImprime	:= .F.
		nRet 		:= -1
		nRet 		:= IFRelGer( nHdlECF, cTickForm, 1 )
		lImprime 	:= LjTEFAskImp(1, nRet)
	End
EndIf

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �Lj720AltMd� Autor � Vendas Cliente        � Data � 21/05/07 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Habilita ou Desabilita o combo Devolucao em Outro Moeda    ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe	 � ExpL1 := Lj720AltMd(ExpN1,ExpO2)                           ���
�������������������������������������������������������������������������Ĵ��
���Parametro � ExpN1 := Forma de devolucao                                ���
���          � ExpO2 := Objeto a ser atualizado                           ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � ExpL1 := Se permite a edicao ou nao                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � LOJA720 - Localizacoes       				              ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Lj720AltMd( nFormaDev , oDevMoeda )
Local lRet	:= .T.                                // Retorno da funcao

//�������������������������Ŀ
//�Somente para localizacoes�
//���������������������������
If cPaisLoc <> "BRA" 

	If nFormaDev == 1
		oDevMoeda:Enable()
	Else
		oDevMoeda:Refresh()
		oDevMoeda:Disable()
	Endif	
	
	oDevMoeda:Refresh()          

EndIf

Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Lj720Lote �Autor  � Vendas Cliente     � Data �  29/08/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �F4 que consulta o lote do produto, caso habilitado o        ���
���          �MV_Rastro                                                   ��� 
�������������������������������������������������������������������������͹��
���Parametros�F4 que consulta o lote do produto, caso habilitado o        ���
���          �MV_Rastro                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Lj720Lote( )
Local aArrayF4		:={}			// Armazena as linhas do DbSeek do Lote
Local cVar			:= ""			// Conteudo da list-box 					
Local cPict			:= ""			// Picture de exibicao do saldo
Local nOpca 		:= 0			// Opcao na selecao do objeto
Local nList 		:= 0			// Linha selecionada do objeto
Local nOrd 			:= IndexOrd()	// Guarda a ordem corrente
Local cProduto		:= TRB->TRB_CODPRO	// Codigo do Produto	
Local cLoteCt		:= ""			// Armazena o sub-lote selecionado
Local nSaldoLt 		:= 0			// Saldo acumulado do produto selecionado
Local cAlias		:= ""			// Armazena a Area corrente
Local cDtValid		:= ""			// Armaneza a data de validade do lote
Local cLote			:= ""			// Armaneza o lote
Local cProdutoLt	:= ""			// Aramzena o produto do lote

Local oDlg							// Obejto da montagem da tela de selecao
Local oQual							// Objeto da linha selecionada

If (ReadVar() $ "M->TRB_NUMLOT/M->TRB_LOTECT" .AND. Rastro(TRB->TRB_CODPRO)) .OR. ;
		"M->TRB_QUANT" $ ReadVar()

	cPict:=PesqPictQt("B8_SALDO",14)
	If Rastro( TRB->TRB_CODPRO )
		cAlias:=Alias()
		DbSelectArea("SB8")
		DbSetOrder(1)
		DbSeek(xFilial()+cProduto)

		While !EOF() .AND. xFilial( "SB8" ) + cProduto == SB8->B8_FILIAL + SB8->B8_PRODUTO
			If Rastro( cProduto )
				If B8_SALDO > 0
					AADD(aArrayF4, {	SB8->B8_LOTECTL, 		SB8->B8_NUMLOTE,	SB8->B8_PRODUTO,	Dtoc(SB8->B8_DATA),; 
										Dtoc(SB8->B8_DTVALID), Transform(SB8->B8_SALDO, cPict)})
					nSaldoLt += SB8->B8_SALDO
				EndIf	
			EndIf 
			DbSkip()				
		End

		If Len(aArrayF4) > 0
			nOpcA := 0
			DEFINE MSDIALOG oDlg TITLE "Saldos por " + "Lote" From 09,0 To 20,50 OF oMainWnd		//"Saldos por " + "Lote"
			@ 0.5,	0.0		TO	6, 20.0 OF oDlg
			@ 1.0,	0.7		Say "Saldo Dispon�vel  "		//"Saldo Dispon�vel  "
			@ 2.0,	3.7		Say Transform( nSaldoLt, cPict )
   			@ 2.4,	0.7		LISTBOX oQual VAR cVar Fields HEADER "Lote" , "Sub-Lote" , "Produto",;	// "Lote" # "Sub-Lote" # "Produto"
															"Data do" + "Lote" , "Validade do Lote" , "Saldo";	// "Data do" + "Lote" # "Validade do Lote" # "Saldo"
															SIZE 150,42 ON DBLCLICK (nList:= oQual:nAt, nOpca := 1,oDlg:End())	
			oQual:SetArray( aArrayF4 )
			oQual:bLine := { ||{aArrayF4[oQual:nAT,1],	aArrayF4[oQual:nAT,2],	aArrayF4[oQual:nAT,3],;
								aArrayF4[oQual:nAT,4],	aArrayF4[oQual:nAT,5],	aArrayF4[oQual:nAT,6]}}

			DEFINE SBUTTON FROM 10  ,166  TYPE 1 ACTION (nList:= oQual:nAt, nOpca := 1,oDlg:End()) ENABLE OF oDlg
			DEFINE SBUTTON FROM 22.5,166  TYPE 2 ACTION (nList:= oQual:nAt, oDlg:End()) ENABLE OF oDlg
			ACTIVATE MSDIALOG oDlg  
			
			If nOpca == 1

				cLote		:= aArrayF4[nList][1]		// Lote
				cProdutoLt	:= aArrayF4[nList][3]		// Produto
				cLoteCt 	:= aArrayF4[nList][2]		// Sub-lote
				cDtValid	:= aArrayF4[nList][5]		// Validade do lote

				If Rastro( cProdutoLt, "S" )
					If "M->TRB_LOTECT" $ ReadVar()
					    RecLock("TRB",.F.)
						REPLACE TRB_LOTECT WITH cLote
						REPLACE TRB_NUMLOT WITH cLoteCt 
						REPLACE TRB_DTVALI WITH CToD( cDtValid )  
						MsUnlock()
					EndIf      
				ElseIf Rastro( cProdutoLt, "L" )
					If "M->TRB_LOTECT" $ ReadVar()
					    RecLock("TRB",.F.)
						REPLACE TRB_LOTECT WITH cLote     
						REPLACE TRB_DTVALI WITH CToD( cDtValid )  
						MsUnlock()
					EndIf 		
				EndIf                  

				//�����������������������Ŀ
				//�Restaura area anterior.�
				//�������������������������
				DbSelectArea( cAlias )
			EndIf
		Else
			Help(" ",1,"A440NAOLOTE")
		Endif    
	Else
		Help(" ",1,"A440NAOLOTE")
	Endif
	//��������������������������������������������������������������Ŀ
	//� Devolve areas , indices e posicoes anteriores                �
	//����������������������������������������������������������������
	DbSelectArea(cAlias)
	DbSetOrder(nOrd)
EndIf
oGetdTRC:oBrowse:Refresh()
oGetdTRC:ForceRefresh()
Return( .T. ) 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Lj720ValCli�Autor  �Vendas Clientes     � Data � 31/10/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida o cliente informado pelo usuario                     ���
�������������������������������������������������������������������������͹��
���Uso       �Loja720                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Lj720ValCli(cCliente,cLoja)
Local aArea		:= GetArea()						// Salva posicionamento atual
Local aAreaSA1	:= SA1->(GetArea())				// Salva posicionamento do SA1
Local lRet		:= .T.								// Retorno da funcao
Local cCliPad	:= SuperGetMV("MV_CLIPAD")			// Cliente padrao
Local cLojaPad	:= SuperGetMV("MV_LOJAPAD")			// Loja do cliente padrao

DbSelectArea("SA1")
DbSetOrder(1)

//������������������������������������������������Ŀ
//�Valida se o codigo informado pelo usuario existe�
//��������������������������������������������������
lRet := DbSeek(xFilial("SA1")+cCliente+cLoja)

If !lRet         
	MsgStop("O cliente selecionado n�o est� cadastrado!","Aten��o")//"O cliente selecionado n�o est� cadastrado!"
EndIf

//���������������������������������������������������������������Ŀ
//�Valida se o cliente a receber o credito eh diferente do cliente�
//�padrao                                                         �
//�����������������������������������������������������������������
If lRet .AND. !Empty(cLoja)
	lRet := (AllTrim(cCliente) <> AllTrim(cCliPad)) .OR. (AllTrim(cLoja) <> AllTrim(cLojaPad))
	If !lRet
		MsgStop("N�o � permitida a troca/devolu��o de mercadorias para o cliente padr�o" ,"Aten��o")//"N�o � permitida a troca/devolu��o de mercadorias para o cliente padr�o" ### "Atencao"
	EndIf
EndIf

RestArea(aAreaSA1)
RestArea(aArea)

Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Lj720ValDia�Autor  �Vendas Clientes     � Data � 19/06/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida o diario contabil - Portugal                         ���
�������������������������������������������������������������������������͹��
���Uso       �Loja720                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Lj720ValDia( cCodDia, lAliasCVL )
Local aArea		:= GetArea()						// Salva posicionamento atual
Local lRet		:= .F.								// Retorno da funcao

If cPaisLoc == "PTG" .AND. lAliasCVL
	DbSelectArea( "CVL" )
	DbSetOrder( 1 )
	If !DbSeek( xFilial( "CVL" ) + cCodDia )
		MsgStop(  "O diario informado nao esta cadastrado", "Aten��o" )               // "O diario informado nao esta cadastrado"
	Else
	   lRet := .T.
	EndIf
Else
	lRet := .T.
EndIf

RestArea(aArea)

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Lj720Resid�Autor  �Vendas CRM          � Data �  10/11/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Elimina possiveis residuos referentes a pagamentos efetuados���
���          �utilizando adm. financeira com taxa de cobranca.            ���
�������������������������������������������������������������������������͹��
���Parametros�ExpA1 - Lista com codigo e quantidade dos produtos da venda ���
���          �ExpC2 - Numero do titulo original                           ���
���          �ExpC3 - Serie do titulo original                            ���
���          �ExpN4 - Moeda corrente                                      ���
���          �ExpN5 - Valor total da venda a ser devolvida                ���
���          �ExpC6 - Codigo do cliente                                   ���
���          �ExpC7 - Loja do cliente           						  ���
�������������������������������������������������������������������������͹��
���Uso       �LOJA720                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Lj720Resid(	aSldItens	, cNumTit	, cPrefixo	, cPrefixoSaida	,;
							nMoedaCorT	, nVlrTotal	, cCliente	, cLoja		   	,;
							cCodFil )

Local aArea	   			:= GetArea()				// Armazena o posicionamento atual
Local aAreaTRB 			:= TRB->(GetArea())		// Armazena o posicionamento atual da tabela TRB
Local aAreaSE1 			:= SE1->(GetArea())		// Armazena o posicionamento atual da tabela SE1
Local aAreaSL1 			:= SL1->(GetArea())		// Armazena o posicionamento atual da tabela SE1
Local aAreaSAE			:= SAE->(GetArea())		// Armazena o posicionamento atual da tabela SAE
Local lDevTotal			:= .F.						// Indica se a devolucao foi total ou a ultima parcela de uma devolucao parcial
Local nPos				:= 0				   		// Indice do produto no array aSldItens
Local nSldProd			:= 0						// Saldo de produtos a serem devolvidos apos o processo
Local nSaldoTit			:= 0				   		// Saldo dos titulos gerados para a venda
Local cFilSE1			:= xFilial("SE1")	   		// Filial da tabela SE1
Local cFilSE1Ori		:= FWxFilial("SE1",cCodFil)	// Filial da tabela SE1 de origem da venda (onde foi realizada a venda)
Local nResiduo			:= 0						// Valor residual a ser abatido
Local cParcela			:= ""						// Parcela do titulo gerado
Local nTamE1_PARCELA	:= TamSX3("E1_PARCELA")[1]	// Tamanho do campo E1_PARCELA
Local cPrefTit			:= ""						// Prefixo a ser gravado no titulo
Local cNatureza			:= ""						// Natureza a ser gravada no titulo
Local aVetMsExAut		:= {}						// Campos do titulo a ser gerado pela MsExecAuto
Local cPortador			:= ""						// Portador do titulo
Local lTemResid			:= .F.						// Indica de tem residuo ( CR )

Private lMsErroAuto		:= .F.						// Controle para execucao da execauto

//������������������������������Ŀ
//�Subtrai os produtos devolvidos�
//��������������������������������
DbSelectArea("TRB")
DbGoTop()

While !TRB->(Eof())
	If (nPos := aScan( aSldItens, {|x| x[1] == TRB->TRB_CODPRO })) > 0
		aSldItens[nPos][2] -= TRB->TRB_QUANT
	Else
		AAdd(aSldItens,{ TRB->TRB_CODPRO, TRB->TRB_QUANT })
	EndIf
	TRB->(DbSkip())
End

aEval(aSldItens,{|x| nSldProd += x[2]})

//������������������������������������������������������Ŀ
//�Se a devolucao nao for total, nao ira remover residuos�
//��������������������������������������������������������
If nSldProd <> 0
	RestArea(aAreaTRB)
	RestArea(aAreaSE1)
	RestArea(aArea)
	Return Nil
EndIf

//�������������������������������Ŀ
//�Soma o total das parcelas pagas�
//���������������������������������
DbSelectArea("SAE")
DbSetOrder(1) //AE_FILIAL+AE_COD

DbSelectArea("SE1")
DbSetOrder(1) //E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
DbSeek( cFilSE1Ori + cPrefixoSaida + cNumTit )

While !SE1->(Eof()) 					.AND.;
	SE1->E1_FILIAL	== cFilSE1Ori		.AND.;
	SE1->E1_PREFIXO	== cPrefixoSaida	.AND.;
	SE1->E1_NUM		== cNumTit
	
	If SE1->E1_VlrReal > 0
		If SE1->E1_VLRREAL > 	SE1->E1_VALOR
			lTemResid	:= .T.
		EndIf
		nSaldotit	+=	 SE1->E1_VALOR
	Else
		nSaldotit	+=	 SE1->E1_VALOR 
	EndIf
		
	SE1->(DbSkip())

		
End	

//�����������������������������Ŀ
//�Calcula o valor a ser abatido�
//�������������������������������
nResiduo := nVlrTotal - nSaldoTit

If (nResiduo > 0) .AND. lTemResid  
   	DbSelectArea( "SL1" )
   	DbSetOrder( 2 ) //L1_FILIAL + L1_SERIE + L1_DOC
	DbSeek( FWxFilial("SL1",cCodFil) + cPrefixo + cNumTit)

	cParcela := PadR(SuperGetMV("MV_1DUP"), nTamE1_PARCELA) // Ajusta de acordo com o tamanho do E1_PARCELA
	cPrefTit := &(SuperGetMV("MV_LJPREF")) 

	SX5->(DbSeek(xFilial("SX5")+"24"+PADR("CR",6)))
	cNatureza := If(Empty(SX5->X5_DESCRI),"CREDITO",SX5->X5_DESCRI)

	DbSelectArea("SE1")
	DbSetOrder(1) //E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO	

	While SE1->(DbSeek(cFilSE1 + cPrefTit + SL1->L1_DOC + cParcela + 'CR '))
		cParcela := CHR(ASC(cParcela)+1)
	End
	
	cPortador	:= xNumCaixa()

	// Monta o array com as informacoes para a gravacao do titulo
	aVetMsExAut  := {	{"E1_PREFIXO"	,cPrefTit					,Nil},;
						{"E1_NUM"	  	,SL1->L1_DOC				,Nil},;
						{"E1_PARCELA" 	,cParcela					,Nil},;
						{"E1_TIPO"	 	,'CR '						,Nil},;
						{"E1_NATUREZ" 	,cNatureza					,Nil},;
						{"E1_PORTADO" 	,cPortador					,Nil},;
			          	{"E1_CLIENTE" 	,cCliente					,Nil},;
		             	{"E1_LOJA"	  	,cLoja						,Nil},;
			          	{"E1_EMISSAO" 	,dDataBase 					,Nil},;
				       	{"E1_VENCTO"  	,dDataBase 					,Nil},;
				       	{"E1_VENCREA" 	,DataValida(dDataBase)		,Nil},;
				       	{"E1_MOEDA" 	,nMoedaCorT					,Nil},;
						{"E1_ORIGEM"	,"LOJA701"					,Nil},;
						{"E1_FLUXO"		,"S"						,Nil},;
					   	{"E1_VALOR"	  	,nResiduo					,Nil }}
	
	// Se a moeda for diferente de um adiciona o valor em moeda 1 para ter a taxa da inclusao do titulo
	If nMoedaCorT <> 1
		aAdd(aVetor,{"E1_VLCRUZ",Round(xMoeda(nResiduo, nMoedaCorT, 1, dDataBase),MsDecimais(1)) ,Nil })
	EndIf          	

	MSExecAuto({|x,y| Fina040(x,y)},aVetMsExAut, 3) //Inclusao
	
	If lMsErroAuto
		DisarmTransaction()
		MostraErro()
	EndIf

EndIf

RestArea(aAreaTRB)
RestArea(aAreaSE1)
RestArea(aAreaSL1)
RestArea(aAreaSAE)
RestArea(aArea)

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Lj720VldMo�Autor  �Microsiga           � Data �  02/08/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao Utilizada para Retornar a Descricao do Motivo       ���
���          � Caastrada na Tabela SX5                                    ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Lj720VldMot(cMotivo, cDescMot)

Local lRet	:= .T.         

If Empty(cMotivo)
	cDescMot	:= Space(40)
Else
	DbSelectArea("SX5")
	DbSeek(xFilial("SX5")+"O1"+cMotivo)
	If Eof()
		HELP(" ",1,"ERROMOTIVO")
		cDescMot	:= Space(40)
		lRet := .F.
	Else                                                         
		cDescMot	:= Alltrim( X5Descri() )
	Endif
Endif
			
Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Lj7AtuInte�Autor  �Vendas Clientes     � Data �  02/04/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Leva os dados da devolucao para integracao                 ���
���          � (Processo OffLine)  F1,D1, e E1							  ���
�������������������������������������������������������������������������͹��
���Uso       � Venda Assistida                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Lj720AtInt()
	
	Local oProcessOff 	:= Nil							//Objeto do tipo LJCProcessoOffLine
	Local cChave 		:= ""							//Chave da tabela
	Local aAreaAtual	:= ""   						//Array que ira guardar os dados do alias atual
	Local aArea         := ""							//Array que ira guardar os dados do alias utilizado
	Local cAuxChave		:= ""							//Guarda a chave do SB2
		
	//Guarda a posicao do arquivo atual
	aAreaAtual := GetArea()
	
	//Estancia o objeto LJCProcessoOffLine
	oProcessOff := LJCProcessoOffLine():New("008")
	
	//Insere os dados do processo (registro da tabela) SF1---------------------------------------------
	DbSelectArea("SF1")

	cChave := xFilial("SF1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_TIPO
	
	oProcessOff:Inserir("SF1", cChave, 1, "INSERT")
	//-------------------------------------------------------------------------------------------------

	//Insere os dados do processo (registro da tabela) SD1 e SB2---------------------------------------	
	aArea := SD1->(GetArea())

	DbSelectArea("SD1")
	
	DbSetOrder(1)
	
	If (SD1->(DbSeek(xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA)))

		While !SD1->(EOF()) .AND. SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA == xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA

			cChave := SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA + SD1->D1_COD + SD1->D1_ITEM
			oProcessOff:Inserir("SD1", cChave, 1, "INSERT")	

			If cAuxChave != SD1->D1_FILIAL + SD1->D1_COD + SD1->D1_LOCAL 
				cAuxChave := SD1->D1_FILIAL + SD1->D1_COD + SD1->D1_LOCAL 
				oProcessOff:Inserir("SB2", cAuxChave, 1, "UPDATE")						
			EndIf
			
			SD1->(DbSkip())
		End	

	EndIf
	
	RestArea(aArea)	
	//-------------------------------------------------------------------------------------------------
	
	//Insere os dados do processo (registro da tabela) SE1---------------------------------------------	
	aArea := SE1->(GetArea())
	
	DbSelectArea("SE1")
	
	DbSetOrder(1)
	
	If DbSeek(xFilial("SE1") + SF1->F1_PREFIXO + SF1->F1_DOC)  
	
		While !SE1->(EOF()) .AND. SE1->E1_FILIAL + SE1->E1_PREFIXO + SE1->E1_NUM  == xFilial("SE1") + SF1->F1_PREFIXO + SF1->F1_DOC

			If SE1->E1_TIPO == "NCC"
				cChave := xFilial("SE1") + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + SE1->E1_TIPO
	         	oProcessOff:Inserir("SE1", cChave, 1, "INSERT")
				
				cChave := xFilial("SE5") + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA
				oProcessOff:Inserir("SE5", cChave, 7, "INSERT")
			EndIf
				
			SE1->(DbSkip())

		End

	EndIf
	
	RestArea(aArea)
	//-------------------------------------------------------------------------------------------------------
	
	//Insere os dados do processo (registro da tabela) SE5---------------------------------------------------	
	aArea := SE5->(GetArea())
	
	DbSelectArea("SE5")
	
	DbSetOrder(7)
	
	If DbSeek(xFilial("SE5") + SF1->F1_PREFIXO + SF1->F1_DOC)  
	
		While !SE5->(EOF()) .AND. SE5->E5_FILIAL + SE5->E5_PREFIXO + SE5->E5_NUMERO  == xFilial("SE5") + SF1->F1_PREFIXO + SF1->F1_DOC

			If SE5->E5_RECPAG == "P"
				cChave := xFilial("SE5") + SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA
				oProcessOff:Inserir("SE5", cChave, 7, "INSERT")
			EndIf
				
			SE5->(DbSkip())

		End

	EndIf
	
	RestArea(aArea)
	//-------------------------------------------------------------------------------------------------------
			
	//Processa os dados 
	oProcessOff:Processar()
	
	//Restaura a area atual
	RestArea(aAreaAtual)
	
Return Nil

/*
�����������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������Ŀ��
���Funcao    �CriaTit    � Autor � Vendas Cliente       � Data � 03/01/11 			  ���
�������������������������������������������������������������������������������������Ĵ��
���Descricao � Gera Titulo de contas a receber para seguradoras Garantia estendida	  ���
�������������������������������������������������������������������������������������Ĵ��
���Sintaxe   � ExpL1:= CriaTit()                                                      ���
�������������������������������������������������������������������������������������Ĵ��
���Parametros�ExpC1 - Documento														  ���
���          �ExpC2 - Serie do documento											  ���
���          �ExpC3 - Operador														  ���
���          �ExpD4 - Data															  ���
���          �ExpN5 - Valor do Titulo      											  ���
���		     �ExpC6 - Cliente Administradora										  ���
���          �ExpC7 - Loja	 														  ���
���          �ExpC8 - Prefixo 														  ���
���          �ExpD9 - Data de emiss�o		           								  ���
���          �ExpD10 - Produto				           								  ���
�������������������������������������������������������������������������������������Ĵ��
���Retorno	 � ExpL1 =.T.            									              ���
�������������������������������������������������������������������������������������Ĵ��
���Uso		 � LOJA720													              ���
��������������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������
*/     

Static Function CriaTit(nValorTit,cCliente,cLoja,cMotivo,cNrChamado,cObs,cTPTit)
                                                          
Local aVetor        := {}                   				// Array com dados para gerar.
Local lRet 			:= .T.                  				// Retorno
Local cPrefixo		:= "MAN"
Local cNumTit     	:= GetSxeNum("SE1","E1_NUM")
Local cTipo			:= If(cTPTit=="NCC","NCC","NDC")
Local cNatNCC	 	:= SuperGetMV("MV_NATNCC")
Local cNatNDC		:= SuperGetMV("MV_NATNDC")
Local lContinua 	:= .T.
Local cParcela 		:= SuperGetMV("MV_1DUP")				// Parcela a gerar 
Local lConf			:= .T.

Private lMsErroAuto := .F.
Private lMsHelpAuto := .T.

DbSelectArea("SE1")
DbSetOrder(1)
While SE1->(DbSeek(xFilial("SE1") + cPrefixo + cNumTit + cParcela + cTipo))
	cParcela := CHR(ASC(cParcela)+1)
End

aAdd(aVetor,{"E1_PREFIXO"	,cPrefixo											,Nil})
aAdd(aVetor,{"E1_NUM"	  	,cNumTit 											,Nil})
aAdd(aVetor,{"E1_PARCELA" 	,cParcela											,Nil})
aAdd(aVetor,{"E1_NATUREZ" 	,If(cTPTit=="NCC",cNatNCC,cNatNDC)                 ,Nil})
aAdd(aVetor,{"E1_TIPO" 		,cTipo												,Nil})
aAdd(aVetor,{"E1_EMISSAO"	,dDatabase											,Nil})
aAdd(aVetor,{"E1_VALOR"		,nValorTit											,Nil})
aAdd(aVetor,{"E1_VENCTO"	,dDatabase											,Nil})
aAdd(aVetor,{"E1_VENCREA"	,dDatabase					   						,Nil})
aAdd(aVetor,{"E1_VENCORI"	,dDatabase											,Nil})
aAdd(aVetor,{"E1_SALDO"		,nValorTit											,Nil})
aAdd(aVetor,{"E1_VLCRUZ"	,xMoeda(nValorTit,1,1,nValorTit)	            	,Nil})
aAdd(aVetor,{"E1_CLIENTE"	,Alltrim(cCliente)									,Nil})
aAdd(aVetor,{"E1_LOJA"		,Alltrim(cLoja)										,Nil})
aAdd(aVetor,{"E1_MOEDA"		,1													,Nil})
aAdd(aVetor,{"E1_STATUS"	,"A"												,Nil})
aAdd(aVetor,{"E1_SITUACA"	,"0"												,Nil})
aAdd(aVetor,{"E1_ORIGEM"	,"SYTM004"											,Nil})
aAdd(aVetor,{"E1_MULTNAT"	,"2"												,Nil})
aAdd(aVetor,{"E1_FLUXO"		,"N"												,Nil})
aAdd(aVetor,{"E1_BASCOM1"	,xMoeda(nValorTit,1,1,nValorTit)					,Nil})
aAdd(aVetor,{"E1_HIST"		,cObs												,Nil})
aAdd(aVetor,{"E1_01SAC"		,cNrChamado											,Nil})
aAdd(aVetor,{"E1_01MOTIV"	,cMotivo											,Nil})
AAdd(aVetor,{"E1_USRNAME"	,UsrRetName(__cUserID)								,Nil})

//Solicita��o realizada para que a NCC seja criada bloqueada. A mesma ser� liberada pelo SAC. - Chamado - 8762
If lConf .And. cTPTit=="NCC"
	aAdd(aVetor,{"E1_XCONFSC"	,"N"												,Nil})    
Endif                      

//����������������������������Ŀ
//�Inclui via rotina automatica�
//������������������������������
MSExecAuto({|x,y| Fina040(x,y)},aVetor,3)       

/*
�����������������������������������������������������������������������Ŀ
�Apresenta mensagem de erro caso a rotina automatica nao seja executada.�
�Desfaz a transacao                                                     �
�������������������������������������������������������������������������
*/                     
If  lMsErroAuto
	MostraErro()
	DisarmTransaction()
	lRet 	   := .F.
	aLogRotAut := GetAutoGrLog()
Else
	ConfirmSX8()
EndIf

Return(lRet)

/*
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Funcao    �LJ720aNCC  � Autor � Vendas Cliente       � Data � 24/07/2012 	���
�������������������������������������������������������������������������������Ĵ��
���Descricao � Carrega um array com as NCCs que foram geradas para a devolucao	���
�������������������������������������������������������������������������������Ĵ��
���Sintaxe   � ExpL1:= LjLoadNCC()                                              ���
�������������������������������������������������������������������������������Ĵ��
���Parametros�ExpC1 - Cliente													���
���          �ExpC2 - Loja														���
���          �ExpC3 - Prefixo da Nota de Entrada								���
���          �ExpC4 - Numero do Documento										���
�������������������������������������������������������������������������������Ĵ��
���Retorno	 �ExpA1 = {}            									        ���
�������������������������������������������������������������������������������Ĵ��
���Uso		 � Lj720Concluir											        ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
*/
Static Function LJ720aNCC(cCliente, cLoja, cPrefixoEnt, cTitEnt)

Local aRet 		:= {}				// array com os R_E_C_N_O_ das NCCs geradas na devolucao
Local cLstDesc	:= FN022LSTCB(2)	//Lista das situacoes de cobranca (Descontada)

DbSelectArea("SE1")
SE1->( DbSetOrder(2) )	//E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO
                                     
If SE1->( DbSeek(xFilial("SE1") + cCliente + cLoja + cPrefixoEnt + cTitEnt) )

	While SE1->( !Eof() ) .AND. xFilial("SE1")		== SE1->E1_FILIAL 	.AND. ;
								SE1->E1_CLIENTE		== cCliente 		.AND. ;
								SE1->E1_LOJA		== cLoja 			.AND. ;
								SE1->E1_PREFIXO		== cPrefixoEnt 		.AND. ;
								SE1->E1_NUM			== cTitEnt
									
	   	If !( SE1->E1_SITUACA $ cLstDesc .OR. SE1->E1_SALDO == 0 )             
		
     		If ( SE1->E1_TIPO $ MV_CRNEG )
     			Aadd( aRet, SE1->(Recno()) )    
     		Endif	

		Endif
	    
		SE1->( DbSkip() )
	End

EndIf

Return aRet

/*
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Funcao    EstOPOtc 	 � Autor � Totvs F�brica        � Data � 15/01/2013 	���
�������������������������������������������������������������������������������Ĵ��
���Descricao � Realiza a Inclus�o/Exxclus�o de OPs e empenhos para o template 	���
���Otica                                                                      	���
�������������������������������������������������������������������������������Ĵ��
���Sintaxe   � ExpL1:= EstOPOtc()                                               ���
�������������������������������������������������������������������������������Ĵ��
���Parametros�ExpC1 - Produto													���
���          �ExpC2 - Documento													���
���          �ExpC3 - Serie                     								���
���          �ExpC4 - Item na tabela SL2 										���
���          �ExpC5 - C�digo do Cliente  										���
���          �ExpC6 - C�digo da Loja       										���
���          �ExpN7 - Op��o de opera��o, sendo :								���
���												3 - Incluir						���
���												5 - Excluir						���
���												6 - Valida Exclus�o				���																				
�������������������������������������������������������������������������������Ĵ��
���Retorno	 �ExpA1 = Nil           									        ���
�������������������������������������������������������������������������������Ĵ��
���Uso		 � Lj720Concluir,Lj720DevSD2,LjLogDevol						        ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
*/

Static Function EstOPOtc(cProd,cDoc,cSerie,cItemL2,cCliente,cLoja,nOpc,cCodFil) 
Local cQuery
Local aRetDados	:= {}
Local cOP
Local cFilSL2 	:= ""
Local cFilSD4 	:= ""

Default cCodFil := cFilAnt

cFilSL2 := FWxFilial("SL2",cCodFil)
cFilSD4 := FWxFilial("SD4",cCodFil)

If nOpc == 5 .Or. nOpc == 6
	cQuery := " Select L2_PRODUTO,L2_LOCAL,D4_OP,L2_QUANT,L2_LOTECTL,L2_DTVALID,L2_LOCALIZ,D4_TRT From "+RetSqlName("SL2")+" SL2 "
	cQuery += " Inner Join "+RetSqlName("SL1")+" SL1 ON SL1.L1_NUM = SL2.L2_NUM "
	If Upper(TcGetDb()) $ "MSSQL / SYBASE" //Validacao caso utilize banco de dados DB2 
		cQuery += " Inner Join "+RetSqlName("SC2")+" SC2 ON SubString(SC2.C2_OSLOJA,1,6) = SubString(SL1.L1_NROPCLI,1,6) "
	Else
		cQuery += " Inner Join "+RetSqlName("SC2")+" SC2 ON SubStr(SC2.C2_OSLOJA,1,6) = SubStr(SL1.L1_NROPCLI,1,6) "	
	Endif
	If Upper(TcGetDb()) $ "MSSQL / SYBASE" //Validacao caso utilize banco de dados DB2 
		cQuery += " Inner Join "+RetSqlName("SD4")+" SD4 ON SD4.D4_OP = SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN AND SD4.D4_COD = SL2.L2_PRODUTO "
	Else
		cQuery += " Inner Join SD4T10 SD4 ON SD4.D4_OP = SC2.C2_NUM || SC2.C2_ITEM || SC2.C2_SEQUEN AND SD4.D4_COD = SL2.L2_PRODUTO "
	Endif
	cQuery += " where  "
	cQuery += " L2_FILIAL ='"+cFilSL2+"'  "
	cQuery += " AND L2_DOC ='"+cDoc+"'  "
	cQuery += " AND L2_SERIE = '"+cSerie+"'  "
	cQuery += " AND SL2.D_E_L_E_T_ =''  "
	cQuery += " AND SD4.D_E_L_E_T_ =''  "
	cQuery += " AND L2_PRODUTO ='"+cProd+"'  "
	cQuery += " AND L2_ITEM ='"+cItemL2+"' "
	cQuery += " AND L2_ORCRES ='' "
	cQuery += " AND SC2.C2_OSLOJA <>'' "
	If Upper(TcGetDb()) $ "MSSQL / SYBASE" //Validacao caso utilize banco de dados DB2 
 		cQuery += " AND L2_CONJUNT = Cast(SUBSTRING(SC2.C2_OSLOJA,7,2)as INT) "
	Else
		cQuery += " AND L2_CONJUNT = Cast(SUBSTR(SC2.C2_OSLOJA,7,2)as INT) "
	EndIf 
	cQuery += " And L1_CLIENTE ='"+cCliente+"' "
	cQuery += " AND L1_LOJA ='"+cLoja+"' "
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"EstSD4",.T.,.T.)
	
	cOP	:= EstSD4->D4_OP
Else
	cQuery := " Select L2_PRODUTO,L2_LOCAL,C2_NUM,C2_ITEM,C2_SEQUEN,L2_QUANT,L2_LOTECTL,L2_DTVALID,L2_LOCALIZ From "+RetSqlName("SL2")+" SL2 "
	cQuery += " Inner Join "+RetSqlName("SL1")+" SL1 ON SL1.L1_NUM = SL2.L2_NUM "
	If Upper(TcGetDb()) $ "MSSQL / SYBASE" //Validacao caso utilize banco de dados DB2 
		cQuery += " Inner Join "+RetSqlName("SC2")+" SC2 ON SubString(SC2.C2_OSLOJA,1,6) = SubString(SL1.L1_NROPCLI,1,6) "
	Else
		cQuery += " Inner Join "+RetSqlName("SC2")+" SC2 ON SubStr(SC2.C2_OSLOJA,1,6) = SubStr(SL1.L1_NROPCLI,1,6) "	
	Endif
	cQuery += " where  "
	cQuery += " L2_FILIAL ='"+xFilial("SL2")+"'  "
	cQuery += " AND L2_DOC ='"+cDoc+"'  "
	cQuery += " AND L2_SERIE = '"+cSerie+"'  "
	cQuery += " AND SL2.D_E_L_E_T_ =''  "
	cQuery += " AND L2_PRODUTO ='"+cProd+"'  "
	cQuery += " AND L2_ITEM ='"+cItemL2+"' "
	cQuery += " AND L2_ORCRES <>'' "
	If Upper(TcGetDb()) $ "MSSQL / SYBASE" //Validacao caso utilize banco de dados DB2 
 		cQuery += " AND L2_CONJUNT = Cast(SUBSTRING(SC2.C2_OSLOJA,7,2)as INT) "
	Else
		cQuery += " AND L2_CONJUNT = Cast(SUBSTR(SC2.C2_OSLOJA,7,2)as INT) "
	EndIf 
	cQuery += " And L1_CLIENTE ='"+cCliente+"' "
	cQuery += " AND L1_LOJA ='"+cLoja+"' "
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"EstSC2",.T.,.T.)
	cOP	:= EstSC2->C2_NUM+EstSC2->C2_ITEM+EstSC2->C2_SEQUEN
Endif
If nOpc == 6
	If SD3->(DbSeek(xFilial("SD3")+EstSD4->D4_OP))
		Aadd(aRetDados,{.T.,EstSD4->D4_OP})	
		EstSD4 -> (DbCloseArea())
		Return aRetDados
	Else
		Aadd(aRetDados,{.F.,EstSD4->D4_OP})
		EstSD4 -> (DbCloseArea())
		Return	aRetDados
	Endif	
ElseIf nOpc == 5
	SD4->(DbSetOrder(1))
	If EstSD4->(!EOF()) .And. SD4->(DbSeek(cFilSD4+EstSD4->L2_PRODUTO+EstSD4->D4_OP+EstSD4->D4_TRT+EstSD4->L2_LOTECTL))
		While EstSD4->(!EOF())
			EmpOtc(EstSD4->L2_PRODUTO,EstSD4->L2_LOCAL,EstSD4->D4_OP,EstSD4->L2_QUANT,EstSD4->L2_LOTECTL,EstSD4->L2_DTVALID,EstSD4->L2_LOCALIZ,nOpc) 
			EstSD4->(DbSkip())
		Enddo
		SD4->(DbSetOrder(2))
        If !SD4->(DbSeek(cFilSD4+cOP))
			GerOPOtc(,,,5)
		Endif
		EstSD4 -> (DbCloseArea())
	Else
		EstSD4 -> (DbCloseArea())
	Endif
Elseif nOpc == 3
	If EstSC2->(!EOF())
		While EstSC2->(!EOF())
			EmpOtc(EstSC2->L2_PRODUTO,EstSC2->L2_LOCAL,cOP,EstSC2->L2_QUANT,EstSC2->L2_LOTECTL,EstSC2->L2_DTVALID,EstSC2->L2_LOCALIZ,nOpc) 
			EstSC2->(DbSkip())
		Enddo
		EstSC2 -> (DbCloseArea())
	Else
		EstSC2 -> (DbCloseArea())
	Endif
Endif

Return

/*
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Funcao    EmpOtc 	 � Autor � Totvs F�brica        � Data � 15/01/2013 	���
�������������������������������������������������������������������������������Ĵ��
���Descricao � Controla o empenho dos materiais Quando utilizado o template   	���
���Otica                                                                      	���
�������������������������������������������������������������������������������Ĵ��
���Sintaxe   � ExpL1:= EmpOtc() 	                                            ���
�������������������������������������������������������������������������������Ĵ��
���Parametros�ExpC1 - Produto													���
���          �ExpC2 - Local     												���
���          �ExpC3 - Ordem de Produ��o         								���
���          �ExpN4 - Quantidade         										���
���          �ExpC5 - Lote               										���
���          �ExpC6 - Data de Validade											���
���          �ExpC7 - Endere�o             										���
���          �ExpN8 - Op��o de opera��o, sendo :								���
���												3 - Incluir						���
���												5 - Excluir						���
�������������������������������������������������������������������������������Ĵ��
���Retorno	 �ExpA1 = Nil           									        ���
�������������������������������������������������������������������������������Ĵ��
���Uso		 � EstOPOtc															���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
*/

Static Function EmpOtc(cProduto,cLocal,cOP,nQtde,cLote,dValid,cLocaliz,nOpc) 
Local aMata380 := {}
Local aEmp380  := {}
Local nModuloOld
Local nQtdAnt
Private lMSErroAuto := .f.  

aadd(aMata380,{"D4_COD"    ,PADR(cProduto,tamsX3("B1_COD")[1])     			,NIL})
aadd(aMata380,{"D4_LOCAL"  ,cLocal       			,NIL})
aadd(aMata380,{"D4_OP"     ,cOP         			,NIL})
aadd(aMata380,{"D4_DATA"   ,dDataBase 				,NIL})
aadd(aMata380,{"D4_QTDEORI",nQtde					,NIL}) 
aadd(aMata380,{"D4_QUANT"  ,nQtde	 				,NIL}) 
aadd(aMata380,{"D4_LOTECTL",If(!Empty(cLote),cLote,CriaVar("D4_LOTECTL"))		,NIL})
aadd(aMata380,{"D4_NUMLOTE",CriaVar("D4_NUMLOTE")	,NIL})                       
aadd(aMata380,{"D4_DTVALID",If(!Empty(dValid),dValid,CTOD("//"))				,NIL})
aadd(aMata380,{"D4_QTSEGUM",0						,NIL})
aadd(aMata380,{"D4_POTENCI",CriaVar("D4_POTENCI")	,NIL})

If !Empty(cLocaliz)
	aadd(aEmp380,{nQtde,cLocaliz,CriaVar("DC_NUMSERI"),0,.F.})
Endif

If nOpc <> 4
	nModuloOld  := nModulo
	nModulo     := 4
	lMSErroAuto := .F.
	lMSHelpAuto := .F.
	msExecAuto({|x,y,z|MATA380(x,y,z)},aMata380,nOpc,aEmp380)
	nModulo     := nModuloOld
	lMsHelpAuto:=.F.
	If lMSErroAuto
		Conout("Ocorreu algum erro no Processo.") //"Ocorreu algum erro no Processo."
		MostraErro()
		lErroReq := .t.
		DisarmTransaction()
		Break
	Else
		Conout("Processo realizado com Sucesso.")//Processo realizado com Sucesso.
	EndIf
Endif

Return 

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Funcao    | LJESPECOK � Autor � Vendas/CRM	        � Data � 18/04/2013  ���
����������������������������������������������������������������������������Ĵ��
���Descricao � Verifica se a especie eh valida								 ���
����������������������������������������������������������������������������Ĵ��
���Sintaxe   � LjEspecOk(cTpEspecie)										 ���
����������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 - especie a ser validada								 ���
����������������������������������������������������������������������������Ĵ��
���Retorno	 � ExpL1 = valida se a especie eh validada						 ���
����������������������������������������������������������������������������Ĵ��
���Uso		 � LOJA720														 ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Static Function LjEspecOk(cTpEspecie)

Local aArea := GetArea()		//armazena a area
Local lRet	:= .T.				//valida se a especie eh valida

Default cTpEspecie	:= ""

If !Empty(cTpEspecie)
	DbSelectArea("SX5")
	If !SX5->( DbSeek(xFilial("SX5") + "42" + cTpEspecie) )
		lRet := .F.
	EndIf
EndIf

RestArea(aArea)

Return lRet


/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Funcao    | LJESPECIE � Autor � Vendas/CRM	        � Data � 18/04/2013  ���
����������������������������������������������������������������������������Ĵ��
���Descricao � Retorna a especie cadastrada para a serie, baseada no 		 ���
���			 | parametro MV_ESPECIE.										 ���
����������������������������������������������������������������������������Ĵ��
���Sintaxe   � LjEspecie(cSerieDoc)											 ���
����������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 - serie utilizada na devolucao							 ���
����������������������������������������������������������������������������Ĵ��
���Retorno	 � ExpC1 = especie cadastrada para a serie. Se a especie nao	 ���
���			 | existir, retornamos 'NF'					     				 ���
����������������������������������������������������������������������������Ĵ��
���Uso		 � Lj720DevSD2 / Lj720DevTRB / LjSerieEOK						 ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Static Function LjEspecie(cSerieDoc)

Local cMvEspecie	:= SuperGetMV("MV_ESPECIE",,"")		//pares de SERIE=ESPECIE
LOcal cSerieEspe	:= "" 								//par de SERIE=ESPECIE 
Local cSerie		:= ""								//serie do par
Local cEspecie		:= ""								//retorno do funcao - especie cadastrada para a serie
Local nI			:= 0								//contador
Local nPosSign		:= 0								//posicao do sinal '='

Default cSerieDoc	:= ""

cSerieDoc := AllTrim(cSerieDoc)

If Empty(cMvEspecie) .OR. cPaisLoc <> "BRA"
	//inializa F1_ESPECIE com o conteudo do inicializador padrao
	cEspecie  := CriaVar("F1_ESPECIE",.T.)
Else
	//substituimos ';' por quebra de linha
	cMvEspecie := StrTran( cMvEspecie, ";", Chr(13) + Chr(10) )

	//verificamos cada par 'serie = especie'
	For nI := 1 TO MLCount( cMvEspecie )

		//retorna o conteudo de cada linha		
		cSerieEspe := AllTrim( StrTran(MemoLine(cMvEspecie,, nI), CHR(13), CHR(10)) )

		//retorna a posicao do '='
		nPosSign := At( "=", cSerieEspe )

		If nPosSign > 0
			//retorna a serie do parametro (antes '=')
			cSerie := SubStr( cSerieEspe, 1, (nPosSign-1) )

			//se a serie do documento for igual a serie do parametro
			If cSerieDoc  == cSerie
				//retorna a especie (apos '=')
				cEspecie := SubStr( cSerieEspe, (nPosSign+1) )
				cEspecie := PadR( cEspecie, TamSX3("X5_CHAVE")[1] )
				
				//verifica se a especie eh valida
				If LjEspecOk(cEspecie)
					Exit
				Else
					cEspecie := ""
				EndIf
			EndIf
		EndIf
	Next
EndIf

If Empty(cEspecie)
   cEspecie := PadR( "NF", TamSX3("F1_ESPECIE")[1] )
EndIf

Return cEspecie


/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Funcao    |LJSERIEOK	 � Autor � Vendas/CRM	        � Data � 18/04/2013  ���
����������������������������������������������������������������������������Ĵ��
���Descricao � Verifica se o campo Serie esta preenchido. Tambem retorna a	 ���
���			 |especie cadastrada para a serie (MV_ESPECIE).					 ���
����������������������������������������������������������������������������Ĵ��
���Sintaxe   � LjSerieoK(cSerieDoc, @cTpEspecie)							 ���
����������������������������������������������������������������������������Ĵ��
���Parametros�ExpC1 - serie utilizada na devolucao							 ���
���          �ExpC2 - especie cadastrada para a serie (MV_ESPECIE)			 ���
����������������������������������������������������������������������������Ĵ��
���Retorno	 �ExpL1 = indica se a serie eh valida						     ���
����������������������������������������������������������������������������Ĵ��
���Uso		 � LOJA720														 ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Static Function LjSerieOk(cSerieDoc, cTpEspecie)

Local lRet			:= .T.	//valida se a serie eh valida

Default cSerieDoc	:= ""
Default cTpEspecie	:= ""

If !Empty(cSerieDoc)
	//retorna a especie cadastrada para a serie
	cTpEspecie := LjEspecie(cSerieDoc)
Else
	lRet := .F.
EndIf

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Lj720SeekCl �Autor  � Vendas Cliente     � Data �14/05/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica se o cliente existe.                              ���
�������������������������������������������������������������������������͹��
���Parametros�ExpC1 - Codigo da Filial                                    ���
���          �ExpC2 - Codigo do Cliente                                   ���
���          �ExpC3 - Loja do Cliente                                     ���
�������������������������������������������������������������������������͹��
���Uso       � SIGALOJA                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Lj720SeekCl(cFilCli, cCodCli, cCodLoja)
Local lRet := .F.

cFilCli := FWxFilial("SA1",cFilCli)

DbSelectArea("SA1")
If MsSeek(cFilCli+cCodCli+cCodLoja)
	lRet := .T.
Else
	HELP(" ",1,"REGNOIS")
Endif

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � Lj720NomFi �Autor  � Vendas Cliente     � Data �14/05/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna o nome da filial.                                  ���
�������������������������������������������������������������������������͹��
���Parametros�ExpC1 - Codigo da Filial                                    ���
���          �ExpC2 - Variavel passada por referencia para atualizar a    ���
���          � 		  descricao da filial.                                ���
���          �ExpL3 - Indica se deve validar o codigo da Filial informada.���
�������������������������������������������������������������������������͹��
���Uso       � SIGALOJA                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Lj720NomFi( cCodFil, cDescrFil, lVldCodFil )
Local lRet 		:= .T.
Local cRetNomFil:= ""
Local aArea 	:= GetArea()
Local aAreaSM0 	:= SM0->(GetArea())

cRetNomFil := Posicione("SM0",1,cEmpAnt+cCodFil,"M0_FILIAL")

If lVldCodFil
	If Empty(cRetNomFil) .And. SM0->(EOF())
		MsgAlert("O c�digo da filial informada n�o � v�lido.","Atne��o")
		lRet := .F.
	EndIf
EndIf

If lRet
	cDescrFil := cRetNomFil
EndIf

RestArea(aAreaSM0)
RestArea(aArea)

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � L720ChgPrc �Autor  � Vendas Cliente     � Data �12/Jun/2013���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao executada na mudanca do Radio Button de Processo.   ���
�������������������������������������������������������������������������͹��
���Uso       � SIGALOJA                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function L720ChgPrc( cAliasTRB  	, aRecSD2  		, oGetdTRC  	, lFormul 	,;
							lCompCR   	, nRecnoTRB		, nTpProc		, nNfOrig 	,;
							nPanel		, oBotaoPesq 	, oFiltroPor 	, nFiltroPor)

Lj720AltProc( cAliasTRB, @aRecSD2 ,oGetdTRC, @lFormul, @lCompCR, @nRecnoTRB, nTpProc )

Lj720CfgDb( nNfOrig, oGetdTRC, nPanel, aRecSd2 , nTpProc )

If (nTpProc == 3 .Or. nTpProc == 4)
	//oBotaoPesq:Disable()
Endif

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � L720ChgOri �Autor  � Vendas Cliente     � Data �12/Jun/2013���
�������������������������������������������������������������������������͹��
���Desc.     � Habilita / Desabilita a edicao de campos e objetos quando  ���
���          � alterado o Radio Button "Origem".                          ���
�������������������������������������������������������������������������͹��
���Uso       � SIGALOJA                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function L720ChgOri( nNfOrig		, oDataIni	, oDataFim	, dDataIni	,;
							dDataFim	, oCodFil	, cCodFil	, oDescrFil	,;
							cDescrFil 	, oFiltroPor, oBotaoPesq, cAliasTRB ,;
							aRecSD2  	, oGetdTRC  , lFormul	, lCompCR   ,;
							nRecnoTRB	, nTpProc	, nPanel	, nFiltroPor,;
							oSayClient	, oCodCli	, oLojaCli	, oNomeCli	,;
							oSayDtIni 	, oSayDtFim	, oSayNumNF	, oCodNumNF	,;
							oSaySerie	, oSerieNF, oLblPedido  ,oPedido)


If nNfOrig==2
	nFiltroPor:=1 //1=Filtro por Cliente e Data
	If ValType(oFiltroPor) <> "N"
		oFiltroPor:Refresh()
	Endif
	
	L720ChgFil(	nFiltroPor	, @oSayClient	, @oCodCli		, @oLojaCli		,;
				@oNomeCli	, @oSayDtIni	, @oDataIni		, @oSayDtFim	,;
    			@oDataFim	, @oSayNumNF	, @oCodNumNF	, @oSaySerie	,;
        		@oSerieNF 	, cAliasTRB		, @aRecSD2		, oGetdTRC		,;
        		@lFormul	, @lCompCR		, @nRecnoTRB	, nTpProc 		,;
        		nNfOrig		, nPanel, oLblPedido  ,oPedido )
EndIf

If nNfOrig == 2 //Sem NF de entrada
	If ValType(oFiltroPor) <> "N"
		oFiltroPor:Disable()
		oFiltroPor:Refresh()
	Endif
	dDataIni:= Ctod("  /  /  ")  
	dDataFim:= Ctod("  /  /  ")
	oDataIni:Refresh()
	oDataFim:Refresh()
	oDataIni:Disable()
	oDataFim:Disable()
	cCodFil   := cFilAnt //Seta a filial corrente
	Lj720NomFi( cCodFil, @cDescrFil, .F. ) //Atualiza a descricao da filial
	oCodFil:Disable()
	oBotaoPesq:Disable()
Else  //Com NF de entrada
	If ValType(oFiltroPor) <> "N"
		oFiltroPor:Enable()
	Endif
	oDataIni:Enable()
	oDataFim:Enable()
	oCodFil:Enable()
	oBotaoPesq:Enable()
Endif

oDataIni:Refresh()
oDataFim:Refresh()
oCodFil:Refresh()
oDescrFil:Refresh()

Lj720AltProc( cAliasTRB, @aRecSD2, oGetdTRC, @lFormul, @lCompCR, @nRecnoTRB, nTpProc )

Lj720CfgDb( nNfOrig, oGetdTRC, nPanel, aRecSd2 , nTpProc ) 

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � L720ChgFil �Autor  � Vendas Cliente     � Data �12/Jun/2013���
�������������������������������������������������������������������������͹��
���Desc.     �Habilita / Desabilita os campos de filtro de dados da venda.���
�������������������������������������������������������������������������͹��
���Uso       � SIGALOJA                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function L720ChgFil( nFiltroPor	, oSayClient, oCodCli	, oLojaCli	,;
							oNomeCli	, oSayDtIni	, oDataIni	, oSayDtFim	,;
							oDataFim	, oSayNumNF	, oCodNumNF	, oSaySerie	,;
							oSerieNF	, cAliasTRB	, aRecSD2	, oGetdTRC	,;
							lFormul		, lCompCR	, nRecnoTRB	, nTpProc 	,;
							nNfOrig 	, nPanel    , oLblPedido ,oPedido)

DEFAULT oLblPedido := Nil 
DEFAULT oPedido    := nIL

If nFiltroPor == 1 //Filtro por "Cliente e Data"
	oSayClient:Show()
	oCodCli:Show()
	oLojaCli:Show()
	oNomeCli:Show()
	oSayClient:Enable()
	oCodCli:Enable()
	oLojaCli:Enable()
	oNomeCli:Enable()
	oSayDtIni:Show()
	oDataIni:Show()
	oSayDtFim:Show()
	oDataFim:Show()
	oSayNumNF:Hide()
	oCodNumNF:Hide()
	oSaySerie:Hide()
	oSerieNF:Hide()
	oLblPedido:Hide()
	oPedido:Hide()
ElseIf nFiltroPor == 2  //Filtro por "No. Cupom / Nota"
	oSayClient:Show()
	oCodCli:Show()
	oLojaCli:Show()
	oNomeCli:Show()
	oSayClient:Disable()
	oCodCli:Disable()
	oLojaCli:Disable()
	oNomeCli:Disable()
	oSayDtIni:Hide()
	oDataIni:Hide()
	oSayDtFim:Hide()
	oDataFim:Hide()
	oSayNumNF:Show()
	oCodNumNF:Show()
	oSaySerie:Show()
	oSerieNF:Show()
	oLblPedido:Hide()
	oPedido:Hide()
ElseIf nFiltroPor == 3
	oSayClient:Hide()
	oCodCli:Hide()
	oLojaCli:Hide()
	oNomeCli:Hide()
	oSayDtIni:Hide()
	oDataIni:Hide()
	oSayDtFim:Hide()
	oDataFim:Hide()
	oSayNumNF:Hide()
	oCodNumNF:Hide()
	oSaySerie:Hide()
	oSerieNF:Hide()
	oLblPedido:Show()
	oPedido:Show()
EndIf

Lj720AltProc( cAliasTRB, @aRecSD2, oGetdTRC, @lFormul, @lCompCR, @nRecnoTRB, nTpProc )

Lj720CfgDb( nNfOrig, oGetdTRC, nPanel, aRecSd2 , nTpProc ) 

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � L720ChgCli �Autor  � Vendas Cliente     � Data �12/Jun/2013���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao executada na mudanca do Cliente / Loja.             ���
�������������������������������������������������������������������������͹��
���Uso       � SIGALOJA                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function L720ChgCli( cField		, cAliasTRB , aRecSD2  	, oGetdTRC  , ;
							lFormul  	, lCompCR   , nRecnoTRB	, nTpProc	, ;
							nNfOrig 	, nPanel	, cCodCli 	, cLojaCli	, ;
							cCodFil		, oLojaCli	, oNomeCli 	, cNomeCli)

Local lRet := .T.

If cField == "CODCLI" //Chamada atraves do valid do campo Codigo do Cliente

	If !EMPTY(cCodCli) .AND. EMPTY(cLojaCli)
		cLojaCli := Posicione("SA1",1,FWxFilial("SA1",cCodFil)+cCodCli,"A1_LOJA")
		lRet := Lj720SeekCl(cCodFil, cCodCli, cLojaCli)
	else
		lRet := .T.
	EndIf
	
	cNomeCli := Lj720VldCli(cCodCli,cLojaCli,cCodFil)
	oLojaCli:Refresh()
	oNomeCli:Refresh()

ElseIf cField == "CODLOJA" //Chamada atraves do valid do campo Loja do Cliente

	If !EMPTY(cLojaCli)
		lRet := Lj720SeekCl(cCodFil, cCodCli, cLojaCli)
	else
		lRet := .T.
	EndIf
	
	cNomeCli := Lj720VldCli(cCodCli,cLojaCli,cCodFil)
	oNomeCli:Refresh()
	
EndIf

Lj720AltProc( cAliasTRB, @aRecSD2 ,oGetdTRC, @lFormul, @lCompCR, @nRecnoTRB, nTpProc )

Lj720CfgDb( nNfOrig, oGetdTRC, nPanel, aRecSd2 , nTpProc )

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � L720SelIte �Autor  � Vendas Cliente     � Data �16/Jun/2013���
�������������������������������������������������������������������������͹��
���Desc.     � Monta tela para selecao dos itens da venda a serem         ���
���          � trocados / devolvidos.                                     ���
�������������������������������������������������������������������������͹��
���Uso       � SIGALOJA                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function L720SelIte( cCodFil		, aRecSd2	, nNfOrig	, nFiltroPor, ;
							cCodCli		, cLojaCli	, cNomeCli	, oNomeCli	, ;
							dDataIni  	, dDataFim	, aNomeTMP 	, cAliasTRB , ;
							nRecnoTRB 	, cNumNF 	, cSerieNF 	, nVlrTotal , ;
							cPedido		)
Local oDlgSelIte
Local aCpoBrw 		:= {}       											// Campos da tabela SD2 que serao exibidos na MsSelect
Local lMv_Rastro	:= (SuperGetMv( "MV_RASTRO", Nil, "N" ) == "S")			// Flag de verificacao do rastro
Local oMark
Local cMarca  		:= GetMark()	                                         	// Marca da MsSelect
Local nX			:= 0
Local nCount        := 0                                                // Contador
Local lConsPadr     := .F.                                              // Verifica se possui consulta padrao
Local lContinua		:= .T.
Local cCodFilCli 	:= FWxFilial("SA1",cCodFil)
Local lAchouSD2		:= .F.
Local lConfirma 	:= .F.

//---------------------------------------------------
// Valida se os campos obrigatorios foram informados
//---------------------------------------------------
If nFiltroPor == 1 //Filtro por Cliente e data
	If Empty(cCodCli)
		Alert("O c�digo do cliente deve ser informado.") //"O c�digo do cliente deve ser informado."
		lContinua:= .F.
	ElseIf Empty(cLojaCli)
		Alert("O c�digo da loja deve ser informado.") //"O c�digo da loja deve ser informado."
		lContinua:= .F.
	EndIf
	If lContinua
	   DbSelectArea("SA1")
	   DbSetOrder(1)
	   If !DbSeek(cCodFilCli+cCodCli+cLojaCli)
	      //"O cliente selecionado n�o est� cadastrado!"
	      Alert("O cliente selecionado n�o est� cadastrado!")
	      lContinua  := .F.
	   Endif
	Endif
ElseIf nFiltroPor == 2  //Filtro por No. Nota e serie
	If Empty(cNumNF)
		Alert("O n�mero da nota deve ser informado") //"O n�mero do cupom ou nota deve ser informado"
		lContinua:= .F.
	ElseIf Empty(cSerieNF)
		Alert("A s�rie deve ser informada") //"A s�rie deve ser informada"
		lContinua:= .F.
	EndIf
ElseIf nFiltroPor == 3  //Filtro por Pedido
	If Empty(cPedido)
		Alert("O n�mero do pedido deve ser informado")
		lContinua:= .F.
    Endif	
EndIf

If lContinua
	//Definicao dos campos
	aAdd(aCpoBrw,{"D2_OK"		,," "	 				," "})
	aAdd(aCpoBrw,{"D2_DOC" 		,,"Documento de Saida"	," "})  								//"Documento de Saida"
	aAdd(aCpoBrw,{"D2_SERIE"	,,"S�rie"				," "})									//"S�rie"
	aAdd(aCpoBrw,{"D2_ITEM	"	,,"Item"				," "})									//"Item"		
	aAdd(aCpoBrw,{"D2_EMISSAO"	,,"Emiss�o"				," "})									//"Emiss�o"
	aAdd(aCpoBrw,{"D2_COD"      ,,"Produto"				," "})									//"Produto"  
	aAdd(aCpoBrw,{"D2_QUANT"	,,"Qtde. Vendida" 		,PesqPict("SD2","D2_QUANT")})			//"Qtde. Vendida" 
	aAdd(aCpoBrw,{"D2_QTDEDEV"	,,"Qtde. Devolvida" 	,PesqPict("SD2","D2_QTDEDEV")})			//"Qtde. Devolvida" 
	aAdd(aCpoBrw,{"D2_PRCVEN"	,,"Preco Unit�rio"		,PesqPict("SD2","D2_PRCVEN")})			//"Preco Unit�rio"
	aAdd(aCpoBrw,{"D2_TOTAL"	,,"Valor do Item"		,PesqPict("SD2","D2_TOTAL")})			//"Valor do Item"
	aAdd(aCpoBrw,{"D2_UM"		,,"Unidade"				," "})									//"Unidade"
	aAdd(aCpoBrw,{"D2_TES"		,,"TES"					," "})									//"TES"		
	
	If lMv_Rastro
		Aadd(aCpoBrw,{"D2_LOTECTL"	,, "Lote",PesqPict("SD2","D2_LOTECTL")}	)	// Lote
		Aadd(aCpoBrw,{"D2_NUMLOTE"	,, "Sub Lote",PesqPict("SD2","D2_NUMLOTE")}	)	// Sub Lote
		Aadd(aCpoBrw,{"D2_DTVALID"	,, "Validade do Lote",PesqPict("SD2","D2_DTVALID")}	)	// Validade do Lote
	EndIf
	
	Do Case
	
		Case nNfOrig == 1    //Com NF de Origem
			oGetdTRC:lNewLine 		:= .F.
			oGetdTRC:lDeleta  		:= .F.
			oGetdTRC:nMax     		:= 999
			oGetdTRC:aAlter			:= {"TRB_QUANT","TRB_TES"}   //Campos que podem ser alterados
			oGetdTRC:oBrowse:aAlter	:= {"TRB_QUANT","TRB_TES"}  
		Case nNfOrig == 2  	  // Sem NF de Origem		
			oGetdTRC:lNewLine 		:= .F.
			oGetdTRC:lDeleta  		:= .T.
			oGetdTRC:nMax     		:= 999
			oGetdTRC:aAlter			:= {"TRB_CODPRO","TRB_QUANT","TRB_PRCVEN","TRB_TES"} //Campos que podem ser alterados
			oGetdTRC:oBrowse:aAlter	:= {"TRB_CODPRO","TRB_QUANT","TRB_PRCVEN","TRB_TES"} //Campos que podem ser alterados
		   
			If lMv_Rastro 
				aAdd( oGetdTRC:aAlter, "TRB_LOTECT")
				aAdd( oGetdTRC:oBrowse:aAlter, "TRB_LOTECT") 
			Endif			
	Endcase
		
	oGetdTRC:oBrowse:Refresh()
	oGetdTRC:ForceRefresh()
	
	//�����������������������������������������������������������������������������Ŀ
	//�Desmarca todos os produtos que foram marcados no panel de selecao de produtos�
	//�������������������������������������������������������������������������������
	If Len(aRecSD2) > 0
		For nX:= 1 to Len(aRecSD2)
			DbSelectArea("SD2")
			DbGoTo(aRecSD2[nX][2])
			RecLock("SD2",.F.)
			REPLACE	SD2->D2_OK WITH Space(Len(SD2->D2_OK))
			MsUnlock()                                                             
		Next nX
		aRecSD2:= {}
	Endif
	
	//--------------------------------
	// Filtra registros da tabela SD2
	//--------------------------------
	MsgRun("Aguarde...",,{ || Lj720FilSD2( 	@cCodCli 	, @cLojaCli , dDataIni  , dDataFim 	,;
											Nil     	, @aNomeTMP , cAliasTRB , @cNomeCli ,;
											oNomeCli  	, cCodFil 	, nFiltroPor, cNumNF 	,;
											cSerieNF	, cPedido ) })  //"Aguarde..."
	
	lAchouSD2 := SD2->( !EOF() ) //Verifica se foi encontrado registro na SD2
	
	If lAchouSD2
		DEFINE MSDIALOG oDlgSelIte TITLE "Itens para troca ou devolu��o" From 0,0 To 300,600 PIXEL //"Itens para troca ou devolu��o"
		
		@ 010,010 SAY "Selecione os produtos que ser�o trocados ou devolvidos" OF oDlgSelIte COLOR CLR_HBLUE  PIXEL SIZE 250,9 //"Selecione os produtos que ser�o trocados ou devolvidos"
		@ 030,005 TO 130,295 LABEL "" OF oDlgSelIte PIXEL
		
		DbSelectArea("SD2")
		//oMark := MsSelect():New("SD2","D2_OK", ,aCpoBrw,.F.,@cMarca,{035,010,125,290},"SD2->(DbGotop())","SD2->(DbGoBottom())",oDlgSelIte)
		oMark := MsSelect():New("SD2","D2_OK", , ,.F.,@cMarca,{035,010,125,290},"SD2->(DbGotop())","SD2->(DbGoBottom())",oDlgSelIte)
		oMark:bAval := {||Lj720Mark(@cMarca,@aRecSD2,@oMark,cCodFil), }		//Funcao de execucao quando marca ou desmarca
		oMark:oBrowse:lhasMark    := .T.
		oMark:oBrowse:lCanAllmark := .F.						//Indica se pode marcar todos de uma vez 
		
		SD2->(DbGotop())
		
		@ 135,210 BUTTON "Ok" SIZE 040,11 OF oDlgSelIte PIXEL ACTION (If(Lj720MsSelOk(aRecSd2),(lConfirma:=.T.,oDlgSelIte:End()),Nil))  //"Ok"
		@ 135,255 BUTTON "Cancelar" SIZE 040,11 OF oDlgSelIte PIXEL ACTION (oDlgSelIte:End())  //"Cancelar"
		
		ACTIVATE MSDIALOG oDlgSelIte CENTER
		
	Else
		MsgAlert("Nenhuma venda foi encontrada. Verifique os dados informados.","Atne��o") //"Nenhuma venda foi encontrada. Verifique os dados informados."
	EndIf

EndIf

If lContinua
	If lConfirma .AND. lAchouSD2
	
		//Atualiza conteudo dos campos Codigo do Cliente, Loja, Nome do Cliente
		cCodCli 	:= SD2->D2_CLIENTE
		cLojaCli	:= SD2->D2_LOJA
		cNomeCli 	:= Posicione("SA1",1,cCodFilCli+cCodCli+cLojaCli,"A1_NOME") 
			
		//Atualiza GetDados com os itens selecionados
		Lj720GetDB(@aRecSd2, cAliasTRB, oGetdTRC, @nRecnoTRB, cCodFil, @nVlrTotal)
	Else
		nVlrTotal := 0
	
		//Limpa conteudo dos campos Codigo do Cliente, Loja, Nome do Cliente
		cCodCli 	:= Space(TamSX3("D2_CLIENTE")[1])
		cLojaCli	:= Space(TamSX3("D2_LOJA")[1])
		cNomeCli 	:= Space(TamSX3("A1_NOME")[1])
	EndIf
EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � L720NextPn  �Autor  � Vendas Cliente    � Data �16/Jun/2013���
�������������������������������������������������������������������������͹��
���Desc.     � Faz validacao na troca para o proximo painel do Wizard.    ���
�������������������������������������������������������������������������͹��
���Uso       � SIGALOJA                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function L720NextPn(	nPanel 		, nNfOrig 		, cCodCli	, cLojaCli	,;
							oWizard		, nTpProc 		, cCodDia	, lAliasCVL	,;
							cCodFilCli	, nFiltroPor  	, aRecSD2)

Local lRet          :=  .T.     	                  // Retorno da Funcao
Local cGrpUsFin		:= GetMv("SY_USRFIN",,"000002")

Default cCodDia     := ""
Default lAliasCVL   := .F.


cCodFilCli := FWxFilial("SA1",cCodFilCli)

lTroca  := nTpProc == 1

If nPanel == 1
	If nFiltroPor == 1
		If Empty(cCodCli)
			Alert("O c�digo do cliente deve ser informado.") //"O c�digo do cliente deve ser informado."
			lRet:= .F.
		ElseIf Empty(cLojaCli)
			Alert("O c�digo da loja deve ser informado.") //"O c�digo da loja deve ser informado."
			lRet:= .F.
		EndIf
		
		If lRet
		   DbSelectArea("SA1")
		   DbSetOrder(1)
		   If !DbSeek(cCodFilCli+cCodCli+cLojaCli)
		      //"O cliente selecionado n�o est� cadastrado!"
		      Alert("O cliente selecionado n�o est� cadastrado!")
		      lRet  := .F.
		   Endif
		Endif
	EndIf
	
	If lRet .And. nNfOrig == 1 .And. Len(aRecSd2) == 0 .And. (nTpProc == 1 .Or. nTpProc == 2)
		MsgAlert("N�o existem produtos para troca ou devolu��o.","Atne��o") //"N�o existem produtos para troca ou devolu��o."
		lRet:= .F.
	EndIf
	
	If lRet .And. nNfOrig == 2
		lRet := Lj720ValCli(cCodCli,cLojaCli)
	EndIf
	
	If lRet .And. !(__cUserId $ cGrpUsFin) .And. (nTpProc == 3 .Or. nTpProc == 4)
		MsgAlert("Voc� n�o tem permiss�o para utilizar esta op��o.","Atne��o")
		lRet:= .F.
	Endif
	
ElseIf nPanel == 2

	If Empty(cCodCli) 
		Alert("O c�digo do cliente deve ser informado.")//"O c�digo do cliente deve ser informado."
		lRet:= .F.
	EndIf

	lRet := lRet .And. Lj720ValCli(cCodCli,cLojaCli)
	lRet := lRet .And. Lj720ValDia( cCodDia, lAliasCVL )

Endif

Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � L720VldDel  �Autor  � Vendas Cliente    � Data �17/Jun/2013���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao de validacao no momento da delecao do item.         ���
�������������������������������������������������������������������������͹��
���Uso       � SIGALOJA                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
uSER Function L720VldDel()

If TRB->TRB_FLAG
	nVlrTotal += TRB->TRB_VLRTOT
Else
	nVlrTotal -= TRB->TRB_VLRTOT
EndIf
oVlrTotal:Refresh()

Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � Lj720NccIcmJr �Autor � Vendas Cliente   � Data �10/10/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao de atualiza��o de saldos para titulos/NCC com valor ���
���			 � de juros separados do valor total - MV_LJICMJR			  ���
�������������������������������������������������������������������������͹��
���Uso       � LOJA720.PRW (SIGALOJA)                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Lj720NccIcmJr(aNcc, cChaveSl1, nVlTotDev, lCompCR)
Local aOrd		:= GetArea()
Local nValAcres	:= 0
Local nI		:= 0

If Len(aNcc) > 0 .And. nVlTotDev > 0

	nValAcres := LJ720VlAcresc(cChaveSl1, nVlTotDev)
	If nValAcres > 0
		For nI := 1 To Len(aNcc)
			SE1->(DbGoTo(aNcc[nI]))
			If SE1->(RecLock("SE1", .F.))
				If lCompCR
					SE1->E1_ACRESC	:= nValAcres
					SE1->E1_SDACRES	:= nValAcres
				Else
					SE1->E1_VALOR += nValAcres
					SE1->E1_SALDO += nValAcres
				EndIf

				SE1->(MSunlock())
			EndIf
		Next 
	EndIf
EndIf
RestArea(aOrd)
Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � LJ720VlAcresc �Autor � Vendas Cliente   � Data �10/10/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao de calculo do valor de juros de um item de uma venda���
���			 � onde o juros esta separados do valor total - MV_LJICMJR	  ���
�������������������������������������������������������������������������͹��
���Uso       � LOJA720.PRW (SIGALOJA)                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function LJ720VlAcresc(cChaveSl1, nVlTotDev)
Local nItAcres	:= 0
Local nValAcres := 0
Local aOrd		:= GetArea()

Lj7Arred(1)
SL1->(DbSetOrder(2))
If SL1->(DbSeek(xFilial("SL1")+cChaveSl1))
	SL4->(DbSetOrder(1))
	If SL4->(DBSeek(xFilial("SL4")+SL1->L1_NUM))
		While SL4->(!EOF()) .And. SL4->(L4_FILIAL+L4_NUM) == SL1->(L1_FILIAL+L1_NUM)
			nValAcres += SL4->L4_ACRSFIN
			SL4->(DBSkip())
		EndDo
	EndIf
	nItAcres := (nVlTotDev/SL1->L1_VLRTOT)
	nItAcres := Lj7Arred(2,3,nItAcres*nValAcres)
EndIf
RestArea(aOrd)
Return nItAcres

//------------------------
/*/{Protheus.doc} LjNFeEntOk
Se a nota fiscal de entrada vai ser transmitida (formul�rio pr�prio e esp�cie SPED), 
validamos se ela possui uma nota fiscal de sa�da vinculada,
pois na NF-e v3.10, se a NF tem a finalidade de Devolu��o de Mercadoria, 
� obrigat�rio referenciar o documento de sa�da.

@param cSerie - s�rie da nota fiscal de entrada
@param lFormul - indica se � formul�rio pr�prio   
@param nNfOrig - indica a origem da nota de entrada (1-com documeto / 2-sem documento)
@author  Varejo
@version P11
@since   08/06/2015
@return  lRet - indica se a nota pode ser usada
/*/
//------------------------
Static Function LjNFeEntOk(cSerie, lFormul, nNfOrig)

Local cEspecie 	:= ""	//esp�cie da nota fiscal de entrada
Local lRet		:= .T.

Default cSerie  := ""	//s�rie do documento de entrada
Default lFormul	:= .T.	//indica uso de Formulario Proprio
Default nNfOrig	:= 1	//indica origem 1-com documento / 2-sem documento

If lFormul .AND. nNFOrig == 2
	
	cEspecie := AllTrim( LjEspecie(cSerie) )

	If cEspecie == 'SPED'
		lRet := .F.
		Help( ,, "LJ720NFEDV",, "Na NF-e v3.10, uma nota fiscal com finalidade de devolu��o, deve ser vinculada a um documento de sa�da."		, 1, 0 )	
		//"Na NF-e v3.10, uma nota fiscal com finalidade de devolu��o, deve ser vinculada a um documento de sa�da."		
	EndIf
	
EndIf

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Lj720Trigger�Autor  � Vendas Cliente     � Data �  08/24/05 ���
�������������������������������������������������������������������������͹��
���Desc.     �- Gatilha o campo descricao do produto, UM e TES.           ���
���          �- Executa o calculo do valor total do item baseado na       ���
���          � quantidade e no preco unitario digitado.                   ���
�������������������������������������������������������������������������͹��
���Parametros�ExpC1 - Campo a ser tratado                                 ���
���          �ExpC2 - Valor referente ao campo                            ���
���          �ExpN3 - Quantidade referente ao campo                       ���
�������������������������������������������������������������������������͹��
���Uso       � SIGALOJA - VENDA ASSISTIDA.                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Lj720Trigger( cCampo  ,cValor  ,nQuant )

Local lRet			:= 	.T.								// Retorno da funcao
Local cTesSai		:= SuperGetMV("MV_TESSAI")			// Pega do parametro o TES padrao para saida
Local cTesInt		:= ""								// Codigo do Tes de saida
Local cTabPrecos    := ""                               // Tabela de preco utilizada no caso de possuir cenario de venda
Local nPrcVenda     := ""                               // Preco de venda
Local cCliente      := ""                               // Cliente 
Local cLoja      	:= ""                               // Loja 
Local nMoeda        := 1                                // Moeda definada como 1 pois o cenario de venda somente existe para o Brasil

Default nQuant  		:= 1
     
If TRB->TRB_FLAG //Se tiver DELETADO nao permite alterar
	MsgStop("Item exclu�do n�o pode ser alterado.") //"Item exclu�do n�o pode ser alterado."
	lRet:= .F.
EndIf

If lRet
	
	Do Case
	
		Case cCampo $ "TRB_CODPRO"
	
			SB1->(DbSetOrder(1))
			SB1->(DbSeek(xFilial("SB1")+cValor))
			cCliente := SA1->A1_COD
			cLoja    := SA1->A1_LOJA
			//�������������������������������������������Ŀ
			//�Parametro da funcao MaTesInt               �
			//�ExpN1 = Documento de 1-Entrada / 2-Saida   �
			//�ExpC1 = Tipo de Operacao Tabela "DJ" do SX5�
			//�ExpC2 = Codigo do Cliente ou Fornecedor    �
			//�ExpC3 = Codigo do gracao E-Entrada         �
			//�ExpC4 = Tipo de Operacao E-Entrada         �
			//���������������������������������������������
			cTesInt := MaTesInt( 2	,Padr("6",2)	,cCliente	,cLoja	,;
							     "C",SB1->B1_COD	,NIL)
	
			If !Empty(cTesInt)
				cTesPad := cTesInt
			Else
				If Empty( SB1->B1_TS )
					cTesPad := cTesSai
				Else
					cTesPad := SB1->B1_TS
				EndIf
			Endif
			
			If lNovaLj720 .And. !Empty(TRB->TRB_CODPRO)
				nVlrTotal -= TRB->TRB_VLRTOT
			EndIf
			
			RecLock("TRB",.F.)
			REPLACE	TRB->TRB_CODPRO	WITH cValor
			REPLACE	TRB->TRB_DESPRO	WITH SB1->B1_DESC
			REPLACE	TRB->TRB_UM		WITH SB1->B1_UM
			REPLACE	TRB->TRB_TES	WITH cTesPad
			REPLACE	TRB->TRB_QUANT	WITH nQuant
		   	
		   	// No caso de utilizar o cenario de venda busca o preco da tabela de preco utilizada 
		   	If lCenVenda
				cTabPrecos := LjXETabPre(cCliente, cLoja) 
				//�����������������������������������������������������������������������Ŀ
				//�Retorna o valor da tabela de preco DA1 de acordo com a moeda utilizada.�
				//�caso nao encontre a tabela de preco retorna o valor do B0_PRV          �
	   			//�������������������������������������������������������������������������
		   		nPrcVenda := MaTabPrVen( cTabPrecos		,cValor		,nQuant			,cCliente	,; 
										cLoja			,nMoeda		, /*dDataVld*/	,/*nTipo*/	,;
										/*lExec*/	)
	   		Else                                                      
				nPrcVenda := Posicione("SB0",1,xFilial("SB0")+cValor,"B0_PRV1")
	   		EndIf 
	   		
			REPLACE	TRB->TRB_PRCVEN	WITH nPrcVenda
			REPLACE	TRB->TRB_VLRTOT	WITH A410Arred(TRB->TRB_QUANT * TRB->TRB_PRCVEN ,"D2_TOTAL")		
			MsUnlock()
			
			If lNovaLj720
				nVlrTotal += TRB->TRB_VLRTOT
			EndIf
	
		Case cCampo $ "TRB_QUANT"
	        
			//�����������������������������������������������������������������������������������������������������������������������Ŀ
			//�Nao permite que a quantidade seja alterada com um valor maior que o saldo a devolver existente na nota fiscal original.�
			//�������������������������������������������������������������������������������������������������������������������������
			If !Empty(TRB->TRB_RECNO) 
				DbSelectArea("SD2")
				DbGoTo(Val(TRB->TRB_RECNO))
				If cValor > ( SD2->D2_QUANT - SD2->D2_QTDEDEV )
					lRet:= .F.
					MsgStop("A quantidade digitada � insuficiente de acordo com o saldo disponivel para devolu��o","Aten��o")//"A quantidade digitada � insuficiente de acordo com o saldo disponivel para devolu��o"##"Aten��o"
				Else
					If lNovaLj720
						nVlrTotal -= TRB->TRB_VLRTOT
					EndIf
					RecLock("TRB",.F.)
					REPLACE TRB->TRB_VLRTOT	WITH A410Arred(cValor * TRB->TRB_PRCVEN ,"D2_TOTAL")
					MsUnlock()
					If lNovaLj720
						nVlrTotal += TRB->TRB_VLRTOT
					EndIf
				Endif
			Else 		
				If lNovaLj720
					nVlrTotal -= TRB->TRB_VLRTOT
				EndIf
				RecLock("TRB",.F.)
				REPLACE	TRB->TRB_VLRTOT	WITH A410Arred(cValor * TRB->TRB_PRCVEN ,"D2_TOTAL")
				MsUnlock()
				If lNovaLj720
					nVlrTotal += TRB->TRB_VLRTOT
				EndIf
		    Endif
	
		Case cCampo $ "TRB_PRCVEN"
			
			If lNovaLj720
				nVlrTotal -= TRB->TRB_VLRTOT
			EndIf
			
			RecLock("TRB",.F.)
			REPLACE	TRB->TRB_VLRTOT	WITH A410Arred(TRB->TRB_QUANT * cValor ,"D2_TOTAL")
			MsUnlock()
	
			If lNovaLj720
				nVlrTotal += TRB->TRB_VLRTOT
			EndIf
	EndCase
	
	If lNovaLj720
		oVlrTotal:Refresh()
	EndIf
	
EndIf

Return(lRet)

/*--------------------------------------------
@Autor: Eduardo Patriani
@Data: 06/06/2017
@Hora: 16:30:24
@Vers�o: 
@Descri��o: Fun��o para carregar o tipo de acao
cadastrado no chamado do SAC.
--------------------------------------------*/
Static Function LjVldAcao( cNrChamado,cTpAcao,nTpProc,cOcorr)

Local lRet 	:= .T.
Local cOper := ""

IF (nTpProc==1 .OR. nTpProc==2)
	cOper := "3"
ElseIF nTpProc==3
	cOper := "4"
ElseIF nTpProc==4
	cOper := "5"
EndIF

If Select("TRB1") > 0
	TRB1->(DbCloseArea())
EndIf

BeginSql Alias "TRB1"
	SELECT DISTINCT UD_01TIPO, UD_OCORREN
	FROM %Table:SUD% SUD
	INNER JOIN %Table:Z01% Z01 ON Z01_FILIAL = %xfilial:Z01% AND Z01_COD=UD_01TIPO AND Z01_TIPO = %Exp:cOper% AND Z01.D_E_L_E_T_ = ''
	WHERE
	UD_FILIAL	= %xfilial:SUD%
	AND UD_CODIGO 	= %Exp:cNrChamado%
	AND UD_STATUS = '1'
	AND SUD.%notDel%
EndSql

If TRB1->(!Eof())
	cTpAcao := TRB1->UD_01TIPO
	cOcorr  := TRB1->UD_OCORREN
Else
	cTpAcao := Space(06)
Endif

Return(lRet)

/*--------------------------------------------
@Autor: Eduardo Patriani
@Data: 06/06/2017
@Hora: 18:30:24
@Vers�o: 
@Descri��o: Fun��o para carregar os campos
do tipo de a��o selecionado;
--------------------------------------------*/                   
Static Function LjFilAcao(cTpAcao,cOcorr) //inclusao de ocorrencia para tratamento da pesquisa de devolu��o - Marcio Nunes 

	Local lRet := .T.

	If Select("TRB2") > 0
		TRB2->(DbCloseArea())
	EndIf

	BeginSql Alias "TRB2"	
		SELECT *
		FROM %Table:Z01% Z01
		WHERE 
		Z01_FILIAL 	= %xfilial:Z01%
		AND Z01_COD = %Exp:cTpAcao%
		AND Z01_OCORR = %Exp:cOcorr%
		AND Z01.%notDel%	
	EndSql

Return(lRet)

/*--------------------------------------------
@Autor: Eduardo Patriani
@Data: 07/06/2017
@Hora: 14:17:24
@Vers�o: 
@Descri��o: Fun��o para atualizar o item do 
chamado no SAC apos a geracao da NF
--------------------------------------------*/
Static Function LjAtuSUD(aRetSUD,nTpProc)

Local lRet := .T.
Local nX   := 0

For nX := 1 To Len(aRetSUD)
	
	If Select("TRB3") > 0
		TRB3->(DbCloseArea())
	EndIf
	
	IF nTpProc==1 .Or. nTpProc==2
		BeginSql Alias "TRB3"
			SELECT R_E_C_N_O_ AS RECSUD
			FROM %Table:SUD% SUD
			WHERE
			UD_FILIAL = %xfilial:SUD%
			AND UD_CODIGO 	= %Exp:aRetSUD[nX,01]%
			AND UD_PRODUTO 	= %Exp:aRetSUD[nX,02]%
			AND UD_STATUS 	= '1'
			AND SUD.%notDel%
		EndSql
	EndIF
	
	IF nTpProc==3 .Or. nTpProc==4
		BeginSql Alias "TRB3"
			SELECT R_E_C_N_O_ AS RECSUD
			FROM %Table:SUD% SUD
			WHERE
			UD_FILIAL = %xfilial:SUD%
			AND UD_CODIGO = %Exp:aRetSUD[nX,01]%
			AND UD_01TIPO = %Exp:aRetSUD[nX,02]%
			AND UD_STATUS = '1'
			AND SUD.%notDel%
		EndSql
	EndIF
		
	While TRB3->(!Eof())
		
		DbSelectArea("SUD")
		DbGoto(TRB3->RECSUD)
		RecLock("SUD",.F.)
		SUD->UD_STATUS := "2"
			if vldTpAcao(SUD->UD_01TIPO)	//#AFD20180619.N
		   		SUD->UD_XNUMTIT := _cTitulo //#AFD20180619.N
			endif							//#AFD20180619.N
		Msunlock()
		
		TRB3->(DbSkip())
	EndDo
	
Next

Return(lRet)


//----------------------------------------------------------|
//	Funtion - vldTpAcao() -> //Valida o tipo de a��o 	   	| 
//	Uso - Komfort House									   	|
//  By Alexis Duarte - 18/06/2018  							|
//----------------------------------------------------------|
Static Function vldTpAcao(cCodAcao)

	Local lRet := .F.
	Local aArea := getArea()
    
	dbSelectArea("Z01")
	Z01->(dbSetOrder(1))
	Z01->(dbgotop())
		   
	if dbSeek(xFilial("Z01")+cCodAcao)

		cGerDuplic := POSICIONE( "SF4", 1, xFilial("SF4")+Z01->Z01_TES, "F4_DUPLIC" )
		
		if cGerDuplic == "S"
			lRet := .T.
		endif

	endif
	
	restArea(aArea)
	
Return lRet


//--------------------------------------------------------------
/*/{Protheus.doc} LjAtuZK0
Description //Descri��o da Fun��o
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 04/06/2019 /*/
//--------------------------------------------------------------
Static Function LjAtuZk0(_Chamado,_Doc,_Serie)

	Local aArea := getArea()
	Local cQuery := ""
	Local cAlias := getNextAlias()
	
	cQuery := "SELECT R_E_C_N_O_ as RECNO FROM " + retSqlName("ZK0")
	cQuery += " WHERE ZK0_NUMSAC = '"+ _Chamado +"'"
	cQuery += " AND D_E_L_E_T_ = ''"

	PLSQuery(cQuery, cAlias)

	dbSelectArea("ZK0")

	While (cAlias)->(!eof())
		dbGoTo((cAlias)->RECNO)

		recLock("ZK0",.F.)
			ZK0->ZK0_NFDEV := _Doc
			ZK0->ZK0_SERDEV := _Serie
			ZK0->ZK0_STATUS := '3'
			ZK0->ZK0_DTRET := dDataBase
			ZK0->ZK0_USRRET := cUserName
		MsUnLock()

		(cAlias)->(DbSkip())
	End
	
	ZK0->(dbCloseArea())

	restArea(aArea)

Return