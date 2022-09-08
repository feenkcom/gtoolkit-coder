"
I am a {{gtClass:BlElement}}.
I display one filter in a chain of filters.
I am used by {{gtClass:GtFiltersElement}}.
1. # Element Example

This is how I look like: {{gtExample:GtFiltersElementExamples>>#filterTagElement|codeExpanded=false|previewExpanded=true|previewShow=#gtLiveFor:|previewHeight=70}}
1. # Coder Example

The following example shows a coder with default filters element that you can change: {{gtExample:GtFiltersElementExamples>>#coderWithFiltersElement|codeExpanded=false|previewExpanded=true}}


"
Class {
	#name : #GtFilterTagElement,
	#superclass : #BrHorizontalPane,
	#instVars : [
		'descriptor',
		'valueString',
		'filterElement'
	],
	#category : #'GToolkit-Coder-UI-Filters'
}

{ #category : #actions }
GtFilterTagElement >> activateEditor [
	self
		childNamed: #editableLabel
		ifFound: [ :label | 
			label
				requestFocus;
				switchToEditor ]
		ifNone: [ (self childNamed: #dropDown) requestFocus ]
]

{ #category : #private }
GtFilterTagElement >> applyDescriptor: aDescriptor [
	self descriptor: aDescriptor.
	self activateEditor.
	
	aDescriptor valueIsRequired
		ifFalse: [ filterElement applyFilters ]
]

{ #category : #elements }
GtFilterTagElement >> buildTagElements [
	self removeChildren.
	
	BlFrameTelemetry
		time: [ 'Create and add dropdown' ]
		during: [ self addChild: self createDropDown as: #dropDown ].

	descriptor valueIsRequired
		ifTrue: [
			BlFrameTelemetry
				time: [ 'Create and add editable label' ]
				during: [ self addChild: self createEditableLabel as: #editableLabel ] ]
]

{ #category : #elements }
GtFilterTagElement >> createDropDown [
	| button dropDownLook |
	button := self createDropDownButton.
	dropDownLook := BrGlamorousWithDropdownAptitude
		handle: [ self createDropDownButton ]
		content: [
			BrSimpleList new
				fitContent;
				stencil: [ :each | 
					BrHorizontalPane new
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
								button label: each name.
								anEvent currentTarget fireEvent: BrDropdownHideWish new.
								self applyDescriptor: each ];
						addChild: (BrLabel new
							aptitude: BrGlamorousLabelAptitude new glamorousRegularFont glamorousCodeSmallSize;
							text: each name;
							yourself);
						yourself ];
				items: filterElement descriptors;
				yourself ].
	button addAptitude: dropDownLook.
	button addAptitude: (BrStyleCommonAptitude new
			default: [ :s | s background: Color transparent ];
			hovered: [ :s | s background: self theme status neutralBackgroundColor darker ]).
	
	button
		when: BlKeyUpEvent
		do: [ :anEvent | 
			anEvent key = BlKeyboardKey backspace ifTrue: [
			self removeFromParent.
			filterElement applyFilters ] ].

	^ button
]

{ #category : #elements }
GtFilterTagElement >> createDropDownButton [
	| button |
	button := BrButton new.
	button aptitude: BrTextLabelAptitude new glamorousRegularFont glamorousCodeSmallSize + BrGlamorousButtonIconAptitude + BrGlamorousButtonLayoutAptitude.
	button vExact: 20.
	button padding: (BlInsets left: 4 right: 2).
	button label: self descriptor name.
	button icon: BrGlamorousVectorIcons downwards.
	button beSmallSize.
	^ button
]

{ #category : #elements }
GtFilterTagElement >> createEditableLabel [
	| label |

	label := BrEditableLabel new.
	label aptitude: BrGlamorousEditableLabelAptitude new glamorousRegularFont glamorousRegularSmallSize.
	label text: (valueString ifNil: [ '' ]).
	label padding: (BlInsets top: 2 left: 4 bottom: 2 right: 4).
	label
		when: BrEditorAcceptWish
		do: [ :aWish | 
			valueString := aWish text asString trim.
			(label parent == self and: [ valueString isEmpty ])
				ifTrue: [ self removeFromParent ].
			filterElement applyFilters ].
	label
		when: BrEditorCancelWish
		do: [ :aWish | 
			(label parent == self and: [ self isValid not ])
				ifTrue: [ self removeFromParent ].
			filterElement applyFilters ].
	label
		whenKey: BlKeyCombination backspace
		labelDo: [ :aShortcutEvent :aShortcut | 
			self removeFromParent.
			filterElement applyFilters ].

	descriptor completion
		ifNotNil:
			[ :strategy | (GtCompletionController on: label strategy: strategy) install ].

	^ label
]

{ #category : #accessing }
GtFilterTagElement >> descriptor [
	^ descriptor
]

{ #category : #accessing }
GtFilterTagElement >> descriptor: aFilterDescriptor [
	descriptor := aFilterDescriptor.
	valueString := ''.
	self buildTagElements
]

{ #category : #'initialize-release' }
GtFilterTagElement >> emptyDefaultValueLabel [
	^ descriptor emptyDefaultValue
]

{ #category : #accessing }
GtFilterTagElement >> filter: aGtMethodsFilter [
	filterElement := aGtMethodsFilter
]

{ #category : #'initialize-release' }
GtFilterTagElement >> initialize [
	super initialize.
	
	self fitContent.
	self margin: (BlInsets all: 3).
	self addAptitude:
		(BrStyleCommonAptitude new
			default: [ :aStyle | 
				aStyle geometry: (BlRoundedRectangleGeometry cornerRadius: 4).
				aStyle background: self theme status neutralBackgroundColor.
				aStyle border: BlBorder empty ];
			hovered: [ :aStyle | 
				aStyle background:
					self theme status neutralBackgroundColor darker ])
]

{ #category : #testing }
GtFilterTagElement >> isDefaultAllFilter [
	^ self descriptor showAsDefaultWhenEmpty
		and: [ valueString isEmpty
				and: [ self
						childNamed: #editableLabel
						ifFound: [ :aLabel | aLabel text asString = self emptyDefaultValueLabel ]
						ifNone: [ true ] ] ]
]

{ #category : #testing }
GtFilterTagElement >> isValid [
	^ descriptor valueIsRequired not or: [ self valueString notEmpty ]
]

{ #category : #'initialize-release' }
GtFilterTagElement >> makeDefaultFilter [
	valueString := ''.
	self setLabelText: self emptyDefaultValueLabel
]

{ #category : #private }
GtFilterTagElement >> setLabelText: aString [
	self
		childNamed: #editableLabel
		ifFound: [ :label | 
			label text deleteAll.
			aString notEmpty
				ifTrue: [ label text
						append: aString asRopedText glamorousRegularFont glamorousRegularSmallSize ] ]
]

{ #category : #accessing }
GtFilterTagElement >> valueString [
	^ valueString
]

{ #category : #accessing }
GtFilterTagElement >> valueString: aString [
	valueString := aString.
	self setLabelText: aString
]
