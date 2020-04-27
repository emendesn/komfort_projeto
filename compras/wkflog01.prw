#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"
#Include "Ap5Mail.Ch"

/*����������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
��� Programa  � WKFCOM01 � Autor � LUIZ EDUARDO F.C.  � Data �  11/08/2017 ���
��������������������������������������������������������������������������͹��
��� Descricao � ENVIA EMAL INFORMATIVO PARA O DEPTO. DE COMPRAS COM OS     ���
���           � PRODUTOS PERSONALIZADOS                                    ���
��������������������������������������������������������������������������͹��
��� Uso       � KOMFORT HOUSE - LOJAS                                      ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
����������������������������������������������������������������������������*/
USER FUNCTION WKFLOG01()
                       
Processa({|| CriaEmail() },"Enviando E-Mail... ")

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

Local cEmailTI    := "luiz.carmo@komforthouse.com.br" //GetMv("MV_MAMCTI",,"helpdesk@shoebiz.com.br") 
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

local cHtml		  := ""
Local aFilial     := {}
Local aEmpresa    := {}
Local cFilNew     := ""
Local cFilOld     := ""
Local nX          := 0
Local nY		  := 0
Local nZ		  := 0
Local cQuery      := ""
Local nSpace      := 0
Local nTotFil1    := 0
Local nTotGeral1  := 0
Local nTotFil2    := 0
Local nTotGeral2  := 0
Local nTotGeral3  := 0
Local nTotGeral4  := 0
Local nTotQtdSac  := 0
Local nQtdVendas  := 0
Local nLimite     := GetMv("MV_MAMINSC",,20) //Quantidade de minutos permitida com a sacola vinculada.
Local nHoraVenda  := 0
Local nHoraLog    := 0
Local nTotMinVinc := 0
Local nHoraVinc   := 0
Local nMinVinc    := 0
Local cHoraVd     := ""
Local cTexto      := ""
Local cTexto1     := ""
Local cTexto2     := ""
Local cTexto3     := ""
Local cTexto4     := ""
Local nQtdSacola  := 0
Local aMensagem   := {}

cHtml := "<html>"
cHtml += "<head></head>"
cHtml += "<body>"
cHtml += "<table width='550px' align='center' style='border: 2px solid; background-color: #FFFFF0;'>"
cHtml += "		<tr style='font-size: 16px; font-weight: bold; text-align: center;'>"
cHtml += "			<td colspan='3'>Relat�rio de Sacolas Desvinculadas</td>"
cHtml += "		<tr>"
cHtml += "		<tr style='font-size: 16px; font-weight: bold; text-align: center;'>"
cHtml += "			<td colspan='3'></td>"
cHtml += "		</tr>"
cHtml += "		</tr>"
cHtml += "		<tr>"
cHtml += "			<td colspan='3'><hr></td>"
cHtml += "		</tr>"
cHtml += "</table>"
cHtml += "</body>"
cHtml += "</html>"    

/*
<hr />
<p style="text-align: center;">
	<span style="color:#000080;"><span style="font-size:16px;"><strong>WORKFLOW de Pedido de Venda Personalizado</strong></span></span></p>
<hr />
<p>
	Pedido :�</p>
<p>
	N�mero Televendas :�</p>
<p>
	Data de Emiss�o :�</p>
<p>
	Loja de Origem :�</p>
<p>
	Vendedor :�</p>
<hr />
<p>
	Produto :�</p>
<p>
	Pre�o de Venda :</p>
<p>
	Quantidade :�</p>
<hr />
<p style="text-align: center;">
	<strong>KOMFORT HOUSE SOFAS LTDA � � � � � � � � � � � � � � � � � �</strong></p>
*/	


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
