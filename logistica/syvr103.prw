#include "totvs.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ SYVR103  ³ Autor ³ Eduardo Patriani      ³ Data ³ 14.02.14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emiss„o do Termo de Retirada de Mercadoria.                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ SYVR103(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Refeito em tReport - Cristiam Rossi em 24/05/2017
/*/
User Function SYVR103()
Local   aArea     := getArea()
Local   cQuery
Private cAlias    := GetNextAlias()                     
Private oPrinter
Private nLin      := 0
Private aPedidos  := {}
                                      
//SUBSTITUIDO PELO FONTE KMOMSR04

Return

//SUA->( DBGOTO( 334 ) )

	cQuery := " SELECT	UA_NUM,UA_NUMSC5,UA_EMISSAO,UA_CODOBS, "
	cQuery += " 		A1_COD,A1_LOJA,A1_NOME,A1_END,A1_BAIRRO,A1_CEP,A1_MUN,A1_EST,A1_DDD,A1_TEL, "
	cQuery += " 		A3_COD,A3_NOME, "
	cQuery += " 		UB_PRODUTO,B1_DESC,UB_UM,UB_QUANT,UB_VRUNIT,UB_VLRITEM,UB_MOSTRUA "
	cQuery += " FROM "+RetSqlName("SUB")+" SUB "
	cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON B1_FILIAL = '"+xFilial("SB1")+"' 	AND B1_COD=UB_PRODUTO AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += " INNER JOIN "+RetSqlName("SUA")+" SUA ON UA_FILIAL = '"+xFilial("SUA")+"'	AND UA_NUM=UB_NUM AND SUA.D_E_L_E_T_ = ' ' "
	cQuery += " INNER JOIN "+RetSqlName("SA3")+" SA3 ON A3_FILIAL = '"+xFilial("SA3")+"' 	AND A3_COD=UA_VEND AND SA3.D_E_L_E_T_ = ' ' "
	cQuery += " INNER JOIN "+RetSqlName("SA1")+" SA1 ON A1_FILIAL = '"+xFilial("SA1")+"'  	AND A1_COD=UA_CLIENTE AND A1_LOJA=UA_LOJA AND SA1.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE UB_FILIAL = '"+xFilial("SUB")+"' "
	cQuery += " AND UB_NUM = '"+SUA->UA_NUM+"' "
	cQuery += " AND UB_TPENTRE IN('1','2') "
	cQuery += " AND SUB.D_E_L_E_T_ = ' ' "
	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,ChangeQuery(cQuery)),cAlias,.F.,.T.)
	TcSetField(cAlias,"UA_EMISSAO","D",8,0)

	R103Carga(@aPedidos,cAlias)
	If Empty(aPedidos)
		Alert("Não existem registros no período informado.")
		restArea( aArea )
		Return nil
	EndIf

	oReport := reportDef()

	if ! Empty( oReport )
		oReport:printDialog()
	endif

	restArea( aArea )
return nil


//---------------------------------------------------------------------------
Static Function reportDef()

	oPrinter := tReport():New('SYVR103','Termo de responsabilidade de retirada', nil, {|oReport| PrintReport(oReport)},"Este relatorio ira imprimir o Termo de responsabilidade de retirada")

	oPrinter:SetPortrait()
	oPrinter:lHeaderVisible	 		:= .F. 	// Não imprime cabeçalho do protheus
	oPrinter:lFooterVisible			:= .F.	// Não imprime rodapé do protheus
	oPrinter:lParamPage		   		:= .F.	// Não imprime pagina de parametros
	oPrinter:oPage:nPaperSize  		:= 9	// Ajuste para papel A4

return oPrinter


//---------------------------------------------------------------------------
Static Function PrintReport( oReport )
Local   nX
Local   nI
Local   nY
Local   cObs
Local   aObs
Private oFont1
Private oFont2
Private oFont3

	DEFINE FONT oFont1 NAME "Arial" SIZE nil,26 BOLD
	DEFINE FONT oFont2 NAME "Arial" SIZE nil,14
	DEFINE FONT oFont3 NAME "Arial" SIZE nil,16 BOLD

	cabec()

	For nX := 1 To Len(aPedidos)

		cObs := U_SyLeSYP(aPedidos[nX,16],TamSx3("UA_OBS")[1])
		aObs := Separa(cObs,CRLF)

		if nLin > 2970
			cabec()
		endif

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

		if nLin + 140 + len(aObs)*70 > 3320
			cabec()
		endif

		oPrinter:Say( nLin, 80 ,"Observações:", oFont2)
		nLin+=70

		For nY := 1 To Len(aObs)
			oPrinter:Say( nLin, 180 ,aObs[nY], oFont2)
			nLin+=70
		Next

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

	if nLin + 550 > 3320
		cabec()
	endif

	oPrinter:Say( nLin, 100 ,"O cliente está ciente do produto e estado em que o mesmo se encontre, concorda com a total responsabilidade", oFont2)
	nLin+=100
	oPrinter:Say( nLin, 100 ,"e está ciente em caso de mostruário que não há garantia do produto.", oFont2)
	nLin+=140

	oPrinter:Say( nLin, 100 ,"Declaro haver recebido a(s) mercadoria(s) constante acima neste comprovante de retirada em perfeito estado", oFont2)
	nLin+=100
	oPrinter:Say( nLin, 100 ,"não tendo nada a declarar.", oFont2)
	nLin+=210

	oPrinter:Say( nLin, 100 ,"Assinatura: ____________________________________ Local: _______________________________ Data: ___/___/______", oFont2)

	SA1->( dbSetOrder(1) )
	if SA1->( dbSeek( xFilial("SA1") + aPedidos[1,2]+aPedidos[1,3] ) )
		nLin+=100
		if SA1->A1_PESSOA == "J"
			oPrinter:Say( nLin, 100 ,"CNPJ: "+transform( SA1->A1_CGC, "@R 99.999.999/9999-99" ), oFont2)
		else
			oPrinter:Say( nLin, 100 ,"CPF: " +transform( SA1->A1_CGC, "@R 999.999.999-99" ), oFont2)
		endif
	endif

return nil


//------------------------------------------
Static Function cabec( )
Local  cLogo := "lgmid.png"
Static nPag  := 0

	if nPag++ > 0
		oPrinter:EndPage()
	endif

	oPrinter:SayBitmap( 60, 900, cLogo, 586, 489 )

	nLin := 500

	oPrinter:Say( nLin, 550 ,"Termo de responsabilidade de retirada", oFont1)
	nLin += 180

return nil


//------------------------------------------
Static Function R103Carga(aPedidos,cAlias)
Local nPos := 0

//UA_EMISSAO/A1_TEL

dbSelectArea(cAlias)
dbGotop()
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
	
	dbSelectArea(cAlias)
	dbSkip()
EndDo  
(cAlias)->(DbCloseArea())

Return nil
