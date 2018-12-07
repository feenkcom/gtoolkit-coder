Class {
	#name : #GtMethodsCoder,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'announcer',
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

{ #category : #announcer }
GtMethodsCoder >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #elements }
GtMethodsCoder >> asElement [
	^ GtMethodsCoderElement new
		methodsCoder: self;
		yourself
]

{ #category : #accessing }
GtMethodsCoder >> coders [
	^ methodCoders
]

{ #category : #'initialize-release' }
GtMethodsCoder >> forMethods: compiledMethods [
	methods := compiledMethods.
	methodCoders := methods collect: [ :each | self newMethodCoderFor: each ].
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

{ #category : #elements }
GtMethodsCoder >> look [
	^ nil
]

{ #category : #'event handling' }
GtMethodsCoder >> methodAdded: aValueAdded [
	| coder |
	coder := GtMethodCoder forMethod: aValueAdded newValue.
	methodCoders add: coder.
	self announce: (GtMethodCoderAdded new coder: self; methodCoder: coder)
]

{ #category : #'event handling' }
GtMethodsCoder >> methodChanged: aValueChanged [
	methodCoders
		do: [ :each | 
			(each isForMethod: aValueChanged newValue)
				ifTrue: [ each updateMethod: aValueChanged newValue ] ]
]

{ #category : #elements }
GtMethodsCoder >> methodCoderLook [
	^ nil
]

{ #category : #'event handling' }
GtMethodsCoder >> methodRemoved: aValueRemoved [
	| toRemove |
	toRemove := methodCoders select: [ :each | each isForMethod: aValueRemoved oldValue ].
	toRemove
		do: [ :each | 
			methodCoders remove: each.
			self announce: (GtMethodCoderRemoved new coder: self; methodCoder: each) ]
]

{ #category : #private }
GtMethodsCoder >> newMethodCoderFor: aMethod [
	| coder |
	coder := GtMethodCoder forMethod: aMethod.
	coder methodsCoder: self.
	^ coder
]
