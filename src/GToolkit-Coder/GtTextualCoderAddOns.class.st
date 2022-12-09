Class {
	#name : #GtTextualCoderAddOns,
	#superclass : #GtCoderAddOns,
	#instVars : [
		'stylers',
		'ast'
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

{ #category : #accessing }
GtTextualCoderAddOns >> ast [
	<return: #GtCoderAst>

	^ ast
]

{ #category : #accessing }
GtTextualCoderAddOns >> ast: aGtCoderAst [
	ast := aGtCoderAst
]

{ #category : #changes }
GtTextualCoderAddOns >> differenceWith: aGtCoderAddOns on: aStream [
	super differenceWith: aGtCoderAddOns on: aStream.
	
	self stylers = aGtCoderAddOns stylers
		ifFalse: [ aStream nextPut: GtCoderAddOnsStylersDifference new ]
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
GtTextualCoderAddOns >> removeStylersOfClass: aStylerClass [
	stylers removeAllSuchThat: [ :each | each class = aStylerClass ]
]

{ #category : #'api - stylers' }
GtTextualCoderAddOns >> stylers [
	^ stylers
]
