#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SYVM104  ºAutor  ³Eduardo Patriani    º Data ³  11/02/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Geracao das Ordens de Compras do produtos de encomenda.    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SYVM104(lAuto,dDataIni,dDataFim,cFilAtu)

Local cCadastro 	:= OemToAnsi("Geração das Ordens de Compras")
Local cPerg		:= Padr('SYVM104',10)
Local aSays	  	:= {}
Local aButtons		:= {}
Local nOpca		:= 0

Private aProdutos := {}

Default lAuto		:= .T.
Default dDataIni	:= Ctod("")
Default dDataFim	:= Ctod("")
Default cFilAtu		:= xFilial("SUA")

m104SX1(cPerg)

Pergunte(cPerg,lAuto)

AADD(aSays,OemToAnsi( "Este programa tem como objetivo gerar as ordens de compra, "))
AADD(aSays,OemToAnsi( "do produtos vendidos como encomenda."))

AADD(aButtons, { 5,lAuto,{|| Pergunte(cPerg,.T. ) } } )
AADD(aButtons, { 1,.T.,{|| nOpca := 1,FechaBatch() }} )
AADD(aButtons, { 2,.T.,{|| nOpca := 0,FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )
If nOpca == 1
	oProcess:= MsNewProcess():New({|lEnd| CarregaProd(lAuto,dDataIni,dDataFim,cFilAtu) },"Aguarde", "Carregando produtos ...",.F.)
	oProcess:Activate()
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CarregaProdºAutor ³Eduardo Patriani    º Data ³  11/02/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carregas os produtos conforme os parametros.               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CarregaProd(lAuto,dDataIni,dDataFim,cFilAtu)

Local aArea  := GetArea()
Local cAlias := GetNextAlias()
Local cLocDep:= GetMv("MV_SYLOCDP",,"100001")
Local xFilAtu:= ''
Local cQuery := ''

If !lAuto
	MV_PAR01 := dDataIni
	MV_PAR02 := dDataFim
Endif

cQuery += " SELECT UB_NUM,UB_ITEM,UB_PRODUTO,UB_QUANT,UB_VRUNIT,UB_PRCTAB,UB_LOCAL,UB_DTENTRE,UA_CLIENTE,UA_LOJA,B1_PROC,B1_LOJPROC,UB_01PEDCO,UB_CONDENT,UB_XFILPED,SUB.R_E_C_N_O_ RECSUB, UB_01DESME "
cQuery += " FROM "+RetSqlName("SUB")+" SUB "
cQuery += " INNER JOIN "+RetSqlName("SUA")+" SUA ON UA_FILIAL = '"+cFilAtu+"' AND UA_NUM=UB_NUM     AND SUA.D_E_L_E_T_= ' ' "
cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD=UB_PRODUTO AND SB1.D_E_L_E_T_= ' ' "
cQuery += " WHERE "
cQuery += " UB_FILIAL=UA_FILIAL "
cQuery += " AND UA_EMISSAO BETWEEN '"+Dtos(Mv_Par01)+"' AND '"+Dtos(Mv_Par02)+"' "
cQuery += " AND UA_PEDPEND  IN ('3','4') "
cQuery += " AND UA_DOC  = ' ' "
cQuery += " AND UA_CANC = ' ' "
cQuery += " AND UB_CONDENT IN('2') "
cQuery += " AND UB_01PEDCO = ' ' "
cQuery += " AND UB_01CANC  = ' ' "
cQuery += " AND SUB.D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY B1_PROC,B1_LOJPROC,UA_CLIENTE,UA_LOJA,B1_COD "

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

(cAlias)->(DbGotop())
oProcess:SetRegua1( (cAlias)->(RecCount()) )
While (cAlias)->(!Eof())
	
	oProcess:IncRegua1("Processando Fornecedor: " + (cAlias)->B1_PROC +'-'+ (cAlias)->B1_LOJPROC )
	
	nPos := Ascan( aProdutos ,{|x| x[1]+x[2] == (cAlias)->B1_PROC+(cAlias)->B1_LOJPROC })
	If nPos == 0
		AAdd( aProdutos , { (cAlias)->B1_PROC , (cAlias)->B1_LOJPROC , (cAlias)->UB_XFILPED , {  (cAlias)->UB_PRODUTO , (cAlias)->UB_QUANT , (cAlias)->UB_VRUNIT , (cAlias)->UB_PRCTAB , (cAlias)->UB_LOCAL , (cAlias)->UB_DTENTRE , (cAlias)->UB_NUM , (cAlias)->UB_ITEM , (cAlias)->UB_XFILPED , (cAlias)->RECSUB , (cAlias)->UB_01DESME} } )
		nPos := Len(aProdutos)
	Else
		AAdd( aProdutos[nPos] , { (cAlias)->UB_PRODUTO , (cAlias)->UB_QUANT , (cAlias)->UB_VRUNIT , (cAlias)->UB_PRCTAB , (cAlias)->UB_LOCAL , (cAlias)->UB_DTENTRE , (cAlias)->UB_NUM , (cAlias)->UB_ITEM , (cAlias)->UB_XFILPED , (cAlias)->RECSUB, (cAlias)->UB_01DESME  } )
	EndIf
	
	(cAlias)->(DbSkip())
End
(cAlias)->( dbCloseArea() )

If Len(aProdutos) > 0
	GeraSC7(cFilAtu)
Else
	If lAuto
		Aviso("Atencao","Não existem ordens de compra para serem geradas.",{"Ok"})
	Endif
Endif

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GeraSC7   ºAutor  ³Eduardo Patriani    º Data ³  24/03/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera pedido de compra.                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GeraSC7(cFilAtu)

Local cItem		:= ""
Local cTes		:= ''
Local cGrupoCom	:= ""
Local cGrupo	:= ""
Local cA120Num 	:= CriaVar('C7_NUM', .T.)
Local cCondPg	:= GetMv("MV_CONDPAD")
Local nPrazo 	:= GetMv("SY_PRZFORN",,30)
Local cFilMat 	:= GetMv("MV_SYLOCDP",,"100001")
Local cGrpAprME	:= GetMv("KH_GRRAPME",,"000002")
Local nItem		:= 1
Local nX     	:= 0
Local nY		:= 0
Local nA		:= 0
Local nLoop		:= 0
Local nTotal	:= 0
Local nPercFre	:= 0
Local aCabec	:= {}
Local aItem		:= {}
Local aItens 	:= {}
Local aAtuPV	:= {}
Local aGrupoCom := {}
Local lRet		:= .F.
Local lFirstNiv := .F.
Local lMedEspec := .F.
Local nModOld	:= nModulo
Local cFilOld	:= cFilAnt

nModulo := 02
cFilAnt := cFilMat

oProcess:SetRegua2(Len(aProdutos))

aGrupoCom := UsrGrComp(__cUserID)
For nLoop := 1 to Len(aGrupoCom)
	cGrupoCom += aGrupoCom[nLoop]
Next nLoop

For nY := 1 To Len(aProdutos)
	
	oProcess:IncRegua2("Processando Pedido:" + Strzero(nY,6))
	
	nItem	 	:= 1
	nPercFre 	:= 0
	n120TotLib 	:= 0
	cA120Num 	:= SYFILNUM(cA120Num,cFilMat)
	
	SA2->(DbSetOrder(1))
	If SA2->(DbSeek(xFilial("SA2") + aProdutos[nY,1] + aProdutos[nY,2]  ))
		If SA2->A2_01PRAZO > 0
			nPrazo := SA2->A2_01PRAZO
		Endif
		
		If !Empty(SA2->A2_COND)
			cCondPg:= SA2->A2_COND
		Endif
	Else
		MsgInfo("Fornecedor: "+aProdutos[nY,1]+"/"+aProdutos[nY,2]+" não cadastrado!")
		Loop		
	Endif
	
	For nX := 4 To Len(aProdutos[nY])
		
		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial("SB1") + aProdutos[nY,nX,1] ))
		
		SB4->(DbSetOrder(1))
		If SB4->(DbSeek(xFilial("SB4") + SB1->B1_01PRODP )) .And. nPercFre == 0
			nPercFre := SB4->B4_01VLFRE
		Endif
		
		Reclock("SC7",.T.)
		SC7->C7_FILIAL 	:= cFilMat
		SC7->C7_TIPO	:= 1
		SC7->C7_ITEM	:= StrZero(nItem,TAMSX3("C7_ITEM")[1])
		SC7->C7_PRODUTO	:= SB1->B1_COD
		SC7->C7_UM		:= SB1->B1_UM
		SC7->C7_QUANT	:= aProdutos[nY,nX,2]
		SC7->C7_PRECO	:= SB1->B1_CUSTD
		SC7->C7_TOTAL	:= SC7->C7_QUANT * SC7->C7_PRECO
		SC7->C7_DATPRF	:= dDatabase+nPrazo
		SC7->C7_LOCAL 	:= aProdutos[nY,nX,5]
		SC7->C7_FORNECE	:= aProdutos[nY,1]
		SC7->C7_LOJA	:= aProdutos[nY,2]
		SC7->C7_COND	:= cCondPg
		SC7->C7_CONTATO	:= SA2->A2_CONTATO
		SC7->C7_FILENT	:= cFilMat
		SC7->C7_EMISSAO	:= dDatabase
		SC7->C7_NUM		:= cA120Num
		SC7->C7_DESCRI	:= SB1->B1_DESC
		SC7->C7_IPIBRUT	:= "B"
		SC7->C7_TPOP	:= "F"
		SC7->C7_USER	:= __cUserid
		SC7->C7_BASEICM	:= SC7->C7_TOTAL
		SC7->C7_BASEIPI	:= SC7->C7_TOTAL
		SC7->C7_MOEDA	:= 1
		SC7->C7_PENDEN	:= "N"
		SC7->C7_POLREPR	:= "N"
		SC7->C7_RATEIO	:= "2"
		SC7->C7_FLUXO	:= "S"
		SC7->C7_FISCORI	:= SC7->C7_FILIAL
		SC7->C7_OBS		:= "At.: "+cFilAtu+"/"+aProdutos[nY,nX,7]+''+aProdutos[nY,nX,8]
		SC7->C7_01TPMAT	:= "3"
		SC7->C7_NUMSUA	:= cFilAtu+aProdutos[nY,nX,7]+aProdutos[nY,nX,8]
		SC7->C7_01DESME	:= aProdutos[nY,nX,11]
		SC7->C7_TES		:= SB1->B1_TE
		SC7->C7_GRADE	:= "N"
		SC7->C7_ALQCSL	:= 1
		SC7->C7_PICM	:= SB1->B1_PICM
		SC7->C7_VALICM	:= (SC7->C7_TOTAL*SC7->C7_PICM)/100
		SC7->C7_TXMOEDA	:= 1		
		SC7->C7_ENCER  := Space(Len(SC7->C7_ENCER))
		Msunlock()
				
		nItem++
		n120TotLib += SC7->C7_TOTAL
		
		IF !Empty(aProdutos[nY,nX,11]) .And. !lMedEspec
			lMedEspec := .T.
		EndIF
		
		AAdd(aAtuPV,{ cFilAtu , aProdutos[nY,nX,7] , aProdutos[nY,nX,8] })		
	Next nX
	
	ConfirmSX8()
	lRet := .T.
	
	If n120TotLib > 0 //.And. !Empty(cGrupoCom)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Limpa o Filtro do SCR caso ele exista                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SCR")
		DbClearFilter()
		dbSelectArea("SC7")
		If lRet
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica o grupo de aprovacao do Comprador.                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SY1")
			dbSetOrder(3)
			If MsSeek(xFilial()+RetCodUsr())
				cGrupo := If(!Empty(Y1_GRAPROV),SY1->Y1_GRAPROV,cGrupo)
			EndIf
		
		EndIf		
		cGrupo:= If(Empty(SC7->C7_APROV),cGrupo,SC7->C7_APROV)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¸
		//³Quando tratar-se de medidas especiais, busca o grupo de³
		//³aprovação do parametro KH_GRRAPME                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lMedEspec
			cGrupo := cGrpAprME
		EndIF
		
		If !Empty(cGrupo)
			lFirstNiv := MaAlcDoc({cA120Num,"PC",n120TotLib,,,cGrupo,,SC7->C7_MOEDA,SC7->C7_TXMOEDA,SC7->C7_EMISSAO},,1)
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Efetua a gravacao do campo de controle de aprovacao C7_CONAPRO  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cBanco := Alltrim(Upper(TCGetDb()))
		SC7->(DBCOMMIT())
		cQuery := "UPDATE "+RetSqlname("SC7")+" "
		cQuery += "SET C7_GRUPCOM = '"+cGrupoCom+"' "
		cQuery += "WHERE C7_FILIAL='"+cFilMat+"' AND "
		cQuery += "C7_NUM='"+cA120Num+"' AND "
		cQuery += "C7_GRUPCOM = '"+Space(Len(SC7->C7_GRUPCOM))+"' "
				
		If TcSrvType() <> "AS/400"
			cQuery += "AND D_E_L_E_T_=' ' "
		Else
			cQuery += "AND @DELETED@=' ' "
		Endif		
		TcSqlExec(cQuery)
		
		cQuery := "UPDATE "+RetSqlname("SC7")+" "		
		cQuery += "SET C7_APROV = '"+cGrupo+"' "		
		cQuery += "WHERE C7_FILIAL='"+cFilMat+"' AND "
		cQuery += "C7_NUM='"+cA120Num+"' AND "
		cQuery += "C7_APROV = '"+Space(Len(SC7->C7_APROV))+"' "

		If TcSrvType() <> "AS/400"
			cQuery += "AND D_E_L_E_T_=' ' "
		Else
			cQuery += "AND @DELETED@=' ' "
		Endif		
		TcSqlExec(cQuery)
		
		cQuery := "UPDATE "+RetSqlname("SC7")+" "
		If !lFirstNiv
			cQuery += "SET C7_CONAPRO = 'B' "
		Else
			cQuery += "SET C7_CONAPRO = 'L' "
		EndIf
		cQuery += "WHERE C7_FILIAL='"+cFilMat+"' AND "
		cQuery += "C7_NUM='"+cA120Num+"' AND "
		cQuery += "C7_APROV <> '"+Space(Len(SC7->C7_APROV))+"' "
				
		If TcSrvType() <> "AS/400"
			cQuery += "AND D_E_L_E_T_=' ' "
		Else
			cQuery += "AND @DELETED@=' ' "
		Endif		
		TcSqlExec(cQuery)
		
		If Substr(cBanco,1,6) == "ORACLE" .And. !__TTSInUse
			TcSqlExec("COMMIT")
		Endif
				
	EndIf
	
Next

If lRet
	For nA:=1 To Len(aAtuPV)
		SUB->(DbSetOrder(1))
		If SUB->(DbSeek( cFilAtu + aAtuPV[nA,2] + aAtuPV[nA,3] ))
			SUB->(RecLock("SUB",.F.))
			SUB->UB_01PEDCOM := RetNumOC(aAtuPV,nA)
			SUB->(Msunlock())
		Endif
	Next
	
	MsgInfo("Pedidos gerados com sucesso.","Atenção")
	
Endif

nModulo := nModOld
cFilAnt := cFilOld

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ M104SX1  ºAutor  ³Eduardo Patriani    º Data ³  11/02/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria Perguntas. 			                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function M104SX1(cPerg)

Local aArea := GetArea()
Local aPerg := {}
Local i

Aadd(aPerg,{cPerg,"01","Da Emissao ?" ,"MV_CH1","D",TamSx3("UA_EMISSAO")[1]	,0,"G","MV_PAR01","",""	,""	,"",""})
Aadd(aPerg,{cPerg,"02","Ate Emissao ?","MV_CH2","D",TamSx3("UA_EMISSAO")[1]	,0,"G","MV_PAR02","",""	,""	,"",""})

DbSelectArea("SX1")
DbSetOrder(1)
For i := 1 To Len(aPerg)
	IF  !DbSeek(aPerg[i,1]+aPerg[i,2])
		RecLock("SX1",.T.)
	Else
		RecLock("SX1",.F.)
	EndIF
	Replace X1_GRUPO   with aPerg[i,01] ;		Replace X1_ORDEM   with aPerg[i,02]
	Replace X1_PERGUNT with aPerg[i,03] ;		Replace X1_VARIAVL with aPerg[i,04]
	Replace X1_TIPO	   with aPerg[i,05] ;		Replace X1_TAMANHO with aPerg[i,06]
	Replace X1_PRESEL  with aPerg[i,07] ;		Replace X1_GSC	   with aPerg[i,08]
	Replace X1_VAR01   with aPerg[i,09] ;		Replace X1_F3	   with aPerg[i,10]
	Replace X1_DEF01   with aPerg[i,11] ;		Replace X1_DEF02   with aPerg[i,12]
	Replace X1_DEF03   with aPerg[i,13] ;		Replace X1_DEF04   with aPerg[i,14]
	MsUnlock()
Next i

RestArea(aArea)

Static Function RetNumOC(aAtuPV,nA)

Local cRetorno	:= ""
Local cQuery	:= ""
Local cAlias 	:= GetNextAlias()

cQuery := "SELECT C7_NUM,C7_ITEM FROM "+RetSqlName("SC7")+" SC7 WHERE C7_NUMSUA = '"+aAtuPV[nA,1]+aAtuPV[nA,2]+aAtuPV[nA,3]+"' AND SC7.D_E_L_E_T_ = '' "
cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

(cAlias)->(DbGotop())
If (cAlias)->(!Eof())
	cRetorno := (cAlias)->C7_NUM+(cAlias)->C7_ITEM
EndIf
(cAlias)->( dbCloseArea() )

Return(cRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SYFILNUM ºAutor  ³ Eduardo Patriani   º Data ³  06/03/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Filtra numero valido para pedido de compra.                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function SYFILNUM(cNumPC,cFilMat)

Local cQry		:= ""

cQry+="	SELECT MAX(C7_NUM) C7_NUM FROM "+RETSQLNAME("SC7")+" SC7"+CRLF
cQry+="	WHERE C7_FILIAL = '"+cFilMat+"'"+CRLF
cQry+="	AND SC7.D_E_L_E_T_ = ' '"

If Select("TRBXX") > 0
	TRBXX->(DbCloseArea())
EndIf

TcQuery cQry New Alias "TRBXX"

dbSelectArea("SC7")
cNumPC 	:= Soma1(TRBXX->C7_NUM)
cMay 	:= "SC7"+Alltrim(xFilial("SC7"))
SC7->(dbSetOrder(1))
While SC7->(DbSeek(xFilial("SC7")+cNumPC) .OR. !MayIUseCode(cMay+cNumPC) )
	cNumPC := Soma1(cNumPC)
EndDo

Return(cNumPC)
