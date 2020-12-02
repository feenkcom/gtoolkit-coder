Class {
	#name : #GtFilteredMethodsCoder,
	#superclass : #GtMethodsCoder,
	#instVars : [
		'allCoders',
		'originalFilter',
		'additionalFilters'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #'private - adding / removing' }
GtFilteredMethodsCoder >> addCoder: aCoder [
	self allCoders add: aCoder.
	super addCoder: aCoder
]

{ #category : #'private - adding / removing' }
GtFilteredMethodsCoder >> addFirstCoder: aCoder [
	self allCoders addFirst: aCoder.
	super addFirstCoder: aCoder
]

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

{ #category : #'private - accessing' }
GtFilteredMethodsCoder >> allCoders [
	<return: #Collection of: #GtMethodCoder>
	"Return all non-filtered coders.
	I keep all coders in this variable to keep state of all coders while filtering."
	^ allCoders
]

{ #category : #'private - accessing' }
GtFilteredMethodsCoder >> allCoders: aCollection [
	self unsubscribeFromAllCoders.
	allCoders := aCollection.
	self subscribeToAllCoders.
]

{ #category : #testing }
GtFilteredMethodsCoder >> canFilter [
	^ true
]

{ #category : #completion }
GtFilteredMethodsCoder >> categories [
	| categories |
	categories := GtPrefixTree new.
	items do: [ :each | categories add: each category ].
	^ categories
]

{ #category : #completion }
GtFilteredMethodsCoder >> classNames [
	| classNames |
	classNames := GtPrefixTree new.
	items
		do: [ :each | classNames add: each methodClass instanceSide name ].
	^ classNames
]

{ #category : #'private - accessing' }
GtFilteredMethodsCoder >> coderFor: aCompiledMethod [
	<return: #GtMethodCoder>
	^ self allCoders 
		detect: [ :eachCoder | eachCoder isForMethod: aCompiledMethod ] 
		ifFound: [ :aCoder | aCoder ] 
		ifNone: [ 
			| aNewCoder |
			aNewCoder := self newCoderFor: aCompiledMethod.
			allCoders add: aNewCoder.
			aNewCoder ]
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
	descriptors := SortedCollection sortBlock: [ :a :b | a order < b order ].
	GtSearchMethodsFilter
		withAllSubclassesDo: [ :eachClass | 
			eachClass 
				filterDescriptorsFor: self 
				into: descriptors ].
	^ descriptors
]

{ #category : #filters }
GtFilteredMethodsCoder >> filterNames [
	^ self filterDescriptors collect: [ :each | each name ]
]

{ #category : #'initialize-release' }
GtFilteredMethodsCoder >> forItems: compiledMethods [
	super forItems: compiledMethods.

	"I store all initialized coders in allCoders variable in order to
	keep their state while filtering. The coders variable includes
	a filtered subset of allCoders variable."
	self allCoders: coders copy.

	originalFilter := compiledMethods filter
]

{ #category : #'initialize-release' }
GtFilteredMethodsCoder >> initialize [
	super initialize.
	additionalFilters := OrderedCollection new.
	allCoders := #().
]

{ #category : #testing }
GtFilteredMethodsCoder >> isForClass [
	^ false
]

{ #category : #'private - accessing' }
GtFilteredMethodsCoder >> methodRemoved: aValueRemoved [
	| toRemove |
	toRemove := self allCoders
		select: [ :each | each isForMethod: aValueRemoved oldValue ].
	toRemove
		do: [ :each | 
			self removeCoder: each ]
]

{ #category : #'private - announcement handling' }
GtFilteredMethodsCoder >> onExampleExecuted: aGtCoderExampleExecuted [
	self announce: aGtCoderExampleExecuted
]

{ #category : #'private - announcement handling' }
GtFilteredMethodsCoder >> onSourceCodeChanged: aGtCoderSourceCodeChanged [
	self announce: aGtCoderSourceCodeChanged
]

{ #category : #completion }
GtFilteredMethodsCoder >> packageNames [
	| packageNames |
	packageNames := GtPrefixTree new.
	items
		do:
			[ :each | each package ifNotNil: [ :package | packageNames add: package name ] ].
	^ packageNames
]

{ #category : #completion }
GtFilteredMethodsCoder >> pragmaNames [
	| pragmaNames |
	pragmaNames := GtPrefixTree new.
	items
		do:
			[ :each | each pragmas do: [ :pragma | pragmaNames add: pragma selector ] ].
	^ pragmaNames
]

{ #category : #'private - adding / removing' }
GtFilteredMethodsCoder >> removeCoder: aCoder [
	self allCoders remove: aCoder ifAbsent: [ "ignore" ].
	super removeCoder: aCoder
]

{ #category : #filters }
GtFilteredMethodsCoder >> runFilters [
	self updateMethods.
	self updateCoders
]

{ #category : #completion }
GtFilteredMethodsCoder >> selectorNames [
	| selectorNames |
	selectorNames := GtPrefixTree new.
	items do: [ :each | selectorNames add: each selector ].
	^ selectorNames
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
		ifTrue: [ ^ b selector notNil
				or: [ a classOrMetaClass name <= b classOrMetaClass name ] ].
	b selector isNil
		ifTrue: [ ^ false ].
	a behavior = b behavior
		ifTrue: [ ^ a selector < b selector ].
	^ a behavior name < b behavior name
]

{ #category : #'private - subscriptions' }
GtFilteredMethodsCoder >> subscribeToAllCoders [
	self allCoders do: [ :eachCoder | 
		self subscribeToCoder: eachCoder ]
]

{ #category : #'private - subscriptions' }
GtFilteredMethodsCoder >> subscribeToCoder: eachCoder [
	super subscribeToCoder: eachCoder.
	eachCoder weak
		when: GtCoderExampleExecuted
		send: #onExampleExecuted:
		to: self.
	eachCoder weak
		when: GtCoderSourceCodeChanged
		send: #onSourceCodeChanged:
		to: self
]

{ #category : #'private - subscriptions' }
GtFilteredMethodsCoder >> unsubscribeFromAllCoders [
	self allCoders do: [ :eachCoder |
		self unsubscribeFromCoder: eachCoder ]
]

{ #category : #private }
GtFilteredMethodsCoder >> updateCoders [
	| newCoders highlighter |
	newCoders := coders select: [ :each | each isModified ].
	items
		do: [ :eachMethod | 
			(newCoders
				anySatisfy: [ :coder | coder isForMethod: eachMethod compiledMethod ])
				ifFalse: [ newCoders add: (self coderFor: eachMethod) ] ].
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
