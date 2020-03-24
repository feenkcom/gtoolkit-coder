Class {
	#name : #GtClassCoderSlotsElement,
	#superclass : #BlElement,
	#instVars : [
		'classCoder',
		'slotElements',
		'shouldGiveFocusToAdded'
	],
	#category : #'GToolkit-Coder-UI - Class'
}

{ #category : #'event handling' }
GtClassCoderSlotsElement >> actOnSlotChanged: anAnnouncement [
	"All slots changed (raw announcement)"
	
	slotElements
		at: anAnnouncement oldSlot name
		ifPresent: [ :aSlotElement | self setSlot: anAnnouncement newSlot toButton: aSlotElement ]
]

{ #category : #'event handling' }
GtClassCoderSlotsElement >> actOnSlotsAdded: anAnnouncement [
	| giveFocus |

	giveFocus := shouldGiveFocusToAdded.

	self enqueueTask: (BlTaskAction new action: [
		anAnnouncement slots do: [ :eachSlot |
			| aNewButton |
			aNewButton := self addButtonForSlot: eachSlot.
			giveFocus ifTrue: [ aNewButton requestFocus ] ] ])
]

{ #category : #'event handling' }
GtClassCoderSlotsElement >> actOnSlotsChanged: anAnnouncement [
	"All slots changed (raw announcement)"
]

{ #category : #'event handling' }
GtClassCoderSlotsElement >> actOnSlotsRemoved: anAnnouncement [
	self enqueueTask: (BlTaskAction new action: [		
		anAnnouncement slots do: [ :eachSlot | self removeButtonForSlot: eachSlot ] ])
]

{ #category : #'private - slot buttons' }
GtClassCoderSlotsElement >> addButtonForSlot: aSlot [
	<return: #BlElement>
	| anElement |

	anElement := self buildButtonForSlot: aSlot.
	self setSlot: aSlot toButton: anElement.	
	slotElements at: aSlot name put: anElement.
	self addChild: anElement at: slotElements size.

	^ anElement
]

{ #category : #'private - instance creation' }
GtClassCoderSlotsElement >> addNewSlotEditorBefore: aButton [
	| aNewSlotCreator |

	aNewSlotCreator := nil.
	aNewSlotCreator := GtClassCoderEditableLabel new
		text: '';
		requestFocus;
		switchToEditor;
		margin: self buttonMargin;
		padding: (BlInsets top: 5 left: 10 bottom: 5 right: 10);
		constraintsDo: [ :c | c flow vertical alignCenter ];
		whenAccepted: [ :aText |
			| aNewSlotName |
			aNewSlotName := aText characters asString trimmed asSymbol.
			
			self giveFocusDuring: [
				self classCoder
					addSlotNamed: aNewSlotName
					ifFailed: [  ] ].
			
			aNewSlotCreator removeFromParent ];
		whenCancelled: [ :anEditableLabel |.
			anEditableLabel focusPrevious.
			anEditableLabel removeFromParent ].

	aNewSlotCreator navigator
		moveTo: 0;
		apply.

	self addChild: aNewSlotCreator at: (self childIndexOf: aButton)
]

{ #category : #'private - instance creation' }
GtClassCoderSlotsElement >> buildButtonForSlot: aSlot [
	^ GtClassCoderEditableLabel new
		text: aSlot name asRopedText;
		margin: self buttonMargin;
		constraintsDo: [ :c | c flow vertical alignCenter ];
		whenAccepted: [ :aText |
			| aCurrentSlotName aNewSlotName |
			
			aCurrentSlotName := aSlot name asSymbol.
			aNewSlotName := aText characters asString trimmed asSymbol.
			
			aCurrentSlotName ~= aNewSlotName
				ifTrue: [
					(RBRenameInstanceVariableRefactoring
						rename: aCurrentSlotName
						to: aNewSlotName
						in: aSlot definingClass) execute ] ];
		whenCancelled: [ :anEditableLabel | anEditableLabel text: aSlot name asRopedText ];
		whenDeleted: [ :anEditableLabel |
			(RBRemoveInstanceVariableRefactoring
				remove: aSlot name
				from: aSlot definingClass) execute ]
]

{ #category : #'private - instance creation' }
GtClassCoderSlotsElement >> buildNewSlotButton [
	^ BrButton new
		look:
			(BrGlamorousButtonRectangularLook new +
			BrGlamorousButtonIconLook new +
			BrGlamorousWithLabelTooltipLook new + (BrInteractiveCommonLook new
				default: [ :aWidget |
					aWidget
						border: BlBorder empty;
						background: BrGlamorousColors neutralBackgroundColor ];
				hovered: [ :aWidget | aWidget background: BrGlamorousColors neutralBackgroundColor darker ];
				pressed: [ :aWidget | aWidget background: BrGlamorousColors neutralBackgroundColor darker darker ];
				focused: [ :aWidget | aWidget border: (BlBorder paint: BrGlamorousColors focusedEditorBorderColor width: 1) ]));
		icon: BrGlamorousIcons add;
		label: 'Add slot';
		beSmall;
		hExact: 20;
		constraintsDo: [ :c | c flow vertical alignCenter ];
		action: [ :aButton | self addNewSlotEditorBefore: aButton ];
		addShortcut: (BlShortcut new
			combination: BlKeyCombination arrowLeft;
			action: [ :aShortcut :anEvent | anEvent currentTarget previousSiblingDo: [ :anElement | anElement requestFocus ] ]);
		addShortcut: (BlShortcut new
			combination: BlKeyCombination return;
			action: [ :aShortcut :anEvent | self addNewSlotEditorBefore: anEvent currentTarget ])
]

{ #category : #initialization }
GtClassCoderSlotsElement >> buttonMargin [
	^ BlInsets top: 2 right: 5 bottom: 2 left: 0
]

{ #category : #accessing }
GtClassCoderSlotsElement >> classCoder [
	<return: #GtClassCoder>

	^ classCoder
]

{ #category : #accessing }
GtClassCoderSlotsElement >> classCoder: aGtClassCoder [
	classCoder := aGtClassCoder.
	
	self initializeElements.

	classCoder
		when: GtClassCoderSlotsChanged do: [ :anAnnouncement | self actOnSlotsChanged: anAnnouncement ].
		
	classCoder
		when: GtClassCoderSlotsAdded do: [ :anAnnouncement | self actOnSlotsAdded: anAnnouncement ].
		
	classCoder
		when: GtClassCoderSlotsRemoved do: [ :anAnnouncement | self actOnSlotsRemoved: anAnnouncement ].
		
	classCoder
		when: GtClassCoderSlotChanged do: [ :anAnnouncement | self actOnSlotChanged: anAnnouncement ]
]

{ #category : #'private - slot buttons' }
GtClassCoderSlotsElement >> giveFocusDuring: aBlock [
	| shouldGiveNow |
	
	shouldGiveNow := shouldGiveFocusToAdded.
	shouldGiveFocusToAdded := true.
	aBlock ensure: [ shouldGiveFocusToAdded := shouldGiveNow ]
]

{ #category : #initialization }
GtClassCoderSlotsElement >> initialize [
	super initialize.
	
	self layout: BlFlowLayout new.
	self constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent ].
	
	slotElements := OrderedDictionary new.
	shouldGiveFocusToAdded := false
]

{ #category : #initialization }
GtClassCoderSlotsElement >> initializeElements [
	self removeChildren.
	slotElements removeAll.
	
	self classCoder theClass slots
		do: [ :eachSlot | self addButtonForSlot: eachSlot ].
	
	self addChild: (self buildNewSlotButton)
]

{ #category : #'private - slot buttons' }
GtClassCoderSlotsElement >> removeButtonForSlot: aSlot [					
	slotElements
		at: aSlot name
		ifPresent: [ :aSlotButton |	
			aSlotButton hasFocus
				ifTrue: [
					| aSlotIndex isFirst isLast |
					aSlotIndex := slotElements indexOfKey: aSlot name.
					isLast := aSlotIndex = slotElements size.
					isFirst := aSlotIndex = 1.
					
					(isLast and: [ isFirst not ])
						ifTrue: [ aSlotButton focusPrevious ]
						ifFalse: [ aSlotButton focusNext ] ].
			aSlotButton removeFromParent.
			slotElements removeKey: aSlot name ]
]

{ #category : #'private - slot buttons' }
GtClassCoderSlotsElement >> setSlot: aSlot toButton: aButtonElement [
	aButtonElement userData at: #gtCoderSlot put: aSlot
]

{ #category : #'private - slot buttons' }
GtClassCoderSlotsElement >> slotOfButton: aButtonElement [
	<return: #Slot>

	^ aButtonElement userData at: #gtCoderSlot
]
