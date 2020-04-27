#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �OMSA200P  �Autor  �ALFA	             � Data �  03/03/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para valida��o do estorno da carga        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION OMSA200P()

	LOCAL cQuery 	:= ""   
	local cAlias	:= GetNextAlias()	
	local lRet		:= .T.   
	Local aArea		:= GetArea()	
	        
	cQuery := "SELECT SF1.F1_DOC "
	cQuery += "FROM "+RetSqlName("SF1")+" SF1 "
	cQuery += "WHERE "
	cQuery += "SF1.F1_FILIAL = '"+xFilial("SF1")+"' AND "
	cQuery += "SF1.F1_XCARGA  = '"+ALLTRIM(paramixb[1])+"' AND "
	cQuery += "SF1.D_E_L_E_T_= ' ' 
	                                     
	cQuery    := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
    
	//Verifica se existe alguma nota de retira vinculada a carga

	dbselectarea(cAlias)
	IF !Eof()
		ALERT("Existem notas para retirada vinculadas a esta carga, por favor verificar!")
		lRet :=	.F.
	
	ENDIF           
	
	dbCloseArea() 
	RestArea(aArea)
	
RETURN(lRet)