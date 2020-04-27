#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"

User Function KMHR821()
//Relatório de impressão de Ordem de Produção

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "Ordem de Produção"
Local cPict         := ""
Local nLin         	:= 80
Local Cabec1       	:= ""
Local Cabec2       	:= ""
Local imprime      	:= .T.
Local aOrd 			:= {}
Local oPrinter 	    := Nil
Local nPrintType	:= 6
Local lAdjust   	:= .F.
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 132
Private tamanho     := "P"
Private nomeprog    := "RPCPR01" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := ""
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private wnrel      	:= "KMHR820" // Coloque aqui o nome do arquivo usado para impressao em disco
Private xNumop 		:=""
Private titulo      := ""
Private oPr
Private xDescri
//Fonte do relatorio
Private oFont01		:= TFont():New('Arial',,06,,.F.,,,,.F.,.F.)

Private oFontC
Private oFontT
Private nMaxLin	:= 0
Private nMaxCol	:= 0
Private cUnMd:=""

//oPr := ReturnPrtObj()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime o codigo de barras do numero da OP              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//cCode := SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD
//MSBAR("CODE128",12,10,Alltrim(cCode),oPr,.F.,,.T.,0.013, 1 ,NIL,NIL,NIL)

Private cString :="SC2"

dbSelectArea("SC2")
dbSetOrder(1)
xNumop:=SC2->C2_NUM
titulo:="Ordem de produção numero : " + xNumop

//pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho)//,,.F.)
//wnrel := SetPrint(cString,wnrel   ,cPerg,@titulo,cDesc ,""    ,""    ,.F.,aOrd,.F.,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,@Titulo,nLin) },Titulo)
Return

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local nSomaOri 		:= 0
Local nSomaC 		:= 0
Local nSomaQTD 		:= 0
Local nSomaT		:= 0
Local lResp1		:= .T.
Local nLinBar    	:= 0
Private nRec 		:= 0
Private cAlias 		:= GetNextAlias()
Private nQtdUn      :=0
Private nQtdGr      :=0

lFirst := .t.
xDados(cAlias,@Titulo)

SetRegua(nRec)
dbGoTop()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o cancelamento pelo usuario...                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lAbortPrint
	@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do cabecalho do relatorio. . .                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If nLin > 65 // Salto de Página. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 5
Endif

if lFirst //C2_SEQUEN ==  Strzero(1,TamSx3("C2_SEQUEN")[1])
	
	lFirst := .f.
	
	@nLin,00 Psay  __PrtThinLine() //Replicate("-",limite+10)
	
	nLin++
	
	cQuery := "SELECT C2_PRODUTO FROM SC2010 WHERE D_E_L_E_T_ != '*' AND C2_ITEM = '01' AND C2_SEQUEN = '001' AND C2_NUM = '"+SC2->C2_NUM+"'" +CRLF
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery ),"TRD",.F.,.T.)
	
	SB1->(DBSELECTAREA("SB1"))
	SB1->(DBSETORDER(1))
	SB1->(DBSEEK(xFilial("SB1") + TRD->C2_PRODUTO))
	
	cTipoP :="PP"
	cTipoP1 := "MP"
	cTipoSC := SB1->B1_TIPO
	
	
	If SC2->C2_SEQUEN >= "002" .And. SUBSTR(SC2->C2_PRODUTO, 1, 4) <> "3190"
		cTipoSC := "PP"
	EndIf
	
EndIf


@nLin,00 Psay "Tipo OP :"+SC2->C2_TPOP+"   "+FormatStr("Data de Inclusão :%d",SC2->C2_EMISSAO)

DbselectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial("SB1")+ SC2->C2_PRODUTO)
xDescri:=SB1->B1_DESC


nLin++

cQuery := "SELECT SUM(D3_QUANT) D3_QUANT, MIN(D3_DTVALID) AS D3DTVALID FROM "+RETSQLNAME("SD3")+" SD3 " +CRLF
cQuery += "WHERE D_E_L_E_T_ != '*' AND D3_FILIAL = '"+SC2->C2_FILIAL+"' AND D3_OP = '"+(SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN)+"' AND SD3.D3_ESTORNO != 'S' " +CRLF
cQuery += "AND D3_COD = '"+SC2->C2_PRODUTO+"' " +CRLF


dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery ),"TRC",.F.,.T.)

nSomaC	:= nSomaC + TRC->D3_QUANT


@nLin,00 Psay "Codigo  :"+SUBSTR(SC2->C2_PRODUTO, 1, 15)
@nLin,25 Psay SUBSTR(xDescri, 1, 35)

//@nLin,90 Psay FormatStr("QT EST:%@E 99,999.99999n",SC2->C2_QUANT )+" "+SC2->C2_UM

nLin++

@nLin,00 Psay "Seq.    :"+SC2->C2_SEQUEN
@nLin,40 Psay FormatStr("QT REAL:%@E 99,999.99999n",TRC->D3_QUANT )+" "+SC2->C2_UM
@nLin,20 Psay FormatStr("Inicio :%d",SC2->C2_EMISSAO)
@nLin,65 Psay FormatStr("FIM :%d",SC2->C2_DATPRF)

TRC->(DBCLOSEAREA())


nLin++

@nLin,00 Psay __PrtThinLine() //Rep.licate("-",limite)

nLin++

cTipoSC := SB1->B1_TIPO
//linha para alterar
If SC2->C2_SEQUEN >= "002" .And. SUBSTR(SC2->C2_PRODUTO, 1, 4) <> "3190"
	cTipoSC := "PP"
EndIf

//Analisar uma melhor solucao
If ((SC2->C2_PRODUTO='520100011' .OR. SC2->C2_PRODUTO='521400005' .OR. SC2->C2_PRODUTO='520100012' .OR. SC2->C2_PRODUTO='522200003' .OR. SC2->C2_PRODUTO='522100006' .OR. SC2->C2_PRODUTO='521600005') .AND. cTipoSC='PI')
	cTipoSC:='PP'
Endif

If SC2->C2_PRODUTO='522500002'
	cTipoP:='PI'
Endif



If cTipoSC = cTipoP
	//A      520500011    ESSENCIA IFF TENYS 130 MOD 44      3,59932KG        -0,59932KG        3,00000KG  0005632166    00000000000
	//012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	@nLin,00 Psay "FASE   CODIGO       DESCRICAO                       QUANT. PREVISTA    QUANT. REALIZADA        LOTE          ENDEREÇO  "
ElseIf cTipoSC = cTipoP1
	//A      520500011    ESSENCIA IFF TENYS 130 MOD 44      3,59932KG        -0,59932KG        3,00000KG  0005632166    00000000000
	@nLin,00 Psay "FASE   CODIGO       DESCRICAO                       QUANT. PREVISTA    QUANT. REALIZADA        LOTE          ENDEREÇO  "
Else
	//         10        20        30        40        50        60        70        80        90        100       110       120
	//1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234
	//411000006    FITA ADES PERSONALIZ PPR 3M-5   1,97250KG   _______   _______ _______    _______     _______  ______  _________
	@nLin,00 Psay "CODIGO      DESCRICAO                       QUANTIDADE/UM"
Endif

nLin++

@nLin,00 Psay __PrtThinLine()

nLin++

cQuery := "SELECT D4_COD, B1_DESC DESCRICAO, B1_UM, D4_LOTECTL, SUM(D4_QTDEORI) D4_QUANT, SUM(D4_QTDEORI) AS D4_QTDEORI, B1_TIPO TIPO_MP" +CRLF
cQuery += "FROM "+RETSQLNAME("SD4")+"(NOLOCK) SD4 JOIN "+RETSQLNAME("SB1")+" (NOLOCK) SB1 ON SD4.D4_COD=SB1.B1_COD AND SB1.B1_TIPO IN('MP') WHERE SD4.D_E_L_E_T_='' AND SUBSTRING(D4_OP,1,6)='"+(SC2->C2_NUM)+"'" +CRLF
cQuery += "GROUP BY D4_COD, B1_DESC, B1_UM, B1_TIPO, D4_LOTECTL " +CRLF

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery ),"TR4",.F.,.T.)

Do While TR4->(!EOF())
	
	If nLin > 65 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 5
	Endif
	
	
	SB1->(DBSELECTAREA("SB1"))
	SB1->(DBSETORDER(1))
	SB1->(DBSEEK(xFilial("SB1") + TR4->D4_COD))
	
	cQuery := "SELECT SUM(D3_QUANT) AS D3_QUANT  FROM "+RETSQLNAME("SD3")+" " +CRLF
	cQuery += "WHERE D_E_L_E_T_ != '*' AND D3_FILIAL = '"+SC2->C2_FILIAL+"' " +CRLF
	cQuery += "AND SUBSTRING(D3_OP,1,6) = '"+(SC2->C2_NUM)+"' AND D3_COD = '"+SB1->B1_COD+"' AND D3_ESTORNO != 'S'" +CRLF
	
	
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery ),"TRB",.F.,.T.)
	
	If Localiza(TR4->D4_COD)
		cQuery := "SELECT DC_LOCALIZ FROM "+RETSQLNAME("SDC")+" " +CRLF
		cQuery += "WHERE D_E_L_E_T_ != '*' AND DC_FILIAL = '"+SC2->C2_FILIAL+"' AND DC_LOTECTL = '"+TR4->D4_LOTECTL+"' " +CRLF
		cQuery += "AND SUBSTRING(DC_OP,1,6) = '"+(SC2->C2_NUM)+"' AND DC_PRODUTO = '"+TR4->D4_COD+"'" + CRLF
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery ),"TRZ",.F.,.T.)
	Endif
	
	If cTipoSC == cTipoP .Or. cTipoSC = cTipoP1
		
		@nLin,02 Psay TR4->D4_TRT
		@nLin,07 Psay Left(TR4->D4_COD,12)
		@nLin,20 Psay Left(SB1->B1_DESC,29)
		
		DbSelectArea("SB1")
		DbSetOrder(1)
		DbSeek(xFilial("SB1")+TR4->D4_COD)
		cUnMd:=B1_UM
		
		
		If cUnMd="GR"
			
			nQtdGr:=TR4->D4_QTDEORI / 1000
			
		Else
			nQtdGr:=TR4->D4_QTDEORI
			
		Endif
		
		If cUnMd="UN"
			
			nQtdUn:=TR4->D4_QTDEORI
			
		Endif
		
		If ! EMPTY(TRB->D3_QUANT)
			@nLin,50 Psay TR4->D4_QTDEORI PICTURE "@E 99,999.99999" + SB1->B1_UM
			//@nLin,67 Psay TR4->D4_QTDEORI PICTURE "@E 999,999.99999" + SB1->B1_UM //TRB->D3_QUANT
			//@nLin,84 Psay TRB->D3_QUANT PICTURE "@E 999,999.99999" + SB1->B1_UM
			//@nLin,68 Psay TR4->D4_QTDEORI PICTURE "@E 99,999.99999" + SB1->B1_UM
			If TR4->D4_COD='521400005'
				@nLin,68 Psay TRB->D3_QUANT/2 PICTURE "@E 999,999.99999" + SB1->B1_UM
			Else
				@nLin,68 Psay TRB->D3_QUANT   PICTURE "@E 999,999.99999" + SB1->B1_UM
			Endif
			@nLin,95 Psay TR4->D4_LOTECTL
			If Localiza(TR4->D4_COD)
				@nLin,110 Psay TRZ->DC_LOCALIZ
			Endif
		Else
			
			
			
			@nLin,50 Psay TR4->D4_QTDEORI PICTURE "@E 99,999.99999" + SB1->B1_UM
			//@nLin,50 Psay nQtdGr PICTURE "@E 99,999.99999" + SB1->B1_UM
			//@nLin,67 Psay Replicate("_",7) + SB1->B1_UM
			@nLin,68 Psay 0.00 PICTURE "@E 99,999.99999" + SB1->B1_UM
			@nLin,95 Psay TR4->D4_LOTECTL
			If Localiza(TR4->D4_COD)
				@nLin,110 Psay TRZ->DC_LOCALIZ
			Endif
		EndIf
		
		
		nSomaOri 	:= nSomaOri + nQtdGr
		nSomaT 		:= nSomaT + TRB->D3_QUANT
	Else
		@nLin,0 Psay Left(TR4->D4_COD,12)  		//Left(C2_PRODUTO,12)
		@nLin,13 Psay Left(SB1->B1_DESC,29)
		
		If ! EMPTY(TRB->D3_QUANT)
			
			
			
			If cUnMd="GR"
				@nLin,46 Psay TRB->D3_QUANT / 100 PICTURE "@E 99,999.99999" + SB1->B1_UM
			Else
				@nLin,46 Psay TRB->D3_QUANT PICTURE "@E 99,999.99999" + SB1->B1_UM
			Endif
			//@nLin,58 Psay Replicate("_",7)
			//@nLin,68 Psay Replicate("_",7)
			//@nLin,76 Psay Replicate("_",7)
			//@nLin,87 Psay Replicate("_",7)
			//@nLin,99 Psay Replicate("_",7)
			//@nLin,108 Psay Replicate("_",7)
			If Localiza(TR4->D4_COD)
				@nLin,115 Psay TRZ->DC_LOCALIZ
			Endif
		Else
			If cUnMd="GR"
				//@nLin,46 Psay TR4->D4_QTDEORI / 100 PICTURE "@E 99,999.99999" + SB1->B1_UM
				@nLin,46 Psay nQtdGr PICTURE "@E 99,999.99999" + SB1->B1_UM
			Else
				@nLin,46 Psay TR4->D4_QTDEORI PICTURE "@E 99,999.99999" + SB1->B1_UM
			Endif
			//@nLin,61 Psay Replicate("_",7)
			//@nLin,68 Psay Replicate("_",7)
			//@nLin,76 Psay Replicate("_",7)
			//@nLin,87 Psay Replicate("_",7)
			//@nLin,99 Psay Replicate("_",7)
			//@nLin,108 Psay Replicate("_",7)
			If Localiza(TR4->D4_COD)
				@nLin,118 Psay TRZ->DC_LOCALIZ
			Endif
		EndIf
		
	EndIf
	
	TRB->(DBCLOSEAREA())
	TRZ->(DBCLOSEAREA())
	
	nLin++
	TR4->(dbSkip())
Enddo

nLin++

TR4->(DBCLOSEAREA())


nLin++

//Alterador Por Douglas Rodrigues conforme solicitação de Cristian Melos 20/08/2013

cTipoSC := SB1->B1_TIPO

If SC2->C2_SEQUEN >= "002" .And. SUBSTR(SC2->C2_PRODUTO, 1, 4) <> "3190"
	cTipoSC := "PP"
EndIf

If cTipoSC = cTipoP
	
	//@nLin,00 Psay "Total: "
	//@nLin,50 Psay nSomaOri - nQtdUn PICTURE "@E 999,999.9999" + SC2->C2_UM
	
	If !EMPTY(nSomaT)
		@nLin,68 Psay nSomaC - nQtdUn PICTURE "@E 999,999.9999" + SC2->C2_UM
		
	EndIf
	
ElseIf SB1->B1_TIPO = cTipoP1
	
	//@nLin,00 Psay "Total: "
   //	@nLin,50 Psay nSomaOri - nQtdUn PICTURE "@E 999,999.9999" + SC2->C2_UM
	
	//If !EMPTY(nSomaT)
	//	@nLin,68 Psay nSomaC - nQtdUn PICTURE "@E 999,999.9999" + SC2->C2_UM
		
   //	EndIf
	
Endif


nLin++

@nLin,00 Psay __PrtThinLine()

nLin++



If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 5
Endif

cQuery := "SELECT C2_PRODUTO FROM "+RETSQLNAME("SC2")+" WHERE D_E_L_E_T_ != '*' AND C2_ITEM = '01' AND C2_SEQUEN = '001' AND C2_NUM = '"+SC2->C2_NUM+"'" +CRLF

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery ),"TRX",.F.,.T.)

SB1->(DBSELECTAREA("SB1"))
SB1->(DBSETORDER(1))
SB1->(DBSEEK(xFilial("SB1") + TRX->C2_PRODUTO))

TRD->(DBCLOSEAREA())
TRX->(DBCLOSEAREA())

cTipoP := "PA"
cTipoP1 := "SA"
cTipoSC := SB1->B1_TIPO

If SC2->C2_SEQUEN >= "002" .And. SUBSTR(SC2->C2_PRODUTO, 1, 4) <> "3190"
	cTipoSC := "PP"
EndIf

If cTipoSC == cTipoP
	
	lResp1 := .T.
	
ElseIf cTipoSC == cTipoP1
	
	lResp1 := .T.
	
ELSE
	
	lResp1 := .F.
	
EndIf

If	lResp1
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 5
	Endif
	/*
	@nLin,00 Psay Replicate("_",limite)
	XMSG := "ROTEIRO DAS OPERACOES"
	@nLin,25 Psay XMSG
	nLin+=2
	@nLin,00 Psay Replicate("_",limite)
	nLin+=2
	
	@nLin++,00 Psay "OPER.           					DESCRICAO                QUANT. PROD				RECURSO			PC./HORA"
	@nLin++,00 Psay "10 - CORTE MADEIRA"
	@nLin++,10 Psay "12 - MONTAGEM ESTRUTURAS"
	@nLin++,10 Psay "14 - ESPUMAÇÃO"	
	
	*/
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 5
	Endif
	
	
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 5
	Endif

	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 5
	Endif
	
	
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 5
	Endif
	
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 5
	Endif
	
		//@nLin,000 Psay Replicate("_",12)
		//@nLin,018 Psay Replicate("_",12)
		//@nLin,038 Psay Replicate("_",12)
		//@nLin,060 Psay Replicate("_",12)
		//@nLin,080 Psay Replicate("_",12)
		//@nLin,104 Psay Replicate("_",25)
		//nLin++
		
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 5
	Endif
	
Else
	/*
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 5
	Endif
	
	@nLin,50 Psay "CONTROLE DE PESAGEM"
	
	nLin++
	
	@nLin,00 Psay __PrtThinLine()
	
	nLin+=2
	
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 5
	Endif
	
		@nLin,000 Psay "___/___/____" //Replicate("_",12)
		@nLin,018 Psay "______:______"//Replicate("_",12)
		@nLin,038 Psay "______:______"//Replicate("_",12)
		@nLin,060 Psay Replicate("_",12)
		@nLin,080 Psay Replicate("_",12)
		@nLin,104 Psay Replicate("_",25)
		nLin+=2
	
	nLin+=1
	
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 6
	Endif
	
	
	@nLin,50 Psay "CONTROLE DE MANIPULAÇÃO"
	
	nLin++
	
	@nLin,00 Psay __PrtThinLine()
	
	nLin+=2
	
	@nLin,00 Psay "DATA              INICIO              TERMINO               N.FUNC              RESPONSAVEL             OBSERVAÇÃO"
	nLin+=2
	for i:= 1 to 2
		@nLin,000 Psay "___/___/____" //Replicate("_",12)
		@nLin,018 Psay "______:______"//Replicate("_",12)
		@nLin,038 Psay "______:______"//Replicate("_",12)
		@nLin,060 Psay Replicate("_",12)
		@nLin,080 Psay Replicate("_",12)
		@nLin,104 Psay Replicate("_",25)
		nLin+=2
	Next
	
	nLin+=1
	
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 6
	Endif
	
	
	@nLin,50 Psay "CONTROLE DE QUALIDADE"
	
	nLin++
	
	@nLin,00 Psay __PrtThinLine()
	
	nLin+=2
	
	for i:= 1 to 1
		@nLin,000 Psay "APROVADO"
		@nLin,018 Psay "(_______)"//Replicate("_",12)
		@nLin,038 Psay "REPROVADO"
		@nLin,060 Psay "(______)"
		@nLin,080 Psay "REPROCESSO"
		@nLin,104 Psay "(______)"
		nLin+=2
	Next
	
	@nLin,00 Psay "OBSERVAÇÃO."
	@nLin,12 Psay Replicate("_",117)
	nLin+=2
	@nLin,00 Psay Replicate("_",129)
	nLin++
	
	nLin+=2
	
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 6
	Endif
	
	@nLin,50 Psay "CONTROLE DE TRANSFERENCIA PARA EMBALAGEM"
	
	nLin++
	
	@nLin,00 Psay __PrtThinLine()
	
	nLin+=2
	
	for i:= 1 to 1
		@nLin,000 Psay "PERDA NO PROCESSO"
		@nLin,018 Psay "[_______%]"//Replicate("_",12)
		@nLin,038 Psay "PERDA NA TRANSFER"
		@nLin,060 Psay "[_______%]"
		@nLin,080 Psay "QUANTIDADE RECEBIDA"
		@nLin,104 Psay "[_______%]"
		nLin+=2
	Next
	
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 5
	Endif
	
	nLin+=2
	
	@nLin,00 Psay "DATA[___/____/____]"
	nLin+=2
	XMSG:= "ALMOXARIFADO________________________ PRODUCAO ________________________ CONTR QUALID _______________________ ESCRITORIO"
	@nLin,00 Psay XMSG+Replicate("_",(limite-Len(XMSG) ))
	*/
EndIf



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()
(cAlias)->( dbCloseArea() )
Return

Static Function xDados(cAlias,Titulo)

Local cQuery :=""
Local cqr    := " AND C2_ITEM = '"+SC2->C2_ITEM+"' AND C2_SEQUEN = '"+SC2->C2_SEQUEN+"'"

cQuery +=" SELECT B1_DESC, C2.* FROM "+RetSqlName("SC2")+" C2 JOIN "+RetSqlName("SB1")+" B1 ON B1.D_E_L_E_T_ =  '' AND C2_PRODUTO =  B1_COD"
cQuery +=" WHERE C2.D_E_L_E_T_ =  '' AND C2_NUM = '"+SC2->C2_NUM + SC2->C2_ITEM+SC2->C2_SEQUEN+"' "
cQuery +=" ORDER BY C2_NUM, C2_ITEM, C2_SEQUEN"


MsAguarde({||dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery ),cAlias,.F.,.T.)},"Selecionando dados...","Aguarde, Gerandos os arquivo temporário...")
dbSelectArea(cAlias)
dbGotop()
dbEval({|| nRec++},,{ ||!(cAlias)->( Eof())},,,.f.)


TcSetField(cAlias ,"C2_DATPRI","D")
TcSetField(cAlias ,"C2_DATPRF","D")
TcSetField(cAlias ,"C2_EMISSAO","D")
TcSetField(cAlias ,"C2_DATRF","D")
TcSetField(cAlias ,"C2_DATAJI","D")
TcSetField(cAlias ,"C2_DATAJF","D")
TcSetField(cAlias ,"C2_DTUPROG","D")

Return

Static Function xDados2(cAlia2,cOP, cseq)

Local cQuery :=""

cQuery +=" SELECT B1_DESC, B1_UM, D4.* FROM "+RetSqlName("SD4")+" D4 JOIN "+RetSqlName("SB1")+" B1 ON B1.D_E_L_E_T_ =  '' AND D4_COD =  B1_COD WHERE D4.D_E_L_E_T_ =  '' "
cQuery +=" AND left(D4_OP,6) =  '"+cOP+"'"
cQuery +=" and right(rTrim(D4_OP),3) =  '"+cseq+"'"
cQuery +=" ORDER BY RIGHT(D4_OP,6), D4_COD,D4_OPORIG"


MsAguarde({||dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery ),cAlia2,.F.,.T.)},"Selecionando dados...","Aguarde, Gerandos os arquivo temporário...")
dbSelectArea(cAlia2)
dbGotop()

Return
