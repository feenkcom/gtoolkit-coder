"
I am a {{gtClass:BrStencil}} that creates a default coder element or customized one, based on users configuration using {{gtMethod:GtCoderElementStencil class>>#defaultStencil:}}. 
I am an abstract class. See my {{gtClass:GtCoderElementStencil | show=#gtSubclassesFor: | expanded = true | label=subclasses}}
"
Class {
	#name : #GtCoderElementStencil,
	#superclass : #BrStencil,
	#classInstVars : [
		'defaultStencil'
	],
	#category : #'GToolkit-Coder-UI-Coder - Source'
}

{ #category : #clearing }
GtCoderElementStencil class >> clearDefaultStencil [
	defaultStencil := nil
]

{ #category : #accessing }
GtCoderElementStencil class >> defaultStencil [
	<return: #BrStencil or: nil>
	^ defaultStencil
]

{ #category : #accessing }
GtCoderElementStencil class >> defaultStencil: aStencil [
	defaultStencil := aStencil asStencil
]

{ #category : #'api - instantiation' }
GtCoderElementStencil >> create [
	^ self class defaultStencil
		ifNil: [ self defaultElement]
		ifNotNil: [ :aStencil | aStencil create ]
]

{ #category : #'api - instantiation' }
GtCoderElementStencil >> defaultElement [
	<return: #BlElement>
	^ self subclassResponsibility
]
