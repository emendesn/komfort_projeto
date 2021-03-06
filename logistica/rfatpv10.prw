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

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Function ReportDef                                               �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
Static Function ReportDef()
	Local oCelula	:= Nil
	Local cDescr	:= "Este programa ir� imprimir o Relat�rio de Pedidos de Venda prontos para entrega"
	Local cTitulo	:= "Pedidos para entrega"
	Local cPerg		:= "RFATPV10"
	
	If !RetParambox()
		Return Nil
	Endif

	oReport := TReport():New(cPerg,cTitulo,"",{|oReport| ReportPrint(oReport,@cAliasRep)},cDescr)

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//쿎riacao da celulas da secao do relatorio                      �
	//�                                                              �
	//쿟RCell():New                                                  �
	//쿐xpO1 : Objeto TSection que a secao pertence                  �
	//쿐xpC2 : Nome da celula do relat�rio. O SX3 ser� consultado    �
	//쿐xpC3 : Nome da tabela de referencia da celula                �
	//쿐xpC4 : Titulo da celula                                      �
	//�        Default : X3Titulo()                                  �
	//쿐xpC5 : Picture                                               �
	//�        Default : X3_PICTURE                                  �
	//쿐xpC6 : Tamanho                                               �
	//�        Default : X3_TAMANHO                                  �
	//쿐xpL7 : Informe se o tamanho esta em pixel                    �
	//�        Default : False                                       �
	//쿐xpB8 : Bloco de c�digo para impressao.                       �
	//�        Default : ExpC2                                       �
	//�                                                              �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Sessao 1 (oCelula)                                           �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Function ReportPrint                                             �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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
	
	//旼컴컴컴컴컴컴컴컴컴컴컴�
	//쿛rocessa dados do Rela.�
	//읕컴컴컴컴컴컴컴컴컴컴컴�
	FwMsgRun( ,{|| SQLFilData(cAliasRep) }, , "Filtrando registros, por favor aguarde..." )
	
	oReport:ASECTION[1]:CALIAS  := cSQLAlias
	//oReport:Section(1):EndQuery()
	
	//旼컴컴컴컴컴컴컴컴컴컴컴�
	//쿔mpressao do Relatorio �
	//읕컴컴컴컴컴컴컴컴컴컴컴�
	oSection1:Print()

	//旼컴컴컴컴컴컴컴컴컴컴컴�
	//쿑echa Alias de Trab.   �
	//읕컴컴컴컴컴컴컴컴컴컴컴�	
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
	
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Carrega arquivo temporario no Srv com os dados da Query      �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	(cAlias)->(dbGotop());	cChave := (cAlias)->( UB_NUM )
	
	While (cAlias)->(!Eof())
		
		lGrava := .T.
		
		If (cAlias)->UB_CONDENT == "1" // Estoque
		//旼컴컴컴컴컴컴컴컴�
		//쿛osiciona Estoque�
		//읕컴컴컴컴컴컴컴컴�
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
		
		//旼컴컴컴컴컴컴컴컴�
		//쿛osiciona Estoque�
		//읕컴컴컴컴컴컴컴컴�
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

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Function CriaPerg (Cria Perguntas no SX1)                        �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
Static Function RetParambox(cPerg)
	Static aRet			:= {}
	Local aParamBox		:= {}
	Local lRet 			:= .T.
	
	aAdd(aParamBox,{1,"Data Entrega De"   ,Ctod(Space(8)),"","","","",50,.T.}) // Tipo data
	aAdd(aParamBox,{1,"Data Entrega At�"  ,Ctod(Space(8)),"","","","",50,.T.}) // Tipo data
    
	If !ParamBox(aParamBox,"Informe o filtro",@aRet)
		Aviso('Aten豫o','Cancelado pelo administrador',{'Ok'});lRet := .F.
	Endif
	
Return lRet

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� FECHA ALIAS DE TRABALHO E DELETA TABELA TEMPORARIA.              �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
Static Function MsCloseTrb()

	If Select(cSQLAlias) > 0
		(cSQLAlias)->(DbCloseArea())
		TCSQLEXEC("DROP TABLE "+ CCREATETABLE)
	Endif

Return