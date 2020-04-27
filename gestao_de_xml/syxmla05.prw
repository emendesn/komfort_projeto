#Include "PROTHEUS.CH"
#Include 'Ap5Mail.Ch'
#Define GD_INSERT 1
#Define GD_UPDATE 2
#Define GD_DELETE 4

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  º SYXMLA05 º Autor º LUIZ EDUARDO F.C.  º Data ³  08/08/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObjetivo  ³ CRIA AUTOMATICAMENTE A PRE-NOTA DE ENTRADA                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GESTOR DE XML                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER FUNCTION SYXMLA05(cChvNF)

Local cQry   := ""
Local nOpc   := 0
Local aTipoNF   := IIF(lCLIENTE,{'B = BENEFICIAMENTO' , 'D = DEVOLUÇÃO'},{'N = NORMAL' , 'C = COMPLEMENTO DE PRECO/FRETE'})
Local aFormul   := {'S= SIM' , 'N = NAO'}
Local oDlgTp, oCmbNF, oCmbFor      

Private aCabec:= {}
Private aItens:= {}
Private aLinha:= {}
Private lMsErroAuto := .F.  

IF lSOLTIPO
	DEFINE DIALOG oDlgTp TITLE "Tipo de Nota Fiscal" FROM 0,0 TO 150,300 PIXEL
	
	@ 008,005 Say "Tipo de Nota Fiscal : " Size 150,010 Pixel Of oDlgTp
	
	cTipoNF:= aTipoNF[1]
	oCmbNF := TComboBox():New(005,060,{|u|if(PCount()>0,cTipoNF:=u,cTipoNF)},aTipoNF,080,010,oDlgTp,,{||},,,,.T.,,,,,,,,,'cTipoNF')
	
	@ 025,005 Say "Formulário Próprio  : " Size 150,010 Pixel Of oDlgTp
	
	cFormNF := aFormul[1]
	oCmbFor := TComboBox():New(022,060,{|u|if(PCount()>0,cFormNF:=u,cFormNF)},aFormul,080,010,oDlgTp,,{||},,,,.T.,,,,,,,,,'cFormNF')
	
	@ 050,005 BUTTON "&OK"	SIZE 50,15 OF oDlgTp PIXEL ACTION {|| (oDlgTp:End())  }
	
	ACTIVATE DIALOG oDlgTp CENTERED
EndIF

Begin Transaction

FWLOADSM0()      

DbSelectArea("Z31")
Z31->(DbSetOrder(2))
Z31->(DbSeek(xFilial("Z31") + ALLTRIM(cChvNF)))

aCabec := 	{	{'F1_TIPO'		,cTipoNF		 	,"AlwaysTrue()"},;		
				{'F1_FORMUL'	,cFormNF		 	,"AlwaysTrue()"},;	 
				{'F1_ESPECIE'	,cEspecie		 	,"AlwaysTrue()"},;		
				{'F1_DOC'		,Z31->Z31_NUM       ,"AlwaysTrue()"},;		
				{'F1_SERIE' 	,Z31->Z31_SERIE 	,"AlwaysTrue()"},;		
				{'F1_EMISSAO'	,Z31->Z31_EMIS   	,"AlwaysTrue()"},;		
				{'F1_FORNECE'	,Z31->Z31_CODFOR 	,"AlwaysTrue()"},;	 
				{'F1_CHVNFE'	,cChvNF 			,"AlwaysTrue()"},;	 				 	
				{'F1_LOJA'		,Z31->Z31_LJFOR   	,"AlwaysTrue()"}}	
				

cQry := " SELECT *  FROM " + RETSQLNAME("Z34")
cQry += " WHERE Z34_FILIAL= '" + XFILIAL("Z34") + "' "
cQry += " AND Z34_CHAVE = '" + ALLTRIM(cChvNF) + "'
cQry += " AND D_E_L_E_T_= ' ' "
cQry += " ORDER BY Z34_ITEM "

If Select("TPNF") > 0
	dbCloseArea("TPNF")   
EndIf                                                                                                                            

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"TPNF",.T.,.T.)

While TPNF->(!EOF())	 
	aLinha := {}    
	
	aLinha := {	{'D1_COD'		,TPNF->Z34_PEDPRO															,NIL},;		
				{'D1_XDESCRI'	,Posicione("SB1",1,xFilial("SB1")+TPNF->Z34_PEDPRO,"B1_DESC")				,NIL},;			
				{'D1_UM'		,ALLTRIM(POSICIONE("SB1",1,xFilial("SB1")+TPNF->Z34_PEDPRO ,"B1_UM"))   	,NIL},;				
				{'D1_QUANT'		,TPNF->Z34_QUANT															,NIL},;		
				{'D1_VUNIT'		,TPNF->Z34_VUNIT															,NIL},;		
				{'D1_TOTAL'		,TPNF->Z34_VLRTOT															,NIL},;	
				{'D1_TES'		,ALLTRIM(POSICIONE("SB1",1,xFilial("SB1")+TPNF->Z34_PEDPRO,"B1_TE"))		,NIL},;	   
				{'D1_LOCAL'		,TPNF->Z34_LOCAL  															,NIL},; 
				{'D1_PEDIDO'	,TPNF->Z34_PEDIDO															,NIL},;	
				{'D1_ITEMPC'	,TPNF->Z34_ITEM  															,NIL},;
				{'D1_LOTECTL'	,TPNF->Z34_LOTE						   										,NIL},;		 	
				{'D1_DTVALID'	,TPNF->Z34_DTVALI															,NIL}}
				
	aadd(aItens,aLinha)	 
	
	TPNF->(DBSKIP())
EndDo

If Select("TPNF") > 0
	dbCloseArea("TPNF")
EndIf        
       
LjMsgRun("Aguarde...Criando Documento de Entrada",,{|| MSExecAuto({|x,y,z| MATA140(x,y,z)}, aCabec, aItens, 3)  })   

If lMsErroAuto      
	mostraerro()
EndIf    

End Transaction

RETURN()