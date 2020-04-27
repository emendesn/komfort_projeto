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

//������������������������������������������������������������������Ŀ
//� Function ReportDef                                               �
//��������������������������������������������������������������������
Static Function ReportDef()
	Local oCelula	:= Nil
	Local cDescr	:= "Este programa ir� imprimir o Relat�rio de Pedidos de Venda prontos para entrega"
	Local cTitulo	:= "Pedidos para entrega"
	Local cPerg		:= "RFATPV10"
	
	If !RetParambox()
		Return Nil
	Endif

	oReport := TReport():New(cPerg,cTitulo,"",{|oReport| ReportPrint(oReport,@cAliasRep)},cDescr)

	//��������������������������������������������������������������Ŀ
	//�Criacao da celulas da secao do relatorio                      �
	//�                                                              �
	//�TRCell():New                                                  �
	//�ExpO1 : Objeto TSection que a secao pertence                  �
	//�ExpC2 : Nome da celula do relat�rio. O SX3 ser� consultado    �
	//�ExpC3 : Nome da tabela de referencia da celula                �
	//�ExpC4 : Titulo da celula                                      �
	//�        Default : X3Titulo()                                  �
	//�ExpC5 : Picture                                               �
	//�        Default : X3_PICTURE                                  �
	//�ExpC6 : Tamanho                                               �
	//�        Default : X3_TAMANHO                                  �
	//�ExpL7 : Informe se o tamanho esta em pixel                    �
	//�        Default : False                                       �
	//�ExpB8 : Bloco de c�digo para impressao.                       �
	//�        Default : ExpC2                                       �
	//�                                                              �
	//����������������������������������������������������������������

	//��������������������������������������������������������������Ŀ
	//� Sessao 1 (oCelula)                                           �
	//����������������������������������������������������������������
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

//������������������������������������������������������������������Ŀ
//� Function ReportPrint                                             �
//��������������������������������������������������������������������
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
	
	//�����������������������Ŀ
	//�Processa dados do Rela.�
	//�������������������������
	FwMsgRun( ,{|| SQLFilData(cAliasRep) }, , "Filtrando registros, por favor aguarde..." )
	
	oReport:ASECTION[1]:CALIAS  := cSQLAlias
	//oReport:Section(1):EndQuery()
	
	//�����������������������Ŀ
	//�Impressao do Relatorio �
	//�������������������������
	oSection1:Print()

	//�����������������������Ŀ
	//�Fecha Alias de Trab.   �
	//�������������������������	
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
	
	//��������������������������������������������������������������Ŀ
	//� Carrega arquivo temporario no Srv com os dados da Query      �
	//����������������������������������������������������������������
	(cAlias)->(dbGotop());	cChave := (cAlias)->( UB_NUM )
	
	While (cAlias)->(!Eof())
		
		lGrava := .T.
		
		If (cAlias)->UB_CONDENT == "1" // Estoque
		//�����������������Ŀ
		//�Posiciona Estoque�
		//�������������������
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
		
		//�����������������Ŀ
		//�Posiciona Estoque�
		//�������������������
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

//������������������������������������������������������������������Ŀ
//� Function CriaPerg (Cria Perguntas no SX1)                        �
//��������������������������������������������������������������������
Static Function RetParambox(cPerg)
	Static aRet			:= {}
	Local aParamBox		:= {}
	Local lRet 			:= .T.
	
	aAdd(aParamBox,{1,"Data Entrega De"   ,Ctod(Space(8)),"","","","",50,.T.}) // Tipo data
	aAdd(aParamBox,{1,"Data Entrega At�"  ,Ctod(Space(8)),"","","","",50,.T.}) // Tipo data
    
	If !ParamBox(aParamBox,"Informe o filtro",@aRet)
		Aviso('Aten��o','Cancelado pelo administrador',{'Ok'});lRet := .F.
	Endif
	
Return lRet

//������������������������������������������������������������������Ŀ
//� FECHA ALIAS DE TRABALHO E DELETA TABELA TEMPORARIA.              �
//��������������������������������������������������������������������
Static Function MsCloseTrb()

	If Select(cSQLAlias) > 0
		(cSQLAlias)->(DbCloseArea())
		TCSQLEXEC("DROP TABLE "+ CCREATETABLE)
	Endif

Return