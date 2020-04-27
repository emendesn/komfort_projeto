#include 'protheus.ch' 
#include 'totvs.ch' 
#include 'topconn.ch' 
#include 'parmtype.ch'

/*/{Protheus.doc} LISRECLA
(long_description)
@author    wellington.raul
@since     06/11/2019
@version   ${version}
@example
(examples)
@see (links_or_references)
/*/
class LISRECLA 
	data list as array
    method New()
    method AddObject(object)
endclass

method New() class LISRECLA
    self:list:= {}
return 

method AddObject(object) class LISRECLA
    aAdd(self:list,object)
return 






