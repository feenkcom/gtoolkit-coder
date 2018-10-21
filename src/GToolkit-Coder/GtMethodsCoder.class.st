Class {
	#name : #GtMethodsCoder,
	#superclass : #Object,
	#instVars : [
		'methodCoders',
		'highlighter'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #'instance creation' }
GtMethodsCoder class >> forImplementors: aSymbol [
	| methods |
	methods := OrderedCollection new.
	Smalltalk
		allClassesDo: [ :each | 
			(each includesSelector: aSymbol)
				ifTrue: [ methods add: each >> aSymbol ] ].
	^ self forMethods: (self sortMethods: methods)
]

{ #category : #'instance creation' }
GtMethodsCoder class >> forMethods: compiledMethods [
	^ self new
		forMethods: compiledMethods;
		yourself
]

{ #category : #'instance creation' }
GtMethodsCoder class >> forReferences: aSymbol [
	| methods |
	methods := OrderedCollection new.
	Smalltalk allClassesDo: [ :each | (each thoroughWhichSelectorsReferTo: aSymbol) do: [ :sel | methods add: each >> sel ] ].
	^ self forMethods: (self sortMethods: methods)
]

{ #category : #private }
GtMethodsCoder class >> sortMethods: aCollection [
	^ aCollection
		asSortedCollection: [ :a :b | 
			a methodClass = b methodClass
				ifTrue: [ a selector < b selector ]
				ifFalse: [ a methodClass name < b methodClass name ] ]
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
	methodCoders := compiledMethods collect: [ :each | GtMethodCoder forMethod: each ]
]

{ #category : #ui }
GtMethodsCoder >> gtLiveFor: aView [
	<gtView>
	^ aView explicit 
		title: 'Live';
		priority: 10;
		stencil: [ self ]
]

{ #category : #accessing }
GtMethodsCoder >> highlighter [
	^ highlighter
]

{ #category : #accessing }
GtMethodsCoder >> highlighter: aReferenceHighlighter [
	highlighter := aReferenceHighlighter.
	methodCoders do: [ :each | each highlighter: aReferenceHighlighter ]
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
