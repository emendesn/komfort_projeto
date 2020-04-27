#Include "PROTHEUS.CH"
#Include "rwmake.ch"
#Include  "TbiConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณKMHBXINV    บAutor  ณVanito Rocha      บ Data ณ  18/08/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina que faz movimentacao interna de determinado armazem บฑฑ
ฑฑบ          ณ de acordo com os parโmetros informados pelo usuแrio        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rotina que faz movimentacao interna de determinado         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function KMHBXINV()

Local vArea :=GetArea()
Local cDocumento:=""
Local vTMS:= ""//'505'
Local _vItens:={}
Local _cAliasD3 := GetNextAlias()
Local _cAliasB2 := GetNextAlias()
Local _cAliasB8 := GetNextAlias()
Local _cCab:={}
Local vPosLoc:= 0
Local vPosEnd:= 0
Local vCabRE:={}
Private lMsErroAuto	:= .F.
Private lMsHelpAuto	:= .F.
Private lAutoErrNoFile := .F.
Private cPerg := "KMHINV1"
Private cHist:=""

If cEmpAnt <> "01"
	Return .F.
Endif

AjustaSx1(cPerg)
If !Pergunte(cPerg, .T.)
	Return
Endif

If Empty(cDocumento)
	cDocumento	:= Upper(mv_par01)
EndIf



BEGINSQL ALIAS _cAliasD3
	%NOPARSER%
	SELECT SUM(BF_QUANT) AS BFQUANT, BF_PRODUTO, BF_LOCALIZ, BF_LOTECTL, BF_LOCAL FROM %TABLE:SBF% LEFT JOIN %TABLE:SB8% ON BF_PRODUTO=B8_PRODUTO AND BF_LOTECTL=B8_LOTECTL AND BF_LOCAL=B8_LOCAL
	WHERE BF_LOCAL = %Exp:mv_par02% AND BF_QUANT >  0 AND BF_PRODUTO BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
	GROUP BY BF_PRODUTO, BF_LOCALIZ, BF_LOTECTL, BF_LOCAL, BF_LOTECTL
	ORDER BY BF_PRODUTO ASC
ENDSQL

If (_cAliasD3)->(Eof())
	(_cAliasD3)->(dbCloseArea())
	Return .T.
EndIf

vTMS:=mv_par05
cHist:=mv_par06


_cCab:= {	{"D3_TM"		,vTMS					,NIL},;
{"D3_DOC"    	,cDocumento 	  		,NIL},;
{"D3_EMISSAO"	,dDataBase		  		,Nil}}

dbSelectArea(_cAliasD3)
While !EOF(_cAliasD3)
	
	If !Empty((_cAliasD3)->BF_PRODUTO)
		vItem := {	{"D3_COD",(_cAliasD3)->BF_PRODUTO								   		,NIL},;
		{"D3_QUANT"	 	,(_cAliasD3)->BFQUANT  										   		,NIL},;
		{"D3_UM"     	,Posicione("SB1",1,xFilial("SB1")+(_cAliasD3)->BF_PRODUTO, "B1_UM")	,NIL},;
		{"D3_LOCAL"  	,mv_par02													   		,NIL},;
		{"D3_LOTECTL"	,(_cAliasD3)->BF_LOTECTL									   		,NIL},;
		{"D3_NUMLOTE"	,''															   		,NIL},;
		{"D3_CUSTO1"	, Criavar("D3_CUSTO1",.F.)										  	,NIL},;		
		{"D3_LOCALIZ"	,(_cAliasD3)->BF_LOCALIZ											,NIL}}
		
		aadd(_vItens, vItem)
	Endif
	dbSelectArea(_cAliasD3)
	Dbskip()
Enddo
/*
BEGINSQL ALIAS _cAliasB2
	%NOPARSER%
	SELECT SUM(B2_QATU) AS B2QUANT, B2_COD, B2_LOCAL, B8_LOTECTL FROM %TABLE:SB2% B2 LEFT JOIN %TABLE:SB8% B8 ON B2.B2_COD=B8.B8_PRODUTO AND B2.B2_LOCAL=B8.B8_LOCAL
	WHERE B2.B2_LOCAL = %Exp:mv_par02% AND B2.B2_QATU >  0 AND B2.B2_COD BETWEEN %Exp:mv_par03% AND %Exp:mv_par04% AND B2.D_E_L_E_T_=''
	GROUP BY B2.B2_COD, B8.B8_LOTECTL, B2.B2_LOCAL
	ORDER BY B2_COD ASC
ENDSQL

If (_cAliasB2)->(Eof())
	(_cAliasB2)->(dbCloseArea())
	Return .T.
EndIf

dbSelectArea(_cAliasB2)
While !EOF(_cAliasB2)
	If !Rastro((_cAliasB2)->B2_COD) .AND. !Localiza((_cAliasB2)->B2_COD)
		If !Empty((_cAliasB2)->B2_COD)
			vItem := {	{"D3_COD",(_cAliasB2)->B2_COD								   	   		,NIL},;
			{"D3_QUANT"	 	,(_cAliasB2)->B2QUANT  										   		,NIL},;
			{"D3_UM"     	,Posicione("SB1",1,xFilial("SB1")+(_cAliasB2)->B2_COD, "B1_UM")		,NIL},;
			{"D3_LOCAL"  	,mv_par02													   		,NIL},;
			{"D3_LOTECTL"	,""															   		,NIL},;
			{"D3_LOCALIZ"	,"" 																,NIL},;
			{"D3_NUMLOTE"	,"" 																,NIL}}
			
			aadd(_vItens, vItem)
		Endif
	Endif
	If Rastro((_cAliasB2)->B2_COD) .AND. !Localiza((_cAliasB2)->B2_COD)
		If Substr((_cAliasB2)->B2_COD,1,1)=='1'
			vItem := {	{"D3_COD",(_cAliasB2)->B2_COD								   	   		,NIL},;
			{"D3_QUANT"	 	,(_cAliasB2)->B2QUANT  										   		,NIL},;
			{"D3_UM"     	,Posicione("SB1",1,xFilial("SB1")+(_cAliasB2)->B2_COD, "B1_UM")		,NIL},;
			{"D3_LOCAL"  	,mv_par02													   		,NIL},;
			{"D3_LOTECTL"	,(_cAliasB2)->B8_LOTECTL									   		,NIL},;
			{"D3_LOCALIZ"	,"" 																,NIL},;
			{"D3_NUMLOTE"	,"" 																,NIL}}
			
			aadd(_vItens, vItem)
		Endif
	Endif
	dbSelectArea(_cAliasB2)
	Dbskip()
Enddo
*/
Begin Transaction
If Len(_vItens) > 0
	MATA241(_cCab,_vItens,3)
	If lMsErroAuto
		DisarmTransaction()
		MostraErro()
	Endif
Endif
End Transaction
RestArea(vArea)
If lMsErroAuto
	Quit
EndIf
Return lMsErroAuto

**************************************************************************************
//Funcao para Enviar Workflow caso ocorra erros durante a execu็ใo do programa      \\
**************************************************************************************
//SD3->D3_DOC, SD3->D3_COD, SD3->D3_LOTECTL, SD3->D3_LOCALIZ
Static Function xGotError(_cMsgError, _cDoc, _cCod, _Lotectl, _cLocaliz)
Alert(_cMsgError)
u_MailNotify("vanito.rocha@hotmail.com","","Erro Movimenta็ใo Inventแrio",{_cMsgError,"Documento: " + _cDoc + "Produto: " + _cCod + " Lote: " + _Lotectl + " Endereco: " + _cLocaliz},{},.T.)
DisarmTransaction()
MsgStop("Um erro impediu a movimentacao de Inventario, favor comunicar o administrador","BSATVINV")
Return



Static Function AjustaSx1(cPerg)

Local aPergunta := {}
Local i
Local aAreaBKP := GetArea()

dbSelectArea("SX1")
SX1->(dbSetOrder(1))
If !dbSeek(cPerg)
	
	
	Aadd(aPergunta,{cPerg,"01","Numero Documento?"			,"MV_CH01" ,"C",09,00,"G","MV_PAR01",""     ,""      ,""			,""			,"",""	,""   	})
	Aadd(aPergunta,{cPerg,"02","Armazem Ret. ?" 			,"MV_CH02" ,"C",02,00,"G","MV_PAR02",""     ,""      ,""			,""			,"",""	,""		})
	Aadd(aPergunta,{cPerg,"03","Produto de ?" 				,"MV_CH03" ,"C",15,00,"G","MV_PAR03","1" 	,""      ,""			,"SB1"		,"",""	,""		})
	Aadd(aPergunta,{cPerg,"04","Produto Ate?"  				,"MV_CH04" ,"C",15,00,"G","MV_PAR04",""		,""		 ,""			,"SB1"		,"",""	,""   	})
	Aadd(aPergunta,{cPerg,"05","Tip. Movim ?"  				,"MV_CH05" ,"C",03,00,"G","MV_PAR05","SB1"	,""		 ,""			,"SF5"		,"",""	,""   	})
	Aadd(aPergunta,{cPerg,"06","Observacao?"  				,"MV_CH06" ,"C",20,00,"G","MV_PAR06",""		,""		 ,""			,""			,"",""	,""   	})
	
	For i := 1 To Len(aPergunta)
		SX1->(RecLock("SX1",!dbSeek(aPergunta[i,1]+aPergunta[i,2])))
		SX1->X1_GRUPO 		:= aPergunta[i,1]
		SX1->X1_ORDEM		:= aPergunta[i,2]
		SX1->X1_PERGUNT		:= aPergunta[i,3]
		SX1->X1_VARIAVL		:= aPergunta[i,4]
		SX1->X1_TIPO		:= aPergunta[i,5]
		SX1->X1_TAMANHO		:= aPergunta[i,6]
		SX1->X1_DECIMAL		:= aPergunta[i,7]
		SX1->X1_GSC			:= aPergunta[i,8]
		SX1->X1_VAR01		:= aPergunta[i,9]
		SX1->X1_DEF01		:= aPergunta[i,10]
		SX1->X1_DEF02		:= aPergunta[i,11]
		SX1->X1_DEF03		:= aPergunta[i,12]
		SX1->X1_DEF04		:= aPergunta[i,13]
		SX1->X1_DEF05		:= aPergunta[i,14]
		SX1->X1_F3			:= aPergunta[i,15]
		SX1->(MsUnlock())
	Next i
Endif
RestArea(aAreaBKP)

Return()
