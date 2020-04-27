//Bibliotecas
#Include 'RwMake.ch'
#Include 'Protheus.ch'
#Include 'TopConn.ch'
 
//Constantes
#Define STR_PULA        Chr(13)+Chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ M460MARK ³ Autor ³ Marcos Milare    	    ³ Data ³ 09/06/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Valida geracao da NF do PV com PC de recompra nao liberado. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Ponto de Entrada na geracao da nota fiscal.                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR      ³  DATA      ³ MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/ 
  
User Function M460MARK()
Local _aArea 	:= GetArea()
Local aAreaC9   := SC9->(GetArea())
Local aAreaC5   := SC5->(GetArea())
Local _lRet     := .T.    
Local cMarca   := ParamIXB[1]
Local _lInvert  := ParamIXB[2]
Local cSQL      := ""
Local nX		:= 0
Local nY		:= 0 
Local cPedido 	:= ""             
Local cCliente	:= ""
Local cLoja		:= ""
Local cQuery	:= ""

Local _cQuery   := ""
Local _cAlias 	:= GetNextAlias()
Local _lMarca   := .F.
Local _lFatPar := GetMv("KH_FATPARC",,.F.)   

 /*-------------------------------------------------------------------*
 | P.E.:  M460MARK - Marcio Nunes - KomfortHouse -06/05/2019          |
 | Desc:  permite faturar apenas itens agregados, processo manual     |
 *-------------------------------------------------------------------*/
     
Pergunte("MT461A", .F.)  
    
If FunName() == "MATA460A" 

	//Seleciona os pedidos marcados
	DbSelectArea("SC9")
	SC9->(DbSetOrder(2))//C9_FILIAL+C9_CLIENTE+C9_LOJA+C9_PEDIDO+C9_ITEM
	SC9->(DbGoTop())
	
	_cQuery := " SELECT * "
	_cQuery += " FROM "+RetSqlName("SC9")+" SC9 (NOLOCK) "
	_cQuery += " WHERE SC9.D_E_L_E_T_ <> '*' AND SC9.C9_NFISCAL =''"
	_cQuery += " AND C9_OK = '"+cMarca+"' "

	//Executando a Cláusula
	cQuery := ChangeQuery(_cQuery)
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),_cAlias,.T.,.T.)     
    
	(_cAlias)->(DbGoTop())                                  
   	While (_cAlias)->(!EOF())
    	If (Alltrim((_cAlias)->C9_OK) == Alltrim(cMarca))   

			DbSelectArea("SB1")
			SB1->(DbSetOrder(1))                                           
			SB1->(DbGoTop())
			
			If (SB1->(DbSeek(xFilial("SB1")+(_cAlias)->C9_PRODUTO)))    
				If SB1->B1_XACESSO =='1'                   
				    cPedido := (_cAlias)->C9_PEDIDO //selecione apenas 1 pedido por x para faturar
				    cCliente:= (_cAlias)->C9_CLIENTE
				    cLoja 	:= (_cAlias)->C9_LOJA
					nX += 1 // Total de registros marcados 
				Else                                                               
					MSGInfo('Somente Agregados podem ser Faturados.',"Atenção")  
			        _lRet:=.F.		   	        
			        Exit						
				EndIf
			EndIf				
   		EndIf                            
   		(_cAlias)->(DbSkip())
    EndDo
    
    If _lRet
	    //Criando a consulta.
	    //Permite faturar apenas produtos agregados.
	    cSQL += " SELECT "                                          + STR_PULA 
	    cSQL += "  C9_PEDIDO, B1_COD, B1_DESC, B1_XACESSO "         + STR_PULA
	    cSQL += " FROM "+RetSQLName("SC9")+" SC9 "                  + STR_PULA
	    cSQL += "   INNER JOIN "+RetSQLName("SB1")+" SB1 ON ("      + STR_PULA
	    cSQL += "       SB1.D_E_L_E_T_='' "                         + STR_PULA
	    cSQL += "       AND B1_COD = C9_PRODUTO"                    + STR_PULA
	    cSQL += "   ) "                                             + STR_PULA
	    cSQL += " WHERE SC9.D_E_L_E_T_ = ' ' "                      + STR_PULA
	    cSQL += "  AND C9_FILIAL='"+FWxFilial("SC9")+"' "           + STR_PULA
	    cSQL += "  AND C9_PEDIDO = '"+cPedido+"' "      	 		+ STR_PULA
	  	cSQL += "  AND C9_CLIENTE = '"+cCliente+"' "      		   	+ STR_PULA
	  	cSQL += "  AND C9_LOJA = '"+cLoja+"' "	         		   	+ STR_PULA  	  	
	    cSQL += "  AND SB1.B1_XACESSO='1'		"               	+ STR_PULA
	                                       
	    //Executando a Cláusula
	    TCQuery cSQL NEW ALIAS QRY_SC9      
	    //Indo ao top e verificando se há registros 
	    QRY_SC9->(DbGoTop())
	    While (QRY_SC9->(!EOF()))    
	        nY += 1
	        QRY_SC9->(DbSkip())          
	    EndDo     
	    If !(nX == nY)
	    	MSGInfo('Selecione todos os agregados do Pedido para Faturar.',"Atenção")      
	        _lRet:=.F.		    
	    EndIf
	    QRY_SC9->(DbCloseArea()) 
 	EndIf    
         
    RestArea(aAreaC5)
    RestArea(aAreaC9)	     
Else

	If !_lFatPar
	
		DbSelectArea("SC9")
		SC9->(DbSetOrder(2))//C9_FILIAL+C9_CLIENTE+C9_LOJA+C9_PEDIDO+C9_ITEM
		SC9->(DbGoTop())
	
		_cQuery := " SELECT * "
		_cQuery += " FROM "+RetSqlName("SC6")+" SC6 (NOLOCK) "
		_cQuery += " WHERE SC6.D_E_L_E_T_ <> '*' "
		_cQuery += " AND C6_NUM IN ( SELECT C9_PEDIDO "
		_cQuery += " FROM "+RetSqlName("SC9")+" SC9 (NOLOCK) "
		_cQuery += " WHERE SC9.D_E_L_E_T_ <> '*' "
		
		If _lInvert
			_cQuery += " AND C9_OK <> '"+cMarca+"' "
		Else
			_cQuery += " AND C9_OK = '"+cMarca+"' "
		EndIf
		
		_cQuery += " AND C9_NFISCAL = '' "
		_cQuery += " AND C9_BLEST = '' "
		_cQuery += " AND C9_BLCRED = '' ) "
		_cQuery += " ORDER BY C6_FILIAL, C6_NUM, C6_ITEM "
	
		cQuery := ChangeQuery(_cQuery)
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),_cAlias,.T.,.T.)
	
		(_cAlias)->(DbGotop())
		While (_cAlias)->(!Eof())
		
			If SC9->(DbSeek((_cAlias)->C6_FILIAL+(_cAlias)->C6_CLI+(_cAlias)->C6_LOJA+(_cAlias)->C6_NUM+(_cAlias)->C6_ITEM,.T.))				
				
				If SC9->C9_QTDLIB <> (_cAlias)->C6_QTDVEN				
					MsgStop("Não é permitido o faturamento de quantidade parcial dos itens do pedido!","NOFATPER1")
					_lRet := .F.				
				Else				
					_lMarca := (IIF(_lInvert,AllTrim(cMarca)<>Alltrim(SC9->C9_OK),AllTrim(cMarca)==Alltrim(SC9->C9_OK)))				
					If !_lMarca					
						MsgStop("Não é permitido o faturamento parcial do pedido!","NOFATPER2")
						_lRet := .F.					
					EndIf					
				EndIf							
				
			Else			
				MsgStop("Não é permitido o faturamento parcial do pedido!","NOFATPER3")
				_lRet := .F.			
			EndIf

			(_cAlias)->(DbSkip())
				
		EndDo

		(_cAlias)->(DbCloseArea())  

	EndIf										

EndIf

RestArea(_aArea)
     
//Restaurando a pergunta do botão Prep.Doc.
Pergunte("MT460A", .F.)

Return _lRet