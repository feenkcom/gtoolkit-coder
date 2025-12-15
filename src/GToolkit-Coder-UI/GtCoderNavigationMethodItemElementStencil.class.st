"
I create a basic method item element used by {{gtClass:GtCoderMethodsGroupedListElement}}. 
Such method item elements are created in the {{gtMethod:GtCoderMethodsGroupedListElement>>#buildMethodItem}} method. 
Users can set their own stencil using {{gtMethod:GtCoderNavigationMethodItemElementStencil class>>#defaultStencil:}}. 

"
Class {
	#name : #GtCoderNavigationMethodItemElementStencil,
	#superclass : #BrStencil,
	#classVars : [
		'DefaultStencil'
	],
	#category : #'GToolkit-Coder-UI-Navigation - Helpers'
}

{ #category : #accessing }
GtCoderNavigationMethodItemElementStencil class >> defaultStencil [
	^ DefaultStencil
]

{ #category : #accessing }
GtCoderNavigationMethodItemElementStencil class >> defaultStencil: aStencil [
	"Users can customize their default navigation method item element"

	DefaultStencil := aStencil asStencil
]

{ #category : #'api - instantiation' }
GtCoderNavigationMethodItemElementStencil >> create [
	^ DefaultStencil
		ifNil: [ GtCoderNavigationCompiledMethodElement new ]
		ifNotNil: [ :aStencil | aStencil create ]
]
