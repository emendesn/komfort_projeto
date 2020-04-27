#include 'protheus.ch'
#include 'parmtype.ch'



/*/{Protheus.doc} KHECOM07
//TODO Gera XML dos produtos do e-commerce  
@author Wellington Raul Pinto
@since 21/01/2020
@version 3.0
@return ${return}, ${return_description}

@type function
/*/

user function KHECOM07()

Local cXml:= ""
Local cQuery := ""
Local cAlias := GetNextAlias()
Local aKits := {}
Local cFile := "C:\rel\arquivo.txt"
Local nArqui
Local oCriaTxt 
Loca _Lret := .F.

cQuery := CRLF + "  SELECT  SUBSTRING(ZKC_CODPAI,1,14) as CODINTERNO , ZKC_DESCRI, ZKC_DESCST,ZKC_PRCDE, "
cQuery += CRLF + "  CASE  "
cQuery += CRLF + "  WHEN B1_XPRECV > 0 THEN SUM(ROUND(B1_XPRECV,2)) "
cQuery += CRLF + "  ELSE SUM(ROUND(B1_PRV1,2)) END PRECO "
cQuery += CRLF + "  FROM ZKC010(NOLOCK) ZKC "
cQuery += CRLF + "  INNER JOIN ZKD010(NOLOCK) ZKD ON ZKD_CODPAI = ZKC_CODPAI  "cQuery += CRLF + "  INNER JOIN " + RetSqlName("SB2") + "(NOLOCK) SB2 ON B2_COD = ZKD_CODFIL  "
cQuery += CRLF + "  INNER JOIN SB1010 (NOLOCK) SB1 ON B1_COD = B2_COD  "
cQuery += CRLF + "  WHERE SB2.D_E_L_E_T_ = '' "
cQuery += CRLF + "  AND SB1.D_E_L_E_T_ = '' "
cQuery += CRLF + "  AND ZKD.D_E_L_E_T_ = '' "
cQuery += CRLF + "  AND ZKC.D_E_L_E_T_ = '' "
cQuery += CRLF + "  AND B2_LOCAL = '15' "
cQuery += CRLF + "  AND B2_FILIAL = '0101' "
cQuery += CRLF + "  AND B2_QATU -B2_QEMP - B2_RESERVA > 0  "
cQuery += CRLF + "  AND ZKC_ECOM = '1' "
cQuery += CRLF + "  AND ZKC_MSBLQL = '2' "
cQuery += CRLF + "  GROUP BY ZKC_CODPAI, ZKC_DESCRI,ZKC_DESCST, ZKC_PRCDE,B1_XPRECV,B1_PRV1 "

PlsQuery(cQuery,cAlias)
While (cAlias)->(!EOF())
Aadd(aKits,{ (cAlias)->CODINTERNO,;
			 (cAlias)->ZKC_DESCRI,;
			 (cAlias)->ZKC_DESCST,;
			 (cAlias)->ZKC_PRCDE,;
			 (cAlias)->PRECO})
(cAlias)->(DbSkip())
Enddo
(cAlias)->(DbCloseArea())


cXml := CRLF + " <rss "	
cXml += CRLF + " xmlns:g='http://base.google.com/ns/1.0'version='2.0'> " 
cXml += CRLF + " <channel> "
cXml += CRLF + " <title>komforthouse</title>  "
cXml += CRLF + " <link>http://www.komforthouse.com.br</link> "
cXml += CRLF + " <description>...</description> "
For nx := 1 to len(aKits)	
cXml += CRLF + " <item> "
cXml += CRLF + " <title>"+Alltrim(aKits[nx][2])+"</title> "
cXml += CRLF + " <link>https://busca.komforthouse.com.br/"+aKits[nx][1]+"?q="+aKits[nx][1]+"</link> "
cXml += CRLF + " <description>"+aKits[nx][3]+"</description> "
cXml += CRLF + " <g:id>"+aKits[nx][1]+"</g:id> "
cXml += CRLF + " <g:condition>Exemplos:novo/usado/seminovo</g:condition> "
cXml += CRLF + " <g:price>"+cValtochar(aKits[nx][4])+"</g:price> "
cXml += CRLF + " <g:sale_price>"+cValtochar(aKits[nx][5])+"</g:sale_price> "
cXml += CRLF + " <g:image_link>https://www.komforthouse.com.br/product/image/"+aKits[nx][1]+"/"+aKits[nx][1]+"/Vitrine/sofa-3-lugares-marrom-vancouver.ashx</g:image_link> "
cXml += CRLF + " </item>
Next nx
cXml += CRLF + " </channel> "
cXml += CRLF + " </rss> "        


oCriaTxt := MNGTXT():new()

 _Lret := oCriaTxt:CriaTXT(cFile)
 
 If ! _Lret
 MsgAlert("Problemas na criaçã do arquivo")
 Return
 EndIf

//oCriaTxt:AbreTXT(cFile)
oCriaTxt:GravaTXT(.F.,cXml)
oCriaTxt:FechaTXT()

return