#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"
#Include "Ap5Mail.Ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa  ณ WKFCOM01 บ Autor ณ LUIZ EDUARDO F.C.  บ Data ณ  11/08/2017 บฑฑ
ฑฑฬอออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricao ณ ENVIA EMAL INFORMATIVO PARA O DEPTO. DE COMPRAS COM OS     บฑฑ
ฑฑบ           ณ PRODUTOS PERSONALIZADOS                                    บฑฑ
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Uso       ณ KOMFORT HOUSE - LOJAS                                      บฑฑ
ฑฑศอออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
USER FUNCTION WKFLOG01()
                       
Processa({|| CriaEmail() },"Enviando E-Mail... ")

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa  ณCriaEmail บ Autor ณ  Marcelo Chacon    บ Data ณ  02/10/08   บฑฑ
ฑฑฬอออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricao ณ Envia email com total das Sacolas Desvinculadas por loja.  บฑฑ
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Uso       ณ Shoebiz                                                    บฑฑ
ฑฑศอออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function CriaEmail()

Local cEmailTI    := "luiz.carmo@komforthouse.com.br" //GetMv("MV_MAMCTI",,"helpdesk@shoebiz.com.br") 
Local cCorpoEmail := ""

cCorpoEmail := CriaHtml()

SendMail(cEmailTI,"","","Pedido com Itens Personalizados - Data "+DToC(dDatabase-1),cCorpoEmail,"","","","","")

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa  ณ CriaHtml บ Autor ณ  Marcelo Chacon    บ Data ณ  02/10/08   บฑฑ
ฑฑฬอออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricao ณ Retorna string em HTML com o email.                        บฑฑ
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Uso       ณ Shoebiz                                                    บฑฑ
ฑฑศอออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

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
cHtml += "			<td colspan='3'>Relat๓rio de Sacolas Desvinculadas</td>"
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
	Pedido : </p>
<p>
	N๚mero Televendas : </p>
<p>
	Data de Emissใo : </p>
<p>
	Loja de Origem : </p>
<p>
	Vendedor : </p>
<hr />
<p>
	Produto : </p>
<p>
	Pre็o de Venda :</p>
<p>
	Quantidade : </p>
<hr />
<p style="text-align: center;">
	<strong>KOMFORT HOUSE SOFAS LTDA                                    </strong></p>
*/	


Return cHtml

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa  ณ SendMail บ Autor ณ  Marcelo Chacon    บ Data ณ  02/10/08   บฑฑ
ฑฑฬอออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricao ณ Envia email com total das Sacolas Desvinculadas por loja.  บฑฑ
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Uso       ณ Shoebiz                                                    บฑฑ
ฑฑศอออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function SendMail(cPara, cCopia1, cCopia2, cTitulo, cMensagem, cAnexo1, cAnexo2, cAnexo3, cAnexo4, cAnexo5)

Local cContaEmail := GetMv("MV_EMCONTA",,"protheus12@komforthouse.com.br")
Local cSenhaEmail := GetMv("MV_EMSENHA" ,,"u23iop")
Local cServidor   := GetMv("MV_RELSERV",,"br768.hostgator.com.br") // 50.116.86.75
Local lConexaoOk  := .F.
Local lEnvioOk    := .F.
Local cErro       := ""

Connect SMTP Server cServidor ACCOUNT cContaEmail PASSWORD cSenhaEmail Result lConexaoOk

//Se necessแrio, for็a autentica็ใo do servidor de e-mails
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
