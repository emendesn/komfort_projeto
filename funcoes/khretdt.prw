#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#Include "Ap5Mail.Ch"
#Include "xmlxfun.ch"
#INCLUDE "JPEG.CH"

#Define ENTER Chr(10)+Chr(13)

/*/
+------------------------------------------------------------------------------
| Descrição     | Função de Retorno de dias disponiveis para agenda técnica  
  Autor: Wellington Raul Pinto
  Data: 04/01/2019    
+------------------------------------------------------------------------------
/*/
USER FUNCTION KHRETDT(dData)

 	Local cAlias := ""
 	Local cAlias1:= ""
    Local cQuery := ""
    Local nVisit := 0
   	Local nMaxVi := 0
    Local nQtdDis:= 0
    Local cQtdDis := ""
   	
   	dbSelectArea("ZK5")
    cQuery := "SELECT ZK5_VIS as nQuantidadeMAxi"+ ENTER
    cQuery += " FROM "+ retSqlName("ZK5")+ " ZK5"+ ENTER
    cQuery += " WHERE ZK5_DATA = '"+dtos(dData)+"'"+ ENTER
    cQuery += " AND ZK5.D_E_L_E_T_ = ' '"+ ENTER
    
	cAlias1 := getNextAlias()
	PLSQuery(cQuery, cAlias1)
	DbSelectArea(cAlias1)
    (cAlias1)->(DbGoTop())      
     nMaxVi := val((cAlias1)->nQuantidadeMAxi)
   	(cAlias1)->(dbCloseArea())  	
   	    
	dbSelectArea("ZK4")
    cQuery := "SELECT COUNT(*) AS nQuantidade"+ ENTER
    cQuery += " FROM "+ retSqlName("ZK4")+ " ZK4"+ ENTER
    cQuery += " WHERE ZK4_DATA = '"+dtos(dData)+"'"+ ENTER
    cQuery += " AND ZK4.D_E_L_E_T_ = ' '"+ ENTER
  
	cAlias := getNextAlias()
	PLSQuery(cQuery, cAlias)
	DbSelectArea(cAlias)
	(cAlias)->(DbGoTop())      
     nVisit := (cAlias)->nQuantidade
    (cAlias)->(dbCloseArea())
     
     nQtdDis = nMaxVi - nVisit
     cQtdDis := cValtochar(nQtdDis)
	
return cQtdDis