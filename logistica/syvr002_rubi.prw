#Include "Protheus.ch"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SYVR002  บAutor  ณPedro H. Oliveira   บ Data ณ  10/21/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Etiqueta de Codigo de Barras de Produto                    บฑฑ
ฑฑบMauro P.  ณ Adaptado para imprimir Painel, Vitrine e acumular produtos บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SYVR002D()

Local aParam  		:= {}
Local aRet     		:= {}
Local aMascGrd      := Separa(GetMv("MV_MASCGRD"),",")

Local cMascara 		:= GetMv("MV_MASCGRD",,'9,2,2')
Local cTamanho      := ""
Local cCor 			:= ""
Local cDescCor 		:= ""
Local cDescCol 		:= ""
Local cMarca   		:= ""
Local cCat1	 		:= ""
Local cCat2	 		:= ""
Local cCat3	 		:= ""
Local cCat4	 		:= ""
Local cCat5	 		:= ""
Local nPrecoVen		:= 0
Private cPerg			:= Padr("RUBIETIQ01",10)
Private lFiltro   	:= MsgNoYes("Filtrar por documento de entrada ?","Filtro atual: Produto")
Private nTamRef 	:= Val(Substr(cMascara,1,2))
Private nTamLin 	:= Val(Substr(cMascara,4,2))
Private nTamCol 	:= Val(Substr(cMascara,7,2))
Private aProdutos	:= {}
Private nTamProd	:= 0
Private aEtiquetas  := {}
Private nFiltro		:= 0
Private nCod		:= Val(aMascGrd[1])+Val(aMascGrd[2])+Val(aMascGrd[3]) +Val(aMascGrd[4])
Private nCod1		:= Val(aMascGrd[1])
Private nCod2		:= Val(aMascGrd[2])
Private nCod3		:= Val(aMascGrd[3])
Private nCod4		:= Val(aMascGrd[4])


AjustaSx1(@cPerg)
If Pergunte(cPerg, .T.)
	
	If !lFiltro
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+MV_PAR01,.T.)
		ProcRegua(RecCount())
		
		While !Eof() .And. (SB1->(B1_FILIAL+B1_COD) <= xFilial("SB1")+MV_PAR02)
			
			
			cCor := ""
			cDescCor := ""
			cMarca   := ""
			cCat1	 := ""
			cCat2	 := ""
			cCat3	 := ""
			cCat4	 := ""
			cCat5	 := ""
			cTamanho := ""
			cDescCol := ""
			
			SB4->( DbSetOrder(1) )
			IF SB4->( Dbseek( xFilial("SB4") + Left(SB1->B1_COD,nTamRef) ) )
				cMarca:= AllTrim(Posicione("AY2", 1, xFilial("AY2") + SB4->B4_01CODMA, "AY2_DESCR")) // B4_XMARCA == B4_01CODMA
				cCat1	 := Alltrim(Posicione("AY0", 1, xFilial("AY0") + SB4->B4_01CAT1, "AY0_DESC"))//B4_01CAT1 == B4_CAT1
				cCat2	 := Alltrim(Posicione("AY0", 1, xFilial("AY0") + SB4->B4_01CAT2, "AY0_DESC"))//B4_01CAT2 == B4_CAT2
				cCat3	 := Alltrim(Posicione("AY0", 1, xFilial("AY0") + SB4->B4_01CAT3, "AY0_DESC"))//B4_01CAT3 == B4_CAT3
				cCat4	 := Alltrim(Posicione("AY0", 1, xFilial("AY0") + SB4->B4_01CAT4, "AY0_DESC"))//B4_01CAT4 == B4_CAT4
				cCat5	 := SB4->B4_01CAT3
				
				cCor := Substr( SB1->B1_COD , nTamRef+1 , nTamLin )
				
				SBV->(DbSetOrder(1))
				IF SBV->( DbSeek( xFilial("SBV") + SB4->B4_LINHA + cCor ) )
					cDescCor := Left(SBV->BV_DESCRI,14)+' '+Alltrim(SBV->BV_CHAVE)
				Endif
				
				cTamanho:=SubStr(ALLTRIM(SB1->B1_COD),Val(aMascGrd[1])+ Val(aMascGrd[2])+1 , Val(aMascGrd[3])  )
				IF SBV->( DbSeek( xFilial("SBV") + SB4->B4_COLUNA + cTamanho ) )
					cDescCol := Alltrim(SBV->BV_DESCRI)
				Endif
			Endif
			
			nPrecoVen := 0
			SB0->( DbSetOrder(1) )
			IF SB0->( DbSeek( xFilial('SB0') + SB1->B1_COD ) )
				nPrecoVen := IIF(SB0->B0_PRV1 == 0,SB1->B1_PRV1,SB0->B0_PRV1)
				//nPrecoVen := SB0->B0_PRV1
			EndIF
			
			aAdd(aProdutos,{ SB1->B1_COD , SB1->B1_DESC , cCor+"-"+ cDescCor , cDescCol , MV_PAR03 } )
			
			aAdd(aEtiquetas,{	SB4->B4_COD,;//SB1->B1_COD ,;                //Codigo  1
								SB4->B4_DESC ,;               //Desc. Produto  2
								Alltrim(cDescCor) ,;                   // Cor Produto   3
								Alltrim(cDescCol),; //Tamanho 4
								Alltrim(SB1->B1_CODBAR),;    // Cod. Barras              5
								'R$ ' + Alltrim(Transform(nPrecoVen,PesqPict("SB1","B1_PRV1"))),;	//Pre็o de venda 6
								cMarca,;                                             // Marca        7
								RIGHT(DTOS(ddatabase),2)+SUBSTR(DTOS(ddatabase),5 ,2)+SUBSTR(DTOS(ddatabase),3,2),; // Categoria 08
								Padr(cCat3,6)+"/"+Padr(cCat2,6),;//                                                                              09
								cCat4,; //                                                                                       10
								'',;     // CODIGO DA COR                                                     11
								Alltrim(SB1->B1_01CODFO),;//cCat5,;  //referencia da categoria 3                                                             12
								Alltrim(SB1->B1_01DREF),; //SB4->B4_X_REFER REFERENCIA                                                                  13
								Alltrim(SM0->M0_NOME),;// NOME EMP                                                               14
								MV_PAR03 } ) // Quantidade de Etiquetas.                                                         15
								//08,4,2,2
			dbSelectArea("SB1")
			dbSkip()
			
		EndDo
	Else
		
		dbSelectArea("SD1")
		dbSetOrder(1)
		//dbSeek(xFilial("SD1")+Alltrim(MV_PAR01),.T.)
		dbSeek(xFilial("SD1")+MV_PAR01+MV_PAR02,.T.)
		
		SB1->(DbSetOrder(1))
		
		ProcRegua(RecCount())
		
		While !Eof() .And. (SD1->(D1_FILIAL+D1_DOC+D1_SERIE) <= xFilial("SD1")+MV_PAR03+MV_PAR04 )
			
			IF SB1->(DbSeek(xFilial("SB1")+SD1->D1_COD )) .And. ( SD1->D1_SERIE <> (Left(GetMv("MV_GNPSERS"),1) + cFilAnt) )
				
				cCor 		:= ""
				cDescCor	:= ""
				cMarca   	:= ""
				cCat1	 	:= ""
				cCat2	 	:= ""
				cCat3	 	:= ""
				cCat4	 	:= ""
				cCat5	 	:= ""
				cTamanho 	:= ""
				cDescCol 	:= ""
				
				SB4->( DbSetOrder(1) )
				IF SB4->( Dbseek( xFilial("SB4") + Left(SB1->B1_COD,nTamRef) ) )
					cMarca:= AllTrim(Posicione("AY2", 1, xFilial("AY2") + SB4->B4_01CODMA, "AY2_DESCR")) // B4_XMARCA == B4_01CODMA
					cCat1	 := Alltrim(Posicione("AY0", 1, xFilial("AY0") + SB4->B4_01CAT1, "AY0_DESC"))//B4_01CAT1 == B4_CAT1
					cCat2	 := Alltrim(Posicione("AY0", 1, xFilial("AY0") + SB4->B4_01CAT2, "AY0_DESC"))//B4_01CAT2 == B4_CAT2
					cCat3	 := Alltrim(Posicione("AY0", 1, xFilial("AY0") + SB4->B4_01CAT3, "AY0_DESC"))//B4_01CAT3 == B4_CAT3
					cCat4	 := Alltrim(Posicione("AY0", 1, xFilial("AY0") + SB4->B4_01CAT4, "AY0_DESC"))//B4_01CAT4 == B4_CAT4
					cCat5	 := SB4->B4_01CAT3//Alltrim(Posicione("AY0", 1, xFilial("AY0") + SB4->B4_CAT5, "AY0_DESC")) //B4_01CAT3 == B4_CAT3
					
					cCor := Substr( SB1->B1_COD , nTamRef+1 , nTamLin )
					
					SBV->(DbSetOrder(1))
					IF SBV->( DbSeek( xFilial("SBV") + SB4->B4_LINHA + cCor ) )
						cDescCor := Left(SBV->BV_DESCRI,14)+' '+Alltrim(SBV->BV_CHAVE)
					Endif
					
					cTamanho:=SubStr(ALLTRIM(SB1->B1_COD),Val(aMascGrd[1])+ Val(aMascGrd[2])+1 , Val(aMascGrd[3])  )
					IF SBV->( DbSeek( xFilial("SBV") + SB4->B4_COLUNA + cTamanho ) )
						cDescCol := Alltrim(SBV->BV_DESCRI)
					Endif
					
				Endif
				
				nPrecoVen := 0
				SB0->( DbSetOrder(1) )
				IF SB0->( DbSeek( xFilial('SB0') + SB1->B1_COD ) )
					nPrecoVen := SB0->B0_PRV1
				EndIF
				
				aAdd(aProdutos,{ SB1->B1_COD , SB1->B1_DESC , cCor+"-"+ cDescCor , cDescCol , SD1->D1_QUANT } )
				
				aAdd(aEtiquetas,{	SB4->B4_COD ,;                //Codigo  1
				SB4->B4_DESC ,;               //Desc. Produto  2
				Alltrim(cDescCor) ,;                   // Cor Produto   3
				Alltrim(cDescCol),; //Tamanho 4
				Alltrim(SB1->B1_CODBAR),;    // Cod. Barras              5
				'R$ ' + Alltrim(Transform(nPrecoVen,PesqPict("SB1","B1_PRV1"))),;	//Pre็o de venda 6
				cMarca,;                                             // Marca        7
				RIGHT(DTOS(ddatabase),2)+SUBSTR(DTOS(ddatabase),5 ,2)+SUBSTR(DTOS(ddatabase),3,2),; // Categoria 08
				Padr(cCat3,6)+"/"+Padr(cCat2,6),;//                                                                              09
				cCat4,; //                                                                                       10
				'',;      // CODIGO DA COR                                                            11
				Alltrim(SB1->B1_01CODFO),;//cCat5,;  //referencia da categoria 3                                                             12
				Alltrim(SB1->B1_01DREF),; //SB4->B4_X_REFER REFERENCIA                                                                  13
				Alltrim(SM0->M0_NOME),;// NOME EMP                                                               14
				SD1->D1_QUANT } ) // Quantidade de Etiquetas.                                                    15
				
			EndIf
			
			dbSelectArea("SD1")
			dbSkip()
		EndDo
	EndIf
	
	
	IF Len(aProdutos) > 0
		If cPerg $ "RUBIETIQ02"
			IF MV_PAR06 == 1//aRet[08] == 1
				IF EditProd(@aProdutos) == 2
					Return
				Endif
			Endif
		Else
			IF MV_PAR04 == 1//aRet[08] == 1
				IF EditProd(@aProdutos) == 2
					Return
				Endif
			Endif
		EndIf
		U_VR002IMP()
		
	Else
		MsgInfo("Nใo hแ dados para impressใo das etiquetas, verifique o parโmetro informado.",,"INFO")
	Endif
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVR002IMP  บAutor  ณPedro H. Oliveira   บ Data ณ  10/21/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para a impressao da etiqueta de codigo de barras.    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function VR002IMP()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImpressora Argox - Etiquetaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Processa({||AltArray(),PrintEtq04(aEtiquetas)},"Imprimindo Etiquetas...")


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAltArray  บAutor  ณPedro H. Oliveira   บData  ณ 29/09/2011  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Altera a quantidade de aEtiquetas para igualar ao aProdutosบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Bini\                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AltArray()


For nX:=1 To Len(aProdutos)
	
	aEtiquetas[nX,15]:= aProdutos[nX,5]
	
Next nX


Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPrintEtq04บAutor  ณPedro H. Oliveira   บData  ณ 29/09/2011  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera imagem das etiquetas e envia a impressora p/ impressใoบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Bini\                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PrintEtq04(aDados)

Local aArea	  := GetArea()
Local aColuna := { { 87, 84,64 ,54 } , { 48.5, 45.5 , 26.5 ,01 } }
Local aLinha  := {57,50,47,44,41,38,31.5 ,15.5 ,12.5, 9.5 ,06.5,03.5}
Local nEtq    := 0
Local cMsg	  := "Manter esta etiqueta em"
Local cMsg2	  := "  caso de troca"
Local aMasc   := Separa(GetMv("MV_MASCGRD"),",")
Local nCor    := Val(aMasc[1])+Val(aMasc[2])+1
Local cPorta  := GetMv("RB_LJRUBI1",,'LPT1')
Local lImpPrc := .F.
Local nCont1:=0
Local nCont2:=Len(aDados)
Local lRet := .F. 

If cPerg $ "RUBIETIQ02"
	lImpPrc:= IIF( MV_PAR07 == 1, .T. , .F. )//MsgNoYes("Imprimir pre็o ?","INFO")
Else
	lImpPrc:= IIF( MV_PAR05 == 1, .T. , .F. )//MsgNoYes("Imprimir pre็o ?","INFO")
EndIF

MSCBPRINTER("TLP 2844",cPorta, ,,.F.)

MSCBCHKStatus(.F.)

For nX := 1 To Len(aDados)
	
	For nY := 1 To aDados[nX,15]
		//Quantidade de etiquetas impressa por vez.
		nEtq += 1
		nCont1:= aDados[nX,15]
		If ( nEtq = 1)
			MSCBBEGIN (1,3)
		EndIf
		
		//ARRAY ESTRUTURA                 POSICAO
		//Codigo          					01
		//Desc. Produto                     02
		// Cor Produto                      03
		//Tamanho                           04
		// Cod. Barras                      05
		//Pre็o de venda                    06
		// Marca                            07
		// DATA                             08
		// CATEGOTIA 3/2                    09
		//  CATEGORIA 4                     10
		// CODIGO DA COR                    11
		//COD. referencia da categoria 3    12
		// REFERENCIA                       13
		// NOME EMP                         14
		// Quantidade de Etiquetas.         15
		
		MscbSay   (aColuna[nEtq,1],aLinha[1]  , ''      ,"I","2","1") // NOME EMPRESA
		
		MscbSay   (aColuna[nEtq,3],aLinha[1], aDados[nX,01],"I","2","1")// COD PRODUTO PAI
		MscbSay   (aColuna[nEtq,3],aLinha[1]-2, Alltrim(aDados[nX,08]) ,"I","2","1")// DATA
		
		MscbSay   (aColuna[nEtq,1],aLinha[1]-3  , PADR(Alltrim(aDados[nX,13]),10) ,"I","3","1") // DESCRICAO DA REFERENCIA DO PRODUTO
		MscbSay   (aColuna[nEtq,1],aLinha[2]    , PADR(Alltrim(aDados[nX,12]),10) ,"I","3","1") 
		           //B1_01CODFO
		MscbSay   (aColuna[nEtq,1],aLinha[3]  , SubStr(Alltrim(aDados[nX,02]),1,20) ,"I","3","1") // DESC. PROD PAI
		MscbSay   (aColuna[nEtq,1],aLinha[4]  , SubStr(Alltrim(aDados[nX,02]),21,20) ,"I","3","1") // DESC. PROD PAI CONTINUACAO
		
		MscbSay   (aColuna[nEtq,1],aLinha[5]  , Padr(Alltrim(aDados[nX,03]),12) ,"I","3","1") // DESCRICAO DA COR
		MscbSay   (aColuna[nEtq,3],aLinha[5]  , 'TAM '+Alltrim(aDados[nX,04]) ,"I","4","1") // TAMANHO
		
		MscbSay   (aColuna[nEtq,1],aLinha[6]  , cMsg                   ,"I","2","1") // MENSAGEM TROCA
		MscbSay   (aColuna[nEtq,1],aLinha[6]-3, cMsg2                  ,"I","2","1") // MENSAGEM TROCA
		
		MSCBSAYBAR(aColuna[nEtq,2],aLinha[7]  , AllTrim(aDados[nX,05])  ,"I","MB04",13,.F.,.T.,.F.,,2,2,.F.,.F.,"1",.T.) // COD BARRAS		
		
		MscbSay   (aColuna[nEtq,1],aLinha[8]  , PADR(Alltrim(aDados[nX,12]),10) ,"I","3","1") // NRO REFERENCIA DA CATEGORIA 3 SECAO
		MscbSay   (aColuna[nEtq,1],aLinha[9]  , SubStr(Alltrim(aDados[nX,02]),1,20) ,"I","3","1") // DESC. PROD PAI
		MscbSay   (aColuna[nEtq,1],aLinha[10]  , SubStr(Alltrim(aDados[nX,02]),21,20) ,"I","3","1") // DESC. PROD PAI
		
		MscbSay   (aColuna[nEtq,1],aLinha[11]  , Padr(Alltrim(aDados[nX,03]),12) ,"I","3","1") // DESCRICAO DA COR
		MscbSay   (aColuna[nEtq,3],aLinha[11]  , 'TAM '+Alltrim(aDados[nX,04]) ,"I","4","1") // TAMANHO
		     
		If lImpPrc
			MscbSay   (aColuna[nEtq,1],aLinha[12], Alltrim(aDados[nX,06]) ,"I","3","1") // PRECO
		EndIf
		
		lRet:= .F.
		If ( nEtq = 2)
			MSCBEND()
			nEtq := 0
			lRet:= .T.
		EndIf
	 
		
	Next nY
	
Next nX

If !lRet //nEtq <> 0
	MSCBEND()
EndIf	
MSCBCLOSEPRINTER()

RestArea(aArea)

Return()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ EditProd บAutor  ณ Pedro H. Oliveira  บ Data ณ  04/24/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Exibe tela para selecao dos produtos e acumulo das etique- บฑฑ
ฑฑบ          ณ tas                                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function EditProd( aProdutos )

Local aSize    	:= MsAdvSize()
Local nRet		:= 2
Local w

Private cCodProd := Space(15)

DEFINE FONT oMaFnt   NAME "Arial" SIZE 0,-12 BOLD
DEFINE FONT oMaFnt03 NAME "Arial" SIZE 0,-12

DEFINE MSDIALOG oDlg FROM 0,0 TO aSize[6],aSize[5] TITLE "Sele็ใo dos produtos" Of oMainWnd PIXEL

oPanel:=TPanel():New(0, 0, "", oDlg, NIL, .F., .F., NIL, NIL, 0,18, .F., .T. )
oPanel:Align:= CONTROL_ALIGN_TOP
oPanel:nClrPane:=14803406

@ 005,005  SAY "Produto" Of oPanel FONT oMaFnt COLOR CLR_BLACK Pixel SIZE 50,12
@ 003,055  MSGET cCodProd Valid AtuProd(@cCodProd) PICTURE "@!" OF oPanel FONT oMaFnt COLOR CLR_BLACK Pixel SIZE 180,10

oProd:= TWBrowse():New(0,0,0,0,,{"C๓digo","Descri็ใo","Cor","Tamanho","Qtde"},{},oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oProd:Align := CONTROL_ALIGN_ALLCLIENT
oProd:SetArray(aProdutos)
oProd:bLDblClick := {|| DigiQtd(aProdutos, oProd) }
oProd:nScrollType  := 1
oProd:oFont := oMaFnt03
oProd:bLine := {|| { 	aProdutos[oProd:nAt,1],;
aProdutos[oProd:nAt,2],;
aProdutos[oProd:nAt,3],;
aProdutos[oProd:nAt,4],;
TransForm(aProdutos[oProd:nAt,5],"@E 999") }}

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg, { || nRet := 1, oDlg:End() } , { || nRet := 2, oDlg:End() } ,,)

aAux := {}
For w := 1 To Len(aProdutos)
	IF aProdutos[w,5] > 0
		aAdd( aAux, { aProdutos[w,1] , aProdutos[w,2] , aProdutos[w,3] , aProdutos[w,4] , aProdutos[w,5] } )
	Endif
Next w
aProdutos := aClone(aAux)

Return( nRet )



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAtuProd() บAutor  ณ Pedro H. Oliveira  บ Data ณ  04/24/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao de validacao do codigo do produto                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function AtuProd( cCodProd )

Local lRet := .T.

IF !Empty(cCodProd)
	
	lRet := LjSB1SLK( @cCodProd, 1 )
	
	If lRet
		nPos := aScan( aProdutos , { |x| AllTrim(x[1]) == AllTrim(cCodProd) } )
		If nPos > 1
			cCodProd := Space(15)
			oProd:nAt := nPos
			oProd:Refresh()
		Else
			lRet := .F.
		Endif
	Endif
	
	If !lRet
		MsgInfo("Produto nใo localizado",,"INFO")
	Endif
	
Endif

Return( lRet )


Static Function DigiQtd(aProdutos, oProd)

lEditCell(@aProdutos, oProd, "@E 999", 5)
oProd:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AjustaSx1 บAutor ณPedro H. Oliveira   บData ณ 10/04/09     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria parametro de Perguntas								  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MABRUK                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AjustaSx1(cPerg)

IF !lFiltro
	PutSx1( cPerg, "01", "Produto De ?"		  	, "Produto De ?"			, "Produto De ?"		, "mv_ch1", "C", nCod, 0, 0, "G", "","SB1", "", "", "mv_par01",	  ,	    ,	  ,,	 ,	   , 	 ,,,,,,,,,,{"Codigo do Produto Inicial."			  , "", ""},{},{} )
	PutSx1( cPerg, "02", "Produto At้?"		  	, "Produto At้?"			, "Produto At้?"		, "mv_ch2", "C", nCod, 0, 0, "G", "","SB1", "", "", "mv_par02",	  ,	    ,	  ,,	 ,	   ,	 ,,,,,,,,,,{"Codigo do Produto Final."  			  , "", ""},{},{} )
	PutSx1( cPerg, "03", "Quantidade ?"		  	, "Quantidade ?"			, "Quantidade ?"		, "mv_ch3", "N", 04, 0, 0, "G", "","   ", "", "", "mv_par03",	  ,	    ,	  ,,	 ,	   ,	 ,,,,,,,,,,{"Quantidade de Etiquetas por Produto."	  , "", ""},{},{} )
	PutSx1( cPerg, "04", "Exibir Produtos?"	  	, "Exibir Produtos?"		, "Exibir Produtos?"	, "mv_ch4", "N", 03, 1, 0, "C", "","   ", "", "", "mv_par04","Sim","Sim","Sim",,"Nใo","Nใo","Nใo",,,,,,,,,,{"Exibi Grade com Produtos Selecionados."  , "", ""},{},{} )
	PutSx1( cPerg, "05", "Com pre็o ?"	      	, "Com pre็o ?"   			, "Com pre็o ?"         , "mv_ch5", "N", 03, 1, 0, "C", "","   ", "", "", "","Sim","Sim","Sim",,"Nใo","Nใo","Nใo",,,,,,,,,,{"Imprimir etiquetas com pre็o ?"          , "", ""},{},{} )
Else
	cPerg:="RUBIETIQ02"
	PutSx1( cPerg, "01", "Documento De ?"		, "Documento De ?"			,"Documento De ?"		, "mv_ch1", "C", 9, 0, 0, "G", "","SF1ETI", "", "", "mv_par01",	  ,	    ,	  ,,	 ,	   , 	 ,,,,,,,,,,{"Codigo do documento de entrada Inicial."			  , "", ""},{},{} )
	PutSx1( cPerg, "02", "Serie de     ?"		, "Serie de     ?"			,"Serie de     ?"		, "mv_ch2", "C", 3, 0, 0, "G", "","      ", "", "", "mv_par02",	  ,	    ,	  ,,	 ,	   , 	 ,,,,,,,,,,{"Serie do documento de entrada inicial."			  , "", ""},{},{} )
	PutSx1( cPerg, "03", "Documento At้?"   	, "Documento At้?"			, "Documento At้?"		, "mv_ch3", "C", 9, 0, 0, "G", "","SF1ETI", "", "", "mv_par03",	  ,	    ,	  ,,	 ,	   ,	 ,,,,,,,,,,{"Codigo do documento de entrada Final."  			  , "", ""},{},{} )
	PutSx1( cPerg, "04", "Serie ate    ?"		, "Serie ate    ?"			,"Serie ate    ?"		, "mv_ch4", "C", 3, 0, 0, "G", "","      ", "", "", "mv_par04",	  ,	    ,	  ,,	 ,	   , 	 ,,,,,,,,,,{"Serie do documento de entrada final."			  , "", ""},{},{} )
	PutSx1( cPerg, "05", "Quantidade ?"			, "Quantidade ?"			, "Quantidade ?"		, "mv_ch5", "N", 04, 0, 0, "G", "","     ", "", "", "mv_par05",	  ,	    ,	  ,,	 ,	   ,	 ,,,,,,,,,,{"Quantidade de Etiquetas por Produto."	  , "", ""},{},{} )
	PutSx1( cPerg, "06", "Exibir Produtos?"	  	, "Exibir Produtos?"		, "Exibir Produtos?"	, "mv_ch6", "N", 03, 1, 0, "C", "","     ", "", "", "mv_par06","Sim","Sim","Sim",,"Nใo","Nใo","Nใo",,,,,,,,,,{"Exibi Grade com Produtos Selecionados."  , "", ""},{},{} )
	PutSx1( cPerg, "07", "Com pre็o ?"	      	, "Com pre็o ?"   			, "Com pre็o ?"         , "mv_ch7", "N", 03, 1, 0, "C", "","     ", "", "", "mv_par07","Sim","Sim","Sim",,"Nใo","Nใo","Nใo",,,,,,,,,,{"Imprimir etiquetas com pre็o ?"          , "", ""},{},{} )
EndIF

Return Nil
