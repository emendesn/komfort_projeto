#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#Include "Ap5Mail.Ch"
#Include "xmlxfun.ch"
#INCLUDE "JPEG.CH"

#Define ENTER Chr(10)+Chr(13)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ KMSACA16 º Autor ³ WELLINGTON RAUL P  º Data ³  29/11/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ TRAVA O PREENCHIMENTO DO CAMPO ACAO DE ACORDO COM O PERFIL º±±
±±ºDescricao ³ DO OPERADOR                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ KOMFORT HOUSE - SAC                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER FUNCTION KMSACA16(dData)

 	Local cAlias := ""
 	Local cAlias1 := ""
    Local cQuery := ""
    Local nVisit := 0
   	Local nMaxVi := 0
   	Local lRet := .T.
   	Local nQtdDis := 0
  
   	
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
     If nVisit >= nMaxVi
     lRet := .F.
     MsgStop("Quantidade Máxima de Visitas Atingida: " + cvaltochar(nMaxVi), "KMSACA16")
     Else 
     MsgInfo("Data Disponível: " + dtoc(dData) + " Quantidades disponíves para agendamento :" + cValtochar(nQtdDis), "KMSACA16")
     lRet:= .T.
     EndIf
 
 Return lRet
		

