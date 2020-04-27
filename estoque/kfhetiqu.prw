#include 'protheus.ch'
#include 'parmtype.ch'
/*==========================================================================
 Funcao.....: KFHETIQU
 Descricao..: Impressao de Etiquetas de Produto
 Autor......: Jackson Santos
 Data.......: 15/01/2016
 Parametros.: Nil
 Retorno....: Nil
==========================================================================*/
user function KFHETIQU(aProEan13,lEntrada,nQtdEtq,lTransfer)
Default lEntrada := .F.       
		FwMsgRun(, {|| Imprime(aProEan13,lEntrada,nQtdEtq,lTransfer) }, , "Imprimindo Etiqueta, Por favor Aguarde" )
Return Nil

/*==========================================================================
 Funcao.....: Imprime
 Descricao..: Etiqueta de Produto
==========================================================================*/
Static Function Imprime(aProEan13,lEntrada,nQtdEtq,lTransfer)

	Local aImprime	:= {}
	Local nQuant	:= 0
	Local nColuna	:= 0
	Local nContad	:= 0
	
	Local nX		:= 0
	Local nY		:= 0
	Local nI		:= 0                 
	
	Local _nLen     := 0
	Local _lSel     := .F.
	Private _oDlg     := Nil
	Private _oLbx     := Nil
	Private oOk       := LoadBitmap( GetResources(), "LBOK" )
	Private oNo       := LoadBitmap( GetResources(), "LBNO" )

	Private nQtdImp     := nQtdEtq   
	Private oFont06		:= TFont():New('Arial',,06,,.F.,,,,.F.,.F.)
	Private oFont06n	:= TFont():New('Arial',,06,,.T.,,,,.F.,.F.)
	Private oFont08		:= TFont():New('Arial',,08,,.F.,,,,.F.,.F.)
	Private oFont08n	:= TFont():New('Arial',,08,,.T.,,,,.F.,.F.)
	Private oFont10		:= TFont():New('Arial',,10,,.F.,,,,.F.,.F.)
	Private oFont10n	:= TFont():New('Arial',,10,,.T.,,,,.F.,.F.)
	Private oFont12		:= TFont():New('Arial',,12,,.F.,,,,.F.,.F.)
	Private oFont12n	:= TFont():New('Arial',,12,,.T.,,,,.F.,.F.)
	Private oFont14		:= TFont():New('Arial',,14,,.F.,,,,.F.,.F.)
	Private oFont14n	:= TFont():New('Arial',,14,,.T.,,,,.F.,.F.)
	Private oFont26		:= TFont():New('Arial',,26,,.F.,,,,.F.,.F.)
	Private oFont26n	:= TFont():New('Arial',,26,,.T.,,,,.F.,.F.)
	Private nLin		:= 0 
	Default aProEan13 	:= {}
  	Default lEntrada    := .F.    
  	
  	aAreaSB1 := SB1->(GetArea())
	
	aImprime:= aClone(aProEan13) 
	                
	_nLen := Len(aImprime[1])+1
	
	If !ISINCALLSTACK('U_PRTNFESEF')
	
		_lSel := MsgYesNo("Deseja selecionar etiquetas?","SELETQ")
	
	Else
	
		_lSel := .F.
	
	EndIf
	
	For _nx := 1 To Len(aImprime)  
		
		aSize(aImprime[_nx],_nLen)                        
		aImprime[_nx,_nLen] := !_lSel
					
	Next _nx      
	
	If _lSel              
	
	
		DEFINE MSDIALOG _oDlg TITLE "Selecione Etiquetas" FROM 0,0 TO 500,600 PIXEL

		@ 05,05 LISTBOX _oLbx FIELDS HEADER " ","Item","Código","Descrição","SKU","Endereço" SIZE 290,230 OF _oDlg PIXEL ;
		ON dblClick(aImprime[_oLbx:nAt,_nLen] := !aImprime[_oLbx:nAt,_nLen],_oLbx:Refresh())
		_oLbx:SetArray( aImprime )
		_oLbx:bLine := {|| {Iif(aImprime[_oLbx:nAt,_nLen],oOk,oNo),; //Seleciona
		aImprime[_oLbx:nAt,11],;
		aImprime[_oLbx:nAt,1],;		
		aImprime[_oLbx:nAt,2],;
		aImprime[_oLbx:nAt,3],;		
		aImprime[_oLbx:nAt,6]}}  

		DEFINE SBUTTON FROM 237,260 TYPE 1 ACTION _oDlg:End() ENABLE OF _oDlg
		ACTIVATE MSDIALOG _oDlg CENTER
	
	EndIf

	//Faz a Impressao das Etiquetas
	If Len( aImprime ) > 0                                 
	   	cModelo:= "ZEBRA"
	  	cPorta := "LPT1"
	  	MSCBPRINTER(cModelo,cPorta,,110,.F.,,,,,,)
	    MSCBLOADGRF("LOGOZ.GRF")
		MSCBCHKSTATUS(.F.)
	    nQtdCont := 0
		nContad	:= 0           
		nQtdCont := 0
		For nX 	:= 1 To Len( aImprime )			    
		
			If aImprime[nX][_nLen]
		  
		    	cCodProdu := aImprime[nX][01]
		    	DbSelectArea("SB1") 
				SB1->(DbSetOrder(1))
				SB1->(DbSeek(xFilial("SB1") + cCodProdu ))
	    		MSCBBEGIN(nQtdImp,4)      	     
	        	MSCBGRAFIC(90,03,"LOGOZ")

		    	cCodBar := IIF(Empty(Alltrim(aImprime[nX,3])),aImprime[nX][01],aImprime[nX][03])
		    	If lEntrada
					MSCBWrite("^FO608,32^GFA,08960,08960,00028,:Z64:eJzt2bFu2zAQBuATFJQZjMjZPBRVH8FjB6Hqo/gR1LFAEAno0NfS4LEPoW4Funh0AUOsKNrUkdJ/tpUUSIBwKJB+rS0dj8cjQ/Q23sbzjYio1FofntnyznbASFXwWUg18yyZ/DZr5R5b+wAtPnyAluyTao6ltaqRlVWMjbA9UAStIPqCbDMJ5w0OY7qBFms8D8l0JtmY6XaW5ZRWyD5TUiN7IDxHhTAPr8Wk95PiIsVTslRraIkwf7GQEzRdXc7n53+wrtbVyMrZhuMiGRGuWV20K2ygKPeGc+llmVBb5Xmo5pk0R0Luzp+jep69jjm6dP7iamTub+J9aGyOdGjsH5eVZ96Ya3kdGItL2syzZO+Z6bPcz+rgmenP3Cep9ipz1TWC1oVae2ae8/gEiSa2bo6WHd9OVyWyUlcsaL51GZDvrjYToDoNjCjrtyVjas8t6qPyVx/twM32LyeLW262D3mqRZqb3VNPRsMC6Pdps1a+TVqwv5cNs6AvGIL2ZIu1/nVQWrdDhnrWGhsC6pnurZ22H53F3LL+/ZxFLtPOmO1tmNWD2Vg7I262fxksbwaz/Quz3WC2fxksZWb7l8Fc0M5ZP5gdsCmNLRatcmbr7mAuaFcalZI1wzwEMXMBdfsms5RbUvl2YKb870vaCy327RRQ3xS21topoJ6dkuEYND4PDT2jHb9PMrtuwXOO3y/Sf6CZolqBeEqWh8bmrxTsMZwjli9FaCzPxlZD43l9jfF15ObogvUnrVtpvYt1QrBUMF7PRtZg4/XzCvPq9RXm7Q8X2mg/Gqwd7WNuRGvz5/Vmh7dvBvdn3j5tze3vp+w8fuZ7Qn0B0R2hfsKe8Zy1l1tcof7F1onpfonsvVQ+1WfR6c6q7PuzaZvs6y6yyT7y+JPpP5FN9K3uPDbqd72zxahPZjM76q+x5fyMEvTz3gjOAd5IA+N3csHZwruTC84rknn3daVvKT/fBuejjN8zBOexNT")
					MSCBWrite("vZhec43n96nWhk7irx/edLskKwtXBmliwT7m0+oLsEMln9iAjfu5mPRXe4Z4xy+CizR4TudMjkJ7DFJ3xfJ9nqQBn6suXW3LNPj/stvkv/Kpj0/0S7EewWW7qiNbIbwkZ2N5ocatfvRlfbYoXnb7XAd3nLG9HgKGaa9JnLRRczsI5Wt1Tw/YKPZEdFDO4c44Y26nuNvnKjQJ0QrcuXd6AuGbsDluoaGt1sigxb9jDP8j14h7vhKDh+zhWqnt16WACgfh3B0a1bb1+71JbbGv4ObLndpKjurrYfUwXujBc/KVNgD+j6gLWKp23ZpTbKCcnI5BKYo65+Qlv9xtbVT2j3M83UVvQO/f8DMetyolDgd1n3XY1UYN2a+qnA3JpUiqdJtLcxHv8A+9BsqA==:4D7D")
					If lTransfer
//						MSCBWrite("^FT650,1150^A0R,100^FH\^FDTRANSF. ENTRADA^FS")
						MSCBWrite("^FT650,600^A0R,100^FH\^FDTRANSF. ENTRADA^FS")
					Else
//						MSCBWrite("^FT650,1350^A0R,100^FH\^FDENTRADA^FS")					
						MSCBWrite("^FT650,1000^A0R,100^FH\^FDENTRADA^FS")					
					EndIf
		    		MSCBSAY(070,010, "FORNECEDOR : " + left(aImprime[nX][04], 37),"R","B","040,020")
		    		MSCBSAY(063,010, "DATA DE FABRICAÇÃO : " + 	aImprime[nX][05],"R","0","030,020")
		    		MSCBSAY(057,010, "CODIGO PRODUTO FORNECEDOR : " + 	aImprime[nX][07],"R","0","030,020")
		    		MSCBSAY(051,010, "CODIGO PRODUTO NA KOMFORT : ","R","0","030,020")
		    		MSCBSAY(051,050, aImprime[nX][01],"R","B","040,020")
					MSCBSAY(051,120, "DIMENSÃO : " + aImprime[nX][08],"R","0","030,020")
					MSCBSAY(048,120, "NF/SERIE/ITEM : " + Alltrim(aImprime[nX][09]) + "-" + Alltrim(aImprime[nX][10]) + "/" + Alltrim(aImprime[nX][11]),"R","0","030,020") //#RVC20180827.n
					cEnde := aImprime[nX][06]

         		Else
					MSCBWrite("^FO608,32^GFA,08960,08960,00028,:Z64:eJzt2bFu2zAQBuATFJQZjMjZPBRVH8FjB6Hqo/gR1LFAEAno0NfS4LEPoW4Funh0AUOsKNrUkdJ/tpUUSIBwKJB+rS0dj8cjQ/Q23sbzjYio1FofntnyznbASFXwWUg18yyZ/DZr5R5b+wAtPnyAluyTao6ltaqRlVWMjbA9UAStIPqCbDMJ5w0OY7qBFms8D8l0JtmY6XaW5ZRWyD5TUiN7IDxHhTAPr8Wk95PiIsVTslRraIkwf7GQEzRdXc7n53+wrtbVyMrZhuMiGRGuWV20K2ygKPeGc+llmVBb5Xmo5pk0R0Luzp+jep69jjm6dP7iamTub+J9aGyOdGjsH5eVZ96Ya3kdGItL2syzZO+Z6bPcz+rgmenP3Cep9ipz1TWC1oVae2ae8/gEiSa2bo6WHd9OVyWyUlcsaL51GZDvrjYToDoNjCjrtyVjas8t6qPyVx/twM32LyeLW262D3mqRZqb3VNPRsMC6Pdps1a+TVqwv5cNs6AvGIL2ZIu1/nVQWrdDhnrWGhsC6pnurZ22H53F3LL+/ZxFLtPOmO1tmNWD2Vg7I262fxksbwaz/Quz3WC2fxksZWb7l8Fc0M5ZP5gdsCmNLRatcmbr7mAuaFcalZI1wzwEMXMBdfsms5RbUvl2YKb870vaCy327RRQ3xS21topoJ6dkuEYND4PDT2jHb9PMrtuwXOO3y/Sf6CZolqBeEqWh8bmrxTsMZwjli9FaCzPxlZD43l9jfF15ObogvUnrVtpvYt1QrBUMF7PRtZg4/XzCvPq9RXm7Q8X2mg/Gqwd7WNuRGvz5/Vmh7dvBvdn3j5tze3vp+w8fuZ7Qn0B0R2hfsKe8Zy1l1tcof7F1onpfonsvVQ+1WfR6c6q7PuzaZvs6y6yyT7y+JPpP5FN9K3uPDbqd72zxahPZjM76q+x5fyMEvTz3gjOAd5IA+N3csHZwruTC84rknn3daVvKT/fBuejjN8zBOexNT")
					MSCBWrite("vZhec43n96nWhk7irx/edLskKwtXBmliwT7m0+oLsEMln9iAjfu5mPRXe4Z4xy+CizR4TudMjkJ7DFJ3xfJ9nqQBn6suXW3LNPj/stvkv/Kpj0/0S7EewWW7qiNbIbwkZ2N5ocatfvRlfbYoXnb7XAd3nLG9HgKGaa9JnLRRczsI5Wt1Tw/YKPZEdFDO4c44Y26nuNvnKjQJ0QrcuXd6AuGbsDluoaGt1sigxb9jDP8j14h7vhKDh+zhWqnt16WACgfh3B0a1bb1+71JbbGv4ObLndpKjurrYfUwXujBc/KVNgD+j6gLWKp23ZpTbKCcnI5BKYo65+Qlv9xtbVT2j3M83UVvQO/f8DMetyolDgd1n3XY1UYN2a+qnA3JpUiqdJtLcxHv8A+9BsqA==:4D7D")
					If lTransfer
//						MSCBWrite("^FT650,1200^A0R,100^FH\^FDTRANSF. SAIDA^FS")
						MSCBWrite("^FT650,600^A0R,100^FH\^FDTRANSF. SAIDA^FS")
					Else	
//						MSCBWrite("^FT650,1520^A0R,100^FH\^FDSAIDA^FS")
						MSCBWrite("^FT650,1000^A0R,100^FH\^FDSAIDA^FS")
					EndIf
         			MSCBSAY(70,010 , "CLIENTE : " + left(aImprime[nX][04], 37),"R","B","040,020")
         			MSCBSAY(62,010 , "NOTA FISCAL : " + aImprime[nX][08],"R","B","040,020")         			
         			MSCBSAY(62,120 , "DATA DE FABRICAÇÃO : " + aImprime[nX][07],"R","0","030,025")
         			MSCBSAY(55,010 , "ENDEREÇO DE ENTREGA : " + left(aImprime[nX][05],87),"R","0","030,025")
         			MSCBSAY(49,010 , "CODIGO DO PRODUTO : ","R","0","030,025")			
         			MSCBSAY(48,045 , aImprime[nX][01],"R","B","040,020")			
//         			MSCBSAY(49,120 , "DATA DE FABRICAÇÃO : " + 	aImprime[nX][07],"R","0","030,025")
         			MSCBSAY(49,120 , substr(aImprime[nX][05],88),"R","0","030,025")

					cEnde := aImprime[nX][09]
         		Endif

	    		MSCBSAY( 040,010, left(aImprime[nX][02],50)  ,"R","B","040,020")
	    		MSCBSAY( 032,010, substr(aImprime[nX][02],51),"R","B","040,020")

				aEnde   := retEnde( cEnde )
				nInicio := 90	// 100
				nAltura := 30	//  20
				for nW := 1 to len( aEnde )
//					MSCBSAY(nInicio - nW * nAltura,200 ,aEnde[nW],"R","0","190,190")
					MSCBSAY(nInicio - nW * nAltura,160 ,aEnde[nW],"R","0","310,310")
				next

				MSCBSAYBAR(12,25,cCodBar,"R","MB07",15,.F.,.T.,.F.,,4,3)
				
									   			
	   			MSCBEND()	   		
	        
			EndIf
	
		Next nX
		MSCBCLOSEPRINTER()        
	Else
		MsgInfo("Sem dados para impressão, verifique os parâmetros ou se os empenhos já foram baixados")
	EndIf
	RestArea(aAreaSB1)	
Return Nil


//---------------------------------
Static Function retEnde( cEnde )
Local aEnde
Local nI
Local nIt

	cEnde := alltrim( cEnde )
	if cEnde == "SEM LOCALIZACAO"
//		return {"L","O","C","A","L"}
		return {"L","O","C"}
	endif

	aEnde := strTokArr( cEnde, "-" )

	if len( aEnde ) >= 3 	// == 3			// se tiver traços (hífen) vai quebrar por eles
//		aSize( aEnde, 5 )
//		aEnde[4] := ""
//		aEnde[5] := ""

		aSize( aEnde, 3 )

	else
		aEnde := {}				// não tem traços (hífen), quebra de 3 em 3
//		cEnde := strTokArr( cEnde, "-", "") + Space(15)	//#RVC20180613.o
//		for nI := 1 to 5
		for nI := 1 to 3
//			aadd( aEnde, substr( cEnde, nI * 3 - 2, 3 ) )	//#RVC20180613.o
			aadd(aEnde, substr(cEnde, nI, 1))				//#RVC20180613.n
		next
	endif
/*
	if empty(aEnde[5])		// se o último elemento for vazio
		aIns(aEnde, 1)		// empurro todos para dar espaço em cima
		aEnde[1] := ""
	endif
*/
return aEnde
