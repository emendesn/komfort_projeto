#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#Include "Ap5Mail.Ch"
#Include "xmlxfun.ch"
#INCLUDE "JPEG.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "FONT.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ KMFINR03 º Autor ³ LUIZ EDUARDO F.C.  º Data ³  23/01/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ IMPRESSAO DE RECIBO DE PAGAMENTO ANTECIPADO (RA)           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ KOMFORT HOUSE                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER FUNCTION KMFINR03(cTitulo,cPrexRA)

Local aPergunta := {}   

//Private	cImag001	:=	"" //U_COPYLOGO()
Private oArial43  	:=	TFont():New("Arial",,43,,.F.,,,,,.F.,.F.)
Private oArial10N	:=	TFont():New("Arial",,09,,.F.,,,,,.F.,.F.)
Private oArial12N	:=	TFont():New("Arial",,12,,.T.,,,,,.F.,.F.)
Private oArial30  	:=	TFont():New("Arial",,20,,.T.,,,,,.F.,.F.)
Private oArial11N	:=	TFont():New("Arial",,09,,.T.,,,,,.F.,.F.)
Private oPrinter  	:=	tAvPrinter():New("KMFINR03")

Default cPrexRA := SuperGetMV("KM_PREFIXO",.F.,"ADM")	//#RVC20180507.n
                                                                               
IF EMPTY(cTitulo)
//	Aadd(aPergunta,{PadR("KMFINR03",10),"01","Número RA ?","MV_CH1" ,"C",12,00,"G","MV_PAR01",""    ,""    ,"","","","SE1RA"})				//#RVC20180507.o                                                                               
	Aadd(aPergunta,{PadR("KMFINR03",10),"01","Número RA ?","MV_CH1" ,"C",09,00,"G","MV_PAR01",""    ,""    ,"","","","SE1RA","!VAZIO()",""	})		//#RVC20180507.n
	Aadd(aPergunta,{PadR("KMFINR03",10),"02","Prefixo   ?","MV_CH2" ,"C",03,00,"G","MV_PAR02",""    ,""    ,"","","",""		,"!VAZIO()","@!"})		//#RVC20180507.n 
	
	VldSX1(aPergunta)
	
	If !Pergunte(aPergunta[1,1],.T.)
		Return(Nil)
	EndIf                                                                                                                                                             
	
	DbSelectArea("SE1")
	SE1->(DbSetOrder(1))  
//	SE1->(DbSeek(xFilial("SE1") + MV_PAR01))			//#RVC20180507.o                                                                                                                	
	SE1->(DbSeek(xFilial("SE1") + MV_PAR02 + MV_PAR01))	//#RVC20180507.n                                                                                                                	
	
	//MV_PAR01                                                                     
Else
	DbSelectArea("SE1")
	SE1->(DbSetOrder(1))  
	SE1->(DbSeek(xFilial("SE1") + cPrexRA + cTitulo))                                                                                                                
EndIF

oPrinter:Setup()
oPrinter:SetPortrait()
oPrinter:StartPage()
PRINTREL()
oPrinter:Preview()

RETURN()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PRINTREL º Autor ³ LUIZ EDUARDO F.C.  º Data ³  26/01/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ FAZA IMPRESSAO DO REATORIO                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
STATIC FUNCTION PRINTREL()

Local aEmpresa := {} 
Local cQuery   := ""   
Local nValor   := 0
Local aForma   := {}
Local nLinha   := 0 
Local cImag001 	:= "C:\totvs\logo.png"
Local cImag002 	:= "C:\totvs\sofas.png"
Local cLocal    := "c:\totvs\"
//Local cData 	:= DtCerta()	//#RVC20180507.o
Local cData		:= ""
Local cTabela	:= "24"			//#RVC20180525.n
Local cChave	:= ""			//#RVC20180525.n
Local _cChave	:= ""			//#RVC20180525.n

U_FM_Direct( cLocal, .F., .F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FAZ AS COPIAS DAS IMAGENS DO SERVIDOR PARA A PASTA LOCAL³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CpyS2T("\system\logo.png",cLocal,.F.)
CpyS2T("\system\sofas.png",cLocal,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array Com Todas as Filiais.                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SM0->(DbGoTop())
While SM0->(!EOF())
	IF SM0->M0_CODFIL = SE1->E1_MSFIL
		aAdd( aEmpresa , SM0->M0_NOMECOM ) 
		aAdd( aEmpresa , SM0->M0_FILIAL  )  
		aAdd( aEmpresa , SM0->M0_ENDENT  )
		aAdd( aEmpresa , SM0->M0_CIDENT  )		
		aAdd( aEmpresa , SM0->M0_ESTENT  )		
		aAdd( aEmpresa , SM0->M0_CGC     )				
		aAdd( aEmpresa , SM0->M0_INSC    )				
		aAdd( aEmpresa , SM0->M0_TEL     )
		aAdd( aEmpresa , SM0->M0_BAIRENT )								
	EndIF
	SM0->(DbSkip())
EndDo    
                                                                
cQuery := " SELECT E1_PARCELA, E1_VALOR, E1_FORMREC, E1_01REDE, E1_01OPER, E1_01NOOPE, E1_VENCREA FROM " + RETSQLNAME("SE1")
cQuery += " WHERE E1_FILIAL = '" + XFILIAL("SE1") + "' "  
cQuery += " AND E1_MSFIL = '" + SE1->E1_MSFIL + "' " 
cQuery += " AND E1_NUM = '" + SE1->E1_NUM + "' "
cQuery += " AND E1_PREFIXO = '" + SE1->E1_PREFIXO + "' "  
cQuery += " AND E1_TIPO = '" + SE1->E1_TIPO + "' "     
cQuery += " AND E1_TIPO <> 'RA' "

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

TRB->(DbGoTop())  

nValor := 0
While TRB->(!EOF())
    aAdd( aForma , { TRB->E1_PARCELA, TRB->E1_VALOR, TRB->E1_FORMREC, TRB->E1_01REDE, TRB->E1_01OPER, TRB->E1_01NOOPE, TRB->E1_VENCREA } ) 
	nValor := nValor + TRB->E1_VALOR
	TRB->(DbSkip())
EndDo    

DbSelectArea("SA1")
SA1->(DbSetOrder(1))
SA1->(DbSeek(xFilial("SA1") + SE1->E1_CLIENTE + SE1->E1_LOJA))   

oPrinter:SayBitMap(0060,0098,cImag001,0268,0157)
oPrinter:Say(0088,0095,"____________________________",oArial43,,0)
oPrinter:Say(0097,0529,ALLTRIM(aEmpresa[1]) + "   Loja " + ALLTRIM(aEmpresa[2]) + "   CNPJ - " + Transform(ALLTRIM(aEmpresa[6]),"@R 99.999.999/9999-99") + "   IE - " + ALLTRIM(aEmpresa[7]),oArial10N,,0)
//oPrinter:Say(0162,0529,"Rua " + ALLTRIM(aEmpresa[3]) + " , " + ALLTRIM(aEmpresa[9]) + " , " + ALLTRIM(aEmpresa[4]) + " - " + ALLTRIM(aEmpresa[5]) + "     Telefone : " + ALLTRIM(aEmpresa[8]) ,oArial10N,,0)	//#RVC20180507.o
oPrinter:Say(0162,0529,ALLTRIM(aEmpresa[3]) + " , " + ALLTRIM(aEmpresa[9]) + " , " + ALLTRIM(aEmpresa[4]) + " - " + ALLTRIM(aEmpresa[5]) + "     Telefone : " + ALLTRIM(aEmpresa[8]) ,oArial10N,,0)				//#RVC20180507.n

cData := DtCerta(SE1->E1_EMISSAO)	//#RVC20180507.n

oPrinter:Say(0282,0095,cData,oArial12N,,0)

oPrinter:Say(0375,0600,"Recibo de Pagamento Antecipado",oArial30,,0)  
//oPrinter:Say(0475,0600,"Título : " + SE1->E1_NUM +" / RA" ,oArial11N,,0) //AFD20180424.o
oPrinter:Say(0475,0600,"Título : " + SE1->E1_NUM + " / Prefixo: "+ SE1->E1_PREFIXO +" / RA" ,oArial11N,,0)//AFD20180424.n

oPrinter:Say(0630,0095,"Recebemos de " + ALLTRIM(SA1->A1_NOME) + " , portador do RG " + ALLTRIM(SA1->A1_PFISICA),oArial11N,,0)
oPrinter:Say(0680,0095,"e do CPF " + Transform(ALLTRIM(SA1->A1_CGC),"@R 999.999.999-99") + " , a importancia de R$ " + ALLTRIM(Transform(nValor,PesqPict('SE1','E1_VALOR'))) + " como parte de pagamento de venda futura.",oArial11N,,0)

oPrinter:Say(0780,0095,"Forma(s) de Pagamento: ",oArial11N,,0)  

//nLinha := 900 //AFD20180424.o
nLinha := 850 //AFD20180424.n
For nX:=1 To Len(aForma)
	//#RVC20180524.bn
	cChave 	:= ALLTRIM(aForma[nX,3])
	_cChave := ALLTRIM(aForma[nX,6])
	If aForma[nX][3] $ "CH|CHT|CHK|BO|BOL|BST" //Todas as possibilidades de Boleto ou Cheque.
		oPrinter:Say(nLinha,0095,;
		"Parcela " + ALLTRIM(aForma[nX,1]) + ;																//Parcela
		" no valor de R$ " + ALLTRIM(Transform(aForma[nX,2],PesqPict('SE1','E1_VALOR'))) + ; 				//Valor
		" em " + Capital(Alltrim(GetAdvFVal("SX5","X5_DESCRI",xFilial("SX5") + cTabela + cChave, 1, _cChave))) + ;	//Tipo 
		" e com venc. em " + DTOC(STOD(aForma[nX,7])),oArial11N,,0)											//Vencimento
//    	nLinha := nLinha + 75 //AFD20180424.o
    	nLinha := nLinha + 65 //AFD20180424.n
   Else
//    	oPrinter:Say(nLinha,0095,ALLTRIM(aForma[nX,1]) + ") - R$ " + ALLTRIM(Transform(aForma[nX,2],PesqPict('SE1','E1_VALOR'))) + " - " + ALLTRIM(aForma[nX,3]) + " - " + ALLTRIM(aForma[nX,6]) + " - Vcto. " + DTOC(STOD(aForma[nX,7])),oArial11N,,0) //#RVC20180524.o
		//#RVC20180524.bn
		oPrinter:Say(nLinha,0095,;
		"Parcela " + ALLTRIM(aForma[nX,1]) + ;																		//Parcela
		" no valor de R$ " + ALLTRIM(Transform(aForma[nX,2],PesqPict('SE1','E1_VALOR'))) + ; 						//Valor
		" em " + Capital(Alltrim(GetAdvFVal("SX5","X5_DESCRI",xFilial("SX5") + cTabela + cChave, 1, _cChave))),oArial11N,,0)	//Tipo
		//#RVC20180524.en 
//    	nLinha := nLinha + 75 //AFD20180424.o
    	nLinha := nLinha + 65 //AFD20180424.n
	EndIf
	//#RVC20180524.en
	/*
	oPrinter:Say(nLinha,0095,ALLTRIM(aForma[nX,1]) + ") - R$ " + ALLTRIM(Transform(aForma[nX,2],PesqPict('SE1','E1_VALOR'))) + " - " + ALLTRIM(aForma[nX,3]) + " - " + ALLTRIM(aForma[nX,6]) + " - Vcto. " + DTOC(STOD(aForma[nX,7])),oArial11N,,0)
//    nLinha := nLinha + 75 //AFD20180424.o
    nLinha := nLinha + 65 //AFD20180424.n
    */
Next

//oPrinter:Say(0900,1300,"Assinatura:______________________________",oArial11N,,0)//AFD20180424.o
//oPrinter:Say(1200,1300,"Nome:__________________________________",oArial11N,,0)//AFD20180424.o
//oPrinter:Say(1500,1300,"R.G.:____________________________________",oArial11N,,0)//AFD20180424.o

//oPrinter:Say(0850,1300,"Assinatura:______________________________",oArial11N,,0)//AFD20180424.n	//#RVC20180608.o
//oPrinter:Say(0950,1300,"Nome:__________________________________",oArial11N,,0)//AFD20180424.n		//#RVC20180608.o
//oPrinter:Say(1050,1300,"R.G.:____________________________________",oArial11N,,0)//AFD20180424.n	//#RVC20180608.o

oPrinter:Say(0850,1600,"Assinatura:____________________________",oArial11N,,0)	//#RVC20180608.n
oPrinter:Say(0950,1600,"Nome:__________________________________",oArial11N,,0)	//#RVC20180608.n
oPrinter:Say(1050,1600,"R.G.:__________________________________",oArial11N,,0)	//#RVC20180608.n

oPrinter:Say(1650,0000,"--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------",oArial11N,,0)

oPrinter:SayBitMap(1800,0098,cImag001,0268,0157)    
oPrinter:Say(1830,0095,"____________________________",oArial43,,0) 
oPrinter:Say(1840,0529,ALLTRIM(aEmpresa[1]) + "   Loja " + ALLTRIM(aEmpresa[2]) + "   CNPJ " + Transform(ALLTRIM(aEmpresa[6]),"@R 99.999.999/9999-99") + "   IE " + ALLTRIM(aEmpresa[7]),oArial10N,,0)
//oPrinter:Say(1905,0529,"Rua " + ALLTRIM(aEmpresa[3]) + " , " + ALLTRIM(aEmpresa[9]) + " , " + ALLTRIM(aEmpresa[4]) + " - " + ALLTRIM(aEmpresa[5]) + "     Telefone : " + ALLTRIM(aEmpresa[8]),oArial10N,,0)	//#RVC20180507.o
oPrinter:Say(1905,0529,ALLTRIM(aEmpresa[3]) + " , " + ALLTRIM(aEmpresa[9]) + " , " + ALLTRIM(aEmpresa[4]) + " - " + ALLTRIM(aEmpresa[5]) + "     Telefone : " + ALLTRIM(aEmpresa[8]),oArial10N,,0)				//#RVC20180507.n

cData := DtCerta(SE1->E1_EMISSAO)	//#RVC20180507.n

oPrinter:Say(2025,0095,cData,oArial12N,,0)   

oPrinter:Say(2118,0600,"Recibo de Pagamento Antecipado",oArial30,,0)                                                
//oPrinter:Say(2218,0600,"Título : " + SE1->E1_NUM + " / RA" ,oArial11N,,0) //AFD20180424.o
oPrinter:Say(2218,0600,"Título : " + SE1->E1_NUM + " / Prefixo: "+ SE1->E1_PREFIXO +" / RA" ,oArial11N,,0) //AFD20180424.n

oPrinter:Say(2373,0095,"Recebemos de " + ALLTRIM(SA1->A1_NOME) + " , portador do RG " + ALLTRIM(SA1->A1_PFISICA),oArial11N,,0) 
oPrinter:Say(2423,0095,"e do CPF " + Transform(ALLTRIM(SA1->A1_CGC),"@R 999.999.999-99") + " , a importância de R$ " + ALLTRIM(Transform(nValor,PesqPict('SE1','E1_VALOR'))) + " como parte de pagamento de venda futura.",oArial11N,,0)
oPrinter:Say(2523,0095,"Forma de Pagamento: ",oArial11N,,0) 

//nLinha := 2643 //AFD20180424.o
nLinha := 2600 //AFD20180424.n
For nX:=1 To Len(aForma)
	//#RVC20180524.bn
	cChave 	:= ALLTRIM(aForma[nX,3])
	_cChave := ALLTRIM(aForma[nX,6])
	If aForma[nX][3] $ "CH|CHT|CHK|BO|BOL|BST" //Todas as possibilidades de Boleto ou Cheque.
		oPrinter:Say(nLinha,0095,;
		"Parcela " + ALLTRIM(aForma[nX,1]) + ;																		//Parcela
		" no valor de R$ " + ALLTRIM(Transform(aForma[nX,2],PesqPict('SE1','E1_VALOR'))) + ; 						//Valor
		" em " + Capital(Alltrim(GetAdvFVal("SX5","X5_DESCRI",xFilial("SX5") + cTabela + cChave, 1, _cChave))) + ;	//Tipo 
		" e com venc. em " + DTOC(STOD(aForma[nX,7])),oArial11N,,0)													//Vencimento
//    	nLinha := nLinha + 75 //AFD20180424.o
    	nLinha := nLinha + 65 //AFD20180424.n   
    Else
//    	oPrinter:Say(nLinha,0175,ALLTRIM(aForma[nX,1]) + ") - R$ " + ALLTRIM(Transform(aForma[nX,2],PesqPict('SE1','E1_VALOR'))) + " - " + ALLTRIM(aForma[nX,3]) + " - " + ALLTRIM(aForma[nX,6]) + " - Vcto. " + DTOC(STOD(aForma[nX,7])),oArial11N,,0) //#RVC20180524.o
		//#RVC20180524.bn
		oPrinter:Say(nLinha,0095,;
		"Parcela " + ALLTRIM(aForma[nX,1]) + ;																		//Parcela
		" no valor de R$ " + ALLTRIM(Transform(aForma[nX,2],PesqPict('SE1','E1_VALOR'))) + ; 						//Valor
		" em " + Capital(Alltrim(GetAdvFVal("SX5","X5_DESCRI",xFilial("SX5") + cTabela + cChave, 1, _cChave))),oArial11N,,0)	//Tipo
		//#RVC20180524.en 
//    	nLinha := nLinha + 75 //AFD20180424.o
    	nLinha := nLinha + 65 //AFD20180424.n
	EndIf
	//#RVC20180524.en
/*	oPrinter:Say(nLinha,0175,ALLTRIM(aForma[nX,1]) + ") - R$ " + ALLTRIM(Transform(aForma[nX,2],PesqPict('SE1','E1_VALOR'))) + " - " + ALLTRIM(aForma[nX,3]) + " - " + ALLTRIM(aForma[nX,6]) + " - Vcto. " + DTOC(STOD(aForma[nX,7])),oArial11N,,0)
//    nLinha := nLinha + 75 //AFD20180424.o 
    nLinha := nLinha + 65 //AFD20180424.n*/
Next

//oPrinter:Say(2643,1300,"Assinatura:____________________________",oArial11N,,0)//AFD20180424.o 
//oPrinter:Say(2943,1300,"Nome:__________________________________",oArial11N,,0)//AFD20180424.o 
//oPrinter:Say(3243,1300,"R.G.:__________________________________",oArial11N,,0)//AFD20180424.o 

//oPrinter:Say(2600,1300,"Assinatura:____________________________",oArial11N,,0)//AFD20180424.n	//#RVC20180608.o
//oPrinter:Say(2700,1300,"Nome:__________________________________",oArial11N,,0)//AFD20180424.n	//#RVC20180608.o
//oPrinter:Say(2800,1300,"R.G.:__________________________________",oArial11N,,0)//AFD20180424.n	//#RVC20180608.o

oPrinter:Say(2600,1600,"Assinatura:____________________________",oArial11N,,0)	//#RVC20180608.n
oPrinter:Say(2700,1600,"Nome:__________________________________",oArial11N,,0)	//#RVC20180608.n
oPrinter:Say(2800,1600,"R.G.:__________________________________",oArial11N,,0)	//#RVC20180608.n

RETURN()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³  DtCerta º Autor ³ Rafael Cruz        º Data ³  20/03/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ VALIDACAO DE DATA                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function DtCerta(dData)

Local cData 
//Local cWeekend	:= 'Sabado|Domingo'		//#RVC20180702.o
Local cWeekend	:= 'Sábado|Sabado|Domingo'	//#RVC20180702.n

Default	cData := Date()

//If (DiaSemana(dData) $ cWeekend)			//#RVC20180702.o
If (Alltrim(DiaSemana(dData)) $ cWeekend)	//#RVC20180702.n
	cData := (Alltrim(DiaSemana(dData)) + ", " + Alltrim(Str(Day(dData))) + " de " + MesExtenso(dData) + " de " + alltrim(str(year(dData))) + ".")
Else 
	cData := (Alltrim(DiaSemana(dData)) + "-feira, " + Alltrim(Str(Day(dData))) + " de " + MesExtenso(dData) + " de " + alltrim(str(year(dData))) + ".")
EndIf

Return cData

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³  VldSX1  º Autor ³ LUIZ EDUARDO F.C.  º Data ³  05/01/17   º±±
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
	SX1->X1_VALID		:= aPergunta[i,16]	//#RVC20180507.n
	SX1->X1_PICTURE		:= aPergunta[i,17]	//#RVC20180511.n
	SX1->(MsUnlock())
Next i

RestArea(aAreaBKP)

Return(Nil)