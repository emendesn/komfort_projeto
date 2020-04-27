#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"
#Include "Ap5Mail.Ch"

/*����������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
��� Programa  � WKFLOJ01 � Autor � LUIZ EDUARDO F.C.  � Data �  11/08/2017 ���
��������������������������������������������������������������������������͹��
��� Descricao � ENVIA EMAL INFORMATIVO PARA O DEPTO. DE COMPRAS COM OS     ���
���           � PRODUTOS PERSONALIZADOS                                    ���
��������������������������������������������������������������������������͹��
��� Uso       � KOMFORT HOUSE - LOJAS                                      ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
����������������������������������������������������������������������������*/
USER FUNCTION WKFLOJ01(aDados)

Private aPedido := aDados

Processa({|| CriaEmail() },"Enviando E-Mail Informativo para o Depto. de Compras... ")

Return

/*����������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
��� Programa  �CriaEmail � Autor �  Marcelo Chacon    � Data �  02/10/08   ���
��������������������������������������������������������������������������͹��
��� Descricao � Envia email com total das Sacolas Desvinculadas por loja.  ���
��������������������������������������������������������������������������͹��
��� Uso       � Shoebiz                                                    ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
����������������������������������������������������������������������������*/

Static Function CriaEmail()

Local cEmailTI    := GETMV("KM_WLOJ01",,"compras@komforthouse.com.br")
Local cCorpoEmail := ""

cCorpoEmail := CriaHtml()

SendMail(cEmailTI,"","","Pedido com Itens Personalizados - Data "+DToC(dDatabase-1),cCorpoEmail,"","","","","")

Return

/*����������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
��� Programa  � CriaHtml � Autor �  Marcelo Chacon    � Data �  02/10/08   ���
��������������������������������������������������������������������������͹��
��� Descricao � Retorna string em HTML com o email.                        ���
��������������������������������������������������������������������������͹��
��� Uso       � Shoebiz                                                    ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
����������������������������������������������������������������������������*/

Static Function CriaHtml()

local cHtml		    := ""
Local nUB_PRODUTO 	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_PRODUTO"})
Local nUB_DESCPER 	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_DESCPER"})
Local nUB_DESCRI 	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_DESCRI" })
Local nUB_QUANT   	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_QUANT"  })

cHtml := "<html>"
cHtml += "<head></head>"
cHtml += "<body>"
cHtml += "<table width='1200px' align='center' style='border: 2px solid; background-color: #F5F5F5;'>"
cHtml += "		<tr style='font-size: 18px; font-weight: bold; text-align: center;'>"
cHtml += "			<td colspan='3'>WORKFLOW de Pedido de Venda Com Itens Personalizado</td>"
cHtml += "		<tr>"
cHtml += "		<tr>"
cHtml += "			<td colspan='3'><hr></td>"
cHtml += "		</tr>"
cHtml += "		<tr style='font-size: 12px; font-weight: bold; '>"
cHtml += "			<td colspan='3'>Pedido : " + SC5->C5_NUM + "</td>"
cHtml += "		</tr>"
cHtml += "		<tr style='font-size: 12px; font-weight: bold; '>"
cHtml += "			<td colspan='3'>N�mero Televendas : " + M->UA_NUM + "</td>"
cHtml += "		</tr>"
cHtml += "		<tr style='font-size: 12px; font-weight: bold; '>"
cHtml += "			<td colspan='3'>Data de Emiss�o : " + DTOC(M->UA_EMISSAO) + "</td>"
cHtml += "		</tr>"
cHtml += "		<tr style='font-size: 12px; font-weight: bold; '>"
cHtml += "			<td colspan='3'>Loja de Origem : " + SC5->C5_MSFIL + "</td>"
cHtml += "		</tr>"
cHtml += "		<tr style='font-size: 12px; font-weight: bold; '>"
cHtml += "			<td colspan='3'>Vendedor : " + M->UA_VEND + " - " + M->UA_DESCVEN + "</td>"
cHtml += "		</tr>"
cHtml += "		<tr>"
cHtml += "			<td colspan='3'><hr></td>"
cHtml += "		</tr>"
For nX:=1 To Len(aPedido)
	cHtml += "		<tr style='font-size: 12px; font-weight: bold; '>"
	cHtml += "			<td colspan='3'>Cod.Produto : " + aPedido[nX,nUB_PRODUTO] + " </td>"
	cHtml += "		</tr>"
	cHtml += "		<tr style='font-size: 12px; font-weight: bold; '>"
	cHtml += "			<td colspan='3'>Descri��o : " + aPedido[nX,nUB_DESCRI] + "</td>"
	cHtml += "		</tr>"
	cHtml += "		<tr style='font-size: 12px; font-weight: bold; '>"
	cHtml += "			<td colspan='3'>Descri��o Personalizado : " + aPedido[nX,nUB_DESCPER] + "</td>"
	cHtml += "		</tr>"
	cHtml += "		<tr style='font-size: 12px; font-weight: bold; '>"
	cHtml += "			<td colspan='3'>Quantidade : " + Alltrim(Transform(aPedido[nX,nUB_QUANT],"@E 999.99")) + "</td>"
	cHtml += "		</tr>"
	cHtml += "		<tr>"
	cHtml += "			<td colspan='3'><hr></td>"
	cHtml += "		</tr>"
Next
cHtml += "		<tr>"
cHtml += "			<td colspan='3'><hr></td>"
cHtml += "		</tr>"
cHtml += "		<tr style='font-size: 12px; font-weight: bold; text-align: center;'>"
cHtml += "			<td colspan='3'>KOMFORT HOUSE SOFAS LTDA</td>"
cHtml += "		</tr>"
cHtml += "		<tr>"
cHtml += "			<td colspan='3'><hr></td>"
cHtml += "		</tr>"
cHtml += "</table>"
cHtml += "</body>"
cHtml += "</html>"

Return cHtml
/*����������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
��� Programa  � SendMail � Autor �  Marcelo Chacon    � Data �  02/10/08   ���
��������������������������������������������������������������������������͹��
��� Descricao � Envia email com total das Sacolas Desvinculadas por loja.  ���
��������������������������������������������������������������������������͹��
��� Uso       � Shoebiz                                                    ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
����������������������������������������������������������������������������*/

Static Function SendMail(cPara, cCopia1, cCopia2, cTitulo, cMensagem, cAnexo1, cAnexo2, cAnexo3, cAnexo4, cAnexo5)

Local cContaEmail := GetMv("MV_EMCONTA",,"protheus12@komforthouse.com.br")
Local cSenhaEmail := GetMv("MV_EMSENHA" ,,"u23iop")
Local cServidor   := GetMv("MV_RELSERV",,"br768.hostgator.com.br") // 50.116.86.75
Local lConexaoOk  := .F.
Local lEnvioOk    := .F.
Local cErro       := ""

Connect SMTP Server cServidor ACCOUNT cContaEmail PASSWORD cSenhaEmail Result lConexaoOk

//Se necess�rio, for�a autentica��o do servidor de e-mails
If GetMv("MV_RELAUTH")
	MailAuth(cContaEmail,cSenhaEmail)
Endif

If lConexaoOk
	//Envia email conforme parametros com a funcao Send Mail
	Send Mail From cContaEmail;
	To cPara;
	CC cCopia1;
	BCC cCopia2;
	Subject cTitulo;
	Body cMensagem;
	Attachment cAnexo1, cAnexo2, cAnexo3, cAnexo4, cAnexo5;
	Result lEnvioOk
EndIf

If !lEnvioOk
	Get MAIL ERROR cErro
	Alert(cErro)
EndIf

Disconnect SMTP Server

Return
