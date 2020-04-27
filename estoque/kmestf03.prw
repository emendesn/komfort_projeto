#Include "rwmake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "TbiConn.ch"


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ±±
±±³Funcao ³KMESTF03      ³ Autor ³ Caio Garcia           ³ Data ³25/10/18  ±±
±±ÃÄÄÄÄÄÄÄÁÄÄÂÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ±±
±±³Descricao ³ Imprime etiqueta por produto                                ±±
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
User Function KMESTF03()

Local _cPerg      := "KMESTF03"
Local _aEtq       := {}
Local _cDimen     := ""
Local _nx         := 0
Local _cCodBar    := ""
Private _oDlg     := Nil
Private _oLbx     := Nil
Private oOk       := LoadBitmap( GetResources(), "LBOK" )
Private oNo       := LoadBitmap( GetResources(), "LBNO" )

_cPerg    := PadR(_cPerg, Len(SX1->X1_GRUPO))
fAjustSX1(_cPerg)

If Pergunte(_cPerg,.T.)
	
	_cQuery := " SELECT * "
	_cQuery += " FROM " + RETSQLNAME("SBF") + " SBF (NOLOCK) "
	_cQuery += " INNER JOIN " + RETSQLNAME("SB1") + " SB1 (NOLOCK) ON B1_COD = BF_PRODUTO AND SB1.D_E_L_E_T_ <> '*' "
	_cQuery += " WHERE SBF.D_E_L_E_T_ <> '*' "
	_cQuery += " AND BF_PRODUTO BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	_cQuery += " AND BF_LOCAL BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
	_cQuery += " AND BF_LOCALIZ BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
	_cQuery += " AND BF_FILIAL = '"+xFilial("SBF")+"' "
	_cQuery += " AND BF_QUANT > 0 "
	
	_cQuery := ChangeQuery(_cQuery)
	
	_cAlias   := GetNextAlias()
	
	DbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, _cQuery ), _cAlias, .T., .F. )
	
	DbSelectArea(_cAlias)
	(_cAlias)->(DbGoTop())
	
	While (_cAlias)->(!Eof())
		
		DbSelectArea("SB5")
		SB5->(DbSetOrder(1))
		If SB5->(DbSeek(xFilial("SB5") + (_cAlias)->BF_PRODUTO))
			_cDimen := cValToChar(SB5->B5_ALTURLC) + " x "+  cValToChar(SB5->B5_LARGLC) + " x " + cValToChar(SB5->B5_COMPRLC)
		EndIf
		
		AADD(_aEtq,{IIF(MV_PAR07==1,.T.,.F.),(_cAlias)->BF_PRODUTO, (_cAlias)->B1_CODBAR,(_cAlias)->B1_DESC, (_cAlias)->BF_LOCALIZ,_cDimen,""})
		
		(_cAlias)->(DbSkip())
		
	EndDo
	
	If Len(_aEtq) > 0
		
		DEFINE MSDIALOG _oDlg TITLE "Selecione Etiquetas" FROM 0,0 TO 500,600 PIXEL
		
		@ 05,05 LISTBOX _oLbx FIELDS HEADER " ","Código","SKU","Descrição","Endereço" SIZE 290,230 OF _oDlg PIXEL ;
		ON dblClick(_aEtq[_oLbx:nAt,1] := !_aEtq[_oLbx:nAt,1],_oLbx:Refresh())
		_oLbx:SetArray( _aEtq )
		_oLbx:bLine := {|| {Iif(_aEtq[_oLbx:nAt,1],oOk,oNo),; //Seleciona
		_aEtq[_oLbx:nAt,2],; //CODIGO
		_aEtq[_oLbx:nAt,3],; //SKU
		_aEtq[_oLbx:nAt,4],; //DESCRIÇÃO
		_aEtq[_oLbx:nAt,5]}} //ENDEREÇO
		
		DEFINE SBUTTON FROM 237,260 TYPE 1 ACTION _oDlg:End() ENABLE OF _oDlg
		ACTIVATE MSDIALOG _oDlg CENTER
		
		
		//Faz a Impressao das Etiquetas
		If Len( _aEtq ) > 0
			cModelo:= "ZEBRA"
			cPorta := "LPT1"
			MSCBPRINTER(cModelo,cPorta,,110,.F.,,,,,,)
			MSCBLOADGRF("LOGOZ.GRF")
			MSCBCHKSTATUS(.F.)
			nQtdCont := 0
			nContad	:= 0
			nQtdCont := 0
			For _nx := 1 To Len(_aEtq)
				
				If _aEtq[_nx][1]
					
					cCodProdu := _aEtq[_nx][02]
					DbSelectArea("SB1")
					SB1->(DbSetOrder(1))
					SB1->(DbSeek(xFilial("SB1") + cCodProdu ))
					
					DbSelectArea("SA2")
					SA2->(DbSetOrder(1))
					SA2->(DbSeek(xFilial("SA2") + SB1->B1_PROC ))
					_cForne := SA2->A2_COD+"/"+SA2->A2_LOJA+" - "+SA2->A2_NOME
					
					MSCBBEGIN(1,4)
					MSCBGRAFIC(90,03,"LOGOZ")
					
					_cCodBar := IIF(Empty(Alltrim(_aEtq[_nx,3])),_aEtq[_nx][02],_aEtq[_nx][03])
					MSCBWrite("^FO608,32^GFA,08960,08960,00028,:Z64:eJzt2bFu2zAQBuATFJQZjMjZPBRVH8FjB6Hqo/gR1LFAEAno0NfS4LEPoW4Funh0AUOsKNrUkdJ/tpUUSIBwKJB+rS0dj8cjQ/Q23sbzjYio1FofntnyznbASFXwWUg18yyZ/DZr5R5b+wAtPnyAluyTao6ltaqRlVWMjbA9UAStIPqCbDMJ5w0OY7qBFms8D8l0JtmY6XaW5ZRWyD5TUiN7IDxHhTAPr8Wk95PiIsVTslRraIkwf7GQEzRdXc7n53+wrtbVyMrZhuMiGRGuWV20K2ygKPeGc+llmVBb5Xmo5pk0R0Luzp+jep69jjm6dP7iamTub+J9aGyOdGjsH5eVZ96Ya3kdGItL2syzZO+Z6bPcz+rgmenP3Cep9ipz1TWC1oVae2ae8/gEiSa2bo6WHd9OVyWyUlcsaL51GZDvrjYToDoNjCjrtyVjas8t6qPyVx/twM32LyeLW262D3mqRZqb3VNPRsMC6Pdps1a+TVqwv5cNs6AvGIL2ZIu1/nVQWrdDhnrWGhsC6pnurZ22H53F3LL+/ZxFLtPOmO1tmNWD2Vg7I262fxksbwaz/Quz3WC2fxksZWb7l8Fc0M5ZP5gdsCmNLRatcmbr7mAuaFcalZI1wzwEMXMBdfsms5RbUvl2YKb870vaCy327RRQ3xS21topoJ6dkuEYND4PDT2jHb9PMrtuwXOO3y/Sf6CZolqBeEqWh8bmrxTsMZwjli9FaCzPxlZD43l9jfF15ObogvUnrVtpvYt1QrBUMF7PRtZg4/XzCvPq9RXm7Q8X2mg/Gqwd7WNuRGvz5/Vmh7dvBvdn3j5tze3vp+w8fuZ7Qn0B0R2hfsKe8Zy1l1tcof7F1onpfonsvVQ+1WfR6c6q7PuzaZvs6y6yyT7y+JPpP5FN9K3uPDbqd72zxahPZjM76q+x5fyMEvTz3gjOAd5IA+N3csHZwruTC84rknn3daVvKT/fBuejjN8zBOexNT")
					MSCBWrite("vZhec43n96nWhk7irx/edLskKwtXBmliwT7m0+oLsEMln9iAjfu5mPRXe4Z4xy+CizR4TudMjkJ7DFJ3xfJ9nqQBn6suXW3LNPj/stvkv/Kpj0/0S7EewWW7qiNbIbwkZ2N5ocatfvRlfbYoXnb7XAd3nLG9HgKGaa9JnLRRczsI5Wt1Tw/YKPZEdFDO4c44Y26nuNvnKjQJ0QrcuXd6AuGbsDluoaGt1sigxb9jDP8j14h7vhKDh+zhWqnt16WACgfh3B0a1bb1+71JbbGv4ObLndpKjurrYfUwXujBc/KVNgD+j6gLWKp23ZpTbKCcnI5BKYo65+Qlv9xtbVT2j3M83UVvQO/f8DMetyolDgd1n3XY1UYN2a+qnA3JpUiqdJtLcxHv8A+9BsqA==:4D7D")
					MSCBSAY(065,010, "FORNECEDOR : " + Left(_cForne, 30),"R","B","040,020")
					MSCBSAY(057,010, "CODIGO PRODUTO FORNECEDOR : " + 	_aEtq[_nx][07],"R","0","030,020")
					MSCBSAY(051,010, "CODIGO PRODUTO NA KOMFORT : ","R","0","030,020")
					MSCBSAY(051,050, _aEtq[_nx][02],"R","B","040,020")
					MSCBSAY(051,120, "DIMENSÃO : " + _aEtq[_nx][06],"R","0","030,020")
					cEnde := _aEtq[_nx][05]
					
					If !Empty(AllTrim(cEnde))
						
						MSCBSAYBAR(78,110,cEnde,"R","MB07",20,.F.,.T.,.F.,,2,1)
						
					EndIf
					
					MSCBSAY( 040,010, left(_aEtq[_nx][04],45)  ,"R","B","040,020")
					MSCBSAY( 032,010, substr(_aEtq[_nx][04],46),"R","B","040,020")
					
					aEnde   := retEnde( cEnde )
					nInicio := 90	// 100
					nAltura := 30	//  20
					for nW := 1 to len( aEnde )
						MSCBSAY(nInicio - nW * nAltura,160 ,aEnde[nW],"R","0","310,310")
					next
					
					MSCBSAYBAR(12,25,_cCodBar,"R","MB07",15,.F.,.T.,.F.,,4,3)
					
					MSCBEND()
					
				EndIf
				
			Next _nx
			
		EndIf
		
		MSCBCLOSEPRINTER()
		
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

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ AjustaSX1³ Autor ³ Caio Garcia                   ³ Data ³  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Verifica as perguntas inclu¡ndo-as caso não existam        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fAjustSX1(_cPerg)

Local _aArea	:= GetArea()
Local aRegs		:= {}

dbSelectArea("SX1")
dbSetOrder(1)

_cPerg := padr(_cPerg,len(SX1->X1_GRUPO))

Aadd(aRegs,{_cPerg,"01","Produto De...","MV_CH1" ,"C",15,0,"G","MV_PAR01","SB1","","","","",""})
Aadd(aRegs,{_cPerg,"02","Produto Até..","MV_CH2" ,"C",15,0,"G","MV_PAR02","SB1","","","","",""})
Aadd(aRegs,{_cPerg,"03","Local De..."  ,"MV_CH3" ,"C",2,0,"G","MV_PAR03","NNR","","","","",""})
Aadd(aRegs,{_cPerg,"04","Local Até.."  ,"MV_CH4" ,"C",2,0,"G","MV_PAR04","NNR","","","","",""})
Aadd(aRegs,{_cPerg,"05","Endereço De...","MV_CH5","C",15,0,"G","MV_PAR05","SBF","","","","",""})
Aadd(aRegs,{_cPerg,"06","Endereço Até..","MV_CH6","C",15,0,"G","MV_PAR06","SBF","","","","",""})
Aadd(aRegs,{_cPerg,"07","Marcado?","MV_CH7","C",1,0,"C","MV_PAR07","","Sim","Não","","",""})

DbSelectArea("SX1")
DbSetOrder(1)

For _i := 1 To Len(aRegs)
	
	If  !DbSeek(aRegs[_i,1]+aRegs[_i,2])
		RecLock("SX1",.T.)
		Replace X1_GRUPO   with aRegs[_i,01]
		Replace X1_ORDEM   with aRegs[_i,02]
		Replace X1_PERGUNT with aRegs[_i,03]
		Replace X1_VARIAVL with aRegs[_i,04]
		Replace X1_TIPO    with aRegs[_i,05]
		Replace X1_TAMANHO with aRegs[_i,06]
		Replace X1_PRESEL  with aRegs[_i,07]
		Replace X1_GSC     with aRegs[_i,08]
		Replace X1_VAR01   with aRegs[_i,09]
		Replace X1_F3      with aRegs[_i,10]
		Replace X1_DEF01   with aRegs[_i,11]
		Replace X1_DEF02   with aRegs[_i,12]
		Replace X1_DEF03   with aRegs[_i,13]
		Replace X1_DEF04   with aRegs[_i,14]
		Replace X1_DEF05   with aRegs[_i,15]
		MsUnlock()
	EndIf
	
Next _i

RestArea(_aArea)

Return