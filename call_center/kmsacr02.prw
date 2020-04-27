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
ฑฑบPrograma  ณ KMSACR02 บ Autor ณ LUIZ EDUARDO F.C.  บ Data ณ  06/09/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ RELATORIO DE ITENS AGENDADOS OU NAO DO SAC                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ KOMFORT HOUSE - SAC                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
USER FUNCTION KMSACR02()

Local aPergunta := {}

Aadd(aPergunta,{PadR("KMSACR02",10),"01","Cliente de  ?" 		,"MV_CH01" 	,"C",006,00,"G","MV_PAR01",""     ,""     		,""					,"","","SA1",""	})
Aadd(aPergunta,{PadR("KMSACR02",10),"02","Cliente de  ?" 		,"MV_CH02" 	,"C",006,00,"G","MV_PAR02",""     ,""     		,""					,"","","SA1",""	})
Aadd(aPergunta,{PadR("KMSACR02",10),"03","Data Emissใo de ?"	,"MV_CH03" 	,"D",008,00,"G","MV_PAR03",""     ,""      		,""					,"","",""	,""	})
Aadd(aPergunta,{PadR("KMSACR02",10),"04","Data Emissใo at้ ?"	,"MV_CH04" 	,"D",008,00,"G","MV_PAR04",""     ,""      		,""					,"","",""	,""	})
Aadd(aPergunta,{PadR("KMSACR02",10),"05","Data Entrega de ?"	,"MV_CH05" 	,"D",008,00,"G","MV_PAR05",""     ,""      		,""					,"","",""	,""	})
Aadd(aPergunta,{PadR("KMSACR02",10),"06","Data Entrega at้ ?"	,"MV_CH06" 	,"D",008,00,"G","MV_PAR06",""     ,""      		,""					,"","",""	,""	})
Aadd(aPergunta,{PadR("KMSACR02",10),"07","Status"    			,"MV_CH07" 	,"C",001,00,"C","MV_PAR07","Todos","Agendados"	,"Nใo Agendados"	,"","",""	,""	})
Aadd(aPergunta,{PadR("KMSACR02",10),"08","Loja de  ?" 			,"MV_CH08" 	,"C",004,00,"G","MV_PAR08",""     ,""         	,""					,"","","SM0",""	})
Aadd(aPergunta,{PadR("KMSACR02",10),"09","Loja at้ ?" 			,"MV_CH09" 	,"C",004,00,"G","MV_PAR09",""     ,""         	,""					,"","","SM0",""	})

VldSX1(aPergunta)

If !Pergunte(aPergunta[1,1],.T.)
	Return(Nil)
EndIf

FwMsgRun( ,{|| IMPEXCEL()  }, , "Filtrando dados , por favor aguarde..." )

RETURN()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ IMPEXCEL บ Autor ณ LUIZ EDUARDO F.C.  บ Data ณ  09/06/17   บฑฑ
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
Local cLocal    := "C:\SAC"
Local oFWMsExcel
Local oExcel
Local cGrpAces	:= GetMv("KH_GRPPROD",,"2001|2002") //Grupo de Produtos que nao deverao cadastrar na tabela SBZ
Local cGrpSB1   := ""
Local nTotAgend := 0
Local nTotSem   := 0

U_FM_Direct( cLocal, .F., .F. )

cArquivo  := cLocal + '\REL_ITENS_AGENDADOS.xls'

// Grava o cabecalho do arquivo
IncProc("Aguarde! Gerando arquivo de integra็ใo com Excel...") // "Aguarde! Gerando arquivo de integra็ใo com Excel..."

cQuery := " SELECT C6_MSFIL, C5_XDESCFI, C6_NUM, C5_EMISSAO, C6_PRODUTO, C6_DESCRI, C6_QTDVEN, C6_CLI, C6_LOJA, A1_NOME, C6_ENTREG, C6_01AGEND  FROM " + RETSQLNAME("SC6") + " SC6 "
cQuery += " INNER JOIN " + RETSQLNAME("SC5") + " SC5 ON C5_FILIAL = C6_FILIAL "
cQuery += " AND C5_MSFIL = C6_MSFIL "
cQuery += " AND C5_NUM = C6_NUM "
cQuery += " AND C5_CLIENTE = C6_CLI "
cQuery += " AND C5_LOJACLI = C6_LOJA "
cQuery += " INNER JOIN " + RETSQLNAME("SA1") + " SA1 ON A1_COD = C6_CLI "
cQuery += " AND A1_LOJA = C6_LOJA "
cQuery += " WHERE C6_FILIAL <> ' ' "
cQuery += " AND SC6.D_E_L_E_T_ = ' ' "
cQuery += " AND SC5.D_E_L_E_T_ = ' ' "
cQuery += " AND SA1.D_E_L_E_T_ = ' ' "
cQuery += " AND C6_CLI BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
cQuery += " AND C5_EMISSAO BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "' "
cQuery += " AND C6_ENTREG  BETWEEN '" + DTOS(MV_PAR05) + "' AND '" + DTOS(MV_PAR06) + "' "
cQuery += " AND C6_MSFIL BETWEEN '" + MV_PAR08 + "' AND '" + MV_PAR09 + "' "
IF MV_PAR07 = 2
	cQuery += " AND C6_01AGEND = '1' "
ElseIF MV_PAR07 = 3
	cQuery += " AND C6_01AGEND = '2' "
EndIF

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

//Criando o objeto que irแ gerar o conte๚do do Excel
oFWMsExcel := FWMSExcel():New()
oFWMsExcel:AddworkSheet("SAC")
//Criando a Tabela
oFWMsExcel:AddTable("SAC","Relat๓rio de Itens Agendados ou Nใo")
// Criando as colunas
oFWMsExcel:AddColumn("SAC","Relat๓rio de Itens Agendados ou Nใo","Filial",1)
oFWMsExcel:AddColumn("SAC","Relat๓rio de Itens Agendados ou Nใo","Loja",1)
oFWMsExcel:AddColumn("SAC","Relat๓rio de Itens Agendados ou Nใo","Pedido",1)
oFWMsExcel:AddColumn("SAC","Relat๓rio de Itens Agendados ou Nใo","Data Emissใo",1)
oFWMsExcel:AddColumn("SAC","Relat๓rio de Itens Agendados ou Nใo","C๓digo Produto",1)
oFWMsExcel:AddColumn("SAC","Relat๓rio de Itens Agendados ou Nใo","Descri็๕ do Produto",1)
oFWMsExcel:AddColumn("SAC","Relat๓rio de Itens Agendados ou Nใo","Quantidade",1)
oFWMsExcel:AddColumn("SAC","Relat๓rio de Itens Agendados ou Nใo","C๓digo Cliente",1)
oFWMsExcel:AddColumn("SAC","Relat๓rio de Itens Agendados ou Nใo","Nome Cliente",1)
oFWMsExcel:AddColumn("SAC","Relat๓rio de Itens Agendados ou Nใo","Data Entrega",1)
oFWMsExcel:AddColumn("SAC","Relat๓rio de Itens Agendados ou Nใo","Status Produto",1) 

nTotAgend := 0
nTotSem   := 0

While TRB->(!EOF())
	cGrpSB1 := Posicione("SB1",1,xFilial("SB1")+TRB->C6_PRODUTO,"B1_GRUPO")
	
	IF !(cGrpSB1 $ cGrpAces)
		oFWMsExcel:AddRow("SAC","Relat๓rio de Itens Agendados ou Nใo",{	TRB->C6_MSFIL,;
		TRB->C5_XDESCFI,;
		TRB->C6_NUM,;
		DTOC(STOD(TRB->C5_EMISSAO)),;
		TRB->C6_PRODUTO,;
		TRB->C6_DESCRI,;
		Transform(TRB->C6_QTDVEN,PesqPict('SC6','C6_QTDVEN')),;
		TRB->C6_CLI + " - " + C6_LOJA,;
		TRB->A1_NOME,;
		DTOC(STOD(TRB->C6_ENTREG)),;
		IIF(TRB->C6_01AGEND == "1","AGENDADO","PENDENTE AGENDAMENTO") })
		
		IF TRB->C6_01AGEND == "1"
			nTotAgend := nTotAgend + 1
		Else
			nTotSem   := nTotSem + 1
		EndIF
		
	EndIF
	TRB->(DbSkip())
EndDo

oFWMsExcel:AddRow("SAC","Relat๓rio de Itens Agendados ou Nใo",{"","","","","",""					,""													,"","","","" })
oFWMsExcel:AddRow("SAC","Relat๓rio de Itens Agendados ou Nใo",{"","","","","","TOTAIS"				,""													,"","","","" })
oFWMsExcel:AddRow("SAC","Relat๓rio de Itens Agendados ou Nใo",{"","","","","",""					,""													,"","","","" })
oFWMsExcel:AddRow("SAC","Relat๓rio de Itens Agendados ou Nใo",{	"","","","","","Itens Agendados"	,Transform(nTotAgend,"@e 9,999,999,999,9999")		,"","","","" })
oFWMsExcel:AddRow("SAC","Relat๓rio de Itens Agendados ou Nใo",{"","","","","",""					,""													,"","","","" })
oFWMsExcel:AddRow("SAC","Relat๓rio de Itens Agendados ou Nใo",{	"","","","","","Itens Sem Agendamento",Transform(nTotSem,"@e 9,999,999,999,9999")	  	,"","","","" })

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

MsgInfo("Foi criado um arquivo [Resumo de Chamados SAC.xls] na pasta [C:\REL_ITENS_AGENDADOS]!!!")

RETURN()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ  VldSX1  บ Autor ณ LUIZ EDUARDO F.C.  บ Data ณ  05/01/17   บฑฑ
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
