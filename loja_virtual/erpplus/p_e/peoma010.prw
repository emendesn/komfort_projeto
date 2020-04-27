#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "parmtype.ch"

USER FUNCTION OMSA010()
	Local aArea 	:= GetArea()
	Local xRet		:= .T.
	Local aParam	:= PARAMIXB
	Local oObj
	Local cIdPonto
	Local cIdModel 
	Local lIsGrid
	Local oModel
	Local oModelDA1
	Local cQuery	:= ""
	Local nAux		:= 0

	If aParam <> Nil
        oObj := aParam[1]
        cIdPonto := aParam[2]
        cIdModel := aParam[3]
        lIsGrid := (Len(aParam) > 3)	
        
//        CONOUT(cIdPonto)		
		If UPPER(ALLTRIM(cIdPonto)) == "FORMCOMMITTTSPRE"
			oModel   := FWModelActive()
			
			// Inclusão ou Alteração do Cabeçalho
			If ( oModel:nOperation == 4 .AND. ;
			     (oModel:GetValue("DA0MASTER","DA0_CODTAB") <> DA0->DA0_CODTAB .OR. ;
        	     oModel:GetValue("DA0MASTER","DA0_DATDE") <> DA0->DA0_DATDE .OR. ;
        	     oModel:GetValue("DA0MASTER","DA0_HORADE") <> DA0->DA0_HORADE .OR. ;
        	     oModel:GetValue("DA0MASTER","DA0_DATATE") <> DA0->DA0_DATATE .OR. ;
        	     oModel:GetValue("DA0MASTER","DA0_HORATE") <> DA0->DA0_HORATE ))
        	     
				If oModel:GetValue("DA0MASTER","DA0_ECFLAG") <> "1"
					return xRet//Sai do P.E se não estiver marcado como E-Commerce
				Endif
//        		Alert("incluir todos 1")   		
       			oModelDA1 := oModel:GetModel("DA1DETAIL")
				For nAux := 1 To oModelDA1:Length()
					oModelDA1:GoLine( nAux )
					
//					Alert(oModelDA1:GetValue("DA1_CODPRO"))		
					If oModelDA1:IsDeleted()
						Alert("Deletado")
					Else
			        	Z08->(dbSetOrder(1))
			        	//Z08_FILIAL+Z08_STATUS+Z08_PRODUT+Z08_CODTAB+Z08_ITEM+DTOS(Z08_DTINC)+Z08_HRINC
			        	Z08->(dbSeek(xFILIAL("Z08")+oModelDA1:GetValue("DA1_CODTAB")+oModelDA1:GetValue("DA1_CODPRO")+oModelDA1:GetValue("DA1_ITEM")))
			        	If !Z08->(Found())
				        	Z08->(RecLock("Z08",.T.))
				        	Z08->Z08_FILIAL  := Z08->(xFILIAL("Z08"))
				        	Z08->Z08_STATUS  := oModelDA1:GetValue("DA1_ATIVO")
				        	Z08->Z08_PRODUT  := oModelDA1:GetValue("DA1_CODPRO")
				        	Z08->Z08_CODTAB	 := oModel:GetValue("DA0MASTER","DA0_CODTAB")
				        	Z08->Z08_ITEM	 := oModelDA1:GetValue("DA1_ITEM")
				        	Z08->Z08_PRCPOR  := oModelDA1:GetValue("DA1_PRCVEN")				        	
				        	Z08->Z08_DTVIGE	 := oModelDA1:GetValue("DA1_DATVIG")
				        	Z08->Z08_DTINC   := dDataBase
				        	Z08->Z08_HRINC   := TIME()
				        	Z08->Z08_INTEGI   := "S"
				        	Z08->(MsUnLock())
				        Else
				        	Z08->(RecLock("Z08",.F.))
				        	Z08->Z08_STATUS  := oModelDA1:GetValue("DA1_ATIVO")
				        	Z08->Z08_PRODUT := oModelDA1:GetValue("DA1_CODPRO")
				        	//Z08->Z08_CODTAB	:= oModel:GetValue("DA0MASTER","DA0_CODTAB")
				        	Z08->Z08_PRECO  := oModelDA1:GetValue("DA1_PRCVEN")
				        	Z08->Z08_DTVIGE	:= oModelDA1:GetValue("DA1_DATVIG")
				        	//Z08->Z08_INTEG	 := 'S'
				        	Z08->Z08_DTINC   := dDataBase
				        	Z08->Z08_HRINC   := TIME()
				        	Z08->Z08_INTEGI   := "S"
				        	Z08->(MsUnLock())				        	
				        Endif
					Endif
				Next nAux
			
			Endif
			
		ElseIf UPPER(ALLTRIM(cIdPonto)) == "MODELCOMMITTTS"
			oModel   := FWModelActive()
			
			// Inclusão ou Alteração do Cabeçalho
			If (oModel:nOperation == 3)
        	     
//        		Alert("incluir todos 2")
			
				cQuery := " SELECT "
				cQuery += "   DA1_CODTAB , DA1_ITEM , DA1_CODPRO , B1_PRV1 , DA1_PRCVEN , DA1_ATIVO,DA1_PRECO"
				cQuery += " FROM "
				cQuery += "   "+ DA1->(RetSQLName("DA1")) +" DA1 "
				cQuery += "   INNER JOIN "+ SB1->(RetSQLName("SB1")) +" SB1 ON "
				cQuery += "     B1_FILIAL = '"+ SB1->(xFILIAL("SB1")) +"' AND B1_COD = DA1_CODPRO "
				cQuery += "     AND SB1.D_E_L_E_T_ = ' ' "
				cQuery += " WHERE "
				cQuery += "   DA1_FILIAL = '"+ DA1->(xFILIAL("DA1")) +"' AND DA1_CODTAB = '"+ oModel:GetValue("DA0MASTER","DA0_CODTAB") +"' "
				cQuery += "   AND DA1.D_E_L_E_T_ = ' ' "
				cQuery += " ORDER BY "
				cQuery += "   DA1_ITEM "
				TcQuery cQuery Alias TDA1A New
				
				TDA1A->(dbGoTop())
				While !TDA1A->(EOF())
        		// Inclusão do produto para integração 
		        	Z08->(dbSetOrder(1))
		        	
		        	Z08->(dbSeek(xFILIAL("Z08")+TDA1A->DA1_CODTAB+TDA1A->DA1_CODPRO+TDA1A->DA1_ITEM))
		        	If !Z08->(Found())
			        	Z08->(RecLock("Z08",.T.))
			        	Z08->Z08_FILIAL  := Z08->(xFILIAL("Z08"))
			        	Z08->Z08_STATUS  := TDA1A->DA1_ATIVO
			        	Z08->Z08_PRODUT := TDA1A->DA1_CODPRO
			        	Z08->Z08_CODTAB	:= TDA1A->DA1_CODTAB
			        	Z08->Z08_ITEM	:= TDA1A->DA1_ITEM
			        	Z08->Z08_DTVIGE	:= TDA1A->DA1_DATVIG
			        	Z08->Z08_DTINC   := dDataBase
			        	Z08->Z08_HRINC   := TIME()
			        	//Z08->Z08_PRCPOR  := 
			        	Z08->Z08_INTEG	 := 'S'
			        	Z08->(MsUnLock())
			        Else
			        	Z08->(RecLock("Z08",.F.))
			        	Z08->Z08_STATUS  := TDA1A->DA1_ATIVO
			        	Z08->Z08_DTVIGE	:= TDA1A->DA1_DATVIG
			        	Z08->Z08_DTINC   := dDataBase
			        	Z08->Z08_HRINC   := TIME()
			        	Z08->Z08_PRECO	 := TDA1->DA1_PRCVEN
			        	//Z08->Z08_PRCPOR  := 
			        	Z08->Z08_INTEG	 := 'S'
			        	Z08->(MsUnLock())
			        Endif 
				
					TDA1A->(dbSkip())
				Enddo
				TDA1A->(dbCloseArea())

			// Se for alteração dos itens
			Elseif oModel:nOperation == 4 .AND. ;
			     oModel:GetValue("DA0MASTER","DA0_CODTAB") == DA0->DA0_CODTAB .AND. ;
        	     oModel:GetValue("DA0MASTER","DA0_DATDE") == DA0->DA0_DATDE .AND. ;
        	     oModel:GetValue("DA0MASTER","DA0_HORADE") == DA0->DA0_HORADE .AND. ;
        	     oModel:GetValue("DA0MASTER","DA0_DATATE") == DA0->DA0_DATATE .AND. ;
        	     oModel:GetValue("DA0MASTER","DA0_HORATE") == DA0->DA0_HORATE
        	     
        		oModelDA1 := oModel:GetModel("DA1DETAIL")
				For nAux := 1 To oModelDA1:Length()
					oModelDA1:GoLine( nAux )
					
					If oModelDA1:IsDeleted()
						Alert("Deletado")
					Elseif oModelDA1:IsInserted() .OR. oModelDA1:IsUpdated()
			        	Z08->(dbSetOrder(1))
			        	//Z08_FILIAL+Z08_STATUS+Z08_PRODUT+Z08_CODTAB+Z08_ITEM+DTOS(Z08_DTINC)+Z08_HRINC
			        	Z08->(dbSeek(xFILIAL("Z08")+oModelDA1:GetValue("DA1_CODTAB")+oModelDA1:GetValue("DA1_CODPRO")+oModelDA1:GetValue("DA1_ITEM")))
			        	If !Z08->(Found())
				        	Z08->(RecLock("Z08",.T.))
				        	Z08->Z08_FILIAL  := Z08->(xFILIAL("Z08"))
				        	Z08->Z08_STATUS  := oModelDA1:GetValue("DA1_ATIVO")
				        	Z08->Z08_PRODUT := oModelDA1:GetValue("DA1_CODPRO")
				        	Z08->Z08_CODTAB	 := oModel:GetValue("DA0MASTER","DA0_CODTAB")
				        	Z08->Z08_ITEM	 := oModelDA1:GetValue("DA1_ITEM")
				        	Z08->Z08_PRECO  := oModelDA1:GetValue("DA1_PRCVEN")
				        	Z08->Z08_DTVIGE	:= oModelDA1:GetValue("DA1_DATVIG")
				        	//Z08->Z08_DESCTB := oModelDA1:GetValue("DA1_DESCRI")
				        	Z08->Z08_DTINC   := dDataBase
				        	Z08->Z08_INTEGI	 := 'S'
				        	Z08->Z08_HRINC   := TIME()
				        	Z08->(MsUnLock())
				        Else
				        	Z08->(RecLock("Z08",.F.))
				        	Z08->Z08_PRECO  := oModelDA1:GetValue("DA1_PRCVEN")
				        	Z08->Z08_PRCPOR := POSICIONE("SB1",1,xFilial("SB1") + oModelDA1:GetValue("DA1_CODPRO"),"B1_PRV1" )
				        	Z08->Z08_DTVIGE	:= oModelDA1:GetValue("DA1_DATVIG")
				        	//Z08->Z08_DESCTB := oModelDA1:GetValue("DA1_DESCRI")
				        	Z08->Z08_INTEGI	 := 'S'
				        	Z08->Z08_DTINC   := dDataBase
				        	Z08->Z08_HRINC   := TIME()
				        	Z08->(MsUnLock())
				        Endif
					Endif
				Next nAux
			Endif
	    Endif
	    
	Endif	
	
	RestArea(aArea)
RETURN xRet