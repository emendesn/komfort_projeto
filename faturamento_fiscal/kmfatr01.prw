#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³  º Autor ³ Caio Garcia        º Data ³  02/03/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ LAUDO TECNICO                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ KOMFORT HOUSE                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function KMFATR01(aLaudo,nZ)

Local _cLogo 	:= "\system\LOGO_REL.png"
Local _cSofaF 	:= "\system\SOFA_F.png"
Local _cSofaB 	:= "\system\SOFA_B.png"
Local oPrint                                                    
Local oFnt14	   	:= TFont():New("Arial",,14,,.F.,,,,,.F.,.F.)
Local oFnt14s	   	:= TFont():New("Arial",,14,,.F.,,,,,.T.,.F.)
Local oFnt14n	   	:= TFont():New("Arial",,14,,.T.,,,,,.F.,.F.)
Local oFnt15	   	:= TFont():New("Arial",,15,,.F.,,,,,.F.,.F.)
Local oFnt15n	   	:= TFont():New("Arial",,15,,.T.,,,,,.F.,.F.)
Local oFnt16	   	:= TFont():New("Arial",,16,,.F.,,,,,.F.,.F.)
Local oFnt16n	   	:= TFont():New("Arial",,16,,.T.,,,,,.F.,.F.)
Local oFnt22	   	:= TFont():New("Arial",,22,,.F.,,,,,.F.,.F.)
Local oFnt22n	   	:= TFont():New("Arial",,22,,.T.,,,,,.F.,.F.)
Local oFnt24	   	:= TFont():New("Arial",,24,,.F.,,,,,.F.,.F.)
Local oFnt24n	   	:= TFont():New("Arial",,24,,.T.,,,,,.F.,.F.)
Local _nLin         := 0
Local _nAdc         := 0

Local cQuery	:= ""
Local cAlias 	:= CriaTrab(,.F.)
//Local cPedido	:= RIGHT(M->UC_01PED,6)
Local cPedido	:= M->UC_01PED // LUIZ EDUARDO F.C. - 01/06/2017 - TRAZER O CONTEUDO COMPLETO DO PEDIDO
Local cChamado	:= M->UC_CODIGO
Local cOperador := ""
Local dData		:= ""
Local cObs		:= ""
Local cNomeCli	:= ""
Local cBairro	:= ""
Local cPonto	:= ""
Local cCidade	:= ""
Local cCEP		:= ""
Local cUF		:= ""
Local cTelefone	:= ""
Local cNota		:= ""
Local cDataEnt	:= ""
Local cProduto	:= ""
Local cDescricao:= ""
Local cDefeito	:= ""
Local cTecnico	:= ""
Local cFileSave	:= ''
Local nLastKey  := 0

cQuery := "SELECT DISTINCT D2_PEDIDO AS PEDIDO, D2_DOC AS NOTA FROM "+RetSqlName("SD2")+" SD2 WHERE D2_PEDIDO = '"+cPedido+"' AND SD2.D_E_L_E_T_ = ' ' "

DbUseArea(.T.,"TOPCONN",TCGENQRY(,,ChangeQuery(cQuery)),cAlias,.F.,.T.)

While (cAlias)->(!EOF())
	cPedido := (cAlias)->PEDIDO
	cNota 	:= (cAlias)->NOTA	
	(cAlias)->(dbSkip())
EndDo
(cAlias)->(DbCloseArea()) 

SUD->(DbSetOrder(1))
SUD->(DBSEEK(XFILIAL("SUD")+cChamado))

SA1->(DbSetOrder(1))
SA1->(DbSeek(xFilial("SA1") + M->UC_CHAVE))

SB1->(DbSetOrder(1))
SB1->(DbSeek(xFilial("SB1") + aLaudo[nZ,01] ))

cOperador 	:= ALLTRIM(Posicione("SU7",1,xFilial("SU7")+M->UC_OPERADO,"U7_NOME"))
cObs		:= ALLTRIM(aLaudo[nZ,02])
cNomeCli	:= ALLTRIM(SA1->A1_NOME)
cBairro		:= UPPER(ALLTRIM(SA1->A1_END) + " , " + ALLTRIM(SA1->A1_BAIRRO) )
cPonto		:= UPPER(ALLTRIM(SA1->A1_COMPLEM))
cCidade		:= ALLTRIM(SA1->A1_MUN)
cCEP		:= SA1->A1_CEP
cUF			:= SA1->A1_EST
cTelefone	:= "("+AllTrim(SA1->A1_DDD)+")"+SA1->A1_TEL
cDataEnt	:= DTOC(aLaudo[nZ,03])
cProduto	:= ALLTRIM(aLaudo[nZ,01])
cDescricao	:= ALLTRIM(SB1->B1_DESC)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRATAMENTO PARA IMPRIMIR 3 DEFEITOS NO LAUDO TECNICO - LUIZ EDUARDO F.C. - 18.05.2017 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//cDefeito	:= ALLTRIM(aLaudo[nZ,04]) 
cDefeito	:= "1. " + ALLTRIM(aLaudo[nZ,04])

IF !EMPTY(ALLTRIM(aLaudo[nZ,05])) .AND. !EMPTY(ALLTRIM(aLaudo[nZ,06]))
	cDefeito	:= "1. " + ALLTRIM(aLaudo[nZ,04]) + "     -     2. " + ALLTRIM(aLaudo[nZ,05]) + "     -     3. " + ALLTRIM(aLaudo[nZ,06])
ElseIF !EMPTY(ALLTRIM(aLaudo[nZ,05])) .AND. EMPTY(ALLTRIM(aLaudo[nZ,06])) 
	cDefeito	:= "1. " + ALLTRIM(aLaudo[nZ,04]) + "     -     2. " + ALLTRIM(aLaudo[nZ,05])
ElseIF EMPTY(ALLTRIM(aLaudo[nZ,05])) .AND. !EMPTY(ALLTRIM(aLaudo[nZ,06])) 
	cDefeito	:= "1. " + ALLTRIM(aLaudo[nZ,04]) + "     -     2. " + ALLTRIM(aLaudo[nZ,06])
EndIF
	

If !ExistDir("C:\LAUDO_TECNICO")
	
	MakeDir("C:\LAUDO_TECNICO")
	
EndIf                          
         
_cDtHr := DToS(DDataBase)+Subs(Time(),1,2)+Subs(Time(),4,2)

_cNomeArq:="LAUDO_TECNICO_"+_cDtHr+".pdf"
oPrint:= FWMsPrinter():New(_cNomeArq,6,.T., ,.T., , , , ,.F., , .T., )
oPrint:SetPortrait()
oPrint:cPathPDF := "C:\LAUDO_TECNICO\"
oPrint:StartPage()

oPrint:Box(0050,0050,0300,2375)
oPrint:Box(0050,0050,0300,0350)
oPrint:SayBitMap(0060,060,_cLogo,0270,0230)
oPrint:Say(190,360,"Responsável pelo atendimento: ",oFnt16n,,0)
oPrint:Say(190,990,cOperador,oFnt14,,0)

oPrint:Box(0050,1650,0300,2372)           
oPrint:Box(0240,1650,0240,2372)//LINHA           
oPrint:Say(0090,1760,"Pedido de Assistência Tecnica",oFnt14,,0)     
oPrint:Say(0145,1680,"Komfort House Sófas - SAC 11 4343-3989",oFnt14,,0)              
oPrint:Say(0200,1800,"sac@komforthouse.com.br",oFnt14s,,0)     
oPrint:Say(0280,1680,"Data Visita:  "+"         /        /         ",oFnt14,,0)     
                               
//OBS                                    
oPrint:Box(0300,0050,0360,2375)                                
oPrint:Say(0340,0060,"OBSERVAÇÃO: ",oFnt15n,,0)
oPrint:Say(0340,0350,UPPER(AllTrim(cObs)),oFnt15,,0)

//CLIENTE
oPrint:Box(0360,0050,0420,2375)                
oPrint:Say(0400,0060,"CLIENTE: ",oFnt15n,,0)
oPrint:Say(0400,0250,UPPER(AllTrim(cNomeCli)),oFnt15,,0)
                                         
//ENDEREÇO
oPrint:Box(0420,0050,0540,2375)             
oPrint:Say(0460,0060,"ENDEREÇO: ",oFnt15n,,0)
oPrint:Say(0460,0300,AllTrim(Subs(cBairro,1,58)),oFnt15,,0)
oPrint:Say(0500,0060,AllTrim(Subs(cBairro,58,80)),oFnt15,,0)

oPrint:Say(0460,1660,"COMPL/REF.: ",oFnt15n,,0)               
oPrint:Say(0460,1920,Subs(cPonto,1,20),oFnt15,,0)
oPrint:Say(0500,1660,Subs(cPonto,21,50),oFnt15,,0)

//CIDADE
oPrint:Box(0540,0050,0600,2375)                     
oPrint:Box(0540,1100,0600,1100)//LINHA              
oPrint:Say(0580,0060,"CIDADE: ",oFnt15n,,0)  
oPrint:Say(0580,0230,UPPER(AllTrim(cCidade)),oFnt15,,0)

oPrint:Say(0580,1110,"CEP: ",oFnt15n,,0)
oPrint:Say(0580,1210,cCEP,oFnt15,,0)

oPrint:Say(0580,1660,"UF: ",oFnt15n,,0)               
oPrint:Say(0580,1740,cUF,oFnt15,,0)

//TELEFONE
oPrint:Box(0600,0050,0660,2375)
oPrint:Say(0640,0060,"TELEFONE: ",oFnt15n,,0)
oPrint:Say(0640,0280,cTelefone,oFnt15,,0)
       
oPrint:Say(0640,1660,"CHAMADO/PROT.: ",oFnt15n,,0)
oPrint:Say(0640,2020,cChamado,oFnt15,,0)
                         
//PEDIDO
oPrint:Box(0660,0050,0720,2375)                     
oPrint:Box(0660,0800,0720,0800)//LINHA              
oPrint:Say(0700,0060,"PEDIDO: ",oFnt15n,,0)
oPrint:Say(0700,0230,cPedido,oFnt15,,0)

oPrint:Say(0700,0810,"NF DE VENDA: ",oFnt15n,,0)
oPrint:Say(0700,1090,cNota,oFnt15,,0)

oPrint:Say(0700,1660,"DATA DE ENTREGA: ",oFnt15n,,0)
oPrint:Say(0700,2060,cDataEnt,oFnt15,,0)
          
oPrint:Box(0420,1650,0720,1650)//LINHA              

//ITENS
oPrint:Box(0720,0050,1020,2375) 
oPrint:Say(0765,0300,"CÓDIGO ",oFnt15n,,0)
oPrint:Say(0765,1450,"DESCRIÇÃO ",oFnt15n,,0)
oPrint:Box(0780,0050,0780,2372)//LINHA              
oPrint:Box(0720,0760,1020,0760)//LINHA

oPrint:Say(0820,0060,UPPER(AllTrim(cProduto)),oFnt15,,0)
oPrint:Say(0820,0780,UPPER(AllTrim(cDescricao)),oFnt15,,0)              


//DEFEITO
oPrint:Box(1020,0050,1080,2375)            
oPrint:Say(1065,1000,"DEFEITO RECLAMADO:",oFnt15n,,0)

//DESC. DEFEITO
oPrint:Box(1080,0050,1280,2375)                      
oPrint:Say(1120,0060,UPPER(AllTrim(cDefeito)),oFnt15,,0)

//IMAG.SOFA
oPrint:Box(1280,0050,1640,2375)                  
oPrint:Box(1280,1200,1640,1200)//LINHA           
oPrint:SayBitMap(1320,180,_cSofaF,0750,0300)
oPrint:SayBitMap(1320,1450,_cSofaB,0750,0300)

//ASSINALE
oPrint:Box(1640,0050,1700,2375)         
oPrint:Say(1680,0350,"ASSINALE ABAIXO EM QUAL PARTE DO PRODUTO SE LOCALIZA(M) O(S) DEFEITO(S): ",oFnt15n,,0)         

//OPÇÕES
oPrint:Box(1700,0050,2060,2375)                                                                                      
                  
_nAdc := 0

oPrint:Box(1740,0070+_nAdc,1790,0160+_nAdc)                                                                                      
oPrint:Say(1780,0180+_nAdc,"POLTRONA",oFnt14,,0)         

oPrint:Box(1850,0070+_nAdc,1900,0160+_nAdc)                    
oPrint:Say(1890,0180+_nAdc,"ASSENTO DIR.",oFnt14,,0)         

oPrint:Box(1960,0070+_nAdc,2010,0160+_nAdc)                  
oPrint:Say(2000,0180+_nAdc,"ASSENTO ESQ.",oFnt14,,0)          
                         
_nAdc += 430

oPrint:Box(1740,0070+_nAdc,1790,0160+_nAdc)                                                                                      
oPrint:Say(1780,0180+_nAdc,"SOFÁ CAMA",oFnt14,,0)         

oPrint:Box(1850,0070+_nAdc,1900,0160+_nAdc)                    
oPrint:Say(1890,0180+_nAdc,"BRAÇO DIR.",oFnt14,,0)         

oPrint:Box(1960,0070+_nAdc,2010,0160+_nAdc)                  
oPrint:Say(2000,0180+_nAdc,"BRAÇO ESQ.",oFnt14,,0)          
                         
_nAdc += 430

oPrint:Box(1740,0070+_nAdc,1790,0160+_nAdc)                                                                                      
oPrint:Say(1780,0180+_nAdc,"FORRO",oFnt14,,0)         

oPrint:Box(1850,0070+_nAdc,1900,0160+_nAdc)                    
oPrint:Say(1890,0180+_nAdc,"ALMOFADA/ENCOSTO",oFnt14,,0)         

oPrint:Box(1960,0070+_nAdc,2010,0160+_nAdc)                  
oPrint:Say(2000,0180+_nAdc,"ALMOFADA ASS.",oFnt14,,0)          
                         
_nAdc += 500

oPrint:Box(1740,0070+_nAdc,1790,0160+_nAdc)                                                                                      
oPrint:Say(1780,0180+_nAdc,"BASE DOS PÉS",oFnt14,,0)         

oPrint:Box(1850,0070+_nAdc,1900,0160+_nAdc)                    
oPrint:Say(1890,0180+_nAdc,"PÉS",oFnt14,,0)         

oPrint:Box(1960,0070+_nAdc,2010,0160+_nAdc)                  
oPrint:Say(2000,0180+_nAdc,"CAIXA DE ENCOSTO",oFnt14,,0)          
                         
_nAdc += 500

oPrint:Box(1740,0070+_nAdc,1790,0160+_nAdc)                                                                                      
oPrint:Say(1780,0180+_nAdc,"SOFÁ DE CANTO",oFnt14,,0)         

oPrint:Box(1850,0070+_nAdc,1900,0160+_nAdc)                    
oPrint:Say(1890,0180+_nAdc,"TECIDO",oFnt14,,0)         

oPrint:Box(1960,0070+_nAdc,2010,0160+_nAdc)                  
oPrint:Say(2000,0180+_nAdc,"RETRATIL",oFnt14,,0)          
                         
//DESC. TECN
oPrint:Box(2060,0050,2120,2375)  
oPrint:Say(2100,0500,"DESCRIÇÃO DETALHADA DO PROBLEMA VISTORIADO PELO TÉCNICO: ",oFnt15n,,0)         

//QUADRO DESC.
oPrint:Box(2120,0050,2520,2375)                  

//TECNICO
oPrint:Box(2520,0050,2600,2375)                  
oPrint:Say(2570,0060,"TÉCNICO: ",oFnt15n,,0)         

//HR ENTRADA
oPrint:Box(2600,0050,2680,2375)                      
oPrint:Say(2650,0060,"HORÁRIO DE ENTRADA: ",oFnt15n,,0)         

oPrint:Box(2600,1200,2680,1200)//LINHA                          
oPrint:Say(2650,1210,"HORÁRIO DE SAÍDA: ",oFnt15n,,0)         

//ASSIN
oPrint:Box(2680,0050,3000,2375)                     
oPrint:Say(2720,0060,"ASSINATURA DO CLIENTE: ",oFnt15n,,0)         

oPrint:EndPage()    

oPrint:Preview()
		
RETURN()
