#INCLUDE "Protheus.ch"

/*
#==================================================================================#
| +------------------------------------------------------------------------------+ |
| ! FUNCAO.........:	RFATPV10                                                 ! |
| ! DESCRICAO......:    RELATORIO DE PEDIDO PRONTOS PARA ENTREGA                 ! |
| ! AUTOR..........:	BRUNNO ABRIGO                                            ! |
| ! DATA...........:	28/01/2015                                               ! |
| ! PARAMETROS.....:	NIL                                                      ! |
| ! USO............:	CASA CENARIO                                             ! |
| +------------------------------------------------------------------------------+ |
#==================================================================================#
*/  
STATIC CCREATETABLE := CRIATRAB(NIL,.F.)
STATIC CSQLALIAS    := GETNEXTALIAS()
STATIC CALIASREP    := GETNEXTALIAS()
STATIC 	OBREAK       := NIL
	
User Function RFATPV10()
	Local oReport 	:= ReportDef()
    
	If Valtype(oReport) == "O"
		oReport:PrintDialog()
	Endif

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Function ReportDef                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function ReportDef()
	Local oCelula	:= Nil
	Local cDescr	:= "Este programa irá imprimir o Relatório de Pedidos de Venda prontos para entrega"
	Local cTitulo	:= "Pedidos para entrega"
	Local cPerg		:= "RFATPV10"
	
	If !RetParambox()
		Return Nil
	Endif

	oReport := TReport():New(cPerg,cTitulo,"",{|oReport| ReportPrint(oReport,@cAliasRep)},cDescr)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Criacao da celulas da secao do relatorio                      ³
	//³                                                              ³
	//³TRCell():New                                                  ³
	//³ExpO1 : Objeto TSection que a secao pertence                  ³
	//³ExpC2 : Nome da celula do relatório. O SX3 será consultado    ³
	//³ExpC3 : Nome da tabela de referencia da celula                ³
	//³ExpC4 : Titulo da celula                                      ³
	//³        Default : X3Titulo()                                  ³
	//³ExpC5 : Picture                                               ³
	//³        Default : X3_PICTURE                                  ³
	//³ExpC6 : Tamanho                                               ³
	//³        Default : X3_TAMANHO                                  ³
	//³ExpL7 : Informe se o tamanho esta em pixel                    ³
	//³        Default : False                                       ³
	//³ExpB8 : Bloco de código para impressao.                       ³
	//³        Default : ExpC2                                       ³
	//³                                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Sessao 1 (oCelula)                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oCelula := TRSection():New(oReport,"Pedidos P/ Entrega",{(cSQLAlias)},,/*Campos do SX3*/,/*Campos do SIX*/)
	oCelula:SetTotalInLine(.F.)

	TRCell():New(oCelula,"UA_CLIENTE"	,cSQLAlias	,/*Titulo*/	,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,	)
	TRCell():New(oCelula,"UA_LOJA"	    ,cSQLAlias	,/*Titulo*/	,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,	)
	TRCell():New(oCelula,"A1_NOME"	    ,cSQLAlias	,/*Titulo*/	,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,	)
	TRCell():New(oCelula,"C6_ENTREG"    ,cSQLAlias	,/*Titulo*/	,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,	)
	TRCell():New(oCelula,"UB_FILIAL"	,cSQLAlias	,/*Titulo*/	,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,	)
	TRCell():New(oCelula,"UB_NUM"	    ,cSQLAlias	,/*Titulo*/	,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,	)
	TRCell():New(oCelula,"C6_NUM"	    ,cSQLAlias	,/*Titulo*/	,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,	)
	TRCell():New(oCelula,"C6_ITEM"	    ,cSQLAlias	,/*Titulo*/	,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,	)
	TRCell():New(oCelula,"C6_PRODUTO"	,cSQLAlias	,/*Titulo*/	,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,	)
	TRCell():New(oCelula,"B1_DESC"	    ,cSQLAlias	,/*Titulo*/	,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,	)
	TRCell():New(oCelula,"UB_XFORFAT"	,cSQLAlias	,/*Titulo*/	,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,	)
	TRCell():New(oCelula,"C6_QTDVEN"	,cSQLAlias	,/*Titulo*/	,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,	)
	TRCell():New(oCelula,"UB_01PEDCO"	,cSQLAlias	,/*Titulo*/	,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,	)
	TRCell():New(oCelula,"C6_LOCAL"	    ,cSQLAlias	,/*Titulo*/	,/*Mascara*/  	,/*Tamanho*/	,/*lPixel*/	,	)
	
	// Quebra de linha
	oBreak := TRBreak():New(oCelula, oCelula:Cell("UB_NUM"),'',.F. )
	oBreak:SetPageBreak(.F.)
	oCelula:SetHeaderPage()

Return oReport

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Function ReportPrint                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function ReportPrint(oReport, cAliasRep)
	Local oSection1		:= oReport:Section(1)
	Local oBreak		:= Nil
    
	BeginSQL Alias cAliasRep
		COLUMN C6_ENTREG AS DATE
		%Noparser%
		SELECT UA_CLIENTE,UA_LOJA,A1_NOME,UB_FILIAL, UB_NUM, C6_NUM, C6_ITEM,C6_PRODUTO, B1_DESC, UB_XFORFAT, C6_QTDVEN, UB_01PEDCO, C6_LOCAL , UB_CONDENT , C7_ENCER, C7_QUJE, UB_DTENTRE, C7_QUANT, C6_ENTREG,UB_XFILPED
		FROM %Table:SUA% SUA
		INNER JOIN %Table:SA1%   SA1   ON A1_COD=UA_CLIENTE    AND A1_LOJA=UA_LOJA   AND SA1.%NotDel%
		INNER JOIN %Table:SUB%   SUB   ON UA_FILIAL=UB_FILIAL  AND UA_NUM=UB_NUM     AND SUB.%NotDel%
		LEFT JOIN %Table:SC6%   SC6   ON C6_FILIAL=UB_XFILPED AND C6_NUM=UB_NUMPV   AND UB_ITEMPV=C6_ITEM AND SC6.%NotDel%
		INNER JOIN %Table:SB1%   SB1   ON C6_PRODUTO=B1_COD    AND SB1.%NotDel%
		LEFT JOIN %Table:SC7%   SC7   ON C7_FILIAL=UB_XFILPED AND C7_ITEM=RIGHT(UB_01PEDCO,4) AND C7_PRODUTO=UB_PRODUTO AND C7_NUM=LEFT(UB_01PEDCO,6) AND SC7.%NotDel%
		WHERE SUA.%NotDel%
		AND UB_DTENTRE BETWEEN %Exp:aRet[1]% AND %Exp:aRet[2]%
		AND UA_DOC   = ' '
		AND UA_CANC <> 'S'
		AND UA_OPER  = '1'
		AND UA_PEDPEND IN('3','5')
		GROUP BY UA_CLIENTE,UA_LOJA,A1_NOME,UB_FILIAL, UB_NUM, C6_NUM, C6_ITEM,C6_PRODUTO, B1_DESC, UB_XFORFAT, C6_QTDVEN, UB_01PEDCO, C6_LOCAL , UB_CONDENT , C7_ENCER, C7_ENCER, C7_QUJE, UB_DTENTRE , C7_QUANT , C6_ENTREG,UB_XFILPED
		ORDER BY UB_FILIAL,UB_NUM
	EndSQL
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Processa dados do Rela.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FwMsgRun( ,{|| SQLFilData(cAliasRep) }, , "Filtrando registros, por favor aguarde..." )
	
	oReport:ASECTION[1]:CALIAS  := cSQLAlias
	//oReport:Section(1):EndQuery()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Impressao do Relatorio ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSection1:Print()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Fecha Alias de Trab.   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	FwMsgRun( ,{|| MsCLoseTrb() }, , "Finalizando, aguarde." )
	
Return Nil

Static Function SQLFilData(cAlias)
	Local x,i
	Local CCHAVE     := ""
	Local aStruct    := (cAlias)->(DbStruct())
	Local aDados     := {}
	Local aAux       := {}
	Local lGrava     := .T.
	
	DBSelectArea("SB2");SB2->( dbSetOrder(1) )
	
	dbCreate(cCreateTable, aStruct      ,"TOPCONN"/*__localdriver*/)
	dbUseArea(.T.   ,/*__localdriver*/"TOPCONN" , cCreateTable,cSQLAlias,.F.,.F.)

	DBSelectArea(cSQLAlias)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega arquivo temporario no Srv com os dados da Query      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	(cAlias)->(dbGotop());	cChave := (cAlias)->( UB_NUM )
	
	While (cAlias)->(!Eof())
		
		lGrava := .T.
		
		If (cAlias)->UB_CONDENT == "1" // Estoque
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posiciona Estoque³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SB2->( MsSeek((cAlias)->(UB_XFILPED +C6_PRODUTO+C6_LOCAL)) )
				If !SB2->B2_QATU >= (cAlias)->C6_QTDVEN
					lGrava := .F.
				Endif
			Endif
		
		ElseIf (cAlias)->UB_CONDENT == "2" // Encomenda
			
			If (cAlias)->C7_ENCER <> 'E' //.and. (cAlias)->C7_QUANT - (cAlias)->C7_QUJE == 0
				lGrava := .F.
			Endif
			
		Elseif (cAlias)->UB_CONDENT == "3" // Estoque Previsto
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posiciona Estoque³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SB2->( MsSeek((cAlias)->(UB_XFILPED +C6_PRODUTO+C6_LOCAL)) )
				If !(SB2->B2_QATU - SB2->B2_QPEDVEN) >= (cAlias)->C6_QTDVEN
					lGrava := .F.
				Endif
			Endif
		Endif
				
		If lGrava
			
			For x:=1 To Len(aStruct)
				Aadd(aAux,(cAlias)->(FieldGet(x) ))
			Next x
			
			Aadd(aDados, aAux )
			aAux := {}
		Endif
		 
		(cAlias)->(dbSkip())
		/*
		If cchave <> (cAlias)->( UB_NUM )
			cChave := (cAlias)->( UB_NUM )
				lGrava := .T.
			If lGrava
				For x:=1 To Len(aDados)
					Reclock(cSQLAlias,.T.)
					For i:= 1 To len(aDados[x])
						(cSQLAlias)->&(Field(i)):= aDados[x,i]
					Next i
					(cSQLAlias)->(MsUnlock())
				Next x
			Endif
			
			aDados := {}
			lGrava := .T.
		Endif
		*/
	EndDo
	
	For x:=1 To Len(aDados)
		Reclock(cSQLAlias,.T.)
		For i:= 1 To len(aDados[x])
			(cSQLAlias)->&(Field(i)):= aDados[x,i]
		Next i
		(cSQLAlias)->(MsUnlock())
	Next x
	
	


	If Select(cAliasRep) > 0
		(cAliasRep)->(DbCloseArea())
	Endif
	
	DbSelectArea(cSQLAlias);(cSQLAlias)->(dbGotop())
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Function CriaPerg (Cria Perguntas no SX1)                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function RetParambox(cPerg)
	Static aRet			:= {}
	Local aParamBox		:= {}
	Local lRet 			:= .T.
	
	aAdd(aParamBox,{1,"Data Entrega De"   ,Ctod(Space(8)),"","","","",50,.T.}) // Tipo data
	aAdd(aParamBox,{1,"Data Entrega Até"  ,Ctod(Space(8)),"","","","",50,.T.}) // Tipo data
    
	If !ParamBox(aParamBox,"Informe o filtro",@aRet)
		Aviso('Atenção','Cancelado pelo administrador',{'Ok'});lRet := .F.
	Endif
	
Return lRet

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FECHA ALIAS DE TRABALHO E DELETA TABELA TEMPORARIA.              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function MsCloseTrb()

	If Select(cSQLAlias) > 0
		(cSQLAlias)->(DbCloseArea())
		TCSQLEXEC("DROP TABLE "+ CCREATETABLE)
	Endif

Return