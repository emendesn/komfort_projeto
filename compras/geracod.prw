#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GERACOD  ºAutor  ³ Gustavo Kuhl  º Data ³  05/07/16        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Geracao do codigo do produto pai automatico.               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function GERCOD()

Local aAreaAtu 	:= GetArea()
Local cRet 		:= M->B4_COD
Local cQuery 	:= ""
Local cNextCod	:= "0000"
Local cCodma	:= "" 
Local cdescma	:= ""
Local cCodcol	:= ""
Local cDesccol	:= ""  
Local cCodEsp	:= ""

If INCLUI .OR. nOpc==6
 
		cCodma := M->B4_01CODMA 
		cCodcol :=  M->B4_01COLEC 
		
		DBSELECTAREA("AY2")
		DBSETORDER(1)
		If DbSeek(xFilial("AY2")+cCodma)   
			If cCodma =='000019'
		    	cdescma := "KMH" //Iniciais do código alterado pois os primeiros produtos foram criados como KMH, Marcio Nunes, Solicitante Adarlene - 03/09/2019
			Else
				cdescma := LEFT(ALLTRIM(AY2->AY2_DESCR),3)
			EndIf
		ENDIF
		
     	DBSELECTAREA("AYH")
		DBSETORDER(1)
		If DbSeek(xFilial("AYH")+cCodcol)
		cDesccol := LEFT(ALLTRIM(AYH->AYH_DESCRI),3)
		ENDIF	
	 
	 	cCodEsp := cdescma+cDesccol 
  
	cQuery := " SELECT MAX(SUBSTRING(SB4.B4_COD,7,4)) AS ULTCOD "+CRLF
	cQuery += " FROM "+RetSqlName("SB4")+" SB4 "+CRLF
	cQuery += " WHERE "+CRLF
	cQuery += " 	SB4.B4_FILIAL = '"+xFilial("SB4")+"' "+CRLF
	cQuery += " 	AND LEFT(SB4.B4_COD,3) = '"+cdescma+"' "+CRLF
	cQuery += " 	AND SUBSTRING(SB4.B4_COD,4,3) = '"+cDesccol+"' "+CRLF
	cQuery += " 	AND SB4.D_E_L_E_T_ = '' "+CRLF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Executa Query gerada  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"TMPSB4",.T.,.T.)
	
	While TMPSB4->(!EOF())
		cNextCod := SOMA1(TMPSB4->ULTCOD)
		
		TMPSB4->(dbSkip())
	EndDo
	
	TMPSB4->(dbCloseArea())
	
	cRet := cCodEsp+cNextCod
EndIf

RestArea(aAreaAtu)

Return cRet 


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DESCRI() ºAutor  ³ Gustavo Kuhl  º Data ³  04/01/17        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Geracao da descricao do produto pai automatico.            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function DESCRI()

Local cRet := M->B4_DESC
Local cModelo := ''

If INCLUI .OR. nOpc==6 

		DBSELECTAREA("AYH")
		DBSETORDER(1)
		If DbSeek(xFilial("AYH")+M->B4_01COLEC)
		cModelo := ALLTRIM(AYH->AYH_DESCRI)
		ENDIF

 
		cRet := ALLTRIM(M->B4_01DCAT2)
		cRet += " "
		cRet += cModelo
		cRet += " "
		cRet += ALLTRIM(M->B4_01DCAT4)
 
EndIf

Return(cRet) 

