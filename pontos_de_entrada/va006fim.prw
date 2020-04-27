/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ VA006Fim ³ Autor ³ Gustavo Kuhl    ³ Data ³ 05/12/2016     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de Entrada executado apos a Inclusao do SB4          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION VA006Fim()

Local cTabela := SB4->B4_COLUNA
Local clinha := SB4->B4_LINHA
Local cChave := ''
Local cPesoB := ''
Local cPesoL := ''
Local cQE := SB4->B4_01VOLUM
Local cComp := 0
Local := 0
Local := 0
Local B1CodBar := ''
Local B1CodBar1 := ''
Local cCodBar := ''
Local CCodGs1 := '78998552'
Local Cdescri := alltrim(B4_DESC) 
Local Ccdescri := ''
Local Cldescri := ''
Local cProduto   := '' 

/*Private cAliasTRB	:= GETNEXTALIAS()	 

BeginSql Alias cAliasTRB                        
 
SELECT MAX(DA1_ITEM)+1 AS DA1_ITEM 
FROM %TABle:DA1% A
WHERE A. %notDel%
AND DA1_CODTAB ='001'
ENDSQL 
*/

DbSelectArea("SB1")
DbSetOrder(11)


If SB1->(DbSeek(xFilial("SB1")+SB4->B4_COD))
	
	
	While SB1->(!Eof()) .AND. SB1->B1_01PRODP == SB4->B4_COD
		
		cChave := ''
	 	clin := ''
		cChave := SB1->B1_01CLGRD
    	clin := SB1->B1_01LNGRD
		cPesoB := 0
		cPesoL := 0
		B1CodBar := ''
		cB1codbar := SB1->B1_CODBAR
	    Cdescref := '' 
     	Cdescref :=	alltrim(SB1->B1_01DREF) 
		B1CodBar1 := ''
		cCodBar := ''
		cCodBar := GetMv("MV_XSEQCOD") // GetMv("MV_XSEQCODBAR")
		cProduto   := SB1->B1_COD
		
		
		DbSelectArea("SBV")
		DbSetOrder(1)
		If SBV->(DbSeek(xFilial("SBV")+cTabela+cChave))
			cPesoB := SBV->BV_01PBGRD
			cPesoL := SBV->BV_01PBGRD
			Ccdescri := alltrim(SBV->BV_DESCRI)
		endif
     	If SBV->(DbSeek(xFilial("SBV")+clinha+clin))
  			Cldescri := alltrim(SBV->BV_DESCRI)
		endif
		 
			RecLock("SB1",.F.) // .F. = ALTERA
			SB1->B1_PESO   :=  cPesoL
			SB1->B1_PESBRU :=  cPesoB
			SB1->B1_DESC :=   Cdescri + " " + Ccdescri + " " + Cldescri + " " + Cdescref 
			//SB1->B1_MSBLQL := '1' // Produto Bloqueado ate execucao do Schedule #Ellen
			MsUnlock()
	 
 
		/*
	  	IF SUBSTR(cB1codbar,1,8) <> '78998552'
 		B1CodBar :=   CCodGs1 + cCodBar
 		B1CodBar1 := trim(B1CodBar)+eandigito(trim(B1CodBar))
			 
	   			RecLock("SB1",.F.) // .F. = ALTERA
	  			SB1->B1_CODBAR :=  B1CodBar1
 			MsUnlock()
		 
			
			
	   		PutMv ("MV_XSEQCOD",SOMA1(cCodBar))
	  	ENDIF*/
		U_KMESTX02(SB1->B1_CODBAR)
		
		cChave := ''
		cChave := SB1->B1_01CLGRD
		cComp := 0
		cLarg := 0
		caltu := 0
		
		DbSelectArea("SBV")
		DbSetOrder(1)
		If SBV->(DbSeek(xFilial("SBV")+cTabela+cChave))
			cComp := SBV->BV_01CGRD
			cLarg := SBV->BV_01LGRD
			caltu := SBV->BV_01AGRD
		endif
		 
		//INSERE PRODUTOS NA TABELA DE COMPLEMENTO DE PRODUTO - SB5
		DbSelectArea("SB5")
		DbSetOrder(1)

		SET DELETED OFF //#AFD20180529.n		

		If SB5->(DbSeek(xFilial("SB5")+SB1->B1_COD))
			RecLock("SB5",.F.)// .F. = ALTERA

			DBRecall() //#AFD20180529.n

			SB5->B5_COMPRLC :=  cComp
			SB5->B5_LARGLC :=  cLarg
			SB5->B5_ALTURLC :=  caltu
			SB5->B5_QE1 := cQE
	        SB5->B5_FATARMA := SB4->B4_FATARMA 
 	        SB5->B5_EMPMAX := SB4->B4_EMPMAX
 	        SB5->B5_ROTACAO := SB4->B4_ROTACAO 
        	SB5->B5_EMB1 := SB1->B1_UM    

			MsUnlock()
		else
			RecLock("SB5",.T.) // .T. = INCLUI
			SB5->B5_FILIAL  :=  xFilial("SB1")
			SB5->B5_COD     :=  SB1->B1_COD
			SB5->B5_CEME    := SB1->B1_DESC
			SB5->B5_COMPRLC :=  cComp
			SB5->B5_LARGLC  :=  cLarg
			SB5->B5_ALTURLC :=  caltu
			SB5->B5_QE1 := cQE 
            SB5->B5_FATARMA := SB4->B4_FATARMA 
 	        SB5->B5_EMPMAX := SB4->B4_EMPMAX
 	        SB5->B5_ROTACAO := SB4->B4_ROTACAO 
        	SB5->B5_EMB1 := SB1->B1_UM  
	
			MsUnlock()
		EndIf
		
		SET DELETED ON //#AFD20180529.n

		GRAVASBZ(cProduto) 
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ GRAVA AS INFORMACOES DO PRODUTO NA TABELA SB2 E SB9 UTILIZANDO O LOCAL PADRAO DO PRODUTO - LUIZ EDUARDO F.C. - 27.11.2017 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//GRAVAINF(cProduto) --> Ficou definido que nao serah executado 02.04.2018 #Ellen

/*		//INSERE PRODUTOS NA TABELA DE PREÇO PADRÃO - DA1     
 

 
 
Private Xitem :=  (cAliasTRB)->DA1_ITEM  
 
  DbSelectArea("DA1")
 DbSetOrder(2)  
	    	 	
				If DbSeek(xFilial("DA1")+SB1->B1_COD)	  
				
			     	RecLock("DA1",.F.)   
                	DA1->DA1_PRCVEN  :=SB1->B1_PRV1
                	DA1->DA1_DATVIG  :=ddatabase
			      	MsUnlock()   
			        else 
				  	RecLock("DA1",.t.)
				  	DA1->DA1_FILIAL := xFilial("DA1") 
				  	DA1->DA1_ITEM  :=STRZERO(Xitem,4)
                    DA1->DA1_CODTAB  := "001"
			     	DA1->DA1_CODPRO  :=SB1->B1_COD
			     	DA1->DA1_PRCVEN  :=SB1->B1_PRV1
			     	DA1->DA1_ATIVO  :=  "1"
			     	DA1->DA1_TPOPER := "4"
			     	DA1->DA1_MOEDA := 1
			     	DA1->DA1_DATVIG  :=ddatabase
                    MsUnlock()   
			      	Xitem++
	             ENDIF */
 		

		SB5->(DbSkip())
		SB1->(DbSkip())

		
	ENDDO
ENDIF 



 
Return .t.

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GRAVASBZ  ºAutor  ³Alfa Consultoria    º Data ³  20/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao paraGravar SBZ.                                      º±±
±±º          ³Grava somente em uma loja. Schedule para demais lojas       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GRAVASBZ(cProduto)

Local aAreaAtu 	:= GetArea()
Local aAreaSB1 	:= SB1->(GetArea())
Local aAreaSM0 	:= SM0->(GetArea())
Local aLojas 	:= {}
Local cFilAtu	:= cFilAnt
Local nTamFil	:= Len(cFilAnt)
Local cGrupo	:= GetMv("KH_GRPPROD",,"2001|2002") //Grupo de Produtos que nao deverao cadastrar na tabela SBZ
Local nX 

SB1->(DbSetOrder(1))
SB1->(DbSeek(xFilial("SB1") + AvKey(cProduto,"B1_COD") ))

//cFilAnt := PadR(aLojas[nX],nTamFil)
 
DbSelectArea("SBZ")
DbSetOrder(1)

SET DELETED OFF //#AFD20180529.n		

IF SBZ->(!DbSeek(cFilAnt+cProduto))  
	RecLock("SBZ",.T.) // .T. = INCLUI
	SBZ->BZ_FILIAL  := cFilAnt
	SBZ->BZ_COD     := cProduto
	SBZ->BZ_LOCPAD  := ALLTRIM(SUPERGETMV("SY_LOCPAD",,"01", cFilAnt))
	SBZ->BZ_LOCALIZ := iif( (cFilAnt$alltrim(SUPERGETMV("SY_LOCALIZ"))) .And. !(SB1->B1_GRUPO $ cGrupo)  ,"S","N")
	SBZ->BZ_DTINCLU := DDATABASE
	SBZ->BZ_TIPOCQ  := 'M' 
	SBZ->BZ_CTRWMS  := '2'  

ELSE
	RecLock("SBZ",.F.) // .F. = Altera
	DBRecall() //#AFD20180529.n
EndIF

MsUnLock()

SET DELETED ON //#AFD20180529.n

/*
DbSelectArea("SM0")
DbSeek(cEmpAnt)
While !EOF() .AND. SM0->M0_CODIGO == cEmpAnt
	AADD(aLojas, AllTrim(SM0->M0_CODFIL))
	DbSkip()
EndDo
*/

/*
For nX:=1 To Len(aLojas)

	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1") + AvKey(cProduto,"B1_COD") ))

	cFilAnt := PadR(aLojas[nX],nTamFil)
 
	DbSelectArea("SBZ")
	DbSetOrder(1)
	IF SBZ->(!DbSeek(cFilAnt+cProduto))  
		RecLock("SBZ",.T.) // .T. = INCLUI
		SBZ->BZ_FILIAL  := cFilAnt
		SBZ->BZ_COD     := cProduto
		SBZ->BZ_LOCPAD  := ALLTRIM(SUPERGETMV("SY_LOCPAD",,"01", cFilAnt))
		SBZ->BZ_LOCALIZ := iif( (cFilAnt$alltrim(SUPERGETMV("SY_LOCALIZ"))) .And. !(SB1->B1_GRUPO $ cGrupo)  ,"S","N")
		SBZ->BZ_DTINCLU := DDATABASE
		SBZ->BZ_TIPOCQ  := 'M' 
		SBZ->BZ_CTRWMS  := '2'  

		MsUnLock()
	EndIF
 
Next nY

cFilAnt := cFilAtu 
*/

RestArea(aAreaSM0)
RestArea(aAreaSB1)
RestArea(aAreaAtu)

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GRAVAINF ºAutor  ³ LUIZ EDUARDO F.C.  º Data ³  27/11/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ FUNCAO PARA GRAVAR O SB9 E SB2                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GRAVAINF(cProduto)

Local aAreaAtu 	:= GetArea()
Local aAreaSB1 	:= SB1->(GetArea())
Local aAreaSM0 	:= SM0->(GetArea())
Local aLojas 	:= {}
Local cFilAtu	:= cFilAnt
Local nTamFil	:= Len(cFilAnt)
Local cGrupo	:= GetMv("KH_GRPPROD",,"2001|2002") //Grupo de Produtos que nao deverao cadastrar na tabela SBZ
Local nX


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tabela passou a ser compartilhada e o campo filial ficarah vazio ³																    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbSelectArea("SM0")
DbSeek(cEmpAnt)
While !EOF() .AND. SM0->M0_CODIGO == cEmpAnt
	AADD(aLojas, AllTrim(SM0->M0_CODFIL))
	DbSkip()
EndDo


For nX:=1 To Len(aLojas)
	
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1") + AvKey(cProduto,"B1_COD") ))
	
	cFilAnt := PadR(aLojas[nX],nTamFil)
	
	DbSelectArea("SB9")
	DbSetOrder(1)
	If !dbSeek(xFilial("SB9")+cProduto+ALLTRIM(SUPERGETMV("SY_LOCPAD",,"01", cFilAnt)))		
		SB9->(RecLock("SB9",.T.))
		SB9->B9_FILIAL := cFilAnt
		SB9->B9_COD		:= cProduto
		SB9->B9_LOCAL 	:= ALLTRIM(SUPERGETMV("SY_LOCPAD",,"01", cFilAnt))
		SB9->B9_DATA	:= dDatabase
		SB9->(msUnLock())		
	EndIf        
	
	// FUNCAO PARA GRAVAR O SB2
	CRIASB2(cProduto,ALLTRIM(SUPERGETMV("SY_LOCPAD",,"01", cFilAnt))) 
	
Next nY

cFilAnt := cFilAtu

RestArea(aAreaSM0)
RestArea(aAreaSB1)
RestArea(aAreaAtu)

return()
