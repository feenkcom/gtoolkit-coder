Class {
	#name : #GtCodersDataSource,
	#superclass : #BlInfiniteDataSource,
	#instVars : [
		'elementsByCoder',
		'coders'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #ui }
GtCodersDataSource >> buildElementForCoder: aCoder [
	^ aCoder asElement
]

{ #category : #accessing }
GtCodersDataSource >> coders: aCoders [
	coders := aCoders.
	self notifyChanged.
]

{ #category : #initialization }
GtCodersDataSource >> initialize [ 	
	super initialize.
	elementsByCoder := Dictionary new.
]

{ #category : #accessing }
GtCodersDataSource >> itemCount [
	^ coders coders size
]

{ #category : #'instance creation' }
GtCodersDataSource >> onBindHolder: anElementHolder at: aPosition [
	| currentCoder |
	currentCoder := coders coders at: aPosition.
	anElementHolder coderElement: (elementsByCoder 
		at: currentCoder 
		ifAbsentPut: [
			self buildElementForCoder: currentCoder])
]

{ #category : #'instance creation' }
GtCodersDataSource >> onCreateHolder: anInfiniteElement type: anItemType [
	^ GtCoderElementHolder new
]

{ #category : #updating }
GtCodersDataSource >> updateCoders [
	| cachedCodersToRemove |
	cachedCodersToRemove := elementsByCoder keys select: [ :aCoder | 
		(coders coders includes: aCoder) not ].
	cachedCodersToRemove do: [ :aCoder |
		elementsByCoder removeKey: aCoder ifAbsent: [  ] ].
	self notifyChanged.
]
