#include 'protheus.ch'
#include 'parmtype.ch'



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ KMSACA11º Autor ³ Wellington Raul     º Data ³  12/03/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºCadastro de comissão vendedores - Alerado para MBROWSE                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 															  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/



user function KHCOM005()
	
Local aCores := {{'Z15->Z15_PRODOR<>""','BR_VERMELHO'},{'Z15->Z15_PRODOR==""','BR_VERDE'}}

Private cCadastro     := "Produtos Medida Especial"
Private cString          := "Z15"                                                                                                       
Private aRotina          := {{'Procurar','AxPesqui',0,1},;
{'Visualisar','AxVisual',0,2},;
{'Alterar','AxAltera',0,3},;
{'Legenda', 'U_LEGCA13()',0,6}}
dbSelectArea("Z15")
dbSetOrder(1)
Z15->(dbGoTop())
MBrowse(6,1,22,75,cString,,,,,,aCores)

Return(.T.)  

User Function LEGCA13()

   aLegenda := { {'BR_VERMELHO',	"Prod Origem Vazio" },;
                 {'BR_VERDE',    	"Prod Origem Preenchido"}};
                 
   BRWLEGENDA( cCadastro, "Legenda", aLegenda )

Return(.T.)


