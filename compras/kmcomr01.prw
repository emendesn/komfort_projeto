#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#Include "Ap5Mail.Ch"
#Include "xmlxfun.ch"
#INCLUDE "JPEG.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � KMCOMR01 � Autor � LUIZ EDUARDO F.C.  � Data �  27/01/17   ���
�������������������������������������������������������������������������͹��
���Descricao � RELATORIO DE REPOSICAO DE COMPRAS                          ���
�������������������������������������������������������������������������͹��
���Uso       � KOMFORT HOUSE                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
USER FUNCTION KMCOMR01()
Local oTela, oPnlInfo, oLogo, oFnt
Local aPergunta := {}
Local aSize     := MsAdvSize()                   
Local cMes      := ""
Local cMes1                                      
Local cMes2
Local cMes3
Local cMes4                                      
Local cMes5
Local cMes6
Local cMesA

Private aDados  := {}
Private aCabec  := {}
Private oBrw
Private cDtIni  := ""
Private cDtFim  := ""
Private aMeses  := {}
Private cLstCF  := SuperGetMV("KH_CFVENDA",,"5102;6102;6108")	// TES considerada venda
Private _cAcoes := GetMV("KH_ACOESTR")

Aadd(aPergunta,{PadR("KMCOMR01",10),"01","Produto de  ?"	,"MV_CH1" ,"C",15,00,"G","MV_PAR01","" ,"" ,"","","","SB1"})
Aadd(aPergunta,{PadR("KMCOMR01",10),"02","Produto at� ?"	,"MV_CH2" ,"C",15,00,"G","MV_PAR02","" ,"" ,"","","","SB1"})
Aadd(aPergunta,{PadR("KMCOMR01",10),"03","Armazem de ?"		,"MV_CH3" ,"C",02,00,"G","MV_PAR03","" ,"" ,"","","","NNR"})
Aadd(aPergunta,{PadR("KMCOMR01",10),"04","Armazem at� ?"	,"MV_CH4" ,"C",02,00,"G","MV_PAR04","" ,"" ,"","","","NNR"})
Aadd(aPergunta,{PadR("KMCOMR01",10),"05","Tipo de ?"		,"MV_CH5" ,"C",02,00,"G","MV_PAR05","" ,"" ,"","","","02" })
Aadd(aPergunta,{PadR("KMCOMR01",10),"06","Tipo at� ?"		,"MV_CH6" ,"C",02,00,"G","MV_PAR06","" ,"" ,"","","","02" })
Aadd(aPergunta,{PadR("KMCOMR01",10),"07","Fornecedor de ?"	,"MV_CH7" ,"C",06,00,"G","MV_PAR07","" ,"" ,"","","","SA2"})
Aadd(aPergunta,{PadR("KMCOMR01",10),"08","Fornecedor at� ?"	,"MV_CH8" ,"C",06,00,"G","MV_PAR08","" ,"" ,"","","","SA2"})
Aadd(aPergunta,{PadR("KMCOMR01",10),"09","Data Refer�ncia"	,"MV_CH9" ,"D",08,00,"G","MV_PAR09","" ,"" ,"","","",""   })

VldSX1(aPergunta)

If ! Pergunte(aPergunta[1,1],.T.)
	Return nil
EndIf

If Empty(MV_PAR09)
	MV_PAR09 := dDataBase
EndIf	

cMes    := LEFT( DTOS( MV_PAR09 ),6)
cDtIni  := DTOS( MonthSub( STOD( cMes+"01" ), 6) )
cDtFim  := DtoS( MV_PAR09 - 1 )

For nI := 6 to 1 step -1
	aadd( aMeses, left( DTOS( MonthSub( STOD( cMes+"01" ), nI) ), 6)  )
Next
aadd( aMeses, cMes )

cMes1 := right(aMeses[1],2) + "/" + left(aMeses[1],4)
cMes2 := right(aMeses[2],2) + "/" + left(aMeses[2],4)
cMes3 := right(aMeses[3],2) + "/" + left(aMeses[3],4)
cMes4 := right(aMeses[4],2) + "/" + left(aMeses[4],4)                                     
cMes5 := right(aMeses[5],2) + "/" + left(aMeses[5],4)
cMes6 := right(aMeses[6],2) + "/" + left(aMeses[6],4)

cMesA := "1 a "+cValToChar( Day(MV_PAR09-1) )

FwMsgRun( ,{|| PrdEstoq()}, , "Filtrando Estoque, por favor aguarde..." )
FwMsgRun( ,{|| PrdPV()   }, , "Filtrando Pedidos recentes, por favor aguarde..." )
FwMsgRun( ,{|| PrdPC()   }, , "Filtrando Pedidos de Compras , por favor aguarde..." )
//FwMsgRun( ,{|| PrdSC()   }, , "Filtrando Solicita��es de Compras , por favor aguarde..." )
//FwMsgRun( ,{|| PrdPVP()  }, , "Filtrando Pedidos Pendentes, por favor aguarde..." )
//FwMsgRun( ,{|| PrdSAC()  }, , "Filtrando Pedidos SAC, por favor aguarde..." )
FwMsgRun( ,{|| PrdPVF()  }, , "Filtrando Pedidos a Faturar, por favor aguarde..." )
FwMsgRun( ,{|| PrdACM()  }, , "Acumulando valores, por favor aguarde..." )

aadd( aCabec, "Fornecedor"           )
aadd( aCabec, "Codinome"             )
aadd( aCabec, "Fora Linha"          )
aadd( aCabec, "Cod.Produto"          )
aadd( aCabec, "Descri��o"            )
aadd( aCabec, "Tipo"                 )
aadd( aCabec, cMes1                  )
aadd( aCabec, cMes2                  )
aadd( aCabec, cMes3                  )
aadd( aCabec, cMes4                  )
aadd( aCabec, cMes5                  )
aadd( aCabec, cMes6                  )
aadd( aCabec, cMesA                  )
aadd( aCabec, "M�dia"                )
aadd( aCabec, "Saldo Atual"        )
aadd( aCabec, "Pedido Compras"       )
aadd( aCabec, "Pedido Vendas"   )
aadd( aCabec, "F�rmula" )
aadd( aCabec, "Dispon�vel"              )
aadd( aCabec, "Necessidade Compra"   )
aadd( aCabec, "Custo Fixo"           )
aadd( aCabec, "Pedido"               )

if Len(aDados) > 0
	
	DEFINE FONT oFnt NAME "ARIAL" SIZE 0,-12 BOLD
	DEFINE MSDIALOG oTela FROM 0,0 TO aSize[6],aSize[5] TITLE "Reposi��o de Compras" Of oMainWnd PIXEL
	
	//����������������������������������������Ŀ
	//� MONTA PAINEL COM AS INFORMACOES GERAIS �
	//������������������������������������������
	oPnlInfo:= TPanel():New(000,000, "",oTela, NIL, .T., .F., NIL, NIL,aSize[6],080, .T., .F. )
	oPnlInfo:Align:=CONTROL_ALIGN_TOP
	
	// TRAZ O LOGO DA KOMFORT HOSUE
	@ 005,005 JPEG oLogo FILE "modelos\logo.jpg" SIZE  010,010 OF oPnlInfo PIXEL NOBORDER
	oLogo:LAUTOSIZE    := .F.
	oLogo:LSTRETCH     := .T.
	
	// CRIA OS BOTOES DA ROTINA
	@ 055,005 BUTTON  "&Sair" 		SIZE 050,020 PIXEL OF oPnlInfo ACTION ( oTela:End() )
	@ 055,070 BUTTON  "&Excel" 		SIZE 050,020 PIXEL OF oPnlInfo ACTION ( LjMsgRun("Aguarde, Exportando para Excel...",,{|| ProcExcel()} ) )
	//		@ 055,135 BUTTON  "&Relat�rio" 	SIZE 050,020 PIXEL OF oPnlInfo ACTION ( /*LjMsgRun("Aguarde, ExportANDo para Excel...",,{|| ProcExcel() }) */ )
	
	//�����������������������������������Ŀ
	//� MONTA O BROWSE COM AS INFORMACOES �
	//�������������������������������������
	aTemp := aClone( aCabec )
	aSize(aTemp, len(aCabec)-1 )
	oBrw:= TWBrowse():New(000,000,000,000,,aTemp,,oTela,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oBrw:SetArray(aDados)
	oBrw:bLine := {|| {		ALLTRIM(aDados[oBrw:nAt,01]) 								,;	// FORNECEDOR
	ALLTRIM(aDados[oBrw:nAt,02]) 								,;	// CODINOME
	ALLTRIM(aDados[oBrw:nAt,03]) 								,;	// CODINOME
	ALLTRIM(aDados[oBrw:nAt,04]) 								,;	// CODIGO DO PRODUTO
	ALLTRIM(aDados[oBrw:nAt,05]) 								,;	// DESCRICAO
	ALLTRIM(aDados[oBrw:nAt,06])								,;	// TIPO DO PRODUTO
	ALLTRIM(Transform(aDados[oBrw:nAt,07],"@e 999,999,999"))	,;	// MES 1
	ALLTRIM(Transform(aDados[oBrw:nAt,08],"@e 999,999,999"))	,;	// MES 2
	ALLTRIM(Transform(aDados[oBrw:nAt,09],"@e 999,999,999"))	,;	// MES 3
	ALLTRIM(Transform(aDados[oBrw:nAt,10],"@e 999,999,999"))	,;	// MES 1
	ALLTRIM(Transform(aDados[oBrw:nAt,11],"@e 999,999,999"))	,;	// MES 2
	ALLTRIM(Transform(aDados[oBrw:nAt,12],"@e 999,999,999"))	,;	// MES 3
	Transform(aDados[oBrw:nAt,13],"@e 999,999,999") 			,;  // VENDIDO MES CORRENTE
	Transform(aDados[oBrw:nAt,14],PesqPict('SC6','C6_QTDVEN'))	,; // MEDIA
	Transform(aDados[oBrw:nAt,15],"@e 999,999,999")			,; // SALDO ESTOQUE
	Transform(aDados[oBrw:nAt,16],"@e 999,999,999")			,; // PEDIDO DE COMPRAS
	Transform(aDados[oBrw:nAt,17],"@e 999,999,999")			,; // PEDIDO DE VENDAS APTO A FATURAR
	Transform(aDados[oBrw:nAt,18],"@e 999,999,999")			,; // F�RMULA  
	Transform(aDados[oBrw:nAt,19],"@e 999,999,999")			,; // DISPONIVEL
	Transform(aDados[oBrw:nAt,20],PesqPict('SC6','C6_QTDVEN')),; // NECESSIDADE DE COMPRA
	Transform(aDados[oBrw:nAt,21],PesqPict('SB1','B1_CUSTD'))}}  // CUSTO FIXO
	oBrw:Align:=CONTROL_ALIGN_ALLCLIENT
	
	ACTIVATE MSDIALOG oTela CENTERED
Else
	MsgInfo("N�o existe dados para o filtro selecionado!","Aten��o")
EndIF

RETURN nil

//--------------------------------------------------------------
Static Function ProcExcel()
dlgToExcel( {{ "ARRAY", "Reposi��o de Compras - " + cFilAnt + " " + SM0->M0_FILIAL, aCabec, aDados }} )
Return nil


//------- listagem dos Produtos e Estoque
STATIC FUNCTION PrdEstoq()
Local _cQuery    := ""
Local _cCodino  := ""

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

_cQuery := " select A2_NREDUZ, B1_COD, B1_DESC, B1_TIPO, B1_CUSTD, B1_01FORAL, B1_XPERSO, B1_XENCOME, sum( coalesce(B2_QATU,0) ) as ESTOQUE "
_cQuery += " from " + RETSQLNAME("SB1") + " SB1 "
_cQuery += " join " + RETSQLNAME("SA2") + " SA2 on A2_FILIAL='"+xFilial("SA2")+"' AND A2_COD=B1_PROC AND A2_LOJA=B1_LOJPROC AND SA2.D_E_L_E_T_<>'*'"
_cQuery += " left join " + RETSQLNAME("SB2") + " SB2 on B2_FILIAL = '0101' AND B2_COD=B1_COD AND B2_LOCAL IN ('01') AND SB2.D_E_L_E_T_<>'*'" //retirados os armazens diferentes de 01, por solicita��o da Adarlene - 17/01/2020
_cQuery += " where B1_FILIAL='" +XFILIAL("SB1")+ "' "
_cQuery += " AND B1_COD between '"     + MV_PAR01 +"' AND '" + MV_PAR02 +"'"
_cQuery += " AND B1_TIPO between '"    + MV_PAR05 +"' AND '" + MV_PAR06 +"'"
_cQuery += " AND B1_PROC between '"    + MV_PAR07 +"' AND '" + MV_PAR08 +"'"
_cQuery += " AND SB1.D_E_L_E_T_ <> '*' "
_cQuery += " GROUP BY A2_NREDUZ, B1_COD, B1_DESC, B1_TIPO, B1_CUSTD, B1_01FORAL, B1_XPERSO, B1_XENCOME "

_cQuery := ChangeQuery(_cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"TRB",.F.,.T.)

MemoWrite('\Querys\COMR01Prd.sql',_cQuery)

While ! TRB->( EOF() )
	
	_cCodino := IIF(TRB->B1_XENCOME=='2',"ENCO ","GIRO ")+IIF(TRB->B1_01FORAL=='F',"FL","")+IIF(TRB->B1_XPERSO=='1',"MED ESP","")
	
	_cFl := TRB->B1_01FORAL 
	
	_cCodino := AllTrim(_cCodino)
	            //   1               2         3       4          5             6             7  8  9  10 11 12 13 14    15           16 17 18 19 20     21          22      
	aAdd( aDados , { TRB->A2_NREDUZ, _cCodino, _cFl ,TRB->B1_COD, TRB->B1_DESC, TRB->B1_TIPO, 0, 0, 0, 0, 0, 0, 0, 0.00, TRB->ESTOQUE, 0, 0, 0, 0, 0, TRB->B1_CUSTD, '' } )
	TRB->( dbSkip() )
End

If Select("TRB") > 0
	TRB->( dbCloseArea() )
EndIf

Return Nil


//------- em pedidos de vendas
STATIC FUNCTION PrdPV()
Local _cQuery    := ""
Local cChave
Local nI
Local nPos

/*_cQuery := " SELECT C6_PRODUTO, LEFT(C5_EMISSAO,6) AS ANOMES, SUM(C6_QTDVEN) as QTDE"
_cQuery += " FROM " + RETSQLNAME("SC5") + " SC5 "
_cQuery += " JOIN " + RETSQLNAME("SC6") + " SC6 on C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM AND C5_MSFIL=C6_MSFIL AND SC6.D_E_L_E_T_<>'*'"
_cQuery += " JOIN " + RETSQLNAME("SB1") + " SB1 on B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD=C6_PRODUTO AND SB1.D_E_L_E_T_<>'*'"
_cQuery += " INNER JOIN " + RETSQLNAME("SF4") + " SF4 ON F4_CODIGO = C6_TES AND SF4.D_E_L_E_T_ <> '*' "	
_cQuery += " WHERE C5_FILIAL='" +XFILIAL("SC5")+ "' "
_cQuery += " AND C5_EMISSAO BETWEEN '" + cDtIni   +"' AND '" + cDtFim   +"' "
_cQuery += " AND B1_COD BETWEEN '"     + MV_PAR01 +"' AND '" + MV_PAR02 +"'"
_cQuery += " AND B1_TIPO BETWEEN '"    + MV_PAR05 +"' AND '" + MV_PAR06 +"'"
_cQuery += " AND B1_PROC BETWEEN '"    + MV_PAR07 +"' AND '" + MV_PAR08 +"'"
_cQuery += " AND C6_CF in " + FormatIN(cLstCF,";")	// CFOP de venda
_cQuery += " AND SC5.D_E_L_E_T_<>'*'"
_cQuery += " AND C6_NUM IN (SELECT E1_PEDIDO "
_cQuery += " FROM " + RETSQLNAME("SE1") + " SE1 "
_cQuery += " WHERE SE1.D_E_L_E_T_ <> '*' "
_cQuery += " AND E1_PEDIDO <> '') "
_cQuery += " AND C5_01SAC NOT IN (SELECT UC_CODIGO"
_cQuery += " FROM " + RETSQLNAME("SUC") + " SUC "
_cQuery += " INNER JOIN " + RETSQLNAME("SUD") + " SUD ON UD_FILIAL = UC_FILIAL AND UD_CODIGO = UC_CODIGO "
_cQuery += " WHERE SUC.D_E_L_E_T_ <> '*' "
_cQuery += " AND SUD.D_E_L_E_T_ <> '*' "
_cQuery += " AND UD_SOLUCAO IN (" +_cAcoes+") ) "
_cQuery += " GROUP BY C6_PRODUTO, left(C5_EMISSAO,6) "
_cQuery += " ORDER BY C6_PRODUTO, left(C5_EMISSAO,6)"
_cQuery := ChangeQuery(_cQuery)                      */

_cQuery := " SELECT C6_PRODUTO, LEFT(C5_EMISSAO,6) AS ANOMES, SUM(C6_QTDVEN) as QTDE"
_cQuery += " FROM " + RETSQLNAME("SC5") + " SC5 "
_cQuery += " JOIN " + RETSQLNAME("SC6") + " SC6 on C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM AND C5_MSFIL=C6_MSFIL AND SC6.D_E_L_E_T_<>'*'"
_cQuery += " JOIN " + RETSQLNAME("SB1") + " SB1 on B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD=C6_PRODUTO AND SB1.D_E_L_E_T_<>'*'"
_cQuery += " INNER JOIN " + RETSQLNAME("SF4") + " SF4 ON F4_CODIGO = C6_TES AND SF4.D_E_L_E_T_ <> '*' "	
_cQuery += " WHERE C5_FILIAL='" +XFILIAL("SC5")+ "' "
_cQuery += " AND C5_EMISSAO BETWEEN '" + cDtIni   +"' AND '" + cDtFim   +"' "
_cQuery += " AND B1_COD BETWEEN '"     + MV_PAR01 +"' AND '" + MV_PAR02 +"'"
_cQuery += " AND B1_TIPO BETWEEN '"    + MV_PAR05 +"' AND '" + MV_PAR06 +"'"
_cQuery += " AND B1_PROC BETWEEN '"    + MV_PAR07 +"' AND '" + MV_PAR08 +"'"
_cQuery += " AND C6_CF in " + FormatIN(cLstCF,";")	// CFOP de venda
_cQuery += " AND SC5.D_E_L_E_T_<>'*'"
_cQuery += " AND C6_BLQ <> 'R' "
_cQuery += " AND C5_01SAC = '' "
//_cQuery += " AND C6_NOTA <> '' "
_cQuery += " GROUP BY C6_PRODUTO, left(C5_EMISSAO,6) "
_cQuery += " ORDER BY C6_PRODUTO, left(C5_EMISSAO,6)"
_cQuery := ChangeQuery(_cQuery)                      

MemoWrite('\Querys\COMR01PVMed.sql',_cQuery)

DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"TRB",.F.,.T.)

While ! TRB->( EOF() )
	
	cChave := TRB->C6_PRODUTO
	nI     := aScan( aDados, {|it| it[4] == cChave} )
	
	if nI > 0
		while ! TRB->( EOF() ) .AND. cChave == TRB->C6_PRODUTO
			
			nPos := aScan( aMeses, TRB->ANOMES )
			if nPos > 0
				aDados[nI][6+nPos] := TRB->QTDE
			endif
			
			TRB->(DbSkip())
		end
	else
		TRB->(DbSkip())
	endif
End

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf
return nil


//------- em pedidos de compras
STATIC FUNCTION PrdPC()
Local _cQuery    := ""
Local nI

_cQuery := " select C7_PRODUTO,"
_cQuery += 		" sum(C7_QUANT-C7_QUJE) as QTDE"
_cQuery += " from " + RETSQLNAME("SC7") + " SC7 "
_cQuery += " join " + RETSQLNAME("SB1") + " SB1 on B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD=C7_PRODUTO AND SB1.D_E_L_E_T_<>'*'"
_cQuery += " where C7_FILIAL='" +xFilial("SC7")+ "' "
_cQuery += " AND B1_COD between '"     + MV_PAR01 +"' AND '" + MV_PAR02 +"'"
_cQuery += " AND B1_TIPO between '"    + MV_PAR05 +"' AND '" + MV_PAR06 +"'"
_cQuery += " AND B1_PROC between '"    + MV_PAR07 +"' AND '" + MV_PAR08 +"'"
_cQuery += " AND C7_RESIDUO<>'S'"
_cQuery += " AND C7_QUANT-C7_QUJE > 0 "
_cQuery += " AND SC7.D_E_L_E_T_<>'*'"
_cQuery += " group by C7_PRODUTO"

_cQuery := ChangeQuery(_cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"TRB",.F.,.T.)

MemoWrite('\Querys\COMR01PC.sql',_cQuery)

While ! TRB->( EOF() )
	
	nI := aScan( aDados, {|it| it[4] == TRB->C7_PRODUTO} )
	if nI > 0
		aDados[nI][16] := TRB->QTDE
	endif
	
	TRB->( dbSkip() )
end

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf
return nil


//------- pedidos aptos a faturar
STATIC FUNCTION PrdPVF()
Local _cQuery    := ""
Local nI

/*_cQuery := " SELECT C6_PRODUTO,SUM(C6_QTDVEN) AS QTDE "
_cQuery += " FROM " + RETSQLNAME("SC6") + " SC6 JOIN SB1010 SB1 ON B1_FILIAL='    ' AND B1_COD=C6_PRODUTO AND C6_NOTA = '' AND SB1.D_E_L_E_T_<>'*' "
_cQuery += " JOIN " + RETSQLNAME("SC5") + " SC5 ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND SC5.D_E_L_E_T_<>'*' AND C5_NOTA = '' "
_cQuery += " INNER JOIN " + RETSQLNAME("SF4") + " SF4 ON F4_CODIGO = C6_TES AND SF4.D_E_L_E_T_ <> '*' "
_cQuery += " WHERE  C6_FILIAL='01  ' "
_cQuery += " AND B1_COD BETWEEN '"     + MV_PAR01 +"' AND '" + MV_PAR02 +"'"
_cQuery += " AND B1_TIPO BETWEEN '"    + MV_PAR05 +"' AND '" + MV_PAR06 +"'"
_cQuery += " AND B1_PROC BETWEEN '"    + MV_PAR07 +"' AND '" + MV_PAR08 +"'" 
_cQuery += " AND C5_EMISSAO <= '" + cDtFim   +"' "
_cQuery += " AND C6_CF IN " + FormatIN(cLstCF,";")	// CFOP de venda
_cQuery += " AND SC6.D_E_L_E_T_<>'*'"
_cQuery += " AND C6_NUM IN (SELECT E1_PEDIDO "
_cQuery += " FROM " + RETSQLNAME("SE1") + " SE1 "
_cQuery += " WHERE SE1.D_E_L_E_T_ <> '*' "
_cQuery += " AND E1_PEDIDO <> '') "
_cQuery += " AND C5_01SAC NOT IN (SELECT UC_CODIGO "
_cQuery += " FROM " + RETSQLNAME("SUC") + " SUC "
_cQuery += " INNER JOIN " + RETSQLNAME("SUD") + " SUD ON UD_FILIAL = UC_FILIAL AND UD_CODIGO = UC_CODIGO "
_cQuery += " WHERE SUC.D_E_L_E_T_ <> '*' "
_cQuery += " AND SUD.D_E_L_E_T_ <> '*' "
_cQuery += " AND UD_SOLUCAO IN (" +_cAcoes+") ) "
_cQuery += " GROUP BY C6_PRODUTO"*/

_cQuery := " SELECT C6_PRODUTO,SUM(C6_QTDVEN) AS QTDE "
_cQuery += " FROM " + RETSQLNAME("SC6") + " SC6 JOIN SB1010 SB1 ON B1_FILIAL='    ' AND B1_COD=C6_PRODUTO AND C6_NOTA = '' AND SB1.D_E_L_E_T_<>'*' "
_cQuery += " JOIN " + RETSQLNAME("SC5") + " SC5 ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND SC5.D_E_L_E_T_<>'*' "
_cQuery += " INNER JOIN " + RETSQLNAME("SF4") + " SF4 ON F4_CODIGO = C6_TES AND SF4.D_E_L_E_T_ <> '*' "
_cQuery += " WHERE  C6_FILIAL='01  ' "
_cQuery += " AND B1_COD BETWEEN '"     + MV_PAR01 +"' AND '" + MV_PAR02 +"'"
_cQuery += " AND B1_TIPO BETWEEN '"    + MV_PAR05 +"' AND '" + MV_PAR06 +"'"
_cQuery += " AND B1_PROC BETWEEN '"    + MV_PAR07 +"' AND '" + MV_PAR08 +"'" 
_cQuery += " AND C5_EMISSAO <= '" + cDtFim   +"' "
_cQuery += " AND C6_CF IN " + FormatIN(cLstCF,";")	// CFOP de venda
_cQuery += " AND SC6.D_E_L_E_T_<>'*'"
_cQuery += " AND C6_BLQ <> 'R' "
_cQuery += " AND C6_NOTA = '' "
_cQuery += " GROUP BY C6_PRODUTO"

_cQuery := ChangeQuery(_cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"TRB",.F.,.T.)

MemoWrite('\Querys\COMR01PV.sql',_cQuery)

While TRB->(!EOF())
	
	nI := aScan( aDados, {|it| it[4] == TRB->C6_PRODUTO} )
	if nI > 0
		aDados[nI][17] := TRB->QTDE
	endif
	
	TRB->(DbSkip())
end

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

return nil

//----------------------------
Static Function PrdACM()
Local nI
Local nTmp
Local nDia := Day( MV_PAR09 )
/*
aDados
01 - Nome Fornecedor
02 - C�dinome
03 - FL
04 - C�dido do Produto
05 - Descri��o Produto
06 - Tipo do Produto
07 - Mes 1
08 - Mes 2
09 - Mes 3
10 - Mes Atual
11 - M�dia
12 - Estoque Atual
13 - em Pedidos de Compras
14 - em Pedidos de Vendas a Faturar
15 - Saldo Dispon�vel
16 - Formula
17 - Necessidade de Compras
18 - Custo produto
19 - pedido (informativo)
*/

for nI := 1 to len( aDados )
	
	if nDia < 15
		nTmp := ( aDados[nI][07] + aDados[nI][08] + aDados[nI][09] + aDados[nI][10] + aDados[nI][11] + aDados[nI][12] ) / 6	// (Mes1 + Mes2 + Mes3+ Mes4+ Mes5+ Mes6) / 6
	else
		nTmp := ( aDados[nI][07] + aDados[nI][08] + aDados[nI][09] + aDados[nI][10] + aDados[nI][11] + aDados[nI][12] + aDados[nI][13] ) / 6	// (Mes2 + Mes3 + MesAtu) / 4
	endif
	aDados[nI][14] := Round(nTmp, 2)			// M�dia
	
	aDados[nI][18] := aDados[nI][15] - aDados[nI][17]		// Disponibilidade Venda
	aDados[nI][19] := (aDados[nI][15] + aDados[nI][16]) - (aDados[nI][17])		// F�rmula
	
	nTmp := aDados[nI][14] - aDados[nI][19]
	aDados[nI][20] := IIF(Round(nTmp, 2)<0,0,Round(nTmp, 2))			// Necessidade de Compra
next

return nil



/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �  VldSX1  � Autor � LUIZ EDUARDO F.C.  � Data �  05/01/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � VALIDACAO DE PERGUNTAS DO SX1                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function VldSX1(aPergunta)
Local i
Local aAreaBKP := GetArea()

dbSelectArea("SX1")
dbSetOrder(1)

For i := 1 To Len(aPergunta)
	RecLock("SX1",!dbSeek(aPergunta[i,1]+aPergunta[i,2]))
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

RestArea(aAreaBKP)

Return nil
