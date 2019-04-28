Class {
	#name : #GtMethodsCoderDataSource,
	#superclass : #BlInfiniteDataSource,
	#instVars : [
		'methodsCoder',
		'elementsByCoder'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #ui }
GtMethodsCoderDataSource >> buildElementForCoder: aMethodCoder [
	^ aMethodCoder asElement
]

{ #category : #initialization }
GtMethodsCoderDataSource >> initialize [ 	
	super initialize.
	elementsByCoder := Dictionary new.
]

{ #category : #accessing }
GtMethodsCoderDataSource >> itemCount [
	^ methodsCoder coders size
]

{ #category : #accessing }
GtMethodsCoderDataSource >> methodsCoder: aMethodsCoder [
	methodsCoder := aMethodsCoder.
	self notifyChanged.
]

{ #category : #'instance creation' }
GtMethodsCoderDataSource >> onBindHolder: anElementHolder at: aPosition [
	| currentCoder |
	currentCoder := methodsCoder coders at: aPosition.
	anElementHolder methodCoderElement: (elementsByCoder 
		at: currentCoder 
		ifAbsentPut: [
			self buildElementForCoder: currentCoder])
]

{ #category : #'instance creation' }
GtMethodsCoderDataSource >> onCreateHolder: anInfiniteElement type: anItemType [
	^ GtMethodCoderElementHolder new
]

{ #category : #updating }
GtMethodsCoderDataSource >> updateCoders [
	| cachedCodersToRemove |
	cachedCodersToRemove := elementsByCoder keys select: [ :aCoder | 
		(methodsCoder coders includes: aCoder) not ].
	cachedCodersToRemove do: [ :aCoder |
		elementsByCoder removeKey: aCoder ifAbsent: [  ] ].
	self notifyChanged.
]
