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
GtFilteredMethodsCoder >> forMethods: compiledMethods [
	super forMethods: compiledMethods.
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

{ #category : #elements }
GtFilteredMethodsCoder >> look [
	^ GtImplementorsFilterMethodsCoderLook new methodsCoder: self
]

{ #category : #elements }
GtFilteredMethodsCoder >> methodCoderLook [
	^ GtMethodCoderCategoryLook new
		methodsCoder: self;
		yourself
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
	newCoders := methodCoders select: [ :each | each isModified ].
	methods
		do: [ :each | 
			(newCoders anySatisfy: [ :coder | coder isForMethod: each ])
				ifFalse: [ newCoders
						add: (methodCoders detect: [ :coder | coder isForMethod: each ] ifNone: [ self newMethodCoderFor: each ]) ] ].
	methodCoders := newCoders.
	methodCoders sort: [ :a :b | self shouldSort: a before: b ].
	highlighter := methods highlighter.
	methodCoders do: [ :each | each highlighter: highlighter ].
	self announce: (GtCoderMethodsListChanged new coder: self)
]

{ #category : #private }
GtFilteredMethodsCoder >> updateMethods [
	methods filter: self combinedFilter
]
