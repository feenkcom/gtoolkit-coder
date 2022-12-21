"
I am a {{gtClass:BlElement}}.
I display one filter in a chain of filters.
I am used by {{gtClass:GtFiltersElement}}.

"
Class {
	#name : #GtFilterTagElement,
	#superclass : #BrHorizontalPane,
	#instVars : [
		'filterDescriptor',
		'availableFilterDescriptors',
		'valueString',
		'filterElement',
		'filterPickerHandle',
		'filterLabel'
	],
	#category : #'GToolkit-Coder-UI-Filters'
}

{ #category : #'private - accessing' }
GtFilterTagElement >> activateEditor [
	self
		childWithId: GtFilterTagEditorId
		ifFound: [ :anEditor | anEditor requestFocus ]
		ifNone: [ filterLabel requestFocus ]
]

{ #category : #'private - accessing' }
GtFilterTagElement >> applyDescriptor: aDescriptor [
	self descriptor: aDescriptor.
	self activateEditor.
	
	aDescriptor valueIsRequired
		ifFalse: [ self applyFiltersDueTo: #applyDescriptor ]
]

{ #category : #'private - instance creation' }
GtFilterTagElement >> applyFiltersDueTo: aReason [
	filterElement
		ifNil: [ ^ self ].

	filterElement applyFiltersDueTo: aReason
]

{ #category : #'api - accessing' }
GtFilterTagElement >> availableFilterDescriptors [
	"Tag element allows users to change the filter to another one.
	Therefore each filter tag element should be able to get a list of all possible descriptors"
	<return: #Collection of: #GtFilterDescriptor>

	^ availableFilterDescriptors
]

{ #category : #'api - accessing' }
GtFilterTagElement >> availableFilterDescriptors: aCollectionOfFilterDescriptors [
	availableFilterDescriptors := aCollectionOfFilterDescriptors
]

{ #category : #'private - instance creation' }
GtFilterTagElement >> createDropdownContent [
	^ BrSimpleList new
		fitContent;
		stencil: [ :eachFilterDescriptor :eachIndex | 
			BrHorizontalPane new
				id: (GtFilterTagPickerItemId indexed: eachIndex);
				hMatchParent;
				vFitContent;
				padding: (BlInsets all: 5);
				aptitude: (BrStyleCommonAptitude new
					default: [ :s | s background: Color transparent ];
					hovered: [ :s | s background: self theme button defaultBorderColor ];
					yourself);
				when: BlClickEvent
					do: [ :anEvent |
						anEvent consumed: true.
						anEvent currentTarget fireEvent: BrDropdownHideWish new.
						self
							requestReplaceFilter: filterDescriptor
							with: eachFilterDescriptor ];
				addChild: (BrLabel new
					aptitude: BrGlamorousLabelAptitude new glamorousRegularFont glamorousCodeSmallSize;
					text: eachFilterDescriptor name;
					yourself);
				yourself ];
		items: self availableFilterDescriptors;
		yourself
]

{ #category : #'private - instance creation' }
GtFilterTagElement >> createEditableLabel [
	| anEditor |

	anEditor := BrEditor new
		beMode: BrTextEditorEditableSingleLineMode new;
		fitContent;
		id: GtFilterTagEditorId;
		aptitude: BrGlamorousRegularEditorAptitude new glamorousRegularFont glamorousCodeSmallSize;
		background: Color white;
		geometry: (BlRoundedRectangleGeometry cornerRadius: 2);
		margin: (BlInsets top: 2 left: 0 bottom: 2 right: 3);
		padding: (BlInsets top: 1 left: 2 bottom: 1 right: 2);
		constraintsDo: [ :c | c minWidth: 16 ];
		text: ''.

	anEditor addShortcut: (BlShortcutWithAction new
		combination: BlKeyCombination enter;
		action: [ :anEvent |
			self
				requestUpdateFilter: filterDescriptor
				value: anEvent currentTarget text asString trimmed ]).

	anEditor when: BlFocusOutEvent do: [ :anEvent |
		anEvent isDueToRemoval
			ifFalse: [
				self
					requestUpdateFilter: filterDescriptor
					value: anEvent currentTarget text asString trimmed ] ].

	^ anEditor
]

{ #category : #'private - instance creation' }
GtFilterTagElement >> createFilterLabel [
	^ BrLabel new
		aptitude: BrGlamorousLabelAptitude new glamorousRegularFont glamorousCodeSmallSize;
		vFitContent;
		beSmallSize
]

{ #category : #'private - instance creation' }
GtFilterTagElement >> createFilterLabelHandle [
	^ self createFilterLabel
		id: GtFilterTagLabelId;
		addAptitude: (BrGlamorousWithDropdownAptitude
			handle: [
				BrHorizontalPane new
					fitContent;
					addChildren: {
						self createFilterLabel text: filterDescriptor name.
						self createFilterPickerHandle
					} ]
			content: [ self createDropdownContent ]) doNotShowOnClick
]

{ #category : #'private - instance creation' }
GtFilterTagElement >> createFilterPickerHandle [
	^ BrButton new
		id: GtFilterTagPickerId;
		aptitude: (BrGlamorousButtonCircularAptitude paddingScale: 0 heightScale: 0.75)
			+ BrGlamorousButtonFlatExteriorAptitude
			+ BrGlamorousButtonIconAptitude;
		icon: BrGlamorousVectorIcons downwards;
		beNormalSize
]

{ #category : #'api - accessing' }
GtFilterTagElement >> descriptor [
	^ filterDescriptor
]

{ #category : #'api - accessing' }
GtFilterTagElement >> descriptor: aFilterDescriptor [
	filterDescriptor := aFilterDescriptor.

	filterLabel text: filterDescriptor name.

	filterDescriptor valueIsRequired
		ifTrue: [
			| aDefaultValue |

			aDefaultValue := aFilterDescriptor emptyDefaultValue
				ifNil: [ '' ].

			self
				childWithId: GtFilterTagEditorId
				ifFound: [ :anEditor | anEditor text: aDefaultValue ]
				ifNone: [ self addChild: (self createEditableLabel text: aDefaultValue) ].

			self
				childWithId: GtFilterTagEditorId
				ifFound: [ :anEditor |
					filterDescriptor completion
						ifNotNil: [ :strategy | (GtCompletionController on: anEditor strategy: strategy) install ]
						ifNil: [ (GtCompletionController on: anEditor strategy: GtCompletionStrategy new) install ] ] ]
		ifFalse: [
			self
				childWithId: GtFilterTagEditorId
				ifFound: [ :anEditor | anEditor removeFromParent ] ]
]

{ #category : #initialization }
GtFilterTagElement >> emptyDefaultValueLabel [
	^ filterDescriptor emptyDefaultValue
]

{ #category : #'api - accessing' }
GtFilterTagElement >> filter: aGtMethodsFilter [
	filterElement := aGtMethodsFilter.
	self availableFilterDescriptors: filterElement descriptors
]

{ #category : #initialization }
GtFilterTagElement >> initialize [
	super initialize.
	
	availableFilterDescriptors := #().
	
	self
		fitContent;
		alignCenterLeft;
		beInSingleCompositionLayer;
		beFocusable.
	
	self addAptitude:
		(BrStyleCommonAptitude new
			default: [ :aStyle | 
				aStyle geometry: (BlRoundedRectangleGeometry cornerRadius: 4).
				aStyle background: self theme status neutralBackgroundColor ];
			hovered: [ :aStyle | 
				aStyle background: self theme status neutralBackgroundColor darker ];
			focused: [ :aStyle |
				aStyle background: self theme editor focusedBorderColor lighter lighter ]).

	filterLabel := self createFilterLabelHandle.
	filterLabel margin: (BlInsets top: 2 right: 0 bottom: 2 left: 4).
	filterPickerHandle := self createFilterPickerHandle.
	filterPickerHandle margin: (BlInsets top: 1 right: 4).

	self addChildren:  {
		filterLabel.
		filterPickerHandle
	}.

	self addAptitude: (BrStyleCommonAptitude new
		// #label;
		default: [ :aStyle | aStyle foreground: Color black ];
		focused: [ :aStyle | aStyle foreground: Color white ]).

	self addAptitude: (BrStyleCommonAptitude new
		// #icon;
		default: [ :aStyle | aStyle background: Color black ];
		focused: [ :aStyle | aStyle background: Color white ]).

	self when: BlClickEvent do: [ :anEvent |
		anEvent consumed: true.
		self hasFocus
			ifTrue: [
				filterLabel dispatchEvent: (BrDropdownShowWish new) ].
		self requestFocus ].

	filterPickerHandle
		when: BlClickEvent
		do: [ :anEvent | filterLabel dispatchEvent: BrDropdownShowWish new ].

	self addShortcut: (BlShortcutWithAction new
		combination: (BlKeyCombination backspace);
		action: [ self requestRemoveFilter: filterDescriptor ])
]

{ #category : #testing }
GtFilterTagElement >> isDefaultAllFilter [
	^ self descriptor showAsDefaultWhenEmpty
		and: [
			self
				childWithId: GtFilterTagEditorId
				ifFound: [ :aLabel | aLabel text asString = self emptyDefaultValueLabel ]
				ifNone: [ true ] ]
]

{ #category : #testing }
GtFilterTagElement >> isValid [	
	^ filterDescriptor isValueValid: self valueString
]

{ #category : #initialization }
GtFilterTagElement >> makeDefaultFilter [
	self setLabelText: self emptyDefaultValueLabel
]

{ #category : #'private - actions' }
GtFilterTagElement >> requestRemoveFilter: aFilterDescriptor [
	"Is sent by filter tag when it requests to remove a filter"
	| aWish |
	
	self dispatchEvent: (aWish := GtFilterTagRemoveWish new
		filterDescriptor: aFilterDescriptor).
	
	self removeFromParent.
	self applyFiltersDueTo: aWish
]

{ #category : #'private - actions' }
GtFilterTagElement >> requestReplaceFilter: aFilterDescriptor with: aNewFilterDescriptor [
	"Is sent by filter tag when it requests to replace itself with a new filter"	
	| aWish |

	aFilterDescriptor = aNewFilterDescriptor
		ifTrue: [ ^ self ].

	self descriptor: aNewFilterDescriptor.
	self activateEditor.

	self dispatchEvent: (aWish := GtFilterTagReplaceWish new
		filterDescriptor: aFilterDescriptor;
		newFilterDescriptor: aNewFilterDescriptor).

	aNewFilterDescriptor valueIsRequired
		ifFalse: [ self applyFiltersDueTo: aWish ]
]

{ #category : #'private - actions' }
GtFilterTagElement >> requestUpdateFilter: aFilterDescriptor value: aString [
	"Is sent by filter tag when it requests to update the filter with a new value"
	| aWish |

	(aFilterDescriptor isValueValid: aString)
		ifFalse: [ ^ self ].

	self dispatchEvent: (aWish := GtFilterTagUpdateWish new
		filterDescriptor: aFilterDescriptor;
		newValue: aString).

	self applyFiltersDueTo: aWish
]

{ #category : #'private - accessing' }
GtFilterTagElement >> setLabelText: aString [
	self
		childWithId: GtFilterTagEditorId
		ifFound: [ :label | label text: aString ]
]

{ #category : #'api - accessing' }
GtFilterTagElement >> valueString [
	^ self
		childWithId: GtFilterTagEditorId
		ifFound: [ :anEditor | anEditor text asString ]
		ifNone: [ '' ]
]

{ #category : #'api - accessing' }
GtFilterTagElement >> valueString: aString [
	self setLabelText: aString
]
