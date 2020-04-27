#include 'protheus.ch'
#include 'parmtype.ch'

#DEFINE ENTER (Chr(13)+Chr(10))
//--------------------------------------------------------------
/*/{Protheus.doc} MyFunction
Description                                                     
                                                                
@param xParam Parameter Description                             
@return xRet Return Description                                 
@author  -                                               
@since 21/05/2019                                                   
/*/                                                             
//--------------------------------------------------------------
user function KHADP001(aCampo,dDtIncl,lRet)                      
Local oButton1
Local oButton2
Local oButton3
Local oButton4
Local oButton5
Local oButton6
Local oButton7
Local oButton8
Local oButton9
Local oButton10
Local oButton11
Local oButton12
Local oButton13
Local oButton14
Local oButton15
Local oButton16
Local oButton17
Local oComboBo1                       
Local cPonto01 := ""
Local oComboBo10
Local cPonto10 := ""
Local oComboBo2
Local cPonto02 := ""
Local oComboBo3
Local cPonto03 := ""
Local oComboBo4
Local cPonto04 := "" 
Local oComboBo5
Local cPonto05 := ""
Local oComboBo6
Local cPonto06 := ""
Local oComboBo7
Local cPonto07 := ""
Local oComboBo8
Local cPonto08 := ""
Local oComboBo9
Local cPonto09 := ""
Local oComboBo10
Local cPonto10 := ""
Local oComboBo11
Local cPonto11 := ""
Local oComboBo12
Local cPonto12 := ""
Local oComboBo13
Local cPonto13 := ""
Local oComboBo14
Local cPonto14 := ""
Local oComboBo15
Local cPonto15 := ""
Local oGet1
Local cAvaliado := SPACE(50)
Local oGet2
Local cAvador := SPACE(50)
Local oGet3
Local ddata := DATE()
Local oGet4
Local cObs := ""
Local oGroup1 
Local oGroup2
Local oGroup3
Local oGroup4
Local oGroup5
Local oGroup6
Local oGroup7
Local oGroup8
Local oGroup9
Local oGroup10
Local oGroup11
Local oGroup12
Local oGroup13
Local oGroup14
Local oGroup15
Local oGroup16
Local oGroup17
Local oSay1 
Local oSay2
Local oSay3
Local oSay4
Local oSay5
Local oSay6
Local oSay7
Local oSay8
Local oSay9
Local oSay10
Local oSay11
Local oSay12
Local oSay13
Local oSay14
Local oSay15
Local oSay16
Local oSay17
Local oSay18
Local oSay19
Local cFerias := " "
Local cCodado := ""
Local cCodador := ""
Local cCodacao := ""
Local cNomAvao := ""
Local cAlias := getNextAlias()
Local cTeste := "" 
Default lRet := .F.
	

If lRet 
	cCodacao := aCampo[5]
	cCodador := aCampo[1]
	cCodado := aCampo[3]
	cAvaliado := aCampo[2]
	cAvador := aCampo[4]
	cNomAvao := aCampo[6]				
	DbSelectArea("ZKF")
	ZKF->(DbSetOrder(1))//ZKF_FILIAL+ZKF_CODAVA+ZKF_CODADO+ZKF_COADOR+DATA_INCLUSAO
		If ZKF->(DbSeek(xFilial()+cCodacao+cCodado+cCodador+dDtIncl))
			cCodacao :=	ZKF->ZKF_CODAVA 
			cNomAvao := ZKF->ZKF_NOMAVA 
			cCodado  := ZKF->ZKF_CODADO 
			cCodador := ZKF->ZKF_COADOR 
			cAvador  := ZKF->ZKF_NOADOR 
			cAvaliado:= ZKF->ZKF_NOMADO 
			ddata 	 := ZKF->ZKF_DTINCL 
			cPonto01 := ZKF->ZKF_PONT01 
			cPonto02 := ZKF->ZKF_PONT02 
			cPonto03 := ZKF->ZKF_PONT03 
			cPonto04 := ZKF->ZKF_PONT04 
			cPonto05 := ZKF->ZKF_PONT05 
			cPonto06 := ZKF->ZKF_PONT06 
			cPonto07 := ZKF->ZKF_PONT07 
			cPonto08 := ZKF->ZKF_PONT08 
			cPonto09 := ZKF->ZKF_PONT09 
			cPonto10 := ZKF->ZKF_PONT10 
			cPonto11 := ZKF->ZKF_PONT11 			
			cPonto12 := ZKF->ZKF_PONT12 
			cPonto13 := ZKF->ZKF_PONT13 
			cPonto14 := ZKF->ZKF_PONT14 
			cPonto15 := ZKF->ZKF_PONT15 
			cObs 	 := ZKF->ZKF_OBS
			EndIf
Else 
	cCodacao := aCampo[5]
	cCodador := aCampo[1]
	cCodado := aCampo[3]
	cAvaliado := aCampo[2]
	cAvador := aCampo[4]
	cNomAvao := aCampo[6]
EndIf  

cQuery := " SELECT DISTINCT QO_PONTOS AS PONTOS, ISNULL(CAST(CAST(QO_QUEST AS VARBINARY(8000)) AS VARCHAR(8000)),'') AS QUESTAO" + ENTER
cQuery += " FROM SQO010(NOLOCK) QO " + ENTER
cQuery += " INNER JOIN RD8010(NOLOCK) D8" + ENTER
cQuery += " ON D8.RD8_CODQUE =  QO.QO_QUESTAO INNER JOIN RD3010(NOLOCK) D3 " + ENTER
cQuery += " ON D8.RD8_CODMOD = D3.RD3_CODIGO INNER JOIN RD6010(NOLOCK) D6 " + ENTER
cQuery += " ON D6.RD6_CODMOD =  D3.RD3_CODIGO AND D6.RD6_CODIGO = '"+cCodacao+"' " + ENTER
cQuery += " WHERE QO.D_E_L_E_T_='' AND D6.D_E_L_E_T_='' AND D8.D_E_L_E_T_='' " + ENTER

PLSQuery(cQuery, cAlias)
	
	aPV := {}

    while (cAlias)->(!eof())
        
        aAdd(aPV,{   (cAlias)->PONTOS,;
                     (cAlias)->QUESTAO;
                     })
                   
    (cAlias)->(dbskip())
    End
    
    (cAlias)->(dbCloseArea())
    
    if len(aPV) == 0
        AAdd(aPV, {0,"",})
    endif

Static oDlg
                                                            //Altura //Largura
  DEFINE MSDIALOG oDlg TITLE "New Dialog" FROM 000, 000  TO 1100,    1390      COLORS 0, 16777215 PIXEL

    @ 008, 010 GROUP oGroup1 TO 058, 673 PROMPT "Informacoes" OF oDlg COLOR 0, 16777215 PIXEL   

	    @ 015, 017 SAY oSay1 PROMPT "Avaliador:" SIZE 030, 007 OF oDlg COLORS 0, 16777215 PIXEL 
	    @ 023, 017 MSGET oGet1 VAR cAvaliado SIZE 206, 010 When .F. OF oDlg COLORS 0, 16777215 PIXEL
	    
	    @ 035, 017 SAY oSay2 PROMPT "Avaliado:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL    
	    @ 042, 017 MSGET oGet2 VAR cAvador SIZE 206, 010 When .F. OF oDlg COLORS 0, 16777215 PIXEL
	    
	    @ 013, 606 SAY oSay3 PROMPT "Data:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL    
	   
	    @ 033, 606 SAY oSay16 PROMPT "Situação:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	    @ 042, 606 MSCOMBOBOX oComboBo11 VAR cFerias ITEMS {"Ferias","Experiência"," "} SIZE 061, 010 OF oDlg COLORS 0, 16777215 PIXEL
    
    @ 064, 009 GROUP oGroup2 TO 472, 673 PROMPT "Questoes" OF oDlg COLOR 0, 16777215 PIXEL
	    @ 020, 605 MSGET oGet3 VAR ddata SIZE 060, 010 When .F. OF oDlg COLORS 0, 16777215 PIXEL    
	    
	    @ 074, 022 GROUP oGroup3 TO 091, 544 PROMPT "Questao 1" OF oDlg COLOR 0, 16777215 PIXEL
	    @ 096, 022 GROUP oGroup4 TO 113, 545 PROMPT "Questao 2" OF oDlg COLOR 0, 16777215 PIXEL
	    @ 120, 022 GROUP oGroup5 TO 137, 543 PROMPT "Questao 3" OF oDlg COLOR 0, 16777215 PIXEL
	    @ 147, 022 GROUP oGroup6 TO 164, 543 PROMPT "Questao 4" OF oDlg COLOR 0, 16777215 PIXEL
	    @ 173, 022 GROUP oGroup7 TO 190, 542 PROMPT "Questao 5" OF oDlg COLOR 0, 16777215 PIXEL
	    @ 200, 022 GROUP oGroup8 TO 217, 540 PROMPT "Questao 6" OF oDlg COLOR 0, 16777215 PIXEL
	    @ 227, 022 GROUP oGroup9 TO 245, 542 PROMPT "Questao 7" OF oDlg COLOR 0, 16777215 PIXEL
	    @ 255, 022 GROUP oGroup10 TO 272, 541 PROMPT "Questao 8" OF oDlg COLOR 0, 16777215 PIXEL
	    @ 283, 022 GROUP oGroup11 TO 300, 543 PROMPT "Questao 9" OF oDlg COLOR 0, 16777215 PIXEL
	    @ 310, 022 GROUP oGroup12 TO 328, 543 PROMPT "Questao 10" OF oDlg COLOR 0, 16777215 PIXEL
	    @ 338, 022 GROUP oGroup13 TO 356, 543 PROMPT "Questao 11" OF oDlg COLOR 0, 16777215 PIXEL
	    @ 366, 022 GROUP oGroup14 TO 384, 543 PROMPT "Questao 12" OF oDlg COLOR 0, 16777215 PIXEL
    	@ 394, 022 GROUP oGroup15 TO 412, 543 PROMPT "Questao 13" OF oDlg COLOR 0, 16777215 PIXEL
	    @ 422, 022 GROUP oGroup16 TO 440, 543 PROMPT "Questao 14" OF oDlg COLOR 0, 16777215 PIXEL
	    @ 450, 022 GROUP oGroup17 TO 468, 543 PROMPT "Questao 15" OF oDlg COLOR 0, 16777215 PIXEL
    
	    @ 076, 552 BUTTON oButton3 PROMPT "Info" SIZE 021, 014 OF oDlg ACTION(apMsgAlert(Alltrim(aPV[1,2]),"Questão 1")) PIXEL
	    @ 098, 553 BUTTON oButton4 PROMPT "Info" SIZE 021, 014 OF oDlg ACTION(apMsgAlert(Alltrim(aPV[2,2]),"Questão 2")) PIXEL
	    @ 123, 554 BUTTON oButton5 PROMPT "Info" SIZE 021, 014 OF oDlg ACTION(apMsgAlert(Alltrim(aPV[3,2]),"Questão 3")) PIXEL
	    @ 148, 554 BUTTON oButton6 PROMPT "Info" SIZE 021, 014 OF oDlg ACTION(apMsgAlert(Alltrim(aPV[4,2]),"Questão 4")) PIXEL
	    @ 174, 553 BUTTON oButton7 PROMPT "Info" SIZE 021, 014 OF oDlg ACTION(apMsgAlert(Alltrim(aPV[5,2]),"Questão 5")) PIXEL
	    @ 202, 553 BUTTON oButton8 PROMPT "Info" SIZE 021, 014 OF oDlg ACTION(apMsgAlert(Alltrim(aPV[6,2]),"Questão 6")) PIXEL
	    @ 229, 554 BUTTON oButton9 PROMPT "Info" SIZE 021, 014 OF oDlg ACTION(apMsgAlert(Alltrim(aPV[7,2]),"Questão 7")) PIXEL
	    @ 256, 553 BUTTON oButton10 PROMPT "Info" SIZE 021, 014 OF oDlg ACTION(apMsgAlert(Alltrim(aPV[8,2]),"Questão 8")) PIXEL
	    @ 285, 554 BUTTON oButton11 PROMPT "Info" SIZE 021, 014 OF oDlg ACTION(apMsgAlert(Alltrim(aPV[9,2]),"Questão 9")) PIXEL
	    @ 313, 556 BUTTON oButton12 PROMPT "Info" SIZE 021, 014 OF oDlg ACTION(apMsgAlert(Alltrim(aPV[10,2]),"Questão 10")) PIXEL    
	    @ 341, 556 BUTTON oButton13 PROMPT "Info" SIZE 021, 014 OF oDlg ACTION(apMsgAlert(Alltrim(aPV[11,2]),"Questão 11")) PIXEL
	    @ 369, 556 BUTTON oButton14 PROMPT "Info" SIZE 021, 014 OF oDlg ACTION(apMsgAlert(Alltrim(aPV[12,2]),"Questão 12")) PIXEL
	    @ 397, 556 BUTTON oButton15 PROMPT "Info" SIZE 021, 014 OF oDlg ACTION(apMsgAlert(Alltrim(aPV[13,2]),"Questão 13")) PIXEL
	    @ 425, 556 BUTTON oButton16 PROMPT "Info" SIZE 021, 014 OF oDlg ACTION(apMsgAlert(Alltrim(aPV[14,2]),"Questão 14")) PIXEL
	    @ 453, 556 BUTTON oButton17 PROMPT "Info" SIZE 021, 014 OF oDlg ACTION(apMsgAlert(Alltrim(aPV[15,2]),"Questão 15")) PIXEL                
        
	    If Len(aPV) >= 1 //valida se o array tem conteúdo para mostrar as questões evitando error log - Marcio Nunes - 03/07/2019
		    nPonto1 := aPV[1,1]
			iF !EMPTY(nPonto1)
				aPontos1 :={}
				for nx := 0 to nPonto1 step 0.5
				aAdd(aPontos1, cValtochar(nx) )
				Next 
			EndIf
		    @ 077, 600 MSCOMBOBOX oComboBo1 VAR cPonto01 ITEMS aPontos1 SIZE 072, 018 OF oDlg COLORS 0, 16777215 PIXEL 
		 EndIf          
		 
	    If Len(aPV) >= 2
		    nPonto2 := aPV[2,1]
		    iF !EMPTY(nPonto2)
		    	aPontos2 :={}                                   
				for nx := 0 to nPonto2 step 0.5
				aAdd(aPontos2, cValtochar(nx) )
				Next
			EndIf            
		    @ 099, 600 MSCOMBOBOX oComboBo2 VAR cPonto02 ITEMS aPontos2 SIZE 072, 018 OF oDlg COLORS 0, 16777215 PIXEL
		EndIf           
		
	    If Len(aPV) >= 3
		    nPonto3 := aPV[3,1]
		    iF !EMPTY(nPonto3)
			    aPontos3 :={}
			    for nx := 0 to nPonto3 step 0.5
			 	aAdd(aPontos3, cValtochar(nx) )
			 	Next  
		 	EndIf 
		    @ 124, 600 MSCOMBOBOX oComboBo3 VAR cPonto03 ITEMS aPontos3 SIZE 072, 018 OF oDlg COLORS 0, 16777215 PIXEL
		EndIf
		
	    If Len(aPV) >= 4
		    nPonto4 := aPV[4,1]
		    If !EMPTY(nPonto4)
			    aPontos4 :={}
			    for nx := 0 to nPonto4 step 0.5
			 	aAdd(aPontos4, cValtochar(nx) )
			 	Next 
		    EndIf
		    @ 151, 600 MSCOMBOBOX oComboBo4 VAR cPonto04 ITEMS aPontos4 SIZE 072, 018 OF oDlg COLORS 0, 16777215 PIXEL
		EndIf
	
	    If Len(aPV) >= 5
		    nPonto5 := aPV[5,1]
		    If !EMPTY(nPonto5)
			    aPontos5 :={}
			    for nx := 0 to nPonto5 step 0.5
			 	aAdd(aPontos5, cValtochar(nx) )
			 	Next 
		    EndIf
		    @ 177, 600 MSCOMBOBOX oComboBo5 VAR cPonto05 ITEMS aPontos5 SIZE 072, 018 OF oDlg COLORS 0, 16777215 PIXEL
		EndIf
		                
	    If Len(aPV) >= 6
		    nPonto6 := aPV[6,1]
		    If !EMPTY(nPonto6)
			    aPontos6 :={}
			    for nx := 0 to nPonto6 step 0.5
			 	aAdd(aPontos6, cValtochar(nx) )
			 	Next 
		    EndIf
		    @ 204, 600 MSCOMBOBOX oComboBo6 VAR cPonto06 ITEMS aPontos6 SIZE 072, 018 OF oDlg COLORS 0, 16777215 PIXEL
		EndIf
		                                                            
	    If Len(aPV) >= 7
		    nPonto7 := aPV[7,1]
		    If !EMPTY(nPonto7)
			    aPontos7 :={}
			    for nx := 0 to nPonto7 step 0.5
			 	aAdd(aPontos7, cValtochar(nx) )
			 	Next 
			EndIf
		    @ 230, 600 MSCOMBOBOX oComboBo7 VAR cPonto07 ITEMS aPontos7 SIZE 072, 018 OF oDlg COLORS 0, 16777215 PIXEL
		EndIf
		
	    If Len(aPV) >= 8
		    nPonto8 := aPV[8,1]
		    If !EMPTY(nPonto8)
			    aPontos8 :={}
			    for nx := 0 to nPonto8 step 0.5
			 	aAdd(aPontos8, cValtochar(nx) )
			 	Next 
		 	EndIf
		    @ 257, 600 MSCOMBOBOX oComboBo8 VAR cPonto08 ITEMS aPontos8 SIZE 072, 018 OF oDlg COLORS 0, 16777215 PIXEL
		EndIf
		
	    If Len(aPV) >= 9
		    nPonto9 := aPV[9,1]
		    If !EMPTY(nPonto9)
			    aPontos9 :={}
			    for nx := 0 to nPonto9 step 0.5
			 	aAdd(aPontos9, cValtochar(nx) )
			 	Next 
		 	EndIf
		    @ 286, 600 MSCOMBOBOX oComboBo9 VAR cPonto09 ITEMS aPontos9 SIZE 072, 018 OF oDlg COLORS 0, 16777215 PIXEL
		EndIf
		
	    If Len(aPV) >= 10
		    nPonto10 := aPV[10,1]
		    If !EMPTY(nPonto10)
			    aPontos10 :={}
			    for nx := 0 to nPonto10 step 0.5
			 	aAdd(aPontos10, cValtochar(nx) )
			 	Next 
			EndIf
		    @ 312, 600 MSCOMBOBOX oComboBo10 VAR cPonto10 ITEMS aPontos10 SIZE 072, 018 OF oDlg COLORS 0, 16777215 PIXEL
	    EndIf      
	    
	     If Len(aPV) >= 11
		    nPonto10 := aPV[11,1]
		    If !EMPTY(nPonto11)
			    aPontos10 :={}
			    for nx := 0 to nPonto11 step 0.5
			 	aAdd(aPontos11, cValtochar(nx) )
			 	Next 
			EndIf
		    @ 340, 600 MSCOMBOBOX oComboBo11 VAR cPonto11 ITEMS aPontos11 SIZE 072, 018 OF oDlg COLORS 0, 16777215 PIXEL
	    EndIf
	    
	     If Len(aPV) >= 12
		    nPonto12 := aPV[12,1]
		    If !EMPTY(nPonto12)
			    aPontos12 :={}
			    for nx := 0 to nPonto12 step 0.5
			 	aAdd(aPontos12, cValtochar(nx) )
			 	Next 
			EndIf
		    @ 368, 600 MSCOMBOBOX oComboBo12 VAR cPonto12 ITEMS aPontos12 SIZE 072, 018 OF oDlg COLORS 0, 16777215 PIXEL
	    EndIf
	    
	     If Len(aPV) >= 13
		    nPonto13 := aPV[13,1]
		    If !EMPTY(nPonto13)
			    aPontos13 :={}
			    for nx := 0 to nPonto13 step 0.5
			 	aAdd(aPontos13, cValtochar(nx) )
			 	Next 
			EndIf
		    @ 396, 600 MSCOMBOBOX oComboBo13 VAR cPonto13 ITEMS aPontos13 SIZE 072, 018 OF oDlg COLORS 0, 16777215 PIXEL
	    EndIf
	    
	     If Len(aPV) >= 14
		    nPonto14 := aPV[14,1]
		    If !EMPTY(nPonto14)
			    aPontos14 :={}
			    for nx := 0 to nPonto14 step 0.5
			 	aAdd(aPontos14, cValtochar(nx) )
			 	Next 
			EndIf
		    @ 424, 600 MSCOMBOBOX oComboBo14 VAR cPonto14 ITEMS aPontos14 SIZE 072, 018 OF oDlg COLORS 0, 16777215 PIXEL
	    EndIf
	    
	     If Len(aPV) >= 15
		    nPonto15 := aPV[15,1]
		    If !EMPTY(nPonto15)
			    aPontos15 :={}
			    for nx := 0 to nPonto15 step 0.5
			 	aAdd(aPontos15, cValtochar(nx) )
			 	Next 
			EndIf
		    @ 452, 600 MSCOMBOBOX oComboBo15 VAR cPonto15 ITEMS aPontos15 SIZE 072, 018 OF oDlg COLORS 0, 16777215 PIXEL
	    EndIf
    
	    If Len(aPV) >= 1                                                                                    
		    @ 081, 026 SAY oSay5 PROMPT aPV[1,2] SIZE 550, 007 OF oDlg COLORS 0, 16777215 PIXEL
	    EndIf           
	    If Len(aPV) >= 2
		    @ 103, 025 SAY oSay6 PROMPT aPV[2,2] SIZE 550, 007 OF oDlg COLORS 0, 16777215 PIXEL
		EndIf
		If Len(aPV) >= 3
		    @ 127, 025 SAY oSay7 PROMPT aPV[3,2] SIZE 550, 007 OF oDlg COLORS 0, 16777215 PIXEL
		EndIf
		If Len(aPV) >= 4
		    @ 154, 025 SAY oSay8 PROMPT aPV[4,2] SIZE 550, 007 OF oDlg COLORS 0, 16777215 PIXEL
		EndIf
		If Len(aPV) >= 5
		    @ 181, 025 SAY oSay9 PROMPT aPV[5,2] SIZE 550, 007 OF oDlg COLORS 0, 16777215 PIXEL
		EndIf
		If Len(aPV) >= 6
		    @ 207, 025 SAY oSay10 PROMPT aPV[6,2] SIZE 550, 007 OF oDlg COLORS 0, 16777215 PIXEL
		EndIf           
		If Len(aPV) >= 7
		    @ 235, 025 SAY oSay11 PROMPT aPV[7,2] SIZE 550, 007 OF oDlg COLORS 0, 16777215 PIXEL
		EndIf           
		If Len(aPV) >= 8
		    @ 262, 024 SAY oSay12 PROMPT aPV[8,2] SIZE 550, 007 OF oDlg COLORS 0, 16777215 PIXEL
		EndIf
		If Len(aPV) >= 9
		    @ 290, 024 SAY oSay13 PROMPT aPV[9,2] SIZE 550, 007 OF oDlg COLORS 0, 16777215 PIXEL
	 	EndIf
	 	If Len(aPV) >= 10          
		    @ 318, 024 SAY oSay14 PROMPT aPV[10,2] SIZE 500, 007 OF oDlg COLORS 0, 16777215 PIXEL
		EndIf
		If Len(aPV) >= 11
		    @ 346, 024 SAY oSay15 PROMPT aPV[11,2] SIZE 500, 007 OF oDlg COLORS 0, 16777215 PIXEL
		EndIf
		If Len(aPV) >= 12          
		    @ 374, 024 SAY oSay16 PROMPT aPV[12,2] SIZE 500, 007 OF oDlg COLORS 0, 16777215 PIXEL
		EndIf
		If Len(aPV) >= 13          
		    @ 402, 024 SAY oSay17 PROMPT aPV[13,2] SIZE 500, 007 OF oDlg COLORS 0, 16777215 PIXEL
		EndIf
		If Len(aPV) >= 14          
		    @ 430, 024 SAY oSay18 PROMPT aPV[14,2] SIZE 500, 007 OF oDlg COLORS 0, 16777215 PIXEL
		EndIf
		If Len(aPV) >= 15          
		    @ 458, 024 SAY oSay19 PROMPT aPV[15,2] SIZE 500, 007 OF oDlg COLORS 0, 16777215 PIXEL
		EndIf

    @ 475, 012 SAY oSay4 PROMPT "Observacao:" SIZE 042, 008 OF oDlg COLORS 0, 16777215 PIXEL    
    @ 485, 011 GET oGet4 VAR cObs MEMO SIZE 600, 039 OF oDlg COLORS 0, 16777215 PIXEL

    @ 530, 533 BUTTON oButton1 PROMPT "Cancelar" SIZE 037, 012 OF oDlg ACTION(oDlg:End()) PIXEL
    @ 530, 575 BUTTON oButton2 PROMPT "Salvar" SIZE 037, 012 ACTION (fGrava(cCodacao,cCodador,cCodado,cAvaliado,cAvador,cNomAvao,ddata,;
    cPonto01,cPonto02,cPonto03,cPonto04,cPonto05,cPonto06,cPonto07,cPonto08,cPonto09,cPonto10,cPonto11,cPonto12,cPonto13,cPonto14,cPonto15,cObs,cFerias,lRet),oDlg:End()) PIXEL OF oDlg PIXEL


  ACTIVATE MSDIALOG oDlg CENTERED
   

Return


//--------------------------------------------------------------
/*/{Protheus.doc} fGrava
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - WELLINGTON RAUL 
@since 27/05/2019 /*/
//--------------------------------------------------------------      

Static Function fGrava(cCodacao,cCodador,cCodado,cAvaliado,cAvador,cNomAvao,ddata,;
    cPonto01,cPonto02,cPonto03,cPonto04,cPonto05,cPonto06,cPonto07,cPonto08,cPonto09,cPonto10,cPonto11,cPonto12,cPonto13,cPonto14,cPonto15,cObs,cFerias,lRet)


Local lGrava 	:= .T.
Local nTotal 	:= val(cPonto01)+val(cPonto02)+val(cPonto03)+val(cPonto04)+val(cPonto05)+val(cPonto06)+val(cPonto07)+val(cPonto08)+val(cPonto09)+val(cPonto10)+val(cPonto11)+val(cPonto12)+val(cPonto13)+val(cPonto14)+val(cPonto15)
Local nPeso 	:= 0
Local dDtAlt	:= DATE()
Local cFeria	:= SUBSTR(cFerias, 0, 1) 
Private cUser := RetCodUsr() //Retorna o Codigo do Usuario
Private cNamUser := UsrRetName( cUser )//Retorna o nome do usuario 


DbSelectArea("RD0")
RD0->(DbSetOrder(1))//RD0_FILIAL, RD0_CODIGO, R_E_C_N_O_, D_E_L_E_T_
if RD0->(DbSeek(xFilial()+cCodador))
nPeso := RD0->RD0_XPESO
endIf

DbSelectArea("ZKF")
ZKF->(DbSetOrder(1))//ZKF_FILIAL+ZKF_CODAVA+ZKF_CODADO+ZKF_COADOR+DATA_INCLUSAO
If ZKF->(DbSeek(xFilial()+cCodacao+cCodado+cCodador+dtos(ddata)))
	If  lRet
		RecLock("ZKF",.F.)						
		msgAlert("Prezado Sr.(a) "+ cNamUser + " Dados da Avaliação Alterados com sucesso!")
		ZKF->ZKF_DTALT := dDtAlt //CAMPO A SER CRIADO  TIPO DATA 8
		ZKF->ZKF_USRALT := cNamUser //CAMPO A SER CRIADO TIPO CARACTERE 40
	Else
		lGrava := .F.
		msgAlert("Prezado Sr.(a) "+ cNamUser + " O Colaborador já possuí avaliação para a data: "+ dtoc(ddata)+" Obrigado")
	EndIf
Else
	RecLock("ZKF",.T.)							
	msgAlert("Prezado Sr.(a) "+ cNamUser + " Dados da Avaliação salvos com sucesso!")
	ZKF->ZKF_USRINC := cUser
EndIf		
If lGrava
	ZKF->ZKF_FILIAL := xFilial()
	ZKF->ZKF_CODAVA := cCodacao
	ZKF->ZKF_NOMAVA := cNomAvao
	ZKF->ZKF_CODADO := cCodado
	ZKF->ZKF_COADOR := cCodador
	ZKF->ZKF_NOADOR := cAvador
	ZKF->ZKF_NOMADO := cAvaliado
	ZKF->ZKF_DTINCL := ddata
	ZKF->ZKF_PONT01 := cPonto01
	ZKF->ZKF_PONT02 := cPonto02
	ZKF->ZKF_PONT03 := cPonto03
	ZKF->ZKF_PONT04 := cPonto04
	ZKF->ZKF_PONT05 := cPonto05
	ZKF->ZKF_PONT06 := cPonto06
	ZKF->ZKF_PONT07 := cPonto07
	ZKF->ZKF_PONT08 := cPonto08
	ZKF->ZKF_PONT09 := cPonto09
	ZKF->ZKF_PONT10 := cPonto10
	ZKF->ZKF_PONT10 := cPonto11
	ZKF->ZKF_PONT10 := cPonto12
	ZKF->ZKF_PONT10 := cPonto13
	ZKF->ZKF_PONT10 := cPonto14
	ZKF->ZKF_PONT10 := cPonto15					
	ZKF->ZKF_TOTAL  := nTotal //CAMPO A SER CRIADO  CAMPO NUMERICO 3
	ZKF->ZKF_OBS	:= cObs //CAMPO A SER CRIADO CAMPO MEMO
	ZKF->ZKF_PESO 	:= nPeso //CAMPO A SER CRIADO  CAMPO NUMERICO 1
	ZKF->ZKF_FERIAS := cFeria //CAMPO A SER CRIADO  CAMPO CARACTERE 1 
	
	MsUnLock()
EndIf
								
									    	
Return