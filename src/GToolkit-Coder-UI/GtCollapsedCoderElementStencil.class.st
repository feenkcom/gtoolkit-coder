"
I create a basic collapsed coder element used by {{gtClass:GtCoderMethodsGroupedListElement}}. 
Such collapsed coder element is created in the {{gtMethod:GtExpandableSourceCoderElement>>#newCollapsedElement}} method. 
Users can set their own stencil using {{gtMethod:GtCollapsedCoderElementStencil class>>#defaultStencil:}}. 

"
Class {
	#name : #GtCollapsedCoderElementStencil,
	#superclass : #BrStencil,
	#classVars : [
		'DefaultStencil'
	],
	#category : #'GToolkit-Coder-UI-Coder - Source'
}

{ #category : #accessing }
GtCollapsedCoderElementStencil class >> defaultStencil [
	^ DefaultStencil
]

{ #category : #accessing }
GtCollapsedCoderElementStencil class >> defaultStencil: aStencil [
	DefaultStencil := aStencil asStencil
]

{ #category : #'api - instantiation' }
GtCollapsedCoderElementStencil >> create [
	^ DefaultStencil
		ifNil: [ GtSourceCoderCollapsedContentElement new ]
		ifNotNil: [ :aStencil | aStencil create ]
]
