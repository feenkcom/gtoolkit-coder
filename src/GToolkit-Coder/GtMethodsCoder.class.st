Class {
	#name : #GtMethodsCoder,
	#superclass : #Object,
	#instVars : [
		'methodCoders'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #'instance creation' }
GtMethodsCoder class >> forMethods: compiledMethods [
	^ self new
		forMethods: compiledMethods;
		yourself
]

{ #category : #elements }
GtMethodsCoder >> asElement [
	| listElement |
	listElement := BrSimpleList new.
	listElement stencil: [ :each | each asElement ].
	listElement padding: (BlInsets all: 10).
	listElement
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	listElement display: methodCoders.
	^ listElement
]

{ #category : #'initialize-release' }
GtMethodsCoder >> forMethods: compiledMethods [
	methodCoders := compiledMethods collect: [ :each | GtMethodCoder forMethod: each ].
	(compiledMethods isKindOf: GtCoderMethodsCollection)
		ifTrue: [ methodCoders do: [ :each | each highlighter: compiledMethods highlighter ] ]
]

{ #category : #ui }
GtMethodsCoder >> gtLiveFor: aView [
	<gtView>
	^ aView explicit 
		title: 'Live';
		priority: 10;
		stencil: [ self ]
]

{ #category : #'initialize-release' }
GtMethodsCoder >> initialize [
	super initialize.
	methodCoders := #()
]

{ #category : #accessing }
GtMethodsCoder >> methodCoders [
	^ methodCoders
]

{ #category : #accessing }
GtMethodsCoder >> methodCoders: anObject [
	methodCoders := anObject
]
