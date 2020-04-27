#INCLUDE "TOTVS.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ SYVR109  ³ Autor ³ Marcio Nunes          ³ Data ³09/05/2019³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissão do Termo de Retirada de Mercadoria em loja para    ³±±
±±³prodotos Agragados.                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ SYVR109(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SYVR109()
Local   aArea     	:= getArea()
Local   cQuery		:= ""
Private cAlias    	:= GetNextAlias()                     
Private oPrinter
Private nLin      	:= 0
Private aPedidos  	:= {}
                                      
//Seleção dos produtos Agregados para impressão do termo de retirada na loja. 
cQuery := " SELECT	UA_NUM,UA_NUMSC5,UA_EMISSAO,UA_CODOBS, "
cQuery += " 		A1_COD,A1_LOJA,A1_NOME,A1_END,A1_BAIRRO,A1_CEP,A1_MUN,A1_EST,A1_DDD,A1_TEL, "
cQuery += " 		A3_COD,A3_NOME, "
cQuery += " 		UB_PRODUTO,B1_DESC,UB_UM,UB_QUANT,UB_VRUNIT,UB_VLRITEM,UB_MOSTRUA "
cQuery += " FROM "+RetSqlName("SUB")+" SUB "
cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON B1_FILIAL = '"+xFilial("SB1")+"' 	AND B1_COD=UB_PRODUTO AND SB1.B1_XACESSO='1' AND SB1.D_E_L_E_T_ = ' ' "//SOMENTE AGRAGADOS
cQuery += " INNER JOIN "+RetSqlName("SUA")+" SUA ON UA_FILIAL = '"+xFilial("SUA")+"'	AND UA_NUM=UB_NUM AND SUA.D_E_L_E_T_ = ' ' "
cQuery += " INNER JOIN "+RetSqlName("SA3")+" SA3 ON A3_FILIAL = '"+xFilial("SA3")+"' 	AND A3_COD=UA_VEND AND SA3.D_E_L_E_T_ = ' ' "
cQuery += " INNER JOIN "+RetSqlName("SA1")+" SA1 ON A1_FILIAL = '"+xFilial("SA1")+"'  	AND A1_COD=UA_CLIENTE AND A1_LOJA=UA_LOJA AND SA1.D_E_L_E_T_ = ' ' "
cQuery += " WHERE UB_FILIAL = '"+xFilial("SUB")+"' "
cQuery += " AND UB_NUM = '"+SUA->UA_NUM+"' "
cQuery += " AND SUB.D_E_L_E_T_ = ' ' "
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,ChangeQuery(cQuery)),cAlias,.F.,.T.)
TcSetField(cAlias,"UA_EMISSAO","D",8,0) 
	
R103Carga(@aPedidos,cAlias)
If Empty(aPedidos)
	Alert("Não existem registros para impressão.")
	restArea( aArea )
	Return nil
EndIf 

oReport := reportDef()

If !Empty(oReport)
	oReport:printDialog()
Endif

RestArea(aArea)
Return Nil


//---------------------------------------------------------------------------
Static Function ReportDef()

oPrinter := tReport():New('SYVR103','Termo de responsabilidade de retirada para Agregados', nil, {|oReport| PrintReport(oReport)},"Este relatorio ira imprimir o Termo de responsabilidade de retirada para Agregados")

oPrinter:SetPortrait()
oPrinter:lHeaderVisible	 		:= .F. 	// Não imprime cabeçalho do protheus
oPrinter:lFooterVisible			:= .F.	// Não imprime rodapé do protheus
oPrinter:lParamPage		   		:= .F.	// Não imprime pagina de parametros
oPrinter:oPage:nPaperSize  		:= 9	// Ajuste para papel A4

Return oPrinter


//---------------------------------------------------------------------------
Static Function PrintReport( oReport )
Local   nX
Local   nI
Private oFont1
Private oFont2
Private oFont3

DEFINE FONT oFont1 NAME "Arial" SIZE nil,26 BOLD
DEFINE FONT oFont2 NAME "Arial" SIZE nil,14
DEFINE FONT oFont3 NAME "Arial" SIZE nil,16 BOLD

cabec()

For nX := 1 To Len(aPedidos)	

	If nLin > 2970
		cabec()
	Endif

	nOldLin := nLin
	oPrinter:Say( nLin, 80 ,"Loja: "+Alltrim(SM0->M0_CODFIL)+'-'+Alltrim(SM0->M0_FILIAL), oFont2)
	nLin+=70
	oPrinter:Say( nLin, 80 ,"Pedido: "+aPedidos[nX,13], oFont2)
	nLin+=70
	oPrinter:Say( nLin, 80 ,"Data: "+DTOC(aPedidos[nX,14]), oFont2)
	nLin+=70
	oPrinter:Say( nLin, 80 ,"Vendedor: "+aPedidos[nX,11]+'-'+aPedidos[nX,12], oFont2)
	nLin+=70

	nLin := nOldLin
	oPrinter:Say( nLin, 1100 ,"Cliente: "+aPedidos[nX,2]+'/'+aPedidos[nX,3]+'-'+aPedidos[nX,4], oFont2)
	nLin+=70
	oPrinter:Say( nLin, 1100 ,"Endereço: "+aPedidos[nX,5], oFont2)
	nLin+=70
	oPrinter:Say( nLin, 1100 ,"Bairro: "+aPedidos[nX,6], oFont2)
	nLin+=70
	oPrinter:Say( nLin, 1100 ,"Município/UF: "+alltrim(aPedidos[nX,8])+' / '+aPedidos[nX,9], oFont2)
	nLin+=70
	oPrinter:Say( nLin, 1100 ,"Telefone: ("+Alltrim(aPedidos[nX,15])+") "+aPedidos[nX,10], oFont2)

	nLin+=70

	oPrinter:Say( nLin, 750, "ITENS DO COMPROVANTE DE RETIRADA", oFont3)
	nLin+=140

	For nI := 17 To Len( aPedidos[nX] )
		if nLin > 3250
			cabec()
		endif

		xLinha := iif( aPedidos[nX,nI,7] == "2", "(mostruário) ", "")
		xLinha += cValToChar(aPedidos[nX,nI,4])+ " x " + alltrim(aPedidos[nX,nI,2])
		oPrinter:Say( nLin, 80, xLinha, oFont2)
		nLin+=70
	Next

Next

nLin+=40
oPrinter:Line(nLin, 80, nLin, 2300)
nLin+=60

If nLin + 550 > 3320
	cabec()
Endif

oPrinter:Say( nLin, 100 ,"O cliente está ciente do produto e estado em que o mesmo se encontra, concorda com a total responsabilidade", oFont2)
nLin+=100
oPrinter:Say( nLin, 100 ,"e está ciente em caso de mostruário que não há garantia do produto.", oFont2)
nLin+=140

oPrinter:Say( nLin, 100 ,"Declaro haver recebido a(s) mercadoria(s) constante acima neste comprovante de retirada em perfeito estado", oFont2)
nLin+=100
oPrinter:Say( nLin, 100 ,"não tendo nada a declarar.", oFont2)
nLin+=210

oPrinter:Say( nLin, 100 ,"Assinatura: ____________________________________ Local: _______________________________ Data: ___/___/______", oFont2) 

SA1->( dbSetOrder(1) )
If SA1->( dbSeek( xFilial("SA1") + aPedidos[1,2]+aPedidos[1,3] ) )
	nLin+=100
	If SA1->A1_PESSOA == "J"
		oPrinter:Say( nLin, 100 ,"CNPJ: "+transform( SA1->A1_CGC, "@R 99.999.999/9999-99" ), oFont2)     
	Else
		oPrinter:Say( nLin, 100 ,"CPF: " +transform( SA1->A1_CGC, "@R 999.999.999-99" ), oFont2)
	Endif
Endif

Return Nil


//------------------------------------------
Static Function cabec( )
Local  cLogo := "lgmid.png"
Static nPag  := 0

	If nPag++ > 0
		oPrinter:EndPage()
	Endif

	oPrinter:SayBitmap( 60, 900, cLogo, 586, 489 )

	nLin := 500

	oPrinter:Say( nLin, 550 ,"Termo de responsabilidade de retirada", oFont1)
	nLin += 180

Return Nil 


//------------------------------------------
Static Function R103Carga(aPedidos,cAlias)
Local nPos := 0

//UA_EMISSAO/A1_TEL

DbSelectArea(cAlias)
DbGotop()
While !Eof() 		

	nPos := Ascan( aPedidos ,{|x| x[1]+x[2]+x[3] == (cAlias)->UA_NUM + (cAlias)->A1_COD + (cAlias)->A1_LOJA })
	If nPos == 0
		AAdd( aPedidos , {	(cAlias)->UA_NUM 	, (cAlias)->A1_COD		, (cAlias)->A1_LOJA	, (cAlias)->A1_NOME	,; 
							(cAlias)->A1_END 	, (cAlias)->A1_BAIRRO	, (cAlias)->A1_CEP 	, (cAlias)->A1_MUN	,;
							(cAlias)->A1_EST 	, (cAlias)->A1_TEL		, (cAlias)->A3_COD	, (cAlias)->A3_NOME	,;							
							(cAlias)->UA_NUMSC5	, (cAlias)->UA_EMISSAO 	, (cAlias)->A1_DDD	, (cAlias)->UA_CODOBS,	{	(cAlias)->UB_PRODUTO,; 
																														(cAlias)->B1_DESC,; 
																														(cAlias)->UB_UM,; 
																														(cAlias)->UB_QUANT,;
																														(cAlias)->UB_VRUNIT,;
																														(cAlias)->UB_VLRITEM,;
																														(cAlias)->UB_MOSTRUA } } )

					nPos := Len(aPedidos)
	Else
		AAdd( aPedidos[nPos] , { 	(cAlias)->UB_PRODUTO	,(cAlias)->B1_DESC	  ,(cAlias)->UB_UM      ,(cAlias)->UB_QUANT,;
									(cAlias)->UB_VRUNIT	 	,(cAlias)->UB_VLRITEM ,(cAlias)->UB_MOSTRUA } )
	EndIf		
	
	DbSelectArea(cAlias)
	DbSkip()
EndDo  
(cAlias)->(DbCloseArea())

Return Nil
