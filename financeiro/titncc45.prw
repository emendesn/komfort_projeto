#include 'rwmake.ch'
#include 'protheus.ch'
#include 'topconn.ch' 
#include 'parmtype.ch'
#Include "TBICONN.CH"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ TITNCC45 ³ Marcio Nunes                  ³ Data ³ 01/04/19 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta Query para baixa de NCC >= 45 automatica              ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ KOMFORTHOUSE - Solicitante Khaled                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function TITNCC45()

Local aArea   	:= getArea()
Local cAliasQry := getNextAlias()
Local cQuery 	:= ""

Private lMsErroAuto := .F.

//Variaveis para iniciar o ambiente                        
_cEmp 	:= "01"
_cFil 	:= "0101"

//Define ambiente
RpcSetType(3)
PREPARE ENVIRONMENT EMPRESA _cEmp FILIAL _cFil MODULO "FIN"


//----------- Montagem da Query efetuar a baixa dos titulos  ------------------------------------
cQuery := "SELECT E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_BAIXA, E1_SALDO, E1_VALOR, E1_HIST, DATEDIFF(day,E1_EMISSAO,GETDATE()) AS DIFERENCA FROM "+retSqlName("SE1") 
cQuery += " WHERE E1_FILIAL='"+ xFilial("SE1") +"'"
//cQuery += " AND E1_PREFIXO='SAC' " //retirado por solicitação do Isaias
cQuery += " AND E1_TIPO='NCC' "
cQuery += " AND E1_SALDO > 0 "
cQuery += " AND (DATEDIFF(day,E1_EMISSAO,GETDATE())) >= 30"   
cQuery += " AND D_E_L_E_T_='' "

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasQry,.F.,.T.)
   		 
While !EOF()
   	aAreaTemp := (cAliasQry)->(getArea())
   	
   	DbSelectArea("SE1")
   	SE1->(dbSetorder(1))

	If SE1->(Dbseek(xFilial("SE1")+(cAliasQry)->E1_PREFIXO+(cAliasQry)->E1_NUM+(cAliasQry)->E1_PARCELA+(cAliasQry)->E1_TIPO))
        
		aTitBx :={{"E1_PREFIXO" ,SE1->E1_PREFIXO	,Nil},;
		        {"E1_NUM"      ,SE1->E1_NUM 	,Nil},;
		        {"E1_TIPO"     ,SE1->E1_TIPO	,Nil},;
	            {"E1_PARCELA"  ,SE1->E1_PARCELA	,Nil},;					           
	  			{"AUTMOTBX"    ,"DAC"          	,Nil},;
			    {"AUTBANCO"    ,""         		,Nil},;  //Dacao não tem banco         
	           	{"AUTAGENCIA"  ,""       		,Nil},;
	           	{"AUTCONTA"    ,""		    	,Nil},;
	           	{"AUTDTBAIXA"  ,Date()    		,Nil},;
	           	{"AUTDTCREDITO",Date()    		,Nil},;
	           	{"AUTHIST"     ,"BX AUTOMATICA 30 DIAS"	,Nil},;
	           	{"AUTJUROS"    ,0                      		,Nil,.T.},;
	           	{"AUTVALREC"   ,IIf (SE1->E1_SALDO >0,SE1->E1_SALDO,SE1->E1_VALOR)	,Nil}} //E1_SALDO > 0 trato a baixa parcial restante no Título
	               	           	
	    //Efetua a Baixa automatica                                                 
	    MSExecAuto({|x,y| Fina070(x,y)},aTitBx,3) 
	    
	    //Grava Historico SE1
	    RecLock("SE1", .F.)
			SE1->E1_HIST := "BX AUTOMATICA 30 DIAS" 
		SE1->(MsUnlock())                 
	    	
	    If lMsErroAuto
			MostraErro()
		Endif
	EndIf
    		
   	RestArea(aAreaTemp)
   	DbSkip()
EndDo             	
    	
lMsErroAuto := .F.
(cAliasQry)->(dbCloseArea())		
RestArea(aArea)

Return