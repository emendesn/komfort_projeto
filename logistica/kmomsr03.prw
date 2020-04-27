#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � KMOMSR03 �Autor  � LUIZ EDUARDO F.C.  � Data � 28/06/2017  ���
�������������������������������������������������������������������������͹��
���Desc.     � IMPRESSAO - TERMO DE RETIRA           					  ���
�������������������������������������������������������������������������͹��
���Uso       � KOMFORT HOUSE                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
USER FUNCTION KMOMSR03(aDados)                                                                                    

Local cFileSave	:= ''
Local nLastKey  := 0
Local cPedido  := ""
Local cCliente := ""
Local dData    := ""
Local cProduto := "" 
Local cTermo   := "" 
Local cDefeito := ""
Local cObs     := "" 
Local cLocal   := "C:\TERMO RETIRA"
Local cOpc     := ""
Local cDevo    := "" 

Private cPathSrv	:= "\modelos\"
Private cPathTer	:= "c:\modelos\"
Private cArquivo 	:= "retira.dotx"
Private aItens	 	:= {}
Private aInfo       := {}
Private oWord 		:= Nil

U_FM_Direct( cLocal, .F., .F. )

/*+--------------+
| Cria Diret�rio |
+----------------+*/
MakeDir(Trim(cPathTer))

If !File(cPathSrv+cArquivo) // Verifica a existencia do DOT no ROOTPATH Protheus / Servidor
	MsgStop( "O arquivo n�o foi encontrado no Servidor.","Aten��o" )
	Return
EndIf

/*+---------------------------------------------+
| Apaga o arquivo caso j� exista no diret�rio |
+---------------------------------------------+*/
If File(cPathTer+cArquivo)
	FErase(cPathTer+cArquivo)
Endif

CpyS2T(cPathSrv+cArquivo,cPathTer,.T.)

If nLastKey == 27
	Return
Endif               

cPedido  := SUBSTR(aDados[4],5,6) 
cCliente := aDados[8] + "CPF/CNPJ - " + ALLTRIM(POSICIONE("SA1",1,XFILIAL("SA1") + aDados[6] + aDados[7],"A1_CGC"))
cTermo   := " - " + aDados[19] + "     Num.Chamado SAC - " + aDados[22] 
dData    := dDataBase
cProduto := "Cod." + aDados[20] + " - " + aDados[21] 
cDefeito := ALLTRIM(POSICIONE("ZK0",5,XFILIAL("ZK0") + aDados[22],"ZK0_DEFEIT"))
cObs     := ALLTRIM(POSICIONE("ZK0",5,XFILIAL("ZK0") + aDados[22],"ZK0_OBSSAC"))
cOpc     := ALLTRIM(POSICIONE("ZK0",5,XFILIAL("ZK0") + aDados[22],"ZK0_OPCTP"))
cDevo    := ALLTRIM(POSICIONE("ZK0",5,XFILIAL("ZK0") + aDados[22],"ZK0_TPDEV")) 

/*+---------------------------------------------+
| Inicializa o Ole com o MS-Word 97 ( 8.0 )   |
+---------------------------------------------+*/
BeginMsOle()
oWord := OLE_CreateLink()                                                                                  
OLE_NewFile(oWord,cPathTer+cArquivo)

OLE_SetDocumentVar(oWord, 'cPedido'		, cPedido )
OLE_SetDocumentVar(oWord, 'cCliente'	, cCliente	)
OLE_SetDocumentVar(oWord, 'cProduto'	, cProduto	)
OLE_SetDocumentVar(oWord, 'cTermo'		, cTermo	)
OLE_SetDocumentVar(oWord, 'dData'	    , ""	)
OLE_SetDocumentVar(oWord, 'cDefeito' 	, cDefeito	)
OLE_SetDocumentVar(oWord, 'cObs'	    , cObs	)       

IF cOpc == "1"
	OLE_SetDocumentVar(oWord, 'cx1'	    , "X" )       
	OLE_SetDocumentVar(oWord, 'cx2'	    , " " )       
	OLE_SetDocumentVar(oWord, 'cx3'	    , " " )       
	OLE_SetDocumentVar(oWord, 'cx4'	    , " " )       
	OLE_SetDocumentVar(oWord, 'cx5'	    , " " )       
ElseIF cOpc == "2"
	OLE_SetDocumentVar(oWord, 'cx1'	    , " " )       
	OLE_SetDocumentVar(oWord, 'cx2'	    , "X" )       
	OLE_SetDocumentVar(oWord, 'cx3'	    , " " )       
	OLE_SetDocumentVar(oWord, 'cx4'	    , " " )   
	OLE_SetDocumentVar(oWord, 'cx5'	    , " " )       	    
ElseIF cOpc == "3"
	OLE_SetDocumentVar(oWord, 'cx1'	    , " " )       
	OLE_SetDocumentVar(oWord, 'cx2'	    , " " )       
	OLE_SetDocumentVar(oWord, 'cx3'	    , "X" )       
	OLE_SetDocumentVar(oWord, 'cx4'	    , " " )
	OLE_SetDocumentVar(oWord, 'cx5'	    , " " )       	       
ElseIF cOpc == "4"
	OLE_SetDocumentVar(oWord, 'cx1'	    , " " )       
	OLE_SetDocumentVar(oWord, 'cx2'	    , " " )       
	OLE_SetDocumentVar(oWord, 'cx3'	    , " " )       
	OLE_SetDocumentVar(oWord, 'cx4'	    , "X" )       
	OLE_SetDocumentVar(oWord, 'cx5'	    , " " )       	
ElseIF cOpc == "5" 
	OLE_SetDocumentVar(oWord, 'cx1'	    , " " )       
	OLE_SetDocumentVar(oWord, 'cx2'	    , " " )       
	OLE_SetDocumentVar(oWord, 'cx3'	    , " " )       
	OLE_SetDocumentVar(oWord, 'cx4'	    , " " )       
	OLE_SetDocumentVar(oWord, 'cx5'	    , "X" )       	
Else
	OLE_SetDocumentVar(oWord, 'cx1'	    , " " )       
	OLE_SetDocumentVar(oWord, 'cx2'	    , " " )       
	OLE_SetDocumentVar(oWord, 'cx3'	    , " " )       
	OLE_SetDocumentVar(oWord, 'cx4'	    , " " )       
	OLE_SetDocumentVar(oWord, 'cx5'	    , " " )       		
EndIF                                          

IF cDevo == "1"
	OLE_SetDocumentVar(oWord, 'cDev1'   , "X" )       
	OLE_SetDocumentVar(oWord, 'cDev2'   , " " )       
ElseIF cDevo == "2"
	OLE_SetDocumentVar(oWord, 'cDev1'   , " " )       
	OLE_SetDocumentVar(oWord, 'cDev2'   , "X" )       
Else
	OLE_SetDocumentVar(oWord, 'cDev1'   , " " )       
	OLE_SetDocumentVar(oWord, 'cDev2'   , " " )       	
EndIF

OLE_UpDateFields(oWord)

cFileSave := cLocal + "\TERMO RETIRA_"+aDados[19]+".docx"
OLE_SaveAsFile( oWord,cFileSave )

OLE_CloseLink( oWord ) // Encerra link

Sleep(2000)
ShellExecute('Open',cFileSave,'','',1) 

MsgInfo("Foi criado um arquivo [TERMO RETIRA_"+aDados[19]+".docx] na pasta [" + cLocal + "]!!!")

RETURN()