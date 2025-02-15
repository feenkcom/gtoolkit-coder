"
I am a {{gtClass:BlElement}}.
I build a filter in {{gtClass:GtCoderElement}}, see {{gtMethod:GtPharoMethodsCoderElement>>#buildFilter|label=#selector}}.
"
Class {
	#name : #GtFiltersElement,
	#superclass : #BrHorizontalFlow,
	#instVars : [
		'descriptors'
	],
	#category : #'GToolkit-Coder-UI-Filters'
}

{ #category : #accessing }
GtFiltersElement >> addAllDefaults [
	| filterElement defaultDescriptors |
	defaultDescriptors := self descriptors
				select: [:each | each showAsDefaultWhenEmpty].
	defaultDescriptors do: 
			[:defaultDescriptor |
			filterElement := self createFilterTagFor: defaultDescriptor.
			filterElement makeDefaultFilter.
			self addChild: filterElement at: self nextTagPosition]
]

{ #category : #accessing }
GtFiltersElement >> addFilterButtonFor: descriptor label: label icon: icon [
	^ BrButton new
		aptitude: self defaultAptitude;
		icon: icon;
		label: label;
		margin: (BlInsets all: 2);
		beSmallSize;
		hExact: 20;
		constraintsDo: [ :c | c flow vertical alignCenter ];
		action: [ :aButton | 
			(self filtersWithDescriptor: descriptor)
				ifEmpty: [ self addFilterForDescriptor: descriptor andValue: '' ]
				ifNotEmpty: [ :coll | coll do: [ :e | self removeChild: e ] ].
			self applyFilters ]
]

{ #category : #accessing }
GtFiltersElement >> addFilterForDescriptor: aFilterDescriptor andValue: aString [
	| element |
	element := self createFilterTagFor: aFilterDescriptor.
	aFilterDescriptor valueIsRequired ifTrue: [element valueString: aString].
	self addChild: element at: self nextTagPosition
]

{ #category : #accessing }
GtFiltersElement >> additionalDefaultButtons [
	| sortedPragmas |
	sortedPragmas := (Pragma allNamed: #gtFilterElement: in: self class)
			sort: [ :aPragma | aPragma arguments first ] ascending
					, [ :aPragma | aPragma methodSelector ] ascending.
	^ (sortedPragmas collect: [ :e | self perform: e methodSelector ])
		reject: [ :e | e isNil ]
]

{ #category : #private }
GtFiltersElement >> applyFilters [
	self applyFiltersDueTo: #unknown
]

{ #category : #private }
GtFiltersElement >> applyFiltersDueTo: aReason [
	self fireEvent: (GtFiltersChangedEvent new filterElement: self; reason: aReason)
]

{ #category : #accessing }
GtFiltersElement >> areAllDefaults [
	^self childrenCount > self defaultButtonCount and: 
			[(1 to: self childrenCount - self defaultButtonCount)
				allSatisfy: [:index | (self childAt: index) isDefaultAllFilter]]
]

{ #category : #'api - filters' }
GtFiltersElement >> asIntersectionFilter [
	| compositeFilter |
	
	compositeFilter := nil.
	
	self
		filtersDo: [ :descriptor :value | 
			compositeFilter
				ifNil: [ compositeFilter := descriptor newFilterWithValue: value ]
				ifNotNil: [ compositeFilter := compositeFilter & (descriptor newFilterWithValue: value) ] ].
	^ compositeFilter
]

{ #category : #'api - filters' }
GtFiltersElement >> buildFilters: aBlock [
	self clearFilters.
	aBlock value
]

{ #category : #accessing }
GtFiltersElement >> clearFilters [
	"Remove all filters"
	[self childrenCount > self defaultButtonCount]
		whileTrue: [self removeChildAt: 1]
]

{ #category : #'private - instance creation' }
GtFiltersElement >> createFilterTagFor: aFilterDescription [
	^ GtFilterTagElement new
		descriptor: aFilterDescription;
		margin: (BlInsets all: 2);
		filter: self
]

{ #category : #private }
GtFiltersElement >> createNewTag [
	| tag |
	self descriptors ifNotEmpty: 
			[:items |
			"self areAllDefaults ifTrue: [ self clearFilters ]."
			tag := self createFilterTagFor: items first.
			self addChild: tag at: self nextTagPosition.
			tag activateEditor]
]

{ #category : #'api - filters' }
GtFiltersElement >> currentFilters [
	^ Array streamContents: [ :aStream | self filtersDo: [ :eachFilter :eachValue | aStream nextPut: (eachFilter -> eachValue) ] ]
]

{ #category : #'private - instance creation' }
GtFiltersElement >> defaultAptitude [
	^ BrGlamorousButtonRectangularAptitude new + BrGlamorousButtonIconAptitude new
		+ BrGlamorousButtonWithLabelTooltipAptitude new
		+ (BrStyleCommonAptitude new
				default: [ :aStyle | 
					aStyle
						border: BlBorder empty;
						background: self theme status neutralBackgroundColor ];
				hovered: [ :aStyle | aStyle background: self theme status neutralBackgroundColor darker ];
				pressed: [ :aStyle | aStyle background: self theme status neutralBackgroundColor darker darker ];
				focused: [ :aStyle | aStyle border: (BlBorder paint: self theme editor focusedBorderColor width: 1) ])
]

{ #category : #accessing }
GtFiltersElement >> defaultButtonCount [
	| addButton |
	addButton := self childWithId: GtFiltersAddButtonId.
	^ self childrenCount - (self childIndexOf: addButton) + 1
]

{ #category : #accessing }
GtFiltersElement >> descriptors [
	^ (descriptors isBlock ifTrue: [ descriptors value ] ifFalse: [ descriptors ])
		ifNil: [ #() ]
]

{ #category : #accessing }
GtFiltersElement >> descriptors: aCollection [
	descriptors := aCollection.

	BlFrameTelemetry
		time: [ 'Add default filter tag' ]
		during: [ self addAllDefaults ].

	self updateAdditionalFilters
]

{ #category : #'api - filters' }
GtFiltersElement >> filtersDo: aBlock [
	"Iterate over all valid filters"
	1 to: self childrenCount - self defaultButtonCount
		do: 
			[:i |
			| filterTagElement |
			filterTagElement := self childAt: i.
			filterTagElement isValid
				ifTrue: 
					[aBlock value: filterTagElement descriptor
						value: filterTagElement valueString]]
]

{ #category : #accessing }
GtFiltersElement >> filtersWithDescriptor: aDescriptor [
	| result |
	result := OrderedCollection new.
	1
		to: self childrenCount - self defaultButtonCount
		do: [ :i | 
			| filterTagElement |
			filterTagElement := self childAt: i.
			filterTagElement descriptor = aDescriptor
				ifTrue: [ result add: filterTagElement ] ].
	^ result
]

{ #category : #accessing }
GtFiltersElement >> gtTestFilter [
	<gtFilterElement: 10>
	| descriptor |
	descriptor := self descriptors
			detect: [ :e | e name = 'Instance methods' ]
			ifNone: [ ^ nil ].
	^ self
		addFilterButtonFor: descriptor
		label: 'Add instance methods filter'
		icon: BrGlamorousVectorIcons emphasizedInspect
]

{ #category : #'gt - extensions' }
GtFiltersElement >> gtViewDefaultDescriptorsFor: aView [ 
	<gtView>
	
	^ aView columnedList 
		title: 'Descriptors';
		items: [ self descriptors ];
		column: 'Name' text: [ :aDescriptor | aDescriptor name ];
		column: 'Order' text: [ :aDescriptor | aDescriptor order ];
		column: 'Is Default' text: [ :aDescriptor | aDescriptor isDefault ];
		column: 'Is Required' text: [ :aDescriptor | aDescriptor valueIsRequired ];
		column: 'Empty Value' text: [ :aDescriptor | aDescriptor emptyDefaultValue ];
		column: 'Show Empty Default' text: [ :aDescriptor | aDescriptor showAsDefaultWhenEmpty ]
]

{ #category : #initialization }
GtFiltersElement >> initialize [
	super initialize.
	self hMatchParent.
	self vFitContent.
	self addChild: self newAddTagButton.
	self updateAdditionalFilters
]

{ #category : #'private - instance creation' }
GtFiltersElement >> newAddTagButton [
	^ BrButton new
		id: GtFiltersAddButtonId;
		aptitude: self defaultAptitude;
		icon: BrGlamorousVectorIcons add;
		label: 'Add Filter';
		margin: (BlInsets all: 2);
		beSmallSize;
		hExact: 20;
		constraintsDo: [ :c | c flow vertical alignCenter ];
		action: [ :aButton | self createNewTag ];
		addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination enter;
				action: [ :anEvent | self createNewTag ])
]

{ #category : #accessing }
GtFiltersElement >> nextTagPosition [
	^self childrenCount - self defaultButtonCount + 1
]

{ #category : #accessing }
GtFiltersElement >> updateAdditionalFilters [
	[ self defaultButtonCount > 1 ]
		whileTrue: [ self removeChildAt: self childrenCount - 1 ].

	self additionalDefaultButtons do: [ :e | self addChild: e ]
]
