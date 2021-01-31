"
I am a ${class:BlElement}$.
I display one filter in a chain of filters.
I am used by ${class:GtFiltersElement}$.
!! Element Example
This is how I look like: ${example:GtFiltersElementExamples>>#filterTagElement|codeExpanded=false|previewExpanded=true|previewShow=#gtLiveFor:|previewHeight=70}$
!! Coder Example
The following example shows a coder with default filters element that you can change: ${example:GtFiltersElementExamples>>#coderWithFiltersElement|codeExpanded=false|previewExpanded=true}$
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
	filterElement applyFilters
]

{ #category : #elements }
GtFilterTagElement >> buildTagElements [
	self removeChildren.
	self addChild: self createDropDown as: #dropDown.
	descriptor valueIsRequired
		ifTrue: [ self addChild: self createEditableLabel as: #editableLabel ]
]

{ #category : #elements }
GtFilterTagElement >> createDropDown [
	| button dropDownLook |
	button := self createDropDownButton.
	dropDownLook := BrGlamorousWithDropdownLook
		handle: [ self createDropDownButton ]
		content: [ BrSimpleList new
				items: filterElement descriptors;
				stencil: [ :each | 
					| element |
					element := BlElement new.
					element
						viewModel:
							(BrInteractiveModel new
								withHover;
								yourself);
						look:
							(BrInteractiveCommonLook new
								default: [ :f | f background: Color transparent ];
								hovered: [ :f | f background: BrGlamorousColors defaultButtonBorderColor ];
								yourself);
						layout: BlLinearLayout horizontal;
						constraintsDo: [ :c | 
							c horizontal matchParent.
							c vertical fitContent ];
						padding: (BlInsets all: 5);
						addEventHandlerOn: BlClickEvent
							do: [ button label: each name.
							dropDownLook hide.
							self applyDescriptor: each ];
						addChild:
							(BrLabel new
								look: BrGlamorousLabelLook new glamorousRegularFont glamorousCodeSmallSize;
								text: each name;
								yourself).
					element ];
				hFitContent;
				vFitContent ].
	button addLook: dropDownLook.
	button
		addLook:
			(BrInteractiveCommonLook new
				default: [ button background: Color transparent ];
				hovered: [ button background: BrGlamorousColors neutralBackgroundColor darker ]).
	^ button
]

{ #category : #elements }
GtFilterTagElement >> createDropDownButton [
	| button |
	button := BrButton new.
	button
		look:
			BrTextLabelLook new glamorousRegularFont glamorousCodeSmallSize
				+ BrGlamorousButtonIconLook + BrGlamorousButtonLayoutLook.
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
	label
		look:
			BrGlamorousEditableLabelLook new glamorousRegularFont
				glamorousRegularSmallSize.
	label text: (valueString ifNil: [ '' ]).
	label
		padding:
			(BlInsets
				top: 2
				left: 4
				bottom: 2
				right: 4).
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
	self addLook:
		(BrStyleCommonLook new
			default: [ :aStyle | 
				aStyle geometry: (BlRoundedRectangleGeometry cornerRadius: 4).
				aStyle background: BrGlamorousColors neutralBackgroundColor.
				aStyle border: BlBorder empty ];
			hovered: [ :aStyle | aStyle background: BrGlamorousColors neutralBackgroundColor darker ])
]

{ #category : #testing }
GtFilterTagElement >> isDefaultAllFilter [
	^ self descriptor showAsDefaultWhenEmpty
		and: [ valueString isEmpty
				and:
					[ (self childNamed: #editableLabel) text asString = self emptyDefaultValueLabel ] ]
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
