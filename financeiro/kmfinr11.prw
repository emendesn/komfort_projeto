#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ KMFINR11  º Autor ³ AP6 IDE           º Data ³  05/12/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório de Captura                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Komfort House                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function KMFINR11()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Declaracao de variaveis                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cPerg 	:= PadR("KMFINR11", Len(SX1->X1_GRUPO))
Local aPergunta	:= {}
Private oReport	:= Nil
Private oSecCab	:= Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao e apresentacao das perguntas      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aPergunta,{cPerg,"01","Loja de  ?" 				,"MV_CH1" ,"C",04,00,"G","MV_PAR01","SM0",""         ,"","","",""})
Aadd(aPergunta,{cPerg,"02","Loja até ?" 				,"MV_CH2" ,"C",04,00,"G","MV_PAR02","SM0",""         ,"","","",""})
Aadd(aPergunta,{cPerg,"03","Emissão de ?"			    ,"MV_CH3" ,"D",08,00,"G","MV_PAR03",""   ,""         ,"","","",""})
Aadd(aPergunta,{cPerg,"04","Emissão até ?" 			    ,"MV_CH4" ,"D",08,00,"G","MV_PAR04",""   ,""         ,"","","",""})
Aadd(aPergunta,{cPerg,"05","Ordenar por ?"			    ,"MV_CH5" ,"N",01,00,"C","MV_PAR05",""   ,"Titulo","Pedido","Nome","",""})

VldSX1(aPergunta)

If !Pergunte(cPerg,.T.)
	Return(Nil)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicoes/preparacao para impressao      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ReportDef()

oReport:PrintDialog()

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportDef ºAutor  ³ Vinícius Moreira   º Data ³ 12/11/2013  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Definição da estrutura do relatório.                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportDef()

Local cPerg 	:= PadR("KMFINR11", Len(SX1->X1_GRUPO))
Local cDesc1	:= "Relatório de Captura"
Local cDesc2	:= "Este programa tem como objetivo imprimir relatorio de acordo com os parametros informados pelo usuario."

oReport := TReport():New(cPerg,cDesc1,cPerg,{|oReport| PrReport(oReport)},cDesc2)
oReport:SetPortrait(.T.)    

oSecCab := TRSection():New( oReport , "TITULOS", {"SE1"} )

TRCell():New( oSecCab, "E1_NUM"     , "SE1")
//TRCell():New( oSecCab, "E1_PARCELA" , "SE1")
TRCell():New( oSecCab, "E1_TIPO"    , "SE1")
//TRCell():New( oSecCab, "E1_PEDIDO"	, "SE1")
TRCell():New( oSecCab, "E1_EMISSAO"	, "SE1")
TRCell():New( oSecCab, "E1_CLIENTE"	, "SE1")
TRCell():New( oSecCab, "E1_LOJA"	, "SE1")
TRCell():New( oSecCab, "A1_NOME"	, "SA1")
TRCell():New( oSecCab, "E1_VALOR"	, "SE1")
TRCell():New( oSecCab, "E1_NSUTEF"	, "SE1")
TRCell():New( oSecCab, "E1_XPARNSU"	, "SE1")
TRCell():New( oSecCab, "E1_01QPARC"	, "SE1")
TRCell():New( oSecCab, "E1_XNCART4"	, "SE1")
TRCell():New( oSecCab, "E1_MSFIL"	, "SE1")
TRCell():New( oSecCab, "E1_XDESCFI"	, "SE1")
TRCell():New( oSecCab, "E1_XDSCADM"	, "SE1")
TRCell():New( oSecCab, "E1_CPFCNPJ"	, "SE1")
TRCell():New( oSecCab, "E1_HIST"	, "SE1")
TRCell():New( oSecCab, "C5_DESPESA"	, "SC5")
TRCell():New( oSecCab, "C5_FRETE"	, "SC5")
	
TRFunction():New(oSecCab:Cell("E1_VALOR"),NIL,"SUM",,,,,.F.,.T.)
	
/*     
//Aqui, farei uma quebra  por seção
oSecCab:SetPageBreak(.T.)
oSecCab:SetTotalText(" ")
*/
	
Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCOMR01   ºAutor  ³ Vinícius Moreira   º Data ³ 12/11/2013  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PrReport(oReport)

Local cQry		:= ""
Local cPerg		:= PadR("KMFINR11", Len(SX1->X1_GRUPO))

Pergunte(cPerg,.F.)
	
cQry := " SELECT DISTINCT"
cQry += "		E1_MSFIL,"
cQry += " 		E1_NUM,"
cQry += "       E1_TIPO,"
cQry += "       E1_EMISSAO,"
cQry += "       E1_CLIENTE,"
cQry += "       E1_LOJA,"
cQry += "       A1_NOME,"
//cQry += "       (CASE WHEN E1_01QPARC > 1 THEN (SUM(E1_VALOR)/ E1_01QPARC) ELSE SUM(E1_VALOR) END) AS E1_VALOR,"
//cQry += "       E5_VALOR,"
cQry += "       E1_NSUTEF,"
cQry += "       E1_01QPARC,"
cQry += "       E1_XNCART4,"
cQry += "       E1_XDESCFI,"
cQry += "       E1_XDSCADM,"
cQry += "       E1_CPFCNPJ,"
cQry += "       ISNULL(E1_HIST, '') AS E1_HIST,"
cQry += "       C5_DESPESA,"
cQry += "       C5_FRETE"
cQry += " FROM "+ RETSQLNAME("SE1") +" (NOLOCK) SE1 "

cQry += " LEFT JOIN "+ RETSQLNAME("SE5") +" (NOLOCK) SE5 "
cQry += " ON E5_FILIAL = '"+ xFilial("SE5")+" ' "
cQry += " AND E5_PREFIXO = E1_PREFIXO "
cQry += " AND E5_NUMERO = E1_NUM "
cQry += " AND E5_CLIFOR = E1_CLIENTE "
cQry += " AND E5_LOJA = E1_LOJA "
cQry += " AND E5_TIPO = 'RA' "
cQry += " AND E5_SITUACA <> 'C' "
cQry += " AND SE5.D_E_L_E_T_ = ' ' "

cQry += " LEFT JOIN "+ RETSQLNAME("SC5") +" (NOLOCK) SC5 "
cQry += " ON C5_FILIAL = '"+ xFilial("SC5")+" ' "
cQry += " AND C5_CLIENTE = E1_CLIENTE "
cQry += " AND C5_NUM = E1_NUM "
cQry += " AND SC5.D_E_L_E_T_ = ' ' "

cQry += " INNER JOIN "+ RETSQLNAME("SA1") +" (NOLOCK) SA1"
cQry += " ON A1_FILIAL = '"+ xFilial("SA1")+" ' "
cQry += " AND A1_COD = E1_CLIENTE "
cQry += " AND A1_LOJA = E1_LOJA "
cQry += " AND SA1.D_E_L_E_T_ = ' ' "

cQry += " WHERE "
cQry += " E1_FILIAL = '"+ xFilial("SE1") + "'" 
cQry += " AND "
cQry += " SE1.D_E_L_E_T_ =  ' ' "
cQry += " AND "
cQry += " E1_TIPO NOT IN ('NCC','RA','RAN','NDC','NF') "
cQry += " AND "
cQry += " E1_EMISSAO BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "'  "
cQry += " AND "
cQry += " E1_MSFIL BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "'  "
cQry += " GROUP BY E1_MSFIL,"
cQry += "          E1_NUM,"
cQry += "          E1_TIPO,"
//cQry += "          E5_HISTOR,"
cQry += "          E1_EMISSAO,"
cQry += "          E1_CLIENTE,"
cQry += "          E1_LOJA,"
cQry += "          A1_NOME,"
//cQry += "		   E5_VALOR,"
cQry += "          E1_NSUTEF,"
cQry += "          E1_01QPARC,"
cQry += "          E1_XNCART4,"
cQry += "          E1_XDESCFI,"
cQry += "          E1_XDSCADM,"
cQry += "          E1_CPFCNPJ,"
cQry += "          E1_HIST,"
cQry += "          C5_DESPESA,"
cQry += "          C5_FRETE"

If MV_PAR05 == 2
	cQry += " ORDER BY E1_MSFIL,E1_HIST, E1_NUM, E1_TIPO"
ElseIf MV_PAR05 == 3
	cQry += " ORDER BY E1_MSFIL,A1_NOME, E1_NUM, E1_TIPO"	
Else
	cQry += " ORDER BY E1_MSFIL, E1_NUM, E1_TIPO"
EndIF
	
If Select("T_R_C") > 0
	T_R_C->(DbCloseArea())
EndIf
	
cQry := ChangeQuery(cQry)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQry),"T_R_C",.F.,.T.)
	
dbSelectArea("T_R_C")
T_R_C->(dbGoTop())
	
oReport:SetMeter(T_R_C->(LastRec()))	
	
While T_R_C->(!EOF())
		
	oReport:IncMeter()
		
	If oReport:Cancel()
		Exit
	EndIf
		
	
	IncProc("Imprimindo Loja ")
	
	oSecCab:Init()
		
	//imprimo a PRIMEIRA seção			
	
	oSecCab:Cell("E1_NUM"):SetValue(T_R_C->E1_NUM)
//	oSecCab:Cell("E1_PARCELA"):SetValue(T_R_C->E1_01QPARC)
	oSecCab:Cell("E1_TIPO"):SetValue(T_R_C->E1_TIPO)
//	oSecCab:Cell("E1_PEDIDO"):SetValue(Substr(Alltrim(T_R_C->E5_HISTOR),4))
	oSecCab:Cell("E1_EMISSAO"):SetValue(STOD(T_R_C->E1_EMISSAO))
	oSecCab:Cell("E1_CLIENTE"):SetValue(T_R_C->E1_CLIENTE)
	oSecCab:Cell("E1_LOJA"):SetValue(T_R_C->E1_LOJA)
	oSecCab:Cell("A1_NOME"):SetValue(T_R_C->A1_NOME)
//	oSecCab:Cell("E1_VALOR"):SetValue(T_R_C->E1_VALOR)
//	oSecCab:Cell("E1_VALOR"):SetValue(IIF(!EMPTY(T_R_C->E5_HISTOR),T_R_C->E5_VALOR,T_R_C->E1_VALOR))
	oSecCab:Cell("E1_VALOR"):SetValue(fRetTotal( T_R_C->E1_NUM, T_R_C->E1_TIPO, T_R_C->E1_EMISSAO, T_R_C->E1_MSFIL, T_R_C->E1_01QPARC, T_R_C->E1_NSUTEF ))
	oSecCab:Cell("E1_NSUTEF"):SetValue(T_R_C->E1_NSUTEF)
	oSecCab:Cell("E1_01QPARC"):SetValue(T_R_C->E1_01QPARC)
	oSecCab:Cell("E1_XNCART4"):SetValue(T_R_C->E1_XNCART4)
	oSecCab:Cell("E1_MSFIL"):SetValue(T_R_C->E1_MSFIL)
	oSecCab:Cell("E1_XDESCFI"):SetValue(T_R_C->E1_XDESCFI)
	oSecCab:Cell("E1_XDSCADM"):SetValue(T_R_C->E1_XDSCADM)
	oSecCab:Cell("E1_CPFCNPJ"):SetValue(T_R_C->E1_CPFCNPJ)
	oSecCab:Cell("E1_HIST"):SetValue(T_R_C->E1_HIST)
	oSecCab:Cell("C5_DESPESA"):SetValue(T_R_C->C5_DESPESA)
	oSecCab:Cell("C5_FRETE"):SetValue(T_R_C->C5_FRETE)
	
	oSecCab:Printline()	
						
	T_R_C->(DbSkip())
EndDo	

oReport:SetTotalInLine(.F.)	 		
		
//imprimo uma linha para separar uma NCM de outra
oReport:ThinLine()
	 		
//finalizo a primeira seção
oSecCab:Finish()
			

Return Nil


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³  VldSX1  º Autor ³ LUIZ EDUARDO F.C.  º Data ³  05/01/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ VALIDACAO DE PERGUNTAS DO SX1                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function VldSX1(aRegs)

Local _i
Local aAreaBKP := GetArea()

dbSelectArea("SX1")

SX1->(dbSetOrder(1))

For _i := 1 To Len(aRegs)
	If  !DbSeek(aRegs[_i,1]+aRegs[_i,2])
		RecLock("SX1",.T.)
			Replace X1_GRUPO   with aRegs[_i,01]
			Replace X1_ORDEM   with aRegs[_i,02]
			Replace X1_PERGUNT with aRegs[_i,03]
			Replace X1_VARIAVL with aRegs[_i,04]
			Replace X1_TIPO    with aRegs[_i,05]
			Replace X1_TAMANHO with aRegs[_i,06]
			Replace X1_PRESEL  with aRegs[_i,07]
			Replace X1_GSC     with aRegs[_i,08]
			Replace X1_VAR01   with aRegs[_i,09]
			Replace X1_F3      with aRegs[_i,10]
			Replace X1_DEF01   with aRegs[_i,11]
			Replace X1_DEF02   with aRegs[_i,12]
			Replace X1_DEF03   with aRegs[_i,13]
			Replace X1_DEF04   with aRegs[_i,14]
			Replace X1_DEF05   with aRegs[_i,15]
		MsUnlock()
	EndIf
Next i

RestArea(aAreaBKP)

Return(Nil)


Static Function fRetTotal( cTitulo, cTipo, cEmissao, cMsfil, nParcela, cNumTef)

	Local nTotal := 0
	Local cQuery := ""
	Local cAlias := getNextAlias()

	cQuery := "SELECT SUM(E1_VALOR) AS E1_VALOR "
	cQuery += "FROM SE1010 "
	cQuery += "WHERE E1_NUM = '"+ cTitulo +"' "
	cQuery += "AND E1_TIPO = '"+ cTipo +"' "
	cQuery += "AND E1_EMISSAO = '"+ cEmissao +"' "
	cQuery += "AND E1_MSFIL = '"+ cMsfil +"' "
	cQuery += "AND E1_NSUTEF = '"+ cNumTef +"'"
	cQuery += "AND E1_01QPARC = '"+ cvaltochar(nParcela) +"' "
	cQuery += "AND D_E_L_E_T_ = ' '"

	PLSQuery(cQuery, cAlias)

	if (cAlias)->(!eof())
		nTotal := (cAlias)->E1_VALOR
	endif

	(cAlias)->(dbCloseArea())

return nTotal