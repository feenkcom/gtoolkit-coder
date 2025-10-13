Extension { #name : #InstanceVariableSlot }

{ #category : #'*GToolkit-Coder-UI' }
InstanceVariableSlot >> gtAbstractActionFor: anAction context: aPhlowContext [
	<gtAction>
	| aSelectedClass |
	aSelectedClass := self owningClass.

	aSelectedClass ifNil: [ ^ anAction noAction ].

	^ anAction dropdown
		label: 'Abstract';
		priority: 23;
		target: GtCoderVariableTarget;
		menuItemPreview: self name;
		menuItemGroup: BrMenuItemGroupConfiguration refactoring;
		menuItemPinSubmenu;
		content: [ :anActionElement :aTargetElement :anExplicitMenu | 
			| aViewModel |
			aViewModel := GtRefactoringsWithConfirmationViewModel new
					refactoringTitle: 'Abstract';
					targetName: ('{1}''s {2} inst. variable'
							format: {aSelectedClass name.
									self name});
					confirmationLabel: ('Abstract {1}' format: {self name});
					refactoringWithConfirmation: [ RBAbstractInstanceVariableRefactoring
							variable: self name
							class: aSelectedClass ];
					afterAppliedBlock: [ anExplicitMenu hideAll ];
					menuModel: anExplicitMenu;
					anchorElement: aTargetElement.
			GtRefactoringsPreviewWithConfirmationElement new
				refactoringsViewModel: aViewModel;
				beContextMenuElement;
				bePinnable: anExplicitMenu ]
]

{ #category : #'*GToolkit-Coder-UI' }
InstanceVariableSlot >> gtBrowseDefiningClassFor: anAction context: aPhlowContext [
	<gtAction>
	self definingClass = self owningClass ifTrue: [ ^ anAction noAction ].

	^ anAction button
		label: ('Browse defining {1}' format: {self definingClass gtCoderTypeName});
		priority: 15;
		target: GtCoderVariableTarget;
		menuItemPreview: [ self definingClass name ];
		menuItemGroup: BrMenuItemGroupConfiguration navigation;
		action: [ :aButton | aButton phlow spawnObject: self definingClass ];
		primaryModifierAction: [ :aButton | self definingClass gtBrowseFrom: aButton ]
]

{ #category : #'*GToolkit-Coder-UI' }
InstanceVariableSlot >> gtBrowseDefiningSuperclassFor: anAction context: aPhlowContext [
	<gtAction>
	self definingClass = self owningClass ifFalse: [ ^ anAction noAction ].
	aPhlowContext
		ifBehavior: [ :aBehavior | 
			aBehavior = self owningClass ifTrue: [ ^ anAction noAction ] ]
		ifNone: [ ^ anAction noAction ].

	^ anAction button
		label: 'Browse defining superclass';
		priority: 12;
		target: GtCoderVariableTarget;
		menuItemPreview: [ self owningClass name ];
		menuItemGroup: BrMenuItemGroupConfiguration navigation;
		action: [ :aButton | aButton phlow spawnObject: self owningClass ];
		primaryModifierAction: [ :aButton | self owningClass gtBrowseFrom: aButton ]
]

{ #category : #'*GToolkit-Coder-UI' }
InstanceVariableSlot >> gtBrowseReferencesActionFor: anAction context: aPhlowContext [
	<gtAction>
	^ anAction button
		label: 'Browse references';
		priority: 10;
		target: GtCoderVariableTarget;
		menuItemPreview: self name;
		menuItemGroup: BrMenuItemGroupConfiguration navigation;
		action: [ :aButton | 
			| aFilter |
			aFilter := self owningClass isInstanceSide
					ifTrue: [ GtSearchInstanceSlotReferenceFilter
							forClassAndSubclasses: self owningClass
							andVariable: self name ]
					ifFalse: [ GtSearchClassSlotReferenceFilter
							forClassAndSubclasses: self owningClass
							andVariable: self name ].
			aButton phlow spawnObject: aFilter ]
]

{ #category : #'*GToolkit-Coder-UI' }
InstanceVariableSlot >> gtCreateAccessorsActionFor: anAction context: aPhlowContext [
	<gtAction>
	| aSelectedClass |
	aSelectedClass := self owningClass.

	aSelectedClass ifNil: [ ^ anAction noAction ].

	^ anAction dropdown
		label: 'Create accessors';
		priority: 22;
		target: GtCoderVariableTarget;
		menuItemPreview: self name;
		menuItemGroup: BrMenuItemGroupConfiguration refactoring;
		menuItemPinSubmenu;
		content: [ :anActionElement :aTargetElement :anExplicitMenu | 
			| aViewModel |
			aViewModel := GtRefactoringsWithConfirmationViewModel new
					refactoringTitle: 'Create accessors';
					targetName: ('{1}''s {2} inst. variable'
							format: {aSelectedClass name.
									self name});
					confirmationLabel: ('Create accessors {1}' format: {self name});
					refactoringWithConfirmation: [ RBCreateAccessorsForVariableRefactoring
							instanceVariable: self name
							class: aSelectedClass ];
					afterAppliedBlock: [ anExplicitMenu hideAll ];
					menuModel: anExplicitMenu;
					anchorElement: aTargetElement.
			GtRefactoringsPreviewWithConfirmationElement new
				refactoringsViewModel: aViewModel;
				beContextMenuElement;
				bePinnable: anExplicitMenu ]
]

{ #category : #'*GToolkit-Coder-UI' }
InstanceVariableSlot >> gtInspectObjectActionFor: anAction context: aPhlowContext [
	<gtAction>
	| aSelfObject |
	aSelfObject := aPhlowContext selfObjectIfNone: [ ^ anAction noAction ].

	^ anAction button
		label: 'Inspect object';
		priority: 30;
		target: GtCoderVariableTarget;
		menuItemPreview: [ (aSelfObject readSlot: self) gtDisplayText ];
		menuItemGroup: BrMenuItemGroupConfiguration navigation;
		action: [ :aButton | 
			aButton phlow spawnObject:  (aSelfObject readSlot: self) ]
]

{ #category : #'*GToolkit-Coder-UI' }
InstanceVariableSlot >> gtProtectSlotActionFor: anAction context: aPhlowContext [
	<gtAction>
	| aSelectedClass |
	aSelectedClass := self owningClass.

	aSelectedClass ifNil: [ ^ anAction noAction ].

	^ anAction dropdown
		label: 'Protect';
		priority: 24;
		target: GtCoderVariableTarget;
		menuItemPreview: self name;
		menuItemGroup: BrMenuItemGroupConfiguration refactoring;
		menuItemPinSubmenu;
		content: [ :anActionElement :aTargetElement :anExplicitMenu | 
			| aViewModel |
			aViewModel := GtRefactoringsWithConfirmationViewModel new
					refactoringTitle: 'Protect';
					targetName: ('{1}''s {2} inst. variable'
							format: {aSelectedClass name.
									self name});
					confirmationLabel: ('Protect {1}' format: {self name});
					refactoringWithConfirmation: [ RBProtectInstanceVariableRefactoring variable: self name class: aSelectedClass ];
					afterAppliedBlock: [ anExplicitMenu hideAll ];
					menuModel: anExplicitMenu;
					anchorElement: aTargetElement.
			GtRefactoringsPreviewWithConfirmationElement new
				refactoringsViewModel: aViewModel;
				beContextMenuElement;
				bePinnable: anExplicitMenu ]
]

{ #category : #'*GToolkit-Coder-UI' }
InstanceVariableSlot >> gtPushDownActionFor: anAction context: aPhlowContext [
	<gtAction>
	| aSelectedClass |
	aSelectedClass := self owningClass.

	aSelectedClass ifNil: [ ^ anAction noAction ].

	^ anAction dropdown
		label: 'Push down';
		priority: 21;
		target: GtCoderVariableTarget;
		menuItemPreview: self name;
		menuItemGroup: BrMenuItemGroupConfiguration refactoring;
		menuItemPinSubmenu;
		content: [ :anActionElement :aTargetElement :anExplicitMenu | 
			| aViewModel |
			aViewModel := GtRefactoringsWithConfirmationViewModel new
					refactoringTitle: 'Push down';
					targetName: ('{1}''s {2} inst. variable'
							format: {aSelectedClass name.
									self name});
					confirmationLabel: ('Push down {1}' format: {self name});
					refactoringWithConfirmation: [ GtPushDownInstanceVariableRefactoring
							variable: self name
							class: aSelectedClass ];
					afterAppliedBlock: [ anExplicitMenu hideAll ];
					menuModel: anExplicitMenu;
					anchorElement: aTargetElement.
			GtRefactoringsPreviewWithConfirmationElement new
				refactoringsViewModel: aViewModel;
				beContextMenuElement;
				bePinnable: anExplicitMenu ]
]

{ #category : #'*GToolkit-Coder-UI' }
InstanceVariableSlot >> gtPushUpActionFor: anAction context: aPhlowContext [
	<gtAction>
	| aSelectedClass |
	aSelectedClass := self owningClass.

	aSelectedClass ifNil: [ ^ anAction noAction ].

	^ anAction dropdown
		label: 'Push up';
		priority: 20;
		target: GtCoderVariableTarget;
		menuItemPreview: self name;
		menuItemGroup: BrMenuItemGroupConfiguration refactoring;
		menuItemPinSubmenu;
		content: [ :anActionElement :aTargetElement :anExplicitMenu | 
			| aViewModel |
			aViewModel := GtRefactoringsWithConfirmationViewModel new
					refactoringTitle: 'Push up';
					targetName: ('{1}''s {2} inst. variable'
							format: {aSelectedClass name.
									self name});
					confirmationLabel: ('Push up {1}' format: {self name});
					refactoringWithConfirmation: [ RBPullUpInstanceVariableRefactoring
							variable: self name
							class: aSelectedClass superclass ];
					afterAppliedBlock: [ anExplicitMenu hideAll ];
					menuModel: anExplicitMenu;
					anchorElement: aTargetElement.
			GtRefactoringsPreviewWithConfirmationElement new
				refactoringsViewModel: aViewModel;
				beContextMenuElement;
				bePinnable: anExplicitMenu ]
]

{ #category : #'*GToolkit-Coder-UI' }
InstanceVariableSlot >> gtRemoveActionFor: anAction context: aPhlowContext [
	<gtAction>
	| aSelectedClass |
	aSelectedClass := self owningClass.

	aSelectedClass ifNil: [ ^ anAction noAction ].

	^ anAction dropdown
		label: 'Remove';
		priority: 40;
		target: GtCoderVariableTarget;
		menuItemPreview: self name;
		menuItemGroup: BrMenuItemGroupConfiguration removal;
		menuItemPinSubmenu;
		content: [ :anActionElement :aTargetElement :anExplicitMenu | 
			| element change button |
			element := BrVerticalPane new fitContent.
			element
				addChild: (BrLabel new
						margin: (BlInsets
								top: 10
								bottom: 0
								left: 10
								right: 10);
						aptitude: BrGlamorousLabelAptitude new glamorousRegularFont;
						text: ('Remove ' , self name) asRopedText).
			element
				addChild: (BrAsyncWidget new
						fitContent;
						stencil: [ | pane references |
							pane := BrVerticalPane new.
							pane fitContent.
							references := (GtSearchInstanceSlotReferenceFilter
									forClassAndSubclasses: aSelectedClass
									andVariable: self name) size.
							references > 0
								ifTrue: [ pane
										addChild: (BrLabel new
												margin: (BlInsets left: 10 right: 10);
												aptitude: BrGlamorousLabelAptitude new glamorousRegularFont thin;
												text: (references printString , ' reference'
														, (references > 1 ifTrue: [ 's' ] ifFalse: [ '' ])) asRopedText) ].
							pane ]).
			change := RBRemoveInstanceVariableChange
					remove: self name
					from: aSelectedClass.
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
					action: [ anExplicitMenu hideAll.
						change execute ].
			element addChild: button as: #removeButton.
			element ]
]

{ #category : #'*GToolkit-Coder-UI' }
InstanceVariableSlot >> gtRenameActionFor: anAction context: aPhlowContext [
	<gtAction>
	| aSelectedClass |
	aSelectedClass := self owningClass.
	aSelectedClass ifNil: [ ^ anAction noAction ].

	^ anAction dropdown
		label: 'Rename';
		priority: 25;
		target: GtCoderVariableTarget;
		menuItemPreview: self name;
		menuItemGroup: BrMenuItemGroupConfiguration refactoring;
		menuItemPinSubmenu;
		content: [ :anActionElement :aTargetElement :anExplicitMenu | 
			| aViewModel |
			aViewModel := GtRefactoringsWithInputViewModel new
					refactoringTitle: 'Rename';
					targetName: ('{1}''s {2} inst. variable'
							format: {aSelectedClass name.
									self name});
					inputLabel: 'New slot name:';
					refactoringWithInput: [ :anInput | 
						GtRenameInstanceVariableRefactoring
							rename: self name
							to: anInput
							in:  aSelectedClass ];
					afterAppliedBlock: [ anExplicitMenu hideAll ];
					menuModel: anExplicitMenu;
					anchorElement: aTargetElement.
			GtRefactoringsPreviewWithInputElement new
				refactoringsViewModel: aViewModel;
				beContextMenuElement;
				bePinnable: anExplicitMenu ]
]
