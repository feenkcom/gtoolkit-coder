Class {
	#name : #GtExpandableSourceCoderElement,
	#superclass : #BrExpander,
	#traits : 'TGtWithTextualCoderViewModel',
	#classTraits : 'TGtWithTextualCoderViewModel classTrait',
	#instVars : [
		'collapsedElement',
		'expandedElement',
		'modificationIndicator'
	],
	#category : #'GToolkit-Coder-UI-Coder - Source'
}

{ #category : #private }
GtExpandableSourceCoderElement >> addCodersCoderLook: aSourceCoder to: anElement [	
	aSourceCoder coderLook
		ifNotNil: [ :aCoderLook | anElement addAptitude: aCoderLook ]
]

{ #category : #converting }
GtExpandableSourceCoderElement >> asVerticallyResizableDo: aBlock [
	^ self
]

{ #category : #private }
GtExpandableSourceCoderElement >> assignCollapsedCoder: aTextualCoderViewModel to: aCollapsedElement [
	aCollapsedElement textualCoderViewModel: aTextualCoderViewModel.

	"Initialize look just once"
	aCollapsedElement aptitude
		ifNil: [
			self addCodersCoderLook: aTextualCoderViewModel to: aCollapsedElement.
			"aCollapsedElement addAptitude: GtSourceCoderCollapsedAddOnsAptitude" ]
]

{ #category : #private }
GtExpandableSourceCoderElement >> assignExpandedCoder: aTextualCoderViewModel to: anExpandedElement [
	anExpandedElement textualCoderViewModel: aTextualCoderViewModel.

	"Initialize look just once"
	anExpandedElement aptitude
		ifNil: [
			self addCodersCoderLook: aTextualCoderViewModel to: anExpandedElement ]
]

{ #category : #accessing }
GtExpandableSourceCoderElement >> coderViewModel [
	<return: #GtPharoMethodCoder>	
	^ self textualCoderViewModel
]

{ #category : #accessing }
GtExpandableSourceCoderElement >> coderViewModel: aCoderViewModel [
	self textualCoderViewModel: aCoderViewModel
]

{ #category : #accessing }
GtExpandableSourceCoderElement >> gtAllShortcutsFor: aView [
	<gtView>
	self shortcuts ifEmpty: [ ^ aView empty ].

	^ aView columnedList
		title: 'All shortcuts' translated;
		priority: 10;
		items: [ self shortcuts , textualCoderViewModel addOns wait shortcuts ];
		column: 'Key' text: [ :each | each combination gtDisplayString ];
		column: 'Action' text: [ :each | each action asString ]
]

{ #category : #initialization }
GtExpandableSourceCoderElement >> initialize [
	super initialize.

	self
		vFitContent;
		hMatchParent;
		margin: (BlInsets all: 4);
		aptitude: (GtCoderExpanderAptitude new padding: BlInsets empty);
		beInSingleCompositionLayer.

	self states withExpansion.

	self when: BrExpandedEvent do: [ self onExpanded ].
	self when: BrCollapsedEvent do: [ self onCollapsed ].

	self
		header: [ collapsedElement := self newCollapsedElement ];
		content: [ expandedElement := self newExpandedElement ].

	self
		when: BlClickEvent
		do: [ :anEvent |
			self isCollapsed
				ifTrue: [
					anEvent consumed: true.
					self expand.
					self textualCoderViewModel focused: true ] ].

	modificationIndicator := self newModificationIndicator.
	modificationIndicator visibility: BlVisibility gone.
	self addChild: modificationIndicator
]

{ #category : #private }
GtExpandableSourceCoderElement >> isDirty: anElement [
	^ anElement userData
		at: #coderDirty
		ifAbsent: [ false ]
]

{ #category : #private }
GtExpandableSourceCoderElement >> markDirty: anElement as: aBoolean [
	anElement userData at: #coderDirty put: aBoolean
]

{ #category : #'private - instance creation' }
GtExpandableSourceCoderElement >> newCollapsedElement [
	| aCollapsedElement |
	aCollapsedElement := GtSourceCoderCollapsedContentElement new.

	textualCoderViewModel
		ifNotNil: [ :aCoder | self assignCollapsedCoder: aCoder to: aCollapsedElement ].

	^ aCollapsedElement
]

{ #category : #'private - instance creation' }
GtExpandableSourceCoderElement >> newExpandedElement [
	| anExpandedElement |
	anExpandedElement := GtSourceCoderExpandedContentElement new.

	textualCoderViewModel
		ifNotNil: [ :aCoder | self assignExpandedCoder: aCoder to: anExpandedElement ].

	^ anExpandedElement
]

{ #category : #'private - instance creation' }
GtExpandableSourceCoderElement >> newModificationIndicator [
	^ BlElement new
		constraintsDo: [ :c |
			c ignoreByLayout.
			c ignored horizontal alignLeft.
			c horizontal exact: 5.
			c vertical matchParent.
			c margin: (BlInsets left: 8) ];
		preventMeAndChildrenMouseEvents;
		background: self theme status changesBackgroundColor;
		id: GtTextualCoderModificationIndicatorId;
		withAsyncPromiseDo: [ :anElementPromise |
			anElementPromise
				whenSuccess: [ :anIndicator :isModified |
					anIndicator visibility: (isModified
						ifTrue: [ BlVisibility visible ]
						ifFalse: [ BlVisibility gone ]) ] ]
]

{ #category : #private }
GtExpandableSourceCoderElement >> onCollapsed [
	self beInSingleCompositionLayer.
	
	textualCoderViewModel ifNotNil: [ :aCoderUIModel |
		aCoderUIModel expanded: false.
		(collapsedElement notNil and: [ self isDirty: collapsedElement ])
			ifTrue: [ self assignCollapsedCoder: aCoderUIModel to: collapsedElement ] ]
]

{ #category : #private }
GtExpandableSourceCoderElement >> onExpanded [
	self beInSeparateCompositionLayer.

	textualCoderViewModel ifNotNil: [ :aCoderUIModel |			
		aCoderUIModel expanded: true.
		(expandedElement notNil and: [ self isDirty: expandedElement ])
			ifTrue: [ self assignExpandedCoder: aCoderUIModel to: expandedElement ] ]
]

{ #category : #'api - textual coder view model' }
GtExpandableSourceCoderElement >> onTextualCoderViewModelChanged [
	"Is sent when a new textualCoder view model is assigned to the element.
	Note: #onTextualCoderViewModelChanged is sent before #subscribeToTextualCoderViewModel
	which means that if you perform any operation that triggers an announcement it will be ignored because the receiver
	didn't get a chance to subscribe to any announcement. Override #onPostTextualCoderViewModelChanged if you
	wish to perform an operation that requires an announcement, but keep in mind that this is not the most efficient way"
	
	self updateElement
]

{ #category : #'private - event handling' }
GtExpandableSourceCoderElement >> onViewModelExpansionChanged: anAnnouncement [
	self expanded: anAnnouncement expanded
]

{ #category : #'private - event handling' }
GtExpandableSourceCoderElement >> onViewModelTextChanged: anAnnouncement [
	self updateModificationIndicator
]

{ #category : #'focus requesting' }
GtExpandableSourceCoderElement >> requestFocus [
	self
		childNamed: #editor
		ifFound: [ :anEditorElement | anEditorElement requestFocus ]
		ifNone: [ super requestFocus ]
]

{ #category : #'api - textual coder view model' }
GtExpandableSourceCoderElement >> subscribeToTextualCoderViewModel [
	"Is sent after a new textualCoder view model is assigned to the element.
	It is required to unsubscribe from the view model or domain model by implementing
	#unsubscribeFromTextualCoderViewModel if elements subscribe to them"

	textualCoderViewModel weak
		when: GtTextualCoderViewModelExpansionChanged
			send: #onViewModelExpansionChanged:
			to: self;
		when: GtTextualCoderViewModelTextChanged
			send: #onViewModelTextChanged:
			to: self
]

{ #category : #'api - textual coder view model' }
GtExpandableSourceCoderElement >> unsubscribeFromTextualCoderViewModel [
	"Is sent before a new textualCoder view model is assigned to the element.
	Elements that subscribe to textualCoder view model in domain model are required to implement this methods."
	
	"textualCoderViewModel coder unsubscribeFromSystem."
	textualCoderViewModel unsubscribe: self
]

{ #category : #'private - update' }
GtExpandableSourceCoderElement >> updateElement [
	textualCoderViewModel expanded
		ifTrue: [ expandedElement
				ifNotNil: [ :anElement | self assignExpandedCoder: textualCoderViewModel to: anElement ].
			collapsedElement
				ifNotNil: [ :anElement | self markDirty: anElement as: true ] ]
		ifFalse: [ collapsedElement
				ifNotNil:
					[ :anElement | self assignCollapsedCoder: textualCoderViewModel to: anElement ].
			expandedElement
				ifNotNil: [ :anElement | self markDirty: anElement as: true ] ].

	textualCoderViewModel focused
		ifFalse: [ self loseFocus ].

	self expanded: textualCoderViewModel expanded.
	self updateModificationIndicator
]

{ #category : #'private - update' }
GtExpandableSourceCoderElement >> updateModificationIndicator [
	modificationIndicator asyncPromise promise: textualCoderViewModel isTextModified
]
