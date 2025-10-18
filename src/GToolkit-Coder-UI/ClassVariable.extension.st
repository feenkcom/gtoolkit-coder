Extension { #name : #ClassVariable }

{ #category : #'*GToolkit-Coder-UI' }
ClassVariable >> gtBrowseReferencesActionFor: anAction context: aPhlowContext [
	<gtAction>
	
	^ anAction button
		label: 'Browse references';
		priority: 10;
		target: GtCoderVariableTarget;
		menuItemPreview: self name;
		menuItemGroup: BrMenuItemGroupConfiguration navigation;
		action: [ :aButton | 
			aButton phlow
				spawnObject: (GtSearchClassVariableReferenceFilter
						forClassAndSubclasses: self owningClass
						andVariable: self name) ]
]

{ #category : #'*GToolkit-Coder-UI' }
ClassVariable >> gtCreateAccessorsActionFor: anAction context: aPhlowContext [
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
					targetName: ('{1}''s {2} class variable'
							format: {aSelectedClass name.
									self name});
					confirmationLabel: ('Create accessors {1}' format: {self name});
					refactoringWithConfirmation: [ RBCreateAccessorsForVariableRefactoring
							variable: self name
							class: aSelectedClass
							classVariable: true ];
					afterAppliedBlock: [ BlTaskAction enqueueElement: aTargetElement action: [ anExplicitMenu hideAll ] ];
					menuModel: anExplicitMenu;
					anchorElement: aTargetElement.
			GtRefactoringsPreviewWithConfirmationElement new
				refactoringsViewModel: aViewModel;
				beContextMenuElement;
				bePinnable: anExplicitMenu ]
]

{ #category : #'*GToolkit-Coder-UI' }
ClassVariable >> gtPushDownActionFor: anAction context: aPhlowContext [
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
					targetName: ('{1}''s {2} class variable'
							format: {aSelectedClass name.
									self name});
					confirmationLabel: ('Push down {1}' format: {self name});
					refactoringWithConfirmation: [ RBPushDownClassVariableRefactoring variable: self name class: aSelectedClass ];
					afterAppliedBlock: [ BlTaskAction enqueueElement: aTargetElement action: [ anExplicitMenu hideAll ] ];
					menuModel: anExplicitMenu;
					anchorElement: aTargetElement.
			GtRefactoringsPreviewWithConfirmationElement new
				refactoringsViewModel: aViewModel;
				beContextMenuElement;
				bePinnable: anExplicitMenu ]
]

{ #category : #'*GToolkit-Coder-UI' }
ClassVariable >> gtPushUpActionFor: anAction context: aPhlowContext [
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
					targetName: ('{1}''s {2} class variable'
							format: {aSelectedClass name.
									self name});
					confirmationLabel: ('Push up {1}' format: {self name});
					refactoringWithConfirmation: [ RBPullUpClassVariableRefactoring
							variable: self name
							class: aSelectedClass superclass ];
					afterAppliedBlock: [ BlTaskAction enqueueElement: aTargetElement action: [ anExplicitMenu hideAll ] ];
					menuModel: anExplicitMenu;
					anchorElement: aTargetElement.
			GtRefactoringsPreviewWithConfirmationElement new
				refactoringsViewModel: aViewModel;
				beContextMenuElement;
				bePinnable: anExplicitMenu ]
]

{ #category : #'*GToolkit-Coder-UI' }
ClassVariable >> gtRemoveActionFor: anAction context: aPhlowContext [
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
							references := (GtSearchClassVariableReferenceFilter
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
			change := RBRemoveClassVariableRefactoring
					variable: self name
					class: aSelectedClass.
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
ClassVariable >> gtRenameActionFor: anAction context: aPhlowContext [
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
					targetName: ('{1}''s {2} class variable'
							format: {aSelectedClass name.
									self name});
					inputLabel: 'New slot name:';
					refactoringWithInput: [ :anInput | 
						RBRenameClassVariableRefactoring
							rename: self name
							to: anInput
							in: self owningClass ];
					afterAppliedBlock: [ BlTaskAction enqueueElement: aTargetElement action: [ anExplicitMenu hideAll ] ];
					menuModel: anExplicitMenu;
					anchorElement: aTargetElement.
			GtRefactoringsPreviewWithInputElement new
				refactoringsViewModel: aViewModel;
				beContextMenuElement;
				bePinnable: anExplicitMenu ]
]
