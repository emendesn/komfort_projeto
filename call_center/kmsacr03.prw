#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#Include "Ap5Mail.Ch"
#Include "xmlxfun.ch"
#INCLUDE "JPEG.CH"

#Define STR_PULA    Chr(13)+Chr(10)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ KMSACR03 บ Autor ณ MURILO ZORATTI  บ Data ณ  02/01/2018   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ RELATORIO - RESUMO DE CHAMADOS                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ KOMFORT - SAC                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
USER FUNCTION KMSACR03()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cDesc1    := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2    := "de acordo com os parametros informados pelo usuario."
Local cDesc3    := ""
Local cPict     := ""
Local titulo    := "RESUMO DE CHAMADOS"
Local nLin      := 80
Local Cabec1    := "Loja             Chamado  Dt.Abertura  Operador                        Cliente                                              Assunto                          Cod.Ocorrencia     Ocorrencia          Cod.Responsavel     Responsavel          Dt.A็ใo     Status Chamado     Status A็ใo"
Local Cabec2    := ""
Local imprime   := .T.
Local aOrd      := {}
Local aPergunta := {} 

//Tk272DescUsu()                                                                                                                  

Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private nomeprog    := "KMSACR03" // Coloque aqui o nome do programa para impressao no cabecalho
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "KMSACR03" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString     := ""
Private limite      := 220
Private tamanho     := "G"
Private nTipo       := 15

Aadd(aPergunta,{PadR("KMSACR03",10),"01","Responsแvel de  ?" 	,"MV_CH1" ,"C",006,00,"G","MV_PAR01",""     ,""      ,""			,"","","USR",""				})
Aadd(aPergunta,{PadR("KMSACR03",10),"02","Responsแvel ate  ?" 	,"MV_CH2" ,"C",006,00,"G","MV_PAR02",""     ,""      ,""			,"","","USR",""				})
Aadd(aPergunta,{PadR("KMSACR03",10),"03","Operador de  ?" 		,"MV_CH3" ,"C",006,00,"G","MV_PAR03",""     ,""      ,""			,"","","SU7",""				})
Aadd(aPergunta,{PadR("KMSACR03",10),"04","Operador at้ ?" 		,"MV_CH4" ,"C",006,00,"G","MV_PAR04",""     ,""      ,""			,"","","SU7",""				})
Aadd(aPergunta,{PadR("KMSACR03",10),"05","Data Abertura de ?"	,"MV_CH5" ,"D",008,00,"G","MV_PAR05",""     ,""      ,""			,"","",""	,""   			})
Aadd(aPergunta,{PadR("KMSACR03",10),"06","Data Abertura at้ ?"	,"MV_CH6" ,"D",008,00,"G","MV_PAR06",""     ,""      ,""			,"","",""	,""   			})
Aadd(aPergunta,{PadR("KMSACR03",10),"07","Assunto  ?" 			,"MV_CH7" ,"C",050,00,"G","MV_PAR07",""     ,""      ,""			,"","",""	,"U_KMHAST()"	})
Aadd(aPergunta,{PadR("KMSACR03",10),"08","Status Chamado"  		,"MV_CH8" ,"C",001,00,"C","MV_PAR08","Todos","Aberto","Encerrada"	,"","",""	,""   			})
Aadd(aPergunta,{PadR("KMSACR03",10),"09","Status Linha"  		,"MV_CH9" ,"C",001,00,"C","MV_PAR09","Todos","Aberto","Encerrada"	,"","",""	,""   			})
Aadd(aPergunta,{PadR("KMSACR03",10),"10","Ordem"  				,"MV_CHA" ,"C",001,00,"C","MV_PAR10","Resp/Assu/Dt","Assu/Resp/Dt","Dt/Assu/Resp"	,"","","",""})
Aadd(aPergunta,{PadR("KMSACR03",10),"11","Filial de  ?" 		,"MV_CHB" ,"C",004,00,"G","MV_PAR11",""     ,""      ,""			,"","","SM0",""				})
Aadd(aPergunta,{PadR("KMSACR03",10),"12","Filial at้  ?" 		,"MV_CHC" ,"C",004,00,"G","MV_PAR12",""     ,""      ,""			,"","","SM0",""				})
Aadd(aPergunta,{PadR("KMSACR03",10),"13","Ocorr๊ncia  ?" 		,"MV_CHD" ,"C",050,00,"G","MV_PAR13",""     ,""      ,""			,"","",""	,"U_KMHOCOR()"	})
Aadd(aPergunta,{PadR("KMSACR03",10),"14","A็ใo  ?" 		    	,"MV_CHE" ,"C",050,00,"G","MV_PAR14",""     ,""      ,""			,"","",""	,"U_KMHACAO()"	})
Aadd(aPergunta,{PadR("KMSACR03",10),"15","Comunica็ใo de  ?" 	,"MV_CHF" ,"C",006,00,"G","MV_PAR15",""     ,""      ,""			,"","","SUL",""				})
Aadd(aPergunta,{PadR("KMSACR03",10),"16","Comunica็ใo at้  ?"	,"MV_CHG" ,"C",006,00,"G","MV_PAR16",""     ,""      ,""			,"","","SUL",""				})
Aadd(aPergunta,{PadR("KMSACR03",10),"17","Chamados Cancelados"  ,"MV_CHH" ,"C",001,00,"C","MV_PAR17","Nใo","Sim","Ambos"			,"","",""	,""   			})
Aadd(aPergunta,{PadR("KMSACR03",10),"18","Dt.A็ใo De ?"			,"MV_CHI" ,"D",008,00,"G","MV_PAR18",""     ,""      ,""			,"","",""	,""   			}) //#RVC20180410.n
Aadd(aPergunta,{PadR("KMSACR03",10),"19","Dt.A็ใo At้ ?"		,"MV_CHJ" ,"D",008,00,"G","MV_PAR19",""     ,""      ,""			,"","",""	,""   			}) //#RVC20180410.n

VldSX1(aPergunta)

If !Pergunte(aPergunta[1,1],.T.)
	Return(Nil)
EndIf

FwMsgRun( ,{|| IMPEXCEL()  }, , "Filtrando dados , por favor aguarde..." )

RETURN()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ  VldSX1  บ Autor ณ MURILO ZORATTI  บ Data ณ 06/06/2017  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ VALIDACAO DE PERGUNTAS DO SX1                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
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

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ MarkAll  บ Autor ณ MURILO ZORATTI  บ Data ณ  23/10/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Marca/Desmarca todos os itens do array                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
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
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ IMPEXCEL บ Autor ณ MURILO ZORATTI  บ Data ณ  09/06/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ IMPRIME O RELATORIO E ESXEL                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
STATIC FUNCTION IMPEXCEL()

Local aArea     := GetArea()
Local cQuery    := "" 
Local cNomeRsp  := ""
Local cArquivo  := "" 
Local cLocal    := "C:\Resumo_Chamados_SAC"
Local cWKF      := ""
local cXstat	:= ""
local cSatsm	:= ""
Local oFWMsExcel
Local oExcel 

U_FM_Direct( cLocal, .F., .F. )

cArquivo  := cLocal + '\Resumo de Chamados SAC.xls'

// Grava o cabecalho do arquivo
IncProc("Aguarde! Gerando arquivo de integra็ใo com Excel...") // "Aguarde! Gerando arquivo de integra็ใo com Excel..."

cQuery := " SELECT UD_MSFIL, UC_01FIL, UD_CODIGO, UC_DATA, UC_OPERADO, U7_NREDUZ, UC_CHAVE, A1_NOME, UD_ASSUNTO, X5_DESCRI, "
cQuery += " UD_OCORREN, U9_DESC, UD_OPERADO, UD_XUSER, UD_DATA, UC_STATUS, UD_STATUS, UC_TIPO, UC_CODIGO, UD_PRODUTO, UD_ITEM, UD_XCODNET, UD_SOLUCAO, "
cQuery += " UD_ENVWKF, UD_WFIDENV, UD_WFIDRET, UD_OBSWKF, UC_01PED, UC_CODCANC, UC_XTPERRO,	UC_XSATISF,	UC_XSTATUS,	FILIAL,UC_SATMOTS,UC_XFOLLOW "
cQuery += " FROM " + RETSQLNAME("SUD") + " SUD "
cQuery += " INNER JOIN " + RETSQLNAME("SUC") + " SUC ON UC_FILIAL = UD_FILIAL "
cQuery += " AND UC_CODIGO = UD_CODIGO "
cQuery += " INNER JOIN " + RETSQLNAME("SU7") + " SU7 ON U7_COD = UC_OPERADO "
cQuery += " INNER JOIN " + RETSQLNAME("SA1") + " SA1 ON A1_COD + A1_LOJA = UC_CHAVE "
cQuery += " INNER JOIN " + RETSQLNAME("SX5") + " SX5 ON X5_CHAVE = UD_ASSUNTO "
cQuery += " INNER JOIN " + RETSQLNAME("SU9") + " SU9 ON U9_CODIGO = UD_OCORREN "
cQuery += " LEFT JOIN SM0010 SM0 (NOLOCK) ON FILFULL = UC_XFILIAL"
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
cQuery += " AND X5_TABELA = 'T1' " 
cQuery += " AND UC_DATA BETWEEN '" + DTOS(MV_PAR05) + "' AND '" + DTOS(MV_PAR06) + "' "
cQuery += " AND UC_OPERADO BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "  
cQuery += " AND UD_OPERADO BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "  
cQuery += " AND UD_MSFIL BETWEEN '" + MV_PAR11 + "' AND '" + MV_PAR12 + "' "  
cQuery += " AND UC_TIPO BETWEEN '" + MV_PAR15 + "' AND '" + MV_PAR16 + "' " 
cQuery += " AND UD_DATA BETWEEN '" + DTOS(MV_PAR18) + "' AND '" + DTOS(MV_PAR19) +"' " //#RVC20180410.n 

IF MV_PAR17 = 2
	cQuery += " AND UC_CODCANC <> ' ' " // CAMPO QUE CONTROLA CHAMADOS CANCELADOS - 03/11/2017	
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

cQuery += " GROUP BY UD_MSFIL, UC_01FIL, UD_CODIGO, UC_DATA, UC_OPERADO, U7_NREDUZ, UC_CHAVE, A1_NOME, UD_ASSUNTO, X5_DESCRI, UD_OCORREN, U9_DESC, UD_OPERADO, UD_XUSER, UD_DATA, UC_STATUS, UD_STATUS, UC_TIPO, UC_CODIGO, UD_PRODUTO, UD_ITEM, UD_XCODNET, UD_SOLUCAO, UD_ENVWKF, UD_WFIDENV, UD_WFIDRET, UD_OBSWKF, UC_01PED, UC_CODCANC,UC_XTPERRO,	UC_XSATISF,	UC_XSTATUS,UC_SATMOTS,UC_XFOLLOW, FILIAL "           

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

cQuery := ChangeQuery(cQuery)


MemoWrite('\Querys\KMSACR03.sql',cQuery)

DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

//Criando o objeto que irแ gerar o conte๚do do Excel
oFWMsExcel := FWMSExcel():New()
oFWMsExcel:AddworkSheet("SAC")
//Criando a Tabela
oFWMsExcel:AddTable("SAC","Resumo Chamados do SAC")
// Criando as colunas
oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Filial",1)
oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Loja",1)
oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","N๚mero Chamado",1)
oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Dt.Abertura",1)
oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Cod.Operador",1)
oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Operador",1)
oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Cod.Cliente",1)
oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Cliente",1)
oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Cod.Assunto",1)
oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Assunto",1) 
oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Cod.Ocorr๊ncia",1)
oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Ocorr๊ncia",1)  
oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Cod.Responsแvel",1)
oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Responsแvel",1)
oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Dt.A็ใo",1) 
oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Status Chamado",1)
oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Status A็ใo",1)
oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Log.Usuแrio",1)
oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Cod.Comunica็ใo",1)
oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Comunica็ใo",1)
oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Produto",1)
oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Item",1)
oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Cod.Produto NETGERA",1)
oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Cod.A็ใo",1)
oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","A็ใo",1)
oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Status WorkFlow",1)
oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Dt.Envio WorkFlow",1)
oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Dt.Retorno WorkFlow",1)
oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","OBS WorkFlow",1)
oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Pedido NETGERA",1)
oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Cancelado",1)
oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Tipo Erro",1)
oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Satisfa็ใo",1)
oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Status PV",1)
oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Loja",1)
oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Sats. Moto",1)
oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Follow Up",1)


While TRB->(!EOF())    
    
	IF !EMPTY(TRB->UD_OPERADO)
		PswOrder(1)
		If PswSeek(TRB->UD_OPERADO)
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณVerifica as informacoes do usuarioณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			aUser:= PswRet(1)                                                                            
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Carrega o nome do usuario 	     ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			cNomeRsp:= aUser[1][2]
		EndIF  
	EndIF                
	       
	IF TRB->UD_ENVWKF == "0"
		cWkf := "Nใo Enviado"
	ELSEIF TRB->UD_ENVWKF == "1"
		cWkf := "Enviado"   
	ELSEIF TRB->UD_ENVWKF == "2"		
		cWkf := "Aprovado"   		
	ELSEIF TRB->UD_ENVWKF == "3"				
		cWkf := "Reprovado" 
	EndIF
	
	IF ALLTRIM(TRB->UC_XSATISF) == "1"
		cXstat := "ำtimo"
	ELSEIF ALLTRIM(TRB->UC_XSATISF) == "2"
		cXstat := "Bom"   
	ELSEIF ALLTRIM(TRB->UC_XSATISF) == "3"		
		cXstat := "Regular"   		
	ELSEIF ALLTRIM(TRB->UC_XSATISF) == "5"				
		cXstat := "Ruim" 
	EndIF		
	
	IF ALLTRIM(TRB->UC_SATMOTS) == "1"
		cSatsm := "ำtimo"
	ELSEIF ALLTRIM(TRB->UC_SATMOTS) == "2"
		cSatsm := "Bom"   
	ELSEIF ALLTRIM(TRB->UC_SATMOTS) == "3"		
		cSatsm := "Regular"   		
	ELSEIF ALLTRIM(TRB->UC_SATMOTS) == "4"				
		cSatsm := "Ruim" 
	EndIF					
	
	
	oFWMsExcel:AddRow("SAC","Resumo Chamados do SAC",{	TRB->UD_MSFIL,;
														TRB->UC_01FIL,;  
														TRB->UC_CODIGO,;
														DTOC(STOD(TRB->UC_DATA)),;
														TRB->UC_OPERADO,;
														TRB->U7_NREDUZ,;
													    LEFT(TRB->UC_CHAVE,6) + " - " + RIGHT(ALLTRIM(TRB->UC_CHAVE),2),;
													    TRB->A1_NOME,;
													    TRB->UD_ASSUNTO,;
													    TRB->X5_DESCRI,;
													    TRB->UD_OCORREN,;
													    TRB->U9_DESC,;
													    TRB->UD_OPERADO,;
													    cNomeRsp,;
													    DTOC(STOD(TRB->UD_DATA)),;
													    IF(ALLTRIM(TRB->UC_STATUS)=="1","Planejada",(IF(ALLTRIM(TRB->UC_STATUS)=="2","Pendente","Encerrada")) ),;
													    IF(ALLTRIM(TRB->UD_STATUS)=="1","Pendente","Encerrada"),;
													    TRB->UD_XUSER,;
													    TRB->UC_TIPO,;
													    Alltrim(POSICIONE("SUL",1,xFilial("SUL")+TRB->UC_TIPO,"UL_DESC")),;
													    TRB->UD_PRODUTO,;
													    TRB->UD_ITEM,;
													    TRB->UD_XCODNET,;
													    TRB->UD_SOLUCAO,;
													    Alltrim(POSICIONE("SUQ",1,xFilial("SUQ")+TRB->UD_SOLUCAO,"UQ_DESC")),;
													    cWkf,;           
													    DTOC(STOD(TRB->UD_WFIDENV)),;
													    DTOC(STOD(TRB->UD_WFIDRET)),;  
													    TRB->UD_OBSWKF,;
													    TRB->UC_01PED,;
													    IF(EMPTY(TRB->UC_CODCANC),"EM ABERTO","CANCELADO"),;
													    TRB->UC_XTPERRO,;
													    cXstat,;
													    TRB->UC_XSTATUS,;
													    TRB->FILIAL,;
													    cSatsm,;
													    DTOC(STOD(TRB->UC_XFOLLOW))	 })    
													    
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
oExcel := MsExcel():New()           //Abre uma nova conexใo com Excel
oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
oExcel:SetVisible(.T.)              //Visualiza a planilha
oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas 

MsgInfo("Foi criado um arquivo [Resumo de Chamados SAC.xls] na pasta [C:\Resumo_Chamados_SAC]!!!")

RETURN()     
