#Include 'Protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณKMHREND บAutor  ณVanito Rocha           บ Data ณ   02/10/2019บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelat๓rio de Posi็๕es de Endere็o 				          บฑฑ
ฑฑบ          ณ		                                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Komfort House						                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function KMHREND()
Local 	nVarLen	:=	SetVarNameLen(100)
Local 	oReport
Local cPerg:= Padr("KMHREND",10)
Private xNum
Private _cProduto:=""
Private	_nEsttrbne:=0
Private	SaldoBNE:=0
Private	_nEsttrbs:=0
Private	SaldoBSE:=0
Private	_nEsttrbrj:=0
Private	SaldoBRJ:=0


//Incluo/Altero as perguntas na tabela SX1
ValidPerg(cPerg)
//gero a pergunta de modo oculto, ficando disponํvel no botใo a็๕es relacionadas
Pergunte(cPerg,.T.)



oReport := ReportDef()
oReport:PrintDialog()


SetVarNameLen(nVarLen)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณMRPA016 บAutor  ณVanito Rocha           บ Data ณ   25/06/2018บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelat๓rio de Conferencia do MRP 					          บฑฑ
ฑฑบ          ณ		                                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BARUEL						                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReportDef()
Local oReport
Local oSection
Local oBreak1,oBreak2
Local cDescricao	:=	"Este programa tem como objetivo imprimir relatorio de endere็os cadastrados e suas capacidades"
Private xSalbar:=0


//Objeto do Relat๓rio
oReport	:=	TReport():New("KMHREN","Este programa tem como objetivo imprimir relatorio de endere็os cadastrados e suas capacidades",, {|oReport| PrintReport(@oReport)}, cDescricao, .T.)

oSection:= TRSection():New(oReport, "relatorio de endere็os cadastrados e suas capacidades"	, {"SBE"})

TRCell():New(oSection, "Armazem"			        								, "SBE", "Armazem"								,							,30)
TRCell():New(oSection, "Endereco"													, "SBE"	, "Endereco"								,	,20)
TRCell():New(oSection, "Capacidade"			    	   								, "SBE", "Capacidade"								,							,20)
TRCell():New(oSection, "Saldo"		    	       									, "SB2", "Saldo"								,							,20)
TRCell():New(oSection, "Disponivel"	   												, "SBE", "Disponibilidade"						,							,20)
TRCell():New(oSection, "Status_do_Endereco"	   										, "SBE", "Status"						,							,20)

//ARMAZEM, ENDERECO, CAPACIDADE,SALDO, CASE WHEN (SALDO <> 0 AND SALDO >=CAPACIDADE) THEN 'OCUPADO' ELSE 'DISPONIVEL' END AS DISPONIVEL

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณMRPA015 บAutor  ณVanito Rocha           บ Data ณ   22/05/2018บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelat๓rio de Conferencia do MRP 					          บฑฑ
ฑฑบ          ณ		                                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BARUEL						                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PrintReport(oReport)
Local oSection		:= oReport:Section(1)
Local oBreak        := Nil
Local cCpoBreak		:= ""
Local cDescBreak	:= ""
Local nOrdem		:= oSection:GetOrder()
Local cOrdem		:= ""
Local cQuery		:= ""
Local TEMPB21		:= GetnextAlias()
Local TEMPTRANBNE	:= GetnextAlias()
Local TEMPB23		:= GetnextAlias()
Local TEMPB22		:= GetnextAlias()
Local TEMPTRANBRJ   := GetnextAlias()
Local TEMPTRANBS    := GetnextAlias()
Local TEMPB27		:= GetnextAlias()

If MV_PAR02='R10'
	MV_PAR02:='R100'
Endif

oSection:BeginQuery()

BeginSql Alias "KMHREN"
	%NoParser%
	SELECT ARMAZEM, ENDERECO, CAPACIDADE,SALDO, CASE WHEN (SALDO <> 0 AND SALDO >=CAPACIDADE) THEN 'OCUPADO' ELSE 'DISPONIVEL' END AS DISPONIVEL, CASE WHEN BLOQUEIO='1' THEN 'BLOQUEADO' ELSE 'SEM BLOQUEIO' END AS STATUS_DO_ENDERECO FROM(SELECT ARMAZEM, ENDERECO, CAPACIDADE, SUM(SALDOBF+SALDOZL2) SALDO, BLOQUEIO FROM (SELECT BE_LOCAL ARMAZEM, BE_LOCALIZ ENDERECO, BE_CAPACID CAPACIDADE, BE_MSBLQL AS BLOQUEIO,
	(SELECT ISNULL(SUM(BF_QUANT),0) FROM %Table:SBF% (NOLOCK) WHERE BF_LOCAL=SBE.BE_LOCAL AND BF_LOCALIZ=SBE.BE_LOCALIZ AND D_E_L_E_T_='' AND BF_FILIAL=SBE.BE_FILIAL) SALDOBF,
	(SELECT ISNULL(SUM(ZL2_QUANT),0) FROM %Table:ZL2% (NOLOCK) WHERE ZL2_LOCAL=SBE.BE_LOCAL AND ZL2_LOCALI=SBE.BE_LOCALIZ AND D_E_L_E_T_='' AND ZL2_ENDER='N' AND ZL2_QUANT > 0) SALDOZL2
	FROM %Table:SBE% (NOLOCK) SBE WHERE  SBE.D_E_L_E_T_=' ' AND SBE.BE_LOCAL IN ('01','04','15') AND SUBSTRING(SBE.BE_LOCALIZ,1,3) BETWEEN %Exp:MV_PAR01%  AND %Exp:MV_PAR02% AND SUBSTRING(SBE.BE_LOCALIZ,9,1) BETWEEN '1' AND '7') AS SBE1 GROUP BY SBE1.ARMAZEM, ENDERECO, CAPACIDADE, BLOQUEIO) AS SBE2
	WHERE ARMAZEM IN ('01','04','15')
	ORDER BY ARMAZEM, SBE2.ENDERECO ASC
EndSql
oSection:EndQuery()

oSection:Print()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณMRPA015 บAutor  ณVanito Rocha           บ Data ณ   22/05/2018บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelat๓rio de Conferencia do MRP 					          บฑฑ
ฑฑบ          ณ		                                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BARUEL						                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidPerg(cPerg)

//     cGrupo,cOrdem,   cPergunt      ,cPerSpa      ,cPerEng     ,cVar cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid    ,cF3   , cGrpSxg,cPyme,cVar01    ,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03 ,cDefSpa3,cDefEng3,cDef04  ,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor                                                                            ,aHelpEng,aHelpSpa,cHelp)
PutSx1(cPerg,"01"   ,"Rua de?","Rua de?","Rua de?","mv_ch1","C"    ,  03    ,0       ,0      ,"G"  ," "    ,"   ",""      ,""   ,"mv_par01"   ,"   " ,"   "   ,"   "   ,"  ",""     ,"   "  ,"   "   ,"     " ,""      ,""      ,"     " ,"      ","     ",""     ,""      ,""      ,{"Calculo MRP","Ex:0000000001"},{                           }      ,{}      ,)
PutSx1(cPerg,"02"   ,"Rua ate?","Rua ate?","Rua ate?","mv_ch2","C"    ,  03    ,0       ,0      ,"G"  ," "    ,"   ",""      ,""   ,"mv_par02"   ,"   " ,"   "   ,"   "   ,"  ",""     ,"   "  ,"   "   ,"     " ,""      ,""      ,"     " ,"      ","     ",""     ,""      ,""      ,{"Calculo MRP","Ex:0000000001"},{                           }      ,{}      ,)

Return
