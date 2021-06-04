"
I am a {{gtClass:BlElement}}.
I build a filter in {{gtClass:GtCoderElement}}, see {{gtMethod:GtMethodsCoderElement>>#buildFilter|label=#selector}}.
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

{ #category : #accessing }
GtFiltersElement >> addEmptyDefault [
	| filterElement defaultDescriptor |
	self childrenCount = 1
		ifFalse: [ ^ self ].
	defaultDescriptor := self descriptors
		detect: [ :each | each showAsDefaultWhenEmpty ]
		ifNone: [ ^ self ].
	filterElement := GtFilterTagElement new.
	filterElement filter: self.
	filterElement descriptor: defaultDescriptor.
	filterElement makeDefaultFilter.
	self addChild: filterElement at: self childrenCount
]

{ #category : #accessing }
GtFiltersElement >> addFilterForDescriptor: aFilterDescriptor andValue: aString [
	| element |
	element := GtFilterTagElement new.
	element filter: self.
	element descriptor: aFilterDescriptor.
	aFilterDescriptor valueIsRequired
		ifTrue: [ element valueString: aString ].
	self addChild: element at: self childrenCount
]

{ #category : #'api - actions' }
GtFiltersElement >> applyFilters [
	self fireEvent: (GtFiltersChangedEvent new filterElement: self).
	self addEmptyDefault
]

{ #category : #accessing }
GtFiltersElement >> buildFilters: aBlock [
	self clearFilters.
	aBlock value.
	self addEmptyDefault
]

{ #category : #accessing }
GtFiltersElement >> clearFilters [
	[ self childrenCount > 1 ] whileTrue: [ self removeChildAt: 1 ]
]

{ #category : #'private - actions' }
GtFiltersElement >> createNewTag [
	| tag |
	self descriptors isEmptyOrNil ifTrue: [ ^ self ].
	(self childrenCount > 1
		and: [ (self childAt: self childrenCount - 1) isDefaultAllFilter ])
		ifTrue: [ self removeChildAt: self childrenCount - 1 ].
	tag := GtFilterTagElement new.
	tag filter: self.
	tag descriptor: self descriptors first.
	self addChild: tag at: self childrenCount.
	tag activateEditor
]

{ #category : #accessing }
GtFiltersElement >> descriptors [
	^ descriptors
]

{ #category : #accessing }
GtFiltersElement >> descriptors: aCollection [
	descriptors := aCollection.
	self addEmptyDefault
]

{ #category : #accessing }
GtFiltersElement >> filtersDo: aBlock [
	1 to: self childrenCount - 1 do: [ :i | 
		| filterTagElement |
		filterTagElement := self childAt: i.
		filterTagElement isValid
			ifTrue: [ aBlock
					value: filterTagElement descriptor
					value: filterTagElement valueString ] ]
]

{ #category : #initialization }
GtFiltersElement >> initialize [
	super initialize.
	self hMatchParent.
	self vFitContent.
	self addChild: self newAddTagButton as: #newButton
]

{ #category : #'private - instance creation' }
GtFiltersElement >> newAddTagButton [
	^ BrButton new
		aptitude:
			BrGlamorousButtonRectangularAptitude new
				+ BrGlamorousButtonIconAptitude new
				+ BrGlamorousButtonWithLabelTooltipAptitude new
				+
					(BrInteractiveCommonAptitude new
						default: [ :aWidget | 
							aWidget
								border: BlBorder empty;
								background: self theme status neutralBackgroundColor ];
						hovered: [ :aWidget | 
							aWidget background:
								self theme status neutralBackgroundColor darker ];
						pressed: [ :aWidget | 
							aWidget
								background:
									self theme status neutralBackgroundColor darker darker ];
						focused: [ :aWidget | 
							aWidget
								border: (BlBorder paint: self theme editor focusedBorderColor width: 1) ]);
		icon: BrGlamorousVectorIcons add;
		label: 'Add Filter';
		margin: (BlInsets all: 2);
		beSmallSize;
		hExact: 20;
		constraintsDo: [ :c | c flow vertical alignCenter ];
		action: [ :aButton | self createNewTag ];
		addShortcut:
			(BlShortcutWithAction new
				combination: BlKeyCombination return;
				action: [ :anEvent | self createNewTag ])
]
