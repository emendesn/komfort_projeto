#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

/*---------------------------------------------------------------------------+
!                       FICHA TECNICA DO PROGRAMA                            !
+----------------------------------------------------------------------------+
!                          DADOS DO PROGRAMA                                 !
+------------------+---------------------------------------------------------+
!Autor             ! CMaxTI Soluções em Sistemas                             !
!                  ! E-Mail calandrine@cmaxti.com.br                         !
+------------------+---------------------------------------------------------+
!Descricao         ! Arquivo gerado automaticamente                          !
!                  ! Criação de relatórios gráficos                          !
+------------------+---------------------------------------------------------+
!Nome              ! KMCOMR05                                              !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 16/11/2018                                              !
+------------------+--------------------------------------------------------*/
User Function KMCOMR05()
Local _cPerg := "KMCOMR05" 
Private	cImag001	:=	"C:\totvs\logo.png"
Private oAriapÎ10NI	:=	TFont():New("Arial Narrow",,10,,.T.,,,,,.F.,.T.)
Private oArialÎ10N	:=	TFont():New("Arial Narrow",,10,,.T.,,,,,.F.,.F.)
Private oArialÎ9N	:=	TFont():New("Arial Narrow",,9,,.T.,,,,,.F.,.F.)
Private oPrinter  	:=	tAvPrinter():New("KMCOMR05")


 	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ajusta e carrega perguntas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cPerg    := PadR(_cPerg, Len(SX1->X1_GRUPO))
fAjustSX1(_cPerg)

IF Pergunte(_cPerg,.T.)

DbSelectArea(“SM0”)
SM0->(DbSeek(cEmpAnt+cFilAtu))

DbSelectArea(“SC7”)
SC7->(Dbsetorder(1))
SC7->(DbSeek(XFILIAL("SC7")+MV_PAR01))

DbSelectArea(“SA2”)
SA2->(Dbsetorder(1))
SA2->(DbSeek(XFILIAL("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA))

  oPrinter:Setup()
  oPrinter:SetPortrait()
  oPrinter:StartPage()
  printPage()
  oPrinter:Preview()

ELSE

ALERT("Cancelado pelo usuario")

ENDIF


Return

Static Function printPage()

Local cNpedido  := MV_PAR01
Local cNcli 	:= SM0->M0_NOMECOM
LOcal cEndcli	:= SM0->M0_ENDCOB
Local cBcli 	:= SM0->M0_BAIRCOB
Local cCepcli 	:= SM0->M0_CEPCOB
Local cCidcli 	:= SM0->M0_CIDCOB
Local cEstcli 	:= SM0->M0_ESTCOB
Local cCnpjcli 	:= SM0->M0_CGC
Local cInsccli 	:= SM0->M0_INSC
Local cTelcli 	:= SM0->M0_TEL
Local cDatapc 	:= DTOC(SC7->C7_EMISSAO)
Local cUsraut 	:= ""
Local cDtaut 	:= DTOC(SC7->C7_DATPRF)
Local cDtentr 	:= DTOC(SC7->C7_DATPRF)
Local cFpag 	:= Posicione("SE4",1,XFILIAL("SE4")+SC7->C7_COND,"E4_DESCRI")
Local cTransp 	:= ""
Local cNfor 	:= SA2->A2_NOME
Local cEndfor 	:= SA2->A2_END
Local cBfor 	:= SA2->A2_BAIRRO
Local cCepfor 	:= SA2->A2_CEP
Local cCidfor 	:= SA2->A2_MUN
Local cEstfor 	:= SA2->A2_EST
Local cCnpjfor 	:= SA2->A2_CGC
Local cInscfor 	:= SA2->A2_INSCR
Local cTelfor 	:= SA2->A2_TEL
Local _nLin := 0
Local _nTotal := 0
Local _nTipi := 0

  oPrinter:SayBitMap(0037,0058,cImag001,0087,0051)

  oPrinter:Box(0027,0029,3273,2420)/*Margem*/

  oPrinter:Box(0027,0175,0097,2419)

  oPrinter:Say(0044,0907,"PEDIDO DE COMRPRA No.:",oAriapÎ10NI,,0)

  oPrinter:Say(0044,1203,cNpedido,oArial10N,,0)

  oPrinter:Box(0388,0030,0600,2420)

  oPrinter:Say(0108,0036,"Emitente:",oArial9N,,0)

  oPrinter:Say(0108,0266,cNcli,oArial9N,,0)

  oPrinter:Say(0165,0036,"Endereço:",oArial10N,,0)

  oPrinter:Say(0166,0266,cEndcli,oArial9N,,0)

  oPrinter:Box(0097,0029,0388,2419)

  oPrinter:Say(0220,0036,"Bairro:",oArial10N,,0)

  oPrinter:Say(0220,0266,cBcli,oArial9N,,0)

  oPrinter:Say(0220,0794,"CEP:",oArial10N,,0)

  oPrinter:Say(0223,0975,cCepcli,oArial9N,,0)

  oPrinter:Say(0279,0036,"Cidade:",oArial10N,,0)

  oPrinter:Say(0279,0266,cCidcli,oArial9N,,0)

  oPrinter:Say(0279,0794,"Estado:",oArial10N,,0)

  oPrinter:Say(0279,0975,cEstcli,oArial9N,,0)

  oPrinter:Say(0337,0036,"CNPJ:",oArial10N,,0)

  oPrinter:Say(0336,0266,cCnpjcli,oArial9N,,0)

  oPrinter:Say(0337,0794,"Insc. Estadual:",oArial10N,,0)

  oPrinter:Say(0336,0975,cInsccli,oArial9N,,0)

  oPrinter:Say(0106,0799,"Tel:",oArial10N,,0)

  oPrinter:Say(0108,0980,cTelcli,oArial9N,,0)

  oPrinter:Say(0402,0036,"Data:",oArial10N,,0)

  oPrinter:Say(0402,0266,cDatapc,oArial9N,,0)

  oPrinter:Say(0401,0794,"Autorizado por:",oArial10N,,0)

  oPrinter:Say(0404,0975,cUsraut,oArial9N,,0)

  oPrinter:Say(0452,0794,"Data Autorização:",oArial10N,,0)

  oPrinter:Say(0454,0975,cDtaut,oArial9N,,0)

  oPrinter:Say(0452,0036,"Data prev. Entrega:",oArial10N,,0)

  oPrinter:Say(0454,0266,cDtentr,oArial9N,,0)

  oPrinter:Say(0502,0036,"Forma Pagamento:",oArial10N,,0)

  oPrinter:Say(0504,0266,cFpag,oArial9N,,0)

  oPrinter:Say(0550,0036,"Transportadora:",oArial10N,,0)

  oPrinter:Say(0551,0266,cTransp,oArial9N,,0)

  oPrinter:Box(0925,0029,0986,2419)

  oPrinter:Say(0629,0036,"Fornecedor:",oArial10N,,0)

  oPrinter:Say(0629,0269,cNfor,oArial9N,,0)

  oPrinter:Say(0680,0036,"Endereço:",oArial10N,,0)

  oPrinter:Say(0684,0269,cEndfor,oArial9N,,0)

  oPrinter:Say(0729,0036,"Bairro:",oArial10N,,0)

  oPrinter:Say(0729,0269,cBfor,oArial9N,,0)

  oPrinter:Say(0629,0799,"CEP:",oArial10N,,0)

  oPrinter:Say(0629,0980,cCepfor,oArial9N,,0)

  oPrinter:Say(0779,0036,"Cidade:",oArial10N,,0)

  oPrinter:Say(0779,0269,cCidfor,oArial9N,,0)

  oPrinter:Say(0680,0799,"Estado:",oArial10N,,0)

  oPrinter:Say(0681,0981,cEstfor,oArial9N,,0)

  oPrinter:Say(0827,0036,"CNPJ:",oArial10N,,0)

  oPrinter:Say(0829,0269,cCnpjfor,oArial9N,,0)

  oPrinter:Say(0727,0799,"Insc. Estadual:",oArial10N,,0)

  oPrinter:Say(0729,0980,cInscfor,oArial9N,,0)

  oPrinter:Box(0600,0030,0911,2420)

  oPrinter:Say(0872,0037,"Tel:",oArial10N,,0)

  oPrinter:Say(0873,0269,cTelfor,oArial9N,,0)

  oPrinter:Box(0027,0029,0097,0175)

  oPrinter:Say(0933,0036,"Qtde",oArialÎ9N,,0)
  
  oPrinter:Say(0933,0105,"Unid.",oArialÎ9N,,0)

  oPrinter:Say(0931,0211,"Código",oArialÎ10N,,0)

  oPrinter:Say(0931,0812,"Descrição",oArialÎ10N,,0)

  oPrinter:Say(0931,1822,"$ Unitário",oArialÎ10N,,0)

  oPrinter:Say(0933,1984,"$ Desc",oArialÎ10N,,0)

  oPrinter:Say(0933,2164,"$ Total",oArialÎ10N,,0)

  oPrinter:Say(0931,2350,"%IPI",oArialÎ10N,,0)

_nLin := 1000

While SC7->(!EOF()) .AND.SC7->C7_NUM ==MV_PAR01
oPrinter:Say(_nLin,036,TRANSFORM(SC7->C7_QUANT,"@E 999.99"),oArialÎ10N,,0)
oPrinter:Say(_nLin,0105,Posicione("SB1",1,XFILIAL("SB1")+SC7->C7_PRODUTO,"B1_UM"),oArialÎ10N,,0)
oPrinter:Say(_nLin,0211,SC7->C7_PRODUTO,oArialÎ10N,,0)
oPrinter:Say(_nLin,0812,Posicione("SB1",1,XFILIAL("SB1")+SC7->C7_PRODUTO,"B1_DESC"),oArialÎ10N,,0)
oPrinter:Say(_nLin,1822,ALLTRIM(TRANSFORM(SC7->C7_PRECO,"@E 999,999,999.99")),oArialÎ10N,,0)
oPrinter:Say(_nLin,1984,ALLTRIM(TRANSFORM(SC7->C7_DESC,"@E 999,999,999.99")),oArialÎ10N,,0)
oPrinter:Say(_nLin,2164,ALLTRIM(TRANSFORM(SC7->C7_TOTAL,"@E 999,999,999.99")),oArialÎ10N,,0)
oPrinter:Say(_nLin,2350,ALLTRIM(TRANSFORM(SC7->C7_VALIPI,"@E 999,999,999.99")),oArialÎ10N,,0)

_nTipi+=SC7->C7_VALIPI
_nTotal+=SC7->C7_TOTAL
_nLin+=43

IF _nLin>=3200
  oPrinter:EndPage()
  oPrinter:StartPage()
  _nLin=80
  oPrinter:Box(0027,0029,3273,2420)/*Margem*/
EndIF

SC7->(Dbskip())

Enddo
_nLin+=20
oPrinter:Box(_nLin,0027,_nLin+70,2420)
oPrinter:Say(_nLin+15,0721,"Total IPI: "+ALLTRIM(TRANSFORM(_nTipi,"@E 999,999,999.99")),oArialÎ10N,,0)
oPrinter:Say(_nLin+15,1245,"Total do Pedido: "+ALLTRIM(TRANSFORM(_nTotal,"@E 999,999,999.99")),oArialÎ10N,,0)

  Return
  
  Static Function fAjustSX1(_cPerg)

Local _aArea	:= GetArea()
Local aRegs		:= {}

dbSelectArea("SX1")
dbSetOrder(1)

_cPerg := padr(_cPerg,len(SX1->X1_GRUPO))

Aadd(aRegs,{_cPerg,"01","Pedido","MV_CH1" ,"C",6,0,"G","MV_PAR01","SC7","","","","",""})

DbSelectArea("SX1")
DbSetOrder(1)

For _i := 1 To Len(aRegs)
	
	If  !DbSeek(aRegs[_i,1]+aRegs[_i,2])
		RecLock("SX1",.T.)
		Replace X1_GRUPO   with aRegs[_i,01]
		Replace X1_ORDEM   with aRegs[_i,02]
		Replace X1_PERGUNT with aRegs[_i,03]
		Replace X1_VARIAVL with aRegs[_i,04]
		Replace X1_TIPO    with aRegs[_i,05]
		Replace X1_TAMANHO with aRegs[_i,06]
		Replace X1_PRESEL  with aRegs[_i,07]
		Replace X1_GSC     with aRegs[_i,08]
		Replace X1_VAR01   with aRegs[_i,09]
		Replace X1_F3      with aRegs[_i,10]
		Replace X1_DEF01   with aRegs[_i,11]
		Replace X1_DEF02   with aRegs[_i,12]
		Replace X1_DEF03   with aRegs[_i,13]
		Replace X1_DEF04   with aRegs[_i,14]
		Replace X1_DEF05   with aRegs[_i,15]
		MsUnlock()
	EndIf
	
Next _i

RestArea(_aArea)
  
Return