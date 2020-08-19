Class {
	#name : #GtMethodsFilterTagElement,
	#superclass : #BrHorizontalPane,
	#instVars : [
		'descriptor',
		'filter',
		'valueString'
	],
	#category : #'GToolkit-Coder-Filters - UI'
}

{ #category : #actions }
GtMethodsFilterTagElement >> activateEditor [
	self
		childNamed: #editableLabel
		ifFound: [ :label | 
			label
				requestFocus;
				switchToEditor ]
		ifNone: [ (self childNamed: #dropDown) requestFocus ]
]

{ #category : #'initialize-release' }
GtMethodsFilterTagElement >> allLabelText [
	^ 'All'
]

{ #category : #private }
GtMethodsFilterTagElement >> applyDescriptor: aDescriptor [
	self descriptor: aDescriptor.
	self activateEditor.
	filter applyFilters
]

{ #category : #elements }
GtMethodsFilterTagElement >> buildTagElements [
	self removeChildren.
	self addChild: self createDropDown as: #dropDown.
	descriptor requiresValue
		ifTrue: [ self addChild: self createEditableLabel as: #editableLabel ]
]

{ #category : #elements }
GtMethodsFilterTagElement >> createDropDown [
	| button dropDownLook |
	button := self createDropDownButton.
	dropDownLook := BrGlamorousWithDropdownLook
		handle: [ self createDropDownButton ]
		content: [ BrSimpleList new
				items: filter descriptors;
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
GtMethodsFilterTagElement >> createDropDownButton [
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
	button beSmall.
	^ button
]

{ #category : #elements }
GtMethodsFilterTagElement >> createEditableLabel [
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
			filter applyFilters ].
	label
		when: BrEditorCancelWish
		do: [ :aWish | 
			(label parent == self and: [ self isValid not ])
				ifTrue: [ self removeFromParent ].
			filter applyFilters ].
	label
		whenKey: BlKeyCombination backspace
		labelDo: [ :aShortcutEvent :aShortcut :aTextEditor | 
			self removeFromParent.
			filter applyFilters ].
	descriptor completion
		ifNotNil:
			[ :strategy | (GtCompletionController on: label strategy: strategy) install ].
	^ label
]

{ #category : #accessing }
GtMethodsFilterTagElement >> descriptor [
	^ descriptor
]

{ #category : #accessing }
GtMethodsFilterTagElement >> descriptor: aFilterDescriptor [
	descriptor := aFilterDescriptor.
	valueString := ''.
	self buildTagElements
]

{ #category : #accessing }
GtMethodsFilterTagElement >> filter: aGtMethodsFilter [
	filter := aGtMethodsFilter
]

{ #category : #accessing }
GtMethodsFilterTagElement >> filterForCoders: aMethodsCoder [
	self isValid
		ifFalse: [ ^ nil ].
	^ self descriptor
		createForCoders: aMethodsCoder
		andValue: self valueString
]

{ #category : #'initialize-release' }
GtMethodsFilterTagElement >> initialize [
	super initialize.
	self fitContent.
	self margin: (BlInsets all: 3).
	self
		look:
			(BrInteractiveCommonLook new
				default: [ :aWidget | 
					aWidget geometry: (BlRoundedRectangleGeometry cornerRadius: 4).
					aWidget background: BrGlamorousColors neutralBackgroundColor.
					aWidget border: BlBorder empty ];
				when: BrInteractionState hovered
					style:
						[ :aWidget | aWidget background: BrGlamorousColors neutralBackgroundColor darker ])
]

{ #category : #testing }
GtMethodsFilterTagElement >> isDefaultAllFilter [
	^ self descriptor name = 'Category'
		and: [ valueString isEmpty
				and: [ (self childNamed: #editableLabel) text asString = self allLabelText ] ]
]

{ #category : #testing }
GtMethodsFilterTagElement >> isValid [
	^ descriptor requiresValue not or: [ self valueString notEmpty ]
]

{ #category : #'initialize-release' }
GtMethodsFilterTagElement >> makeDefaultAllFilter [
	valueString := ''.
	(self childNamed: #editableLabel) text
		deleteAll;
		append:
			self allLabelText asRopedText glamorousRegularFont
				glamorousRegularSmallSize
]

{ #category : #accessing }
GtMethodsFilterTagElement >> valueString [
	^ valueString
]

{ #category : #accessing }
GtMethodsFilterTagElement >> valueString: aString [
	valueString := aString.
	self
		childNamed: #editableLabel
		ifFound: [ :label | 
			label text deleteAll.
			aString notEmpty
				ifTrue: [ label text
						append: aString asRopedText glamorousRegularFont glamorousRegularSmallSize ] ]
]
