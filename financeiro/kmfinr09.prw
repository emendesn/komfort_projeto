#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ KMFINR09  º Autor ³ AP6 IDE           º Data ³  05/12/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rel. Resumo por Tipo de Pagamento/Recebimento              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Komfort House                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function KMFINR09()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Declaracao de variaveis                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cPerg 	:= PadR("KMFINR09", Len(SX1->X1_GRUPO))
Local aPergunta	:= {}
Private oReport	:= Nil
Private oSecCab	:= Nil
Private oSecIte	:= Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao e apresentacao das perguntas      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aPergunta,{cPerg,"01","Loja de  ?" 				,"MV_CH1" ,"C",04,00,"G","MV_PAR01","SM0"      ,"","","","",""})
Aadd(aPergunta,{cPerg,"02","Loja até ?" 				,"MV_CH2" ,"C",04,00,"G","MV_PAR02","SM0"      ,"","","","",""})
Aadd(aPergunta,{cPerg,"03","Emissão de ?"			    ,"MV_CH3" ,"D",08,00,"G","MV_PAR03",""         ,"","","","",""})
Aadd(aPergunta,{cPerg,"04","Emissão até?" 			    ,"MV_CH4" ,"D",08,00,"G","MV_PAR04",""         ,"","","","",""})
Aadd(aPergunta,{cPerg,"05","Venc. de ?"			    	,"MV_CH5" ,"D",08,00,"G","MV_PAR05",""         ,"","","","",""})
Aadd(aPergunta,{cPerg,"06","Venc. até?" 			    ,"MV_CH6" ,"D",08,00,"G","MV_PAR06",""         ,"","","","",""})
Aadd(aPergunta,{cPerg,"07","Oper. de ?" 				,"MV_CH7" ,"C",03,00,"G","MV_PAR07","SAE"      ,"","","","",""})
Aadd(aPergunta,{cPerg,"08","Oper.até ?" 				,"MV_CH8" ,"C",03,00,"G","MV_PAR08","SAE"      ,"","","","",""})

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

Local cPerg 	:= PadR("KMFINR09", Len(SX1->X1_GRUPO))
Local cTexto	:= "Emissão entre " + DtoC(MV_PAR03) + " e " + DtoC(MV_PAR04) + "."

oReport := TReport():New(cPerg,"Rel. Resumo por Tipo de Pagamento/Recebimento",cPerg,{|oReport| PrintReport(oReport)},"Impressão dos Títulos.")
//oReport:SetLandscape()

oSecCab := TRSection():New( oReport , "Período")
TRCell():New(oSecCab,cTexto,,"",,Len(cTexto),,{|| cTexto})

oSecIte := TRSection():New( oReport , "Titulos", {"QRY"} )
TRCell():New( oSecIte, "E1_XDSCADM" , "QRY")
TRCell():New( oSecIte, "E1_TIPO" 	, "QRY")
TRCell():New( oSecIte, "E1_VALOR"	, "QRY")

TRFunction():New(oSecIte:Cell("E1_VALOR"),"","SUM",,,,,.F.,.T.)	
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
Local cPerg		:= PadR("KMFINR09", Len(SX1->X1_GRUPO))
Local cTiposEx	:= SuperGetMv("KH_KMFINR9",.F.,"NCC|NDC|RA|RAN|NF")	//#RVC20181206.n 

Pergunte(cPerg,.F.)

cQry := " SELECT DISTINCT(E1_XDSCADM), E1_TIPO, SUM(E1_VALOR) AS E1_VALOR FROM " + RETSQLNAME("SE1") + " (NOLOCK) SE1"
cQry += " WHERE  E1_FILIAL = '" + XFILIAL("SE1") + "' "
cQry += " AND SE1.D_E_L_E_T_ = ' ' "
cQry += " AND E1_EMISSAO BETWEEN '" + DtoS(MV_PAR03) + "' AND '" + DtoS(MV_PAR04) + "'  "
cQry += " AND E1_VENCREA BETWEEN '" + DtoS(MV_PAR05) + "' AND '" + DtoS(MV_PAR06) + "'  "
cQry += " AND E1_01OPER BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "'  "
cQry += " AND E1_MSFIL BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "'  "
cQry += " AND E1_TIPO NOT IN " + FormatIn(cTiposEx,'|')										//#RVC20181206.n
cQry += " GROUP BY E1_XDSCADM, E1_TIPO "
cQry += " ORDER BY E1_XDSCADM "

cQry := ChangeQuery(cQry)

If Select("QRY") > 0
	Dbselectarea("QRY")
	QRY->(DbClosearea())
EndIf

TcQuery cQry New Alias "QRY"

dbSelectArea("QRY")
QRY->(dbGoTop())
	
oReport:SetMeter(QRY->(LastRec()))	

//inicializo a PRIMEIRA seção
oSecCab:init()

//oSecCab:Cell(cTexto):SetValue(cTexto)
oSecCab:Printline()

//inicializo a SEGUNDA seção
oSecIte:init()

While !Eof()
	
	If oReport:Cancel()
		Exit
	EndIf
	  
	oReport:IncMeter()		
	
//#RVC20181206.bo
//	oSecIte:Cell("E1_XDSCADM"):SetValue(QRY->E1_XDSCADM)
//	oSecIte:Cell("E1_VALOR"):SetValue(QRY->E1_VALOR)
//#RVC20181206.eo

//#RVC20181206.bn 	
	If !Empty(QRY->E1_XDSCADM)
		oSecIte:Cell("E1_XDSCADM"):SetValue(QRY->E1_XDSCADM)
		oSecIte:Cell("E1_TIPO"):SetValue(QRY->E1_TIPO)
		oSecIte:Cell("E1_VALOR"):SetValue(QRY->E1_VALOR)
	Else
		oSecIte:Cell("E1_XDSCADM"):SetValue(QRY->E1_TIPO)
		oSecIte:Cell("E1_TIPO"):SetValue(QRY->E1_TIPO)
		oSecIte:Cell("E1_VALOR"):SetValue(QRY->E1_VALOR)
	EndIf			
//#RVC20181206.en	
	oSecIte:Printline()
		
	QRY->(dbSkip())

EndDo

//finalizo a SEGUNDA seção
oSecIte:Finish()

//imprimo uma linha para separar uma NCM de outra
oReport:ThinLine()

//finalizo a PRIMEIRA seção
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