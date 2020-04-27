#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#Include "Ap5Mail.Ch"
#Include "xmlxfun.ch"
#INCLUDE "JPEG.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ KMLOJG01 º Autor ³ LUIZ EDUARDO F.C.  º Data ³  07/03/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±                                     
±±ºDescricao ³ GATILHO NO CAMPO UB_VRUNIT - CALCULA O DESCONTO DO PRODUTO º±±
±±º          ³ DE ACORDO COM O PRECO UNITARIO DIGITADO                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ KOMFORT HOUSE - LOJA                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±                                     
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER FUNCTION KMLOJG01()    

Private nUB_VRUNIT  := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_VRUNIT"})
Private nUB_QUANT   := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_QUANT"}) 
Private nUB_VLRITEM := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_VLRITEM"}) 
Private nUB_DESC    := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_DESC"})  
Private nUB_VALDESC := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_VALDESC"})
Private nUB_PRCTAB  := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_PRCTAB"})                                 
Private nUB_PRODUTO := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_PRODUTO"})                                 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ZERA TODOS OS CAMPOS DE VALORES - LUIZ EDUARDO F.C. - 16.08.2017 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCols[n,nUB_VRUNIT] 	:= 0
aCols[n,nUB_DESC]		:= 0
aCols[n,nUB_VALDESC] 	:= 0 
aCols[n,nUB_VLRITEM] 	:= 0   
aCols[n,nUB_PRCTAB]     := 0                                                      
                             
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CARREGA O PRECO DE TABELA DO PRODUTO - TABELA DA1 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("DA1")
DbSetOrder(2)
DbSeek(xFilial("DA1") + aCols[n,nUB_PRODUTO])

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ATUALIZA OS CAMPOS COM OS NOVOS VALORES ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                                                             		
aCols[n,nUB_PRCTAB]		:= DA1->DA1_PRCVEN 
aCols[n,nUB_VRUNIT] 	:= M->UB_VRUNIT
aCols[n,nUB_VALDESC] 	:= aCols[n,nUB_PRCTAB] - M->UB_VRUNIT
aCols[n,nUB_VLRITEM] 	:= M->UB_VRUNIT * aCols[n,nUB_QUANT]                                                                          
aCols[n,nUB_DESC]		:= (((M->UB_VRUNIT / aCols[n,nUB_PRCTAB]) - 1) * 100) * -1

/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ATUALIZA O CAMPO "VALOR DE DESCONTO"  ³                                                                              
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCols[n,nUB_VALDESC]	:= aCols[n,nUB_QUANT] * (aCols[n,nUB_PRCTAB] - aCols[n,nUB_VRUNIT])
M->UB_VALDESC			:= aCols[n,nUB_QUANT] * (aCols[n,nUB_PRCTAB] - aCols[n,nUB_VRUNIT])

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ATUALIZA O CAMPO "PORCENTAGEM DE DESCONTO" ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCols[n,nUB_DESC]	:=  (aCols[n,nUB_VLRITEM] - aCols[n,nUB_VALDESC]) / 100 
M->nUB_DESC			:=  (aCols[n,nUB_VLRITEM] - aCols[n,nUB_VALDESC]) / 100 
*/

RETURN(.T.)