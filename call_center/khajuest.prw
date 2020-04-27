#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"

#DEFINE ENTER CHR(13)+CHR(10)

//--------------------------------------------------------------
/*/{Protheus.doc} KHAJUEST
Description //KHAJUEST - Ajusta estoque empenhado com base na tabela SC6
Ao encontrar SC6 determina a quantidade deleta a SBF e ajusta o campo B2_RESERVA 
Para executar o ajuste das tabelas e empenhar a fila do SAC para todos os produtos execute: U_KHAJUEST() 
Para executar o ajuste das tabelas e empenhar a fila do SAC apenas um produtos execute:U_KHAJUEST('CODPRODUTO') 
Para empenhar a fila do sac por produto execute U_KHAJUEST('CODPRODUTO',.T.) 
@since 10/06/2019 /*/
//--------------------------------------------------------------
User Function KHAJUEST(cProduto,lAjusac)

	Local cQuery	:= ""
	Local cAlias 	:= getNextAlias()                                                    
	Local _cEmp 	:= ""
	Local _cFil 	:= ""	

    Default cProduto := ""             
    Default lAjusac  := .F.
                            
   	//Variaveis para iniciar o ambiente                        
	_cEmp 	:= "01"
	_cFil 	:= "0101"
	//Chamada por Schedule, para ajuste dos pedidos que foram extornados e podem ser emepnhados novamente.
	Prepare Environment Empresa _cEmp Filial _cFil TABLES "SM0","SUA","SUB","SC5","SC6","SA1","SC9","SB2","SB1","SBF","SDB" MODULO 'TMK' 
    
    If lAjusac
	    U_KHAJUSAC(cProduto)
	Else   
	    					    
	    //SELECIONO A QUANTIDADE DE PRODUTOS PARA UTILIZAR ABAIXO
	    //Verifica a quantidade de registros na SBF que não tem SB6
		cQuery := "SELECT BF_PRODUTO FROM SBF010 (NOLOCK)  " + ENTER
		cQuery += " WHERE BF_LOCAL = '01' " + ENTER
		cQuery += "	AND D_E_L_E_T_ = '' " + ENTER                               
		cQuery += "	AND BF_EMPENHO > 0 " + ENTER
		cQuery += "	AND BF_QUANT > 0 " + ENTER
		cQuery += "	AND BF_LOCALIZ  NOT IN ( " + ENTER
		cQuery += "	SELECT C6_LOCALIZ FROM SC6010(NOLOCK) " + ENTER
		cQuery += "	WHERE C6_LOCAL = '01'  " + ENTER 
		cQuery += "	AND D_E_L_E_T_ = '' " + ENTER	
		cQuery += "	AND C6_NOTA = '' " + ENTER                                         
		cQuery += "	AND C6_LOCALIZ <> '' " + ENTER 		
		cQuery += "	AND C6_BLQ = '' )" + ENTER		
		cQuery += "	GROUP BY BF_PRODUTO" + ENTER  		      
	
		PLSQuery(cQuery, cAlias)   
		
		While (cAlias)->(!Eof())//QUANTIDADE DE PRODUTOS PARA AJUSTE AGRUPADOS
			
			//Chamada da função para ajuste e epenho dos produtos selecionados
			U_KHAJUSAC((cAlias)->BF_PRODUTO)		   	  
		   		   	
			(cAlias)->(DbSkip())		
			
		EndDo   	   
	    
		(cAlias)->(DbCloseArea())
	EndIf   	                                    	
	
	//Query do Wellington, tras por produto e Pedido (Todos que estão com divergência sem data de filtro
	//ESTA QUERY RETORNA PRODUTOS SEM PEDIDO DE VENDA E SEM EMPENHO, OS NÃO EMPENHADOS É NECESSÁRIO ANALISAR	
	//cQuery9 := "SELECT C6_PRODUTO, C6_NUM FROM SC6010 (NOLOCK) SC6 " + ENTER 
	cQuery9 := "SELECT C6_PRODUTO FROM SC6010 (NOLOCK) SC6 " + ENTER 
    cQuery9 += " INNER JOIN SM0010 (NOLOCK) SM0 ON SC6.C6_MSFIL = SM0.FILFULL " + ENTER 
    cQuery9 += " INNER JOIN SC5010 (NOLOCK) SC5 ON SC5.C5_MSFIL = SC6.C6_MSFIL AND SC5.C5_NUM = SC6.C6_NUM  " + ENTER 
	cQuery9 += " LEFT JOIN SC9010 (NOLOCK) SC9 ON SC6.C6_NUM = SC9.C9_PEDIDO AND SC6.C6_PRODUTO = SC9.C9_PRODUTO AND SC6.C6_ITEM = SC9.C9_ITEM AND SC9.D_E_L_E_T_ = '' " + ENTER 
    cQuery9 += " INNER JOIN SB1010 (NOLOCK) B1 ON B1_COD = C6_PRODUTO " + ENTER 
    cQuery9 += " INNER JOIN SA1010 (NOLOCK) SA1 ON SA1.A1_COD = C5_CLIENT AND SA1.A1_LOJA = SC5.C5_LOJACLI " + ENTER 
    cQuery9 += " WHERE SC6.D_E_L_E_T_ = ' ' AND C5_XPRIORI <> '1' AND C5_NOTA = '' AND SC5.D_E_L_E_T_ = ' ' " + ENTER 
    //cQuery9 += " AND (CASE WHEN C9_BLEST IS NULL THEN 'NAO-LIB' ELSE 'LIB' END) = 'NAO-LIB'  " + ENTER 
    cQuery9 += " AND C6_BLQ <> 'R' AND C6_NOTA = '' AND C6_LOCAL = '01' AND C6_PRODUTO " + ENTER 
    cQuery9 += " IN ( SELECT  B2_COD FROM " + retSqlname('SB2')+ "(NOLOCK) B2 " + ENTER 
    cQuery9 += "  INNER JOIN SB1010 (NOLOCK) B1 ON B1.B1_COD = B2.B2_COD  " + ENTER  
    cQuery9 += "  WHERE B2.D_E_L_E_T_ = '' AND B2_QATU > B2_RESERVA " + ENTER 
    //cQuery9 += "  AND B1.B1_XENCOME = '2'  " + ENTER //Produtos de giro
    cQuery9 += "  AND B2_LOCAL = '01' AND B2_FILIAL = '0101') AND C6_LOCALIZ <>'' " + ENTER
    //cQuery9 += "  AND B1_COD='' " + ENTER
	cQuery9 += "  GROUP BY C6_PRODUTO    " + ENTER //PRODUTOS AGRUPADOS POIS A ROTINA DE AJUSTE NÃO PRECISA DO PEDIDO PARA AJUSTAR
    
	cAlias9 := getNextAlias()     
		
	PLSQuery(cQuery9, cAlias9)	                 
	While (cAlias9)->(!eof())                             
		U_KHAJUSAC((cAlias9)->C6_PRODUTO)  	    			   	
	   	(cAlias9)->(DbSkip())                                   
	EndDo   		
	

Return 


//--------------------------------------------------------------
/*/{Protheus.doc} KHAJUSAC
Description //KHAJUSAC - Função responsável por ajustar o empenho do SAC
@since 10/06/2019 /*/
//-------------------------------------------------------------- 

User Function KHAJUSAC(cProd)

Local nAjuB2		:= 0
Local cLocal		:= ""
Local cCod			:= ""   
Local lEmpe			:= .T.
Local cAlias2 		:= getNextAlias()
Local cAlias5 	:= getNextAlias()

Default	cProd 		:= ""          

// 1º - Ajuste da tabela SC6
//LIMPA SC6 C6_LOCALIZ (ANTES DE EMPENHAR) QUE NÃO TEM SBF
cQuery5 := "SELECT C6_NUM, C6_ITEM, C6_PRODUTO, C6_LOCALIZ FROM SC6010 (NOLOCK) " + ENTER 
cQuery5 += " WHERE C6_PRODUTO ='"+ cProd +"' " + ENTER 
cQuery5 += " AND D_E_L_E_T_ = '' " + ENTER 
cQuery5 += " AND C6_NOTA = '' " + ENTER 
cQuery5 += " AND C6_BLQ = '' " + ENTER 
cQuery5 += " AND C6_LOCALIZ <>'' " + ENTER                    
cQuery5 += " AND C6_LOCALIZ NOT IN( " + ENTER 
cQuery5 += " SELECT BF_LOCALIZ FROM SBF010 (NOLOCK) " + ENTER 
cQuery5 += " WHERE BF_PRODUTO = '"+ cProd +"' " + ENTER 
cQuery5 += " AND D_E_L_E_T_ = '' " + ENTER 
cQuery5 += " AND BF_EMPENHO > 0 " + ENTER       
cQuery5 += " AND BF_QUANT > 0 ) " + ENTER 
 
PLSQuery(cQuery5, cAlias5) 

While (cAlias5)->(!Eof())//QUANTIDADE DE SC6 LOZALIZ SEM SBF		

	DbSelectArea("SC6")
	SC6->(DbSetOrder(1))   

	If SC6->(dbSeek(Xfilial("SC6")+(cAlias5)->C6_NUM+(cAlias5)->C6_ITEM+(cAlias5)->C6_PRODUTO))	
		RecLock("SC6",.F.)
			SC6->C6_LOCALIZ := ''
		SC6->(MsUnlock())
   	EndIf   		
	(cAlias5)->(DbSkip())   		
	
EndDo 

//2º Recebe o produto e ajusta o Empenho BF_EMPENHO - SBF que não tem na SC6
cQuery2 := "SELECT BF_PRODUTO, BF_LOCALIZ, BF_EMPENHO, BF_LOCAL, BF_EMPENHO FROM SBF010 (NOLOCK)  " + ENTER
cQuery2 += " WHERE BF_LOCAL = '01' " + ENTER
cQuery2 += " AND BF_PRODUTO = '"+ cProd +"'" + ENTER
cQuery2 += " AND D_E_L_E_T_ = '' " + ENTER                               
cQuery2 += " AND BF_EMPENHO > 0 " + ENTER
cQuery2 += " AND BF_QUANT > 0 " + ENTER
cQuery2 += " AND BF_LOCALIZ  NOT IN ( " + ENTER
cQuery2 += " SELECT C6_LOCALIZ FROM SC6010(NOLOCK) " + ENTER
cQuery2 += " WHERE C6_LOCAL = '01'  " + ENTER 
cQuery2 += " AND C6_PRODUTO = '"+ cProd +"'" + ENTER	   
cQuery2 += " AND D_E_L_E_T_ = '' " + ENTER	
cQuery2 += " AND C6_NOTA = '' " + ENTER
cQuery2 += " AND C6_LOCALIZ <> '' " + ENTER
cQuery2 += " AND C6_BLQ = '' )" + ENTER		
cQuery2 += " ORDER BY BF_PRODUTO" + ENTER		

PLSQuery(cQuery2, cAlias2)

While (cAlias2)->(!Eof())

	DbSelectArea("SBF")
	SBF->(DbSetOrder(1))   

	If SBF->(dbSeek(Xfilial("SBF")+(cAlias2)->BF_LOCAL+(cAlias2)->BF_LOCALIZ+(cAlias2)->BF_PRODUTO))	
		RecLock("SBF",.F.)
			SBF->BF_EMPENHO := 0
		SBF->(MsUnlock())  		
 	EndIf   		
	(cAlias2)->(DbSkip())   	
	
EndDo 

//3º Consulta Fila e ajusta a tabela - Ajuste da query pois estava duplicando as linhas com Inner Join da SB1, prejudicando O B2_RESERVA 
cQuery7 := "SELECT C6_NUM,C6_ITEM,C6_PRODUTO,C6_QTDVEN,C6_LOCAL,C6_LOCALIZ, SC6.R_E_C_N_O_ AS RECSC6" + ENTER
cQuery7 += " FROM "+ RetSqlName("SC6")+" (NOLOCK) SC6" + ENTER
cQuery7 += " WHERE SC6.D_E_L_E_T_ = ' '" + ENTER
cQuery7 += " AND C6_BLQ <> 'R'" + ENTER
cQuery7 += " AND C6_NOTA = ''" + ENTER
cQuery7 += " AND C6_LOCAL = '01'" + ENTER
cQuery7 += " AND C6_PRODUTO = '"+ cProd +"'" + ENTER
cQuery7 += " ORDER BY C6_NUM, C6_ITEM" + ENTER	    		      

//Somar a quantidade de registros com localização preenchidos na C6 para atualizar a SB2->B2_RESERVA
//Ajusta a Reserva maior que a quantidade empenhada na SC6  
cAlias7 := getNextAlias()

PLSQuery(cQuery7, cAlias7)

While (cAlias7)->(!eof())                            
   	//Conta a quantidade de registros com Lozaliz para atualiza a SB2   	
	cLocal 	:= (cAlias7)->C6_LOCAL   		 
	cCod	:= (cAlias7)->C6_PRODUTO
	If !Empty((cAlias7)->C6_LOCALIZ)
		nAjuB2	+= 1
	EndIf
	(cAlias7)->(DbSkip())                      
EndDo
                               	
DBSelectArea("SB2")
DBSetOrder(2) 
DbGoTop()
IF DBSeek(xFilial("SB2")+Alltrim(cLocal)+Alltrim(cCod)) 
	If (SB2->B2_RESERVA > nAjuB2)   
		Reclock("SB2",.F.)
			SB2->B2_RESERVA := nAjuB2
		SB2->(MsUnlock())		
	ElseIf (SB2->B2_RESERVA < nAjuB2)   //Para reserva menor que a SC6, somente ajustar a SB2, pois o empenho está correto
		Reclock("SB2",.F.)
			SB2->B2_RESERVA := nAjuB2
		SB2->(MsUnlock())                        
		lEmpe :=.F.      
	EndIf                        
EndIf	
SB2->(DbCloseArea())                                                          
      
cAlias7 := getNextAlias()

PLSQuery(cQuery7, cAlias7)                                    

While (cAlias7)->(!Eof())
	If Empty((cAlias7)->C6_LOCALIZ) .And. lEmpe//Atualizo apenas os registros que não tem localização

	   	//Chamada da função para reprocessar a fila
	   	U_fSBF((cAlias7)->C6_NUM,(cAlias7)->C6_ITEM,(cAlias7)->C6_PRODUTO,(cAlias7)->C6_LOCAL,(cAlias7)->C6_QTDVEN)
	   	
	EndIf
   	(cAlias7)->(DbSkip())                                  
EndDo

Return