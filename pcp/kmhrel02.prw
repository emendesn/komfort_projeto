#include "protheus.ch"
#include "report.ch"   
#Include "TopConn.ch"
 
User Function KMHREL02()
Local oReport
Local oReport := ReportDef()           
                                                                        
oReport:PrintDialog()

Return Nil
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � SYVR107  � Autor � AP6 IDE            � Data �  24/10/12   ���
�������������������������������������������������������������������������͹��                                   
���Descricao � Relatorio de pagamento dos montadores                      ���
�������������������������������������������������������������������������͹��                
���Uso       � Casa Cenario                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������                      
���������������������������������������������������������������������������*/
Static Function ReportDef()
Local oBreak,oBreak1, oCell, oReport, oSection                                          
Local cPerg	  	:= "SYVR107"                    
Local cReport 	:= "SYVR107"
Local cTitulo 	:= "Requisi��o de Produ��o por �rea"
Local cDescri 	:= "Este programa ir� emitir a Ordem de Produ��o por area."

oReport := TReport():New("SYVR107","Requisi��o de Produ��o por �rea",,{|oReport| ReportPrint(oReport)},"Requisi��o de Produ��o por �rea")  

oReport:nfontbody:=7
oReport:cfontbody:="Arial"

If !SYPERGUNTA() 
	Return(.T.)
Endif

//��������������������������������������������������������������Ŀ
//� Sessao 1 (oSection1)                                      �
//����������������������������������������������������������������                                                       
oSection1 := TRSection():New(oReport, "Requisi��o de Produ��o por �rea", {"SG1","SB1","SB2"}, {"Por OP"} )

//��������������������������������������������������������������Ŀ
//�Criacao da celulas da secao do relatorio                      �
//�                                                              �
//�TRCell():New                                                  �
//�ExpO1 : Objeto TSection que a secao pertence                  �
//�ExpC2 : Nome da celula do relat�rio. O SX3 ser� consultado    �
//�ExpC3 : Nome da tabela de referencia da celula                �
//�ExpC4 : Titulo da celula                                      �
//�        Default : X3Titulo()                                  �
//�ExpC5 : Picture                                               �
//�        Default : X3_PICTURE                                  �
//�ExpC6 : Tamanho                                               �
//�        Default : X3_TAMANHO                                  �
//�ExpL7 : Informe se o tamanho esta em pixel                    �
//�        Default : False                                       �
//�ExpB8 : Bloco de c�digo para impressao.                       �
//�        Default : ExpC2                                       �
//�                                                              �
//����������������������������������������������������������������                            
    
//Cabecalho do relat�rio
TRCell():New(oSection1,"MATERIA PRIMA"	,,RetTitle("G1_COMP")		,,TamSX3("G1_COMP")[1])
TRCell():New(oSection1,"NECESSIDADE"   	,,RetTitle("G1_QUANT")   	,,TamSX3("G1_QUANT")[1])
TRCell():New(oSection1,"UNIMEDIDA"   	,,RetTitle("B1_UM")		   	,,TamSX3("B1_UM")[1])
TRCell():New(oSection1,"DESCRICAO"		,,RetTitle("B1_DESC")		,,TamSX3("B1_DESC")[1]) 
TRCell():New(oSection1,"TIPO"   		,,RetTitle("B1_TIPO")   	,,TamSX3("B1_TIPO")[1])
TRCell():New(oSection1,"AREA" 			,,RetTitle("B1_01ARPCP") 	,,TamSX3("G1_COMP")[1])    
    

oReport:SetTotalInLine(.F.)
oReport:SetLandscape()                                   

Return( oReport )
/*���������������������������������������������������������������������������                                   
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � SYVR107  � Autor � AP6 IDE            � Data �  24/10/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Relatorio de pagamento dos montadores                      ���
�������������������������������������������������������������������������͹��
���Uso       � Casa Cenario                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
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
Local nX			:= 0 
Local nQtdOp		:= 0 
Local nQtdaP		:= 0  
Local nQtdOp		:= 0 
Local nQtdG1		:= 0
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
		MsgAlert("OP n�o encontrada")  
	    Return .F.
	EndIf
	                 
	SC2->(dbCloseArea())

cQuery := " WITH ESTRUT( FILIAL, CODIGO, COD_PI, COD_MP, NECESSIDADE, TIPO, DESCRICAO, DTINI, DTFIM, UNIMEDIDA, AREA ) AS "
cQuery += " (                                                "
cQuery += " SELECT G1_FILIAL, G1_COD PAI, G1_COD, G1_COMP, G1_QUANT,  SB1.B1_TIPO, B1_DESC, G1_INI, G1_FIM, B1_UM, "
cQuery += " CASE WHEN B1_01ARPCP = 1 THEN 'CORTE' WHEN B1_01ARPCP = 2 THEN 'MARCENARIA' "
cQuery += " WHEN B1_01ARPCP = 3 THEN 'LAMINACAO' WHEN B1_01ARPCP = 4 THEN 'COSTURA' WHEN B1_01ARPCP = 5 THEN 'TAPECARIA' WHEN B1_01ARPCP = 6 THEN 'ESPUMACAO' WHEN B1_01ARPCP = 7 THEN 'MONTAGEM' ELSE '' END AS AREA "
cQuery += " FROM SG1010 SG1 (NOLOCK) "
cQuery += " INNER JOIN SB1010 SB1 (NOLOCK) ON B1_COD=G1_COMP "
cQuery += " WHERE SG1.D_E_L_E_T_ = '' "
cQuery += " AND SB1.D_E_L_E_T_ = '' "
cQuery += " AND G1_FILIAL      = '0101' "
cQuery += " UNION ALL  "
cQuery += " SELECT G1_FILIAL, CODIGO, G1_COD, G1_COMP, NECESSIDADE * G1_QUANT, SB1.B1_TIPO, B1_DESC, G1_INI, G1_FIM, B1_UM, "
cQuery += " CASE WHEN B1_01ARPCP = 1 THEN 'CORTE' WHEN B1_01ARPCP = 2 THEN 'MARCENARIA' "
cQuery += " WHEN B1_01ARPCP = 3 THEN 'LAMINACAO' WHEN B1_01ARPCP = 4 THEN 'COSTURA' WHEN B1_01ARPCP = 5 THEN 'TAPECARIA' WHEN B1_01ARPCP = 6 THEN 'ESPUMACAO'  WHEN B1_01ARPCP = 7 THEN 'MONTAGEM' ELSE '' END AS AREA "  
cQuery += " FROM SG1010 SG1 (NOLOCK) "
cQuery += " INNER JOIN SB1010 SB1 (NOLOCK) ON B1_COD=G1_COMP "           
cQuery += " INNER JOIN ESTRUT EST "
cQuery += " ON G1_COD = COD_MP "
cQuery += " WHERE SG1.D_E_L_E_T_ = '' "
cQuery += " AND SB1.D_E_L_E_T_ = '' "             
cQuery += " AND SG1.G1_FILIAL = '0101' "     
cQuery += " ) "
cQuery += " SELECT * "
cQuery += " FROM ESTRUT E1 "
cQuery += " WHERE E1.CODIGO = '"+cProdOp+"'"   
cQuery += " AND E1.TIPO ='MP' 
cQuery += " ORDER BY AREA"         

DbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), cAlias, .F., .T.)    

oReport:SetMeter( 1 )
oSection1:Init()

	nPagina := 1  
	
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
	oReport:PrintText("OP: "+cNum+" Produto: "+cProdOp+" | QTD: "+Str(nQtdOp)+" | Descri��o: "+Alltrim(cDescOp)+" | Data In�cio: "+SUBSTR(dTos(dDtIni),7,2)+"/"+SUBSTR(dTos(dDtIni),5,2)+"/"+SUBSTR(dTos(dDtIni),1,4)+ " | Data Entrega: "+SUBSTR(dTos(dDtEntr),7,2)+"/"+SUBSTR(dTos(dDtEntr),5,2)+"/"+SUBSTR(dTos(dDtEntr),1,4)+ " ",060,030)                             	
//	oReport:PrintText("OP: "+cNum+" Produto: "+cProdOp+" | Descri��o: "+Alltrim((cAlias)->DESCRICAO)+" | Data In�cio: "+dTos(dDtIni)+" | Data Entrega: "+dTos(dDtEntr)+ " ",060,030)                          
    oReport:SkipLine()   // salta uma linha
    oReport:SkipLine()   // salta uma linha                             

(cAlias)->( dbGoTop() )
While (cAlias)->( !Eof() )      
	oReport:IncMeter()

	// -- Verifica o cancelamento pelo usuario.
	If oReport:Cancel()
		Exit
	EndIf 1   
	
	//IMPRIME CABECALHO
	//nPagina := 1  
	
	//verifica se docigo de PI � o mesmo e soma as necessidades para uma unica impress�o, n�o foi possivel agrupar via query
	cCodAnt := (cAlias)->COD_PI
	
	//pula de linha para uma nova �rea
	cAreaAnt := (cAlias)->AREA
		                             					
   	If (cAreaAnt <> cAreaPos) .Or. cAreaPos == "" // or garente que entra na primeira vez
		//impressao do PI                 
		dbSelectArea("SB1")
		dbSetOrder(1)  
		If DbSeek( xFilial("SB1")+(cAlias)->COD_PI)    
	   		cDescPI := Alltrim(SB1->B1_DESC)  
	   		 
	   		//Pula p�gina por PI, ap�s o primeiro PI
	    	If 	cAreaAnt <> cAreaPos .And. nx > 0
	    		oReport:EndPage()                       
				//oReport:StarPage() 
				
				//imprime cabe�alho
				TReport():ShowHeader()
				
				//Imprime dados OP Produto e Cliente
			   	oReport:SkipLine()   // salta uma linha 
			   	oReport:SkipLine()   // salta uma linha
				oReport:PrintText("OP: | "+cNum+" Produto: "+cProdOp+" | QTD: "+Str(nQtdOp)+" | Descri��o: "+Alltrim(cDescOp)+" | Data In�cio: "+dTos(dDtIni)+" | Data Entrega: "+dTos(dDtEntr)+ " ",060,030)                          
			    oReport:SkipLine()   // salta uma linha
			    oReport:SkipLine()   // salta uma linha                          
	    	EndIf   
	    	                                                                                           
	    	nX := 1                                             
	        
	        //Posiciona SG1 para buscar a quantidade do PI
	        dbSelectArea("SG1")
			dbSetOrder(2)   
			If dbSeek(xFilial("SG1")+(cAlias)->COD_MP+(cAlias)->COD_PI)         
				nQtdG1  := SG1->G1_QUANT
			EndIf                                                                             
	    		    
	   		//Imprime PI    
	   		oReport:SkipLine()   // salta uma linha
	   		oReport:ThinLine() //-- Impressao de Linha Simples                     
	   		oReport:PrtLeft("PI: "+(cAlias)->COD_PI+" | Descri��o: "+cDescPI+" | UM: PI | QTD: "+Str(nQtdG1*nQtdOp)+" ") //nQtdOp multiplica pela quantidade de OP's
	   		oReport:SkipLine()   // salta uma linha                   
	   		oReport:SkipLine()   // salta uma linha  
	   		
	   		//IMPRIME o cabe�alho para as proximas linhas         
	   	  //	oReport:PrintText("Componente       Quantidade        Unidade      Descri��o                                                          Tipo     Area PCP ",060,030)                          
   		//	oReport:SkipLine()   // salta uma linha       
		Endif 
  	EndIf                                              
		                                          	     
     //Imprime conteudo do relat�rio para o cabecalho definido acima                  
    oSection1:Cell("MATERIA PRIMA" 	):SetBlock( { || (cAlias)->COD_MP		} ) //                       pegar da sed o que for apontado
	oSection1:Cell("NECESSIDADE"    ):SetBlock( { || (cAlias)->NECESSIDADE*nQtdOp	} ) //calcular a quantidade passada na OP menos a quantidade apontada
	oSection1:Cell("UNIMEDIDA"	    ):SetBlock( { || (cAlias)->UNIMEDIDA		} )	
	oSection1:Cell("DESCRICAO" 		):SetBlock( { || (cAlias)->DESCRICAO		} )
	oSection1:Cell("TIPO" 			):SetBlock( { || (cAlias)->TIPO		} )          
	oSection1:Cell("AREA"			):SetBlock( { || (cAlias)->AREA		} )                                                  
	    
    //Imprime sess�o 
    oSection1:PrintLine()                                                         
	
	cAreaPos := (cAlias)->AREA						
	cCodPos := (cAlias)->COD_PI

	(cAlias)->( dbSkip() )                              
EndDo
                     
    /*
	//Impressao de assinatura
	oReport:PrtLeft("Dados do respons�vel")
    oReport:SkipLine()   // salta uma linha  
 	oReport:SkipLine()   // salta uma linha
   	oReport:PrtLeft("Nome: __________________________________________")
    oReport:SkipLine()   // salta uma linha
    oReport:SkipLine()   // salta uma linha
    oReport:PrtLeft("Data: ____/____/______" )       
	 */

oSection1:Finish()

(cAlias)->( dbCloseArea() )

Return( oReport )
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SYPERGUNTA�Autor  �Microsiga           � Data �  25/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function SYPERGUNTA()

Local aBoxParam  := {}
Local aRetParam  := {}

Aadd(aBoxParam,{1,"OP"			,CriaVar("C2_NUM",.F.)					,PesqPict("SC2","C2_NUM"),"","SC2","",50,.F.})

IF !ParamBox(aBoxParam,"Informe os Parametros",@aRetParam)
	Return(.F.)
EndIf

MV_PAR01   := aRetParam[1]

Return(.T.) 
