#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "BINR001.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BINR001  บAutor  ณ Wilson A. Silva Jr.บ Data ณ  16/01/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio DRE - Demonstrativo do Resultado do Exercicio.   บฑฑ
ฑฑบ          ณ IMPORTANTE ATUALIZAR PACTH tttp101_ExcelXML.ptm (Symm)     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Template Function BINR001()

	Local cPerg 	:= PADR("BINR001",10,"A")
	Local cDir   	:= "C:\"
	Local cArquivo  := "relatorio"
	Local cTitulo   := STR0001//"Relat๓rio DRE"
	Local cNome		:= STR0002+DtoS(dDataBase)+"-"+STRTRAN(TIME(),":","")//"RelatorioDRE-"
	Local cDesc    	:= STR0003//"Esta rotina tem como objetivo criar um arquivo no formato XLS contendo Relatorio DRE."
	Local cExt		:= "XLS"
	Local nOpc   	:= 1 // 1 = gerar arquivo e abrir / 2 = somente gerar aquivo em disco
	Local cMsgProc  := STR0004//"Aguarde. Gerando relat๓rio..." 
	
	Private cDBMS 	:= AllTrim(Upper(TCGETDB()))

    AjustaSX1(cPerg)	
		
	T_XMLPerg(	cPerg,;
	cDir,;
	{|lEnd, cArquivo| GeraExl(cArquivo)},;
	cTitulo,;
	cNome,;
	cDesc,;
	cExt,;
	nOpc,;
	cMsgProc )

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GeraExl  บAutor  ณ Wilson A. Silva Jr.บ Data ณ  26/04/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria Arquivo XLS (Excel) Com base nos dados enviados por   บฑฑ
ฑฑบ          ณ Parametro.                                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GeraExl(cArquivo)

	Local oXML
	
	//FILTROS
	Private cAnoExec 	:= StrZero(MV_PAR01,4)
	Private cFiliais	:= IIF( MV_PAR02 == 1 ,T_SYBrwOpc("Selecao de Filiais","SM0","M0_CODFIL","M0_FILIAL",Len(cFilAnt)),"")
	Private nTipoRel 	:= MV_PAR03
	
	Private nFolder		:= 1 			//pasta onde o relatorio sera gerado
	
	oXML := ExcelXML():New()  	
 	
	LjMsgRun("Aguarde, Gerando Relat๓rio DRE...",,{|| oXML := T_GeraDRE(oXML)}) // "Aguarde, Gerando Relat๓rio DRE..."
	
	LjMsgRun(STR0007,, {|| oXML	:= GrFiltro(oXML) })//"Aguarde, Gerando Aba Indica็๕es de Filtros..."
	
	If oXML <> NIL
		Return oXML:GetXML(cArquivo)
	EndIf
		
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GrFiltro บAutor  ณ Wilson A. Silva Jr.บ Data ณ  26/04/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria aba descrevendo filtros no relatorio.                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GrFiltro(oXml)
	Local oStlTitFil
	Local oStlTitPar
	Local oStlPar   
	Local aStl 
	
	oXml:setFolder(nFolder)
	nFolder++
	oXml:setFolderName("Parametros")
	oXml:showGridLine(.F.)
	                     
	oStlTitFil := CellStyle():New("StlTitFil")
	oStlTitFil:setFont("Calibri", 10, "#003366", .T., .F., .F., .F.)
	oStlTitFil:setBorder("TOP", , 3, .T.)
	oStlTitFil:setBorder("BOTTOM", , 2, .T.)
	oStlTitFil:setBorder("LEFT", , 3, .T.)	
	oStlTitFil:setBorder("RIGHT", , 3, .T.)		
	
	oStlTitPar := CellStyle():New("StlTitPar")
	oStlTitPar:setFont("Calibri", 10, "#003366", .T., .F., .F., .F.)
	oStlTitPar:setBorder("BOTTOM", , 1, .T.)
	oStlTitPar:setBorder("LEFT", , 3, .T.)
	oStlTitPar:setHAlign("LEFT")	
	
	oStlPar := CellStyle():New("StlPar")
	oStlPar:setFont("Calibri", 10, "#003366", .F., .F., .F., .F.)
	oStlPar:setBorder("BOTTOM", , 1, .T.)
	oStlPar:setBorder("LEFT", , 2, .T.)	
	oStlPar:setBorder("RIGHT", , 3, .T.)  
	oStlPar:setHAlign("LEFT")		

	aStl := {oStlTitPar, oStlPar}	
	oXml:AddRow(, {STR0009}, oStlTitFil ) //"PARAMETROS DE PESQUISA"
	
	oXml:setMerge(, , , 1) 
	
	oXml:setColSize({"100", "100"})
	
	oXml:AddRow(, {"Ano Exercํcio: "	, cAnoExec	}, aStl)
	oXml:AddRow(, {"Filiais: " 			, cFiliais	}, aStl)
	oXml:AddRow(, {"Tipo Relat๓rio: " 	, IIF(nTipoRel == 1, "Por Emissใo", "Por Vencimento")}, aStl)
		 
	oXml:SkipLine(1)	
		
Return oXml

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GeraDRE	บAutor  ณ Wilson A. Silva Jr.บ Data ณ  26/04/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria Aba com o Relatorio DRE.					  		  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Template Function GeraDRE(oXml)

	Local aDados 	:= {}
	Local nI
	Local nX
	
	//variaveis de controle 
	Local lZebra := .T.
	Local lFolha := .F.
	Local nItens := 0
	Local lMargCo:= .T.
	
	//variaveis auxiliares
	Local aColSize	:= {} 
	Local aRowDad	:= {} 
	Local aCabDad1	:= {}
	Local aStatDad	:= {}
	Local aCabDad2	:= {}
	Local aTotAcum	:= {}
	Local aStl		:= {}
	Local aCabStl1	:= {}
	Local aStlStat  := {}
	Local aCabStl2	:= {}
	Local aAcumStl	:= {}
	Local cAuxVar	:= ""
	Local nNumMarg	:= 0
	Local nDespFix	:= 0
	Local nRBruta	:= 0
	
	//variaveis de estilo 
	Private oStlTit
	Private oStlCab
	Private oSN01Txt
	Private oSN01Por
	Private oSN01Num
	Private oSN02Txt
	Private oSN02Por
	Private oSN02Num
	Private oSN03Txt
	Private oSN03Por
	Private oSN03Num
	
	Private oSSkipLine := nil
	
	/*Style Titulo*/
	oStlTit := CellStyle():New("DRE_StlTit")
	oStlTit:setFont("Calibri", 28 ,"#003366", .T., .F., .F., .F.)
	oStlTit:setInterior("#FFC000")
	oStlTit:setBorder("TOP", , 1, .T.)
	oStlTit:setBorder("LEFT", , 1, .T.) 
	oStlTit:setBorder("RIGHT", , 1, .T.)
	oStlTit:setBorder("BOTTOM", , 1, .T.) 
	oStlTit:setHAlign("CENTER")  
	
	oStlCab := CellStyle():New("DRE_StlCab")
	oStlCab:setFont("Calibri", 11, "#FFFFFF", .T., .F., .F., .F.)
	oStlCab:setInterior("#538ED5")
	oStlCab:setBorder("TOP", , 1, .T.)
	oStlCab:setBorder("LEFT", , 1, .T.) 
	oStlCab:setBorder("RIGHT", , 1, .T.)
	oStlCab:setBorder("BOTTOM", , 1, .T.)  
	oStlCab:setHAlign("CENTER")	
	
	oSN00Txt:= CellStyle():New("DRE_N00Txt")
	oSN00Txt:setFont("Calibri", 11, "#003366", .T., .F., .F., .F.)
	oSN00Txt:setInterior("#FFFF00")
	oSN00Txt:setBorder("TOP", , 1, .T.)
	oSN00Txt:setBorder("LEFT", , 1, .T.)
	oSN00Txt:setBorder("RIGHT", , 1, .T.)
	oSN00Txt:setBorder("BOTTOM", , 1, .T.)	
	oSN00Txt:setHAlign("LEFT")
	
	oSN00Num:= CellStyle():New("DRE_N00Num")
	oSN00Num:setFont("Calibri", 11, "#003366", .T., .F., .F., .F.)
	oSN00Num:setInterior("#FFFF00")
	oSN00Num:setBorder("TOP", , 1, .T.)
	oSN00Num:setBorder("LEFT", , 1, .T.)
	oSN00Num:setBorder("RIGHT", , 1, .T.)
	oSN00Num:setBorder("BOTTOM", , 1, .T.)	
	oSN00Num:setHAlign("RIGHT")
	oSN00Num:setNumberFormat("_(* #,##0.00_);_(* \(#,##0.00\);_(* &quot;-&quot;??_);_(@_)")
	
	oSN01Txt:= CellStyle():New("DRE_N01Txt")
	oSN01Txt:setFont("Calibri", 11, "#003366", .T., .F., .F., .F.)
	oSN01Txt:setInterior("#D8D8D8")
	oSN01Txt:setBorder("TOP", , 0, .T.)
	oSN01Txt:setBorder("LEFT", , 1, .T.)
	oSN01Txt:setBorder("RIGHT", , 1, .T.)
	oSN01Txt:setBorder("BOTTOM", , 0, .T.)	
	oSN01Txt:setHAlign("LEFT")
	
	oSN01Num:= CellStyle():New("DRE_N01Num")
	oSN01Num:setFont("Calibri", 11, "#003366", .T., .F., .F., .F.)
	oSN01Num:setInterior("#D8D8D8")
	oSN01Num:setBorder("TOP", , 0, .T.)
	oSN01Num:setBorder("LEFT", , 1, .T.)
	oSN01Num:setBorder("RIGHT", , 1, .T.)
	oSN01Num:setBorder("BOTTOM", , 0, .T.)	
	oSN01Num:setHAlign("RIGHT")
	oSN01Num:setNumberFormat("_(* #,##0.00_);_(* \(#,##0.00\);_(* &quot;-&quot;??_);_(@_)")
   
	oSN02Txt:= CellStyle():New("DRE_N02Txt")
	oSN02Txt:setFont("Calibri", 11, "#003366", .T., .F., .F., .F.)
	oSN02Txt:setInterior("#FFFFFF")
	oSN02Txt:setBorder("TOP", , 0, .T.)
	oSN02Txt:setBorder("LEFT", , 1, .T.)
	oSN02Txt:setBorder("RIGHT", , 1, .T.)
	oSN02Txt:setBorder("BOTTOM", , 0, .T.)	
	oSN02Txt:setHAlign("LEFT")
	
	oSN02Num:= CellStyle():New("DRE_N02Num")
	oSN02Num:setFont("Calibri", 11, "#003366", .T., .F., .F., .F.)
	oSN02Num:setInterior("#FFFFFF")
	oSN02Num:setBorder("TOP", , 0, .T.)
	oSN02Num:setBorder("LEFT", , 1, .T.)
	oSN02Num:setBorder("RIGHT", , 1, .T.)
	oSN02Num:setBorder("BOTTOM", , 0, .T.)	
	oSN02Num:setHAlign("RIGHT")
	oSN02Num:setNumberFormat("_(* #,##0.00_);_(* \(#,##0.00\);_(* &quot;-&quot;??_);_(@_)")
	
	oSub01Txt:= CellStyle():New("DRE_Sub01Txt")
	oSub01Txt:setFont("Calibri", 11, "#003366", .T., .F., .F., .F.)
	oSub01Txt:setInterior("#FFC000")
	oSub01Txt:setBorder("TOP", , 1, .T.)
	oSub01Txt:setBorder("LEFT", , 1, .T.)
	oSub01Txt:setBorder("RIGHT", , 1, .T.)
	oSub01Txt:setBorder("BOTTOM", , 1, .T.)	
	oSub01Txt:setHAlign("LEFT")
		
	oSub01Num:= CellStyle():New("DRE_Sub01Num")
	oSub01Num:setFont("Calibri", 11, "#003366", .T., .F., .F., .F.)
	oSub01Num:setInterior("#FFC000")
	oSub01Num:setBorder("TOP", , 1, .T.)
	oSub01Num:setBorder("LEFT", , 1, .T.)
	oSub01Num:setBorder("RIGHT", , 1, .T.)
	oSub01Num:setBorder("BOTTOM", , 1, .T.)	
	oSub01Num:setHAlign("RIGHT")
	oSub01Num:setNumberFormat("_(* #,##0.00_);_(* \(#,##0.00\);_(* &quot;-&quot;??_);_(@_)") 

	oPE01Txt:= CellStyle():New("DRE_PE01Txt")
	oPE01Txt:setFont("Calibri", 11, "#003366", .T., .F., .F., .F.)
	oPE01Txt:setInterior("#FF3300")
	oPE01Txt:setBorder("TOP", , 1, .T.)
	oPE01Txt:setBorder("LEFT", , 1, .T.)
	oPE01Txt:setBorder("RIGHT", , 1, .T.)
	oPE01Txt:setBorder("BOTTOM", , 1, .T.)	
	oPE01Txt:setHAlign("LEFT")
		
	oPE01Num:= CellStyle():New("DRE_PE01Num")
	oPE01Num:setFont("Calibri", 11, "#003366", .T., .F., .F., .F.)
	oPE01Num:setInterior("#FF3300")
	oPE01Num:setBorder("TOP", , 1, .T.)
	oPE01Num:setBorder("LEFT", , 1, .T.)
	oPE01Num:setBorder("RIGHT", , 1, .T.)
	oPE01Num:setBorder("BOTTOM", , 1, .T.)	
	oPE01Num:setHAlign("RIGHT")
	oPE01Num:setNumberFormat("_(* #,##0.00_);_(* \(#,##0.00\);_(* &quot;-&quot;??_);_(@_)") 

	T_GrDadDRE(aDados)
	
	oXml:setFolder(nFolder)
	nFolder++
	oXml:setFolderName("DRE")
	oXml:showGridLine(.F.)
	oXml:SetZoom(80)
	
	aAdd( aColSize, "70" )		// COD
	aAdd( aColSize, "243.33" )	// DESCRICAO
		
	aCabDad2 := {}
	aAdd( aCabDad2, STR0015 ) 		// COD//"CำDIGO"
	aAdd( aCabDad2, STR0016 ) 	// DESCRICAO//"DESCRIวรO DO LANวAMENTO"
	
	aCabStl2 := {}
	aAdd( aCabStl2, oStlCab ) 	// COD
	aAdd( aCabStl2, oStlCab ) 	// DESCRICAO
	
	For nX:=1 To 12

		aAdd( aColSize, "80" )
		
		aAdd( aCabDad2, MesExt(nX) )
		aAdd( aCabStl2, oStlCab )
		
		If nX==6 .OR. nX==12
			aAdd( aColSize, "130" )
			aAdd( aCabDad2, STR0017 + " " + StrZero(nX/6,1) + STR0018)//"SUB-TOTAL "//"บ SEMESTRE"
			aAdd( aCabStl2, oStlCab )
		EndIf
	Next nX
	 
	aAdd( aColSize, "100" ) // Coluna do Total		
	aAdd( aCabDad2, STR0019 )//"TOTAL ANUAL"
	aAdd( aCabStl2, oStlCab )   

	oXML:AddRow(, aCabDad2, aCabStl2)
	oXML:SkipLine("2.25",oSSkipLine)
			
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Ajusta o tamanho das colunas da planilha. ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oXML:SetColSize(aColSize)
 	
 	TMP->(dbGoTop())
	While TMP->(!EOF())
	
	    lFolha := (TMP->NFILHOS==0)
	    If Len(AllTrim(TMP->ED_CODIGO))==1
			cAuxVar := '00'
		Else
			//cAuxVar := StrZero(VAL(SUBSTR(TMP->ED_CODIGO,1,1)),2)
			If lZebra
				lZebra  := .F.
				cAuxVar := '01'
			Else
				lZebra  := .T.
				cAuxVar := '02'
			EndIf
		EndIf
	    
		aRowDad := {}
		aAdd( aRowDad, TMP->ED_CODIGO ) 	// COD
		aAdd( aRowDad, Space(Len(AllTrim(TMP->ED_CODIGO))*2)+IIF(TMP->ED_COND=='R','(+) ','(-) ')+TMP->ED_DESCRIC )	// DESCRICAO
	
		aStl := {}
		aAdd( aStl, &("oSN"+cAuxVar+"Txt") ) // COD
		aAdd( aStl, &("oSN"+cAuxVar+"Txt") ) // DESCRICAO 
  
		If lFolha
			
			aAdd( aRowDad, IsNull(TMP->JANEIRO, 0) ) 	// JANEIRO
			aAdd( aRowDad, IsNull(TMP->FEVEREIRO, 0) ) // FEVEREIRO
			aAdd( aRowDad, IsNull(TMP->MARCO, 0) ) 	// MARCO
			aAdd( aRowDad, IsNull(TMP->ABRIL, 0) ) 	// ABRIL
			aAdd( aRowDad, IsNull(TMP->MAIO, 0) ) 		// MAIO
			aAdd( aRowDad, IsNull(TMP->JUNHO, 0) ) 	// JUNHO
			aAdd( aRowDad, "=SUM(RC[-6]:RC[-1])" ) 		// SUB-TOTAL 1 SEMESTRE
			aAdd( aRowDad, IsNull(TMP->JULHO, 0) ) 	// JULHO
			aAdd( aRowDad, IsNull(TMP->AGOSTO, 0) ) 	// AGOSTO
			aAdd( aRowDad, IsNull(TMP->SETEMBRO, 0) ) 	// SETEMBRO
			aAdd( aRowDad, IsNull(TMP->OUTUBRO, 0) ) 	// OUTUBRO
			aAdd( aRowDad, IsNull(TMP->NOVEMBRO, 0) ) 	// NOVEMBRO
			aAdd( aRowDad, IsNull(TMP->DEZEMBRO, 0) ) 	// DEZEMBRO
			aAdd( aRowDad, "=SUM(RC[-6]:RC[-1])" ) 		// SUB-TOTAL 2 SEMESTRE
			aAdd( aRowDad, "=SUM(RC[-8],RC[-1])" ) 		// TOTAL ANUAL			
			
			For nX:=1 To 15 
				aAdd( aStl, &("oSN"+cAuxVar+"Num") )
			Next nX 
		Else
			For nX:=1 To 15
				aAdd( aRowDad, "=SUBTOTAL(9,R[1]C:R["+StrZero(TMP->NFILHOS,4)+"]C)" )  
				aAdd( aStl, &("oSN"+cAuxVar+"Num") )
			Next nX
		EndIf
			
		oXML:AddRow(, aRowDad, aStl)
				
		nItens++
		TMP->(dbSkip())
		 
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Sub-TOTAIS. ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If (lMargCo .AND. SubStr(TMP->ED_CODIGO,1,1)=='3') .OR. TMP->(EOF())
			aRowDad := {}
			aAdd( aRowDad, IIF(TMP->(EOF()),STR0020,STR0021) ) 	// COD//"(=) RESULTADO OPERACIONAL"//"(=) MARGEM DE CONTRIBUIวรO"
			aAdd( aRowDad, "" )	// DESCRICAO
		
			aStl := {}
			aAdd( aStl, oSub01Txt ) // COD
			aAdd( aStl, oSub01Txt ) // DESCRICAO 
				
			For nX:=1 To 15
				aAdd( aRowDad, "=SUBTOTAL(9,R[-"+StrZero(nItens,4)+"]C:R[-1]C)" )  
				aAdd( aStl, oSub01Num ) 
			Next nX
			
			oXML:AddRow(, aRowDad, aStl)
			oXML:SetMerge(,,,1)
			
			If lMargCo
				nNumMarg := nItens
			EndIf
		     
			lMargCo := .F. // Para nao entrar mais nessa condicao
			nItens++
		EndIf
		
		If SubStr(TMP->ED_CODIGO,1,1)=='1'
			nRBruta++
		EndIf
		
		If SubStr(TMP->ED_CODIGO,1,1)<>'4'
			nDespFix++
		EndIf
		 				
	EndDo 
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Ponto de Equilibrio. ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aRowDad := {}
	aAdd( aRowDad, STR0023 ) 	// COD//"(=) PONTO DE EQUILอBRIO"
	aAdd( aRowDad, "" )	// DESCRICAO

	aStl := {}
	aAdd( aStl, oPE01Txt ) // COD
	aAdd( aStl, oPE01Txt ) // DESCRICAO 
		
	For nX:=1 To 15
		//aAdd( aRowDad, "=IF(SUBTOTAL(9,R[-"+StrZero(nItens-nDespFix-1,4)+"]C:R[-2]C)=0,0,"+;
		//				"SUBTOTAL(9,R[-"+StrZero(nItens-nDespFix-1,4)+"]C:R[-2]C)/(R[-"+StrZero(nItens-nNumMarg,4)+"]C/SUBTOTAL(9,R[-"+StrZero(nItens,4)+"]C:R[-"+StrZero(nItens-nRBruta,4)+"]C)))" ) 
		aAdd( aRowDad, "=ABS(IF(OR(SUBTOTAL(9,R[-"+StrZero(nItens-nDespFix-1,4)+"]C:R[-2]C)=0,R[-"+StrZero(nItens-nNumMarg,4)+"]C<=0),0,"+;
					   	"R[-"+StrZero(nItens-nNumMarg,4)+"]C / SUBTOTAL(9,R[-"+StrZero(nItens-nDespFix-1,4)+"]C:R[-2]C) ))" ) 
		
		aAdd( aStl, oPE01Num ) 
	Next nX
	
	oXML:AddRow(, aRowDad, aStl)
	oXML:SetMerge(,,,1)
    
	TMP->(dbCloseArea())
	
Return oXml

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GrDadDRE บAutor  ณ Wilson A. Silva Jr.บ Data ณ  26/04/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera dados para relatorio de DRE.				          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Template Function GrDadDRE(aDados)

	Local cQuery 	:= ""
	
 	cQuery := " SELECT "+ CRLF
 	cQuery += " 	T1.ED_CODIGO, "+ CRLF
	cQuery += " 	T1.ED_DESCRIC, "+ CRLF 
	cQuery += " 	T1.ED_COND, "+ CRLF
	If cDBMS == "ORACLE"
		cQuery += " 	(SELECT COUNT(1) FROM "+RetSqlName("SED")+" B WHERE B.ED_FILIAL = '"+xFilial("SED")+"' AND B.ED_PAI LIKE RTRIM(T1.ED_CODIGO)||'%' AND B.ED_01DRE = 'S' AND B.D_E_L_E_T_ <> '*') AS NFILHOS, "+ CRLF
	Else
		cQuery += " 	(SELECT COUNT(1) FROM "+RetSqlName("SED")+" B WHERE B.ED_FILIAL = '"+xFilial("SED")+"' AND B.ED_PAI LIKE RTRIM(T1.ED_CODIGO)+'%' AND B.ED_01DRE = 'S' AND B.D_E_L_E_T_ <> '*') AS NFILHOS, "+ CRLF
	EndIf
	cQuery += " 	SUM(CASE WHEN T1.MES = '01' THEN T1.VALOR ELSE 0 END) AS JANEIRO, "+ CRLF
	cQuery += " 	SUM(CASE WHEN T1.MES = '02' THEN T1.VALOR ELSE 0 END) AS FEVEREIRO, "+ CRLF
	cQuery += " 	SUM(CASE WHEN T1.MES = '03' THEN T1.VALOR ELSE 0 END) AS MARCO, "+ CRLF
	cQuery += " 	SUM(CASE WHEN T1.MES = '04' THEN T1.VALOR ELSE 0 END) AS ABRIL, "+ CRLF
	cQuery += " 	SUM(CASE WHEN T1.MES = '05' THEN T1.VALOR ELSE 0 END) AS MAIO, "+ CRLF
	cQuery += " 	SUM(CASE WHEN T1.MES = '06' THEN T1.VALOR ELSE 0 END) AS JUNHO, "+ CRLF
	cQuery += " 	SUM(CASE WHEN T1.MES = '07' THEN T1.VALOR ELSE 0 END) AS JULHO, "+ CRLF
	cQuery += " 	SUM(CASE WHEN T1.MES = '08' THEN T1.VALOR ELSE 0 END) AS AGOSTO, "+ CRLF
	cQuery += " 	SUM(CASE WHEN T1.MES = '09' THEN T1.VALOR ELSE 0 END) AS SETEMBRO, "+ CRLF
	cQuery += " 	SUM(CASE WHEN T1.MES = '10' THEN T1.VALOR ELSE 0 END) AS OUTUBRO, "+ CRLF
	cQuery += " 	SUM(CASE WHEN T1.MES = '11' THEN T1.VALOR ELSE 0 END) AS NOVEMBRO, "+ CRLF
	cQuery += " 	SUM(CASE WHEN T1.MES = '12' THEN T1.VALOR ELSE 0 END) AS DEZEMBRO "+ CRLF
	
	cQuery += " FROM ( "+ CRLF
	
	cQuery += " 		SELECT "+ CRLF
	cQuery += " 			SED.ED_CODIGO, "+ CRLF
	cQuery += " 			SED.ED_DESCRIC, "+ CRLF
	cQuery += " 			SED.ED_COND, "+ CRLF
	If nTipoRel == 1 // Emissao
		cQuery += " 			SUBSTRING(E1_EMISSAO,5,2) AS MES, "+ CRLF
	Else
		cQuery += " 			SUBSTRING(E1_VENCREA,5,2) AS MES, "+ CRLF
	EndIf
	cQuery += " 			(ISNULL(SUM((E1_VALOR+E1_MULTA+E1_JUROS+E1_ACRESC+E1_CORREC)-E1_DESCONT-E1_DECRESC-E1_DESCFIN),0)) AS VALOR "+ CRLF
	cQuery += "     	FROM "+RetSqlName("SED")+" SED "+ CRLF
	cQuery += "    		LEFT OUTER JOIN "+RetSqlName("SE1")+" SE1 "+ CRLF
	cQuery += " 	   		ON SE1.E1_NATUREZ = SED.ED_CODIGO "+ CRLF
	If nTipoRel == 1 // Emissao
		cQuery += " 	   		AND SUBSTRING(SE1.E1_EMISSAO,1,4) = '"+cAnoExec+"' "+ CRLF
	Else
		cQuery += " 	   		AND SUBSTRING(SE1.E1_VENCREA,1,4) = '"+cAnoExec+"' "+ CRLF
	EndIf
	//cQuery += " 	   		AND SE1.E1_ORIGEM IN ('LOJA701','LOJA010') "+ CRLF // Garante que nใo ira trazer titulos de liquida็ใo duplicando o valor no DRE.
	cQuery += " 			AND SE1.E1_FLAGFAT <> 'S' "+ CRLF // Filtra titulos que foram aglutinados em fatura para nao duplicar valor no DRE.
	//cQuery += " 	   		AND SE1.E1_LA <> 'S' "+ CRLF // Garante que nใo ira trazer titulos de liquida็ใo duplicando o valor no DRE.
	cQuery += " 	   		AND SE1.E1_NUMLIQ = ' ' "+ CRLF // Garante que nใo ira trazer titulos de liquida็ใo duplicando o valor no DRE.
	cQuery += " 			AND (SE1.E1_TIPO <> 'PR' OR (SE1.E1_TIPO = 'PR' AND SE1.E1_BAIXA = ' ')) "+ CRLF // Garante que nao ira trazer titulos provisorios ja substituidos duplicando o valor no DRE.
	cQuery += " 	   		AND SE1.D_E_L_E_T_ <> '*' "+ CRLF
	If !Empty(cFiliais)
		cQuery += " 			AND SE1.E1_FILIAL IN ('"+cFiliais+"') "+ CRLF
	EndIf
	cQuery += "     	WHERE "+ CRLF
	cQuery += "     		SED.ED_FILIAL = '"+xFilial("SED")+"' "+ CRLF
	cQuery += "     		AND SED.ED_01DRE = 'S' "+ CRLF
	cQuery += "     		AND SED.D_E_L_E_T_ <> '*' "+ CRLF
	cQuery += " 		GROUP BY "+ CRLF
	cQuery += " 			SED.ED_CODIGO, "+ CRLF
	cQuery += " 			SED.ED_DESCRIC, "+ CRLF
	cQuery += " 			SED.ED_COND, "+ CRLF
	If nTipoRel == 1 // Emissao
		cQuery += " 			SUBSTRING(E1_EMISSAO,5,2) "+ CRLF 
	Else
		cQuery += " 			SUBSTRING(E1_VENCREA,5,2) "+ CRLF 
	EndIf
	
	cQuery += " 	UNION ALL "+ CRLF
	 	
	cQuery += "    		SELECT "+ CRLF
	cQuery += "    			SED.ED_CODIGO, "+ CRLF
	cQuery += "    			SED.ED_DESCRIC, "+ CRLF
	cQuery += "    			SED.ED_COND, "+ CRLF
	If nTipoRel == 1 // Emissao
		cQuery += " 			SUBSTRING(E2_EMISSAO,5,2) AS MES, "+ CRLF
	Else
		cQuery += "    			SUBSTRING(E2_VENCREA,5,2) AS MES, "+ CRLF
	EndIf
	cQuery += "    			(ISNULL(SUM((E2_VALOR+E2_MULTA+E2_JUROS+E2_ACRESC+E2_CORREC)-E2_DESCONT-E2_DECRESC),0)*-1) AS VALOR "+ CRLF
	cQuery += "     	FROM "+RetSqlName("SED")+" SED "+ CRLF
	cQuery += "    		LEFT OUTER JOIN "+RetSqlName("SE2")+" SE2 "+ CRLF
	cQuery += " 	 		ON SE2.E2_NATUREZ = SED.ED_CODIGO "+ CRLF
	If nTipoRel == 1 // Emissao
		cQuery += " 			AND SUBSTRING(SE2.E2_EMISSAO,1,4) = '"+cAnoExec+"' "+ CRLF
	Else
		cQuery += " 			AND SUBSTRING(SE2.E2_VENCREA,1,4) = '"+cAnoExec+"' "+ CRLF
	EndIf
	cQuery += " 			AND SE2.E2_MULTNAT <> '1' "+ CRLF // Filtra titulos com multiplas naturezas pois o valor serแ verificado na SEV
	cQuery += " 			AND SE2.E2_FLAGFAT <> 'S' "+ CRLF // Filtra titulos que foram aglutinados em fatura para nao duplicar valor no DRE.
	cQuery += " 			AND (SE2.E2_DESDOBR <> 'S' OR (SE2.E2_DESDOBR = 'S' AND SE2.E2_PARCELA <> ' '))"+ CRLF // Filtro titulos que foram desdobrados para nao duplicar valor no DRE.
	cQuery += " 			AND (SE2.E2_TIPO <> 'PR' OR (SE2.E2_TIPO = 'PR' AND SE2.E2_BAIXA = ' ')) "+ CRLF // Garante que nao ira trazer titulos provisorios ja substituidos duplicando o valor no DRE.
	cQuery += " 			AND (SE2.E2_TIPO <> 'PA' OR (SE2.E2_TIPO = 'PA' AND SE2.E2_BAIXA = ' ')) "+ CRLF // Garante que nao ira trazer pagamentos antecipados ja compensados duplicando o valor no DRE.
	cQuery += " 			AND SE2.D_E_L_E_T_ <> '*' "+ CRLF	
	If !Empty(cFiliais)
		cQuery += " 		AND SE2.E2_FILIAL IN ('"+cFiliais+"') "+ CRLF
	EndIf 
	cQuery += "     	WHERE "+ CRLF
	cQuery += "     		SED.ED_FILIAL = '"+xFilial("SED")+"' "+ CRLF
	cQuery += "     		AND SED.ED_01DRE = 'S' "+ CRLF
	cQuery += "     		AND SED.D_E_L_E_T_ <> '*' "+ CRLF
	cQuery += " 		GROUP BY "+ CRLF
	cQuery += " 			SED.ED_CODIGO, "+ CRLF
	cQuery += " 			SED.ED_DESCRIC, "+ CRLF
	cQuery += " 			SED.ED_COND, "+ CRLF
	If nTipoRel == 1 // Emissao
		cQuery += " 			SUBSTRING(E2_EMISSAO,5,2) "+ CRLF 
	Else
		cQuery += " 			SUBSTRING(E2_VENCREA,5,2) "+ CRLF 
	EndIf
	
	cQuery += " 	UNION ALL "+ CRLF
	
	cQuery += " 		SELECT "+ CRLF
	cQuery += " 			SED.ED_CODIGO, "+ CRLF
	cQuery += " 			SED.ED_DESCRIC, "+ CRLF
	cQuery += " 			SED.ED_COND, "+ CRLF
	If nTipoRel == 1 // Emissao
		cQuery += " 			SUBSTRING(E2_EMISSAO,5,2) AS MES, "+ CRLF
	Else
		cQuery += " 			SUBSTRING(E2_VENCREA,5,2) AS MES, "+ CRLF
	EndIf
	cQuery += " 			(ISNULL(SUM(EV_VALOR),0)*-1) AS VALOR "+ CRLF
	cQuery += " 		FROM "+RetSqlName("SED")+" SED "+ CRLF
	cQuery += " 		INNER JOIN "+RetSqlName("SEV")+" SEV "+ CRLF
	cQuery += "   			ON SEV.EV_NATUREZ = SED.ED_CODIGO "+ CRLF
	cQuery += " 			AND SEV.EV_RECPAG = 'P' "+ CRLF
	cQuery += " 			AND SEV.EV_SITUACA = ' ' "+ CRLF
	cQuery += "    			AND SEV.D_E_L_E_T_ <> '*' "+ CRLF	
	If !Empty(cFiliais)
		cQuery += " 		AND SEV.EV_FILIAL IN ('"+cFiliais+"') "+ CRLF
	EndIf	
	cQuery += " 		INNER JOIN "+RetSqlName("SE2")+" SE2 "+ CRLF
	cQuery += "    			ON SE2.E2_NUM = SEV.EV_NUM "+ CRLF
	cQuery += "    			AND SE2.E2_FILIAL = SEV.EV_FILIAL "+ CRLF
	cQuery += " 			AND SE2.E2_FORNECE = SEV.EV_CLIFOR "+ CRLF
	cQuery += "    			AND SE2.E2_LOJA = SEV.EV_LOJA "+ CRLF
	cQuery += " 			AND SE2.E2_TIPO = SEV.EV_TIPO "+ CRLF
	If nTipoRel == 1 // Emissao
		cQuery += " 			AND SUBSTRING(SE2.E2_EMISSAO,1,4) = '"+cAnoExec+"' "+ CRLF
	Else
		cQuery += " 			AND SUBSTRING(SE2.E2_VENCREA,1,4) = '"+cAnoExec+"' "+ CRLF
	EndIf
	cQuery += " 			AND SE2.D_E_L_E_T_ <> '*'	"+ CRLF
	cQuery += "     	WHERE "+ CRLF
	cQuery += "     		SED.ED_FILIAL = '"+xFilial("SED")+"' "+ CRLF
	cQuery += "     		AND SED.ED_01DRE = 'S' "+ CRLF
	cQuery += "     		AND SED.D_E_L_E_T_ <> '*' "+ CRLF
	cQuery += " 		GROUP BY "+ CRLF
	cQuery += " 			SED.ED_CODIGO, "+ CRLF
	cQuery += " 			SED.ED_DESCRIC, "+ CRLF
	cQuery += " 			SED.ED_COND, "+ CRLF
	If nTipoRel == 1 // Emissao
		cQuery += " 			SUBSTRING(E2_EMISSAO,5,2) "+ CRLF 
	Else
		cQuery += " 			SUBSTRING(E2_VENCREA,5,2) "+ CRLF 
	EndIf
	
	cQuery += " ) T1 "+ CRLF
	
	cQuery += " GROUP BY "+ CRLF
 	cQuery += " 	T1.ED_CODIGO, "+ CRLF
	cQuery += " 	T1.ED_DESCRIC, "+ CRLF 
	cQuery += " 	T1.ED_COND "+ CRLF

	cQuery += " ORDER BY T1.ED_CODIGO "+ CRLF
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Salva query em disco para debug. ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If GetNewPar("SY_DEBUG", .F.)
		MakeDir("\DEBUG\")
		MemoWrite("\DEBUG\"+__cUserID+"_BINR001.SQL", cQuery)
	EndIf

	If Select("TMP") > 0
		TMP->(dbCloseArea())
	EndIf
	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,T_SYCompQry(cQuery)),"TMP",.F.,.T.)
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MesExt	บAutor  ณ Wilson A. Silva Jr.บ Data ณ  06/05/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna mes em extenso.	   								  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function MesExt(nMes)
 
Local aMeses := {	STR0024,STR0025,STR0026,STR0027,STR0028,STR0029,;
					STR0030,STR0031,STR0032,STR0033,STR0034,STR0035}
				//{	"Janeiro","Fevereiro","Mar็o","Abril","Maio","Junho",;
				//	"Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"}
Return aMeses[nMes]

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ IsNull   บAutor  ณ Wilson A. Silva Jr.บ Data ณ  03/05/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ 												              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function IsNull(xDado, xRetorno)
Return IIF(Empty(xDado),xRetorno,xDado )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AjustaSX1บAutor  ณ Wilson A. Silva Jr.บ Data ณ  27/04/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria perguntas no dicionario SX1.                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function AjustaSX1(cPerg)	

	Local aHelp01 := {"Informe o ano do exercํcio. ","",""}
	Local aHelp02 := {"Deseja Selecionar as Filiais.","",""}
	Local aHelp03 := {"Tipo Relat๓rio: ","Data de Emissao ou Vencimento.",""}
	                                                                                                                                                                                                                                              
	T_PutSx1(cPerg,"01","Ano Exercํcio"		,"Ano Exercํcio"		,"Ano Exercํcio"		,"MV_CH1","N",4,0, ,"G",,,,,"MV_PAR01",					,				,				,StrZero(Year(Date()))	,				,				,				,,,,,,,,,,aHelp01,aHelp01,aHelp01)
	T_PutSx1(cPerg,"02","Seleciona Filiais"	,"Seleciona Filiais"	,"Seleciona Filiais"	,"MV_CH2","N",1,0,1,"C",,,,,"MV_PAR02","Sim"			,"Sim"			,"Sim"			,						,"Nใo"			,"Nใo"			,"Nใo"			,,,,,,,,,,aHelp02,aHelp02,aHelp02)
	T_PutSx1(cPerg,"03","Tipo Relat๓rio"	,"Tipo Relat๓rio"		,"Tipo Relat๓rio"		,"MV_CH3","N",1,0,1,"C",,,,,"MV_PAR03","Por Emissao"	,"Por Emissao"	,"Por Emissao"	,						,"Por Vencto"	,"Por Vencto"	,"Por Vencto"	,,,,,,,,,,aHelp03,aHelp03,aHelp03)
	
Return 
