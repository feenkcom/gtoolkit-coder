Class {
	#name : #GtMethodsCoder,
	#superclass : #Object,
	#instVars : [
		'methodCoders',
		'methods'
	],
	#category : #'GToolkit-Coder-Coders'
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
	methods := compiledMethods.
	methodCoders := methods collect: [ :each | GtMethodCoder forMethod: each ].
	(methods isKindOf: GtCoderMethodsCollection)
		ifTrue: [ methods announcer weak
				when: ValueAdded send: #methodAdded: to: self;
				when: ValueChanged send: #methodChanged: to: self;
				when: ValueRemoved send: #methodRemoved: to: self.
			methodCoders do: [ :each | each highlighter: methods highlighter ] ]
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

{ #category : #'event handling' }
GtMethodsCoder >> methodAdded: aValueAdded [
	| coder |
	coder := GtMethodCoder forMethod: aValueAdded newValue.
	methodCoders add: coder
]

{ #category : #'event handling' }
GtMethodsCoder >> methodChanged: aValueChanged [
	methodCoders
		do: [ :each | 
			(each isForMethod: aValueChanged newValue)
				ifTrue: [ each updateMethod: aValueChanged newValue ] ]
]

{ #category : #accessing }
GtMethodsCoder >> methodCoders [
	^ methodCoders
]

{ #category : #accessing }
GtMethodsCoder >> methodCoders: anObject [
	methodCoders := anObject
]

{ #category : #'event handling' }
GtMethodsCoder >> methodRemoved: aValueRemoved [
	methodCoders removeAllSuchThat: [ :each | each isForMethod: aValueRemoved oldValue ]
]
