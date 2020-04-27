#Include "Protheus.ch"
#Include "RwMake.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ KMSACC01 ºAutor  ³ LUIZ EDUARDO F.C.  º Data ³ 09/10/2017  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ TELA DE CONSULTA DE CHAMADOS - SAC    					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ KOMFORT HOUSE                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER FUNCTION KMSACC01()

Local cQuery    := ""    
Local aPergunta := {}

Aadd(aPergunta,{PadR("KMSACC01",10),"01","Filial de  ?" 			,"MV_CH01" ,"C",004,00,"G","MV_PAR01",""     ,""      ,""			,"","","SM0",""			})
Aadd(aPergunta,{PadR("KMSACC01",10),"02","Filial até  ?" 			,"MV_CH02" ,"C",004,00,"G","MV_PAR02",""     ,""      ,""			,"","","SM0",""			})
Aadd(aPergunta,{PadR("KMSACC01",10),"03","Data Abertura de ?"		,"MV_CH03" ,"D",008,00,"G","MV_PAR03",""     ,""      ,""			,"","",""	,""   		})
Aadd(aPergunta,{PadR("KMSACC01",10),"04","Data Abertura até ?"		,"MV_CH04" ,"D",008,00,"G","MV_PAR04",""     ,""      ,""			,"","",""	,""   		})
Aadd(aPergunta,{PadR("KMSACC01",10),"05","Número de  ?" 			,"MV_CH05" ,"C",006,00,"G","MV_PAR05",""     ,""      ,""			,"","","",""			})
Aadd(aPergunta,{PadR("KMSACC01",10),"06","Número até  ?" 			,"MV_CH06" ,"C",006,00,"G","MV_PAR06",""     ,""      ,""			,"","","",""			})
Aadd(aPergunta,{PadR("KMSACC01",10),"07","Pedido de  ?" 			,"MV_CH07" ,"C",006,00,"G","MV_PAR07",""     ,""      ,""			,"","","",""			})
Aadd(aPergunta,{PadR("KMSACC01",10),"08","Pedido até  ?" 			,"MV_CH08" ,"C",006,00,"G","MV_PAR08",""     ,""      ,""			,"","","",""			})
Aadd(aPergunta,{PadR("KMSACC01",10),"09","CPF/CNPJ Cliente de ?" 	,"MV_CH09" ,"C",014,00,"G","MV_PAR09",""     ,""      ,""			,"","","",""			})
Aadd(aPergunta,{PadR("KMSACC01",10),"10","CPF/CNPJ Cliente até ?" 	,"MV_CH10" ,"C",014,00,"G","MV_PAR10",""     ,""      ,""			,"","","",""			})
Aadd(aPergunta,{PadR("KMSACC01",10),"11","CPF/CNPJ Contato de ?" 	,"MV_CH11" ,"C",014,00,"G","MV_PAR11",""     ,""      ,""			,"","","",""			})
Aadd(aPergunta,{PadR("KMSACC01",10),"12","CPF/CNPJ Contato até ?" 	,"MV_CH12" ,"C",014,00,"G","MV_PAR12",""     ,""      ,""			,"","","",""			})

VldSX1(aPergunta)

If !Pergunte(aPergunta[1,1],.T.)
	Return(Nil)
EndIf

FwMsgRun( ,{|| FILDADOS()  }, , "Filtrando dados , por favor aguarde..." )

RETURN()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³  VldSX1  º Autor ³ LUIZ EDUARDO F.C.  º Data ³ 06/06/2017  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ VALIDACAO DE PERGUNTAS DO SX1                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FILDADOS ºAutor  ³ LUIZ EDUARDO F.C.  º Data ³ 09/10/2017  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ FILTRA OS DADOS DE ACORDO COM OS PARAMETROS INFORMADOS	  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
STATIC FUNCTION FILDADOS()

Local cQuery   := ""  
Local aDados   := {} 
Local aButtons := {} 
Local aSize    := MsAdvSize()
Local aArea    := GetArea()
Local oDlg, oBrw             

Private oSt1     := LoadBitmap(GetResources(),'BR_AZUL')  
Private oSt2     := LoadBitmap(GetResources(),'BR_VERDE') 
Private oSt3     := LoadBitmap(GetResources(),'BR_VERMELHO')          

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz o calculo automatico de dimensoes de objetos     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AAdd(aButtons,{	'',{|| VisualSUC(aDados[oBrw:nAt])  }, "Visualizar Chamado SAC "} )   

cQuery := " SELECT UC_STATUS, UC_MSFIL, UC_01FIL, UC_CODIGO, UC_DATA, UC_CODCONT, U5_CONTAT, U5_CPF, UC_CHAVE, A1_NOME, A1_CGC, UC_OPERADO, U7_NOME, UC_01PED FROM " + RETSQLNAME("SUC") + " SUC "
cQuery += " INNER JOIN " + RETSQLNAME("SA1") + " SA1 ON A1_COD + A1_LOJA = UC_CHAVE "
cQuery += " INNER JOIN " + RETSQLNAME("SU7") + " SU7 ON U7_COD = UC_OPERADO "
cQuery += " INNER JOIN " + RETSQLNAME("SU5") + " SU5 ON U5_CODCONT = UC_CODCONT "
cQuery += " WHERE UC_FILIAL = '" + XFILIAL("SUC") + "' "
cQuery += " AND A1_FILIAL = '" + XFILIAL("SA1") + "' "
cQuery += " AND U7_FILIAL = '" + XFILIAL("SU7") + "' "
cQuery += " AND U5_FILIAL = '" + XFILIAL("SU5") + "' "
cQuery += " AND SUC.D_E_L_E_T_ = ' ' "
cQuery += " AND SA1.D_E_L_E_T_ = ' ' "
cQuery += " AND SU7.D_E_L_E_T_ = ' ' "
cQuery += " AND SU5.D_E_L_E_T_ = ' ' "    
cQuery += " AND UC_MSFIL BETWEEN  '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
cQuery += " AND UC_DATA BETWEEN   '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "' "
cQuery += " AND UC_CODIGO BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
cQuery += " AND UC_01PED BETWEEN  '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' "
cQuery += " AND A1_CGC BETWEEN    '" + MV_PAR09 + "' AND '" + MV_PAR10 + "' "
cQuery += " AND U5_CPF BETWEEN    '" + MV_PAR11 + "' AND '" + MV_PAR12 + "' "   
cQuery += " ORDER BY UC_DATA "

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

While TRB->(!EOF())
	aAdd( aDados, { TRB->UC_MSFIL, TRB->UC_01FIL, TRB->UC_CODIGO, TRB->UC_DATA, TRB->UC_CODCONT, TRB->U5_CONTAT, TRB->U5_CPF, TRB->UC_CHAVE, TRB->A1_NOME, TRB->A1_CGC, TRB->UC_OPERADO, TRB->U7_NOME, TRB->UC_01PED, TRB->UC_STATUS } )
	TRB->(!DbSkip())
EndDo               

IF Len(aDados) = 0
	MsgInfo("Não foram encontradas informações com os parametros informado!")
	RETURN()
EndIF         

DEFINE MSDIALOG oDlg TITLE "TELA DE CONSULTA DE CHAMADOS - SAC" FROM 0,0 TO aSize[6],aSize[5] OF oMainWnd PIXEL

oBrw:= TwBrowse():New(0,0,0,0,, {'','Filial','Chamado','Dt.Abertura','Contato','CPF/CNPJ Contato','Cliente','CPF/CNJP Cliente','Operador','Pedido'},,oDlg,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
oBrw:SetArray(aDados)
oBrw:bLine := {|| { 	IF( ALLTRIM(aDados[oBrw:nAt,14])=="1",oSt1,IF(ALLTRIM(aDados[oBrw:nAt,14])=="2",oSt3,oSt2))                              ,;                             
						aDados[oBrw:nAt,01] + " - " +  aDados[oBrw:nAt,02]	 																		,;
						aDados[oBrw:nAt,03] 																										,;
						DTOC(STOD(aDados[oBrw:nAt,04])) 																							,;
						"( " + aDados[oBrw:nAt,05] + " ) " +  aDados[oBrw:nAt,06] 																	,;
						aDados[oBrw:nAt,07] 																										,;								
						"( " + LEFT(aDados[oBrw:nAt,08],6) + "-" + RIGHT(ALLTRIM(aDados[oBrw:nAt,08]),2) + " ) " + ALLTRIM(aDados[oBrw:nAt,09])	,;
						aDados[oBrw:nAt,10] 																										,;								
						"( " + aDados[oBrw:nAt,11] + " ) " + aDados[oBrw:nAt,12] 																	,;																
						aDados[oBrw:nAt,13] 																										}}
oBrw:Align:= CONTROL_ALIGN_ALLCLIENT
oBrw:bLDblClick := {|| VisualSUC(aDados[oBrw:nAt])  }

ACTIVATE MSDIALOG oDlg CENTERED ON INIT ( EnchoiceBar(oDlg,{|| oDlg:End() }, {||  oDlg:End() },,aButtons) ) 

RestArea(aArea)

RETURN()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VisualSUC  º Autor ³ Eduardo Patriani   º Data ³  05/06/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ VISUALIZA O CHAMADO DO PEDIDO.         		                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/                                 `
Static Function VisualSUC( aDados )

Local nRecno 	:= 0

aRotina			:= {{ "Pesquisar","AxPesqui" 			,0,1 },;
					{ "Visualizar","AxVisual"   		,0,2 },;
					{ "Chamadas","TK271CallCenter"		,0,3 } }

INCLUI 			:= .F.

DbSelectArea("SUC")
DbSetOrder(1)
DbSeek(xFilial("SUC") + aDados[3] )
nRecno := SUC->(Recno())

TK271CallCenter("SUC",nRecno,2)

Return