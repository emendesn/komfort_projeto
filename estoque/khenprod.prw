#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณKHENPROD    บAutor  ณVanito Rocha      บ Data ณ  18/08/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Endereca automแtico as Ordens de Produ็ใo				  บฑฑ
ฑฑบ          ณ de acordo com os parโmetros informados pelo usuแrio        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rotina que faz endere็amento das Ordens de Produ็ใo        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function KHENPROD()

Local cAliasZL2:=GetNextAlias()
Local aArea :=GetArea()
Local cDocumen
Local aAuto:={}
Local alinha:={}
Local aItens:={}
Local cQuery:=""
Local xArmOri:='95'
Local xEndOri:='PXA.AA.A1'
Private lMsErroAuto	:= .F.
Private lMsHelpAuto	:= .F.

cQuery	:= " SELECT ZL2_OP, ZL2_COD, ZL2_ITEMNF, ZL2_LOCAL, ZL2_FORNE, ZL2_LOJA, ZL2_QUANT, ZL2_LOCALI, ZL2_D3DOC"
cQuery  += " FROM " + RetSqlName("ZL2") + " (NOLOCK) WHERE ZL2_OP<>'' AND ZL2_DTIMPR <>'' AND D_E_L_E_T_='' AND ZL2_ENDER='N' AND ZL2_QUANT > 0 AND ZL2_FILIAL='0101' "

TcQuery cQuery New Alias (cAliasZL2)

DbSelectArea(cAliasZL2)
DbGotop()
While (cAliasZL2)->(!EOF())
	aAdd(aItens,{ZL2_OP,;
	ZL2_COD,;
	ZL2_ITEMNF,;
	ZL2_FORNE,;
	ZL2_LOJA,;
	ZL2_QUANT,;
	ZL2_LOCAL,;
	ZL2_LOCALI,;
	ZL2_D3DOC})
	DbSkip()
Enddo


/*Tratamento para endere็ar o mesmo produto+endere็o repetido em apenas uma linha, a rotina de transferencias multiplas nใo permite mais de uma linha do mesmo produto para o mesmo endere็o
If ( nPos:= aScan(_aEndSld,{|R| R[1] == TRB->ENDERECO }) ) == 0
//Verifico se o saldo do endereco ainda esta dentro da capacidade
If TRB->SALDO+1 <= TRB->CAPACIDADE
//coloco o saldo mais um na posicao 2 do vetor para
//controlar o saldo caso seja utilizado o endereco novamente
aAdd(_aEndSld,{TRB->ENDERECO,TRB->SALDO+1,TRB->CAPACIDADE})
xLocaliz := TRB->ENDERECO
EXIT
Endif
Else
//Verifico se o saldo do endereco esta dentro da capacidade
//Quando ja usei o endereco eu uso a posicao 2 do vetor para
//controlar o saldo
If _aEndSld[nPos,2]+1 <= TRB->CAPACIDADE
_aEndSld[nPos,2]+= 1
xLocaliz := TRB->ENDERECO
EXIT
Endif
Endif


*/

(cAliasZL2)->(DbCloseArea())

IF Empty(cDocumen)
	cDocumen  := Criavar("D3_DOC")
	cDocumen	:= IIf(Empty(cDocumen),NextNumero("SD3",2,"D3_DOC",.T.),cDocumen)
	cDocumen	:= A261RetINV(cDocumen)
EndIf

aadd(aAuto,{cDocumen,dDataBase})

DbSelectArea("SD3")
DbSetOrder(1)
For nX := 1 to Len(aItens)
	aLinha := {}

	CriaSB2( aItens[nx,02], "01" )
	
	//Origem
	SB1->(DbSeek(xFilial("SB1")+PadR(aItens[nx,02], tamsx3('D3_COD') [1])))
	aadd(aLinha,{"ITEM",'00'+cvaltochar(nX),Nil})
	aadd(aLinha,{"D3_COD", aItens[nx,02], Nil}) //Cod Produto origem
	aadd(aLinha,{"D3_DESCRI", SB1->B1_DESC, Nil}) //descr produto origem
	aadd(aLinha,{"D3_UM", SB1->B1_UM, Nil}) //unidade medida origem
	aadd(aLinha,{"D3_LOCAL", xArmOri, Nil}) //armazem origem
	aadd(aLinha,{"D3_LOCALIZ", PadR(xEndOri, tamsx3('D3_LOCALIZ') [1]),Nil}) //Informar endereรงo origem
	
	//Destino
	SB1->(DbSeek(xFilial("SB1")+PadR(aItens[nx,02], tamsx3('D3_COD') [1])))
	aadd(aLinha,{"D3_COD", SB1->B1_COD, Nil}) //cod produto destino
	aadd(aLinha,{"D3_DESCRI", SB1->B1_DESC, Nil}) //descr produto destino
	aadd(aLinha,{"D3_UM", SB1->B1_UM, Nil}) //unidade medida destino
	aadd(aLinha,{"D3_LOCAL", aItens[nX,05], Nil}) //armazem destino
	aadd(aLinha,{"D3_LOCALIZ", PadR(aItens[nX,08], tamsx3('D3_LOCALIZ') [1]),Nil}) //Informar endereรงo destino
	aadd(aLinha,{"D3_NUMSERI", "", Nil}) //Numero serie
	aadd(aLinha,{"D3_LOTECTL", "", Nil}) //Lote Origem
	aadd(aLinha,{"D3_NUMLOTE", "", Nil}) //sublote origem
	aadd(aLinha,{"D3_DTVALID", '', Nil}) //data validade
	aadd(aLinha,{"D3_POTENCI", 0, Nil}) // Potencia
	aadd(aLinha,{"D3_QUANT", 1, Nil}) //Quantidade
	aadd(aLinha,{"D3_QTSEGUM", 0, Nil}) //Seg unidade medida
	aadd(aLinha,{"D3_ESTORNO", "", Nil}) //Estorno
	aadd(aLinha,{"D3_NUMSEQ", "", Nil}) // Numero sequencia D3_NUMSEQ
	aadd(aLinha,{"D3_LOTECTL", "", Nil}) //Lote destino
	aadd(aLinha,{"D3_NUMLOTE", "", Nil}) //sublote destino
	aadd(aLinha,{"D3_DTVALID", '', Nil}) //validade lote destino
	aadd(aLinha,{"D3_ITEMGRD", "", Nil}) //Item Grade
	aadd(aLinha,{"D3_CODLAN", "", Nil}) //cat83 prod origem
	aadd(aLinha,{"D3_CODLAN", "", Nil}) //cat83 prod destino
	aAdd(aAuto,aLinha)
Next nX

If !Empty(aAuto)
	MSExecAuto({|x,y| mata261(x,y)},aAuto, 3)
	If lMSErroAuto
		MsgAlert("Nใo foi possivel realizar as transferencias"+ cDocumen,"ATENวรO")
		MostraErro()
	Else
		xQuery:="UPDATE ZL2010 SET ZL2_ENDER='S' WHERE ZL2_OP<>'' AND ZL2_DTIMPR <>'' AND D_E_L_E_T_='' AND ZL2_ENDER='N' AND ZL2_QUANT > 0"
		
		TCSQLExec(xQuery)
		
		MsgAlert("Transferencia efetuada com sucesso "+cDocumen,"ATENวรO")
		
	Endif
Else
	MsgAlert("Nao existem Ordens de Produ็ใo para serem endere็adas, verifique se as etiquetas do endere็amento foram impressas")
Endif
Return
