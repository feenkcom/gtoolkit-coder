"
I create a basic collapsed coder element used by {{gtClass:GtCoderMethodsGroupedListElement}}. 
Such collapsed coder element is created in the {{gtMethod:GtExpandableSourceCoderElement>>#newCollapsedElement}} method. 
Users can set their own stencil using {{gtMethod:GtCollapsedCoderElementStencil class>>#defaultStencil:}}. 

"
Class {
	#name : #GtCollapsedCoderElementStencil,
	#superclass : #GtCoderElementStencil,
	#category : #'GToolkit-Coder-UI-Coder - Source'
}

{ #category : #'api - instantiation' }
GtCollapsedCoderElementStencil >> defaultElement [
	<return: #BlElement>
	^ GtSourceCoderCollapsedContentElement new
]
