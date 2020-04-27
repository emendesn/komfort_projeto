#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GERACOD  �Autor  � SYMM Consultoria   � Data �  19/09/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Geracao do codigo do produto pai automatico.               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � SYVAUX                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GERACOD(lCopia)

Local aAreaAtu 	:= GetArea()
Local cRet 		:= M->B4_COD
Local cQuery 	:= ""
Local cNextCod	:= "00"
Local cCodEsp	:= M->B4_01CAT3 
Default lCopia := .F.
                                                            
IF INCLUI .Or. lCopia
	
	cQuery := " SELECT MAX(SUBSTRING(SB4.B4_COD,5,3)) AS ULTCOD " + CRLF
	cQuery += " FROM " + RetSqlName("SB4") + " SB4 " + CRLF
	cQuery += " WHERE " + CRLF
	cQuery += " 	SB4.B4_FILIAL = '" + xFilial("SB4") + "' " + CRLF
	cQuery += " 	AND LTRIM(RTRIM(SB4.B4_01CAT3)) = '" + AllTrim(cCodEsp) + "' " + CRLF
	cQuery += " 	AND SB4.D_E_L_E_T_ = '' " + CRLF
	
	//������������������������
	//�Executa Query gerada  �
	//������������������������
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"TMPSB4",.T.,.T.)
	
	While TMPSB4->(!EOF())
		cNextCod := SOMA1(TMPSB4->ULTCOD)
		
		TMPSB4->(dbSkip())
	EndDo
	
	TMPSB4->(dbCloseArea())
	
	cRet := SubStr(cCodEsp,2,4)+cNextCod
	
EndIF

RestArea(aAreaAtu)

Return cRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GERADESC �Autor  � SYMM Consultoria   � Data �  19/09/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Geracao da descricao do produto pai automatico.            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � SYVAUX                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GERADESC()

Local cRet := M->B4_DESC

IF INCLUI
	cRet := ALLTRIM(M->B4_01DESMA) +  "/" + ALLTRIM(B4_01DCAT3) + "/" //+ ALLTRIM(B4_01DCAT4) + "/" + ALLTRIM(B4_01DCAT5)
EndIF
                                                                       
Return(cRet)
