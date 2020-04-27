//Bibliotecas
#Include 'RwMake.ch'
#Include 'Protheus.ch'
#Include 'TopConn.ch'
 
//Constantes
#Define STR_PULA        Chr(13)+Chr(10)
 
/*--------------------------------------------------------------------*
 | P.E.:  M460MARK - Marcio Nunes - KomfortHouse -06/05/2019                      |
 | Desc:  permite faturar apenas itens agregados, processo manual     |
 *-------------------------------------------------------------------*/
  
User Function M460MARK()
    Local aArea 	:= GetArea()
    Local aAreaC9   := SC9->(GetArea())
    Local aAreaC5   := SC5->(GetArea())
    Local lRet      := .T.    
    Local cMarca    := ParamIXB[1]
    Local lInverte  := ParamIXB[2]
    Local cSQL      := ""
    Local cMens     := ""
    Local cMensBoni := ""
    Local cMensAux 	:= ""
    Local cPedsMark := ""
    Local nX		:= 0
    Local nY		:= 0 
    Local cPedido 	:= ""
	Local cCliente	:= ""
	Local cLoja		:= "" 
     
    Pergunte("MT461A", .F.)  
    
    If FunName() == "MATA460A" 
    
    	SC9->(DbGoTop())
	   	While (SC9->(!EOF()))
	    	If (SC9->C9_OK == cMarca)

				DbSelectArea("SB1")
				SB1->(DbSetOrder(1))
				SB1->(DbGoTop())
				
				If (SB1->(DbSeek(xFilial("SB1")+SC9->C9_PRODUTO)))
					If SB1->B1_XACESSO =='1'                   
					    cPedido := SC9->C9_PEDIDO //selecione apenas 1 pedido por x para faturar
					    cCliente:= SC9->C9_CLIENTE
					    cLoja 	:= SC9->C9_LOJA
						nX += 1 // Total de registros marcados 
					Else
						MSGInfo('Somente Agregados podem ser Faturados.',"Atenção")  
				        lRet:=.F.						
					EndIf
				EndIf				
   			EndIf                            
   		SC9->(DbSkip())
	    EndDo
    
	    If lRet
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
		        lRet:=.F.		    
		    EndIf
		    QRY_SC9->(DbCloseArea()) 
	 	EndIf    
	         
	    RestArea(aAreaC5)
	    RestArea(aAreaC9)
	    RestArea(aArea) 
	EndIf
     
    //Restaurando a pergunta do botão Prep.Doc.
    Pergunte("MT460A", .F.)
Return lRet