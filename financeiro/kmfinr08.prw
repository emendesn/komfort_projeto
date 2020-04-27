#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ KMFINR08  º Autor ³ AP6 IDE           º Data ³  05/12/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório de C.Receber por Operadora                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Komfort House                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function KMFINR08()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Declaracao de variaveis                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cPerg 	:= PadR("KMFINR08", Len(SX1->X1_GRUPO))
Local aPergunta	:= {}
Private oReport	:= Nil
Private oSecEmp	:= Nil
Private oSecCab	:= Nil
Private oSecIte	:= Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao e apresentacao das perguntas      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aPergunta,{cPerg,"01","Loja de  ?" 	,"MV_CH1" ,"C",04,00,"G","MV_PAR01","SM0","","","","",""})
Aadd(aPergunta,{cPerg,"02","Loja até ?" 	,"MV_CH2" ,"C",04,00,"G","MV_PAR02","SM0","","","","",""})
Aadd(aPergunta,{cPerg,"03","Emissão de ?"	,"MV_CH3" ,"D",08,00,"G","MV_PAR03",""   ,"","","","",""})
Aadd(aPergunta,{cPerg,"04","Emissão até?" 	,"MV_CH4" ,"D",08,00,"G","MV_PAR04",""   ,"","","","",""})
Aadd(aPergunta,{cPerg,"05","Venc. de ?"		,"MV_CH5" ,"D",08,00,"G","MV_PAR05",""   ,"","","","",""})
Aadd(aPergunta,{cPerg,"06","Venc. até?" 	,"MV_CH6" ,"D",08,00,"G","MV_PAR06",""   ,"","","","",""})
Aadd(aPergunta,{cPerg,"07","Oper. de ?" 	,"MV_CH7" ,"C",03,00,"G","MV_PAR07","SAE","","","","",""})
Aadd(aPergunta,{cPerg,"08","Oper.até ?" 	,"MV_CH8" ,"C",03,00,"G","MV_PAR08","SAE","","","","",""})
Aadd(aPergunta,{cPerg,"09","Ordenar por ?"	,"MV_CH9" ,"N",01,00,"C","MV_PAR09","" 	 ,"Titulo","Vencto","Cliente","",""})

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

Local cPerg 	:= PadR("KMFINR08", Len(SX1->X1_GRUPO))

oReport := TReport():New(cPerg,"Relatório de C.Receber por Operadora",cPerg,{|oReport| PrintReport(oReport)},"Impressão dos Títulos.")
oReport:SetLandscape()

oSecEmp := TRSection():New( oReport , "Loja", {"SM0"} )
TRCell():New( oSecEmp, "Filial"    , "SM0")
TRCell():New( oSecEmp, "Descrição" 	, "SM0")

oSecCab := TRSection():New( oReport , "Operadora", {"SAE"} )
TRCell():New( oSecCab, "AE_COD"     , "SAE")
TRCell():New( oSecCab, "AE_DESC"	, "SAE")
TRCell():New( oSecCab, "AE_TIPO" 	, "SAE")
TRCell():New( oSecCab, "AE_01NAT" 	, "SAE")

oSecIte := TRSection():New( oReport , "Titulos", {"QRY"} )
TRCell():New( oSecIte, "E1_NUM"     , "QRY")
TRCell():New( oSecIte, "E1_PREFIXO"	, "QRY")
TRCell():New( oSecIte, "E1_PARCELA"	, "QRY")
TRCell():New( oSecIte, "E1_XPARNSU"	, "QRY")
TRCell():New( oSecIte, "E1_01QPARC" , "QRY")
TRCell():New( oSecIte, "E1_DOCTEF" 	, "QRY")
TRCell():New( oSecIte, "E1_EMISSAO"	, "QRY")
TRCell():New( oSecIte, "E1_VENCREA"	, "QRY")
TRCell():New( oSecIte, "E1_VALOR"	, "QRY")
TRCell():New( oSecIte, "E1_01TAXA"	, "QRY")
TRCell():New( oSecIte, "Vlr.Liquid"	, "QRY")
TRCell():New( oSecIte, "E1_PEDIDO" 	, "QRY")
TRCell():New( oSecIte, "E1_NOMCLI" 	, "QRY")

TRFunction():New(oSecIte:Cell("E1_VALOR"),NIL,"SUM",,,,,.F.,.T.)	
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
Static Function PrintReport(oReport)

Local cQry		:= ""
Local cLoja		:= ""
Local cDescFi	:= ""
Local cOper		:= ""
Local cPerg		:= PadR("KMFINR08", Len(SX1->X1_GRUPO))

Pergunte(cPerg,.F.)

cQry := " SELECT ISNULL(E1_VALOR - E2_VALOR,E1_VALOR) AS E1_XVALLIQ,* FROM " + RETSQLNAME("SE1") + " (NOLOCK) SE1"
cQry += " LEFT JOIN " + RETSQLNAME("SAE") + " SAE "
cQry += " ON AE_FILIAL = '" + XFILIAL("SAE") + "' "
cQry += " AND AE_COD = E1_01OPER "
cQry += " AND SAE.D_E_L_E_T_ <> '*' "

cQry += " LEFT JOIN " + RETSQLNAME("SE2") + " (NOLOCK) SE2 ON E2_MSFIL = E1_MSFIL "
cQry += " AND E2_NUM = E1_NUM	"
cQry += " AND E2_PARCELA = E1_PARCELA "
cQry += " AND E2_TIPO = E1_TIPO "
cQry += " AND E2_PREFIXO = 'TXA' "
cQry += " AND SE2.D_E_L_E_T_ <> '*' "

cQry += " WHERE  E1_FILIAL = '" + XFILIAL("SE1") + "' "
cQry += " AND SE1.D_E_L_E_T_ = ' ' "
cQry += " AND E1_EMISSAO BETWEEN '" + DtoS(MV_PAR03) + "' AND '" + DtoS(MV_PAR04) + "'  "
cQry += " AND E1_VENCREA BETWEEN '" + DtoS(MV_PAR05) + "' AND '" + DtoS(MV_PAR06) + "'  "
cQry += " AND E1_01OPER BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "'  "
cQry += " AND E1_MSFIL BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "'  "
If MV_PAR09 == 1
	cQry += " ORDER BY E1_MSFIL, E1_01OPER, E1_NOMCLI,E1_PREFIXO, E1_NUM, E1_PARCELA,E1_XPARNSU, E1_TIPO"
ElseIf MV_PAR09 == 2
	cQry += " ORDER BY E1_MSFIL, E1_01OPER, E1_VENCREA,E1_PREFIXO, E1_NUM, E1_PARCELA,E1_XPARNSU, E1_TIPO"
Else
	cQry += " ORDER BY E1_MSFIL, E1_01OPER, E1_PREFIXO, E1_NUM, E1_PARCELA,E1_XPARNSU, E1_TIPO"
EndIf

cQry := ChangeQuery(cQry)

If Select("QRY") > 0
	Dbselectarea("QRY")
	QRY->(DbClosearea())
EndIf

TcQuery cQry New Alias "QRY"

dbSelectArea("QRY")
QRY->(dbGoTop())
	
oReport:SetMeter(QRY->(LastRec()))	

While !Eof()
		
	If oReport:Cancel()
		Exit
	EndIf
	  
	//inicializo a PRIMEIRA seção
	oSecEmp:Init()
	
	cLoja 	:= QRY->E1_MSFIL
	cDescFi	:= FWFilialName(cEmpAnt,cLoja,1)
	IncProc("Imprimindo Loja " + cDescFi)
	
	While QRY->E1_MSFIL == cLoja
		//imprimo a PRIMEIRA seção				
		oSecEmp:Cell("Filial"):SetValue(QRY->E1_MSFIL)
		oSecEmp:Cell("Descrição"):SetValue(cDescFi)				
		oSecEmp:Printline()
		
		//inicializo a SEGUNDA seção
		oSecCab:init()
		
		cOper := QRY->E1_01OPER
		
		//imprimo a SEGUNDA seção				
		oSecCab:Cell("AE_COD"):SetValue(QRY->E1_01OPER)
		oSecCab:Cell("AE_DESC"):SetValue(QRY->AE_DESC)
		oSecCab:Cell("AE_TIPO"):SetValue(QRY->AE_TIPO)
		oSecCab:Cell("AE_01NAT"):SetValue(QRY->AE_01NAT)				
		oSecCab:Printline()
		
		//inicializo a TERCEIRA seção
		oSecIte:init()
		
		While QRY->E1_MSFIL == cLoja .AND. QRY->E1_01OPER == cOper
			
			oReport:IncMeter()		
			
			oSecIte:Cell("E1_NUM"):SetValue(QRY->E1_NUM)
			oSecIte:Cell("E1_PREFIXO"):SetValue(QRY->E1_PREFIXO)
			oSecIte:Cell("E1_PARCELA"):SetValue(QRY->E1_PARCELA)
			oSecIte:Cell("E1_XPARNSU"):SetValue(QRY->E1_XPARNSU)
			oSecIte:Cell("E1_01QPARC"):SetValue(QRY->E1_01QPARC)			
			oSecIte:Cell("E1_DOCTEF"):SetValue(QRY->E1_DOCTEF)
			oSecIte:Cell("E1_EMISSAO"):SetValue(StoD(QRY->E1_EMISSAO))
			oSecIte:Cell("E1_VENCREA"):SetValue(StoD(QRY->E1_VENCREA))
			oSecIte:Cell("E1_VALOR"):SetValue(QRY->E1_VALOR)
			oSecIte:Cell("E1_01TAXA"):SetValue(QRY->E1_01TAXA)
			oSecIte:Cell("Vlr.Liquid"):SetValue(QRY->E1_XVALLIQ)
			oSecIte:Cell("E1_PEDIDO"):SetValue(QRY->E1_PEDIDO)
			oSecIte:Cell("E1_NOMCLI"):SetValue(QRY->E1_NOMCLI)
						
			oSecIte:Printline()
		
	 		QRY->(dbSkip())
	 	EndDo
		 //finalizo a segunda seção para que seja reiniciada para o proximo registro
		oSecIte:Finish()
	 		
		//finalizo a segunda seção para que seja reiniciada para o proximo registro
		oSecCab:Finish()
		oReport:SetTotalInLine(.F.)	 		
		
		//imprimo uma linha para separar uma NCM de outra
		oReport:ThinLine()
	 		
		//finalizo a primeira seção
		oSecEmp:Finish()
	EndDo
Enddo


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