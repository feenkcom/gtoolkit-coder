Class {
	#name : #GtTextualCoderAddOns,
	#superclass : #GtCoderAddOns,
	#instVars : [
		'stylers'
	],
	#category : #'GToolkit-Coder-Coders - Addons'
}

{ #category : #accessing }
GtTextualCoderAddOns >> addAddOns: aGtCoderAddOns [
	super addAddOns: aGtCoderAddOns.

	self addStylers: aGtCoderAddOns stylers
]

{ #category : #'api - stylers' }
GtTextualCoderAddOns >> addStyler: aStyler [
	(stylers anySatisfy: [ :each | each class = aStyler class ])
		ifTrue: [ ^ self ].

	stylers add: aStyler
]

{ #category : #'api - stylers' }
GtTextualCoderAddOns >> addStylers: aCollectionOfStylers [
	aCollectionOfStylers do: [ :eachStyler | self addStyler: eachStyler ]
]

{ #category : #changes }
GtTextualCoderAddOns >> differenceWith: aGtCoderAddOns on: aStream [
	super differenceWith: aGtCoderAddOns on: aStream.
	
	self stylers = aGtCoderAddOns stylers
		ifFalse: [ aStream nextPut: GtCoderAddOnsStylersDifference new ]
]

{ #category : #'gt-extensions' }
GtTextualCoderAddOns >> gtViewStylersFor: aView [
	<gtView>
	^ aView list
		title: 'Stylers' translated;
		priority: 30;
		items: [ self stylers ]
]

{ #category : #'initialize-release' }
GtTextualCoderAddOns >> initialize [
	super initialize.
	stylers := OrderedCollection new
]

{ #category : #copying }
GtTextualCoderAddOns >> postCopy [
	super postCopy.
	stylers := stylers copy
]

{ #category : #'api - stylers' }
GtTextualCoderAddOns >> stylers [
	^ stylers
]
