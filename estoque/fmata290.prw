#INCLUDE "totvs.ch"
//#INCLUDE "MATA290.CH"---- colocado abaixo
#define STR0001 If( cPaisLoc $ "ANG|PTG", "C�lculo Do Lote Econ�mico", "C�lculo do Lote Econ�mico" )
#define STR0002 If( cPaisLoc $ "ANG|PTG", "A Efectuar O C�lculo Do Lote Econ�mico...", "Efetuando C�lculo do Lote Econ�mico..." )
#define STR0003 If( cPaisLoc $ "ANG|PTG", "A Seleccionar Registos...", "Selecionando Registros..." )
#define STR0004 If( cPaisLoc $ "ANG|PTG", "Lote Econ�mico", "Lote Econ�mico" )
#define STR0005 If( cPaisLoc $ "ANG|PTG", "Actualiza��o do Consumo do M�s", "Atualiza��o do Consumo do M�s" )
#define STR0006 "C�lculos"
#define STR0007 "Por Peso"
#define STR0008 "Pela Tend�ncia"
#define STR0009 "Incremento:"
#define STR0010 If( cPaisLoc $ "ANG|PTG", "N�mero De Meses:", "N�mero de Meses:" )
#define STR0011 If( cPaisLoc $ "ANG|PTG", "C�lculo Do Lote Econ�mico", "C�lculo do Lote Econ�mico" )
#define STR0012 If( cPaisLoc $ "ANG|PTG", "C�lculo Do Ponto De Pedido", "C�lculo do Ponto de Pedido" )
#define STR0013 If( cPaisLoc $ "ANG|PTG", "Ajustar o lote econ�mico pela", "Ajusta Lote Econ�mico pela" )
#define STR0014 If( cPaisLoc $ "ANG|PTG", "Disponibilidade financeira", "disponibilidade financeira" )
#define STR0015 If( cPaisLoc $ "ANG|PTG", "Classifica��o ABC", "Classifica��o ABC" )
#define STR0016 If( cPaisLoc $ "ANG|PTG", "Do per�odo ", "Per�odo de" )
#define STR0017 If( cPaisLoc $ "ANG|PTG", "Aquisi��o (meses)", "Aquisi��o(meses)" )
#define STR0018 If( cPaisLoc $ "ANG|PTG", "Distribui��o", "Distribui��o" )
#define STR0019 If( cPaisLoc $ "ANG|PTG", "Percentagem (%)", "Percentual (%)" )
#define STR0020 If( cPaisLoc $ "ANG|PTG", "Tipos De Material", "Tipos de Material" )
#define STR0021 If( cPaisLoc $ "ANG|PTG", "Grupos De Material", "Grupos de Material" )
#define STR0022 "Estabilidade"
#define STR0023 "Sazonalidade"
#define STR0024 If( cPaisLoc $ "ANG|PTG", "Inverter Selec��o", "Inverter Selecao" )
#define STR0025 If( cPaisLoc $ "ANG|PTG", "A Gravar A Classifica��o Abc", "Gravar Classificacao ABC" )
#define STR0026 If( cPaisLoc $ "ANG|PTG", "Actualizar ", "Atualizar " )
#define STR0027 If( cPaisLoc $ "ANG|PTG", "Seleccionar Filial", "Seleciona Filial" )
#define STR0028 "Esta rotina tem o objetivo de recalcular o consumo mensal e a m�dia por pesos ou pela tend�ncia dos produtos em estoque. Tamb�m est� apta a calcular o lote econ�mico, ponto de pedido e classifica��o ABC, conforme f�rmulas conceituais do ambiente de estoque."
#define STR0029 If( cPaisLoc $ "ANG|PTG", "Configura��es Criaris", "Configura��es Gerais" )
#define STR0031 "Filtros"
#define STR0032 If( cPaisLoc $ "ANG|PTG", "Op��es De Processamento", "Op��es de Processamento" )
#define STR0033 If( cPaisLoc $ "ANG|PTG", "A processar pedidos...", "Processando demandas..." )
#define STR0034 If( cPaisLoc $ "ANG|PTG", "A processar documentos de sa�da...", "Processando documentos de sa�da..." )
#define STR0035 If( cPaisLoc $ "ANG|PTG", "A processar documentos de entrada...", "Processando documentos de entrada..." )
#define STR0036 If( cPaisLoc $ "ANG|PTG", "A processar movimenta��es internas...", "Processando movimenta��es internas..." )
#define STR0037 If( cPaisLoc $ "ANG|PTG", "A gravar pedidos...", "Gravando demandas..." )
#define STR0038 If( cPaisLoc $ "ANG|PTG", "A calcular lote econ�mico...", "Calculando lote econ�mico..." )
#define STR0039 If( cPaisLoc $ "ANG|PTG", "A ajustar lote econ�mico...", "Ajustando lote econ�mico..." )
#define STR0040 "In�cio do processamento"
#define STR0041 If( cPaisLoc $ "ANG|PTG", "Fim do processamento", "T�rmino do processamento" )
#define STR0042 "Analisa produtos sem grupo"
#define STR0043 If( cPaisLoc $ "ANG|PTG", "C�lculo do Stock de Seguran�a", "C�lculo do Estoque de Seguran�a" )
#define STR0044 If( cPaisLoc $ "ANG|PTG", "considerando consumo dos �ltimos", "considerando consumo dos ultimos" )
#define STR0045 "meses."
#define STR0046 "Aten��o"
#define STR0047 If( cPaisLoc $ "ANG|PTG", "Preencha a quantidade de meses para o c�lculo do stock de seguran�a.", "Preencha a quantidade de meses para o c�lculo do estoque de seguran�a." )
#define STR0048 "Ok"
#define STR0049 "Por m�dia de consumo"
#define STR0050 "Por previs�o de venda"
#define STR0051 "Inicio Filial: "
#define STR0052 "Final Filial: "
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATA290  � Autor � Eveli Morasco         � Data � 31/01/92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Calculo do lote economico                                  ���
�����������������������������������������������������������������������������

Fonte fMATA290 - criada User Function pois o Ponto de Pedido da KOMFORTHOUSE
� por Pedido de Venda e n�o por sa�da de NF.

Incrementada rotina de considerar os Pedidos de Vendas no consumo m�dio e
criado filtro pra n�o considerar produtos do tipo "ME" no c�lculo do mesmo
pelas NF de sa�da. - Cristiam Rossi em 24/03/2017
�����������������������������������������������������������������������������
*/
User Function fMATA290(lBat,aLista)

Local cPerg := "MTA290"
Local lContinua := .T.
Local lRetPE := .T.

Private nTotRegs := 0
Private lGrvABC  :=.T.
Private lEnd     :=.F.
Private aOpcoes

Private lMTA290Fil := ExistBlock("MTA290FIL")
Private cMTA290Fil

Default lBat := .F.

TCInternal(5,"*OFF")   // Desliga Refresh no Lock do Top

//�����������������������������������������������������Ŀ
//� Carrega as perguntas selecionadas                   �
//�������������������������������������������������������

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01        	// Armazem De                            �
//� mv_par02        	// Armazem Ate                           �
//� mv_par03        	// Produto De 	                         �
//� mv_par04        	// Produto Ate   	                     �
//| mv_par05            // Consumo Med. Neg. Zerar (Sim/Nao)     |
//| mv_par06            // Considerar Mov. Inventario (Sim/Nao)  | 
//����������������������������������������������������������������
Pergunte(cPerg,.F.)

If !lBat
	aOpcoes := A290Menu(lBat)
Else
 	aOpcoes := aClone(aLista)
EndIf

If ExistBlock("A290CONT")
	lContinua := If(ValType(lRetPE := ExecBlock("A290CONT",.F.,.F.,{aOpcoes})) == "L",lRetPE,.T.)
Endif

If !aOpcoes == NIL .And. lContinua

	//��������������������������������������������������������������Ŀ
	//� Variaveis utilizadas para desenhar cursor                    �
	//����������������������������������������������������������������
	dbSelectArea("SB1")
	nTotRegs := nTotRegs + RecCount()
	nTotRegs := nTotRegs + RecCount()
	
	dbSelectArea("SB3")
	nTotRegs := nTotRegs + RecCount()
	nTotRegs := nTotRegs + RecCount()
	nTotRegs := nTotRegs + RecCount()
	nTotRegs := nTotRegs + RecCount()
	nTotRegs := nTotRegs + RecCount()
	
	dbSelectArea("SD1")
	nTotRegs := nTotRegs + RecCount()
	
	dbSelectArea("SD2")
	nTotRegs := nTotRegs + RecCount()
	
	dbSelectArea("SD3")
	nTotRegs := nTotRegs + RecCount()
	
	If !lBat
		If IsBlind()
			BatchProcess(OemToAnsi(STR0001),OemToAnsi(STR0002),"MTA290",{ || Processa({|lEnd| MA290Process(aOpcoes,@lEnd,lBat)},OemToAnsi(STR0001),OemToAnsi(STR0002),.F.)})
	    Else
			Processa({|lEnd| MA290Process(aOpcoes,@lEnd,lBat)},OemToAnsi(STR0001),OemToAnsi(STR0002),.F.)
	    EndIf
	Else
		MA290Process(aOpcoes,@lEnd,lBat)  //"C�lculo do Lote Econ�mico"###"Efetuando C�lculo do Lote Econ�mico..."
	EndIf    
EndIf
Return

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A290CalCon� Autor � Eveli Morasco         � Data � 10/02/92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Recalcula o consumo medio do mes                           ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � A290CalCon()                                               ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA290                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function A290CalCon(oCenterPanel)
Static l290Cons

Local cAliasSD1	:= "SD1"
Local cAliasSD2	:= "SD2"
Local cAliasSD3	:= "SD3"
Local cAliasSB1	:= "SB1"
Local cAliasSB3	:= "SB3"
Local cCod      := ""
Local cIndex	:= ""
Local cCond		:= ""
Local cCondUsr  := ""
Local cMes		:= "B3_Q"+StrZero(Month(dDataBase),2)

Local nTotCod   := 0
Local nCons		:= 0
Local nX		:= 0
Local nIndex    := 0

Local lA290CSD2 := ExistBlock("A290CSD2")
Local lMT290SD1 := ExistBlock("MT290SD1")
Local lMT290SD3 := ExistBlock("MT290SD3")

Local lM290QSD1 := ExistBlock("M290QSD1")
Local lM290QSD2 := ExistBlock("M290QSD2")
Local lM290QSD3 := ExistBlock("M290QSD3")

Local lRetPE	:= .F.
Local lConsumo  := .F.
Local lQuery	:= .F.
Local dDataIni  := Ctod("01/"+StrZero(Month(dDataBase),2,0)+"/"+StrZero(Year(dDataBase),4,0))
Local dDataFim  := LastDay(dDataBase)

Local lM290QSB1 := ExistBlock("M290QSB1")
Local cOpcoes	:= ""
Local cQuery	:= ""
Local cQueryUsr	:= ""

l290Cons := If(l290Cons==NIL,ExistBlock("A290CONS"),l290Cons)

//��������������������������������������������������������������Ŀ
//� Zera o arquivo de consumos antes de recalcular               �
//����������������������������������������������������������������
dbSelectArea("SB3")

lQuery	  := .T.
cAliasSB3 := GetNextAlias()
cAliasSB1 := cAliasSB3
cQuery := "SELECT B3_FILIAL,B3_COD,SB3.R_E_C_N_O_ RECNOSB3 "
cQuery += "FROM " + RetSqlName("SB3") + " SB3 "
cQuery += "JOIN " + RetSqlName("SB1") + " SB1 "
cQuery += "ON  B1_FILIAL = '" + xFilial("SB1") + "' "
cQuery += "AND B1_COD = B3_COD "
cQuery += "AND B1_COD >= '"+mv_par03+"' AND B1_COD <= '"+mv_par04+"' "
cQuery += "AND SB1.D_E_L_E_T_ = ' ' "
cQuery += "WHERE SB3.B3_FILIAL='"+xFilial("SB3")+ "' "
cQuery += "AND SB3.D_E_L_E_T_ = ' ' "
If aOpcoes[8][1] != "**" .And. !Empty(aOpcoes[8][1])
	cOpcoes := Trim(aOpcoes[8][1])
	cOpcoes := Substr(cOpcoes,1,Len(cOpcoes)-1)
	cQuery += "AND SB1.B1_TIPO IN ('"+StrTran(cOpcoes,"|","','")+"') "
EndIf
If aOpcoes[9][1] != "**" .And. !Empty(aOpcoes[9][1])
	cOpcoes := Trim(aOpcoes[9][1])
	cOpcoes := Substr(cOpcoes,1,Len(cOpcoes)-1)
	cQuery += "AND SB1.B1_GRUPO IN ('"+StrTran(cOpcoes,"|","','")+"') "
EndIf
//�����������������������������������������������������������������������������������Ŀ
//� M290QSB1 - Ponto de Entrada utilizado para adicionar filtro na query (ref. SB1)   |
//�������������������������������������������������������������������������������������
If lM290QSB1
	cQueryUsr := ExecBlock("M290QSB1",.F.,.F.)
	If ValType(cQueryUsr) == "C"
		cQuery += cQueryUsr
	EndIf
EndIf
cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSB3,.T.,.T.)
dbGoTop()

While !EOF() .And. IIf(lQuery,.T.,(cAliasSB3)->B3_FILIAL+(cAliasSB3)->B3_COD <= xFilial("SB3")+mv_par04)

	//��������������������������������������������Ŀ
	//� Posiciona na tabela SB3 para gravar cMes   |
	//����������������������������������������������
	If lQuery
		dbSelectArea("SB3")
		dbGoto((cAliasSB3)->RECNOSB3)
	Else
		dbSelectArea("SB1")
		dbSeek(xFilial("SB1")+(cAliasSB3)->B3_COD)
		If !MA290Filtro()
			dbSelectArea(cAliasSB3)
			dbSkip()
			Loop
		EndIf	
		dbSelectArea("SB3")
	EndIf
	
	RecLock("SB3",.F.)
	Replace &(cMes) With 0
	MsUnlock()

	dbSelectArea(cAliasSB3)
	dbSkip()

	If !lBat
		If oCenterPanel <> NIL
			oCenterPanel:IncRegua1(OemToAnsi(STR0033))
		Else
			IncProc()	
		EndIf
	EndIf
EndDo

If lQuery
	dbSelectArea(cAliasSB3)
	dbCloseArea()
EndIf


// Processar Pedidos de Vendas - espec�fico KOMFORTHOUSE - Cristiam Rossi em 24/03/2017

cAliasPV := GetNextAlias()
cQuery := "SELECT C5_FILIAL, C6_PRODUTO, C6_QTDVEN, C5_EMISSAO, C5_TIPO, SC6.R_E_C_N_O_ RECNOSC6 "
cQuery += "FROM "+RetSqlName("SC6")+" SC6 "

cQuery += "JOIN " + RetSqlName("SC5") + " SC5 "
cQuery += "ON  C5_FILIAL = '" + xFilial("SC5") + "' "
cQuery += "AND C5_NUM = C6_NUM "
cQuery += "AND SC5.D_E_L_E_T_ = ' ' "

cQuery += "JOIN " + RetSqlName("SB1") + " SB1 "
cQuery += "ON  B1_FILIAL = '" + xFilial("SB1") + "' "
cQuery += "AND B1_COD = C6_PRODUTO "
cQuery += "AND B1_COD >= '"+mv_par03+"' AND B1_COD <= '"+mv_par04+"' "
cQuery += "AND SB1.D_E_L_E_T_ = ' ' "

cQuery += "AND B1_TIPO = 'ME' "	// considerar tipo ME, espec�fico KOMFORTHOUSE - Cristiam em 24/03/2017

cQuery += "WHERE SC5.C5_FILIAL='"+xFilial("SC5")+ "' "
cQuery += "AND C6_LOCAL >= '"+mv_par01+"' AND C6_LOCAL <= '"+mv_par02+"' "
cQuery += "AND C5_EMISSAO >= '" + DTOS(dDataIni)	+ "' "
cQuery += "AND C5_EMISSAO <= '" + DTOS(dDataFim)	+ "' "

cQuery += "AND C6_BLQ = '' "	// n�o considerar res�duos

cQuery += "AND SC6.D_E_L_E_T_=' ' "

If aOpcoes[8][1] != "**" .And. !Empty(aOpcoes[8][1])
	cOpcoes := Trim(aOpcoes[8][1])
	cOpcoes := Substr(cOpcoes,1,Len(cOpcoes)-1)
	cQuery += " AND SB1.B1_TIPO IN ('"+StrTran(cOpcoes,"|","','")+"') "
EndIf

If aOpcoes[9][1] != "**" .And. !Empty(aOpcoes[9][1])
	cOpcoes := Trim(aOpcoes[9][1])
	cOpcoes := Substr(cOpcoes,1,Len(cOpcoes)-1)
	cQuery += " AND SB1.B1_GRUPO IN ('"+StrTran(cOpcoes,"|","','")+"') "
EndIf

cQuery += " order by C6_PRODUTO"

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasPV,.T.,.T.)
dbGoTop()

TcSetField(cAliasPV,"C6_QTDVEN"  ,"N", TamSx3("C6_QTDVEN")[1] , TamSx3("C6_QTDVEN")[2]  )
TcSetField(cAliasPV,"C5_EMISSAO" ,"D", TamSx3("C5_EMISSAO")[1], TamSx3("C5_EMISSAO")[2] )

While ! (cAliasPV)->( EOF() )

	cCod := (cAliasPV)->C6_PRODUTO
	If !lQuery
		dbSelectArea("SB1")
		dbSeek(xFilial("SB1")+cCod)
		If !MA290Filtro()
			dbSelectArea(cAliasPV)
			dbSkip()
			Loop
		EndIf	
		dbSelectArea(cAliasPV)
	EndIf	

	nTotCod := 0

	While ! (cAliasPV)->( EOF() ) .and. cCod == (cAliasPV)->C6_PRODUTO

		nTotCod += (cAliasPV)->C6_QTDVEN

		(cAliasPV)->( dbSkip() )
	end
	
	dbSelectArea("SB3")
	dbSeek(xFilial("SB3")+cCod)
	If EOF()
		RecLock("SB3",.T.)
		Replace B3_FILIAL With xFilial("SB3"), B3_COD With cCod
	Else
		RecLock("SB3",.F.)
	EndIf
	Replace &(cMes) With &(cMes) + nTotCod
	MsUnlock()
	
	dbSelectArea(cAliasPV)
EndDo

(cAliasPV)->( dbCloseArea() )

//---------------------------------------------------------------- fim processar pedidos de vendas

//��������������������������������������������������������������Ŀ
//� Processa o arquivo SD2 -> Itens das notas fiscais de entrada �
//����������������������������������������������������������������
dbSelectArea("SD2") // itens das notas fiscais de saida
dbSetOrder(1)

cAliasSD2 := GetNextAlias()
cQuery := "SELECT D2_FILIAL,D2_COD,D2_QUANT,D2_EMISSAO,D2_REMITO,D2_TES,D2_TIPO,D2_ORIGLAN,SD2.R_E_C_N_O_ RECNOSD2 "
cQuery += "FROM "+RetSqlName("SD2")+" SD2 "

cQuery += "JOIN " + RetSqlName("SB1") + " SB1 "
cQuery += "ON  B1_FILIAL = '" + xFilial("SB1") + "' "
cQuery += "AND B1_COD = D2_COD "
cQuery += "AND B1_COD >= '"+mv_par03+"' AND B1_COD <= '"+mv_par04+"' "
cQuery += "AND SB1.D_E_L_E_T_ = ' ' "

cQuery += "AND B1_TIPO <> 'ME' "	// n�o considerar tipo ME, espec�fico KOMFORTHOUSE - Cristiam em 24/03/2017

cQuery += "WHERE SD2.D2_FILIAL='"+xFilial("SD2")+ "' "
cQuery += "AND D2_LOCAL >= '"+mv_par01+"' AND D2_LOCAL <= '"+mv_par02+"' "
cQuery += "AND D2_EMISSAO >= '" + DTOS(dDataIni)	+ "' "
cQuery += "AND D2_EMISSAO <= '" + DTOS(dDataFim)	+ "' "
cQuery += "AND D2_ORIGLAN <> 'LF' AND D2_TIPO IN ('N','B') "
cQuery += "AND D2_REMITO = '"+CriaVar("D2_REMITO",.F.)+"' "
cQuery += "AND SD2.D_E_L_E_T_=' ' "
//��������������������������������������������������������������������Ŀ
//� M290QSD2 - Ponto de Entrada para adicionar filtro na query do SD2  |
//����������������������������������������������������������������������
If lM290QSD2
	cQueryUsr := ExecBlock("M290QSD2",.F.,.F.)
	If ValType(cQueryUsr) == "C"
		cQuery += cQueryUsr
	EndIf
EndIf
If aOpcoes[8][1] != "**" .And. !Empty(aOpcoes[8][1])
	cOpcoes := Trim(aOpcoes[8][1])
	cOpcoes := Substr(cOpcoes,1,Len(cOpcoes)-1)
	cQuery += " AND SB1.B1_TIPO IN ('"+StrTran(cOpcoes,"|","','")+"') "
EndIf
If aOpcoes[9][1] != "**" .And. !Empty(aOpcoes[9][1])
	cOpcoes := Trim(aOpcoes[9][1])
	cOpcoes := Substr(cOpcoes,1,Len(cOpcoes)-1)
	cQuery += " AND SB1.B1_GRUPO IN ('"+StrTran(cOpcoes,"|","','")+"') "
EndIf
//�����������������������������������������������������������������������������������Ŀ
//� M290QSB1 - Ponto de Entrada utilizado para adicionar filtro na query (ref. SB1)   |
//�������������������������������������������������������������������������������������
If lM290QSB1
	cQueryUsr := ExecBlock("M290QSB1",.F.,.F.)
	If ValType(cQueryUsr) == "C"
		cQuery += cQueryUsr
	EndIf
EndIf

cQuery += " ORDER BY "+SqlOrder(SD2->(IndexKey()))
cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD2,.T.,.T.)
dbGoTop()

TcSetField(cAliasSD2,"D2_QUANT"   ,"N", TamSx3("D2_QUANT")[1], TamSx3("D2_QUANT")[2] )
TcSetField(cAliasSD2,"D2_EMISSAO" ,"D", TamSx3("D2_EMISSAO")[1], TamSx3("D2_EMISSAO")[2] )

While !EOF()

	cCod    := D2_COD
	If !lQuery
		dbSelectArea("SB1")
		dbSeek(xFilial("SB1")+cCod)
		If !MA290Filtro()
			dbSelectArea(cAliasSD2)
			dbSkip()
			Loop
		EndIf	
		dbSelectArea(cAliasSD2)
	EndIf	
	nTotCod := 0
	lConsumo:= .F.

	While !EOF() .And. (cAliasSD2)->D2_COD == cCod

		lConsumo:= .T.
		dbSelectArea("SF4")
		dbSeek(xFilial("SF4")+(cAliasSD2)->D2_TES)
		dbSelectArea(cAliasSD2)
		If SF4->F4_ESTOQUE == "S"

			//-- Nao permite remessa de poder de terceiros
			If SF4->F4_PODER3 == "D"
				dbSelectArea(cAliasSD2)
				dbSkip()
				Loop
			EndIf

			//����������������������������������������������������������������Ŀ
			//� A290CSD2 - Ponto de Entrada para filtrar a tabela SD2 (ANTIGO) �
			//������������������������������������������������������������������
			If lA290CSD2
				dbSelectArea("SD2") // posiciona o arq. para o filtro logico do usuario
				If lQuery
					dbGoto((cAliasSD2)->RECNOSD2)
				EndIf	
				If ValType(lRetPE := ExecBlock("A290CSD2",.F.,.F.,{"SD2"})) == "L" .And. !lRetPE
					dbSelectArea(cAliasSD2)
					dbSkip()
					Loop
				EndIf
				dbSelectArea(cAliasSD2)
			EndIf

			If (cAliasSD2)->D2_TES <= "500"
				nTotCod := nTotCod - (cAliasSD2)->D2_QUANT
			Else
				nTotCod := nTotCod + (cAliasSD2)->D2_QUANT
			EndIf
		EndIf
		
		dbSkip()
		
		//��������������������������������������������������������������Ŀ
		//� Movimentacao do Cursor                                       �
		//����������������������������������������������������������������
		If !lBat
			If oCenterPanel <> NIL
				oCenterPanel:IncRegua1(OemToAnsi(STR0034))
			Else
				IncProc()
			EndIf
		EndIf
	EndDo
	
	If lConsumo
		dbSelectArea("SB3")
		dbSeek(xFilial("SB3")+cCod)
		If EOF()
			RecLock("SB3",.T.)
			Replace B3_FILIAL With xFilial("SB3"), B3_COD With cCod
		Else
			RecLock("SB3",.F.)
		EndIf
		Replace &(cMes) With &(cMes) + nTotCod
		MsUnlock()
	EndIf
	
	dbSelectArea(cAliasSD2)
EndDo

If !lQuery
	RetIndex("SD2")
	dbClearFilter()
	Ferase(cIndex+OrdBagExt())
EndIf

//��������������������������������������������������������������Ŀ
//� Processa o arquivo SD1 -> Itens das notas fiscais de Dev.Vdas�
//����������������������������������������������������������������
dbSelectArea("SD1") // Itens das notas fiscais de entrada
dbSetOrder(5) //D1_FILIAL+D1_COD+D1_LOCAL

cAliasSD1 := GetNextAlias()
cQuery := "SELECT D1_FILIAL,D1_COD,D1_ORIGLAN,D1_TIPO,D1_REMITO,D1_DTDIGIT,D1_TES,D1_QUANT,SD1.R_E_C_N_O_ RECNOSD1 "
cQuery += "FROM "+RetSqlName("SD1")+" SD1 "

cQuery += "JOIN " + RetSqlName("SB1") + " SB1 "
cQuery += "ON  B1_FILIAL = '" + xFilial("SB1") + "' "
cQuery += "AND B1_COD = D1_COD "
cQuery += "AND B1_COD >= '"+mv_par03+"' AND B1_COD <= '"+mv_par04+"' "
cQuery += "AND SB1.D_E_L_E_T_ = ' ' "

cQuery += "WHERE SD1.D1_FILIAL='"+xFilial("SD1")+ "' "
cQuery += "AND D1_LOCAL >= '"+mv_par01+"' AND D1_LOCAL <= '"+mv_par02+"' "
cQuery += "AND D1_DTDIGIT >= '" + DTOS(dDataIni)	+ "' "
cQuery += "AND D1_DTDIGIT <= '" + DTOS(dDataFim)	+ "' "
cQuery += "AND D1_ORIGLAN <> 'LF' AND D1_TIPO IN ('D','B','N') "
cQuery += "AND D1_REMITO = '"+CriaVar("D1_REMITO",.F.)+"' "
cQuery += "AND SD1.D_E_L_E_T_=' ' "
//��������������������������������������������������������������������Ŀ
//� M290QSD1 - Ponto de Entrada para adicionar filtro na query do SD1  |
//����������������������������������������������������������������������
If lM290QSD1
	cQueryUsr := ExecBlock("M290QSD1",.F.,.F.)
	If ValType(cQueryUsr) == "C"
		cQuery += cQueryUsr
	EndIf
EndIf
If aOpcoes[8][1] != "**" .And. !Empty(aOpcoes[8][1])
	cOpcoes := Trim(aOpcoes[8][1])
	cOpcoes := Substr(cOpcoes,1,Len(cOpcoes)-1)
	cQuery += " AND SB1.B1_TIPO IN ('"+StrTran(cOpcoes,"|","','")+"') "
EndIf
If aOpcoes[9][1] != "**" .And. !Empty(aOpcoes[9][1])
	cOpcoes := Trim(aOpcoes[9][1])
	cOpcoes := Substr(cOpcoes,1,Len(cOpcoes)-1)
	cQuery += " AND SB1.B1_GRUPO IN ('"+StrTran(cOpcoes,"|","','")+"') "
EndIf
//�����������������������������������������������������������������������������������Ŀ
//� M290QSB1 - Ponto de Entrada utilizado para adicionar filtro na query (ref. SB1)   |
//�������������������������������������������������������������������������������������
If lM290QSB1
	cQueryUsr := ExecBlock("M290QSB1",.F.,.F.)
	If ValType(cQueryUsr) == "C"
		cQuery += cQueryUsr
	EndIf
EndIf
cQuery += " ORDER BY "+SqlOrder(SD1->(IndexKey()))
cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD1,.T.,.T.)
dbGoTop()

TcSetField(cAliasSD1,"D1_QUANT"   ,"N", TamSx3("D1_QUANT")[1]  , TamSx3("D1_QUANT")[2] )
TcSetField(cAliasSD1,"D1_DTDIGIT" ,"D", TamSx3("D1_DTDIGIT")[1], TamSx3("D1_DTDIGIT")[2] )

While !EOF()

	cCod    := (cAliasSD1)->D1_COD
	If !lQuery
		dbSelectArea("SB1")
		dbSeek(xFilial("SB1")+cCod)
		If !MA290Filtro()
			dbSelectArea(cAliasSD1)
			dbSkip()
			Loop
		EndIf	
		dbSelectArea(cAliasSD1)
	EndIf	
	nTotCod	:= 0
	lConsumo:= .F.

	While !EOF() .And. (cAliasSD1)->D1_COD == cCod
		
		lConsumo := .T.
		dbSelectArea("SF4")
		dbSeek(xFilial("SF4")+(cAliasSD1)->D1_TES)
		dbSelectArea(cAliasSD1)
		If SF4->F4_ESTOQUE == "S"
			//-- Valida se permite poder de terceiros na entrada
			If (cAliasSD1)->D1_TIPO $ 'B|N'
				If SF4->F4_PODER3 # "D"
					dbSelectArea(cAliasSD1)
					dbSkip()
					Loop
				EndIf
			EndIf	
			//����������������������������������������������������������������������������Ŀ
			//� MT290SD1 - Ponto de Entrada para adicionar filtro na query do SD1 (ANTIGO) |
			//������������������������������������������������������������������������������
			If lMt290SD1
				dbSelectArea("SD1")
				If lQuery
					dbGoto((cAliasSD1)->RECNOSD1)
				EndIf
				If ValType(lRetPE := ExecBlock("MT290SD1",.F.,.F.)) == "L" .And. !lRetPE
					dbSelectArea(cAliasSD1)
					dbSkip()
					Loop
				EndIf
				dbSelectArea(cAliasSD1)
			EndIf

			If (cAliasSD1)->D1_TES <= "500"
				nTotCod := nTotCod - (cAliasSD1)->D1_QUANT
			Else
				nTotCod := nTotCod + (cAliasSD1)->D1_QUANT
			EndIf

		EndIf
		
		dbSkip()

		//��������������������������������������������������������������Ŀ
		//� Movimentacao do Cursor                                       �
		//����������������������������������������������������������������
		If !lBat
			If oCenterPanel <> NIL
				oCenterPanel:IncRegua1(OemToAnsi(STR0035))
			Else
				IncProc()
			EndIf
		EndIf

	EndDo

	If lConsumo
		dbSelectArea("SB3")
		dbSeek(xFilial("SB3")+cCod)
		If EOF()
			RecLock("SB3",.T.)
			Replace B3_FILIAL With xFilial("SB3"), B3_COD With cCod
		Else
			RecLock("SB3",.F.)
		EndIf
		Replace &(cMes) With &(cMes) + nTotCod
		MsUnlock()
	EndIf
		
	dbSelectArea(cAliasSD1)
EndDo

If !lQuery
	RetIndex("SD1")
	dbClearFilter()
	Ferase(cIndex+OrdBagExt())
EndIf

//��������������������������������������������������������������Ŀ
//� Processa o arquivo SD3 -> Movimentacoes Internas             �
//����������������������������������������������������������������
dbSelectArea("SD3")	// Movimentacoes Internas
dbSetOrder(3)       // D3_FILIAL+D3_COD+D3_LOCAL

cAliasSD3 := GetNextAlias()
cQuery := "SELECT D3_FILIAL,D3_COD,D3_TM,D3_CF,D3_EMISSAO,D3_QUANT,SD3.R_E_C_N_O_ RECNOSD3 "
cQuery += "FROM "+RetSqlName("SD3")+" SD3 "

cQuery += "JOIN " + RetSqlName("SB1") + " SB1 "
cQuery += "ON  B1_FILIAL = '" + xFilial("SB1") + "' "
cQuery += "AND B1_COD = D3_COD "
cQuery += "AND B1_COD >= '"+mv_par03+"' AND B1_COD <= '"+mv_par04+"' "
cQuery += "AND SB1.D_E_L_E_T_ = ' ' "

cQuery += "WHERE SD3.D3_FILIAL='"+xFilial("SD3")+ "' "
cQuery += "AND D3_LOCAL >= '"+mv_par01+"' AND D3_LOCAL <= '"+mv_par02+"' "
cQuery += "AND D3_EMISSAO >= '" + DTOS(dDataIni)	+ "' "
cQuery += "AND D3_EMISSAO <= '" + DTOS(dDataFim)	+ "' "
cQuery += "AND D3_CF <> 'DE8' AND  D3_CF  <>  'RE8' "
cQuery += IIf(mv_par06 == 2,"AND D3_DOC <> 'INVENT' ",'')
cQuery += "AND SD3.D_E_L_E_T_=' ' "

//��������������������������������������������������������������������Ŀ
//� MT290SD3 - Ponto de Entrada para adicionar filtro na query do SD3  |
//����������������������������������������������������������������������
If lM290QSD3
	cQueryUsr := ExecBlock("M290QSD3",.F.,.F.)
	If ValType(cQueryUsr) == "C"
		cQuery += cQueryUsr
	EndIf
EndIf
If aOpcoes[8][1] != "**" .And. !Empty(aOpcoes[8][1])
	cOpcoes := Trim(aOpcoes[8][1])
	cOpcoes := Substr(cOpcoes,1,Len(cOpcoes)-1)
	cQuery += " AND SB1.B1_TIPO IN ('"+StrTran(cOpcoes,"|","','")+"') "
EndIf
If aOpcoes[9][1] != "**" .And. !Empty(aOpcoes[9][1])
	cOpcoes := Trim(aOpcoes[9][1])
	cOpcoes := Substr(cOpcoes,1,Len(cOpcoes)-1)
	cQuery += " AND SB1.B1_GRUPO IN ('"+StrTran(cOpcoes,"|","','")+"') "
EndIf
//�����������������������������������������������������������������������������������Ŀ
//� M290QSB1 - Ponto de Entrada utilizado para adicionar filtro na query (ref. SB1)   |
//�������������������������������������������������������������������������������������
If lM290QSB1
	cQueryUsr := ExecBlock("M290QSB1",.F.,.F.)
	If ValType(cQueryUsr) == "C"
		cQuery += cQueryUsr
	EndIf
EndIf
cQuery += " ORDER BY "+SqlOrder(SD3->(IndexKey()))
cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD3,.T.,.T.)
dbGoTop()

TcSetField(cAliasSD3,"D3_QUANT"   ,"N", TamSx3("D3_QUANT")[1]  , TamSx3("D3_QUANT")[2] )
TcSetField(cAliasSD3,"D3_EMISSAO" ,"D", TamSx3("D3_EMISSAO")[1], TamSx3("D3_EMISSAO")[2] )

While !EOF() 

	cCod    := (cAliasSD3)->D3_COD
	nTotCod := 0
	lConsumo:= .F.

	While !EOF() .And. (cAliasSD3)->D3_COD == cCod

		If Subs((cAliasSD3)->D3_CF,2,1) == "E" .And. !Substr((cAliasSD3)->D3_CF,3,1) $ "3478"

			If !lQuery
				dbSelectArea("SB1")
				dbSeek(xFilial("SB1")+cCod)
				If !MA290Filtro()
					dbSelectArea(cAliasSD3)
					dbSkip()
					Loop
				EndIf	
				dbSelectArea(cAliasSD3)
			EndIf	

    		lConsumo := .T.              
	
			//��������������������������������������������������������������������Ŀ
			//� MT290SD3 - Ponto de Entrada para adicionar filtro no SD3 (ANTIGO)  |
			//����������������������������������������������������������������������
			If lMt290SD3
				dbSelectArea("SD3")
				If lQuery
					dbGoto((cAliasSD3)->RECNOSD3)
				EndIf
				If ValType(lRetPE := ExecBlock("MT290SD3",.F.,.F.)) == "L" .And. !lRetPE
					dbSelectArea(cAliasSD3)
					dbSkip()
					Loop
				EndIf
				dbSelectArea(cAliasSD3)
			EndIf
				
			If (cAliasSD3)->D3_TM <= "500"
				nTotCod := nTotCod - (cAliasSD3)->D3_QUANT
			Else
				nTotCod := nTotCod + (cAliasSD3)->D3_QUANT
			EndIf

		EndIf

		dbSkip()
		//��������������������������������������������������������������Ŀ
		//� Movimentacao do Cursor                                       �
		//����������������������������������������������������������������
		If !lBat
			If oCenterPanel <> NIL
				oCenterPanel:IncRegua1(OemToAnsi(STR0036))
			Else
				IncProc()
			EndIf
		EndIf
	EndDo

	If lConsumo
		//������������������������������������������������������������������������Ŀ
		//� A290CONS - Ponto de Entrada utilizado para alterar o consumo calculado �
		//��������������������������������������������������������������������������
		If l290Cons
			nCons:=ExecBlock("A290CONS",.F.,.F.,{cCod,nTotCod})
			If ValType(nCons) == "N"
				nTotCod:=nCons
			EndIf
		EndIf
	
		dbSelectArea("SB3")
		dbSeek(xFilial("SB3")+cCod)
		If EOF()
			RecLock("SB3",.T.)
			Replace B3_FILIAL With xFilial("SB3"), B3_COD With cCod
		Else
			RecLock("SB3",.F.)
		EndIf
		Replace &(cMes) With &(cMes) + nTotCod
	
		MsUnlock()
	EndIf
		
	dbSelectArea(cAliasSD3)
EndDo
If !lQuery
	RetIndex("SD3")
	dbClearFilter()
	Ferase(cIndex+OrdBagExt())
EndIf
//��������������������������������������������������������������Ŀ
//� Devolve ordem principal dos arquivos                         �
//����������������������������������������������������������������
(cAliasSD1)->(dbCloseArea())
(cAliasSD2)->(dbCloseArea())
(cAliasSD3)->(dbCloseArea())
RETINDEX("SD1")
dbClearFilter()
RETINDEX("SD2")
dbClearFilter()
RETINDEX("SD3")
dbClearFilter()            
Return Nil

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A290CalNor� Autor � Eveli Morasco         � Data � 10/02/92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Calculo normal da media de consumos (utiliza os pesos)     ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � A290CalNor()                                               ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA290                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function A290CalNor(nPorInc,oCenterPanel)
Local nX,aPesos[12],cPesos,nTPesos:=0,nMeses,aPesoAux,nI,nConsid,aPesoUsr
Local nTamanho	:=TamSX3("B3_CTOTAL")[1]
Local nDecimais	:=TamSX3("B3_TOTAL")[2]
Local lA290CalP	:=ExistBlock("A290CALP")
Local lQuery	:= .F.
Local cAliasSB3	:= "SB3"
Local cAliasSB1	:= "SB1"
Local lM290QSB1 :=ExistBlock("M290QSB1")
Local cOpcoes	:= ""
Local cQuery	:= ""
Local cQueryUsr	:= ""

AFILL(aPesos,0)

//��������������������������������������������������������������Ŀ
//� Pega a configuracao de pesos do cliente                      �
//����������������������������������������������������������������
cPesos := GetMv("MV_PESOS")
cPesos := SubStr(cPesos,1,12)
cPesos := cPesos+Space(12-Len(cPesos))

For nX := 1 To 12
	aPesos[nX] := Val(SubStr(cPesos,nX,1))
Next nX

aPesoAux := aClone(aPesos)
//��������������������������������������������������������������Ŀ
//� Varre o arquivo de demandas e verifica filtro no SB1         �
//����������������������������������������������������������������
dbSelectArea("SB3")

lQuery	  := .T.
cAliasSB3 := GetNextAlias()
cAliasSB1 := cAliasSB3
cQuery := "SELECT SB3.B3_FILIAL,SB3.B3_COD,SB3.R_E_C_N_O_ RECNOSB3,"
cQuery += "SB1.B1_FILIAL,SB1.B1_COD,SB1.B1_CONINI,SB1.B1_CUSTD,SB1.R_E_C_N_O_ RECNOSB1  "
cQuery += "FROM " + RetSqlName("SB3") + " SB3 "
cQuery += "JOIN " + RetSqlName("SB1") + " SB1 "
cQuery += "ON  B1_FILIAL = '" + xFilial("SB1") + "' "
cQuery += "AND B1_COD = B3_COD "
cQuery += "AND B1_COD >= '"+mv_par03+"' AND B1_COD <= '"+mv_par04+"' "
cQuery += "AND SB1.D_E_L_E_T_ = ' ' "
cQuery += "WHERE SB3.B3_FILIAL='"+xFilial("SB3")+ "' "
cQuery += "AND SB3.D_E_L_E_T_=' ' "
If aOpcoes[8][1] != "**" .And. !Empty(aOpcoes[8][1])
	cOpcoes := Trim(aOpcoes[8][1])
	cOpcoes := Substr(cOpcoes,1,Len(cOpcoes)-1)
	cQuery += "AND SB1.B1_TIPO IN ('"+StrTran(cOpcoes,"|","','")+"') "
EndIf
If aOpcoes[9][1] != "**" .And. !Empty(aOpcoes[9][1])
	cOpcoes := Trim(aOpcoes[9][1])
	cOpcoes := Substr(cOpcoes,1,Len(cOpcoes)-1)
	cQuery += "AND SB1.B1_GRUPO IN ('"+StrTran(cOpcoes,"|","','")+"') "
EndIf
//�����������������������������������������������������������������������������������Ŀ
//� M290QSB1 - Ponto de Entrada utilizado para adicionar filtro na query (ref. SB1)   |
//�������������������������������������������������������������������������������������
If lM290QSB1
	cQueryUsr := ExecBlock("M290QSB1",.F.,.F.)
	If ValType(cQueryUsr) == "C"
		cQuery += cQueryUsr
	EndIf
EndIf
cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSB3,.T.,.T.)
dbGoTop()

TcSetField(cAliasSB3,"B1_CUSTD" ,"N", TamSx3("B1_CUSTD")[1], TamSx3("B1_CUSTD")[2] )
TcSetField(cAliasSB3,"B1_CONINI","D", 8, 0)

While !EOF() .And. IIf(lQuery,.T.,(cAliasSB3)->B3_FILIAL+(cAliasSB3)->B3_COD <= xFilial("SB3")+mv_par04)
	If !lQuery
		dbSelectArea("SB1")
		dbSeek(xFilial("SB1")+(cAliasSB3)->B3_COD)
	EndIf		

	If MA290Filtro(lQuery)

		nMeses := CalcMeses(RetFldProd((cAliasSB1)->B1_COD,"B1_CONINI",cAliasSB1))
		aPesos := aClone(aPesoAux)
		nI := nMeses
	
		If nMeses < 12
			nX := (Month(dDataBase)+1) - nMeses
			If nX <= 0
				nX += 12
			EndIf
			If nX = 13
				nX := 1
			EndIf
			aPesos := {0,0,0,0,0,0,0,0,0,0,0,0}
			If nMeses > 0
				nConsid := Month(dDataBase)+1
				nConsid := IIF(nConsid >12,1,nConsid)
				While nX != nConsid
					aPesos[nX] := aPesoAux[nX]
					nX++
					nX := IIF(nX>12,1,nX)
				End
			EndIf
		EndIf

		//�����������������������������������������������������������Ŀ
		//� Ponto de entrada p/ manipulacao de meses para calculo	  �
		//�������������������������������������������������������������
		If lA290CalP
			aPesoUsr := ExecBlock("A290CALP",.F.,.F.,{nMeses,aPesos,aPesoAux,cAliasSB1,cAliasSB3})
			If ValType(aPesoUsr) == "A"
				aPesos := aClone(aPesoUsr)
			EndIf
		EndIf	
		
		nTpesos := 0
		For nX := 1 To 12
			nTpesos    += aPesos[nX]
		Next nX
	
		dbSelectArea("SB3")
		If lQuery
			dbGoto((cAliasSB3)->RECNOSB3)
		EndIf
		RecLock("SB3",.F.)
		Replace  B3_MEDIA With ((	B3_Q01*aPesos[01]+B3_Q02*aPesos[02]+B3_Q03*aPesos[03]+;
									B3_Q04*aPesos[04]+B3_Q05*aPesos[05]+B3_Q06*aPesos[06]+;
									B3_Q07*aPesos[07]+B3_Q08*aPesos[08]+B3_Q09*aPesos[09]+;
									B3_Q10*aPesos[10]+B3_Q11*aPesos[11]+B3_Q12*aPesos[12])/;
									nTpesos)*(1+nPorInc/100)
		//-- Se o consumo medio for negativo zerar o consumo medio
		If mv_par05 == 1
			If B3_MEDIA < 0 
				Replace B3_MEDIA With 0
			EndIf
		EndIf
		Replace	B3_TOTAL  With B3_MEDIA*RetFldProd((cAliasSB1)->B1_COD,"B1_CUSTD",cAliasSB1)
		Replace	B3_CTOTAL With StrZero(B3_TOTAL,nTamanho,nDecimais)
		Replace B3_MES    With dDatabase
		MsUnlock()
	EndIf
	dbSelectArea(cAliasSB3)
	dbSkip()
	If !lBat
		If oCenterPanel <> NIL
			oCenterPanel:IncRegua1(OemToAnsi(STR0037))
		Else
			IncProc()
		EndIf
	EndIf
EndDo
If lQuery
	(cAliasSB3)->(dbCloseArea())
EndIf
Return Nil

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A290CalMin� Autor � Eveli Morasco         � Data � 11/02/92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Calculo da media de consumos que utiliza o conceito dos    ���
���          � minimos quadrados.                                         ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � A290CalMin()                                               ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA290                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function A290CalMin(nQtdMes,oCenterPanel)
Local nX,cMesAux2,cMeses:="010203040506070809101112"
Local nTotx:=0,nMpx:=0,nToty:=0,nMpy:=0,nTotXaYa:=0,nTotXaXa:=0,nTotYaYa:=0
Local aX[nQtdMes],aY[nQtdMes],aXa[nQtdMes],aYa[nQtdMes]
Local aXaYa[nQtdMes],aXaXa[nQtdMes],aYaYa[nQtdMes]
Local nMesProj,nSX,nSY,nRXY,nK1,nK2,nYP,nMeses,nMesAux
Local nTamanho  :=TamSX3("B3_CTOTAL")[1]
Local nDecimais :=TamSX3("B3_TOTAL")[2]
Local lQuery	:= .F.
Local cAliasSB3	:= "SB3"
Local cAliasSB1	:= "SB1"
Local lM290QSB1 := ExistBlock("M290QSB1")
Local aStru     := {}
Local cOpcoes   := ""
Local cQuery    := ""
Local cQueryUsr	:= ""
nMesAux := nQtdMes

For nX := 1 To nQtdMes
	aX[nX]    := nX
	aY[nX]    := 0
	aXa[nX]   := 0
	aYa[nX]   := 0
	aXaYa[nX] := 0
	aXaXa[nX] := 0
	aYaYa[nX] := 0
Next nX

Store nQtdMes+1 To nMesProj

// DEFINICOES DO X  --> MESES

For nX := 1 To nQtdMes
	nTotx := nTotx + aX[nX]
Next
nMpx := nTotx/nQtdMes               // MEDIA PONDERADA DE X

//��������������������������������������������������������������Ŀ
//� Varre o arquivo de demandas e verifica filtro no SB1         �
//����������������������������������������������������������������
dbSelectArea("SB3")

aStru     := SB3->(dbStruct())
lQuery	  := .T.
cAliasSB3 := GetNextAlias()
cAliasSB1 := cAliasSB3
cQuery := "SELECT SB3.*,SB3.R_E_C_N_O_ RECNOSB3,"
cQuery += "SB1.B1_FILIAL,SB1.B1_COD,SB1.B1_CONINI,SB1.B1_CUSTD,SB1.R_E_C_N_O_ RECNOSB1 "
cQuery += "FROM " + RetSqlName("SB3") + " SB3 "
cQuery += "JOIN " + RetSqlName("SB1") + " SB1 "
cQuery += "ON B1_FILIAL = '" + xFilial("SB1") + "' "
cQuery += "AND B1_COD = B3_COD "
cQuery += "AND B1_COD >= '" + mv_par03 + "' AND B1_COD <= '" + mv_par04 + "' "
cQuery += "AND SB1.D_E_L_E_T_ = ' ' "
cQuery += "WHERE SB3.B3_FILIAL='" + xFilial("SB3") + "' "
cQuery += "AND SB3.D_E_L_E_T_=' ' "
If aOpcoes[8][1] != "**" .And. !Empty(aOpcoes[8][1])
	cOpcoes := Trim(aOpcoes[8][1])
	cOpcoes := Substr(cOpcoes,1,Len(cOpcoes)-1)
	cQuery += "AND SB1.B1_TIPO IN ('"+StrTran(cOpcoes,"|","','")+"') "
EndIf
If aOpcoes[9][1] != "**" .And. !Empty(aOpcoes[9][1])
	cOpcoes := Trim(aOpcoes[9][1])
	cOpcoes := Substr(cOpcoes,1,Len(cOpcoes)-1)
	cQuery += "AND SB1.B1_GRUPO IN ('"+StrTran(cOpcoes,"|","','")+"') "
EndIf
//�����������������������������������������������������������������������������������Ŀ
//� M290QSB1 - Ponto de Entrada utilizado para adicionar filtro na query (ref. SB1)   |
//�������������������������������������������������������������������������������������
If lM290QSB1
	cQueryUsr := ExecBlock("M290QSB1",.F.,.F.)
	If ValType(cQueryUsr) == "C"
		cQuery += cQueryUsr
	EndIf
EndIf

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSB3,.T.,.T.)
dbGoTop()

For nX := 1 To Len(aStru)
	If ( aStru[nX][2] <> "C")
		TcSetField(cAliasSB3,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
	EndIf
Next
TcSetField(cAliasSB3,"B1_CUSTD" ,"N", TamSx3("B1_CUSTD")[1], TamSx3("B1_CUSTD")[2] )
TcSetField(cAliasSB3,"B1_CONINI","D", 8, 0)

While !EOF() .And. IIf(lQuery,.T.,(cAliasSB3)->B3_FILIAL+(cAliasSB3)->B3_COD <= xFilial("SB3")+mv_par04)

	nToty    := 0
	nTotXaYa := 0
	nTotXaXa := 0
	nTotYaYa := 0

	If !lQuery
		dbSelectArea("SB1")
		dbSeek(xFilial("SB1")+(cAliasSB3)->B3_COD)
	EndIf		

	If MA290Filtro(lQuery)

		nQtdMes := CalcMeses(RetFldProd((cAliasSB1)->B1_COD,"B1_CONINI",cAliasSB1),nMesAux)

		dbSelectArea(cAliasSB3)
		
		// DEFINICOES DO Y  --> QTDES
		For nX := 1 To nQtdMes
			STORE "B3_Q"+SUBS(cMeses+cMeses,(24+Month(dDataBase)*2)-1-(nQtdMes-nX)*2,2) TO cMesAux2
			aY[nX] := &(cMesAux2)
			nToty  := nToty + aY[nX]
		Next nX
		nMpy := nToty/nQtdMes               // MEDIA PONDERADA DE Y
		
		For nX := 1 To nQtdMes
			
			// CALCULO DO XA
			aXa[nX] := aX[nX] - nMpx
			
			// CALCULO DO YA
			aYa[nX] := aY[nX] - nMpy
			
			// CALCULO DO XA*YA
			aXaYa[nX] := aXa[nX]  * aYa[nX]
			nTotXaYa  := nTotXaYa + aXaYa[nX]
			
			// CALCULO DO XA*XA
			aXaXa[nX] := aXa[nX]  * aXa[nX]
			nTotXaXa  := nTotXaXa + aXaXa[nX]
			
			// CALCULO DO YA*YA
			aYaYa[nX] := aYa[nX]  * aYa[nX]
			nTotYaYa  := nTotYaYa + aYaYa[nX]
		Next nX
		
		nSX  := Abs( Sqrt( nTotXaXa / nQtdMes ) )
		nSY  := Abs( Sqrt( nTotYaYa / nQtdMes ) )
		nRXY := nTotXaYa / ( nQtdMes * nSX * nSY )
		nK1  := nRXY * ( nSX / nSY )
		nK2  := nRXY * ( nSY / nSX )
		nYP  := ( nK2 * nMesProj ) + ( nMpy - ( nK2 * nMpx ) )
		
		dbSelectArea("SB3")
		If lQuery
			dbGoto((cAliasSB3)->RECNOSB3)
		EndIf
		RecLock("SB3",.F.)
		Replace B3_MEDIA WITH nYP,B3_TOTAL WITH B3_MEDIA*RetFldProd((cAliasSB1)->B1_COD,"B1_CUSTD",cAliasSB1)
		//-- Se o consumo medio for negativo zerar o consumo medio
		If mv_par05 == 1
			If B3_MEDIA < 0 
				Replace B3_MEDIA With 0
			EndIf
		EndIf
		Replace	B3_CTOTAL With StrZero(B3_TOTAL,nTamanho, nDecimais)
		Replace B3_MES    With dDatabase
		MsUnlock()
	EndIf
	dbSelectArea(cAliasSB3)
	dbSkip()
	If !lBat
		If oCenterPanel <> NIL
			oCenterPanel:IncRegua1(OemToAnsi(STR0037))
		Else
			IncProc()
		EndIf
	EndIf
EndDo       
If lQuery
	(cAliasSB3)->(dbCloseArea())
EndIf
Return Nil

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A290CalLot� Autor � Eveli Morasco         � Data � 12/02/92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Calcula o lote economico                                   ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � A290CalLot()                                               ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA290                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function A290CalLot(cCalPon,nPerA,nPerB,nPerC,nPorA,nPorB,nPorC,lCtrLote,oCenterPanel)
Local nTotCon:=0,nTotA:=0,nTotB:=0,nTotC:=0,nLote,cClasse,nPrazo
Local lMta290Abc:= Existblock("A290ABC")
Local lA290CALL := .F.                                         
Local lA290CAPP := .F.                                         
Local nA290CALL := 0
Local nA290CAPP := 0
Local nQE		:= 0
Local bWhileSB3 := {}
Local cAliasSB1	:= "SB1"
Local cAliasSB3	:= "SB3"
Local lQuery	:= .F.
Local cIndSB3	:= CriaTrab(NIL,.F.), nIndSB3
Local cCond		:= ""
Local lM290QSB1 := ExistBlock("M290QSB1")
Local cOpcoes	:= ""
Local cQuery	:= ""
Local cQueryUsr	:= ""

Default lCtrLote := .T.

dbSelectArea("SB3")

bWhileSB3 := { || (cAliasSB3)->( !Eof()) }
lQuery	  := .T.
cAliasSB3 := GetNextAlias()
cAliasSB1 := cAliasSB3
cQuery := "SELECT B3_FILIAL,B3_COD,B3_MEDIA,B3_TOTAL,SB3.R_E_C_N_O_ RECNOSB3,"
cQuery += "B1_FILIAL,B1_COD,B1_QE,B1_LE,SB1.R_E_C_N_O_ RECNOSB1  "
cQuery += "FROM " + RetSqlName("SB3") + " SB3 "
cQuery += "JOIN " + RetSqlName("SB1") + " SB1 "
cQuery += "ON  B1_FILIAL = '" + xFilial("SB1") + "' "
cQuery += "AND B1_COD = B3_COD "
cQuery += "AND B1_COD >= '" + mv_par03 + "' AND B1_COD <= '" + mv_par04 + "' "
cQuery += "AND SB1.D_E_L_E_T_ = ' ' "
cQuery += "WHERE SB3.B3_FILIAL='" + xFilial("SB3") + "' "
cQuery += "AND SB3.D_E_L_E_T_=' ' "
If aOpcoes[8][1] != "**" .And. !Empty(aOpcoes[8][1])
	cOpcoes := Trim(aOpcoes[8][1])
	cOpcoes := Substr(cOpcoes,1,Len(cOpcoes)-1)
	cQuery += "AND SB1.B1_TIPO IN ('"+StrTran(cOpcoes,"|","','")+"') "
EndIf
If aOpcoes[9][1] != "**" .And. !Empty(aOpcoes[9][1])
	cOpcoes := Trim(aOpcoes[9][1])
	cOpcoes := Substr(cOpcoes,1,Len(cOpcoes)-1)
	cQuery += "AND SB1.B1_GRUPO IN ('"+StrTran(cOpcoes,"|","','")+"') "
EndIf
//�����������������������������������������������������������������������������������Ŀ
//� M290QSB1 - Ponto de Entrada utilizado para adicionar filtro na query (ref. SB1)   |
//�������������������������������������������������������������������������������������
If lM290QSB1
	cQueryUsr := ExecBlock("M290QSB1",.F.,.F.)
	If ValType(cQueryUsr) == "C"
		cQuery += cQueryUsr
	EndIf
EndIf
cQuery += " ORDER BY B3_FILIAL,B3_CTOTAL DESC "
cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSB3,.T.,.T.)
dbGoTop()

TcSetField(cAliasSB3,"B1_LE"      ,"N", TamSx3("B1_LE")[1]    , TamSx3("B1_LE")[2] )
TcSetField(cAliasSB3,"B1_QE"      ,"N", TamSx3("B1_QE")[1]    , TamSx3("B1_QE")[2] )
TcSetField(cAliasSB3,"B3_MEDIA"   ,"N", TamSx3("B3_MEDIA")[1] , TamSx3("B3_MEDIA")[2] )
TcSetField(cAliasSB3,"B3_TOTAL"   ,"N", TamSx3("B3_TOTAL")[1] , TamSx3("B3_TOTAL")[2] )

//��������������������������������������������������������������Ŀ
//� Soma o valor total das medias de consumo                     �
//����������������������������������������������������������������
While Eval( bWhileSB3 )
	nTotCon += B3_TOTAL
	dbSkip()
EndDo
dbGoTop()

nTotA   :=  nPorA * nTotCon / 100
nTotB   := (nPorB * nTotCon / 100) + nTotA
nTotC   := (nPorC * nTotCon / 100) + nTotB
nTotCon := 0

While Eval( bWhileSB3 )
	If lQuery .Or. SB1->(dbSeek(xFilial("SB1")+(cAliasSB3)->B3_COD))
		If MA290Filtro(lQuery)
			Do Case
				Case nTotCon < nTotA
					nLote   := (cAliasSB3)->B3_MEDIA * nPerA
					cClasse := 'A'
				Case nTotCon < nTotB
					nLote   := (cAliasSB3)->B3_MEDIA * nPerB
					cClasse := 'B'
				OtherWise
					nLote   := (cAliasSB3)->B3_MEDIA * nPerC
					cClasse := 'C'
			EndCase
			nQE	  := RetFldProd((cAliasSB1)->B1_COD,"B1_QE",cAliasSB1)
			nLote := If(nLote < nQE,nQE,Round(nLote / If( nQE==0,1,nQE ), 0) * If( nQE==0,1,nQE ) )
			nPrazo := CalcPrazo((cAliasSB1)->B1_COD,RetFldProd((cAliasSB1)->B1_COD,"B1_LE",cAliasSB1))

			//���������������������������������������������������������������������������������������Ŀ
			//� A290CALL - Ponto de Entrada para manipulacao do Valor a ser gravado no Lote Economico |
			//�����������������������������������������������������������������������������������������
			nA290CALL := 0
			lA290CALL := .F.
			If lCtrLote .And. ExistBlock('A290CALL')
				nA290CALL := ExecBlock('A290CALL', .F., .F., {(cAliasSB1)->B1_COD, nLote})
				If Valtype(nA290CALL) == 'N'
					lA290CALL  := .T.
				EndIf
			EndIf

			If lQuery
				//������������������������������������������������������������Ŀ
				//� Posiciona SB3 devido funcao CalcEstSeg executar formula    |
				//��������������������������������������������������������������
				If cCalPon == "x" 
					dbSelectArea("SB3")
					dbGoto((cAliasSB3)->RECNOSB3)
				EndIf
			EndIf
			
			//�����������������������������������������������������������������������������������������Ŀ
			//� A290CAPP - Ponto de Entrada para manipulacao do Valor a ser gravado no Ponto de Pedido  |
			//�������������������������������������������������������������������������������������������
			nA290CAPP := 0
			lA290CAPP := .F.
			If cCalPon == "x" .And. ExistBlock('A290CAPP')
				If RetArqProd((cAliasSB1)->B1_COD)
					nA290CAPP := ((cAliasSB3)->B3_MEDIA * (nPrazo / 30 )) + CalcEstSeg( SB1->B1_ESTFOR )
				Else
					nA290CAPP := ((cAliasSB3)->B3_MEDIA * (nPrazo / 30 )) + CalcEstSeg( SBZ->BZ_ESTFOR )
				EndIf
				nA290CAPP := ExecBlock('A290CAPP', .F., .F., {(cAliasSB1)->B1_COD, nA290CAPP})
				If Valtype(nA290CAPP) == 'N'
					lA290CAPP  := .T.
				EndIf
			EndIf
			
			If RetArqProd((cAliasSB1)->B1_COD)
				If lQuery
					dbSelectArea("SB1")
					dbGoto((cAliasSB1)->RECNOSB1)
				EndIf
				RecLock("SB1",.F.)
				If lCtrLote
					Replace B1_LE With If(lA290CALL,nA290CALL,nLote)
				EndIf
				If cCalPon == "x"
					Replace B1_EMIN WITH If(lA290CAPP,nA290CAPP,((cAliasSB3)->B3_MEDIA * (nPrazo / 30 )) + CalcEstSeg( SB1->B1_ESTFOR ))
				EndIf
			Else
				RecLock("SBZ",.F.)
				If lCtrLote
					Replace BZ_LE With If(lA290CALL,nA290CALL,nLote)
				EndIf
				If cCalPon == "x"
					Replace BZ_EMIN WITH If(lA290CAPP,nA290CAPP,((cAliasSB3)->B3_MEDIA * (nPrazo / 30 )) + CalcEstSeg( SBZ->BZ_ESTFOR ))
				EndIf
			EndIf
			MsUnlock()
			If lGrvABC
				dbSelectArea("SB3")
				If lQuery .And. cCalPon <> "x" 
					dbGoto((cAliasSB3)->RECNOSB3)
				EndIf				
				RecLock("SB3",.F.)
				Replace B3_CLASSE With cClasse
				//�����������������������������������������������������������Ŀ
				//� A290ABC - Ponto de Entrada para manipulacao da Classe ABC |
				//�������������������������������������������������������������
				If lMta290Abc
					Execblock("A290ABC",.F.,.F.)
				EndIf
				MsUnlock()
			EndIf
			dbSelectArea(cAliasSB3)
			nTotCon := nTotCon + (cAliasSB3)->B3_TOTAL
		EndIf
	EndIf
	If !lQuery
		dbSkip(-1)
	Else 
		dbSkip()
	EndIf
	If !lBat
		If oCenterPanel <> NIL
			oCenterPanel:IncRegua1(OemToAnsi(STR0038))
		Else
			IncProc()
		EndIf
	EndIf
EndDo

If lQuery
	dbSelectArea(cAliasSB3)
	dbCloseArea()	
Else
	RetIndex("SB3")
	Ferase(cIndSB3+OrdBagExt())
	dbSetOrder(1)
EndIf
Return Nil

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A290AjuLot� Autor � Eveli Morasco         � Data � 13/02/92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ajusta o lote economico pelo valor disponivel para compras ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � A290AjuLot()                                               ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA290                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function A290AjuLot(nValDisp,oCenterPanel)
Local nQatu:=0,nPedido:=0,nTotVal:=0,nFalta:=0,nDif:=0
Local nA290AJUL := 0
Local lA290AJUL := .F.
Local lQuery    := .F.
Local cAliasSB1	:= "SB1"
Local cAliasSB3	:= "SB3"
Local lM290QSB1 := ExistBlock("M290QSB1")
Local cOpcoes	:= ""
Local cQuery	:= ""
Local cQueryUsr	:= ""

//��������������������������������������������������������������Ŀ
//� Seleciona ordem por produto para o SC1 e o SC7               �
//����������������������������������������������������������������
dbSelectArea("SC1")
dbSetOrder(2)

dbSelectArea("SC7")
dbSetOrder(4)

dbSelectArea("SB1")
dbSetOrder(1)

lQuery	  := .T.
cAliasSB1 := GetNextAlias()
cAliasSB3 := cAliasSB1
cQuery := "SELECT B1_FILIAL,B1_COD,B1_EMIN,B1_LE,B1_UPRC,B1_CUSTD,SB1.R_E_C_N_O_ RECNOSB1,B3_MEDIA "
cQuery += "FROM " + RetSqlName("SB1") + " SB1 "
cQuery += "LEFT JOIN " + RetSqlName("SB3") + " SB3 "
cQuery += "ON  B3_FILIAL = '" + xFilial("SB3") + "' "
cQuery += "AND B3_COD = B1_COD "
cQuery += "AND SB3.D_E_L_E_T_ = ' ' "
cQuery += "WHERE B1_FILIAL = '" + xFilial("SB1") + "' "
cQuery += "AND B1_COD >= '"+mv_par03+"' AND B1_COD <= '"+mv_par04+"' "
If aOpcoes[8][1] != "**" .And. !Empty(aOpcoes[8][1])
	cOpcoes := Trim(aOpcoes[8][1])
	cOpcoes := Substr(cOpcoes,1,Len(cOpcoes)-1)
	cQuery += "AND SB1.B1_TIPO IN ('"+StrTran(cOpcoes,"|","','")+"') "
EndIf
If aOpcoes[9][1] != "**" .And. !Empty(aOpcoes[9][1])
	cOpcoes := Trim(aOpcoes[9][1])
	cOpcoes := Substr(cOpcoes,1,Len(cOpcoes)-1)
	cQuery += "AND SB1.B1_GRUPO IN ('"+StrTran(cOpcoes,"|","','")+"') "
EndIf
cQuery += "AND SB1.D_E_L_E_T_ = ' ' "
//�����������������������������������������������������������������������������������Ŀ
//� M290QSB1 - Ponto de Entrada utilizado para adicionar filtro na query (ref. SB1)   |
//�������������������������������������������������������������������������������������
If lM290QSB1
	cQueryUsr := ExecBlock("M290QSB1",.F.,.F.)
	If ValType(cQueryUsr) == "C"
		cQuery += cQueryUsr
	EndIf
EndIf
cQuery += " ORDER BY "+SqlOrder(SB1->(IndexKey()))
cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSB1,.T.,.T.)
dbGoTop()

TcSetField(cAliasSB1,"B1_EMIN"  ,"N", TamSx3("B1_EMIN")[1],  TamSx3("B1_EMIN")[2] )
TcSetField(cAliasSB1,"B1_LE" 	,"N", TamSx3("B1_LE")[1],	 TamSx3("B1_LE")[2] )
TcSetField(cAliasSB1,"B1_UPRC"  ,"N", TamSx3("B1_UPRC")[1],  TamSx3("B1_UPRC")[2] )
TcSetField(cAliasSB1,"B1_CUSTD" ,"N", TamSx3("B1_CUSTD")[1], TamSx3("B1_CUSTD")[2] )
TcSetField(cAliasSB1,"B3_MEDIA" ,"N", TamSx3("B3_MEDIA")[1], TamSx3("B3_MEDIA")[2] )

//��������������������������������������������������������������Ŀ
//� Soma o valor total das compras do mes                        �
//����������������������������������������������������������������
While !EOF() .And. IIf(lQuery,.T.,(cAliasSB1)->B1_FILIAL+(cAliasSB1)->B1_COD <= xFilial("SB1")+mv_par04)
	If MA290Filtro(lQuery)
		If lQuery
			nQatu	:= A290SB2Aju((cAliasSB1)->B1_COD)
			nPedido := A290SC1Aju((cAliasSB1)->B1_COD)
			nPedido += A290SC7Aju((cAliasSB1)->B1_COD)
		Else
			nQatu   := 0
			nPedido := 0
			dbSelectArea("SB2")
			dbSeek(xFilial("SB2")+SB1->B1_COD)
			While !EOF() .And. B2_FILIAL+B2_COD == xFilial("SB2")+SB1->B1_COD
				If B2_LOCAL >= mv_par01 .And. B2_LOCAL <= mv_par02
					nQatu := nQatu + B2_QATU
				EndIf
				dbSkip()
			EndDo
			dbSelectArea("SC1")
			dbSeek(xFilial("SC1")+SB1->B1_COD)
			While !EOF() .And. C1_FILIAL+C1_PRODUTO == xFilial("SC1")+SB1->B1_COD
				If C1_QUANT > C1_QUJE .And. Month(C1_DATPRF) == Month(dDataBase);
				   .And. Year(C1_DATPRF) == Year(dDataBase);
				   .And. C1_LOCAL >= mv_par01 .And. C1_LOCAL <= mv_par02
					nPedido := nPedido + (C1_QUANT - C1_QUJE)
				EndIf
				dbSkip()
			EndDo
			dbSelectArea("SC7")
			dbSeek(xFilial("SC7")+SB1->B1_COD)
			While !EOF() .And. C7_FILIAL+C7_PRODUTO == xFilial("SC7")+SB1->B1_COD
				If C7_QUANT > C7_QUJE .And. Month(C7_DATPRF) == Month(dDataBase) .And. Empty(C7_RESIDUO);
				   .And. Year(C7_DATPRF) == Year(dDataBase);
				   .And. C7_LOCAL >= mv_par01 .And. C7_LOCAL <= mv_par02
					nPedido := nPedido + (C7_QUANT-C7_QUJE)
				EndIf
				dbSkip()
			EndDo
			dbSelectArea("SB3")
			dbSeek(xFilial("SB3")+SB1->B1_COD)
			dbSelectArea("SB1")
		EndIf

		nFalta := (RetFldProd((cAliasSB1)->B1_COD,"B1_EMIN",cAliasSB1)+(cAliasSB3)->B3_MEDIA) - (nQatu+nPedido)

		If nFalta > 0
			If nFalta < RetFldProd((cAliasSB1)->B1_COD,"B1_LE",cAliasSB1)
				nFalta := RetFldProd((cAliasSB1)->B1_COD,"B1_LE",cAliasSB1)
			EndIf
			nTotVal := nTotVal + (nFalta * IIF(RetFldProd((cAliasSB1)->B1_COD,"B1_UPRC",cAliasSB1) > 0,RetFldProd((cAliasSB1)->B1_COD,"B1_UPRC",cAliasSB1),RetFldProd((cAliasSB1)->B1_COD,"B1_CUSTD",cAliasSB1)))
		EndIf
		
	EndIf
	dbSkip()
	If !lBat
		If oCenterPanel <> NIL
			oCenterPanel:IncRegua1(OemToAnsi(STR0039))
		Else
			IncProc()
		EndIf
	EndIf
EndDo
If nTotVal <= 0
	nTotVal := 1
EndIf
nDif := (nValDisp/nTotVal)
If lQuery
	dbSelectArea(cAliasSB1)
	dbCloseArea()
EndIf
//��������������������������������������������������������������Ŀ
//� Somente ajusta se o valor informado nao conseguir comprar    �
//� pelo menos 85% da necessidade calculada.                     �
//����������������������������������������������������������������
If nDif < 0.85
	dbSelectArea("SB1")
	cAliasSB1 := GetNextAlias()
	cQuery := "SELECT B1_FILIAL,B1_COD,B1_LE,SB1.R_E_C_N_O_ RECNOSB1 "
	cQuery += "FROM "+RetSqlName("SB1")+" SB1 "
	cQuery += "WHERE B1_FILIAL = '" + xFilial("SB1") + "' "
	cQuery += "AND B1_COD >= '"+mv_par03+"' AND B1_COD <= '"+mv_par04+"' "
	cQuery += "AND SB1.D_E_L_E_T_ = ' ' "
	If aOpcoes[8][1] != "**" .And. !Empty(aOpcoes[8][1])
		cOpcoes := Trim(aOpcoes[8][1])
		cOpcoes := Substr(cOpcoes,1,Len(cOpcoes)-1)
		cQuery += "AND SB1.B1_TIPO IN ('"+StrTran(cOpcoes,"|","','")+"') "
	EndIf
	If aOpcoes[9][1] != "**" .And. !Empty(aOpcoes[9][1])
		cOpcoes := Trim(aOpcoes[9][1])
		cOpcoes := Substr(cOpcoes,1,Len(cOpcoes)-1)
		cQuery += "AND SB1.B1_GRUPO IN ('"+StrTran(cOpcoes,"|","','")+"') "
	EndIf
	//�����������������������������������������������������������������������������������Ŀ
	//� M290QSB1 - Ponto de Entrada utilizado para adicionar filtro na query (ref. SB1)   |
	//�������������������������������������������������������������������������������������
	If lM290QSB1
		cQueryUsr := ExecBlock("M290QSB1",.F.,.F.)
		If ValType(cQueryUsr) == "C"
			cQuery += cQueryUsr
		EndIf
	EndIf

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSB1,.T.,.T.)
	dbGoTop()

	TcSetField(cAliasSB1,"B1_LE" 	,"N", TamSx3("B1_LE")[1],	 TamSx3("B1_LE")[2] )
			
	While !EOF() .And. IIf(lQuery,.T.,(cAliasSB1)->B1_FILIAL+(cAliasSB1)->B1_COD <= xFilial("SB1")+mv_par04)
		If MA290Filtro(lQuery)
			//���������������������������������������������������������������������������������������Ŀ
			//� A290AJUL - Ponto de Entrada para manipulacao do Valor a ser gravado no Lote Economico |
			//�����������������������������������������������������������������������������������������
			nA290AJUL := 0
			lA290AJUL := .F.
			If ExistBlock('A290AJUL')
				nA290AJUL := ExecBlock('A290AJUL', .F., .F., {(cAliasSB1)->B1_COD, (RetFldProd((cAliasSB1)->B1_COD,"B1_LE",cAliasSB1) * nDif)})
				If Valtype(nA290AJUL) == 'N'
					lA290AJUL := .T.
				EndIf
			EndIf
			If RetArqProd((cAliasSB1)->B1_COD)
				If lQuery
					dbSelectArea("SB1") // posiciona SB1 somente qdo necessario
					dbGoto((cAliasSB1)->RECNOSB1)
				EndIf
				RecLock("SB1",.F.)
				Replace B1_LE With If(lA290AJUL,nA290AJUL,B1_LE * nDif)
				MsUnlock()
			Else
				RecLock("SBZ",.F.)
				Replace BZ_LE With If(lA290AJUL,nA290AJUL,BZ_LE * nDif)
				MsUnlock()
			EndIf
			dbSelectArea(cAliasSB1)
		EndIf
		dbSkip()
		If !lBat
			If oCenterPanel <> NIL
				oCenterPanel:IncRegua1(OemToAnsi(STR0039))
			Else
				IncProc()
			EndIf
		EndIf
	EndDo
EndIf
//��������������������������������������������������������������Ŀ
//� Devolve a ordem principal dos arquivos                       �
//����������������������������������������������������������������
If lQuery .And. Select(cAliasSB1) > 0
	dbSelectArea(cAliasSB1)
	dbCloseArea()
EndIf
dbSelectArea("SC1")
dbSetOrder(1)

dbSelectArea("SC7")
dbSetOrder(1)
Return Nil

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � A290Menu � Autor � Jorge Queiroz         � Data � 06/01/92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Processa a string das opcoes de processamento              ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � ExpA1 := A290Menu()                                        ���
�������������������������������������������������������������������������Ĵ��
���Altera��o �Guilherme Santos - 20/07/06                                 ���
���          �Incluido tratamento para selecao de Filiais que deverao ser ���
���          �processadas.                                                ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpA1 := Array devolvido pela escolha                      ���
���          � [1][1]-> Atualiza Consumo do Mes (x ou Branco)             ���
���          � [2][1]-> Calcula por Peso        (x ou Branco)             ���
���          �    [2]-> Incremento Percentual   (Percentual N 3)          ���
���          � [3][1]-> Calculo pela Tendencia  (x ou Branco)             ���
���          �    [2]-> Numero de Meses         (Meses N 2)               ���
���          � [4][1]-> Calculo Lote Economico  (x ou Branco)             ���
���          �    [2]-> Calculo Ponto Pedido    (x ou Branco)             ���
���          � [5][1]-> Ajusta Lote Economico   (x ou Branco)             ���
���          �    [2]-> Disponibilidade         (Valor N 11)              ���
���          � [6][1]-> Periodo Aquisicao A     (Valor N  4,1)            ���
���          � [6][2]-> Periodo Aquisicao B     (Valor N  4,1)            ���
���          � [6][3]-> Periodo Aquisicao C     (Valor N  4,1)            ���
���          � [7][1]-> %Distribuicao     A     (Percentual N 5,2)        ���
���          � [7][2]-> %Distribuicao     B     (Percentual N 5,2)        ���
���          � [7][3]-> %Distribuicao     C     (Percentual N 5,2)        ���
���          � [8][1]-> Tipo de Material  (** Todos)                      ���
���          � [9][1]-> Grupos de Material  (** Todos)                    ���
���          �[10][1]-> Selecao de Filiais (.T. ou .F.)                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA290                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function A290MENU(lBat)
Local oDlg,oQual,oQual2,oUsado,oConsumo,nCalculo:=1,oChk1,oChk2,oChk3,oChk4,oChk7,oChk8,lCalc,lLote,lEstSeg:=.F.,;
lPedido,lDispoF,nIncre:=nMeses:=nDispoF:=0,;
nA1:=nB1:=nC1:=1,nA2:=nB2:=30,nC2:=40,oGet1,oGet2,oGet3,nOpca:=2,aOpt[10][3],;
oChkQual,oChkQual2,lQual:=.T.,lQual2:=.T.,oChk5,oChk6,lFilial,oChkGrpVz,lGrpVazio:=.T.
Local cVarQ := cVarQ2 := "  "
Local cCapital
Local i := 0
Local bBlNewProcess := {|oCenterPanel|aOpcoes:=a290PrepPrc(nIncre,nMeses,lPedido,lDispoF,nDispoF,nA1,nA2,nB1,nB2,nC1,nC2,lFilial,lCalc,nCalculo,lLote,lGrpVazio),;
						MA290Process(aOpcoes,@lEnd,lBat,oCenterPanel)}
Local aTreeProc 	:= {}
Local lUsaNewPrc	:= UsaNewPrc()
Local nMesesES	:= 0
Local nConsumo	:= 1
Local lConsumo	:= .F.

SetKey( VK_F12 ,{|| Pergunte("MTA290",.T.)})

Private cCadastro := OemToAnsi(STR0004)   //"Lote Econ�mico"
Private aTipo := {}
Private aGrupo := {}

Private oOk   := LoadBitmap( GetResources(), "LBOK")
Private oNo   := LoadBitmap( GetResources(), "LBNO")

//�������������������������������������������������������������Ŀ
//�Monta a Tabela de Tipos                                      �
//���������������������������������������������������������������
dbSelectArea("SX5")
dbSeek(xFilial("SX5")+"02")
While (X5_FILIAL == xFilial("SX5")) .And. (X5_TABELA == "02")
	cCapital := OemToAnsi(Capital(X5Descri()))
	AADD(aTipo,{.T.,SubStr(X5_chave,1,3)+" - "+cCapital})
	dbSkip()
EndDo

//��������������������������������������������������������������Ŀ
//�Monta a Tabela de Grupos                                      �
//����������������������������������������������������������������
dbSelectArea("SBM")
dbSeek(xFilial("SBM"))
While !EOF() .And. BM_FILIAL == xFilial("SBM")
	cCapital := OemToAnsi(Capital(BM_DESC))
	AADD(aGrupo,{.T.,SubStr(BM_GRUPO,1,5)+" - "+cCapital})
	dbSkip()
EndDo

If !lUsaNewPrc
	DEFINE MSDIALOG oDlg TITLE cCadastro From 145,0 To 625,628 OF oMainWnd PIXEL
	@ 95,15 TO 230,120 LABEL "" OF oDlg  PIXEL
	@ 140,20 MSGET oGet3 VAR nMesesES Picture "999" SIZE 15,10 VALID (nMesesES < 13 .And. nMesesES > 0) OF oDlg PIXEL ;oGet3:Disable()
	@ 155,20 RADIO oConsumo VAR nConsumo 3D SIZE 70,10 PROMPT OemToAnsi(STR0049),OemToAnsi(STR0050) OF oDlg PIXEL  ON CLICK If(lEstSeg .And. nConsumo==1,lConsumo:=.T.,lConsumo:=.F.) ;oConsumo:Disable()      //Por Consumo Medio ou Por Previsao de Venda
	@ 123,20 CHECKBOX oChk8 VAR lEstSeg PROMPT OemToAnsi(STR0043) SIZE 100, 10 OF oDlg PIXEL ON CLICK If(lEstSeg,(oGet3:Enable(),oConsumo:Enable()),(oGet3:Disable(),oConsumo:Disable())) ;oChk8:oFont := oDlg:oFont //"Estoque de Seguranca" 
	@ 133,20 Say OemToAnsi(STR0044) SIZE 100,10 OF oDlg PIXEL //considerando consumo dos ultimos.
    @ 138,40 Say OemToAnsi(STR0045) SIZE 20,10 OF oDlg PIXEL //meses.	                   
	@ 185,20 CHECKBOX oChk4 VAR lDispoF PROMPT OemToAnsi(STR0013) SIZE 90, 10 OF oDlg PIXEL ON CLICK If(lDispoF,oGet4:Enable(),oGet4:Disable()) ;oChk4:oFont := oDlg:oFont  //"Ajusta Lote Econ�mico pela dispo-"
	@ 195,20 Say OemToAnsi(STR0014) SIZE 80,10 OF oDlg PIXEL    																		//"nibilidade financeira"
	@ 202,70 MSGET oGet4 VAR nDispoF Picture "@E 99,999,999,999" VALID nDispoF > 0 SIZE 45,10 OF oDlg PIXEL ;oGet4:Disable() 
	DEFINE SBUTTON FROM 220,240 TYPE 1 ACTION IIF(A290VldPer(nA2,nB2,nC2,oChk8,oGet3,lEstSeg,nMesesES),(nOpca:=1,oDlg:End()),"") ENABLE OF oDlg
	DEFINE SBUTTON FROM 220,270 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
	@ 02,15 TO 30,120 LABEL "" OF oDlg  PIXEL
	@ 08,20 CHECKBOX oChk1 VAR lCalc PROMPT OemToAnsi(STR0005) SIZE 100, 10 OF oDlg PIXEL ;oChk1:oFont := oDlg:oFont   			  //"Atualiza��o do Consumo do M�s"		
	@ 18,20 CHECKBOX oChk6 VAR lFilial PROMPT OemToAnsi(STR0027) SIZE 90, 10 OF oDlg PIXEL ;oChk6:oFont := oDlg:oFont             //"Seleciona Filial"
	@ 32,15 TO 92,120 LABEL OemToAnsi(STR0006) OF oDlg  PIXEL   															      //"C�lculos"
	@ 38,20 RADIO oUsado VAR nCalculo 3D SIZE 70,10 PROMPT OemToAnsi(STR0007),OemToAnsi(STR0008) OF oDlg PIXEL      			 //"Por Peso"###"Pela Tend�ncia"
	oUsado:bChange := { || IIF(nCalculo=1,(oGet1:Enable(),oGet2:Disable()),(oGet1:Disable(),oGet2:Enable())) }
	@ 62,20 Say OemToAnsi(STR0009) SIZE 40,10 OF oDlg PIXEL    																		 //"Incremento:"
	@ 62,67 MSGET oGet1 VAR nIncre When IIF(nCalculo=1,.T.,.F.) Picture "999" SIZE 15,10 OF oDlg PIXEL
	@ 78,20 Say OemToAnsi(STR0010) SIZE 60,10 OF oDlg PIXEL     																	 //"N�mero de Meses:"
	@ 78,67 MSGET oGet2 VAR nMeses When IIF(nCalculo=2,.T.,.F.) Picture "999" SIZE 15,10 VALID (nMeses < 13 .And. nMeses > 0) OF oDlg PIXEL
	@ 103,20 CHECKBOX oChk2 VAR lLote PROMPT OemToAnsi(STR0011) SIZE 80, 10 OF oDlg PIXEL ;oChk2:oFont := oDlg:oFont    			//"C�lculo do Lote Econ�mico"
	@ 113,20 CHECKBOX oChk3 VAR lPedido PROMPT OemToAnsi(STR0012) SIZE 80, 10 OF oDlg PIXEL ;oChk3:oFont := oDlg:oFont       	//"C�lculo do Ponto de Pedido"
	@ 02,130 TO 73,300 LABEL OemToAnsi(STR0015) OF oDlg PIXEL    																	//"Classifica��o ABC"
	@ 12,182 TO 58,219 LABEL "A" OF oDlg  PIXEL
	@ 12,220 TO 58,257 LABEL "B" OF oDlg  PIXEL
	@ 12,258 TO 58,295 LABEL "C" OF oDlg  PIXEL
	@ 18,135 Say OemToAnsi(STR0016) SIZE 50,10 OF oDlg PIXEL   //"Per�odo de"
	@ 25,135 Say OemToAnsi(STR0017) SIZE 50,10 OF oDlg PIXEL   //"Aquisi��o(meses)"
	@ 38,135 Say OemToAnsi(STR0018) SIZE 45,10 OF oDlg PIXEL   //"Distribui��o"
	@ 45,135 Say OemToAnsi(STR0019) SIZE 45,10 OF oDlg PIXEL   //"Percentual (%)"
	@ 20,185 MSGET nA1 Picture "99.9" VALID nA1 >0 SIZE 17,10 OF oDlg PIXEL
	@ 20,223 MSGET nB1 Picture "99.9" VALID nB1 >0 SIZE 17,10 OF oDlg PIXEL
	@ 20,261 MSGET nC1 Picture "99.9" VALID nC1 >0 SIZE 17,10 OF oDlg PIXEL
	@ 40,185 MSGET nA2 Picture "99.9" VALID nA2 >0 SIZE 17,10 OF oDlg PIXEL
	@ 40,223 MSGET nB2 Picture "99.9" VALID nB2 >0 SIZE 17,10 OF oDlg PIXEL
	@ 40,261 MSGET nC2 Picture "99.9" VALID nC2 >0 SIZE 17,10 OF oDlg PIXEL
	@ 60,135 CHECKBOX oChk5 VAR lGrvABC PROMPT OemToAnsi(STR0025) SIZE 95,10 OF oDlg PIXEL ;oChk5:oFont := oDlg:oFont   										//"Grava Classificacao ABC"
	If Len(aTipo) > 0
		@ 76,130 LISTBOX oQual VAR cVarQ Fields HEADER "",OemToAnsi(STR0020) SIZE 75,100 ON DBLCLICK (aTipo:=ca290troca(oQual:nAt,aTipo),oQual:Refresh()) ON RIGHT CLICK ListBoxAll(nRow,nCol,@oQual,oOk,oNo,@aTipo) NOSCROLL OF oDlg PIXEL  //"Tipos de Material"
		oQual:SetArray(aTipo)
		oQual:bLine := { || {if(aTipo[oQual:nAt,1],oOk,oNo),aTipo[oQual:nAt,2]}}
		@ 185,130 CHECKBOX oChkQual  VAR lQual  PROMPT OemToAnsi(STR0024) SIZE 90, 10 OF oDlg PIXEL ON CLICK (AEval(aTipo , {|z| z[1] := If(z[1]==.T.,.F.,.T.)}), oQual:Refresh(.F.)) //"Inverter Selecao"
	EndIf
	If Len(aGrupo) > 0
		@ 76,225 LISTBOX oQual2 VAR cVarQ2 Fields HEADER "",OemToAnsi(STR0021) SIZE 75, 100 ON DBLCLICK (aGrupo:=ca290troca(oQual2:nAt,aGrupo),oQual2:Refresh()) ON RIGHT CLICK ListBoxAll(nRow,nCol,@oQual2,oOk,oNo,@aGrupo) NOSCROLL OF oDlg  PIXEL   //"Grupos de Material"
		oQual2:SetArray(aGrupo)
		oQual2:bLine := { || {if(aGrupo[oQual2:nAt,1],oOk,oNo),aGrupo[oQual2:nAt,2]}}
		@ 185,225 CHECKBOX oChkQual2 VAR lQual2 PROMPT OemToAnsi(STR0024) SIZE 90, 10 OF oDlg PIXEL ON CLICK (AEval(aGrupo, {|z| z[1] := If(z[1]==.T.,.F.,.T.)}),oQual2:Refresh(.F.)) //"Inverter Selecao"
		@ 193,225 CHECKBOX oChkGrpVz VAR lGrpVazio PROMPT STR0042 SIZE 90, 10 OF oDlg PIXEL
	EndIf

	//����������������������������������������������������������Ŀ
	//� Ponto de Entrada MTA290FIL - p/ adicionar filtro no SB1  |
	//� (permite a criacao de um botao para customizacao)		 �
	//������������������������������������������������������������
	If ( lMta290Fil )
		DEFINE SBUTTON FROM 220,210 TYPE 5 ACTION ( cMTA290Fil:=ExecBlock("MTA290FIL",.F.,.F.) ) ENABLE OF oDlg
	EndIf

	oChk2:BlClicked :=	{|| oChk2:Refresh()}
	ACTIVATE MSDIALOG oDlg CENTERED
Else
	aAdd(aTreeProc,{OemToAnsi(STR0029),{|oCenterPanel|a290MontCfg(oCenterPanel,@lCalc,@lFilial,@nCalculo,@nIncre,@nMeses,@lLote,@lPedido,@lDispoF,@nDispof)},"ENGRENAGEM"})
	aAdd(aTreeProc,{OemToAnsi(STR0015),{|oCenterPanel|a290MontABC(oCenterPanel,@nA1,@nB1,@nC1,@nA2,@nB2,@nC2,@lGrvABC)},"PMSRRFSH"})
	aAdd(aTreeProc,{OemToAnsi(STR0031),{|oCenterPanel|a290MontFil(oCenterPanel,@lGrpVazio)},"filtro1"})	
	tNewProcess():New("MATA290",cCadastro,bBlNewProc,OemToAnsi(STR0028),"",aTreeProc,,,,,.T.)
EndIf

If nOpca == 1
	aOpt := a290PrepPrc(nIncre,nMeses,lPedido,lDispoF,nDispoF,nA1,nA2,nB1,nB2,nC1,nC2,lFilial,lCalc,nCalculo,lLote,lGrpVazio,lEstSeg,nMesesES,lConsumo)
Else
	aOpt:=NIL
EndIf

DeleteObject(oOk)
DeleteObject(oNo)

//��������������������������������������������������������������Ŀ
//� Desativa a tecla F12							             �
//����������������������������������������������������������������
SetKey( VK_F12, Nil )

Return aOpt

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � CalcMeses� Autor � Wilson Junior         � Data � 28/03/95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna o Numero de Meses para calculo                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA290                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CalcMeses(dInicio,nMaximo)
Local nAnoIni := Year(dInicio),nMesIni:=Month(dInicio)
Local nAnoFim := Year(dDataBase),nMesFim:=Month(dDataBase)
Local nMeses
nMaximo := IIF(nMaximo == Nil,12,nMaximo)
nMeses := ((nAnoFim-nAnoIni)*12) + (nMesFim-nMesIni) + 1
nMeses := IIF(nMeses>nMaximo,nMaximo,nMeses)
nMeses := IIF(nMeses<0,0,nMeses)
Return(nMeses)

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MA290Filt� Autor � Marcos Bregantim      � Data � 04/07/95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna .t. ou .f. para validacao do filtro                ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpL1 = indica se esta' utilizando query ou nao            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA290                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MA290Filtro(lQuery)
Local lRet := .T.

DEFAULT lQuery	  := .F.

If !lQuery
	If aOpcoes[8][1] != "**" .And. !Empty(aOpcoes[8][1]) .And. !(SB1->B1_TIPO$Trim(aOpcoes[8][1]))
		lRet := .F.
	EndIf
	If lRet .And. aOpcoes[9][1] != "**" .And. !Empty(aOpcoes[9][1]) .And. !(SB1->B1_GRUPO$Trim(aOpcoes[9][1]))
		lRet := .F.
	EndIf
	If lRet .And. (SB1->B1_COD < mv_par03 .Or. SB1->B1_COD > mv_par04)
		lRet := .F.
	EndIf			
EndIf

//������������������������������������������������������������������������������������������Ŀ
//� cMTA290Fil = Retorno do Ponto de Entrada MTA290FIL - filtro para customizacao		     |
//��������������������������������������������������������������������������������������������
If lRet .And. lMTA290Fil .And. Valtype(cMTA290Fil) == "C"
	If !(&(cMTA290Fil))
		lRet := .F.
	EndIf
EndIf

Return (lRet)

/*
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    �MA290Process  � Autor �Rodrigo de A Sartorio� Data � 08/02/96 ���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Funcao que chama a regua e executa as funcoes de processamento���
���������������������������������������������������������������������������Ĵ��
���Altera��o �Guilherme Santos - 20/07/06                                   ���
���          �Incluido tratamento para selecao de Filiais que deverao ser   ���
���          �processadas.                                                  ���
���������������������������������������������������������������������������Ĵ��
��� Uso      �MATA290                                                       ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
Static Function MA290Process(aOpcoes,lEnd,lBatch,oCenterPanel)
// Variaveis utilizadas para processamento de calculo por empresa
Local aFilsCalc :={}
Local nForFilial:=0
Local cFilBack  :=cFilAnt 	//Guarda Filial Atual

Private lBat := lBatch

//�������������������������������������Ŀ	
//� Inicializa o log de processamento   �
//���������������������������������������
ProcLogIni( {},"MATA290" )

//�����������������������������������Ŀ
//� Atualiza o log de processamento   �
//�������������������������������������
ProcLogAtu("INICIO")

//Tratamento para selecao de Filiais para Processamento
If !lBat
	If !(oCenterPanel <> NIL)
		ProcRegua(nTotRegs)
	Else
		oCenterPanel:SetRegua1(nTotRegs)
	EndIf
	aFilsCalc := MatFilCalc(aOpcoes[10][1])
Else
	aFilsCalc := MatFilCalc(.F.,,.F.)
EndIf

For nForFilial := 1 to Len(aFilsCalc)
	If aFilsCalc[nForFilial,1]

		cFilAnt := aFilsCalc[nForFilial,2]	//Altera Filial Corrente
		
		//���������������������������������������������Ŀ
		//� Atualiza o log de processamento             �
		//�����������������������������������������������
		ProcLogAtu("MENSAGEM",STR0051+cFilAnt,STR0051+cFilAnt) // "Inicio Filial: "
		
		If (oCenterPanel <> NIL)
			oCenterPanel:SaveLog(OemToAnsi(STR0040))
		EndIf
		
		If aOpcoes[1][1] == "x"         // Atualiza Consumo do Mes
			A290CalCon(oCenterPanel)
		EndIf
		
		If aOpcoes[2][1] == "x"         // Calcula por Peso
			A290CalNor(aOpcoes[2][2],oCenterPanel)
		Else
			A290CalMin(aOpcoes[3][2],oCenterPanel)    // Calculo pela Tendencia
		EndIf
		
		If aOpcoes[4][1] == "x"         // Calculo Lote Economico
			//��������������������������������������������������������������Ŀ
			//� Os parametros passados na funcao A290CalLot sao :            �
			//�                                                              �
			//� aOpcoes[4][2] = Se deve calcular o ponto de pedido           �
			//� aOpcoes[6][1]-> Periodo Aquisicao A                          �
			//� aOpcoes[6][2]-> Periodo Aquisicao B                          �
			//� aOpcoes[6][3]-> Periodo Aquisicao C                          �
			//� aOpcoes[7][1]-> %Distribuicao     A                          �
			//� aOpcoes[7][2]-> %Distribuicao     B                          �
			//� aOpcoes[7][3]-> %Distribuicao     C                          �
			//����������������������������������������������������������������
			A290CalLot(aOpcoes[4][2],aOpcoes[6][1],aOpcoes[6][2],aOpcoes[6][3],;
			aOpcoes[7][1],aOpcoes[7][2],aOpcoes[7][3],.T.,oCenterPanel)
		Else  
			A290CalLot(aOpcoes[4][2],aOpcoes[6][1],aOpcoes[6][2],aOpcoes[6][3],;
			aOpcoes[7][1],aOpcoes[7][2],aOpcoes[7][3],.F.,oCenterPanel)
		EndIf
		If aOpcoes[5][1] == "x"          // Ajusta Lote Economico
			A290AjuLot(aOpcoes[5][2],oCenterPanel)    // Disponibilidade
		EndIf
		If aOpcoes[11][1] == "x"         // Processa o calculo do estoque de seguranca
			A290CalcES(aOpcoes[11][2],oCenterPanel,!aOpcoes[11,3]) //
		EndIf		
		If (oCenterPanel <> NIL)
			oCenterPanel:SaveLog(OemToAnsi(STR0041))
		EndIf
		
		//���������������������������������������������Ŀ
		//� Atualiza o log de processamento             �
		//�����������������������������������������������
		ProcLogAtu("MENSAGEM",STR0052+cFilAnt,STR0052+cFilAnt) //"Final Filial: "
		
	EndIf
Next nForFilial

//�����������������������������������Ŀ
//� Atualiza o log de processamento   �
//�������������������������������������
ProcLogAtu("FIM")

cFilAnt := cFilBack	 //Retorna Filial Inicial

Return

/*
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �MA290VldPer  � Autor �Rodrigo de A Sartorio� Data � 08/02/96 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Funcao que valida os percentuais do Calculo ABC              ���
��������������������������������������������������������������������������Ĵ��
��� Uso      �MATA290                                                      ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
Static Function A290VldPer(nA2,nB2,nC2,oChk8,oGet3,lEstSeg,nMesesES)
lRet:=.T.
If nA2+nB2+nC2 != 100
	Help(" ",1,"A290PERC")
	lRet:=.F.
EndIf

If lRet .And. (lEstSeg .And. nMesesES == 0)
	Aviso(STR0046,STR0047,{STR0048}) //"Aten��o"#"Preencha a quantidade de meses para o c�lculo do estoque de seguran�a."#"OK"
	lRet := .F.
EndIf
Return lRet

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
��� Fun��o    � CA290TROCA                                                 ���
��������������������������������������������������������������������������Ĵ��
��� Autor     � Rodrigo de Almeida Sartorio              � Data � 09.01.96 ���
��������������������������������������������������������������������������Ĵ��
��� Descri��o � Troca marcador entre x e branco                            ���
��������������������������������������������������������������������������Ĵ��
���  Uso      � SigaEST - Advanced                                         ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
Static Function CA290TROCA(nIt,aArray)
aArray[nIt,1] := !aArray[nIt,1]
Return aArray


/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A290SB2Aju� Autor � Ricardo Berti         � Data � 31/08/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Processa query p/ arq.Saldos (SB2) para um produto         ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ExN1 := A290SB2Aju(ExpC1)                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExC1 = Codigo do produto                                   ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � ExN1 = Saldo Total do produto 			                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA290                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function A290SB2AJU(cProd)

Local cQuery
Local cAliasQry := GetNextAlias()
Local cArea		:= Alias()
Local nQtde		:= 0

cQuery := "SELECT SUM(B2_QATU) B2TOTAL "
cQuery += "FROM "+RetSqlName("SB2")+" SB2 "
cQuery += "WHERE B2_FILIAL = '" + xFilial("SB2") + "' "
cQuery += "AND B2_COD  = '"+cProd+"' "
If !Empty(mv_par01) .Or. mv_par02 <> "ZZ"
	cQuery += "AND B2_LOCAL >= '"+mv_par01+"' AND B2_LOCAL <= '"+mv_par02+"' "
EndIf			
cQuery += "AND SB2.D_E_L_E_T_ = ' ' "
cQuery := ChangeQuery(cQuery)
	
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)
dbGoTop()

TcSetField(cAliasQry,"B2TOTAL",  "N", TamSx3("B2_QATU")[1],  TamSx3("B2_QATU")[2] )

nQtde := B2TOTAL
dbCloseArea()

dbSelectArea(cArea)
Return (nQtde)


/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A290SC1Aju� Autor � Ricardo Berti         � Data � 31/08/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Processa query p/ solic.de compras(SC1) para um produto    ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ExN1 := A290SC1Aju(ExpC1)                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExC1 = Codigo do produto                                   ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � ExN1 = Total da Qtde. - Qtde.ja'entregue                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA290                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function A290SC1AJU(cProd)

Local cQuery
Local cAliasQry := GetNextAlias()
Local dDataIni  := Ctod("01/"+StrZero(Month(dDataBase),2,0)+"/"+StrZero(Year(dDataBase),4,0))
Local dDataFim  := LastDay(dDataBase)
Local cArea		:= Alias()
Local nQtde		:= 0

cQuery := "SELECT SUM(C1_QUANT - C1_QUJE) C1TOTAL "
cQuery += "FROM "+RetSqlName("SC1")+" SC1 "
cQuery += "WHERE C1_FILIAL = '" + xFilial("SC1") + "' "
cQuery += "AND C1_PRODUTO   = '"+cProd+"' "
If !Empty(mv_par01) .Or. mv_par02 <> "ZZ"
	cQuery += "AND C1_LOCAL >= '"+mv_par01+"' AND C1_LOCAL <= '"+mv_par02+"' "
EndIf			
cQuery += "AND C1_QUANT     > C1_QUJE "
cQuery += "AND C1_DATPRF   >= '" + DTOS(dDataIni)	+ "' "
cQuery += "AND C1_DATPRF   <= '" + DTOS(dDataFim)	+ "' "
cQuery += "AND SC1.D_E_L_E_T_ = ' ' "
cQuery := ChangeQuery(cQuery)
	
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)
dbGoTop()

TcSetField(cAliasQry,"C1TOTAL",  "N", TamSx3("C1_QUANT")[1], TamSx3("C1_QUANT")[2] )

nQtde := C1TOTAL
dbCloseArea()

dbSelectArea(cArea)
Return (nQtde)


/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A290SC7Aju� Autor � Ricardo Berti         � Data � 31/08/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Processa query p/ pedidos de compras(SC7) para um produto  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ExN1 := A290SC7Aju(ExpC1)                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExC1 = Codigo do produto                                   ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � ExN1 = Total da Qtde. - Qtde.ja'entregue                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA290                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function A290SC7AJU(cProd)

Local cQuery
Local cAliasQry := GetNextAlias()
Local dDataIni  := Ctod("01/"+StrZero(Month(dDataBase),2,0)+"/"+StrZero(Year(dDataBase),4,0))
Local dDataFim  := LastDay(dDataBase)
Local cArea		:= Alias()
Local nQtde		:= 0

cQuery := "SELECT SUM(C7_QUANT - C7_QUJE) C7TOTAL "
cQuery += "FROM "+RetSqlName("SC7")+" SC7 "
cQuery += "WHERE C7_FILIAL = '" + xFilial("SC7") + "' "
cQuery += "AND C7_PRODUTO   = '"+cProd+"' "
If !Empty(mv_par01) .Or. mv_par02 <> "ZZ"
	cQuery += "AND C7_LOCAL >= '"+mv_par01+"' AND C7_LOCAL <= '"+mv_par02+"' "
EndIf			
cQuery += "AND C7_QUANT     > C7_QUJE "
cQuery += "AND C7_DATPRF   >= '" + DTOS(dDataIni)	+ "' "
cQuery += "AND C7_DATPRF   <= '" + DTOS(dDataFim)	+ "' "
cQuery += "AND C7_RESIDUO   = ' ' "
cQuery += "AND SC7.D_E_L_E_T_ = ' ' "
cQuery := ChangeQuery(cQuery)
	
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)
dbGoTop()

TcSetField(cAliasQry,"C7TOTAL",  "N", TamSx3("C7_QUANT")[1], TamSx3("C7_QUANT")[2] )

nQtde := C7TOTAL
dbCloseArea()

dbSelectArea(cArea)
Return (nQtde)

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MT290Perg � Autor �Ricardo Berti         � Data �04/09/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Carrega o 'pergunte' para o grupo do programa              ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � MT290Perg()  	                                          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA290               	 	                              ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MT290Perg()

Pergunte("MTA290",.T.)
Return Nil

/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
���Fun��o    �a290MontCfg � Autor � Andre Anjos	          � Data � 17/12/2007 ���
�����������������������������������������������������������������������������Ĵ��
���Descri��o �Monta painel de configuracoes para a NewProcess                 ���
�����������������������������������������������������������������������������Ĵ��
��� Uso      � MATA290                                                        ���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/
Static Function a290MontCfg(oCenterPanel,lCalc,lFilial,nCalculo,nIncre,nMeses,lLote,lPedido,lDispoF,nDispof)
Local oChk1,oChk2,oChk3,oChk4,oChk5,oChk6,oUsado,oGet1,oGet2,oGet3,oGetDisp

@ 05,05 TO 80,140 LABEL OemToAnsi(STR0032) OF oCenterPanel  PIXEL //Opcoes de Processamento
@ 15,10 CHECKBOX oChk1 VAR lCalc PROMPT OemToAnsi(STR0005) SIZE 90, 10 OF oCenterPanel PIXEL//"Atualiza��o do Consumo do M�s"
@ 25,10 CHECKBOX oChk2 VAR lFilial PROMPT OemToAnsi(STR0027) SIZE 90, 10 OF oCenterPanel PIXEL//"Seleciona Filial"
@ 35,10 CHECKBOX oChk3 VAR lLote PROMPT OemToAnsi(STR0011) SIZE 80, 10 OF oCenterPanel PIXEL//"C�lculo do Lote Econ�mico"
@ 45,10 CHECKBOX oChk4 VAR lPedido PROMPT OemToAnsi(STR0012) SIZE 80, 10 OF oCenterPanel PIXEL//"C�lculo do Ponto de Pedido"
@ 55,10 CHECKBOX oChk6 VAR lPedido PROMPT OemToAnsi(STR0043) SIZE 100, 10 OF oCenterPanel PIXEL//"Calculo do Estoque de Seguranca"
@ 65,10 CHECKBOX oChk5 VAR lDispoF PROMPT OemToAnsi(STR0013) SIZE 90,10 ON CLICK (If(lDispoF,oGetDisp:Enable(),oGetDisp:Disable())) OF oCenterPanel PIXEL//"Ajusta Lote Econ�mico pela dispo-
//@ 65,10 Say OemToAnsi(STR0044) SIZE 80,10 OF oCenterPanel PIXEL//"Considerando consumo dos �ltimos"
//@ 65,90 MSGET oGet3 Var nDispoF Picture "@E 999" VALID nDispoF > 0 SIZE 25,10 OF oCenterPanel PIXEL; oGetDisp:Disable()

//@ 75,10 CHECKBOX oChk5 VAR lDispoF PROMPT OemToAnsi(STR0013) SIZE 90, 10 ON CLICK (If(lDispoF,oGetDisp:Enable(),oGetDisp:Disable())) OF oCenterPanel PIXEL//"Ajusta Lote Econ�mico pela dispo-
@ 72,20 Say OemToAnsi(STR0014) SIZE 80,10 OF oCenterPanel PIXEL//"nibilidade financeira"
@ 65,90 MSGET oGetDisp Var nDispoF Picture "@E 99,999,999,999" VALID nDispoF > 0 SIZE 45,10 OF oCenterPanel PIXEL; oGetDisp:Disable()

@ 05,170 TO 80,310 LABEL OemToAnsi(STR0006) OF oCenterPanel  PIXEL    //"C�lculos"
@ 20,175 RADIO oUsado VAR nCalculo 3D SIZE 70,10 PROMPT OemToAnsi(STR0007),OemToAnsi(STR0008) OF oCenterPanel PIXEL      											//"Por Peso"###"Pela Tend�ncia"
oUsado:bChange := { || IIF(nCalculo=1,(oGet1:Enable(),oGet2:Disable()),(oGet1:Disable(),oGet2:Enable())) }
@ 45,177 Say OemToAnsi(STR0009) SIZE 40,10 OF oCenterPanel PIXEL    																													//"Incremento:"
@ 43,240 MSGET oGet1 VAR nIncre When IIF(nCalculo=1,.T.,.F.) Picture "999" SIZE 15,10 OF oCenterPanel PIXEL
@ 60,177 Say OemToAnsi(STR0010) SIZE 60,10 OF oCenterPanel PIXEL     																												//"N�mero de Meses:"
@ 58,240 MSGET oGet2 VAR nMeses When IIF(nCalculo=2,.T.,.F.) Picture "999" SIZE 15,10 VALID (nMeses < 13 .And. nMeses > 0) OF oCenterPanel PIXEL
Return

/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
���Fun��o    �a290MontABC � Autor � Andre Anjos	          � Data � 17/12/2007 ���
�����������������������������������������������������������������������������Ĵ��
���Descri��o �Monta painel de curva ABC para a NewProcess                     ���
�����������������������������������������������������������������������������Ĵ��
��� Uso      � MATA290                                                        ���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/
Static Function a290MontABC(oCenterPanel,nA1,nB1,nC1,nA2,nB2,nC2,lGrvABC)
Local oChk1

@ 05,05 TO 73,180 LABEL OemToAnsi(STR0015) OF oCenterPanel PIXEL//"Classifica��o ABC"
@ 10,57 TO 58,94 LABEL "A" OF oCenterPanel  PIXEL
@ 10,95 TO 58,132 LABEL "B" OF oCenterPanel  PIXEL
@ 10,133 TO 58,170 LABEL "C" OF oCenterPanel  PIXEL
@ 18,10 Say OemToAnsi(STR0016) SIZE 45,10 OF oCenterPanel PIXEL   //"Per�odo de"
@ 25,10 Say OemToAnsi(STR0017) SIZE 45,10 OF oCenterPanel PIXEL   //"Aquisi��o(meses)"
@ 38,10 Say OemToAnsi(STR0018) SIZE 45,10 OF oCenterPanel PIXEL   //"Distribui��o"
@ 45,10 Say OemToAnsi(STR0019) SIZE 45,10 OF oCenterPanel PIXEL   //"Percentual (%)"
@ 20,63 MSGET nA1 Picture "99.9" VALID nA1 >0 SIZE 17,10 OF oCenterPanel PIXEL
@ 20,100 MSGET nB1 Picture "99.9" VALID nB1 >0 SIZE 17,10 OF oCenterPanel PIXEL
@ 20,139 MSGET nC1 Picture "99.9" VALID nC1 >0 SIZE 17,10 OF oCenterPanel PIXEL
@ 40,63 MSGET nA2 Picture "99.9" VALID nA2 >0 SIZE 17,10 OF oCenterPanel PIXEL
@ 40,100 MSGET nB2 Picture "99.9" VALID nB2 >0 SIZE 17,10 OF oCenterPanel PIXEL
@ 40,139 MSGET nC2 Picture "99.9" VALID nC2 >0 SIZE 17,10 OF oCenterPanel PIXEL
@ 60,10 CHECKBOX oChk1 VAR lGrvABC PROMPT OemToAnsi(STR0025) SIZE 74,10 OF oCenterPanel PIXEL

Return

/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
���Fun��o    �a290MontFil � Autor � Andre Anjos	          � Data � 17/12/2007 ���
�����������������������������������������������������������������������������Ĵ��
���Descri��o �Monta painel de filtros para a NewProcess                       ���
�����������������������������������������������������������������������������Ĵ��
��� Uso      � MATA290                                                        ���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/
Static Function a290MontFil(oCenterPanel,lGrpVazio)
Local oQual,oQual2,oChkQual,oChkQual2,oChkGrpVz
Local lQual, lQual2

@ 05,05 TO 110,290 LABEL OemToAnsi(STR0031) OF oCenterPanel PIXEL//"Filtros
If Len(aTipo) > 0
	@ 15,15 CHECKBOX oChkQual  VAR lQual  PROMPT OemToAnsi(STR0024) SIZE 50, 10 OF oCenterPanel PIXEL ON CLICK (AEval(aTipo , {|z| z[1] := If(z[1]==.T.,.F.,.T.)}), oQual:Refresh(.F.)) //"Inverter Selecao"
	oQual := TCBrowse():New(25,15,100,81,,,,oCenterPanel,,,,,{||aTipo:=ca290troca(oQual:nAt,aTipo),oQual:Refresh()},,,,,,,.T.,,.T.,,.F.,,)	
	oQual:SetArray(aTipo)

	oQual:AddColumn(TCColumn():New("",{|| If(aTipo[oQual:nAt,1],oOk,oNo)},,,,"LEFT",,.T.,.F.,,,,.T.,))
	oQual:AddColumn(TCColumn():New(OemToAnsi(STR0020),{|| aTipo[oQual:nAt,2]},,,,"LEFT",,.F.,.F.,,,,.F.,))
	oQual:Refresh()
EndIf
If Len(aGrupo) > 0
	@ 15,130 CHECKBOX oChkQual2 VAR lQual2 PROMPT OemToAnsi(STR0024) SIZE 50, 10 OF oCenterPanel PIXEL ON CLICK (AEval(aGrupo, {|z| z[1] := If(z[1]==.T.,.F.,.T.)}),oQual2:Refresh(.F.)) //"Inverter Selecao"
	@ 15,200 CHECKBOX oChkGrpVz VAR lGrpVazio PROMPT STR0042 SIZE 90, 10 OF oCenterPanel PIXEL
	oQual2 := TCBrowse():New(25,130,150,81,,,,oCenterPanel,,,,,{||aGrupo:=ca290troca(oQual2:nAt,aGrupo),oQual2:Refresh()},,,,,,,.T.,,.T.,,.F.,,)	
	oQual2:SetArray(aGrupo)
	
	oQual2:AddColumn(TCColumn():New("",{|| If(aGrupo[oQual2:nAt,1],oOk,oNo)},,,,"LEFT",,.T.,.F.,,,,.T.,))
	oQual2:AddColumn(TCColumn():New(OemToAnsi(STR0021),{|| aGrupo[oQual2:nAt,2]},,,,"LEFT",,.F.,.F.,,,,.F.,))
	oQual2:Refresh()
EndIf

Return

/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
���Fun��o    �a290PrepPrc � Autor � Andre Anjos	          � Data � 17/12/2007 ���
�����������������������������������������������������������������������������Ĵ��
���Descri��o �Prepara variaveis para processamento		                      ���
�����������������������������������������������������������������������������Ĵ��
��� Uso      � MATA290                                                        ���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/
Static Function a290PrepPrc(nIncre,nMeses,lPedido,lDispoF,nDispoF,nA1,nA2,nB1,nB2,nC1,nC2,lFilial,lCalc,nCalculo,lLote,lGrpVazio,lEstSeg,nMesesES,lConsumo)

Local i, nArr
Local aOpt[11][3]

//���������������������������������������������Ŀ
//� Grava Atualizacao do Consumo do Mes no array�
//�����������������������������������������������
If lCalc
	aOpt[1,1]:= "x"
Else
	aOpt[1,1]:=" "
EndIf
	
//�������������������������������������������������������������Ŀ
//� Grava Tipo de Calculo e valor p/ formula de calculo no array�
//���������������������������������������������������������������
If nCalculo=1
	aOpt[2,1]:="x"
	aOpt[2,2]:=nIncre
	aOpt[3,1]:=" "
	aOpt[3,2]:=0
Else
	aOpt[2,1]:=" "
	aOpt[2,2]:=0
	aOpt[3,1]:="x"
	aOpt[3,2]:=nMeses
EndIf
	
//�����������������������������������������Ŀ
//� Grava Calculo do Lote Economico no array�
//�������������������������������������������
If lLote
	aOpt[4,1]:="x"
	If lPedido
		aOpt[4,2]:="x"
	EndIf
Else
	If lPedido
		aOpt[4,2]:="x"
	Else
		aOpt[4,2]:=" "
	EndIf
	aOpt[4,1]:=" "
EndIf

	
//������������������������������������������Ŀ
//� Grava disponibilidade financeira no array�
//��������������������������������������������
If lDispoF
	aOpt[5,1]:="x"
	aOpt[5,2]:=nDispoF
Else
	aOpt[5,1]:=" "
	aOpt[5,2]:=0
EndIf

//�������������������������������������Ŀ
//� Grava Periodos de Aquisicao no array�
//���������������������������������������
aOpt[6,1]:=nA1
aOpt[6,2]:=nB1
aOpt[6,3]:=nC1

//���������������������������������Ŀ
//� Grava percentuais no array      �
//�����������������������������������
aOpt[7,1]:=nA2
aOpt[7,2]:=nB2
aOpt[7,3]:=nC2

//���������������������������������Ŀ
//� Move aTipo p/aOpt               �
//�����������������������������������
aOpt[8][1]:=""
nArr:=0
For i:=1 To Len(aTipo)
	If aTipo[i][1]
		nArr++
		aOpt[8][1] := aOpt[8][1]+SubStr(aTipo[i,2],1,2)+"|"
	EndIf
Next i
If nArr == Len(aTipo)
	aOpt[8][1]:="**"
EndIf

//���������������������������������Ŀ
//� Move aGrupo p/aOpt              �
//�����������������������������������
aOpt[9][1]:=""
nArr:=0
For i:=1 To Len(aGrupo)
	If aGrupo[i][1]
		nArr++
		aOpt[9][1] := aOpt[9][1]+SubStr(aGrupo[i,2],1,4)+"|"
	EndIf
Next i
If nArr == Len(aGrupo) .And. !Empty(aOpt[9][1])
	aOpt[9][1] := IIf(lGrpVazio, "**", aOpt[9][1])
Else
	aOpt[9][1] := IIf(lGrpVazio .And. Len(aGrupo)>0, aOpt[9][1]+Space(Len(SB1->B1_GRUPO))+"|", aOpt[9][1])
EndIf

//����������������������������������������������Ŀ
//� Ativa ou nao, selecao de Filiais no Array    �
//� Se nao ativar, processa somente filial atual �
//������������������������������������������������
aOpt[10,1] := lFilial

//����������������������������������������������Ŀ
//� Ativa ou nao, estoque de seguran�a por media �
//� de consumo ou pela previs�o de vendas        �
//������������������������������������������������

If lEstSeg
	aOpt[11,1] := "x"
	aOpt[11,2] := nMesesES
	aOpt[11,3] := lConsumo
EndIf

Return aOpt

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    �A290CalcES� Autor � Rodrigo Toledo        � Data � 16/12/2011 ���
���������������������������������������������������������������������������Ĵ��
���Descri��o �C�lculo e atualizacao do estoque de seguranca				    ���
���������������������������������������������������������������������������Ĵ��
���Parametros�ExpC1 = numero de meses                                       ���
���������������������������������������������������������������������������Ĵ��
��� Uso      � MATA290                                                      ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/                      
Static Function A290CalcES(nQtMeses,oCenterPanel,lConsumo)
Local lQuery   	:= .F.
Local cAliasSB1	:= "SB1" 
Local cFormula  := ""
Local cTabela   := SuperGetMV("MV_ARQPROD",.F.,"SB1")
Local nX      	:= 0
Local cData	 	:= DToC(dDataBase)
Local nTot		:= 0
Static nQtMeses2:= 0

Local cOpcoes := ""
Local cQuery := ""
    
Default lConsumo := .F.

dbSelectArea("SB1")
dbSetOrder(1)
lQuery   := .T.
cAliasSB1 := GetNextAlias()
cQuery := "SELECT SB1.B1_FILIAL,SB1.B1_COD,SB1.B1_ESTSEG,SB1.R_E_C_N_O_ RECNOSB1, "
If lConsumo
	cQuery += "SB3.B3_Q01,SB3.B3_Q02,SB3.B3_Q03,SB3.B3_Q04,SB3.B3_Q05,SB3.B3_Q06,SB3.B3_Q07, "
	cQuery += "SB3.B3_Q08,SB3.B3_Q09,SB3.B3_Q10,SB3.B3_Q11,SB3.B3_Q12 "
Else
	cQuery += " SUM(C4_QUANT) AS TOTSC4 "
EndIf
cQuery += "FROM " + RetSqlName("SB1") + " SB1 "
If lConsumo
	cQuery += "LEFT JOIN " + RetSqlName("SB3") + " SB3 ON  SB3.B3_FILIAL = '" + xFilial("SB3") + "' "
	cQuery += "AND SB3.B3_COD = SB1.B1_COD AND SB3.D_E_L_E_T_ = ' ' "         
Else
cQuery += "LEFT JOIN " + RetSqlName("SC4") + " SC4 ON  SC4.C4_FILIAL = '" + xFilial("SC4") + "' "
	cQuery += "AND SC4.C4_PRODUTO = SB1.B1_COD AND SC4.D_E_L_E_T_ = ' ' "         
Endif
cQuery += "WHERE SB1.B1_FILIAL = '" + xFilial("SB1") + "' "
cQuery += "AND SB1.B1_COD >= '"+mv_par03+"' AND SB1.B1_COD <= '"+mv_par04+"' "
If !lConsumo
	cQuery += " AND SC4.C4_DATA BETWEEN '" +DToS(dDataBase) +"' AND '" +DToS(dDataBase + (nQtMeses * 30)) +"'"
EndIf
If aOpcoes[8][1] != "**" .And. !Empty(aOpcoes[8][1])
      		cOpcoes := Trim(aOpcoes[8][1])
         	cOpcoes := Substr(cOpcoes,1,Len(cOpcoes)-1)
      		cQuery += "AND SB1.B1_TIPO IN ('"+StrTran(cOpcoes,"|","','")+"') "
EndIf
If aOpcoes[9][1] != "**" .And. !Empty(aOpcoes[9][1])
      		cOpcoes := Trim(aOpcoes[9][1])
         	cOpcoes := Substr(cOpcoes,1,Len(cOpcoes)-1)
         	cQuery += "AND SB1.B1_GRUPO IN ('"+StrTran(cOpcoes,"|","','")+"') "
     	EndIf
cQuery += "AND SB1.D_E_L_E_T_ = ' ' "
If !lConsumo
      		cQuery += "GROUP BY SB1.B1_FILIAL,SB1.B1_COD,SB1.B1_ESTSEG,SB1.R_E_C_N_O_"
EndIf      
cQuery := ChangeQuery(cQuery)     
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSB1,.T.,.T.)
dbGoTop()
//�������������������������������������Ŀ
//� monta a formula de consumos medios  �
//���������������������������������������
cFormula := ""
If lConsumo
	nQtMeses2:=nQtMeses
	For nX := 1 To nQtMeses2
   		cMes := StrZero((Month(CToD(cData)) - nX),2)
      If cMes == "00"
      		cMes := "12"
      		cData := "01/" + cMes + "/" + StrZero((Year(dDataBase) - 1),4)
      		nX := nX - 2
      		nQtMeses2 := nQtMeses2 - 2
		EndIf   
      If nX > nQtMeses2
      		Exit
      EndIf
      cFormula += "B3_Q"+cMes+"+"
	Next
   cFormula := "(" + SubStr(cFormula,1,Len(cFormula)-1) + ")"
EndIf

SB3->(dbSetOrder(1))
SB5->(dbSetOrder(1))
SC4->(dbSetOrder(1))

//���������������������������������������������Ŀ
//� Realiza o calculo do estoque de seguranca   �
//�����������������������������������������������
While (cAliasSB1)->(!EOF()) .And. (lQuery .Or. (cAliasSB1)->(B1_FILIAL+B1_COD) <= xFilial("SB1")+mv_par04)
	SB5->(dbSeek(xFilial("SB5")+(cAliasSB1)->B1_COD))
	
	If lQuery
		If lConsumo
      		nMC := (cAliasSB1)->(&cFormula / (nQtMeses * 30))
		Else
      		nMC := (cAliasSB1)->(TOTSC4 / (nQtMeses * 30))
		EndIf
	Else 
		If lConsumo
         	If SB3->(dbSeek(xFilial("SB3")+(cAliasSB1)->B1_COD))
         		nMC := SB3->(&cFormula / (nQtMeses * 30))
    		EndIf                                                 
		Else
			SC4->(dbSeek(xFilial("SC4")+(cAliasSB1)->B1_COD+DToS(dDataBase),.T.))
	   		While !SC4->(EOF()) .And. SC4->(C4_FILIAL+C4_PRODUTO) == xFilial("SB1")+(cAliasSB1)->B1_COD .And.;
	   									SC4->C4_DATA <= (dDataBase + (nQtMeses * 30))
   				nTot += SC4->C4_QUANT
   				SC4->(dbSkip())
   			EndDo
   			nMC := nTot / (nQtMeses * 30)
		EndIf
	EndIf

	nCalcES := Round(nMC * SB5->B5_DIASES,0)
	
	If cTabela == "SBZ"
    	If SBZ->(dbSeek(xFilial("SBZ")+(cAliasSB1)->B1_COD))
        	RecLock("SBZ",.F.)
            Replace BZ_ESTSEG With nCalcES
			MsUnlock()
		EndIf
	Else
    	If SB1->(dbSeek(xFilial("SB1")+(cAliasSB1)->B1_COD))
        	RecLock("SB1",.F.)
            Replace B1_ESTSEG With nCalcES
            MsUnlock()
		EndIf
	EndIf
	(cAliasSB1)->(dbSkip())

	If !lBat
   		If oCenterPanel <> NIL
      		oCenterPanel:IncRegua1(OemToAnsi(STR0039))
		Else
      		IncProc()
		EndIf
	EndIf
EndDo

If lQuery
   (cAliasSB1)->(dbCloseArea())
EndIf

Return
