#include 'protheus.ch'
#include 'parmtype.ch'

user function KHTMK002()

Local cPesq        := Space(40)
Local aSize        := MsAdvSize()
Local aItens       := {"","1-Em Aberto","2-Em Atendimento","3-Aprovado","4-Sugerido","5-ReAnalise"}
Private cCombo       := ""
Private dDateDe    := Date()
Private dDateAte   := Date()
Private oSay
Private oSay2
Private oSay3
Private oGet
Private oGet2
Private oGet3
Private oTela
Private oLayer     := FWLayer():new()
Private oPainel1
Private oPainel2
Private _aDados    := {}
Private oBrwPro
Private aButtons   := {}
Private cCadastro  := "ORÇAMENTOS"
Private oTComboBox

DEFINE MSDIALOG oTela FROM 0,0 TO aSize[6],aSize[5] TITLE cCadastro Of oMainWnd PIXEL

AAdd(aButtons,{	'',{|| fExcelG(_aDados) }, "Exportar Excel"} )
EnchoiceBar(oTela,{ || oTela:End() },{ || oTela:End() },.F.,aButtons,,,.F.,.F.,.T.,.F.,.F.)

//Inicializa o FWLayer com a janela que ele pertencera e se sera exibido o botao de fechar
oLayer:init(oTela,.F.)
//Cria as Linhas do Layer
oLayer:AddLine("L01",20,.F.)
oLayer:AddLine("L02",80,.F.)
//Cria as colunas do Layer
oLayer:addCollumn('Col01_01',100,.F., "L01") 
oLayer:addCollumn('Col02_01',100,.F., "L02") 
//Cria as janelas
oLayer:addWindow('Col01_01','C1_Win01_01','Pesquisa',100,.F.,.F.,/**/,"L01",/**/)
oLayer:addWindow('Col02_01','C1_Win02_01','Orçamentos',100,.F.,.F.,/**/,"L02",/**/)
//Adiciona os paineis aos objetos
oPainel1 := oLayer:GetWinPanel('Col01_01','C1_Win01_01',"L01")
oPainel2 := oLayer:GetWinPanel('Col02_01','C1_Win02_01',"L02")


oBrwPro := TwBrowse():New(000,000,oPainel2:nClientWidth/2,oPainel2:nClientHeight/2,, {'Atendimento',;
						                                                              'Dt Emissao',;
						                                                              'Dt Envio Cred.',;
						                                                              'Loja',;
						                                                              'Desc. Loja',;
						                                                              'Cod. Cliente',;
						                                                              'Nome Cliente',;
						                                                              'Valor Bruto',;
						                                                              'Entrada',;
						                                                              'Valor Finan.',;
						                                                              'Qnt Parcelas',;
						                                                              '% Liberação',;
						                                                              'Status',;
						                                                              'Pedido',;
						                                                              'Analista Cred.',;
						                                                              'Hora Aprov.',;
						                                                              'Autorização',;
						                                                              'Cancelado',;
						                                                              'Deletado' },,oPainel2,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
oBrwPro:bLDblClick := {|| fSetOPeracao(oBrwPro:nColPos,_aDados[oBrwPro:nAt])}
fProp()

@002,002 SAY oSay PROMPT "Atendimento\Cliente: " SIZE 50, 10 OF oPainel1 COLORS 0, 16777215 PIXEL
@002,055 MSGET oGet VAR cPesq SIZE 100, 010 OF oPainel1 PIXEL

@002,160 SAY oSay2 PROMPT "Data De: " SIZE 30, 10 OF oPainel1 COLORS 0, 16777215 PIXEL
@002,185 MSGET oGet2 VAR dDateDe SIZE 50, 10 OF oPainel1 PIXEL

@002,240 SAY oSay3 PROMPT "Data Até: " SIZE 30, 10 OF oPainel1 COLORS 0, 16777215 PIXEL
@002,268 MSGET oGet3 VAR dDateAte SIZE 50, 10 OF oPainel1 PIXEL

oTComboBox := TComboBox():New(004,330,{|u|if(PCount()>0,cCombo:=u,cCombo)},aItens,060,010,oPainel1,,{|| },,,,.T.,,,,,,,,,)

@002,400 BUTTON "&Pesquisar" SIZE 050, 012 ACTION (Processa({|| fProp(cPesq) },"Aguarde...","Atualizando Dados...",.F.)) OF oPainel1 PIXEL

ACTIVATE MSDIALOG oTela CENTERED

return

Static Function fProp(cPesq)

Local cQuery    := ""
Local cAlias2   := GetNextAlias()
Local cCpo      := IIf(IsNumeric(cpesq), "UA_NUM", "A1_NOME")
Local aLikes    := {}
Local cStatus   := ""
Default cPesq   := ""

// Retira aspas simples e duplas
cPesq    := StrTran(cPesq,"'"," ")
cPesq    := StrTran(cPesq,'"'," ")
// Retira espacos em branco do campo de pesquisa.
cPesq    := Alltrim(cPesq)
// Transformo a pesquisa digitada em letras maiusculas
cPesq    := Upper(cPesq)
// Gera array com likes da pesquisa.
aLikes   := StrToKArr(cPesq, " ")

_aDados := {}

cQuery := " SELECT UA_NUM, UA_EMISSAO, UA_XDTENV, UA_LOJA, UA_01FILIA, UA_CLIENTE, A1_NOME, UA_VLRLIQ, " + CRLF 
cQuery += " ISNULL((UA_VLRLIQ - E1_VALOR),0) AS ENTRADA, " + CRLF
cQuery += " ISNULL(E1_VALOR,0) VLR_FINANCIADO, " + CRLF
cQuery += " ISNULL(E1_PARCELA,0) QNT_PARCELAS, " + CRLF
cQuery += " UA_XPERLIB, UA_XSTATUS, UA_NUMSC5, UA_XATCRED, UA_XHRAPRO, E1_DOCTEF, " + CRLF
cQuery += " CASE WHEN UA_STATUS = 'CAN' THEN 'SIM' ELSE 'NÃO' END AS UA_STATUS, " + CRLF
cQuery += " CASE  WHEN UA.D_E_L_E_T_ = '*' THEN 'SIM' ELSE '' END DELETADO " + CRLF
cQuery += " FROM SUA010(NOLOCK) UA " + CRLF																			
cQuery += " INNER JOIN SA1010(NOLOCK) A1 ON A1.A1_COD = UA_CLIENTE AND A1.D_E_L_E_T_ <> '*' " + CRLF				
cQuery += " LEFT JOIN (SELECT E1_NUM,E1_PEDIDO,COUNT(E1_PARCELA) E1_PARCELA,E1_MSFIL, SUM(E1_VALOR) E1_VALOR,E1_TIPO,E1_FORMREC,E1_DOCTEF " + CRLF 					
cQuery += " 		   FROM  SE1010 E1(NOLOCK) " + CRLF 																		
cQuery += " 	       WHERE E1.E1_TIPO IN ('BOL','CHK') AND E1.D_E_L_E_T_ = '' AND E1.E1_PEDIDO  = E1_NUM " + CRLF 			
cQuery += " 	       GROUP BY E1_NUM,E1_PEDIDO, E1_MSFIL, E1_TIPO,E1_FORMREC,E1_DOCTEF " + CRLF										
cQuery += " 	       ) E1 ON E1.E1_PEDIDO = UA.UA_NUMSC5 AND E1.E1_MSFIL = UA.UA_FILIAL " + CRLF								
cQuery += " WHERE UA_EMISSAO BETWEEN '"+ DTOS(dDateDe) +"' AND '"+ DTOS(dDateAte) +"' " + CRLF

If !Empty(aLikes)
	For nX := 1 to len(aLikes)
		cQuery += "AND " + cCpo + " LIKE '%"+ aLikes[nX] + "%' " + CRLF
	Next nX
EndIf

If !Empty(cCombo)
	cQuery += "AND UA_XSTATUS = '"+ Substr(cCombo,1,1) +"' " + CRLF
EndIf

cQuery += " GROUP BY UA_NUM,UA_EMISSAO,UA_XDTENV,UA_01FILIA,A1_NOME,E1_TIPO,UA_VLRLIQ,E1_PARCELA,E1_VALOR,UA_XPERLIB,UA_XSTATUS,UA_NUMSC5,E1_PEDIDO,UA_XATCRED,UA_STATUS,UA_XHRAPRO,E1_DOCTEF,UA_LOJA,UA_CLIENTE,UA_STATUS,UA.D_E_L_E_T_ " + CRLF 		
cQuery += " ORDER BY UA_NUM " + CRLF

PlsQuery(cQuery, cAlias2)

while (cAlias2)->(!eof())

		Do Case
			case (cAlias2)->UA_XSTATUS == '1'
				cStatus := "Em Aberto"
			case (cAlias2)->UA_XSTATUS == '2'
				cStatus := "Em Atendimento"
			case (cAlias2)->UA_XSTATUS == '3'
				cStatus := "Aprovado"
			case (cAlias2)->UA_XSTATUS == '4'
				cStatus := "Sugerido"
			case (cAlias2)->UA_XSTATUS == '5'
				cStatus := "Reanalise"			
		EndCase

		Aadd(_aDados, { (cAlias2)->UA_NUM,;
		                (cAlias2)->UA_EMISSAO,;
		                (cAlias2)->UA_XDTENV,;
		                (cAlias2)->UA_LOJA,;
		                (cAlias2)->UA_01FILIA,;
		                (cAlias2)->UA_CLIENTE,;
		                (cAlias2)->A1_NOME,;
		                (cAlias2)->UA_VLRLIQ,;
		                (cAlias2)->ENTRADA,;
		                (cAlias2)->VLR_FINANCIADO,;
		                (cAlias2)->QNT_PARCELAS,;
		                (cAlias2)->UA_XPERLIB,;
		                 cStatus,;
		                (cAlias2)->UA_NUMSC5,;
		                (cAlias2)->UA_XATCRED,;
		                (cAlias2)->UA_XHRAPRO,;
		                (cAlias2)->E1_DOCTEF,;
		                (cAlias2)->UA_STATUS,;
		                (cAlias2)->DELETADO;
		                	                  })
		                
		     (cAlias2)->(dbskip())            
EndDo

(cAlias2)->(dbCloseArea())

if len(_aDados) == 0
   AAdd(_aDados, {"","","","","","","","","","","","","","","","","","",""})
endif

oBrwPro:SetArray(_aDados)
   
oBrwPro:bLine := {|| {   _aDados[oBrwPro:nAt,01] ,;//Atendimento 
                         _aDados[oBrwPro:nAt,02] ,;//Emissao
                         _aDados[oBrwPro:nAt,03] ,;//Data Envio para o credito
                         _aDados[oBrwPro:nAt,04] ,;//Cod Loja
                         _aDados[oBrwPro:nAt,05] ,;//Descrição Loja
                         _aDados[oBrwPro:nAt,06] ,;//Cod Cliente
                         _aDados[oBrwPro:nAt,07] ,;//Nome Cliente
                         Transform(_aDados[oBrwPro:nAt,08],"@E 999,999.99") ,;//Valor bruto
                         Transform(_aDados[oBrwPro:nAt,09],"@E 999,999.99") ,;//Entrada
                         Transform(_aDados[oBrwPro:nAt,10],"@E 999,999.99") ,;//Valor Financiado
                         _aDados[oBrwPro:nAt,11] ,;//Qnt Parcelas
                         _aDados[oBrwPro:nAt,12] ,;//% Liberação
                         _aDados[oBrwPro:nAt,13] ,;//Status
                         _aDados[oBrwPro:nAt,14] ,;//Pedido
                         _aDados[oBrwPro:nAt,15] ,;//Analista Credito
                         _aDados[oBrwPro:nAt,16] ,;//Hora Aprovação
                         _aDados[oBrwPro:nAt,17] ,;//Autorização
                         _aDados[oBrwPro:nAt,18] ,;//Cancelado
                         _aDados[oBrwPro:nAt,19] }}//Deletado
        
oBrwPro:Align := CONTROL_ALIGN_ALLCLIENT

return
//---------------------------------------------------------------
Static Function fInfCliente(_array)

    local aArea := getArea()
    Private aCpos := {  "A1_END","A1_BAIRRO","A1_EST","A1_CEP", "A1_MUN","A1_DDD","A1_TEL","A1_TEL2","A1_XTEL3",;
    					"A1_CONTATO","A1_EMAIL","A1_COMPLEM","A1_NOME","A1_NREDUZ","A1_XHISTCR","A1_XFILMAT",;
    					"A1_XNTRAB","A1_XENDTRB","A1_XDTADM","A1_XCARGO","A1_XVLRSAL","A1_XDDDTC","A1_XTELCML","A1_XNRAMAL",;
    					"A1_DDDTELR","A1_XTELREC","A1_XCNTREC","A1_XHISTCR","A1_DDDTR1","A1_TELREC1","A1_DDDTR2",;
    					"A1_TELREC2","A1_XSCOR","A1_XPASPC","A1_XQTRES","A1_XVLTRE","A1_XOCUPA","A1_XNATUR","A1_XNONJG ",;
    					"A1_XCPFJG","A1_XCARJG","A1_XADMJG","A1_XSALJG","A1_XNEMJG","A1_XDDDJG","A1_XFONJG","A1_XDDDCJG",;
    					"A1_FOEMJG","A1_XPAREC","A1_XAUTJG","A1_CGC","A1_DTNASC","A1_XCPFJU","A1_DDDSPC3","A1_TELSCP3","A1_XINADIN","A1_ENDENT",;
    					"A1_XIDADE","A1_XESTCIV","A1_XNOMERC","A1_XCPFRC","A1_XGPARRC","A1_XDDDRC","A1_XTELRC","A1_XEMPRC","A1_XDTARC",;
    					"A1_XCARGRC","A1_XDDDERC","A1_XTEMPRC","A1_XHOLER","A1_XCBANC","A1_XCENDER","A1_XDOCPES","A1_XIMPREN","A1_XENDGO",;
    					"A1_XENDSPC","A1_XANCRED","A1_XDANALI","A1_BAIRROE","A1_COMPENT","A1_01MUNEN","A1_MUNE","A1_ESTE","A1_CEPE","A1_PFISICA",;
                        "A1_RENCOM","A1_DTNCOM","A1_TELSPC","A1_CNPJEMP","A1_SCREMP","A1_XTEMLR","A1_XMORADI","A1_XSCRCON"}
						
	Private cCadastro := "Cadastro de Clientes - Alteração de Cadastro"
    
    dbSelectArea("SA1")
    SA1->(dbSetOrder(1)) //A1_FILIAL, A1_COD, A1_LOJA, R_E_C_N_O_, D_E_L_E_T_

    if SA1->(dbSeek(xFilial()+_array[6]+_array[4]))
        AxAltera("SA1",SA1->(Recno()),4,,aCpos)
    endif

    restArea(aArea)

Return

//--------------------------------------------------------------
Static Function fSetOPeracao(nColuna,_array)

    Do Case

        Case nColuna == 1 //Atendimento
        	processa( {|| fInfCliente(_array) }, "Aguarde...", "Localizando cliente...", .f.)
       
    EndCase

Return

//--------------------------------------------------------------
Static Function fExcelG(aItens)

	Local oExcel := FWMsExcel():New()
    Local cArqTemp := GetTempPath() + "KHTMK002"+substr(time(), 7, 2)+".XLS"
	Local aCab := {}
	Local aFields := {"UA_NUM","UA_EMISSAO","UA_XDTENV","UA_LOJA","UA_01FILIA","UA_CLIENTE","A1_NOME","UA_VLRLIQ","ENTRADA","VLR_FINANCIADO","QNT_PARCELAS","UA_XPERLIB","STATUS","UA_NUMSC5","UA_XATCRED","UA_XHRAPRO","E1_DOCTEF","UA_STATUS","DELETADO"}
    Local nx := 0
    Local nr := 0
    Local cTitle := "Orçamentos"

    if len(aItens) <= 0 
        Return(msginfo("Não ha dados para impressão...","ATENÇÃO"))
    endif
    
    DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	For nx := 1 to Len(aFields)
		If SX3->(DbSeek(aFields[nx]))
	    	Aadd(aCab, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		ELSE
			Aadd(aCab,{aFields[nx],"","","","","","","C","","","",""})
		Endif
	Next nx           
    
   	cNamePlan := cNameTable := cTitle

	oExcel:AddworkSheet(cNamePlan)
	oExcel:AddTable (cNamePlan,cNameTable)
	
	//Colunas do Excel ----------------------------------------
	for nx := 1 to Len(aCab)
		if aCab[nx][8] == "C"// Tipo Caracter
			oExcel:AddColumn(cNamePlan,cNameTable,aCab[nx][1],1,1)
		elseif aCab[nx][8] == "N"// Tipo Numerico
			oExcel:AddColumn(cNamePlan,cNameTable,aCab[nx][1],3,2)
		elseif aCab[nx][8] == "D" // Tipo Data
			oExcel:AddColumn(cNamePlan,cNameTable,aCab[nx][1],1,3)			
		else
			oExcel:AddColumn(cNamePlan,cNameTable,aCab[nx][1],1,1)
		endif
	next nx

    for nr := 1 to len(aItens) 
	   	oExcel:AddRow(cNamePlan,cNameTable,{;
	   										aItens[nr][1],;
											aItens[nr][2],;
                                            aItens[nr][3],;
											aItens[nr][4],;
                                            aItens[nr][5],;
                                            aItens[nr][6],;
                                            aItens[nr][7],;
                                            aItens[nr][8],;
                                            Transform(aItens[nr][9],"@E 999,999.99" ),;
                                            Transform(aItens[nr][10],"@E 999,999.99" ),;
                                            aItens[nr][11],;
                                            aItens[nr][12],;
                                            aItens[nr][13],;
                                            aItens[nr][14],;
                                            aItens[nr][15],;
                                            aItens[nr][16],;
                                            aItens[nr][17],;
                                            aItens[nr][18],;
                                            aItens[nr][19];
                                            })
	next nr
    
	oExcel:Activate()
	oExcel:GetXMLFile(cArqTemp)
	ShellExecute("open", cArqTemp, "", "C:\", 1 )
	
Return
