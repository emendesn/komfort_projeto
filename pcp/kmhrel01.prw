#include "protheus.ch"
#include "report.ch"
 
User Function KMHREL01()
Local oReport
Local oReport := ReportDef()   

oReport:PrintDialog()

Return Nil
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SYVR107  บ Autor ณ AP6 IDE            บ Data ณ  24/10/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de pagamento dos montadores                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ               
ฑฑบUso       ณ Casa Cenario                                               บฑฑ     
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function ReportDef()                                                             
Local oBreak,oBreak1, oCell, oReport, oSection 
Local cPerg	  	:= "SYVR107"                    
Local cReport 	:= "SYVR107"
Local cTitulo 	:= "Requizi็ใo de Material"
Local cDescri 	:= "Este programa irแ emitir a Requizi็ใo de Material."

oReport := TReport():New("SYVR107","Requisi็ใo de Material",,{|oReport| ReportPrint(oReport)},"Requizi็ใo de Material.")     

oReport:nfontbody:=7
oReport:cfontbody:="Arial"

If !SYPERGUNTA() 
	Return(.T.)
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Sessao 1 (oSection1)                                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                                                       
oSection1 := TRSection():New(oReport, "Requizi็ใo de Material", {"SG1","SB1","SB2"}, {"Por OP"} )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ                         
//ณCriacao da celulas da secao do relatorio                      ณ
//ณ                                                              ณ
//ณTRCell():New                                                  ณ
//ณExpO1 : Objeto TSection que a secao pertence                  ณ
//ณExpC2 : Nome da celula do relat๓rio. O SX3 serแ consultado    ณ
//ณExpC3 : Nome da tabela de referencia da celula                ณ
//ณExpC4 : Titulo da celula                                      ณ
//ณ        Default : X3Titulo()                                  ณ
//ณExpC5 : Picture                                               ณ
//ณ        Default : X3_PICTURE                                  ณ
//ณExpC6 : Tamanho                                               ณ
//ณ        Default : X3_TAMANHO                                  ณ
//ณExpL7 : Informe se o tamanho esta em pixel                    ณ
//ณ        Default : False                                       ณ
//ณExpB8 : Bloco de c๓digo para impressao.                       ณ
//ณ        Default : ExpC2                                       ณ
//ณ                                                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                            
    
//Cabecalho do relat๓rio
TRCell():New(oSection1,"MATERIA PRIMA"	,,RetTitle("G1_COMP")		,,TamSX3("G1_COMP")[1])
TRCell():New(oSection1,"NECESSIDADE"   	,,RetTitle("G1_QUANT")   	,,TamSX3("G1_QUANT")[1])
TRCell():New(oSection1,"UNIMEDIDA"   	,,RetTitle("B1_UM")		   	,,TamSX3("B1_UM")[1])
TRCell():New(oSection1,"DESCRICAO"		,,RetTitle("B1_DESC")		,,TamSX3("B1_DESC")[1]) 
TRCell():New(oSection1,"TIPO"   		,,RetTitle("B1_TIPO")   	,,TamSX3("B1_TIPO")[1])
TRCell():New(oSection1,"AREA" 			,,RetTitle("B1_01ARPCP") 	,,TamSX3("G1_COMP")[1])    
    

oReport:SetTotalInLine(.F.)
oReport:SetLandscape()

Return( oReport )
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ    
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SYVR107  บ Autor ณ AP6 IDE            บ Data ณ  24/10/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de pagamento dos montadores                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Casa Cenario                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function ReportPrint( oReport )
Local cQuery       	:= ""
Local cAlias       	:= GetNextAlias()
Local oSection1 	:= oReport:Section(1)
Local oSectionPed  	:= oSection1:Section(1)                                
Local Tamanho		:= "P"
Local nPagina		:= 1   
Local cAreaAnt 		:= ""
Local cAreaPos		:= ""
Local cCodAnt 		:= ""
Local cCodPos		:= ""        
Local cCodMp  		:= ""
Local cDesc   		:= ""
Local cTipo   		:= ""
Local cArea   		:= ""
Local nNecess		:= 0 
Local nQtdOp		:= 0 
Local nx			:= 0
Private cNum 		:= ""
Private cProdOp		:= ""
Private cDescOp 	:= ""
Private cNumPV 		:= ""
Private cCliPC 		:= ""
Private cCliLjPC	:= ""
Private cFilPV 		:= ""
Private cNomeCli	:= ""  

	//Dados da OP e Pedido do Cliente e Produto
	dbSelectArea("SC2")
	dbSetOrder(1)   
	If dbSeek(xFilial("SC2")+Alltrim(MV_PAR01)+"01001")//mv_par01 sempre busca o sequencial 001         
		cNum 	:= SC2->C2_NUM
		cProdOp	:= SC2->C2_PRODUTO
		dDtIni	:= SC2->C2_DATPRI
		dDtEntr := SC2->C2_DATPRF 
		nQtdOp  := SC2->C2_QUANT 
	Else           
		MsgAlert("OP nใo encontrada")  
	    Return .F.
	EndIf
	                 
	SC2->(dbCloseArea())

cQuery := " WITH ESTRUT( FILIAL, CODIGO, COD_PI, COD_MP, NECESSIDADE, TIPO, DESCRICAO, DTINI, DTFIM, UNIMEDIDA, AREA ) AS "
cQuery += " (                                                "
cQuery += " SELECT G1_FILIAL, G1_COD PAI, G1_COD, G1_COMP, G1_QUANT,  SB1.B1_TIPO, B1_DESC, G1_INI, G1_FIM, B1_UM, "
cQuery += " CASE WHEN B1_01ARPCP = 1 THEN 'CORTE' WHEN B1_01ARPCP = 2 THEN 'MARCENARIA' "
cQuery += " WHEN B1_01ARPCP = 3 THEN 'LAMINACAO' WHEN B1_01ARPCP = 4 THEN 'COSTURA' WHEN B1_01ARPCP = 5 THEN 'TAPECARIA' WHEN B1_01ARPCP = 6 THEN 'ESPUMACAO'  WHEN B1_01ARPCP = 7 THEN 'MONTAGEM' WHEN B1_01ARPCP = 8 THEN 'EMBALAGEM' ELSE '' END AS AREA "
cQuery += " FROM SG1010 SG1 (NOLOCK) "
cQuery += " INNER JOIN SB1010 SB1 (NOLOCK) ON B1_COD=G1_COMP "
cQuery += " WHERE SG1.D_E_L_E_T_ = '' "
cQuery += " AND SB1.D_E_L_E_T_ = '' "                                                             
cQuery += " AND G1_FILIAL      = '0101' "
cQuery += " UNION ALL  "
cQuery += " SELECT G1_FILIAL, CODIGO, G1_COD, G1_COMP, NECESSIDADE * G1_QUANT, SB1.B1_TIPO, B1_DESC, G1_INI, G1_FIM, B1_UM, "
cQuery += " CASE WHEN B1_01ARPCP = 1 THEN 'CORTE' WHEN B1_01ARPCP = 2 THEN 'MARCENARIA' "
cQuery += " WHEN B1_01ARPCP = 3 THEN 'LAMINACAO' WHEN B1_01ARPCP = 4 THEN 'COSTURA' WHEN B1_01ARPCP = 5 THEN 'TAPECARIA' WHEN B1_01ARPCP = 6 THEN 'ESPUMACAO'  WHEN B1_01ARPCP = 7 THEN 'MONTAGEM' WHEN B1_01ARPCP = 8 THEN 'EMBALAGEM' ELSE '' END AS AREA "  
cQuery += " FROM SG1010 SG1 (NOLOCK) "
cQuery += " INNER JOIN SB1010 SB1 (NOLOCK) ON B1_COD=G1_COMP "
cQuery += " INNER JOIN ESTRUT EST "
cQuery += " ON G1_COD = COD_MP "
cQuery += " WHERE SG1.D_E_L_E_T_ = '' "
cQuery += " AND SB1.D_E_L_E_T_ = '' "             
cQuery += " AND SG1.G1_FILIAL = '0101' "     
cQuery += " ) "
cQuery += " SELECT  MAX(E1.CODIGO) AS CODIGO, E1.COD_MP AS COD_MP, MAX(E1.UNIMEDIDA) AS UNIMEDIDA, "
cQuery += " MAX(E1.DESCRICAO) AS DESCRICAO, MAX(E1.TIPO) AS TIPO, MAX(E1.AREA) AS AREA, "
cQuery += " SUM(E1.NECESSIDADE) AS NECESSIDADE "
cQuery += " FROM ESTRUT E1 "
cQuery += " WHERE E1.CODIGO = '"+cProdOp+"' "   
cQuery += " AND E1.TIPO ='MP'       
cQuery += " GROUP BY E1.CODIGO, E1.COD_MP, E1.UNIMEDIDA, E1.DESCRICAO, E1.TIPO, E1.AREA "
cQuery += " ORDER BY E1.AREA, E1.COD_MP "         

DbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), cAlias, .F., .T.)             
                                                                                         
oReport:SetMeter( 1 )
oSection1:Init()

	nPagina := 1  
	
	//Dados da OP e Pedido do Cliente e Produto
	
	dbSelectArea("SB1")                                                               
	dbSetOrder(1)  
	If DbSeek( xFilial("SB1")+cProdOp)
		cDescOp := Alltrim(SB1->B1_DESC)         
	Endif
	
	
	SB1->(dbCloseArea())                      
	
	dbSelectArea("SC5")
	dbSetOrder(1)  
	dbSeek(xFilial("SC5")+cNum)
	cNumPV := SC5->C5_NUM
	cCliPC := SC5->C5_CLIENTE
	cCliLjPC := SC5->C5_LOJACLI
	cFilPV := SC5->C5_XDESCFI
	
	SC5->(dbCloseArea())
	
	dbSelectArea("SA1")
	dbSetOrder(1)  
	dbSeek(xFilial("SA1")+cCliPC+cCliLjPC)
	cNomeCli := SA1->A1_NOME
	
	SA1->(dbCloseArea())                                                                                                        
	
	//Imprime dados OP Produto e Cliente                                                                                                    
   	oReport:SkipLine()   // salta uma linha                                                                                                 
   	oReport:SkipLine()   // salta uma linha
	oReport:PrintText("OP: "+cNum+" Produto: "+cProdOp+" | Descri็ใo: "+Alltrim(cDescOp)+" | Qtd: "+transform(nQtdOp, "@E 999,999.999999" )+ " | Data Inํcio: "+SUBSTR(dTos(dDtIni),7,2)+"/"+SUBSTR(dTos(dDtIni),5,2)+"/"+SUBSTR(dTos(dDtIni),1,4)+ " | Data Entrega: "+SUBSTR(dTos(dDtEntr),7,2)+"/"+SUBSTR(dTos(dDtEntr),5,2)+"/"+SUBSTR(dTos(dDtEntr),1,4)+ " ",060,030)                          
    oReport:SkipLine()   // salta uma linha            
    oReport:SkipLine()   // salta uma linha                  
    //oReport:PrintText("Filial PV: "+cFilPV+ "Cliente PV: "+cCliPC+ " Nome: "+cNomeCli,020,020) //caso necessแrio habilitar no futuro
                                                          
    oReport:ThinLine() //-- Impressao de Linha Simples      
 	oReport:SkipLine()   // salta uma linha           

(cAlias)->( dbGoTop() )
While (cAlias)->( !Eof() )      
	oReport:IncMeter()
	                                                          
	// -- Verifica o cancelamento pelo usuario.
	If oReport:Cancel()
		Exit
	EndIf    
	
	//IMPRIME CABECALHO
	//nPagina := 1  
	
	//verifica se docigo de MP ้ o mesmo e soma as necessidades para uma unica impressใo, nใo foi possivel agrupar via query
	cCodAnt := (cAlias)->COD_MP
	
	//pula de linha para uma nova แrea
	cAreaAnt := (cAlias)->AREA
		                             				
	//pula de linha
	  If cAreaAnt <> cAreaPos .And. nX > 0//pula e imprime linha de separa็ใo 
	    	
	    	//Impressao de assinatura
	    	oReport:SkipLine()   // salta uma linha
	    	
			oReport:PrtLeft("Dados do responsแvel")               
		    oReport:SkipLine()   // salta uma linha        
		 	oReport:SkipLine()   // salta uma linha
	    	oReport:PrtLeft("Nome: __________________________________________")
		    oReport:SkipLine()   // salta uma linha
		    oReport:SkipLine()   // salta uma linha
		    oReport:PrtLeft("Data: ____/____/______" )   
	    	oReport:SkipLine()   // salta uma linha
	    	oReport:SkipLine()   // salta uma linha            
	    	
	    	//Pula de Linha
 			oReport:SkipLine()   // salta uma linha
 			oReport:ThinLine() //-- Impressao de Linha Simples                         
 		EndIf
 		
 //	If (cCodAnt == cCodPos) .Or. cCodPos == "" // or garente que entra na primeira vez
		//soma                 
		nNecess := (cAlias)->NECESSIDADE
		cMedi	:= (cAlias)->UNIMEDIDA                          
		cCodMp  := (cAlias)->COD_MP                
		cDesc   := (cAlias)->DESCRICAO
		cTipo   := (cAlias)->TIPO
		cArea   := (cAlias)->AREA
   //	Else                                            
	     //Imprime conteudo do relat๓rio para o cabecalho definido acima                  
	    oSection1:Cell("MATERIA PRIMA" 	):SetBlock( { || cCodMp		} )                  // marcio pegar da sd3 o que for apontado
		oSection1:Cell("NECESSIDADE"    ):SetBlock( { || nNecess*nQtdOp	} ) //calcular a quantidade passada na OP menos a quantidade apontada
		oSection1:Cell("UNIMEDIDA"	    ):SetBlock( { || cMedi		} )	
		oSection1:Cell("DESCRICAO" 		):SetBlock( { || cDesc		} )
		oSection1:Cell("TIPO" 			):SetBlock( { || cTipo		} )          
		oSection1:Cell("AREA"			):SetBlock( { || cArea		} )                                                  
	    
	    //Imprime sessใo 
	    oSection1:PrintLine()     
	    nNecess := 0                                                    	     	  
	     
  //	EndIf
	
	cAreaPos := (cAlias)->AREA						
	cCodPos := (cAlias)->COD_MP
    nX :=1
	(cAlias)->( dbSkip() )                              
EndDo
                     
//Imprime a ultima passada acima
If  cArea <> cAreaPos //caso seja difernte imprime a ultima linha
	oSection1:Cell("MATERIA PRIMA" 	):SetBlock( { || cCodMp		} )    
	oSection1:Cell("NECESSIDADE"    ):SetBlock( { || nNecess	} )
	oSection1:Cell("UNIMEDIDA"	    ):SetBlock( { || cMedi		} )
	oSection1:Cell("DESCRICAO" 		):SetBlock( { || cDesc		} )
	oSection1:Cell("TIPO" 			):SetBlock( { || cTipo		} )
	oSection1:Cell("AREA"			):SetBlock( { || cArea		} )    

	oSection1:PrintLine()         
EndIf

	//Impressao de assinatura
	oReport:PrtLeft("Dados do responsแvel")
    oReport:SkipLine()   // salta uma linha  
 	oReport:SkipLine()   // salta uma linha                                      
   	oReport:PrtLeft("Nome: __________________________________________")
    oReport:SkipLine()   // salta uma linha
    oReport:SkipLine()   // salta uma linha
    oReport:PrtLeft("Data: ____/____/______" )       
	

oSection1:Finish()

(cAlias)->( dbCloseArea() )

Return( oReport )
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSYPERGUNTAบAutor  ณMicrosiga           บ Data ณ  25/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function SYPERGUNTA()

Local aBoxParam  := {}
Local aRetParam  := {}

Aadd(aBoxParam,{1,"OP"			,CriaVar("C2_NUM",.F.)					,PesqPict("SC2","C2_NUM"),"","SC2","",50,.F.})

IF !ParamBox(aBoxParam,"Informe os Parametros",@aRetParam)
	Return(.F.)
EndIf

MV_PAR01   := aRetParam[1]

Return(.T.) 
