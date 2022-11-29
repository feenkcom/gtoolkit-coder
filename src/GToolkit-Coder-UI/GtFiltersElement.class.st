"
I am a {{gtClass:BlElement}}.
I build a filter in {{gtClass:GtCoderElement}}, see {{gtMethod:GtPharoMethodsCoderElement>>#buildFilter|label=#selector}}.
1. # Element Example

The following example shows how I look like: {{gtExample:GtFiltersElementExamples>>#filtersElement|codeExpanded=false|previewExpanded=true|previewShow=#gtLiveFor:|previewHeight=70}}
1. # Coder Example

The following example shows a coder with default filters element that you can change: {{gtExample:GtFiltersElementExamples>>#coderWithFiltersElement|codeExpanded=false|previewExpanded=true}}


"
Class {
	#name : #GtFiltersElement,
	#superclass : #BrHorizontalFlow,
	#instVars : [
		'descriptors'
	],
	#category : #'GToolkit-Coder-UI-Filters'
}

{ #category : #private }
GtFiltersElement >> addAllDefaults [
	| filterElement defaultDescriptors |
	
	defaultDescriptors := self descriptors select: [ :each | each showAsDefaultWhenEmpty ].
	defaultDescriptors
		do: [ :defaultDescriptor | 
			filterElement := self createFilterTagFor: defaultDescriptor.
			filterElement makeDefaultFilter.

			self addChild: filterElement at: self childrenCount ]
]

{ #category : #accessing }
GtFiltersElement >> addFilterForDescriptor: aFilterDescriptor andValue: aString [
	| element |
	element := self createFilterTagFor: aFilterDescriptor.
	aFilterDescriptor valueIsRequired
		ifTrue: [ element valueString: aString ].
	self addChild: element at: self childrenCount
]

{ #category : #private }
GtFiltersElement >> applyFilters [
	self applyFiltersDueTo: #unknown
]

{ #category : #private }
GtFiltersElement >> applyFiltersDueTo: aReason [
	self fireEvent: (GtFiltersChangedEvent new filterElement: self; reason: aReason)
]

{ #category : #private }
GtFiltersElement >> areAllDefaults [
	^ self childrenCount > 1
		and: [ (1 to: self childrenCount - 1)
				allSatisfy: [ :index | (self childAt: index) isDefaultAllFilter ] ]
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

{ #category : #'api - filters' }
GtFiltersElement >> clearFilters [
	"Remove all filters"

	[ self childrenCount > 1 ] whileTrue: [ self removeChildAt: 1 ]
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
	self descriptors
		ifNotEmpty: [ :items | 
			"self areAllDefaults ifTrue: [ self clearFilters ]."
			tag := self createFilterTagFor: items first.
			self addChild: tag at: self childrenCount.
			tag activateEditor ]
]

{ #category : #'api - filters' }
GtFiltersElement >> currentFilters [
	^ Array streamContents: [ :aStream | self filtersDo: [ :eachFilter :eachValue | aStream nextPut: (eachFilter -> eachValue) ] ]
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
		during: [ self addAllDefaults ]
]

{ #category : #'api - filters' }
GtFiltersElement >> filtersDo: aBlock [
	"Iterate over all valid filters"

	1 to: self childrenCount - 1 do: [ :i | 
		| filterTagElement |
		filterTagElement := self childAt: i.
		filterTagElement isValid
			ifTrue: [ aBlock
					value: filterTagElement descriptor
					value: filterTagElement valueString ] ]
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
	self addChild: self newAddTagButton
]

{ #category : #'private - instance creation' }
GtFiltersElement >> newAddTagButton [
	^ BrButton new
		id: GtFiltersAddButtonId;
		aptitude:
			BrGlamorousButtonRectangularAptitude new
				+ BrGlamorousButtonIconAptitude new
				+ BrGlamorousButtonWithLabelTooltipAptitude new
				+ (BrStyleCommonAptitude new
						default: [ :aStyle | 
							aStyle
								border: BlBorder empty;
								background: self theme status neutralBackgroundColor ];
						hovered: [ :aStyle | 
							aStyle background: self theme status neutralBackgroundColor darker ];
						pressed: [ :aStyle | 
							aStyle background: self theme status neutralBackgroundColor darker darker ];
						focused: [ :aStyle | 
							aStyle border: (BlBorder paint: self theme editor focusedBorderColor width: 1) ]);
		icon: BrGlamorousVectorIcons add;
		label: 'Add Filter';
		margin: (BlInsets all: 2);
		beSmallSize;
		hExact: 20;
		constraintsDo: [ :c | c flow vertical alignCenter ];
		action: [ :aButton | self createNewTag ];
		addShortcut:
			(BlShortcutWithAction new
				combination: BlKeyCombination enter;
				action: [ :anEvent | self createNewTag ])
]
