#include 'protheus.ch' 
#include 'totvs.ch' 
#include 'topconn.ch' 
#include 'parmtype.ch'

/*/{Protheus.doc} SB1RECLA
(long_description)
@author    wellington.raul
@since     05/11/2019
@version   ${version}
@example
(examples)
@see (links_or_references)
/*/
class SB1RECLA 
	data id as string 
	data url as string
	data name as string
	data price as nunber 	
	method New(id,url,name,price)
    method setData(id,url,name,price)
endclass

method New(id,url,name,price) class SB1RECLA
	Default id    := 'GRAREV0002A8011'
	Default url   := 'https://www.komforthouse.com.br/'
	Default name  := 'SOFA REVOLUTION 2 LUG 1.62X0.77X1.11 TC 9177/10568 .'
	Default price := 1.699
return

method setData(id,url,name,price) class SB1RECLA
	self:id    := id
	self:url   := url
	self:name  := name
	self:price := price
return 