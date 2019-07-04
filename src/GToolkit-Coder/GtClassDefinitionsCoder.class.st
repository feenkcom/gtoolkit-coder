Class {
	#name : #GtClassDefinitionsCoder,
	#superclass : #GtCoders,
	#instVars : [
		'class'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #'instance creation' }
GtClassDefinitionsCoder class >> forClass: aClass [
	^ self new
		forClass: aClass;
		yourself
]

{ #category : #elements }
GtClassDefinitionsCoder >> elementClass [
	^ GtMethodsCoderElement
]

{ #category : #'instance creation' }
GtClassDefinitionsCoder >> forClass: aBehavior [
	self flag: 'FIXME should listen class definition change'.
	class := aBehavior.
	self
		forItems:
			{class instanceSide.
			class classSide}
]

{ #category : #'instance creation' }
GtClassDefinitionsCoder >> newCoderFor: aBehavior [
	^ GtClassDefinitionCoder forClass: aBehavior
]
