Class {
	#name : #GtSourceCoderAddOns,
	#superclass : #GtCoderAddOns,
	#instVars : [
		'stylers'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #stylers }
GtSourceCoderAddOns >> addStyler: aStyler [
	(stylers anySatisfy: [ :each | each class = aStyler class ])
		ifTrue: [ ^ self ].
	stylers add: aStyler.
	modified add: #stylers
]

{ #category : #ui }
GtSourceCoderAddOns >> gtViewStylersFor: aView [
	<gtView>
	^ aView list
		title: 'Stylers' translated;
		priority: 30;
		items: [ self stylers ]
]

{ #category : #'initialize-release' }
GtSourceCoderAddOns >> initialize [
	super initialize.
	stylers := OrderedCollection new
]

{ #category : #stylers }
GtSourceCoderAddOns >> removeStylerOfType: aClass [
	| styler |
	styler := stylers detect: [ :each | each isKindOf: aClass ] ifNone: [  ].
	styler isNil
		ifTrue: [ ^ self ].
	stylers remove: styler.
	modified add: #stylers
]

{ #category : #accessing }
GtSourceCoderAddOns >> stylers [
	^ stylers
]
