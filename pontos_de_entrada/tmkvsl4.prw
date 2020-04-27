#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TMKVSL4  ³ Autor ³  SYMM CONSULTORIA  ³ Data ³  14/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ajusta a gravacao da tabela de forma de pagamento.         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TMKVSL4(cAtendimento,aParcelas)

Local aArea 	:= GetArea()
Local nX		:= 0
//Local nI		:= 0	//#RVC20180628.o
Local aReceb	:= {} 
Local aDadosNSU := {}
Local aDadosCHE := {}
Local lTefOk    := .F.                            							// Tef OK
Local aNSU		:= {}	//#RVC20180603.n
Local cBand		:= ""	//#RVC20180626.n
Local cParc		:= "0"	//#RVC20180628.n

SL4->(DbSetOrder(1))
SL4->(DbSeek(xFilial("SL4") + cAtendimento ))
While SL4->(!Eof()) .And. SL4->L4_FILIAL+SL4->L4_NUM==xFilial("SL4") + cAtendimento
	aDadosNSU := SEPARA(SL4->L4_OBS,"|")
	aDadosCHE := SEPARA(SL4->L4_OBS,"|")

	Reclock("SL4",.F.)      
	
	SL4->L4_XPARC := ALLTRIM(RIGHT(ALLTRIM(SL4->L4_OBS),2))
		
	If !Empty(SL4->L4_COMP)
		If LEFT(SL4->L4_COMP,1)=="1"
			SL4->L4_XFORFAT := "1"
		Else
			SL4->L4_XFORFAT := "2"
		Endif
		SL4->L4_COMP  := ""
		SL4->L4_MOEDA := 1
		
		//#RVC20180724.bn 
		If Len(aDadosNSU) > 0
			SL4->L4_ADMINIS	:= aDadosNSU[1]
		Else
			SL4->L4_ADMINIS	:= ""
			SL4->L4_NUMCART := ""
		Endif
		//#RVC20180724.en
		
		If Alltrim(SL4->L4_FORMA) $  "CC/CD/BOL/FI"		
			//#RVC20180724.bo 
/*			If Len(aDadosNSU) > 0
				SL4->L4_ADMINIS	:= aDadosNSU[1]
			Else
				SL4->L4_ADMINIS	:= ""
			Endif
			*/		//#RVC20180724.be
			
			If Len(aDadosNSU) > 1			
				SL4->L4_AUTORIZ	:= aDadosNSU[2]
				//#RVC20180603.bn
				If Empty(aNSU)
					Aadd(aNSU,{aDadosNSU[2]})
					SL4->L4_XPARNSU := "1"
				Else
					Aadd(aNSU,{aDadosNSU[2]})
					ASort(aNSU)
					For  nX := 1 to Len(aNSU)
						If Alltrim(aNSU[nX][1]) == Alltrim(aDadosNSU[2])
//							nI++											//#RVC20180628.o
							cParc := SOMA1(cParc,TamSX3("E1_PARCELA")[1])	//#RVC20180628.n
						EndIf
					Next
//					SL4->L4_XPARNSU := cValtoChar(nI)	//#RVC20180628.o
//					nI := 0								//#RVC20180628.o
					SL4->L4_XPARNSU := cParc
					cParc := "0"						//#RVC20180628.n
				EndIf
				//#RVC20180603.en
			Else
				SL4->L4_AUTORIZ	:= ""
			Endif
			SL4->L4_NUMCART := ""	

			//#RVC20180603.bn
			If Len(aDadosNSU) > 3
				SL4->L4_XNCART4	:= aDadosNSU[4]
			Else
				SL4->L4_XNCART4	:= ""
			Endif
			
			If Len(aDadosNSU) > 4
//				SL4->L4_XFLAG	:= aDadosNSU[5]						//#RVC20180626.o
//				cBand			:= Rtrim(aDadosNSU[5])				//#RVC20180626.n	//#RVC20180710.o
//				SL4->L4_XFLAG	:= SUBSTR(cBand,1,(Len(cBand)-1))	//#RVC20180626.n	//#RVC20180710.o
				SL4->L4_XFLAG	:= RemovNum(aDadosNSU[5])
			Else
				SL4->L4_XFLAG	:= ""
			Endif
			//#RVC20180603.en
					
		
//		ElseIf Alltrim(SL4->L4_FORMA) $  "CH/CHK" //AFD20180507.o
//		ElseIf Alltrim(SL4->L4_FORMA) $  "CH/CHK" .AND. M->UA_OPER=="1" //AFD20180507.n
		ElseIf Alltrim(SL4->L4_FORMA) $  "CH/CHK" .and. M->UA_OPER=="1" .and. len(aDadosCHE) > 1//AFD20180517.n
			SL4->L4_AUTORIZ	:= ""         
			SL4->L4_NUMCART	:= aDadosCHE[1]			
			SL4->L4_AGENCIA	:= aDadosCHE[2]
			SL4->L4_CONTA	:= aDadosCHE[3]
			//SL4->L4_RG		:= aDadosCHE[5]	//#AFD20180517.o
			SL4->L4_CGC		:= aDadosCHE[5]		//#AFD20180517.n	
			SL4->L4_TELEFON	:= aDadosCHE[6]

//--------- Autorização Telecheque e CMC7 - Cristiam Rossi em 18/07/2017
			if file( "\CALL_CENTER_"+cFilAnt+"\SYTM002_"+cFilAnt+"_"+M->UA_NUM+".TXT" )
				cAutoriz := memoRead("\CALL_CENTER_"+cFilAnt+"\SYTM002_"+cFilAnt+"_"+cAtendimento+".TXT")
				SL4->L4_CODVP := cAutoriz
				fErase( "\CALL_CENTER_"+cFilAnt+"\SYTM002_"+cFilAnt+"_"+cAtendimento+".TXT" )
			endif
			
			cNumCH := separa( SL4->L4_OBS, "|")[4]
			if file( "\CALL_CENTER_"+cFilAnt+"\TMKVPA_"+cFilAnt+"_"+cAtendimento+"_"+ALLTRIM(cNumCH)+".TXT" )
				cCMC7 := memoRead("\CALL_CENTER_"+cFilAnt+"\TMKVPA_"+cFilAnt+"_"+cAtendimento+"_"+ALLTRIM(cNumCH)+".TXT" )
				SL4->L4_NUMCFID := cCMC7
				fErase( "\CALL_CENTER_"+cFilAnt+"\TMKVPA_"+cFilAnt+"_"+cAtendimento+"_"+ALLTRIM(cNumCH)+".TXT" )
			endif
//----------------------------------------------------------------------
		Endif
					
	Endif
	SL4->(MsUnlock())	
	SL4->(DbSkip())
End

RestArea(aArea)

Return

Static Function RemovNum(cString)

Private cTexto := ""

cTexto := Strtran(cString,"1","")
cTexto := Strtran(cTexto,"2","")
cTexto := Strtran(cTexto,"3","")
cTexto := Strtran(cTexto,"4","")     
cTexto := Strtran(cTexto,"5","")
cTexto := Strtran(cTexto,"6","")
cTexto := Strtran(cTexto,"7","")
cTexto := Strtran(cTexto,"8","")
cTexto := Strtran(cTexto,"9","")
cTexto := Strtran(cTexto,"0","")
cTexto := Alltrim(cTexto)

return(cTexto)