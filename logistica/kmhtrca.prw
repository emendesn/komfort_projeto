#IFDEF TOTVS
	#INCLUDE 'TOTVS.CH'
#ELSE
	#INCLUDE 'PROTHEUS.CH'
#ENDIF

#DEFINE pCRLF     CHR(13)+CHR(10)

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � KMHTRCA  � Autor � Edilson Nascimento   � Data � 05/02/20  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Rotina para apresentacao das informacoes relacionadas a    ���
���          � as NF de transferencia                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � KMHTRCA			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function KMHTRCA()

    Local aBotoes	    := {}         //Vari�vel onde ser� incluido o bot�o para a legenda

    Private oLista                    //Declarando o objeto do browser
    Private aCabecalho  := {}         //Variavel que montar� o aHeader do grid
    Private aColsEx 	:= {}         //Vari�vel que receber� os dados

    //Declarando os objetos de cores para usar na coluna de status do grid
    Private oVermelho	:= LoadBitmap( GetResources(), "BR_VERMELHO")
    Private oAmarelo	:= LoadBitmap( GetResources(), "BR_AMARELO")
    Private oVerde  	:= LoadBitmap( GetResources(), "BR_VERDE")


    DEFINE MSDIALOG oDlg              ;
           TITLE    "Transferencias"  ;
           FROM     000, 000          ;
           TO       300, 700          ;
           PIXEL

        //chamar a fun��o que cria a estrutura do aHeader
        CriaCabec()

        //Monta o browser com inclus�o, remo��o e atualiza��o
        oLista := MsNewGetDados():New(053, 078, 415, 775, GD_INSERT+GD_DELETE+GD_UPDATE, ;
                                      .T., Nil,/*8*/,/*9*/, Nil, 999, ;
                                      /*12*/, /*13*/, .T., oDlg, aCabecalho, aColsEx)

        //Carregar os itens que ir�o compor o conteudo do grid
        FwMsgRun( /*Nil*/, {|| Carregar() }, "Transferencias...", "Carrgando os registros...")

        //Alinho o grid para ocupar todo o meu formul�rio
        oLista:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

        //Ao abrir a janela o cursor est� posicionado no meu objeto
        oLista:oBrowse:SetFocus()

        //Crio o menu que ir� aparece no bot�o A��es relacionadas
        aadd(aBotoes,{"NG_ICO_LEGENDA", {||Legenda()},"Legenda","Legenda"})

        EnchoiceBar(oDlg, {|| oDlg:End() }, {|| oDlg:End() },,aBotoes)

    ACTIVATE MSDIALOG oDlg CENTERED
Return


/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � CriaCabec � Autor � Edilson Nascimento   � Data � 04/02/20 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Monta o cabecario para exibicao do ListBox                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Procedure CriaCabec()

    Aadd(aCabecalho, {;
                  "",;//X3Titulo()
                  "IMAGEM",;  //X3_CAMPO
                  "@BMP",;		//X3_PICTURE
                  3,;			//X3_TAMANHO
                  0,;			//X3_DECIMAL
                  ".F.",;			//X3_VALID
                  "",;			//X3_USADO
                  "C",;			//X3_TIPO
                  "",; 			//X3_F3
                  "V",;			//X3_CONTEXT
                  "",;			//X3_CBOX
                  "",;			//X3_RELACAO
                  "",;			//X3_WHEN
                  "V"})			//
    Aadd(aCabecalho, {;
                  "Minuta",;//X3Titulo()
                  "MINUTA",;  //X3_CAMPO
                  "@!",;		//X3_PICTURE
                  6,;			//X3_TAMANHO
                  0,;			//X3_DECIMAL
                  "",;			//X3_VALID
                  "",;			//X3_USADO
                  "C",;			//X3_TIPO
                  "",; 			//X3_F3
                  "R",;			//X3_CONTEXT
                  "",;			//X3_CBOX
                  "",;			//X3_RELACAO
                  ""})			//X3_WHEN
    Aadd(aCabecalho, {;
                  "Pedido",;//X3Titulo()
                  "PEDIDO",;  //X3_CAMPO
                  "@!",;		//X3_PICTURE
                  6,;			//X3_TAMANHO
                  0,;			//X3_DECIMAL
                  "",;			//X3_VALID
                  "",;			//X3_USADO
                  "C",;			//X3_TIPO
                  "",; 			//X3_F3
                  "R",;			//X3_CONTEXT
                  "",;			//X3_CBOX
                  "",;			//X3_RELACAO
                  ""})			//X3_WHEN
    Aadd(aCabecalho, {;
                  "Fiscal",;//X3Titulo()
                  "FISCAL",;  //X3_CAMPO
                  "@!",;		//X3_PICTURE
                  9,;			//X3_TAMANHO
                  0,;			//X3_DECIMAL
                  "",;			//X3_VALID
                  "",;			//X3_USADO
                  "C",;			//X3_TIPO
                  "",; 			//X3_F3
                  "R",;			//X3_CONTEXT
                  "",;			//X3_CBOX
                  "",;			//X3_RELACAO
                  ""})			//X3_WHEN
    Aadd(aCabecalho, {;
                  "Data",;//X3Titulo()
                  "Data",;  //X3_CAMPO
                  "@!",;		//X3_PICTURE
                  6,;			//X3_TAMANHO
                  0,;			//X3_DECIMAL
                  "",;			//X3_VALID
                  "",;			//X3_USADO
                  "C",;			//X3_TIPO
                  "",; 			//X3_F3
                  "R",;			//X3_CONTEXT
                  "",;			//X3_CBOX
                  "",;			//X3_RELACAO
                  ""})			//X3_WHEN

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � Carregar  � Autor � Edilson Nascimento   � Data � 04/02/20 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Carrega os dados para exibicao dentro do ListBox           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Procedure Carregar()

Local cQuery
Local cAlias     := getNextAlias()


	BEGIN SEQUENCE
	
		//Seleciona os registros de transferencia
		cQuery := "SELECT DAK.DAK_COD AS MINUTA,DAI.DAI_PEDIDO AS PEDIDO,DAI.DAI_NFISCA AS NFISCAL,DAK.DAK_DATA AS DATA" + pCRLF
		cQuery += "  FROM " + RetSqlName("DAK") + " (NOLOCK) DAK" + pCRLF
		cQuery += " INNER JOIN " + RetSqlName("DAI") + " (NOLOCK) DAI ON DAI.DAI_FILIAL = DAK.DAK_FILIAL AND DAI.DAI_COD = DAK.DAK_COD" + pCRLF
		cQuery += " WHERE DAK.D_E_L_E_T_ = ''" + pCRLF
		cQuery += "       AND DAI.D_E_L_E_T_ = ''" + pCRLF
		cQuery += "       AND DAI.DAI_CLIENT = '000001'" + pCRLF
		cQuery += "       AND DAK.DAK_FILIAL = '"+ xFilial("DAK") +"'" + pCRLF
		cQuery += "       AND NOT EXISTS(SELECT DAH.DAH_FILIAL,DAH.DAH_CODCAR" + pCRLF
		cQuery += "                        FROM " + RetSqlName("DAH") + " (NOLOCK) DAH" + pCRLF
		cQuery += "                       WHERE DAH.DAH_FILIAL = DAK.DAK_FILIAL" + pCRLF
		cQuery += "                             AND DAH.DAH_CODCAR = DAK.DAK_COD" + pCRLF
		cQuery += "                             AND DAH.D_E_L_E_T_ = '')" + pCRLF
		cQuery += " ORDER BY DAK.DAK_FILIAL,DAK.DAK_COD" + pCRLF
		
        dbUseArea(.T., "TOPCONN", TCGenQry(,, cQuery), cAlias, .F., .T.)
		
		while ! (cAlias)->( Eof() )

			aadd( aColsEx, { oVerde, ;
                             TRANSFORM( (cAlias)->MINUTA, PesqPict("DAK","DAK_COD") ),;
                             TRANSFORM( (cAlias)->PEDIDO, PesqPict("DAI","DAI_PEDIDO") ),;
                             TRANSFORM( (cAlias)->NFISCA, PesqPict("DAI","DAI_NFISCA") ),;
                             TRANSFORM( STOD((cAlias)->DATA), PesqPict("DAK","DAK_DATA") ) } )

			(cAlias)->(DbSkip())
			
		enddo
		
		(cAlias)->(DBCloseArea())
		
		//Setar array do aCols do Objeto.
		oLista:SetArray(aColsEx,.T.)
		
		//Atualizo as informa��es no grid
		oLista:Refresh()
	
	END SEQUENCE
	
Return


/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � Legenda   � Autor � Edilson Nascimento   � Data � 04/02/20 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Exibe a legenda com o status dos registros                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Procedure Legenda()

Local aLegenda := {}

//	AADD(aLegenda,{"BR_VERMELHO" 	,"   Faturado 1" })
//	AADD(aLegenda,{"BR_AMARELO"     ,"   Faturado 2" })
	AADD(aLegenda,{"BR_VERDE"    	,"   Minuta Emitida" })
	
	BrwLegenda("Legenda", "Legenda", aLegenda)

Return