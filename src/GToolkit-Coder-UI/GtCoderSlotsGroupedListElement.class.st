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

{ #category : #'private - context menu' }
GtCoderSlotsGroupedListElement >> abstractSubmenuFor: aString [
	| submenu |
	submenu := BrMenuExplicit new.
	
	submenu
		stencil: [ :anExplicitMenu | 
			| aViewModel |
			aViewModel := GtRefactoringsWithConfirmationViewModel new
					refactoringTitle: 'Abstract';
					targetName: ('{1}''s {2} inst. variable' format: { self selectedClass name. aString });
					confirmationLabel: ('Abstract {1}' format: { aString });
					refactoringWithConfirmation: [ RBAbstractInstanceVariableRefactoring
						variable: aString
						class: self selectedClass ];
					afterAppliedBlock: [ anExplicitMenu hideAll ];
					menuModel: anExplicitMenu;
					anchorElement: self.
			GtRefactoringsPreviewWithConfirmationElement new 
				refactoringsViewModel: aViewModel;
				beContextMenuElement;
				bePinnable: anExplicitMenu ].
	
	^ submenu  
]

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

{ #category : #'private - context menu' }
GtCoderSlotsGroupedListElement >> contextMenuFor: item [
	| menu |
	menu := BrMenuItems new.
	menu
		addItemLabel: (self createLabel: 'Browse references' description: item name)
		action: [ self browseSlotReferencesFor: item name ].
	menu
		addItem: (BrMenuSubmenuItem new
				label: (self createLabel: 'Pull up' description: item name);
				submenu: (self pullUpSubmenuFor: item name);
				bePinSubmenuAction).
	menu
		addItem: (BrMenuSubmenuItem new
				label: (self createLabel: 'Push down' description: item name);
				submenu: (self pushDownSubmenuFor: item name);
				bePinSubmenuAction).
	menu
		addItem: (BrMenuSubmenuItem new
				label: (self createLabel: 'Create accessors' description: item name);
				submenu: (self createAccessorsSubmenuFor: item name);
				bePinSubmenuAction).
	menu
		addItem: (BrMenuSubmenuItem new
				label: (self createLabel: 'Abstract' description: item name);
				submenu: (self abstractSubmenuFor: item name);
				bePinSubmenuAction).
	menu
		addItem: (BrMenuSubmenuItem new
				label: (self createLabel: 'Protect' description: item name);
				submenu: (self protectSubmenuFor: item name);
				bePinSubmenuAction).
	menu
		addItem: (BrMenuSubmenuItem new
				label: (self createLabel: 'Remove' description: item name);
				submenu: (self removeSubmenuFor: item name)).
	menu
		addItem: (BrMenuSubmenuItem new
				label: (self createLabel: 'Rename' description: item name);
				submenu: (self renameSubmenuFor: item name);
				bePinSubmenuAction).
	^ menu
]

{ #category : #'private - context menu' }
GtCoderSlotsGroupedListElement >> createAccessorsSubmenuFor: aString [
	| submenu |
	submenu := BrMenuExplicit new.
	
	submenu
		stencil: [ :anExplicitMenu | 
			| aViewModel |
			aViewModel := GtRefactoringsWithConfirmationViewModel new
					refactoringTitle: 'Create accessors';
					targetName: ('{1}''s {2} inst. variable' format: { self selectedClass name. aString });
					confirmationLabel: ('Create accessors {1}' format: { aString });
					refactoringWithConfirmation: [ RBCreateAccessorsForVariableRefactoring
						instanceVariable: aString
						class: self selectedClass ];
					afterAppliedBlock: [ anExplicitMenu hideAll ];
					menuModel: anExplicitMenu;
					anchorElement: self.
			GtRefactoringsPreviewWithConfirmationElement new 
				refactoringsViewModel: aViewModel;
				beContextMenuElement;
				bePinnable: anExplicitMenu ].
	
	^ submenu 
]

{ #category : #initialization }
GtCoderSlotsGroupedListElement >> createSlotGroups [
	| classSlotGroup instanceGroup classVarGroup |
	instanceGroup := BrGroup new
			domainObject: 'instance-side slots';
			stream: #() asAsyncStream;
			itemStencil: [ BrHorizontalPane new
					aptitude: BrGlamorousListItemAptitude;
					hMatchParent;
					vFitContent ];
			itemDataBinder: [ :element :item | 
				| label slotText |
				element removeChildren.
				label := BrLabel new
						hMatchParent;
						vFitContent;
						beSmallSize;
						aptitude: GtCoderNavigationTreeLabelAptitude.

				slotText := self computeSlotItemText: item.

				label text: slotText.
				label
					addAptitude: (BrGlamorousWithExplicitContextMenuAptitude menu: [ self contextMenuFor: item ]).
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

{ #category : #'private - context menu' }
GtCoderSlotsGroupedListElement >> protectSubmenuFor: aString [
	| submenu |
	submenu := BrMenuExplicit new.
	
	submenu
		stencil: [ :anExplicitMenu | 
			| aViewModel |
			aViewModel := GtRefactoringsWithConfirmationViewModel new
					refactoringTitle: 'Protect';
					targetName: ('{1}''s {2} inst. variable' format: { self selectedClass name. aString });
					confirmationLabel: ('Protect {1}' format: { aString });
					refactoringWithConfirmation: [ RBProtectInstanceVariableRefactoring
						variable: aString
						class: self selectedClass ];
					afterAppliedBlock: [ anExplicitMenu hideAll ];
					menuModel: anExplicitMenu;
					anchorElement: self.
			GtRefactoringsPreviewWithConfirmationElement new 
				refactoringsViewModel: aViewModel;
				beContextMenuElement;
				bePinnable: anExplicitMenu ].
	
	^ submenu  
]

{ #category : #'private - context menu' }
GtCoderSlotsGroupedListElement >> pullUpSubmenuFor: aString [
	| submenu |
	submenu := BrMenuExplicit new.
	submenu
		stencil: [ :anExplicitMenu | 
			| aViewModel |
			aViewModel := GtRefactoringsWithConfirmationViewModel new
					refactoringTitle: 'Pull up';
					targetName: ('{1}''s {2} inst. variable' format: { self selectedClass name. aString });
					confirmationLabel: ('Pull up {1}' format: { aString });
					refactoringWithConfirmation: [ RBPullUpInstanceVariableRefactoring
						variable: aString
						class: self selectedClass superclass ];
					afterAppliedBlock: [ anExplicitMenu hideAll ];
					menuModel: anExplicitMenu;
					anchorElement: self.
			GtRefactoringsPreviewWithConfirmationElement new 
				refactoringsViewModel: aViewModel;
				beContextMenuElement;
				bePinnable: anExplicitMenu ].
	
	^ submenu
]

{ #category : #'private - context menu' }
GtCoderSlotsGroupedListElement >> pushDownSubmenuFor: aString [
	| submenu |
	submenu := BrMenuExplicit new.
	
	submenu
		stencil: [ :anExplicitMenu | 
			| aViewModel |
			aViewModel := GtRefactoringsWithConfirmationViewModel new
					refactoringTitle: 'Push down';
					targetName: ('{1}''s {2} inst. variable' format: { self selectedClass name. aString });
					confirmationLabel: ('Push down {1}' format: { aString });
					refactoringWithConfirmation: [ GtPushDownInstanceVariableRefactoring
						variable: aString
						class: self selectedClass ];
					afterAppliedBlock: [ anExplicitMenu hideAll ];
					menuModel: anExplicitMenu;
					anchorElement: self.
			GtRefactoringsPreviewWithConfirmationElement new 
				refactoringsViewModel: aViewModel;
				beContextMenuElement;
				bePinnable: anExplicitMenu ].
	
	^ submenu
]

{ #category : #'private - context menu' }
GtCoderSlotsGroupedListElement >> removeSubmenuFor: aString [
	| submenu |
	submenu := BrMenuExplicit new.
	^ submenu
		stencil: [ | element change button |
			element := BrVerticalPane new fitContent.
			element
				addChild: (BrLabel new
						margin: (BlInsets
								top: 10
								bottom: 0
								left: 10
								right: 10);
						aptitude: BrGlamorousLabelAptitude new glamorousRegularFont;
						text: ('Remove ' , aString) asRopedText).
			element
				addChild: (BrAsyncWidget new
						fitContent;
						stencil: [ | pane references |
							pane := BrVerticalPane new.
							pane fitContent.
							references := (GtSearchInstanceSlotReferenceFilter
									forClassAndSubclasses: self selectedClass
									andVariable: aString) size.
							references > 0
								ifTrue: [ pane
										addChild: (BrLabel new
												margin: (BlInsets left: 10 right: 10);
												aptitude: BrGlamorousLabelAptitude new glamorousRegularFont thin;
												text: (references printString , ' reference'
														, (references > 1 ifTrue: [ 's' ] ifFalse: [ '' ])) asRopedText) ].
							pane ]).
			change := RBRemoveInstanceVariableChange
					remove: aString
					from: self selectedClass.
			button := BrButton new
					aptitude: BrGlamorousButtonWithIconAptitude;
					beSmallSize;
					margin: (BlInsets
							top: 10
							bottom: 10
							left: 10
							right: 10);
					icon: BrGlamorousVectorIcons remove;
					label: 'Remove';
					action: [ submenu hideAll.
						change execute ].
			element addChild: button as: #removeButton.
			element ]
]

{ #category : #'private - context menu' }
GtCoderSlotsGroupedListElement >> renameSubmenuFor: aString [
	| submenu |
	submenu := BrMenuExplicit new.
	
	submenu
		stencil: [ :anExplicitMenu | 
			| aViewModel |
			aViewModel := GtRefactoringsWithInputViewModel new
					refactoringTitle: 'Rename slot';
					targetName: ('{1}''s {2} inst. variable' format: { self selectedClass name. aString });
					inputLabel: 'Rename slot:';
					refactoringWithInput: [ :anInput | 
						RBRenameInstanceVariableRefactoring
							rename: aString
							to: anInput
							in: self selectedClass ];
					afterAppliedBlock: [ anExplicitMenu hideAll ];
					menuModel: anExplicitMenu;
					anchorElement: self.
			GtRefactoringsPreviewWithInputElement new 
				refactoringsViewModel: aViewModel;
				beContextMenuElement;
				bePinnable: anExplicitMenu ].
	
	^ submenu
]

{ #category : #accessing }
GtCoderSlotsGroupedListElement >> selectedClass [
	^ navigationModel selectedClass
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
