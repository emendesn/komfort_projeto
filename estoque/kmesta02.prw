#Include 'Protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � KMESTA02 �Autor  �M�rio - ERP Plus    � Data �  12/02/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para c�lculo do c�digo EAN. Informado como valida��o���
���          �de usu�rio no campo B1_CODBAR.                              ���
�������������������������������������������������������������������������͹��
���Uso       � SUGEST�O DO C�DIGO EAN.                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER FUNCTION KMESTA02()
Local aArea 	:= GetArea()
Local lRet		:= .F.
Local oEAN
Local cTipo := SuperGetMv("KH_TPPROD",.F.,"ME")

If Alltrim(M->B1_TIPO) $ cTipo
	If Empty(M->B1_CODBAR)
		If AVISO("C�digo EAN","Aten��o!!! EAN em branco, deseja prosseguir assim mesmo???",{"Sim","N�o"},2) == 1
			lRet := .T.
		Else
			If AVISO("C�digo EAN","Verificar novo c�digo EAN dispon�vel???",{"Sim","N�o"},1) == 1			
				oEAN := KMESTX01():New( M->B1_COD ,  ,  ,  ,  ,  )
				If oEAN:lCaldSeq()
					If oEAN:lCalcDV()
						M->B1_CODBAR := Alltrim(oEAN:cCodPais) + Alltrim(oEAN:cEmpresa) + Alltrim(oEAN:cSequenc) + Alltrim(oEAN:cDigVerif)			
					Else
						lRet := .F.
						Alert(oEAN:cMsgErro)
					Endif 
				Else	//#RVC20180416.bn
					oEAN := KMESTX01():New( M->B1_COD , "790" , "94870" ,  ,  ,  )
					If oEAN:lCaldSeq()
						If oEAN:lCalcDV()
							M->B1_CODBAR := Alltrim(oEAN:cCodPais) + Alltrim(oEAN:cEmpresa) + Alltrim(oEAN:cSequenc) + Alltrim(oEAN:cDigVerif)			
						Else
							lRet := .F.
							Alert(oEAN:cMsgErro)
						Endif 
					Else
						lRet := .F.
						Alert(oEAN:cMsgErro)
					EndIf	//#RVC20180416.en
//					lRet := .F.				//#RVC20180416.o
//					Alert(oEAN:cMsgErro)	//#RVC20180416.o
				Endif		
			Endif
			lRet := .T.
		Endif
	Else
	
		Aviso("Altera��o EAN","EAN alterado manualmente!!!",{"Ok"},1)
		
		// Se n�o for um c�digo Komfort House
//		If SUBSTR(M->B1_CODBAR,1,8) $ "78998552|79094870"	//#RVC20180612.o
		If SUBSTR(M->B1_CODBAR,1,8) $ "78998552|79094870|79094871|79094872|79094873|79094874|79094875|79094876|79094877|79094878|79094879"	//#RVC20180612.n
			If Len(Alltrim(M->B1_CODBAR)) == 13
				oEAN := KMESTX01():New( M->B1_COD , SUBSTR(M->B1_CODBAR,1,3) , SUBSTR(M->B1_CODBAR,4,5) , SUBSTR(M->B1_CODBAR,9,4) , SUBSTR(M->B1_CODBAR,13,1) ,  )
				If oEAN:lValidDV()
					lRet := .T.
				Else
					lRet := .F.
					Alert(oEAN:cMsgErro)
				Endif
			ElseIf Len(Alltrim(M->B1_CODBAR)) == 12
				oEAN := KMESTX01():New( M->B1_COD , SUBSTR(M->B1_CODBAR,1,3) , SUBSTR(M->B1_CODBAR,4,5) , SUBSTR(M->B1_CODBAR,9,4) ,  ,  )
				If oEAN:lCalcDV()
					M->B1_CODBAR := ALLTRIM(M->B1_CODBAR)+oEAN:cDigVerif
					lRet := .T.
				Else
					lRet := .F.
					Alert(oEAN:cMsgErro)
				Endif
			Else
				lRet := .F.
				Alert("Quantidade de d�gitos informada n�o � v�lida. O c�digo EAN deve ter 12 d�gitos (ocorrer� o c�lculo do DV) ou 13 d�gitos (n�o efetuar� o c�lculo do DV).")
			Endif
			
			If lRet		
				If oEAN:lVldSeq()
					If oEAN:lVldDupli( M->B1_CODBAR )
						lRet := .T.
					Else		
						If MSGNOYES(oEAN:cMsgErro +". Prosseguir desta forma?","PERMITIR C�DIGO EAN DUPLICADO ?")
							lRet := .T.
						Else
							lRet := .F.
							//Alert(oEAN:cMsgErro)
							If AVISO("C�digo EAN","Verificar novo c�digo EAN dispon�vel???",{"Sim","N�o"},1) == 1
								If oEAN:lCaldSeq()
									If oEAN:lCalcDV()
										M->B1_CODBAR := Alltrim(oEAN:cCodPais) + Alltrim(oEAN:cEmpresa) + Alltrim(oEAN:cSequenc) + Alltrim(oEAN:cDigVerif)			
									Else
										lRet := .F.
										Alert(oEAN:cMsgErro)
									Endif 
								Else	//#RVC20180416.bn
									oEAN := KMESTX01():New( M->B1_COD , "790" , "94870" ,  ,  ,  )
									If oEAN:lCaldSeq()
										If oEAN:lCalcDV()
											M->B1_CODBAR := Alltrim(oEAN:cCodPais) + Alltrim(oEAN:cEmpresa) + Alltrim(oEAN:cSequenc) + Alltrim(oEAN:cDigVerif)			
										Else
											lRet := .F.
											Alert(oEAN:cMsgErro)
										Endif 
									Else
										lRet := .F.
										Alert(oEAN:cMsgErro)
									EndIf	//#RVC20180416.en
//									Alert(oEAN:cMsgErro)	//#RVC20180416.o
								Endif
							Endif							
						Endif					
					Endif
				Else					
					//lRet := .F.
					If MSGNOYES(oEAN:cMsgErro +". Prosseguir desta forma?","PERMITIR C�DIGO EAN DUPLICADO ?")
						lRet := .T.
					Else
						//Alert(oEAN:cMsgErro)
						If AVISO("C�digo EAN","Verificar novo c�digo EAN dispon�vel???",{"Sim","N�o"},1) == 1
							If oEAN:lCaldSeq()
								If oEAN:lCalcDV()
									M->B1_CODBAR := Alltrim(oEAN:cCodPais) + Alltrim(oEAN:cEmpresa) + Alltrim(oEAN:cSequenc) + Alltrim(oEAN:cDigVerif)			
								Else
									lRet := .F.
									Alert(oEAN:cMsgErro)
								Endif 
							Else	//#RVC20180416.bn
								oEAN := KMESTX01():New( M->B1_COD , "790" , "94870" ,  ,  ,  )
								If oEAN:lCaldSeq()
									If oEAN:lCalcDV()
										M->B1_CODBAR := Alltrim(oEAN:cCodPais) + Alltrim(oEAN:cEmpresa) + Alltrim(oEAN:cSequenc) + Alltrim(oEAN:cDigVerif)			
									Else
										lRet := .F.
										Alert(oEAN:cMsgErro)
									Endif 
								Else
									lRet := .F.
									Alert(oEAN:cMsgErro)
								EndIf	//#RVC20180416.en
//								Alert(oEAN:cMsgErro)	//#RVC20180416.o
							Endif
						Endif
					Endif
				Endif
			Endif
		Else
			oEAN := KMESTX01():New( M->B1_COD ,  ,  ,  ,  ,  )
			If oEAN:lCaldSeq()	//#RVC20180416.bn
				If oEAN:lCalcDV()
					M->B1_CODBAR := Alltrim(oEAN:cCodPais) + Alltrim(oEAN:cEmpresa) + Alltrim(oEAN:cSequenc) + Alltrim(oEAN:cDigVerif)			
				Else
					lRet := .F.
					Alert(oEAN:cMsgErro)
				Endif 
			Else
				//oEAN := KMESTX01():New( M->B1_COD , "790" , "94870" ,  ,  ,  )	//#RVC20180612.o
				oEAN := KMESTX01():New( M->B1_COD , LocStr(1) , LocStr(2) ,  ,  ,  )//#RVC20180612.n
				If oEAN:lCaldSeq()
					If oEAN:lCalcDV()
						M->B1_CODBAR := Alltrim(oEAN:cCodPais) + Alltrim(oEAN:cEmpresa) + Alltrim(oEAN:cSequenc) + Alltrim(oEAN:cDigVerif)			
					Else
						lRet := .F.
						Alert(oEAN:cMsgErro)
					Endif 
				Else
					lRet := .F.
					Alert(oEAN:cMsgErro)
				EndIf	
			Endif	//#RVC20180416.en
			If oEAN:lVldDupli( M->B1_CODBAR )
				lRet := .T.
			Else
				If MSGNOYES(oEAN:cMsgErro +". Prosseguir desta forma?","PERMITIR C�DIGO EAN DUPLICADO ?")
					lRet := .T.
				Else
					lRet := .F.
				Endif
			Endif
		Endif
	Endif
Else
	lRet := .T.
Endif

RestArea(aArea)
RETURN lRet

//#RVC20180612.bn
Static Function LocStr(N)
	
	Local cQry		:= ""
	Local aArea		:= GetArea()
	Local aPRF		:= StrToKarr(SuperGetMV("KH_PRFXEAN",.F.,"78998552"))
	Local cQry		:= ""
	Local cRet	 	:= ""
	
	dbSelectArea("SB1")
	SB1->(dbSetOrder(5))
	SB1->(dbGoTop()) 
	
	cQry += " SELECT MAX(SUBSTRING(B1_CODBAR,1,8)) AS CODBAR FROM SB1010 "
	cQry += " WHERE B1_TIPO = 'ME' "
	cQry += " AND D_E_L_E_T_ = ' ' "
	cQry += " ORDER BY 1 "
	
	If Select("TRB") > 0
		TRB->(DbCloseArea())
	Endif
	
	cQry := ChangeQuery(cQry)
	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQry),"TRB",.F.,.T.)
		
	If Alltrim(TRB->CODBAR) $ aPRF
		If N == 1
			cRet	:= SUBSTR(ALLTRIM(TRB->CODBAR),1,3)
		Else
			cRet 	:= SUBSTR(ALLTRIM(TRB->CODBAR),4,5)
		EndIf
	EndIf

	RestArea(aArea)

Return cRet
//#RVC20180612.en