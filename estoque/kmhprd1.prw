#Include "rwmake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "TbiConn.ch"


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ±±
±±³Funcao ³KMHPRD1      ³ Autor ³ Vanito Rocha           ³ Data ³24/07/19  ±±
±±ÃÄÄÄÄÄÄÄÁÄÄÂÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ±±
±±³Descricao ³ Imprime etiqueta por produto na Produção                    ±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function KMHPRD1(cOp)

Local _cPerg      := "KMHPRD"
Local _aEtq       := {}
Local _cDimen     := ""
Local _nx         := 0
Local _ny         := 0
Local nW 		  := 1
Local _cCodBar    := ""
Local bCount:=0
Private _oDlg     := Nil
Private _oLbx     := Nil
Private oOk       := LoadBitmap( GetResources(), "LBOK" )
Private oNo       := LoadBitmap( GetResources(), "LBNO" )

_cPerg    := PadR(_cPerg, Len(SX1->X1_GRUPO))
fAjustSX1(_cPerg)

If Pergunte(_cPerg,.T.)
	
	If !Empty(cOp)
		MV_PAR01:=cOp
		MV_PAR02:=cOp
	Endif
	
	
	_cQuery := " SELECT * "
	_cQuery += " FROM " + RETSQLNAME("SC2") + " SC2 (NOLOCK) "
	_cQuery += " INNER JOIN " + RETSQLNAME("SB1") + " SB1 (NOLOCK) ON B1_COD = C2_PRODUTO AND SB1.D_E_L_E_T_ <> '*' JOIN SA2010 SA2 (NOLOCK) ON SA2.A2_COD=SB1.B1_PROC AND SA2.A2_LOJA=SB1.B1_LOJPROC"
	_cQuery += " WHERE SC2.D_E_L_E_T_ <> '*' AND SC2.C2_SEQUEN='001'"
	_cQuery += " AND C2_NUM+C2_ITEM+C2_SEQUEN BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	_cQuery := ChangeQuery(_cQuery)
	
	_cAlias   := GetNextAlias()
	
	DbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, _cQuery ), _cAlias, .T., .F. )
	
	DbSelectArea(_cAlias)
	(_cAlias)->(DbGoTop())
	
	nCount:=MV_PAR04
	If MV_PAR04==0
		nCount:=(_cAlias)->C2_QUJE
	Endif
	
	While (_cAlias)->(!Eof())
		
		DbSelectArea("SB5")
		SB5->(DbSetOrder(1))
		If SB5->(DbSeek(xFilial("SB5") + (_cAlias)->C2_PRODUTO))
			_cDimen := cValToChar(SB5->B5_ALTURLC) + " x "+  cValToChar(SB5->B5_LARGLC) + " x " + cValToChar(SB5->B5_COMPRLC)
		EndIf
		
		//AADD(_aEtq,{(_cAlias)->C2_NUM,(_cAlias)->C2_PRODUTO, (_cAlias)->B1_DESC,(_cAlias)->C2_QUANT})
		AADD(_aEtq,{IIF(MV_PAR03==1,.T.,.F.),(_cAlias)->C2_NUM, (_cAlias)->C2_PRODUTO,(_cAlias)->B1_DESC, (_cAlias)->C2_QUANT,(_cAlias)->C2_EMISSAO,(_cAlias)->C2_ITEM,(_cAlias)->C2_SEQUEN,(_cAlias)->B1_PROC, (_cAlias)->B1_LOJPROC,(_cAlias)->A2_COD,(_cAlias)->A2_LOJA,(_cAlias)->A2_NOME,""})
		
		(_cAlias)->(DbSkip())
		
	EndDo
	(_cAlias)->(DbCloseArea())
	
	If Len(_aEtq) > 0
		
		DEFINE MSDIALOG _oDlg TITLE "Selecione Etiquetas" FROM 0,0 TO 500,600 PIXEL
		
		@ 05,05 LISTBOX _oLbx FIELDS HEADER " ","Código","SKU","Descrição","Endereço" SIZE 290,230 OF _oDlg PIXEL ;
		ON dblClick(_aEtq[_oLbx:nAt,1] := !_aEtq[_oLbx:nAt,1],_oLbx:Refresh())
		_oLbx:SetArray( _aEtq )
		_oLbx:bLine := {|| {Iif(_aEtq[_oLbx:nAt,1],oOk,oNo),; //Seleciona
		_aEtq[_oLbx:nAt,2],; //CODIGO
		_aEtq[_oLbx:nAt,3],; //SKU
		_aEtq[_oLbx:nAt,4]}} //ENDEREÇO
		
		DEFINE SBUTTON FROM 237,260 TYPE 1 ACTION _oDlg:End() ENABLE OF _oDlg
		ACTIVATE MSDIALOG _oDlg CENTER
		
		
		//Faz a Impressao das Etiquetas
		If nCount > 0
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
					For _ny := 1 To nCount
						
						cCodProdu := _aEtq[_nx][03]
						DbSelectArea("SB1")
						SB1->(DbSetOrder(1))
						SB1->(DbSeek(xFilial("SB1") + cCodProdu ))
						
						DbSelectArea("SA2")
						SA2->(DbSetOrder(1))
						SA2->(DbSeek(xFilial("SA2") + _aEtq[_nx][09]+_aEtq[_nx][10]))
						_cForne := _aEtq[_nx][11]+"/"+_aEtq[_nx][12]+" - "+_aEtq[_nx][13]
						
						MSCBBEGIN(1,4)
						MSCBGRAFIC(90,03,"LOGOZ")
						
						_cCodBar := _aEtq[_nx][02]+_aEtq[_nx][07]+_aEtq[_nx][08]
						MSCBWrite("^FO608,32^GFA,08960,08960,00028,:Z64:eJzt2bFu2zAQBuATFJQZjMjZPBRVH8FjB6Hqo/gR1LFAEAno0NfS4LEPoW4Funh0AUOsKNrUkdJ/tpUUSIBwKJB+rS0dj8cjQ/Q23sbzjYio1FofntnyznbASFXwWUg18yyZ/DZr5R5b+wAtPnyAluyTao6ltaqRlVWMjbA9UAStIPqCbDMJ5w0OY7qBFms8D8l0JtmY6XaW5ZRWyD5TUiN7IDxHhTAPr8Wk95PiIsVTslRraIkwf7GQEzRdXc7n53+wrtbVyMrZhuMiGRGuWV20K2ygKPeGc+llmVBb5Xmo5pk0R0Luzp+jep69jjm6dP7iamTub+J9aGyOdGjsH5eVZ96Ya3kdGItL2syzZO+Z6bPcz+rgmenP3Cep9ipz1TWC1oVae2ae8/gEiSa2bo6WHd9OVyWyUlcsaL51GZDvrjYToDoNjCjrtyVjas8t6qPyVx/twM32LyeLW262D3mqRZqb3VNPRsMC6Pdps1a+TVqwv5cNs6AvGIL2ZIu1/nVQWrdDhnrWGhsC6pnurZ22H53F3LL+/ZxFLtPOmO1tmNWD2Vg7I262fxksbwaz/Quz3WC2fxksZWb7l8Fc0M5ZP5gdsCmNLRatcmbr7mAuaFcalZI1wzwEMXMBdfsms5RbUvl2YKb870vaCy327RRQ3xS21topoJ6dkuEYND4PDT2jHb9PMrtuwXOO3y/Sf6CZolqBeEqWh8bmrxTsMZwjli9FaCzPxlZD43l9jfF15ObogvUnrVtpvYt1QrBUMF7PRtZg4/XzCvPq9RXm7Q8X2mg/Gqwd7WNuRGvz5/Vmh7dvBvdn3j5tze3vp+w8fuZ7Qn0B0R2hfsKe8Zy1l1tcof7F1onpfonsvVQ+1WfR6c6q7PuzaZvs6y6yyT7y+JPpP5FN9K3uPDbqd72zxahPZjM76q+x5fyMEvTz3gjOAd5IA+N3csHZwruTC84rknn3daVvKT/fBuejjN8zBOexNT")
						MSCBWrite("vZhec43n96nWhk7irx/edLskKwtXBmliwT7m0+oLsEMln9iAjfu5mPRXe4Z4xy+CizR4TudMjkJ7DFJ3xfJ9nqQBn6suXW3LNPj/stvkv/Kpj0/0S7EewWW7qiNbIbwkZ2N5ocatfvRlfbYoXnb7XAd3nLG9HgKGaa9JnLRRczsI5Wt1Tw/YKPZEdFDO4c44Y26nuNvnKjQJ0QrcuXd6AuGbsDluoaGt1sigxb9jDP8j14h7vhKDh+zhWqnt16WACgfh3B0a1bb1+71JbbGv4ObLndpKjurrYfUwXujBc/KVNgD+j6gLWKp23ZpTbKCcnI5BKYo65+Qlv9xtbVT2j3M83UVvQO/f8DMetyolDgd1n3XY1UYN2a+qnA3JpUiqdJtLcxHv8A+9BsqA==:4D7D")
						MSCBSAY(065,010, "FORNECEDOR : " + Left(_cForne, 30),"R","B","040,020")
						MSCBSAY(057,010, "CODIGO PRODUTO FORNECEDOR : " + 	cCodProdu,"R","0","030,020")
						MSCBSAY(051,010, "CODIGO PRODUTO NA KOMFORT : ","R","0","030,020")
						MSCBSAY(051,050, cCodProdu,"R","B","040,020")
						MSCBSAY(051,120, "Op: "+ _aEtq[_nx][02] + "  Data Produção : " + _aEtq[_nx][06],"R","0","030,020")
						cEnde := "PRD-KO-MFORT"
						aEnde:={'PK','RM','DH'}
						
						MSCBSAY( 040,010, left(_aEtq[_nx][04],45)  ,"R","B","040,020")
						MSCBSAY( 032,010, substr(_aEtq[_nx][04],46),"R","B","040,020")
						
						nInicio := 90	// 100
						nAltura := 30	//  20
						for nW := 1 to len( aEnde )
							MSCBSAY(nInicio - nW * nAltura,160 ,aEnde[nW],"R","0","310,310")
						next
						
						MSCBSAYBAR(12,25,_cCodBar,"R","MB07",15,.F.,.T.,.F.,,4,3)
						MSCBEND()
					Next _ny
				Next _nx
			EndIf
		Endif
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

Aadd(aRegs,{_cPerg,"01","Ordem de...","MV_CH1" ,"C",15,0,"G","MV_PAR01","SB1","","","","",""})
Aadd(aRegs,{_cPerg,"02","Ordem Até..","MV_CH2" ,"C",15,0,"G","MV_PAR02","SB1","","","","",""})
Aadd(aRegs,{_cPerg,"03","Marcado?","MV_CH3","C",1,0,"C","MV_PAR03","","Sim","Não","","",""})
Aadd(aRegs,{_cPerg,"04","Qtd.Etiq.?","MV_CH4","N",2,0,"C","MV_PAR04","","","","","",""})
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
