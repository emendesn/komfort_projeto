#Include "rwmake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "TbiConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ±±
±±³Funcao ³KMESTF04      ³ Autor ³ Caio Garcia           ³ Data ³25/10/18  ±±
±±ÃÄÄÄÄÄÄÄÁÄÄÂÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ±±
±±³Descricao ³ Imprime etiqueta na pré nota                                ±±
±±³          ³                                                             ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.              ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                      ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ±±
±±³            ³        ³      ³                                           ±±
±±³            ³        ³      ³                                           ±±
±±³            ³        ³      ³                                           ±±
±±³            ³        ³      ³                                           ±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function KMESTF04()

Local   oDlg
Local _aEtq       := {}
Local _cDimen     := ""
Local _nx         := 0
Local _cCodBar    := ""
Local   nOpcSel   := 0
Local _cAlias	  :=GetNextAlias()
Local nPFlag 	  := 0
Local oButton1
Local oButton2
Local oButton3
Private nOpcSel
Private nPFlag 	  := 0
Private aCabIt 	  := {}
Private aItens 	  := {}
Private aZl2	  := {}
Private aEnder	  := {}
Private oGrid
Private nOrder 	  := 0
Private _oDlg     := Nil
Private _oLbx     := Nil
Private oOk       := LoadBitmap( GetResources(), "LBOK" )
Private oNo       := LoadBitmap( GetResources(), "LBNO" )
Private lImprimi  := .F.
Private _AENDSLD  := {}
Private lEmpEnd   :=.F.



	cDocde  := F1_DOC
	cDocAte := F1_DOC
	cSerie  := F1_SERIE
	cForn   := F1_FORNECE
	cLoja   := F1_LOJA
	nTipo   := 1
	cTipo   := "ENTRADA"
	_cFil   := xFilial("SF1")
	
	DEFINE MSDIALOG oDlg                               ;
	          TITLE "Seleçao da Nota Fiscal"           ;
			  OF    oMainWnd                           ;
			  PIXEL                                    ;
			  FROM  0,0 TO 300,280
	
	DEFINE FONT oFnt                                   ;
	       NAME "ARIAL"                                ;
		   SIZE 0,-12                                  ;
		   BOLD

	@ 05,05 SAY  "Impressão de Etiqueta de Mercadoria" ; 
	        FONT oFnt                                  ;
			OF   oDlg                                  ;
			PIXEL
	
	@ 20,05 SAY  "Documento de:"                       ;
	        OF   oDlg                                  ;
			PIXEL
			
	@ 19,45 msget cDOCde Size 60,9 Picture "@!" of oDlg Pixel
	
	@ 35,05 say "Documento até:" of oDlg Pixel
	@ 34,45 msget cDOCate Size 60,9 Picture "@!" of oDlg Pixel
	
	@ 50,05 say "Série:" of oDlg Pixel
	@ 49,45 msget cSerie Size 30,9 Picture "XXX" of oDlg Pixel
	
	@ 65,05 say "Fornecedor:" of oDlg Pixel
	@ 64,45 msget cForn Size 60,9 Picture "999999" F3 "SA2" of oDlg Pixel
	
	@ 80,05 say "Loja For.:" of oDlg Pixel
	@ 79,45 msget cLoja Size 60,9 Picture "99" of oDlg Pixel
	
	@ 95,05 say "Filial:" of oDlg Pixel
	@ 94,45 msget _cFil Size 60,9 Picture "9999" F3 "SM0" of oDlg Pixel
	
	@ 110,05 say "Tipo:" of oDlg Pixel
	@ 109,45 combobox oCmb Var cTipo ITEMS {"ENTRADA"} When .F. size 60,9 of oDlg Pixel
	
	
	@ 130, 010 BUTTON oButton1 PROMPT "Imprimir" SIZE 025, 016 OF oDlg ACTION iif( valCpo(cDOCde, cDOCate, cSerie), (nOpcSel := 1, oDlg:End()) , nil) PIXEL
	@ 130, 050 BUTTON oButton3 PROMPT "Reimprimir" SIZE 030, 016 OF oDlg ACTION iif( valCpo(cDOCde, cDOCate, cSerie), (nOpcSel := 3, oDlg:End()) , nil) PIXEL
	@ 130, 110 BUTTON oButton2 PROMPT "Cancelar" SIZE 025, 016 OF oDlg ACTION Processa({|| nOpcSel := 2, oDlg:End() }) PIXEL
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
	If nOpcSel == 1 .OR. nOpcSel == 3
		
		If nOpcSel == 1
			_cQuery := " SELECT D1_COD, F1_STATUS, B1_CODBAR, B1_DESC, D1_QUANT, D1_FORNECE, D1_DOC, D1_SERIE, D1_ITEM, D1_LOJA, D1_ENDER, B5_LARGLC, B5_COMPRLC, B5_ALTURLC, B1_XANDAR, D1_NUMSEQ "
			_cQuery += " FROM " + RETSQLNAME("SD1") + " SD1 (NOLOCK) "
			_cQuery += " INNER JOIN " + RETSQLNAME("SF1") + " SF1 (NOLOCK) ON SF1.D_E_L_E_T_ <> '*' AND F1_FILIAL = D1_FILIAL AND F1_DOC = D1_DOC AND F1_FORNECE = D1_FORNECE AND F1_LOJA = D1_LOJA "
			_cQuery += " INNER JOIN " + RETSQLNAME("SB1") + " SB1 (NOLOCK) ON SB1.D_E_L_E_T_ <> '*' AND B1_COD = D1_COD "
			_cQuery += " INNER JOIN " + RETSQLNAME("SB5") + " SB5 (NOLOCK) ON SB5.D_E_L_E_T_ <> '*' AND B1_COD = B5_COD "
			_cQuery += " WHERE SD1.D_E_L_E_T_ <> '*' "
			_cQuery += " AND B1_LOCALIZ = 'S'"
			_cQuery += " AND D1_DOC BETWEEN  '"+cDOCde+"' AND '"+cDOCate+"' "
			_cQuery += " AND D1_SERIE = '"+cSerie+"'  "
			_cQuery += " AND D1_FORNECE = '"+cForn+"'  "
			_cQuery += " AND D1_LOJA = '"+cLoja+"'  "
			_cQuery += " AND D1_FILIAL = '"+_cFil+"'  "
			_cQuery += " ORDER BY D1_FILIAL, D1_DOC, D1_ITEM  "
		Else
			_cQuery := " SELECT ZL2_COD D1_COD, F1_STATUS, B1_CODBAR, B1_DESC, ZL2_QUANT D1_QUANT, ZL2_FORNE D1_FORNECE, ZL2_NOTA D1_DOC, ZL2_SERIE D1_SERIE, ZL2_ITEMNF D1_ITEM,ZL2_LOJA D1_LOJA, ZL2_LOCALI D1_ENDER "
			_cQuery += " FROM " + RETSQLNAME("ZL2") + " ZL2 JOIN SB1010 (NOLOCK) SB1 ON ZL2.ZL2_COD=SB1.B1_COD JOIN SF1010 (NOLOCK) SF1 ON ZL2.ZL2_NOTA=SF1.F1_DOC AND ZL2.ZL2_SERIE=SF1.F1_SERIE AND ZL2.ZL2_FORNE=SF1.F1_FORNECE AND ZL2.ZL2_LOJA=SF1.F1_LOJA "
			_cQuery += " WHERE ZL2.D_E_L_E_T_ <> '*' "
			_cQuery += " AND ZL2_NOTA BETWEEN  '"+cDOCde+"' AND '"+cDOCate+"' "
			_cQuery += " AND ZL2_SERIE = '"+cSerie+"'  "
			_cQuery += " AND ZL2_FORNE = '"+cForn+"'  "
			_cQuery += " AND ZL2_LOJA = '"+cLoja+"'  "
			_cQuery += " AND ZL2_FILIAL = '"+_cFil+"'  "
			_cQuery += " ORDER BY ZL2_FILIAL, ZL2_NOTA, ZL2_ITEMNF  "
		Endif
		
		
		_cQuery := ChangeQuery(_cQuery)
		
		DbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, _cQuery ), _cAlias, .T., .F. )
		
		DbSelectArea(_cAlias)
		(_cAlias)->(DbGoTop())
		While (_cAlias)->(!Eof())
			DbSelectArea("SB5")
			SB5->(DbSetOrder(1))
			If SB5->(DbSeek(xFilial("SB5") + (_cAlias)->D1_COD))
				_cDimen := cValToChar(SB5->B5_ALTURLC) + " x "+  cValToChar(SB5->B5_LARGLC) + " x " + cValToChar(SB5->B5_COMPRLC)
			EndIf
			//    1          2                     3                    4              5                     6                    7             8   9    10
			If nOpcSel==1
				For nA := 1 to (_cAlias)->D1_QUANT
					AADD(_aEtq,{ "LBTIK",;
					             (_cAlias)->D1_DOC,;
					             (_cAlias)->D1_ITEM,;
					             (_cAlias)->D1_COD,;
					             (_cAlias)->B1_CODBAR,;
					             alltrim((_cAlias)->B1_DESC),;
					             (_cAlias)->D1_ENDER,;
					             _cDimen,;
					             "",;
					             (_cAlias)->D1_FORNECE,;
					             (_cAlias)->D1_LOJA,;
					             (_cAlias)->D1_DOC,;
					             (_cAlias)->D1_SERIE,;
					             (_cAlias)->D1_ITEM,;
					             (_cAlias)->B5_COMPRLC,;
					             (_cAlias)->B5_LARGLC,;
					             (_cAlias)->B5_ALTURLC,;
					             (_cAlias)->B1_XANDAR,;
					             (_cAlias)->D1_NUMSEQ,;
					             IIF((_cAlias)->F1_STATUS=='A',"","(PRE)")})
				next nA
				
			Else
				
				For nA := 1 to (_cAlias)->D1_QUANT
					AADD(_aEtq,{ "LBTIK",;
					             (_cAlias)->D1_DOC,;
					             (_cAlias)->D1_ITEM,;
					             (_cAlias)->D1_COD,;
					             (_cAlias)->B1_CODBAR,;
					             alltrim((_cAlias)->B1_DESC),;
					             (_cAlias)->D1_ENDER,;
					             _cDimen,;
					             "",;
					             (_cAlias)->D1_FORNECE,;
					             (_cAlias)->D1_LOJA,;
					             (_cAlias)->D1_DOC,;
					             (_cAlias)->D1_SERIE,;
					             (_cAlias)->D1_ITEM,;
					             IIF((_cAlias)->F1_STATUS=='A',"","(PRE)")})
				next nA
			Endif
			(_cAlias)->(DbSkip())
		EndDo
		If nopcsel==1
			for nA := 1 To Len(_aEtq)
				_aEtq[nA][7]:=GetEnd(_aEtq[nA][4],_aEtq[nA][15],_aEtq[nA][16],_aEtq[nA][17],_aEtq[nA][6],_aEtq[nA][18])
			next nA
		Endif
		
		(_cAlias)->(dbcloseArea())
		
		If Len(_aEtq) > 0
			cfilant := "0101"
			fEtiquetas(_aEtq)
			
			//Faz a Impressao das Etiquetas
			If Len( _aEtq ) > 0 .and. lImprimi



				cModelo:= "ZEBRA"
				cPorta := "LPT1"
				MSCBPRINTER(cModelo,cPorta,,110,.F.,,,,,,)
				MSCBLOADGRF("LOGOZ.GRF")
				MSCBCHKSTATUS(.F.)
				nQtdCont := 0
				nContad	:= 0
				nQtdCont := 0
				nPFlag := GdFieldPos("FLAG",oGrid:aheader)
				
				If nOpcSel == 1
					For _nx := 1 To Len(oGrid:aCols)
						AADD(aZl2,{ _cFil,;
					                oGrid:aCols[_nx][2],;
					                cSerie,;
					                oGrid:aCols[_nx][4],;
					                oGrid:aCols[_nx][3],;
					                "",;
					                oGrid:aCols[_nx][7]})
						
					Next _nx
					
					For _nx := 1 To Len(oGrid:aCols)
						If Empty(oGrid:aCols[_nx][7])
							MsgAlert("Os endereços devem ser preenchidos para todos os itens, verifique a capacidade dos enderecos.","Atencao")
							lEmpEnd:=.T.
							Exit
							
						Endif
					Next _nx
					
					
					//Para gravar os dados na tabela ZL2
					If !lEmpEnd
						nX := 1
						While nX <= Len( aZl2 )
							
							// Pesquisa a tabela Para Identificar se o endereco nao foi utilizado anteriormente
							// -- FILIAL + CODIGO + NOTA + SERIE + ITEM_NF + LOCAL + LOCALI
							IF ! ZL2->(DBsetOrder(1), DBseek(xFilial("ZL2")+aZl2[nx][2]+aZl2[nx][3]+aZl2[nx][4]+aZl2[nx][5]+"01"+aZl2[nx][7]))
								
								BEGIN TRANSACTION
									Reclock("ZL2",.T.)
									ZL2->ZL2_FILIAL:= aZl2[nx][1]
									ZL2->ZL2_NOTA  := aZl2[nx][2]
									ZL2->ZL2_SERIE := aZl2[nx][3]
									ZL2->ZL2_COD   := aZl2[nx][4]
									ZL2->ZL2_ITEMNF:= aZl2[nx][5]
									ZL2->ZL2_LOCAL := '01'//aZl2[nx][6]
									ZL2->ZL2_LOCALI:= aZl2[nx][7]
									ZL2->ZL2_QUANT := 1
									ZL2->ZL2_ENDER := 'N'
									ZL2->ZL2_FORNE := cForn
									ZL2->ZL2_LOJA  := cLoja
									ZL2->ZL2_DTIMPR:= dDataBase
									ZL2->ZL2_USRIMP:= cUserName
									ZL2->( Msunlock() )
								END TRANSACTION
								nX++
							else

                                // Procura um novo enredeco caso ja exista a reserva na ZL2
                                IF ( nPos := AScan( _aEtq, { |xItem| xItem[4] == aZl2[nx][4] } ) ) > 0
									aZl2[nx][7]          := GetEnd( _aEtq[ nPos ][4], _aEtq[ nPos ][15], _aEtq[ nPos ][16], _aEtq[ nPos ][17], ;
									                                _aEtq[ nPos ][6], _aEtq[ nPos][18] )
									oGrid:aCols[ nx ][7] := aZl2[ nx ][7]
								Endif
								
							EndIf							

						Enddo

					Endif
				Endif
				
				For _nx := 1 To Len(oGrid:aCols)
					If Empty(oGrid:aCols[_nx][7])
						MsgAlert("Os endereços devem ser preenchidos para todos os itens.","Atencao")
						Exit
						
					Endif
				Next _nx
				If !lEmpEnd
					For _nx := 1 To Len(oGrid:aCols)
						If Empty(oGrid:aCols[_nx][7])
							MsgAlert("Os endereços devem ser preenchidos para todos os itens.","Atencao")
							Exit
						Endif
						If oGrid:aCols[_nx][nPFlag] == "LBTIK"
							cCodProdu := _aEtq[_nx][04]
							DbSelectArea("SB1")
							SB1->(DbSetOrder(1))
							SB1->(DbSeek(xFilial("SB1") + cCodProdu ))
							
							DbSelectArea("SA2")
							SA2->(DbSetOrder(1))
							SA2->(DbSeek(xFilial("SA2") + _aEtq[_nx][10]+_aEtq[_nx][11] ))
							_cForne := SA2->A2_COD+"/"+SA2->A2_LOJA+" - "+SA2->A2_NOME
							
							MSCBBEGIN(1,4)
							MSCBGRAFIC(90,03,"LOGOZ")
							
							_cCodBar := IIF(Empty(Alltrim(_aEtq[_nx][05])),_aEtq[_nx][04],_aEtq[_nx][05])
							MSCBWrite("^FO608,32^GFA,08960,08960,00028,:Z64:eJzt2bFu2zAQBuATFJQZjMjZPBRVH8FjB6Hqo/gR1LFAEAno0NfS4LEPoW4Funh0AUOsKNrUkdJ/tpUUSIBwKJB+rS0dj8cjQ/Q23sbzjYio1FofntnyznbASFXwWUg18yyZ/DZr5R5b+wAtPnyAluyTao6ltaqRlVWMjbA9UAStIPqCbDMJ5w0OY7qBFms8D8l0JtmY6XaW5ZRWyD5TUiN7IDxHhTAPr8Wk95PiIsVTslRraIkwf7GQEzRdXc7n53+wrtbVyMrZhuMiGRGuWV20K2ygKPeGc+llmVBb5Xmo5pk0R0Luzp+jep69jjm6dP7iamTub+J9aGyOdGjsH5eVZ96Ya3kdGItL2syzZO+Z6bPcz+rgmenP3Cep9ipz1TWC1oVae2ae8/gEiSa2bo6WHd9OVyWyUlcsaL51GZDvrjYToDoNjCjrtyVjas8t6qPyVx/twM32LyeLW262D3mqRZqb3VNPRsMC6Pdps1a+TVqwv5cNs6AvGIL2ZIu1/nVQWrdDhnrWGhsC6pnurZ22H53F3LL+/ZxFLtPOmO1tmNWD2Vg7I262fxksbwaz/Quz3WC2fxksZWb7l8Fc0M5ZP5gdsCmNLRatcmbr7mAuaFcalZI1wzwEMXMBdfsms5RbUvl2YKb870vaCy327RRQ3xS21topoJ6dkuEYND4PDT2jHb9PMrtuwXOO3y/Sf6CZolqBeEqWh8bmrxTsMZwjli9FaCzPxlZD43l9jfF15ObogvUnrVtpvYt1QrBUMF7PRtZg4/XzCvPq9RXm7Q8X2mg/Gqwd7WNuRGvz5/Vmh7dvBvdn3j5tze3vp+w8fuZ7Qn0B0R2hfsKe8Zy1l1tcof7F1onpfonsvVQ+1WfR6c6q7PuzaZvs6y6yyT7y+JPpP5FN9K3uPDbqd72zxahPZjM76q+x5fyMEvTz3gjOAd5IA+N3csHZwruTC84rknn3daVvKT/fBuejjN8zBOexNT")
							MSCBWrite("vZhec43n96nWhk7irx/edLskKwtXBmliwT7m0+oLsEMln9iAjfu5mPRXe4Z4xy+CizR4TudMjkJ7DFJ3xfJ9nqQBn6suXW3LNPj/stvkv/Kpj0/0S7EewWW7qiNbIbwkZ2N5ocatfvRlfbYoXnb7XAd3nLG9HgKGaa9JnLRRczsI5Wt1Tw/YKPZEdFDO4c44Y26nuNvnKjQJ0QrcuXd6AuGbsDluoaGt1sigxb9jDP8j14h7vhKDh+zhWqnt16WACgfh3B0a1bb1+71JbbGv4ObLndpKjurrYfUwXujBc/KVNgD+j6gLWKp23ZpTbKCcnI5BKYo65+Qlv9xtbVT2j3M83UVvQO/f8DMetyolDgd1n3XY1UYN2a+qnA3JpUiqdJtLcxHv8A+9BsqA==:4D7D")
							MSCBWrite("^FT650,1000^A0R,100^FH\^FDENTRADA^FS")
							MSCBSAY(065,010, "FORNECEDOR : " + Left(_cForne, 30),"R","B","040,020")
							MSCBSAY(057,010, "CODIGO PRODUTO FORNECEDOR : " + 	_aEtq[_nx][09],"R","0","030,020")
							MSCBSAY(051,010, "CODIGO PRODUTO NA KOMFORT : ","R","0","030,020")
							MSCBSAY(051,050, _aEtq[_nx][04],"R","B","040,020")
							MSCBSAY(051,120, "DIMENSÃO : " + _aEtq[_nx][08],"R","0","030,020")
							MSCBSAY(048,120, "NF/SERIE/ITEM : " + Alltrim(_aEtq[_nx][12]) + "-" + Alltrim(_aEtq[_nx][13]) + "/" + Alltrim(_aEtq[_nx][14])+Alltrim(_aEtq[_nx][15]),"R","0","030,020")
							
							cEnde := oGrid:aCols[_nx][07]
							MSCBSAY( 040,010, left(_aEtq[_nx][06],45)  ,"R","B","040,020")
							MSCBSAY( 032,010, substr(_aEtq[_nx][06],46),"R","B","040,020")
							
							
							aEnde   := retEnde( cEnde )
							nInicio := 90	// 100
							nAltura := 30	//  20
							For nW := 1 To Len( aEnde )
								MSCBSAY(nInicio - nW * nAltura,160 ,aEnde[nW],"R","0","310,310")
							Next
							MSCBSAYBAR(12,25,_cCodBar,"R","MB07",15,.F.,.T.,.F.,,4,3)
							MSCBEND()
						EndIf
					Next _nx
					MSCBCLOSEPRINTER()
				Endif
				fExcel(oGrid:aCols, "Endereços")
			Endif
		Else
			Alert("Não foram encontradas etiquetas nos parâmetros informados")
		EndIf
	Else
		Alert("Cancelado pelo usuário")
	EndIf
	
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ retEnde  ³ Autor ³ Caio Garcia                   ³ Data ³  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Verifica as perguntas inclu¡ndo-as caso não existam        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function retEnde( cEnde )

Local aEnde
Local nI
Local nIt

cEnde := AllTrim( cEnde )
If cEnde == "SEM LOCALIZACAO"
	return {"L","O","C"}
EndIf

aEnde := strTokArr( cEnde, "-" )

If Len( aEnde ) >= 3 	// == 3			// se tiver traços (hífen) vai quebrar por eles
	aSize( aEnde, 3 )
	
Else
	aEnde := {}				// não tem traços (hífen), quebra de 3 em 3
	
	For nI := 1 to 3
		aadd(aEnde, substr(cEnde, nI, 1))				//#RVC20180613.n
	Next
EndIf

Return aEnde


Static Function valCpo( cDOCde, cDOCate, cSerie )

If Empty( cDOCde ) .or. empty( cDOCate ) .or. empty( cSerie )
	msgAlert( "Favor preencher todos os campos", "validação parâmetros" )
	Return .F.
EndIf

Return .T.

//--------------------------------------------------------------
/*/{Protheus.doc} fMarcAll
Description //Marcar/Desmarcar todos itens da tela.
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 31/10/2018 /*/
//--------------------------------------------------------------
Static Function fMarcAll()

Local nx := 0

Local nPFlag := GdFieldPos("FLAG",oGrid:aheader)

for nx := 1 To Len(oGrid:aCols)
	if oGrid:aCols[nx,nPFlag] == "LBNO"
		oGrid:aCols[nx,nPFlag] := "LBTIK"
	else
		oGrid:aCols[nx,nPFlag] := "LBNO"
	endif
next nx

oGrid:Refresh()

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fMarc
Description //Marca o checkbox da linha posicionada.
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 31/10/2018 /*/
//--------------------------------------------------------------
Static Function fMarc(nLin)

Local nPFlag := GdFieldPos("FLAG",oGrid:aheader)
Local nColPos := oGrid:oBrowse:ColPos

if nColPos == 1
	if (oGrid:aCols[nLin,nPFlag] == "LBNO")
		oGrid:aCols[nLin,nPFlag] := "LBTIK"
	else
		oGrid:aCols[nLin,nPFlag] := "LBNO"
	endif
	
	oGrid:Refresh()
elseif nColPos == 7
	oGrid:EditCell()
else
	
endif

Return

Static Function fEtiquetas(_aEtq)

Local oBtnCancel
Local oBtnConfirm
Static _oDlg

DEFINE MSDIALOG _oDlg TITLE "Seleção de etiquetas" FROM 000, 000  TO 500, 900 COLORS 0, 16777215 PIXEL

fMSNewGet(_aEtq)
@ 232, 007 BUTTON oBtnCancel PROMPT "Marcar/Desmarcar " SIZE 062, 016 OF _oDlg ACTION {|| fMarcAll() } PIXEL
@ 232, 317 BUTTON oBtnCancel PROMPT "Cancelar" SIZE 062, 016 OF _oDlg ACTION {|| _oDlg:end() } PIXEL
@ 232, 385 BUTTON oBtnConfirm PROMPT "Imprimir" SIZE 062, 016 OF _oDlg ACTION {|| lImprimi := .T., _oDlg:end() } PIXEL

ACTIVATE MSDIALOG _oDlg CENTERED

Return


Static Function fMSNewGet(_aEtq)

Local nx
Local aCabIt := {}
Local aItens := {}
Local aFields := {"D1_DOC","D1_ITEM","D1_COD","B1_CODBAR","B1_DESC","D1_ENDER"}
Local cAlterFields := "D1_ENDER"



If nOpcSel == 3
	cAlterFields:=''
Endif

Static oGrid

// Define field properties
DbSelectArea("SX3")
SX3->(DbSetOrder(2))

Aadd(aCabIt,{"","FLAG","@BMP",1,0,"","€€€€€€€€€€€€€€","C","","R","","","","V","","",""})

For nx := 1 to Len(aFields)
	If SX3->(DbSeek(aFields[nx]))
		Aadd(aCabIt, {AllTrim(X3Titulo()),;
		SX3->X3_CAMPO,;
		SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,;
		SX3->X3_DECIMAL,;
		SX3->X3_VALID,;
		SX3->X3_USADO,;
		SX3->X3_TIPO,;
		iif(SX3->X3_CAMPO == "D1_ENDER","SBE",SX3->X3_F3),;
		SX3->X3_CONTEXT,;
		SX3->X3_CBOX,;
		SX3->X3_RELACAO,;
		SX3->X3_WHEN,;
		iif(SX3->X3_CAMPO $ cAlterFields,"A",SX3->X3_VISUAL),;
		SX3->X3_VLDUSER,;
		SX3->X3_PICTVAR,;
		SX3->X3_OBRIGAT })
	Endif
Next nx

// Define field values
For nx := 1 to Len(_aEtq)
	aAdd(aItens,{_aEtq[nx][01],_aEtq[nx][02],_aEtq[nx][03],_aEtq[nx][04],_aEtq[nx][05],_aEtq[nx][06],_aEtq[nx][07],.F.})
Next nx

oGrid := MsNewGetDados():New( 001, 001, 229, 448, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", ,, 999, "AllwaysTrue", "", "AllwaysTrue", _oDlg, aCabIt, aItens)

oGrid:oBrowse:bLDblClick := {|| fMarc(oGrid:NAT) }

Return


Static Function fExcel(aItens, cTitle)

Local oExcel := FWMsExcel():New()
Local cArqTemp := GetTempPath() + "ENDERECOS_"+substr(time(), 7, 2)+".XLS"
Local aFields := {"D1_DOC","D1_ITEM","D1_COD","B1_CODBAR","B1_DESC","D1_ENDER"}
Local aCab := {}
Local nx := 0
if len(aItens) <= 0
	Return(msginfo("Não ha dados para impressão...","ATENÇÃO"))
endif

DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nx := 1 to Len(aFields)
	If SX3->(DbSeek(aFields[nx]))
		Aadd(aCab, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
		SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
	Endif
Next nx

cNamePlan := cNameTable := cTitle

oExcel:AddworkSheet(cNamePlan)
oExcel:AddTable (cNamePlan,cNameTable)

//Colunas do Excel ----------------------------------------
for nx := 1 to Len(aCab)
	if aCab[nx][8] == "C"// Tipo Caracter
		oExcel:AddColumn(cNamePlan,cNameTable,aCab[nx][1],1,1)
	elseif aCab[nx][8] == "N"// Tipo Numerico
		oExcel:AddColumn(cNamePlan,cNameTable,aCab[nx][1],3,2)
	else // Tipo Data
		oExcel:AddColumn(cNamePlan,cNameTable,aCab[nx][1],1,3)
	endif
next nx

for nx := 1 to len(aItens)
	if aItens[nx][1] == "LBTIK"
		oExcel:AddRow(cNamePlan,cNameTable,{;
		aItens[nx][2],;
		aItens[nx][3],;
		aItens[nx][4],;
		aItens[nx][5],;
		aItens[nx][6],;
		aItens[nx][7];
		},{1,2,3,4,5,6})
	endif
next nx

oExcel:Activate()
oExcel:GetXMLFile(cArqTemp)
ShellExecute("open", cArqTemp, "", "C:\", 1 )
Return


Static function GetEnd(cCod,ncompr,nlarg,naltur,cDescri, _cndari)

/*
Sofás Cama: (MALDIVAS/VALÊNCIA/HUNGRIA/ESLOVÊNIA). Estas peças cabem um total de 3 peças por posição e especificamente na altura (2).* Elas vem em uma caixa e são empilhadas 3 peças por posição na altura (2).
-Sofás de tamanhos (1,40 até 2,29) especificamente nas alturas (3/4/5/6).
-Sofás de tamanhos (2,30 á 2,50) especificamente na altura(7).
-Sofá *((SOFA DENVER CANTO CT 0.86X0.92X0.86 (CJ 2,30X2,30)). Esta peça cabem 2 peças por posição e especificamente na altura (2).
-Poltronas cabem 3 peças por posição e especificamente da altura (2).
*/

Local cQuery :=""
Local xPosGen:="3,4,5,6"
Local nPos := 0
Local xLocaliz
Local xMed
Local cxPosi:=""
Local xandarf:=""
Local xSaldo:=0
Local cEnderI     := SuperGetMV("KH_ENDERI",.T.,"R55")
Local cEnderF     := SuperGetMV("KH_ENDERF",.T.,"R89")

If _cndari $ xPosGen
	
	xandarf:="6"
	
	_cndari:="3"
	
Else
	
	xandarf:=_cndari
	
Endif
If Select("TRB")>0
	TRB->( dbCloseArea() )
Endif

If _cndari <>'8'
	cQuery := " SELECT ARMAZEM, ENDERECO, CAPACIDADE,SALDO FROM(SELECT ARMAZEM, ENDERECO, CAPACIDADE, SUM(SALDOBF+SALDOZL2) SALDO FROM (SELECT BE_LOCAL ARMAZEM, BE_LOCALIZ ENDERECO, BE_CAPACID CAPACIDADE, "
	cQuery += " (SELECT ISNULL(SUM(BF_QUANT),0) FROM SBF010 (NOLOCK) WHERE BF_LOCAL=SBE.BE_LOCAL AND BF_LOCALIZ=SBE.BE_LOCALIZ AND D_E_L_E_T_='' AND BF_FILIAL=SBE.BE_FILIAL AND SBE.BE_MSBLQL<>'1') SALDOBF, "
	cQuery += " (SELECT ISNULL(SUM(ZL2_QUANT),0) FROM ZL2010 (NOLOCK) WHERE ZL2_LOCAL=SBE.BE_LOCAL AND ZL2_LOCALI=SBE.BE_LOCALIZ AND D_E_L_E_T_='' AND ZL2_ENDER='N' AND ZL2_QUANT > 0) SALDOZL2 "
	cQuery += " FROM SBE010 (NOLOCK) SBE WHERE  SBE.D_E_L_E_T_=' ' AND SBE.BE_LOCAL='01' AND SUBSTRING(SBE.BE_LOCALIZ,1,3) BETWEEN '"+cEnderI+"' AND '"+cEnderF+"' AND SUBSTRING(SBE.BE_LOCALIZ,LEN(BE_LOCALIZ),1) BETWEEN '"+_cndari+"' AND '"+xandarf+"' AND SBE.BE_MSBLQL<>'1') AS SBE1 GROUP BY SBE1.ARMAZEM, ENDERECO, CAPACIDADE) AS SBE2 "
	cQuery += " WHERE SALDO < CAPACIDADE AND ARMAZEM='01'"
	cQuery += " ORDER BY SBE2.ENDERECO ASC "
	
Else
	cEnderI:='R100'
	cEnderF:='R104'
	_cndari:='1'
	xandarf:='7'
	
	
	cQuery := " SELECT ARMAZEM, ENDERECO, CAPACIDADE,SALDO FROM(SELECT ARMAZEM, ENDERECO, CAPACIDADE, SUM(SALDOBF+SALDOZL2) SALDO FROM (SELECT BE_LOCAL ARMAZEM, BE_LOCALIZ ENDERECO, BE_CAPACID CAPACIDADE, "
	cQuery += " (SELECT ISNULL(SUM(BF_QUANT),0) FROM SBF010 (NOLOCK) WHERE BF_LOCAL=SBE.BE_LOCAL AND BF_LOCALIZ=SBE.BE_LOCALIZ AND D_E_L_E_T_='' AND BF_FILIAL=SBE.BE_FILIAL AND SBE.BE_MSBLQL<>'1') SALDOBF, "
	cQuery += " (SELECT ISNULL(SUM(ZL2_QUANT),0) FROM ZL2010 (NOLOCK) WHERE ZL2_LOCAL=SBE.BE_LOCAL AND ZL2_LOCALI=SBE.BE_LOCALIZ AND D_E_L_E_T_='' AND ZL2_ENDER='N' AND ZL2_QUANT > 0) SALDOZL2 "
	cQuery += " FROM SBE010 (NOLOCK) SBE WHERE  SBE.D_E_L_E_T_=' ' AND SBE.BE_LOCAL='01' AND SUBSTRING(SBE.BE_LOCALIZ,1,4) BETWEEN '"+cEnderI+"' AND '"+cEnderF+"' AND SUBSTRING(SBE.BE_LOCALIZ,10,1) BETWEEN '"+_cndari+"' AND '"+xandarf+"' AND SBE.BE_MSBLQL<>'1') AS SBE1 GROUP BY SBE1.ARMAZEM, ENDERECO, CAPACIDADE) AS SBE2 "
	cQuery += " WHERE SALDO < CAPACIDADE AND ARMAZEM='01'"
	cQuery += " ORDER BY SBE2.ENDERECO ASC "
	
Endif

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)
TRB->(DBSELECTAREA("TRB"))

//Vetor private _aEndSld controla o saldo utilizado vs capacidade
While !TRB->( Eof() )
	If ( nPos:= aScan(_aEndSld,{|R| R[1] == TRB->ENDERECO }) ) == 0
		//Verifico se o saldo do endereco ainda esta dentro da capacidade
		If TRB->SALDO+1 <= TRB->CAPACIDADE
			//coloco o saldo mais um na posicao 2 do vetor para
			//controlar o saldo caso seja utilizado o endereco novamente
			aAdd(_aEndSld,{TRB->ENDERECO,TRB->SALDO+1,TRB->CAPACIDADE})
			xLocaliz := TRB->ENDERECO
			EXIT
		Endif
	Else
		//Verifico se o saldo do endereco esta dentro da capacidade
		//Quando ja usei o endereco eu uso a posicao 2 do vetor para                  v
		//controlar o saldo
		If _aEndSld[nPos,2]+1 <= TRB->CAPACIDADE
			_aEndSld[nPos,2]+= 1
			xLocaliz := TRB->ENDERECO
			EXIT
		Endif
	Endif
	TRB->( dbSkip() )
EndDo
TRB->(DbCloseArea())
Return xLocaliz
