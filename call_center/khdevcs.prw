#include 'protheus.ch'
#include 'parmtype.ch'

///////////////////////////////////////////////////
//| KHDEVCS - Devolucao de Cancela Substiui
//| Autor - Wellington Raul Pinto 
//| Objetivo - Ajustar o saldo do cancela substitui 
//| devolvendo o produto para o armazem da loja 
///////////////////////////////////////////////////

user function KHDEVCS(cNumPed,cDocNf,cLoja)
Local aCabec 	 	:= {}//cabecario do execauto
Local aItens 	 	:= {}//itens do execauto 
Local aLinha 	 	:= {}//Array temporario
Local aAd1			:= {}//Array da query SD1
Local aAF1			:= {}//Array da query Sf1
Local cQuery     	:= "" 
local cQuF1 		:= ""
Local cAliD2     	:= GetNextAlias()
Local cAliF2     	:= GetNextAlias()
local cNumDoc     	:= CriaVar("F1_DOC"		,.F.)
local cSerieDoc	 	:= CriaVar("F1_SERIE"	,.F.)
local cTpEspecie 	:= CriaVar("F1_ESPECIE"	,.F.)
PRIVATE lMsErroAuto  := .F.

cSerieDoc := "1  "
cNumDoc := NxtSX5Nota( cSerieDoc )

/////////////////////////////////////////////////////////////
//| Efetuo o Select nas tabelas SD2 e SF2 com o pedido e a NF
/////////////////////////////////////////////////////////////

cQuery := CRLF + "  SELECT D2_ITEM,D2_COD,D2_QUANT,D2_TOTAL,D2_TES,D2_CF,D2_DOC,D2_SERIE,D2_EMISSAO,"
cQuery += CRLF + "  D2_NFORI,D2_SERIORI,D2_ITEMORI,D2_PRUNIT,D2_IDENTB6,D2_LOCAL FROM SD2010 (NOLOCK) "
cQuery += CRLF + "  WHERE D2_PEDIDO  = '"+cNumPed+"'"
cQuery += CRLF + "  AND D2_DOC = '"+cDocNf+"' "
cQuery += CRLF + "  AND D_E_L_E_T_ = '' "
cQuery += CRLF + "  ORDER BY D2_ITEM "

PlSquery(cQuery,cAliD2)

While (cAliD2)->(!EOF())
Aadd(aAd1,{ (cAliD2)->D2_ITEM,;
			(cAliD2)->D2_COD,;
			(cAliD2)->D2_QUANT,;
			(cAliD2)->D2_TOTAL,;
			(cAliD2)->D2_TES,;
			(cAliD2)->D2_CF,;
			(cAliD2)->D2_DOC,;
			(cAliD2)->D2_SERIE,;
			(cAliD2)->D2_EMISSAO,;
			(cAliD2)->D2_NFORI,;
			(cAliD2)->D2_SERIORI,;
			(cAliD2)->D2_ITEMORI,;
			(cAliD2)->D2_PRUNIT,;
			(cAliD2)->D2_IDENTB6,;
			(cAliD2)->D2_LOCAL})
	(cAliD2)->(DbSkip())
EndDo

cQuF1 := CRLF + "   SELECT F2_LOJA,F2_SERIE,F2_ESPECIE,F2_CLIENTE, F2_CHVNFE FROM SF2010 (NOLOCK) "
cQuF1 += CRLF + "   WHERE F2_DOC = '"+cDocNf+"' "
cQuF1 += CRLF + "   AND D_E_L_E_T_ = '' "
cQuF1 += CRLF + "   AND F2_FILIAL = '"+cLoja+"' "


PlSquery(cQuF1,cAliF2)

While (cAliF2)->(!EOF())
Aadd(aAF1,{ (cAliF2)->F2_LOJA,;
			(cAliF2)->F2_SERIE,;
			(cAliF2)->F2_ESPECIE,;
			(cAliF2)->F2_CLIENTE,;
			(cAliF2)->F2_CHVNFE})
	(cAliF2)->(DbSkip())
EndDo

/////////////////////////////////////////////////////
//| Certifico que os as duas consultas tem registros 
/////////////////////////////////////////////////////

IF len(aAF1) >0 .and. len(aAd1) >0

aCabec := {}
aItens := {}

//////////////////////////////////////////////////////////////////////
//| O cabecario foi alterado devido a uma insercao manual para teste e 
//| foi necessario adicionar o campo F1_CHVNFE obrigatorio quando
//| O tipo for devolucao e o formulario igual a nao
//////////////////////////////////////////////////////////////////////

aadd(aCabec,{"F1_TIPO" ,"D" })
aadd(aCabec,{"F1_FORMUL" ,"N" })
aadd(aCabec,{"F1_DOC" ,cNumDoc })
aadd(aCabec,{"F1_SERIE" ,"1  " })
aadd(aCabec,{"F1_EMISSAO" ,dDataBase })
aadd(aCabec,{"F1_FORNECE" ,"000001"})
aadd(aCabec,{"F1_LOJA" ,"01"})
aadd(aCabec,{"F1_ESPECIE" ,aAF1[1][3]})
aadd(aCabec,{"F1_CHVNFE" ,aAF1[1][5]})
aadd(aCabec,{"F1_XCANSUB" ,cLoja+"- Dev CS"})			
			

for nx := 1 to len (aAd1)
aLinha := {}
	aadd(aLinha,{"D1_ITEM" ,aAd1[nx][1] ,Nil})
	aadd(aLinha,{"D1_COD" ,aAd1[nx][2] ,Nil})
	aadd(aLinha,{"D1_QUANT" ,aAd1[nx][3] ,Nil})
	aadd(aLinha,{"D1_VUNIT" ,aAd1[nx][13] ,Nil})
	aadd(aLinha,{"D1_TOTAL" ,aAd1[nx][4] ,Nil})
	aadd(aLinha,{"D1_LOCAL" ,aAd1[nx][15] ,Nil})
	aadd(aLinha,{"D1_TES" ,"055" ,Nil})//tes de devolucao
	aAdd(aLinha,{"D1_CF" ,"1202" ,Nil})
	aAdd(aLinha,{"D1_DOC" ,cNumDoc ,Nil}) // *
	aAdd(aLinha,{"D1_SERIE" ,"1  " ,Nil}) // *
	aAdd(aLinha,{"D1_EMISSAO",dDataBase ,Nil}) // 
	aadd(aLinha,{"D1_NFORI" ,aAd1[nx][7]  ,Nil}) // nota de origem
	aadd(aLinha,{"D1_SERIORI",aAd1[nx][8]  ,Nil})
	aadd(aLinha,{"D1_ITEMORI",aAd1[nx][1] ,Nil})
	AAdd(aLinha,{"D1_IDENTB6",aAd1[nx][14] ,Nil}) // d2_nunseq
	aadd(aLinha,{"AUTDELETA" ,"N" ,Nil})
	aadd(aItens,aLinha)
next nx

//////////////////////////////////////////
//| Execauto para efetuar a devolução
//////////////////////////////////////////

MSExecAuto({|x,y,z| mata103(x,y,z)},aCabec,aItens,3)

If !lMsErroAuto
ConOut("Incluido com sucesso! "+cNumDoc)
Else
ConOut("Erro na inclusao!")
mostraerro()
EndIf

EndIf	
	
	
return