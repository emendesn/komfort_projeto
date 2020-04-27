#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#Include "Ap5Mail.Ch"
#Include "xmlxfun.ch"
#INCLUDE "JPEG.CH"

#Define STR_PULA    Chr(13)+Chr(10)

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � KMSACR02 � Autor � LUIZ EDUARDO F.C.  � Data �  06/09/2017 ���
�������������������������������������������������������������������������͹��
���Descricao � RELATORIO DE ITENS AGENDADOS OU NAO DO SAC                 ���
�������������������������������������������������������������������������͹��
���Uso       � KOMFORT HOUSE - SAC                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
USER FUNCTION KMSACR02()

Local aPergunta := {}

Aadd(aPergunta,{PadR("KMSACR02",10),"01","Cliente de  ?" 		,"MV_CH01" 	,"C",006,00,"G","MV_PAR01",""     ,""     		,""					,"","","SA1",""	})
Aadd(aPergunta,{PadR("KMSACR02",10),"02","Cliente de  ?" 		,"MV_CH02" 	,"C",006,00,"G","MV_PAR02",""     ,""     		,""					,"","","SA1",""	})
Aadd(aPergunta,{PadR("KMSACR02",10),"03","Data Emiss�o de ?"	,"MV_CH03" 	,"D",008,00,"G","MV_PAR03",""     ,""      		,""					,"","",""	,""	})
Aadd(aPergunta,{PadR("KMSACR02",10),"04","Data Emiss�o at� ?"	,"MV_CH04" 	,"D",008,00,"G","MV_PAR04",""     ,""      		,""					,"","",""	,""	})
Aadd(aPergunta,{PadR("KMSACR02",10),"05","Data Entrega de ?"	,"MV_CH05" 	,"D",008,00,"G","MV_PAR05",""     ,""      		,""					,"","",""	,""	})
Aadd(aPergunta,{PadR("KMSACR02",10),"06","Data Entrega at� ?"	,"MV_CH06" 	,"D",008,00,"G","MV_PAR06",""     ,""      		,""					,"","",""	,""	})
Aadd(aPergunta,{PadR("KMSACR02",10),"07","Status"    			,"MV_CH07" 	,"C",001,00,"C","MV_PAR07","Todos","Agendados"	,"N�o Agendados"	,"","",""	,""	})
Aadd(aPergunta,{PadR("KMSACR02",10),"08","Loja de  ?" 			,"MV_CH08" 	,"C",004,00,"G","MV_PAR08",""     ,""         	,""					,"","","SM0",""	})
Aadd(aPergunta,{PadR("KMSACR02",10),"09","Loja at� ?" 			,"MV_CH09" 	,"C",004,00,"G","MV_PAR09",""     ,""         	,""					,"","","SM0",""	})

VldSX1(aPergunta)

If !Pergunte(aPergunta[1,1],.T.)
	Return(Nil)
EndIf

FwMsgRun( ,{|| IMPEXCEL()  }, , "Filtrando dados , por favor aguarde..." )

RETURN()

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � IMPEXCEL � Autor � LUIZ EDUARDO F.C.  � Data �  09/06/17   ���
�������������������������������������������������������������������������͹��
���Descri��o � IMPRIME O RELATORIO E ESXEL                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
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
IncProc("Aguarde! Gerando arquivo de integra��o com Excel...") // "Aguarde! Gerando arquivo de integra��o com Excel..."

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

//Criando o objeto que ir� gerar o conte�do do Excel
oFWMsExcel := FWMSExcel():New()
oFWMsExcel:AddworkSheet("SAC")
//Criando a Tabela
oFWMsExcel:AddTable("SAC","Relat�rio de Itens Agendados ou N�o")
// Criando as colunas
oFWMsExcel:AddColumn("SAC","Relat�rio de Itens Agendados ou N�o","Filial",1)
oFWMsExcel:AddColumn("SAC","Relat�rio de Itens Agendados ou N�o","Loja",1)
oFWMsExcel:AddColumn("SAC","Relat�rio de Itens Agendados ou N�o","Pedido",1)
oFWMsExcel:AddColumn("SAC","Relat�rio de Itens Agendados ou N�o","Data Emiss�o",1)
oFWMsExcel:AddColumn("SAC","Relat�rio de Itens Agendados ou N�o","C�digo Produto",1)
oFWMsExcel:AddColumn("SAC","Relat�rio de Itens Agendados ou N�o","Descri�� do Produto",1)
oFWMsExcel:AddColumn("SAC","Relat�rio de Itens Agendados ou N�o","Quantidade",1)
oFWMsExcel:AddColumn("SAC","Relat�rio de Itens Agendados ou N�o","C�digo Cliente",1)
oFWMsExcel:AddColumn("SAC","Relat�rio de Itens Agendados ou N�o","Nome Cliente",1)
oFWMsExcel:AddColumn("SAC","Relat�rio de Itens Agendados ou N�o","Data Entrega",1)
oFWMsExcel:AddColumn("SAC","Relat�rio de Itens Agendados ou N�o","Status Produto",1) 

nTotAgend := 0
nTotSem   := 0

While TRB->(!EOF())
	cGrpSB1 := Posicione("SB1",1,xFilial("SB1")+TRB->C6_PRODUTO,"B1_GRUPO")
	
	IF !(cGrpSB1 $ cGrpAces)
		oFWMsExcel:AddRow("SAC","Relat�rio de Itens Agendados ou N�o",{	TRB->C6_MSFIL,;
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

oFWMsExcel:AddRow("SAC","Relat�rio de Itens Agendados ou N�o",{"","","","","",""					,""													,"","","","" })
oFWMsExcel:AddRow("SAC","Relat�rio de Itens Agendados ou N�o",{"","","","","","TOTAIS"				,""													,"","","","" })
oFWMsExcel:AddRow("SAC","Relat�rio de Itens Agendados ou N�o",{"","","","","",""					,""													,"","","","" })
oFWMsExcel:AddRow("SAC","Relat�rio de Itens Agendados ou N�o",{	"","","","","","Itens Agendados"	,Transform(nTotAgend,"@e 9,999,999,999,9999")		,"","","","" })
oFWMsExcel:AddRow("SAC","Relat�rio de Itens Agendados ou N�o",{"","","","","",""					,""													,"","","","" })
oFWMsExcel:AddRow("SAC","Relat�rio de Itens Agendados ou N�o",{	"","","","","","Itens Sem Agendamento",Transform(nTotSem,"@e 9,999,999,999,9999")	  	,"","","","" })

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

MsgInfo("Foi criado um arquivo [Resumo de Chamados SAC.xls] na pasta [C:\REL_ITENS_AGENDADOS]!!!")

RETURN()
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �  VldSX1  � Autor � LUIZ EDUARDO F.C.  � Data �  05/01/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � VALIDACAO DE PERGUNTAS DO SX1                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
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
