#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#Include "Ap5Mail.Ch"
#Include "xmlxfun.ch"
#INCLUDE "JPEG.CH"

#Define STR_PULA    Chr(13)+Chr(10)
//--------------------------------------------------------------
/*/{Protheus.doc} KMSACR08
Description //Relatorio de Analise de Entregas - Auditoria
@param xParam Parameter Description
@return xRet Return Description
@author  - Everton Santos
@since 03/08/2019 /*/
//--------------------------------------------------------------
USER FUNCTION KMSACR08()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de Variaveis                                             �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
Local cDesc1    := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2    := "de acordo com os parametros informados pelo usuario."
Local cDesc3    := ""
Local cPict     := ""
Local titulo    := "ANALISE DE ENTREGAS"
Local nLin      := 80
Local Cabec1    := "Loja             Chamado  Dt.Abertura  Operador                        Cliente                                              Assunto                          Cod.Ocorrencia     Ocorrencia          Cod.Responsavel     Responsavel          Dt.A豫o     Status Chamado     Status A豫o"
Local Cabec2    := ""
Local imprime   := .T.
Local aOrd      := {}
Local aPergunta := {} 

//Tk272DescUsu()                                                                                                                  

Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private nomeprog    := "KMSACR08" // Coloque aqui o nome do programa para impressao no cabecalho
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "KMSACR08" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString     := ""
Private limite      := 220
Private tamanho     := "G"
Private nTipo       := 15

Aadd(aPergunta,{PadR("KMSACR08",10),"01","Respons�vel de  ?" 	,"MV_CH1" ,"C",006,00,"G","MV_PAR01",""     ,""      ,""			,"","","USR",""				})
Aadd(aPergunta,{PadR("KMSACR08",10),"02","Respons�vel ate  ?" 	,"MV_CH2" ,"C",006,00,"G","MV_PAR02",""     ,""      ,""			,"","","USR",""				})
Aadd(aPergunta,{PadR("KMSACR08",10),"03","Operador de  ?" 		,"MV_CH3" ,"C",006,00,"G","MV_PAR03",""     ,""      ,""			,"","","SU7",""				})
Aadd(aPergunta,{PadR("KMSACR08",10),"04","Operador at� ?" 		,"MV_CH4" ,"C",006,00,"G","MV_PAR04",""     ,""      ,""			,"","","SU7",""				})
Aadd(aPergunta,{PadR("KMSACR08",10),"05","Data Abertura de ?"	,"MV_CH5" ,"D",008,00,"G","MV_PAR05",""     ,""      ,""			,"","",""	,""   			})
Aadd(aPergunta,{PadR("KMSACR08",10),"06","Data Abertura at� ?"	,"MV_CH6" ,"D",008,00,"G","MV_PAR06",""     ,""      ,""			,"","",""	,""   			})
Aadd(aPergunta,{PadR("KMSACR08",10),"07","Assunto  ?" 			,"MV_CH7" ,"C",050,00,"G","MV_PAR07",""     ,""      ,""			,"","",""	,"U_KMHAST()"	})
Aadd(aPergunta,{PadR("KMSACR08",10),"08","Status Chamado"  		,"MV_CH8" ,"C",001,00,"C","MV_PAR08","Todos","Aberto","Encerrada"	,"","",""	,""   			})
Aadd(aPergunta,{PadR("KMSACR08",10),"09","Status Linha"  		,"MV_CH9" ,"C",001,00,"C","MV_PAR09","Todos","Aberto","Encerrada"	,"","",""	,""   			})
Aadd(aPergunta,{PadR("KMSACR08",10),"10","Ordem"  				,"MV_CHA" ,"C",001,00,"C","MV_PAR10","Resp/Assu/Dt","Assu/Resp/Dt","Dt/Assu/Resp"	,"","","",""})
Aadd(aPergunta,{PadR("KMSACR08",10),"11","Filial de  ?" 		,"MV_CHB" ,"C",004,00,"G","MV_PAR11",""     ,""      ,""			,"","","SM0",""				})
Aadd(aPergunta,{PadR("KMSACR08",10),"12","Filial at�  ?" 		,"MV_CHC" ,"C",004,00,"G","MV_PAR12",""     ,""      ,""			,"","","SM0",""				})
Aadd(aPergunta,{PadR("KMSACR08",10),"13","Ocorr�ncia  ?" 		,"MV_CHD" ,"C",050,00,"G","MV_PAR13",""     ,""      ,""			,"","",""	,"U_KMHOCOR()"	})
Aadd(aPergunta,{PadR("KMSACR08",10),"14","A豫o  ?" 		    	,"MV_CHE" ,"C",050,00,"G","MV_PAR14",""     ,""      ,""			,"","",""	,"U_KMHACAO()"	})
Aadd(aPergunta,{PadR("KMSACR08",10),"15","Comunica豫o de  ?" 	,"MV_CHF" ,"C",006,00,"G","MV_PAR15",""     ,""      ,""			,"","","SUL",""				})
Aadd(aPergunta,{PadR("KMSACR08",10),"16","Comunica豫o at�  ?"	,"MV_CHG" ,"C",006,00,"G","MV_PAR16",""     ,""      ,""			,"","","SUL",""				})
Aadd(aPergunta,{PadR("KMSACR08",10),"17","Chamados Cancelados"  ,"MV_CHH" ,"C",001,00,"C","MV_PAR17","N�o","Sim","Ambos"			,"","",""	,""   			})
Aadd(aPergunta,{PadR("KMSACR08",10),"18","Dt.A豫o De ?"			,"MV_CHI" ,"D",008,00,"G","MV_PAR18",""     ,""      ,""			,"","",""	,""   			}) //#RVC20180410.n
Aadd(aPergunta,{PadR("KMSACR08",10),"19","Dt.A豫o At� ?"		,"MV_CHJ" ,"D",008,00,"G","MV_PAR19",""     ,""      ,""			,"","",""	,""   			}) //#RVC20180410.n

VldSX1(aPergunta)

If !Pergunte(aPergunta[1,1],.T.)
	Return(Nil)
EndIf

FwMsgRun( ,{|| IMPEXCEL()  }, , "Filtrando dados , por favor aguarde..." )

RETURN()

/*複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  �  VldSX1  � Autor � LUIZ EDUARDO F.C.  � Data � 06/06/2017  볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     � VALIDACAO DE PERGUNTAS DO SX1                              볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�*/
Static Function VldSX1(aPergunta)

Local i
Local aAreaBKP := GetArea()

dbSelectArea("SX1")

SX1->(dbSetOrder(1))

For i := 1 To Len(aPergunta)
	SX1->(RecLock("SX1",!dbSeek(aPergunta[i,1]+aPergunta[i,2])))
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

Return(Nil)

/*複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튔un뇙o    � MarkAll  � Autor � LUIZ EDUARDO F.C.  � Data �  23/10/16   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒escri뇙o � Marca/Desmarca todos os itens do array                     볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�*/
STATIC FUNCTION MarkAll(nOpc,aAcols)

Local nX := 0

IF nOpc = 1
	For nX:=1 To Len(aAcols)
		aAcols[nX,1] := .T.
	Next
Else
	For nX:=1 To Len(aAcols)
		aAcols[nX,1] := .F.
	Next
EndIF

RETURN(aAcols)

/*複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튔un뇙o    � IMPEXCEL � Autor � LUIZ EDUARDO F.C.  � Data �  09/06/17   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒escri뇙o � IMPRIME O RELATORIO E ESXEL                                볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�*/
STATIC FUNCTION IMPEXCEL()

Local aArea     := GetArea()
Local cQuery    := "" 
Local cNomeRsp  := ""
Local cArquivo  := "" 
Local cLocal    := "C:\Analise_Entregas"
Local cWKF      := ""
Local oFWMsExcel
Local oExcel 

U_FM_Direct( cLocal, .F., .F. )

cArquivo  := cLocal + '\Analise de Entregas.xls'

// Grava o cabecalho do arquivo
IncProc("Aguarde! Gerando arquivo de integra豫o com Excel...") // "Aguarde! Gerando arquivo de integra豫o com Excel..."

cQuery := " SELECT UD_MSFIL,UC_01FIL,UD_CODIGO,UC_DATA,UC_CHAVE,A1_NOME,UD_ASSUNTO,X5_DESCRI,U9_DESC,UD_OPERADO,UD_XUSER,UD_DATA,UC_STATUS,UD_STATUS,UC_TIPO,UC_CODIGO,UD_PRODUTO,"
cQuery += " B1_DESC,UD_SOLUCAO,UC_01PED,D2_EMISSAO,DAH_XDTENT,DAH_XDESCR "
cQuery += " FROM " + RETSQLNAME("SUD") + " SUD "
cQuery += " INNER JOIN " + RETSQLNAME("SUC") + " SUC ON UC_FILIAL = UD_FILIAL "
cQuery += " AND UC_CODIGO = UD_CODIGO "
cQuery += " INNER JOIN " + RETSQLNAME("SU7") + " SU7 ON U7_COD = UC_OPERADO "
cQuery += " INNER JOIN " + RETSQLNAME("SA1") + " SA1 ON A1_COD + A1_LOJA = UC_CHAVE "
cQuery += " INNER JOIN " + RETSQLNAME("SX5") + " SX5 ON X5_CHAVE = UD_ASSUNTO "
cQuery += " INNER JOIN " + RETSQLNAME("SU9") + " SU9 ON U9_CODIGO = UD_OCORREN "
cQuery += " INNER JOIN " + RETSQLNAME("SB1") + " SB1 ON UD_PRODUTO = B1_COD "
cQuery += " LEFT JOIN "  + RETSQLNAME("SD2") + " SD2 ON D2_PEDIDO = RIGHT(UC_01PED,6) AND D2_COD = UD_PRODUTO AND SD2.D_E_L_E_T_ = ''"
cQuery += " LEFT JOIN "  + RETSQLNAME("DAI") + " DAI ON DAI_PEDIDO = D2_PEDIDO AND DAI_CLIENT = D2_CLIENTE AND DAI.D_E_L_E_T_ = ''"  
cQuery += " LEFT JOIN "  + RETSQLNAME("DAH") + " DAH ON DAH_CODCAR = DAI_COD AND DAI_CLIENT = DAH_CODCLI AND DAH.D_E_L_E_T_ = ''"
cQuery += " WHERE UD_FILIAL = '" + XFILIAL("SUD") + "' "
cQuery += " AND UC_FILIAL = '" + XFILIAL("SUC") + "' "
cQuery += " AND U7_FILIAL = '" + XFILIAL("SU7") + "' "
cQuery += " AND A1_FILIAL = '" + XFILIAL("SA1") + "' "
cQuery += " AND X5_FILIAL = '" + XFILIAL("SX5") + "' "
cQuery += " AND U9_FILIAL = '" + XFILIAL("SU9") + "' "
cQuery += " AND SUD.D_E_L_E_T_ = ' ' "
cQuery += " AND SUC.D_E_L_E_T_ = ' ' "
cQuery += " AND SU7.D_E_L_E_T_ = ' ' "
cQuery += " AND SA1.D_E_L_E_T_ = ' ' "
cQuery += " AND SX5.D_E_L_E_T_ = ' ' "
cQuery += " AND SU9.D_E_L_E_T_ = ' ' "
cQuery += " AND SB1.D_E_L_E_T_ = ' ' "
cQuery += " AND X5_TABELA = 'T1' " 
cQuery += " AND UC_DATA BETWEEN '" + DTOS(MV_PAR05) + "' AND '" + DTOS(MV_PAR06) + "' "
cQuery += " AND UC_OPERADO BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "  
cQuery += " AND UD_OPERADO BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "  
cQuery += " AND UD_MSFIL BETWEEN '" + MV_PAR11 + "' AND '" + MV_PAR12 + "' "  
cQuery += " AND UC_TIPO BETWEEN '" + MV_PAR15 + "' AND '" + MV_PAR16 + "' " 
cQuery += " AND UD_DATA BETWEEN '" + DTOS(MV_PAR18) + "' AND '" + DTOS(MV_PAR19) +"' " //#RVC20180410.n 

IF MV_PAR17 = 2
	cQuery += " AND UC_CODCANC <> ' ' " // CAMPO QUE CONTROLA CHAMADOS CANCELADOS - LUIZ EDUARDO F.C. - 03/11/2017	
ElseIF MV_PAR17 = 1
	IF MV_PAR08 <> 1
		IF MV_PAR08 = 2
		  cQuery += " AND UC_STATUS <> '3' "
		ELSE
		  cQuery += " AND UC_STATUS = '3' "
		ENDIF                               
		cQuery += " AND UC_CODCANC = ' ' "
	EndIF           
	
	IF MV_PAR09 <> 1
		IF MV_PAR09 = 2
			cQuery += " AND UD_STATUS = '1'
		Else
			cQuery += " AND UD_STATUS = '2'	
		EndIF                              
		cQuery += " AND UC_CODCANC = ' ' "
	EndIF                                  
Else
	IF MV_PAR08 <> 1
		IF MV_PAR08 = 2
		  cQuery += " AND UC_STATUS <> '3' "
		ELSE
		  cQuery += " AND UC_STATUS = '3' "
		ENDIF                               
	EndIF           
	
	IF MV_PAR09 <> 1
		IF MV_PAR09 = 2
			cQuery += " AND UD_STATUS = '1'
		Else
			cQuery += " AND UD_STATUS = '2'	
		EndIF                              
	EndIF                                  	
EndIF

IF !EMPTY(MV_PAR07)    
	//IF LEFT(MV_PAR07,10) == "'" 	//#AFD26072018.O
		cQuery += " AND UD_ASSUNTO IN (" + MV_PAR07 + ")"
	//EndIF 						//#AFD26072018.O
EndIF                 

IF !EMPTY(MV_PAR13)     
	IF LEFT(MV_PAR13,1) == "'"
		cQuery += " AND UD_OCORREN IN (" + MV_PAR13 + ")"   
	EndIF
EndIF                 

IF !EMPTY(MV_PAR14)           
	IF LEFT(MV_PAR14,1) == "'"
		cQuery += " AND UD_SOLUCAO IN (" + MV_PAR14 + ")"
	EndIF
EndIF      

cQuery += " GROUP BY UD_MSFIL,UC_01FIL,UD_CODIGO,UC_DATA,UC_CHAVE,A1_NOME,UD_ASSUNTO,X5_DESCRI,U9_DESC,UD_OPERADO,UD_XUSER,UD_DATA,UC_STATUS,UD_STATUS,UC_TIPO,UC_CODIGO,UD_PRODUTO,B1_DESC,UD_SOLUCAO,UC_01PED,D2_EMISSAO,DAH_XDTENT,DAH_XDESCR "           

IF MV_PAR10 = 1
	cQuery += " ORDER BY UD_OPERADO, UD_ASSUNTO, UC_DATA "
ElseIF MV_PAR10 = 2
	cQuery += " ORDER BY UD_ASSUNTO, UD_OPERADO, UC_DATA "
ElseIF MV_PAR10 = 3
	cQuery += " ORDER BY UC_DATA, UD_ASSUNTO, UD_OPERADO "
EndIF      
	
If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

MemoWrite("C:\memowryte\KMSACR08.TXT", cQuery)

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

//Criando o objeto que ir� gerar o conte�do do Excel
oFWMsExcel := FWMSExcel():New()
oFWMsExcel:AddworkSheet("AUD")
//Criando a Tabela
oFWMsExcel:AddTable("AUD","Analise de Entregas")
// Criando as colunas
oFWMsExcel:AddColumn("AUD","Analise de Entregas","Filial",1)
oFWMsExcel:AddColumn("AUD","Analise de Entregas","Loja",1)
oFWMsExcel:AddColumn("AUD","Analise de Entregas","N�mero Chamado",1)
oFWMsExcel:AddColumn("AUD","Analise de Entregas","Dt.Abertura",1)
oFWMsExcel:AddColumn("AUD","Analise de Entregas","Cod.Operador",1)
oFWMsExcel:AddColumn("AUD","Analise de Entregas","Operador",1)
oFWMsExcel:AddColumn("AUD","Analise de Entregas","Cod.Cliente",1)
oFWMsExcel:AddColumn("AUD","Analise de Entregas","Cliente",1)
oFWMsExcel:AddColumn("AUD","Analise de Entregas","Assunto",1) 
oFWMsExcel:AddColumn("AUD","Analise de Entregas","Ocorr�ncia",1)  
oFWMsExcel:AddColumn("AUD","Analise de Entregas","Cod.Respons�vel",1)
oFWMsExcel:AddColumn("AUD","Analise de Entregas","Respons�vel",1)
oFWMsExcel:AddColumn("AUD","Analise de Entregas","Dt.A豫o",1) 
oFWMsExcel:AddColumn("AUD","Analise de Entregas","Status Chamado",1)
oFWMsExcel:AddColumn("AUD","Analise de Entregas","Status A豫o",1)
oFWMsExcel:AddColumn("AUD","Analise de Entregas","Comunica豫o",1)
oFWMsExcel:AddColumn("AUD","Analise de Entregas","Produto",1)
oFWMsExcel:AddColumn("AUD","Analise de Entregas","Desc.Produto",1)
oFWMsExcel:AddColumn("AUD","Analise de Entregas","A豫o",1)
oFWMsExcel:AddColumn("AUD","Analise de Entregas","Pedido",1)
oFWMsExcel:AddColumn("AUD","Analise de Entregas","Faturado",1)
oFWMsExcel:AddColumn("AUD","Analise de Entregas","Entrega",1)
oFWMsExcel:AddColumn("AUD","Analise de Entregas","Observa豫o",1)

While TRB->(!EOF())    
    
	IF !EMPTY(TRB->UD_OPERADO)
		PswOrder(1)
		If PswSeek(TRB->UD_OPERADO)
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			//쿣erifica as informacoes do usuario�
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
			aUser:= PswRet(1)                                                                            
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			//� Carrega o nome do usuario 	     �
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
			cNomeRsp:= aUser[1][2]
		EndIF  
	EndIF                
	       
	IF TRB->UD_ENVWKF == "0"
		cWkf := "N�o Enviado"
	ELSEIF TRB->UD_ENVWKF == "1"
		cWkf := "Enviado"   
	ELSEIF TRB->UD_ENVWKF == "2"		
		cWkf := "Aprovado"   		
	ELSEIF TRB->UD_ENVWKF == "3"				
		cWkf := "Reprovado" 
	EndIF
				   
oFWMsExcel:AddRow("AUD","Analise de Entregas",{	TRB->UD_MSFIL,;
													TRB->UC_01FIL,;  
													TRB->UC_CODIGO,;
													DTOC(STOD(TRB->UC_DATA)),;
													TRB->UC_OPERADO,;
													TRB->U7_NREDUZ,;
													LEFT(TRB->UC_CHAVE,6) + " - " + RIGHT(ALLTRIM(TRB->UC_CHAVE),2),;
													TRB->A1_NOME,;
													TRB->X5_DESCRI,;
													TRB->U9_DESC,;
													TRB->UD_OPERADO,;
													cNomeRsp,;
													DTOC(STOD(TRB->UD_DATA)),;
													getStatusCh(TRB->UC_STATUS),;//Retorna a descri豫o do status do chamado
													IF(ALLTRIM(TRB->UD_STATUS)=="1","Pendente","Encerrada"),;
													Alltrim(POSICIONE("SUL",1,xFilial("SUL")+TRB->UC_TIPO,"UL_DESC")),;
													TRB->UD_PRODUTO,;
													TRB->B1_DESC,;
													Alltrim(POSICIONE("SUQ",1,xFilial("SUQ")+TRB->UD_SOLUCAO,"UQ_DESC")),;
													TRB->UC_01PED,;
													DTOC(STOD(TRB->D2_EMISSAO)),;
													DTOC(STOD(TRB->DAH_XDTENT)),;
													TRB->DAH_XDESCR })
													        
					                                    
	cNomeRsp := ""													    
	TRB->(DbSkip())
EndDo

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

//Ativando o arquivo e gerando o xml
oFWMsExcel:Activate()
oFWMsExcel:GetXMLFile(cArquivo)

//Abrindo o excel e abrindo o arquivo xml
oExcel := MsExcel():New()           //Abre uma nova conex�o com Excel
oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
oExcel:SetVisible(.T.)              //Visualiza a planilha
oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas

MsgInfo("Foi criado um arquivo [Analise de Entregas.xls] na pasta [C:\Resumo_Chamados_AUD]!!!")

RETURN()     


//--------------------------------------------------------------
/*/{Protheus.doc} getStatusCh
Description //Retorna a descri豫o do status do chamado
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 07/01/2019 /*/
//--------------------------------------------------------------
Static Function getStatusCh(cStatus)

	Local cStsChamado := ""
	
	Do Case
	   	Case alltrim(cStatus) == "1"
			cStsChamado := "Planejada"
	   	Case alltrim(cStatus) == "2"
		   	cStsChamado := "Pendente"
	   	Case alltrim(cStatus) == "3"
		   	cStsChamado := "Encerrado"
		Case alltrim(cStatus) == "4"
		   	cStsChamado := "Em Andamento"
		Case alltrim(cStatus) == "5"
		   	cStsChamado := "Visita Tec"
		Case alltrim(cStatus) == "6"
		   	cStsChamado := "Devolucao"
		Case alltrim(cStatus) == "7"
		   	cStsChamado := "Retorno"
		Case alltrim(cStatus) == "8"
		   	cStsChamado := "Troca Aut"
	   	Case alltrim(cStatus) == "9"
			cStsChamado := "Email Fab"
	EndCase

Return(cStsChamado)