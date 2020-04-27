#include 'protheus.ch'
#include 'parmtype.ch'

//--------------------------------------------------------------
/*/{Protheus.doc} KHGETCLI
Description //Grava os  clientes na tabela muro para o reclame aqui
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul
@since: 03-12-2019 /*/
/* Documentação:
Busca os clientes que estão na regras para gravação da tabela muro e posterior 
Envio para o reclame aqui.
*/
//--------------------------------------------------------------
user function KHGETCLI()

Local cQuery := ""
Local cAlias := getNextAlias()
Local _dData := Date()-5
Private aClie := {}

cQuery := CRLF + " SELECT DISTINCT C6_NUM,A1_COD,A1_NOME,A1_EMAIL,C6_PRODUTO,C6_ITEM,B1_DESC,C6_DATFAT,C6_ENTREG, "
cQuery += CRLF + " CASE   "
cQuery += CRLF + " WHEN DAH_XDESCR = '' THEN 'SEM REGISTRO'   "
cQuery += CRLF + " WHEN DAH_XDESCR <> '' THEN DAH_XDESCR   "
cQuery += CRLF + " END   "
cQuery += CRLF + " AS ENTREGA "
cQuery += CRLF + " FROM SA1010 (NOLOCK) A1   "
cQuery += CRLF + " INNER JOIN SC6010 (NOLOCK) C6  "
cQuery += CRLF + " ON A1.A1_COD = C6.C6_CLI  "
cQuery += CRLF + " INNER JOIN SB1010 (NOLOCK) B1  "
cQuery += CRLF + " ON B1_COD = C6_PRODUTO    "
cQuery += CRLF + " INNER JOIN SC5010 C5 (NOLOCK)   "
cQuery += CRLF + " ON  C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM  "
cQuery += CRLF + " LEFT OUTER JOIN SD2010 D2 (NOLOCK) ON D2.D_E_L_E_T_ = '' AND SUBSTRING(C5_FILIAL,1,2) = SUBSTRING(D2_FILIAL,1,2) AND C5_NUM = D2_PEDIDO AND C6_ITEM = D2_ITEMPV  "
cQuery += CRLF + " LEFT OUTER JOIN SD1010 D1 (NOLOCK) ON D1.D_E_L_E_T_ = '' AND D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_CLIENTE = D1_FORNECE AND D2_LOJA = D1_LOJA AND D2_ITEM = D1_ITEMORI  "
cQuery += CRLF + " LEFT JOIN DAI010(NOLOCK) AI "
cQuery += CRLF + " ON AI.DAI_PEDIDO = C6.C6_NUM AND AI.DAI_CLIENT = C6.C6_CLI    "
cQuery += CRLF + " LEFT JOIN DAH010(NOLOCK) AH  "
cQuery += CRLF + " ON AH.DAH_CODCAR = AI.DAI_COD AND AH.DAH_SEQUEN = AI.DAI_SEQUEN AND AI.DAI_CLIENT = AH.DAH_CODCLI  "
cQuery += CRLF + " WHERE A1.D_E_L_E_T_ = '' "
cQuery += CRLF + " AND B1.D_E_L_E_T_ = '' "
cQuery += CRLF + " AND C6.C6_NOTA <> '' "
cQuery += CRLF + " AND C6.C6_BLQ <> 'R' "
cQuery += CRLF + " AND C5.C5_CLIENTE <> '000001' "
cQuery += CRLF + " AND AH.D_E_L_E_T_ = ''  "
cQuery += CRLF + " AND C6.D_E_L_E_T_ = ''"
cQuery += CRLF + " AND C6_ENTREG  =  '"+DTOS(_dData)+"' "
cQuery += CRLF + " AND AH.DAH_XDESCR NOT  LIKE '%NAO%' "
cQuery += CRLF + " AND AH.DAH_XDESCR NOT  LIKE '%DEVOLU%' "
cQuery += CRLF + " AND D1.D1_DOC IS NULL "
cQuery += CRLF + " AND C5_CLIENTE NOT IN ( "
cQuery += CRLF + " SELECT E1_CLIENTE FROM SE1010 (NOLOCK) "
cQuery += CRLF + " WHERE E1_PREFIXO IN ('MAN','SAC')  "
cQuery += CRLF + " AND D_E_L_E_T_ = ''   "
cQuery += CRLF + " AND E1_CLIENTE = C5.C5_CLIENTE "
cQuery += CRLF + " ) "
cQuery += CRLF + " ORDER BY C6_ENTREG ASC "

 

PlsQuery(cQuery,cAlias)

While (cAlias)->(!EOF())
	Aadd(aClie,{(cAlias)->C6_NUM,;      //1
				(cAlias)->A1_COD,;		//2
				(cAlias)->A1_NOME,;     //3
				(cAlias)->A1_EMAIL,;    //4
				(cAlias)->C6_PRODUTO,;  //5
				(cAlias)->C6_ITEM,;     //6
				(cAlias)->B1_DESC,;     //7
				(cAlias)->C6_DATFAT,;   //8
				(cAlias)->C6_ENTREG,;   //9
				(cAlias)->ENTREGA})     //10
    (cAlias)->(DbSkip())	
End
	(cAlias)->(DbCloseArea())
	
	fGrava()
	
return

//-------------------------------------------------
/* Documentação:
Função: fGrava() 
Objetivo: Gravar os clientes nas tabelas muro
Autor: Wellington Raul Pinto
Data: 03-12-2019
*/
//-------------------------------------------------
Static Function fGrava()
Local nx
local cCodZ0 := ""
Local nPosi := 0
Local cNome := ""
Local cSobre := ""
Local cCodZ1 := ""

DbSelectArea('Z20')
DbSelectArea('Z21')
for nx := 1 to len(aClie)
		 Z20->(DbSetorder(1))	
	if ! Z20->(DbSeek(Alltrim(aClie[nx][01]))) 
		    cCodZ0 := GetSxeNum("Z20","Z20_COD")
		    nPosi  := AT(" ",Alltrim(aClie[nx][03]))
		    cNome  := SubStr(Alltrim(aClie[nx][03]),1,nPosi)
		    cSobre := SubStr(Alltrim(aClie[nx][03]),nPosi) 		    
			RecLock("Z20",.T.)
				Z20_COD 	:= cCodZ0
				Z20_PEDIDO  := Alltrim(aClie[nx][01])
				Z20_NOME    := cNome
				Z20_SBNOME  := Alltrim(cSobre)
				Z20_EMAIL   := Alltrim(aClie[nx][04])
				Z20_ENTREG  := aClie[nx][09]
				Z20_STATUS  := '1' 
			Z20->(MsUnLock())
			ConfirmSx8()
			//cCodZ1 := cCodZ0
	EndIf
		 Z21->(DbSetorder(2))
	if ! Z21->(DbSeek(Alltrim(aClie[nx][01])+Alltrim(aClie[nx][05])+Alltrim(aClie[nx][06])))
			RecLock("Z21",.T.)
				//Z21_CODIGO := cCodZ1
				Z21_PEDIDO := Alltrim(aClie[nx][01])
				Z21_CODCLI := Alltrim(aClie[nx][02])
				Z21_CODPRO := Alltrim(aClie[nx][05])
				Z21_ITEM   := Alltrim(aClie[nx][06])
				Z21_DESCPR := Alltrim(aClie[nx][07]) 
				Z21_DTFATU := aClie[nx][08]
				Z21_ENTREG := Alltrim(aClie[nx][10])
			Z21->(MsUnLock())
   EndIf
Next nx

Z20->(DbCloseArea())
Z21->(DbCloseArea())

Return


//--------------------------------------------------------------
/*/{Protheus.doc} JBGETCLI
Description //Chama a rotina de projetos via Schedule
@param xParam Parameter Description
@return xRet Return Description
@author  - wellington raul pinto
@since: 26-06-2019 /*/
//--------------------------------------------------------------
User Function JBGETCLI()

    Local _aEnv := {}

    _aEnv := {'01','0101'}
    RPCClearEnv()
    RPCSetType(3)
    RPCSetEnv(_aEnv[1], _aEnv[2])
    U_KHGETCLI()
    RPCClearEnv()
Return()

