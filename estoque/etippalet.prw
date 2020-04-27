#include 'totvs.ch'
/*==========================================================================
 Funcao.....: EtiPPalet
 Descricao..: Impressao de Etiquetas p/ Porta Palete
 Autor......: Cristiam Rossi
 Data.......: 17/04/2017
 Parametros.: Nil
 Retorno....: Nil .
==========================================================================*/
User function EtiPPalet()
Local   aArea     := getArea()
Local   cPerg     := padR("ETIPALETE", 10)

	AjustaSX1( cPerg )

	IF Pergunte( cPerg, .T.)
		FwMsgRun(, {|| Imprime() }, , "Imprimindo Etiqueta, Por favor Aguarde" )
	Endif

	restArea( aArea )
Return Nil


//-------------------------------------------------
Static Function Imprime()
Local   aEnder  := {}
Local   cModelo := "ZEBRA"
Local   cPorta  := "LPT1"
Local   nQtdImp := 1
Local   nI

	SBE->( dbSetOrder(1) )
	SBE->( dbSeek( MV_PAR01 + MV_PAR02 + MV_PAR03, .T.  ) )
	while ! SBE->( EOF() ) .and. SBE->( BE_FILIAL+BE_LOCAL+BE_LOCALIZ ) <= MV_PAR01 + MV_PAR02 + MV_PAR04

		aadd( aEnder, SBE->BE_LOCALIZ )

		SBE->( dbSkip() )
	end

	if len( aEnder ) == 0
		msgStop( "Não foram encontrados endereços, reveja os parâmetros","Impressão de Etiquetas Porta Palete" )
	else

	  	MSCBPRINTER(cModelo,cPorta,,110,.F.,,,,,,)
//	  	MSCBPRINTER(cModelo,cPorta,,110,.F.,,,,4000, "ZEBRACD2", .F.)	// modelo com Fila mscbSpool

	    MSCBLOADGRF("LOGOZ.GRF")
		MSCBCHKSTATUS(.F.)

		for nI := 1 to len( aEnder )
			MSCBBEGIN( nQtdImp, 4 )
			MSCBGRAFIC( 90, 300, "LOGOZ" )

			MSCBWrite("^FO608,32^GFA,08960,08960,00028,:Z64:eJzt2bFu2zAQBuATFJQZjMjZPBRVH8FjB6Hqo/gR1LFAEAno0NfS4LEPoW4Funh0AUOsKNrUkdJ/tpUUSIBwKJB+rS0dj8cjQ/Q23sbzjYio1FofntnyznbASFXwWUg18yyZ/DZr5R5b+wAtPnyAluyTao6ltaqRlVWMjbA9UAStIPqCbDMJ5w0OY7qBFms8D8l0JtmY6XaW5ZRWyD5TUiN7IDxHhTAPr8Wk95PiIsVTslRraIkwf7GQEzRdXc7n53+wrtbVyMrZhuMiGRGuWV20K2ygKPeGc+llmVBb5Xmo5pk0R0Luzp+jep69jjm6dP7iamTub+J9aGyOdGjsH5eVZ96Ya3kdGItL2syzZO+Z6bPcz+rgmenP3Cep9ipz1TWC1oVae2ae8/gEiSa2bo6WHd9OVyWyUlcsaL51GZDvrjYToDoNjCjrtyVjas8t6qPyVx/twM32LyeLW262D3mqRZqb3VNPRsMC6Pdps1a+TVqwv5cNs6AvGIL2ZIu1/nVQWrdDhnrWGhsC6pnurZ22H53F3LL+/ZxFLtPOmO1tmNWD2Vg7I262fxksbwaz/Quz3WC2fxksZWb7l8Fc0M5ZP5gdsCmNLRatcmbr7mAuaFcalZI1wzwEMXMBdfsms5RbUvl2YKb870vaCy327RRQ3xS21topoJ6dkuEYND4PDT2jHb9PMrtuwXOO3y/Sf6CZolqBeEqWh8bmrxTsMZwjli9FaCzPxlZD43l9jfF15ObogvUnrVtpvYt1QrBUMF7PRtZg4/XzCvPq9RXm7Q8X2mg/Gqwd7WNuRGvz5/Vmh7dvBvdn3j5tze3vp+w8fuZ7Qn0B0R2hfsKe8Zy1l1tcof7F1onpfonsvVQ+1WfR6c6q7PuzaZvs6y6yyT7y+JPpP5FN9K3uPDbqd72zxahPZjM76q+x5fyMEvTz3gjOAd5IA+N3csHZwruTC84rknn3daVvKT/fBuejjN8zBOexNT")
			MSCBWrite("vZhec43n96nWhk7irx/edLskKwtXBmliwT7m0+oLsEMln9iAjfu5mPRXe4Z4xy+CizR4TudMjkJ7DFJ3xfJ9nqQBn6suXW3LNPj/stvkv/Kpj0/0S7EewWW7qiNbIbwkZ2N5ocatfvRlfbYoXnb7XAd3nLG9HgKGaa9JnLRRczsI5Wt1Tw/YKPZEdFDO4c44Y26nuNvnKjQJ0QrcuXd6AuGbsDluoaGt1sigxb9jDP8j14h7vhKDh+zhWqnt16WACgfh3B0a1bb1+71JbbGv4ObLndpKjurrYfUwXujBc/KVNgD+j6gLWKp23ZpTbKCcnI5BKYo65+Qlv9xtbVT2j3M83UVvQO/f8DMetyolDgd1n3XY1UYN2a+qnA3JpUiqdJtLcxHv8A+9BsqA==:4D7D")

//			MSCBWrite("^FT650,1150^A0R,135^FH\^FDTRANSFERENCIA ENTRADA^FS")
//			MSCBWrite("^FT650,1350^A0R,135^FH\^FDENTRADA^FS")					
//			MSCBWrite("^FT550,100^A0R,100^FH\^FD"+alltrim(aEnder[nI])+"^FS")

	   		MSCBSAY( 50, 29, aEnder[nI], "R", "0", "110,090")
			MSCBSAYBAR(20,24, aEnder[nI],"R","MB07",20,.F.,.T.,.F.,, 3, 2, .F.)

//	   		MSCBSAY( 24, 55, aEnder[nI], "N", "0", "110,090")
//			MSCBSAYBAR(16,75, aEnder[nI],"N","MB07",20,.F.,.T.,.F.,, 3, 2, .F.)

			MSCBEND()
		next
		MSCBCLOSEPRINTER()

		msgInfo("Impressão finalizada", "Impressão Etiqueta porta palete")
	endif

Return Nil


//------------------------------------
Static Function AjustaSX1( cPerg )
Local aArea   := getArea()
Local aCpos   := {'X1_PERGUNT','X1_VARIAVL','X1_TIPO','X1_TAMANHO','X1_DECIMAL','X1_GSC','X1_VALID','X1_VAR01','X1_F3','X1_PYME'}
Local aRegs   := {}
Local nI
Local nJ
Local nPos

	aadd(aRegs,{"Filial              ?","mv_ch1","C",len(SBE->BE_FILIAL) ,0,"G","","MV_PAR01","SM0","S"})
	aadd(aRegs,{"Local               ?","mv_ch2","C",len(SBE->BE_LOCAL)  ,0,"G","","MV_PAR02","NNR","S"})
	aadd(aRegs,{"Endereco Inicial    ?","mv_ch3","C",len(SBE->BE_LOCALIZ),0,"G","","MV_PAR03","SBE","S"})
	aadd(aRegs,{"Endereco Final      ?","mv_ch4","C",len(SBE->BE_LOCALIZ),0,"G","","MV_PAR04","SBE","S"})

	SX1->( dbSetOrder(1) )

	for nI := 1 to len( aRegs )
		if ! SX1->( dbSeek( cPerg + StrZero(nI,2) ) )
			recLock("SX1",.T.)
			SX1->X1_GRUPO := cPerg
			SX1->X1_ORDEM := StrZero(nI,2)
			for nJ := 1 to len( aCpos )
				if ( nPos := SX1->( fieldPos( aCpos[nJ] ) ) ) > 0
					SX1->( fieldPut( nPos, aRegs[nI,nJ] ) )
				endif
			next
			msUnlock()
		endif
	next

	restArea( aArea )
Return nil
