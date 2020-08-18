Class {
	#name : #GtFilteredMethodsCoder,
	#superclass : #GtMethodsCoder,
	#instVars : [
		'originalFilter',
		'additionalFilters'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #filters }
GtFilteredMethodsCoder >> additionalFilters [
	^ additionalFilters
]

{ #category : #filters }
GtFilteredMethodsCoder >> additionalFilters: aCollection [
	additionalFilters = aCollection
		ifTrue: [ ^ self ].
	additionalFilters := OrderedCollection withAll: aCollection.
	self runFilters
]

{ #category : #testing }
GtFilteredMethodsCoder >> canFilter [
	^ true
]

{ #category : #elements }
GtFilteredMethodsCoder >> coderLook [
	^ GtMethodCoderCategoryLook
]

{ #category : #private }
GtFilteredMethodsCoder >> combinedFilter [
	| combinedFilters |
	combinedFilters := additionalFilters
		inject: nil
		into: [ :sum :each | sum ifNil: [ each ] ifNotNil: [ sum | each ] ].
	^ originalFilter
		ifNil: [ combinedFilters ]
		ifNotNil: [ combinedFilters
				ifNil: [ originalFilter ]
				ifNotNil: [ originalFilter & combinedFilters ] ]
]

{ #category : #filters }
GtFilteredMethodsCoder >> filterDescriptors [
	| descriptors |
	descriptors := OrderedCollection new.
	GtSearchMethodsFilter
		withAllSubclassesDo: [ :each | 
			(each filterDescriptorFor: self)
				ifNotNil: [ :descriptor | descriptors add: descriptor ] ].
	^ descriptors asSortedCollection: [ :a :b | a order < b order ]
]

{ #category : #filters }
GtFilteredMethodsCoder >> filterNames [
	^ self filterDescriptors collect: [ :each | each name ]
]

{ #category : #'initialize-release' }
GtFilteredMethodsCoder >> forItems: compiledMethods [
	super forItems: compiledMethods.
	originalFilter := compiledMethods filter
]

{ #category : #'initialize-release' }
GtFilteredMethodsCoder >> initialize [
	super initialize.
	additionalFilters := OrderedCollection new
]

{ #category : #testing }
GtFilteredMethodsCoder >> isForClass [
	^ false
]

{ #category : #filters }
GtFilteredMethodsCoder >> runFilters [
	self updateMethods.
	self updateCoders
]

{ #category : #accessing }
GtFilteredMethodsCoder >> setFilters: aCollection [
	self additionalFilters: aCollection.
	self
		announce:
			(GtCodersFiltersChanged new
				coders: self;
				yourself)
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
