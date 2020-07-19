Class {
	#name : #GtFilteredMethodsCoder,
	#superclass : #GtMethodsCoder,
	#instVars : [
		'originalFilter',
		'categoryFilterString',
		'implementorsFilterString'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #private }
GtFilteredMethodsCoder >> categoryFilter [
	^ categoryFilterString notNil
		ifTrue: [ GtSearchMethodCategoryFilter forCategory: categoryFilterString ]
]

{ #category : #accessing }
GtFilteredMethodsCoder >> categoryFilterString [
	^ categoryFilterString
]

{ #category : #accessing }
GtFilteredMethodsCoder >> categoryFilterString: aSymbol [
	categoryFilterString := aSymbol.
	self updateMethods.
	self updateCoders
]

{ #category : #elements }
GtFilteredMethodsCoder >> coderLook [
	^ GtSourceCoderHeaderLook + GtMethodCoderCategoryLook
]

{ #category : #private }
GtFilteredMethodsCoder >> combineFilters: anArray [
	| result |
	result := nil.
	anArray
		do: [ :each | 
			each notNil
				ifTrue: [ result := result isNil
						ifTrue: [ each ]
						ifFalse: [ result & each ] ] ].
	^ result
]

{ #category : #private }
GtFilteredMethodsCoder >> combinedFilter [
	^ self combineFilters: self filters
]

{ #category : #private }
GtFilteredMethodsCoder >> filters [
	^ {originalFilter.
	self categoryFilter.
	self implementorsFilter}
]

{ #category : #'initialize-release' }
GtFilteredMethodsCoder >> forItems: compiledMethods [
	super forItems: compiledMethods.
	originalFilter := compiledMethods filter
]

{ #category : #private }
GtFilteredMethodsCoder >> implementorsFilter [
	^ (implementorsFilterString notNil and: [ implementorsFilterString notEmpty ])
		ifTrue: [ GtSearchImplementorPatternFilter pattern: implementorsFilterString ]
]

{ #category : #accessing }
GtFilteredMethodsCoder >> implementorsFilterString [
	^ implementorsFilterString
]

{ #category : #accessing }
GtFilteredMethodsCoder >> implementorsFilterString: aString [
	implementorsFilterString := aString.
	self updateMethods.
	self updateCoders
]

{ #category : #private }
GtFilteredMethodsCoder >> shouldSort: a before: b [
	a selector isNil
		ifTrue: [ ^ b selector notNil or: [ a classOrMetaClass name <= b classOrMetaClass name ] ].
	b selector isNil
		ifTrue: [ ^ false ].
	a classOrMetaClass = b classOrMetaClass
		ifTrue: [ ^ a selector < b selector ].
	^ a classOrMetaClass name < b classOrMetaClass name
]

{ #category : #private }
GtFilteredMethodsCoder >> updateCoders [
	| newCoders highlighter |
	newCoders := coders select: [ :each | each isModified ].
	items
		do: [ :each | 
			(newCoders
				anySatisfy: [ :coder | coder isForMethod: each compiledMethod ])
				ifFalse: [ newCoders add: (self newCoderFor: each) ] ].
	coders := newCoders.
	coders sort: [ :a :b | self shouldSort: a before: b ].
	(items isKindOf: GtSearchMethodGroupResult)
		ifTrue: [ highlighter := items highlighter.
			coders do: [ :each | each highlighter: highlighter ] ].
	self
		announce:
			(GtCodersCodersChanged new
				coders: self;
				yourself)
]

{ #category : #private }
GtFilteredMethodsCoder >> updateMethods [
	(items isKindOf: GtSearchMethodGroupResult)
		ifTrue: [ items updateForFilter: self combinedFilter ]
]
