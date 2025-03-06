Class {
	#name : #GtCoderSlotsGroupedListElement,
	#superclass : #BrGroupedList,
	#traits : 'TGtCoderNavigationWithContextMenu',
	#classTraits : 'TGtCoderNavigationWithContextMenu classTrait',
	#instVars : [
		'slotsGroup',
		'navigationModel'
	],
	#category : #'GToolkit-Coder-UI-Navigation - Helpers'
}

{ #category : #'private - actions' }
GtCoderSlotsGroupedListElement >> browseSlotReferencesFor: aString [
	self phlow
		spawnObject: (GtSearchInstanceSlotReferenceFilter
				forClassAndSubclasses: self selectedClass
				andVariable: aString)
]

{ #category : #initialization }
GtCoderSlotsGroupedListElement >> computeSlotItemText: aSlot [
	| slotText |
	
	slotText := aSlot name asRopedText.
	self navigationModel selectedClass = aSlot definingClass instanceSide
		ifFalse: [ slotText, ((' ({1})' format: { aSlot definingClass name }) asRopedText foreground: Color gray) ].

	^ slotText
]

{ #category : #initialization }
GtCoderSlotsGroupedListElement >> createSlotGroups [
	| classSlotGroup instanceGroup classVarGroup |
	instanceGroup := BrGroup new
			domainObject: 'instance-side slots';
			stream: #() asAsyncStream;
			itemStencil: [ BrHorizontalPane new
					aptitude:  BrGlamorousListItemAptitude;
					hMatchParent;
					vFitContent ];
			itemDataBinder: [ :element :item | 
				| label slotText|
				element removeChildren.
				label := BrLabel new
						hMatchParent;
						vFitContent;
						beSmallSize;
						aptitude: BrGlamorousLabelAptitude.
						
				slotText := self computeSlotItemText: item.
				
				label text: slotText.
				label
					addAptitude: (BrGlamorousWithExplicitContextMenuAptitude
							itemsWithAnchorActions: [ (self slotListContextMenuItemsFor: item) ]).
				element addChild: label ];
			shouldShowWithoutItems: false.
	classSlotGroup := instanceGroup copy domainObject: 'class-side slots'.
	classVarGroup := instanceGroup copy domainObject: 'class vars'.
	^ {instanceGroup.
		classSlotGroup.
		classVarGroup}
]

{ #category : #initialization }
GtCoderSlotsGroupedListElement >> initialize [
	super initialize.

	self
		padding: (BlInsets left: 5 right: 10);
		matchParent;
		headerElementStencil: [ BrLabel new
				beSmallSize;
				aptitude: (BrGlamorousLabelAptitude new foreground: Color gray) ];
		headerDataBinder: [ :label :each | label text: each domainObject asRopedText ].

	slotsGroup := self createSlotGroups.
	self groups: slotsGroup.
	
	self
		when: BrSelectionChanged
		do: [ :anEvent | self onSlotsListSelectionChanged ]
]

{ #category : #accessing }
GtCoderSlotsGroupedListElement >> navigationModel [
	^ navigationModel
]

{ #category : #accessing }
GtCoderSlotsGroupedListElement >> navigationModel: anObject [
	navigationModel == anObject
		ifTrue: [ ^ self ].

	self unsubscribeFromNavigationModel.
	navigationModel := anObject.
	self subscribeToNavigationModel.
	
	self updateSlotList
]

{ #category : #'event handling - selection' }
GtCoderSlotsGroupedListElement >> onSlotSelected: anAnnouncement [
	
]

{ #category : #'event handling - selection' }
GtCoderSlotsGroupedListElement >> onSlotsListSelectionChanged [
	| theIndices anIndex aSelectedItem |

	theIndices := self selectedIndices ifEmpty: [ ^ self ].
	anIndex := theIndices first.
	(anIndex between: 1 and: self viewModel entityCount)
		ifFalse: [ ^ self ].
	aSelectedItem := (self viewModel entityAt: anIndex) value object.
	self navigationModel selectSlot: aSelectedItem source: self
]

{ #category : #'event handling' }
GtCoderSlotsGroupedListElement >> onSlotsToShowChanged: anAnnouncement [
	self updateSlotList
]

{ #category : #'private - actions' }
GtCoderSlotsGroupedListElement >> renameSlot: slotName inElement: elem [
	| edit |
	edit := BrEditableLabel new.
	edit
		aptitude: (BrGlamorousEditableLabelAptitude new
				fontSize: 11.9;   "Force the font to match the label font"
				background: Color transparent);
		text: slotName;
		when: BrEditorAcceptWish
			do: [ :aWish | 
				| refactoring |
				refactoring := RBRenameInstanceVariableRefactoring
						rename: slotName
						to: aWish text asString
						in: self selectedClass.
				edit switchToLabel.
				self
					addPreviewButtonFor: refactoring
					to: elem
					cancelSelector: #updateSlotList ];
		switchToEditor.
	edit requestFocus.
	elem removeChildren.
	elem addChild: edit
]

{ #category : #accessing }
GtCoderSlotsGroupedListElement >> selectedClass [
	^ navigationModel selectedClass
]

{ #category : #'private - context menu' }
GtCoderSlotsGroupedListElement >> slotListContextMenuItemsFor: item [
	^ {(self createLabel: 'Browse references' description: item name)
			-> [ :elem | self browseSlotReferencesFor: item name ].
		(self createLabel: 'Push up' description: item name)
			-> [ :elem | 
				| refactoring |
				refactoring := RBPullUpInstanceVariableRefactoring
						variable: item name
						class: self selectedClass superclass.
				self
					addPreviewButtonFor: refactoring
					to: elem
					cancelSelector: #updateSlotList ].
		(self createLabel: 'Push down' description: item name)
			-> [ :elem | 
				| refactoring |
				refactoring := GtPushDownInstanceVariableRefactoring
						variable: item name
						class: self selectedClass.
				self
					addPreviewButtonFor: refactoring
					to: elem
					cancelSelector: #updateSlotList ].
		(self createLabel: 'Create accessors' description: item name)
			-> [ :elem | 
				| refactoring |
				refactoring := RBCreateAccessorsForVariableRefactoring
						instanceVariable: item name
						class: self selectedClass.
				self
					addPreviewButtonFor: refactoring
					to: elem
					cancelSelector: #updateSlotList ].
		(self createLabel: 'Abstract' description: item name)
			-> [ :elem | 
				| refactoring |
				refactoring := RBAbstractInstanceVariableRefactoring
						variable: item name
						class: self selectedClass.
				self
					addPreviewButtonFor: refactoring
					to: elem
					cancelSelector: #updateSlotList ].
		(self createLabel: 'Protect' description: item name)
			-> [ :elem | 
				| refactoring |
				refactoring := RBProtectInstanceVariableRefactoring
						variable: item name
						class: self selectedClass.
				self
					addPreviewButtonFor: refactoring
					to: elem
					cancelSelector: #updateSlotList ].
		(self createLabel: 'Remove' description: item name)
			-> [ :elem | 
				| refactoring |
				refactoring := RBRemoveInstanceVariableRefactoring
						variable: item name
						class: self selectedClass.
				self
					addPreviewButtonFor: refactoring
					to: elem
					cancelSelector: #updateSlotList ].
		"(self createLabel: 'Rename slot' description: item name)
			-> [ :elem | self renameSlot: item name inElement: elem ]"}
]

{ #category : #'private - subscriptions' }
GtCoderSlotsGroupedListElement >> subscribeToNavigationModel [
	| subscriptions |

	subscriptions := {
		GtCoderNavigationSlotsToShowChanged -> #onSlotsToShowChanged:.
		GtCoderNavigationSlotSelected -> #onSlotSelected:.
	}.

	subscriptions
		do: [ :sub | 
			navigationModel weak
				when: sub key
				send: sub value
				to: self ]
]

{ #category : #subscriptions }
GtCoderSlotsGroupedListElement >> unsubscribeFromNavigationModel [
	navigationModel ifNotNil: [ :aModel | aModel unsubscribe: self ]
]

{ #category : #'updating lists' }
GtCoderSlotsGroupedListElement >> updateSlotList [
	| slotsToShow newSlotGroups instanceSideSlots classSideSlots staticVars |
	self navigationModel ifNil: [ ^ self ].

	self deselectAll.

	slotsToShow := self navigationModel slotsToShow.
	instanceSideSlots := slotsToShow
			select: [ :eachSlot | eachSlot isInstanceVariable and: [ eachSlot owningClass isClassSide not ] ].

	classSideSlots := slotsToShow
			select: [ :eachSlot | eachSlot isInstanceVariable and: [ eachSlot owningClass isClassSide ] ].

	staticVars := slotsToShow select: [ :eachSlot | eachSlot isClassVariable ].

	newSlotGroups := {instanceSideSlots.
			classSideSlots.
			staticVars}
			collect: [ :each | each asSortedCollection: [ :a :b | a name < b name ] ].

	slotsGroup with: newSlotGroups do: [ :grp :str | grp items: str ].
	self groups: slotsGroup
]
