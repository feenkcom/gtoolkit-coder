Class {
	#name : #GtSourceCoderAddOns,
	#superclass : #GtCoderAddOns,
	#instVars : [
		'stylers'
	],
	#category : #'GToolkit-Coder-Coders - Addons'
}

{ #category : #accessing }
GtSourceCoderAddOns >> addAddOns: aGtCoderAddOns [
	super addAddOns: aGtCoderAddOns.

	self addStylers: aGtCoderAddOns stylers
]

{ #category : #'api - stylers' }
GtSourceCoderAddOns >> addStyler: aStyler [
	(stylers anySatisfy: [ :each | each class = aStyler class ])
		ifTrue: [ ^ self ].

	stylers add: aStyler
]

{ #category : #'api - stylers' }
GtSourceCoderAddOns >> addStylers: aCollectionOfStylers [
	aCollectionOfStylers do: [ :eachStyler | self addStyler: eachStyler ]
]

{ #category : #changes }
GtSourceCoderAddOns >> differenceWith: aGtCoderAddOns on: aStream [
	super differenceWith: aGtCoderAddOns on: aStream.
	
	self stylers = aGtCoderAddOns stylers
		ifFalse: [ aStream nextPut: GtCoderAddOnsStylersDifference new ]
]

{ #category : #'gt-extensions' }
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

{ #category : #copying }
GtSourceCoderAddOns >> postCopy [
	super postCopy.
	stylers := stylers copy
]

{ #category : #'api - stylers' }
GtSourceCoderAddOns >> stylers [
	^ stylers
]
