#Include 'Protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � KMESTA01 �Autor  �M�rio - ERP Plus    � Data �  12/02/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para c�lculo do c�digo EAN. Gatilho do campo B1_TIPO���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � SUGEST�O DO C�DIGO EAN.                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER FUNCTION KMESTA01()
Local aArea := GetArea()
Local cRet	  := ""
Local oEAN
Local cTipo := SuperGetMv("KH_TPPROD",.F.,"ME")

If ALLTRIM(M->B1_TIPO) $ cTipo .AND. EMPTY(M->B1_CODBAR)
	oEAN := KMESTX01():New( M->B1_COD ,  ,  ,  ,  ,  )
	If oEAN:lCaldSeq()
		If oEAN:lCalcDV()
			cRet := Alltrim(oEAN:cCodPais) + Alltrim(oEAN:cEmpresa) + Alltrim(oEAN:cSequenc) + Alltrim(oEAN:cDigVerif)			
		Else
			cRet := ""
			Alert(oEAN:cMsgErro)
		Endif 
	Else	//#RVC20180416.bn
		oEAN := KMESTX01():New( M->B1_COD , "790" , "94870" ,  ,  ,  )
		If oEAN:lCaldSeq()
			If oEAN:lCalcDV()
				cRet := Alltrim(oEAN:cCodPais) + Alltrim(oEAN:cEmpresa) + Alltrim(oEAN:cSequenc) + Alltrim(oEAN:cDigVerif)			
			Else
				cRet := ""
				Alert(oEAN:cMsgErro)
			Endif 
		Else
			cRet := ""
			Alert(oEAN:cMsgErro)
		EndIf	//#RVC20180416.en
//		cRet := ""				//#RVC20180416.o
//		Alert(oEAN:cMsgErro)	//#RVC20180416.o
	Endif
Else
	cRet := M->B1_CODBAR
Endif

RestArea(aArea)
RETURN cRet

