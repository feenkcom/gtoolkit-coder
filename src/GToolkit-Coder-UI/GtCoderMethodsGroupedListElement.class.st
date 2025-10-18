Class {
	#name : #GtCoderMethodsGroupedListElement,
	#superclass : #BrGroupedList,
	#traits : 'TGtCoderNavigationWithContextMenu',
	#classTraits : 'TGtCoderNavigationWithContextMenu classTrait',
	#instVars : [
		'navigationModel',
		'methodGroups'
	],
	#category : #'GToolkit-Coder-UI-Navigation - Helpers'
}

{ #category : #'private - actions' }
GtCoderMethodsGroupedListElement >> browseHierarchyImplementorsOf: aSymbol [
	self phlow spawnObject: aSymbol gtImplementors & self hierarchyFilter
]

{ #category : #'private - actions' }
GtCoderMethodsGroupedListElement >> browseHierarchyReferencesOf: aSymbol [
	self phlow spawnObject: aSymbol gtSenders & self hierarchyFilter
]

{ #category : #'private - actions' }
GtCoderMethodsGroupedListElement >> browseImplementorsOf: aSymbol [
	self phlow spawnObject: (GtSearchImplementorsFilter selector: aSymbol)
]

{ #category : #'private - actions' }
GtCoderMethodsGroupedListElement >> browseReferencesOf: aSymbol [
	self phlow spawnObject: (GtSearchReferencesFilter literal: aSymbol) 
]

{ #category : #'private - actions' }
GtCoderMethodsGroupedListElement >> browseSeveralHierarchyImplementorsOf: aCollectionOfSymbols [
	| aFilter |
	aFilter := aCollectionOfSymbols allButFirst
			inject: aCollectionOfSymbols first gtImplementors & self hierarchyFilter
			into: [ :filter :symbol | filter | (symbol gtImplementors & self hierarchyFilter) ].

	self phlow spawnObject: aFilter
]

{ #category : #'private - actions' }
GtCoderMethodsGroupedListElement >> browseSeveralHierarchyReferencesOf: aCollectionOfSymbols [
	| aFilter |
	aFilter := aCollectionOfSymbols allButFirst
			inject: aCollectionOfSymbols first gtSenders & self hierarchyFilter
			into: [ :filter :symbol | filter | (symbol gtSenders & self hierarchyFilter) ].

	self phlow spawnObject: aFilter
]

{ #category : #'private - actions' }
GtCoderMethodsGroupedListElement >> browseSeveralImplementorsOf: aCollectionOfSymbols [
	| aFilter |
	aFilter := aCollectionOfSymbols allButFirst
			inject: (GtSearchImplementorsFilter selector: aCollectionOfSymbols first)
			into: [ :filter :symbol | filter | (GtSearchImplementorsFilter selector: symbol) ].

	self phlow spawnObject: aFilter
]

{ #category : #'private - actions' }
GtCoderMethodsGroupedListElement >> browseSeveralReferencesOf: aCollectionOfSymbols [
	| aFilter |
	aFilter := aCollectionOfSymbols allButFirst
			inject: (GtSearchReferencesFilter literal: aCollectionOfSymbols first)
			into: [ :filter :symbol | filter | (GtSearchReferencesFilter literal: symbol) ].

	self phlow spawnObject: aFilter.
]

{ #category : #'private - insance creation' }
GtCoderMethodsGroupedListElement >> buildMethodItem [
	<return: #BlElement>
	| aLabel |
	aLabel := BrLabel new.
	aLabel
		hMatchParent;
		vFitContent;
		beSmallSize;
		aptitude: GtCoderNavigationTreeLabelAptitude + BrGlamorousListItemAptitude
				+ (BrGlamorousWithExplicitContextMenuAptitude new
						withGainFocusOnShow;
						handleSubmenu: [ | someItems currentMethod |
							currentMethod := aLabel userData at: #method.
							someItems := self selectedItems.
							(someItems size > 1 and: [ someItems identityIncludes: currentMethod ])
								ifTrue: [ self contextMenuForSeveralItems: someItems in: aLabel ]
								ifFalse: [ self contextMenuForOneItem: currentMethod in: aLabel ] ]).

	aLabel addEventHandler: self createMethodDragHandler.

	^ aLabel
]

{ #category : #'private - context menu' }
GtCoderMethodsGroupedListElement >> contextMenuForOneItem: item in: anElement [
	| menu |
	menu := BrMenuItems new.
	menu
		addItem: (BrMenuActionItem new
				group: BrMenuItemGroupConfiguration navigation;
				label: (self createLabel: 'Browse implementors' description: item selector);
				action: [ self browseImplementorsOf: item selector ]).
	menu
		addItem: (BrMenuActionItem new
				group: BrMenuItemGroupConfiguration navigation;
				label: (self createLabel: 'Browse hierarchy implementors' description: item selector);
				action: [ self browseHierarchyImplementorsOf: item selector ]).
	menu
		addItem: (BrMenuActionItem new
				group: BrMenuItemGroupConfiguration navigation;
				label: (self createLabel: 'Browse references' description: item selector);
				action: [ self browseReferencesOf: item selector ]).
	menu
		addItem: (BrMenuActionItem new
				group: BrMenuItemGroupConfiguration navigation;
				label: (self createLabel: 'Browse hierarchy references' description: item selector);
				action: [ self browseHierarchyReferencesOf: item selector ]).
	menu
		addItem: (BrMenuSubmenuItem new
				group: BrMenuItemGroupConfiguration refactoring;
				label: (self createLabel: 'Push up method' description: item selector);
				submenu: (self pushUpMethodSubmenuFor: item);
				bePinSubmenuAction).

	item methodClass subclasses notEmpty
		ifTrue: [ menu
				addItem: (BrMenuSubmenuItem new
						group: BrMenuItemGroupConfiguration refactoring;
						label: (self createLabel: 'Push down method' description: item selector);
						submenu: (self pushDownMethodSubmenuFor: item);
						bePinSubmenuAction) ].
	menu
		addItem: (BrMenuSubmenuItem new
				group: BrMenuItemGroupConfiguration refactoring;
				label: (self createLabel: 'Rename message' description: item selector);
				submenu: (self renameMethodSubmenuFor: item);
				bePinSubmenuAction).
	menu
		addItem: (BrMenuSubmenuItem new
				group: BrMenuItemGroupConfiguration refactoring;
				label: (self createLabel: 'Remove method' description: item selector);
				submenu: (self removeMethodSubmenuFor: item)).
	^ menu
]

{ #category : #'private - context menu' }
GtCoderMethodsGroupedListElement >> contextMenuForSeveralItems: someItems in: anElement [
	| menu |
	menu := BrMenuItems new.
	menu
		addItem: (BrMenuActionItem new
				group: BrMenuItemGroupConfiguration navigation;
				label: (self
						createLabel: 'Browse implementors'
						description: ('{1} methods' format: {someItems size}));
				action: [ self browseSeveralImplementorsOf: (someItems collect: #selector) ]).
	menu
		addItem: (BrMenuActionItem new
				group: BrMenuItemGroupConfiguration navigation;
				label: (self
						createLabel: 'Browse hierarachy implementors'
						description: ('{1} methods' format: {someItems size}));
				action: [ self browseSeveralHierarchyImplementorsOf: (someItems collect: #selector) ]).
	menu
		addItem: (BrMenuActionItem new
				group: BrMenuItemGroupConfiguration navigation;
				label: (self
						createLabel: 'Browse references'
						description: ('{1} methods' format: {someItems size}));
				action: [ self browseSeveralReferencesOf: (someItems collect: #selector) ]).
	menu
		addItem: (BrMenuActionItem new
				group: BrMenuItemGroupConfiguration navigation;
				label: (self
						createLabel: 'Browse hierarchy references'
						description: ('{1} methods' format: {someItems size}));
				action: [ self browseSeveralHierarchyReferencesOf: (someItems collect: #selector) ]).

	menu
		addItem: (BrMenuSubmenuItem new
				group: BrMenuItemGroupConfiguration refactoring;
				label: (self
						createLabel: 'Push up methods'
						description: ('{1} methods' format: {someItems size}));
				submenu: (self pushUpSeveralMethodsSubmenuFor: someItems);
				bePinSubmenuAction).

	someItems anyOne methodClass subclasses notEmpty
		ifTrue: [ menu
				addItem: (BrMenuSubmenuItem new
						group: BrMenuItemGroupConfiguration refactoring;
						label: (self
								createLabel: 'Push down methods'
								description: ('{1} methods' format: {someItems size}));
						submenu: (self pushDownSeveralMethodsSubmenuFor: someItems);
						bePinSubmenuAction) ].

	menu
		addItem: (BrMenuSubmenuItem new
				group: BrMenuItemGroupConfiguration refactoring;
				label: (self
						createLabel: 'Remove methods'
						description: ('{1} methods' format: {someItems size}));
				submenu: (self removeSeveralMethodsSubmenuFor: someItems)).
	^ menu
]

{ #category : #'private - insance creation' }
GtCoderMethodsGroupedListElement >> createDraggedMethodItem: aDragItem [

	^ BrLabel new
		aptitude: (BrGlamorousLabelAptitude new padding: (BlInsets all: 5)) + BrShadowAptitude;
		beSmallSize;
		opacity: 0.85;
		margin: (BlInsets all: 5);
		background: Color white;
		beFocusable;
		requestFocus;
		geometry: (BlRoundedRectangleGeometry cornerRadius: 5);
		fitContent;
		text: aDragItem domainObject printString
]

{ #category : #'private - insance creation' }
GtCoderMethodsGroupedListElement >> createMethodDragHandler [
	^ BlDragHandler new
		enableCopy;
		liftItem: [ :aLabelElement | 
			| someItems currentMethod |
			currentMethod := aLabelElement userData at: #method.
			someItems := self selectedItems.
			(someItems size > 1 and: [ someItems identityIncludes: currentMethod ])
				ifTrue: [ 
					someItems collect: [ :each |
						BlDragItem new
							sourceElement: aLabelElement;
							domainObject: each;
							stencil: [ :aDragItem | self createSeveralDraggedMethodsItem: someItems ] ] ]
				ifFalse: [ 
					BlDragItem new
						sourceElement: aLabelElement;
						domainObject: (aLabelElement userData at: #method);
						stencil: [ :aDragItem | self createDraggedMethodItem: aDragItem ] ] ]
]

{ #category : #'private - insance creation' }
GtCoderMethodsGroupedListElement >> createMethodGroups [
	| classGroup instanceGroup |
	instanceGroup := BrGroup new
			domainObject: 'instance side';
			stream: #() asAsyncStream;
			itemStencil: [ self buildMethodItem ];
			itemDataBinder: [ :element :eachCompiledMethod |
				| aSelector |
				element userData at: #method put: eachCompiledMethod.
				
				aSelector := eachCompiledMethod selector asRopedText.
				eachCompiledMethod isDeprecated
					ifTrue: [ aSelector lineThrough ].
				
				element text: aSelector ];
			shouldShowWithoutItems: false.
	classGroup := instanceGroup copy domainObject: 'class side'.
	^ {instanceGroup.
		classGroup}
]

{ #category : #'private - insance creation' }
GtCoderMethodsGroupedListElement >> createSeveralDraggedMethodsItem: aCollection [
	^ BrLabel new
		aptitude: (BrGlamorousLabelAptitude new padding: (BlInsets all: 5)) + BrShadowAptitude;
		beSmallSize;
		opacity: 0.85;
		margin: (BlInsets all: 5);
		background: Color white;
		beFocusable;
		requestFocus;
		geometry: (BlRoundedRectangleGeometry cornerRadius: 5);
		fitContent;
		text: ('{1} methods' format: {aCollection  size})
]

{ #category : #'private - actions' }
GtCoderMethodsGroupedListElement >> hierarchyFilter [
	^ (GtSearchInheritedMethodsFilter forClass: self selectedClass) withSuperclasses
		withSubclasses
]

{ #category : #initialization }
GtCoderMethodsGroupedListElement >> initialize [
	super initialize.

	self
		padding: (BlInsets left: 5 right: 10);
		matchParent;
		headerElementStencil: [ BrLabel new
				beSmallSize;
				aptitude: (BrGlamorousLabelAptitude new foreground: Color gray) ];
		headerDataBinder: [ :label :each | label text: each domainObject asRopedText ].

	methodGroups := self createMethodGroups.
	self groups: methodGroups.
	
	self
		when: BrSelectionChanged
		do: [ :anEvent | self onMethodsListSelectionChanged ]
]

{ #category : #accessing }
GtCoderMethodsGroupedListElement >> methodList [
	^ methodGroups flatCollect: [ :grp | grp itemsProvider currentItems ]
]

{ #category : #accessing }
GtCoderMethodsGroupedListElement >> navigationModel [
	^ navigationModel
]

{ #category : #accessing }
GtCoderMethodsGroupedListElement >> navigationModel: anObject [
	navigationModel == anObject
		ifTrue: [ ^ self ].

	self unsubscribeFromNavigationModel.
	navigationModel := anObject.
	self subscribeToNavigationModel.
	
	self updateMethodList
]

{ #category : #'event handling - selection' }
GtCoderMethodsGroupedListElement >> onMethodSelected: anAnnouncement [
	
]

{ #category : #'event handling - selection' }
GtCoderMethodsGroupedListElement >> onMethodsListSelectionChanged [
	| theIndices allSelectedItems |
	theIndices := self selectedIndices ifEmpty: [ ^ self ].
	(theIndices first between: 1 and: self viewModel entityCount)
		ifFalse: [ ^ self ].
	(theIndices last between: 1 and: self viewModel entityCount)
		ifFalse: [ ^ self ].

	allSelectedItems := self selectedItems.
	allSelectedItems ifEmpty: [ ^ self ].
	allSelectedItems size = 1
		ifTrue: [ self navigationModel selectMethod: allSelectedItems anyOne ]
		ifFalse: [ self navigationModel selectMethods: allSelectedItems ]
]

{ #category : #'event handling - selection' }
GtCoderMethodsGroupedListElement >> onMethodsSelected: anAnnouncement [
	
]

{ #category : #'event handling' }
GtCoderMethodsGroupedListElement >> onMethodsToShowChanged: anAnnouncement [
	self updateMethodList
]

{ #category : #'private - context menu' }
GtCoderMethodsGroupedListElement >> pushDownMethodSubmenuFor: aMethod [
	| submenu |
	submenu := BrMenuExplicit new.

	submenu
		stencil: [ :anExplicitMenu | 
			| aViewModel |
			aViewModel := GtRefactoringsWithConfirmationViewModel new
					refactoringTitle: 'Push down';
					targetName: ('{1}>>#{2}'
							format: {aMethod methodClass.
									aMethod selector});
					confirmationLabel: ('Push down {1}' format: {aMethod selector});
					refactoringWithConfirmation: [ GtRBPushDownMethodRefactoring
							pushDown: {aMethod selector}
							from: (self
									forPharo12AndNewer: [ aMethod methodClass name ]
									forPharo11: [ aMethod methodClass ]) ];
					afterAppliedBlock: [ BlTaskAction enqueueElement: self action: [ anExplicitMenu hideAll ] ];
					menuModel: anExplicitMenu;
					anchorElement: self.
			GtRefactoringsPreviewWithConfirmationElement new
				refactoringsViewModel: aViewModel;
				beContextMenuElement;
				bePinnable: anExplicitMenu ].

	^ submenu
]

{ #category : #'private - context menu' }
GtCoderMethodsGroupedListElement >> pushDownSeveralMethodsSubmenuFor: aCollectionOfMethods [
	| submenu |
	submenu := BrMenuExplicit new.

	submenu
		stencil: [ :anExplicitMenu | 
			| aViewModel |
			aViewModel := GtRefactoringsWithConfirmationViewModel new
					refactoringTitle: 'Push down';
					targetName: ('{1} methods' format: {aCollectionOfMethods size});
					confirmationLabel: ('Push down {1} methods' format: {aCollectionOfMethods size});
					refactoringsWithConfirmation: [ | aGroupByClass aModel aCollectionOfRefactorings |
						aGroupByClass := aCollectionOfMethods groupedBy: #methodClass.
						aModel := Smalltalk createRbNamespace
								onEnvironment: GtRBPushDownMethodRefactoring new defaultEnvironment.
						aCollectionOfRefactorings := aGroupByClass
								collect: [ :someMethods | 
									GtRBPushDownMethodRefactoring new
										model: aModel;
										pushDown: (someMethods collect: #selector)
											from: (self
													forPharo12AndNewer: [ someMethods anyOne methodClass name ]
													forPharo11: [ someMethods anyOne methodClass ]) ]
								as: Array.
						aModel name: ('Push down {1} methods' format: {aCollectionOfMethods size}).
						aCollectionOfRefactorings ];
					afterAppliedBlock: [ BlTaskAction enqueueElement: self action: [ anExplicitMenu hideAll ] ];
					menuModel: anExplicitMenu;
					anchorElement: self.
			GtRefactoringsPreviewWithConfirmationElement new
				refactoringsViewModel: aViewModel;
				beContextMenuElement;
				bePinnable: anExplicitMenu ].

	^ submenu
]

{ #category : #'private - context menu' }
GtCoderMethodsGroupedListElement >> pushUpMethodSubmenuFor: aMethod [
	| submenu |
	submenu := BrMenuExplicit new.

	submenu
		stencil: [ :anExplicitMenu | 
			| aViewModel |
			aViewModel := GtRefactoringsWithConfirmationViewModel new
					refactoringTitle: 'Push up';
					targetName: ('{1}>>#{2}'
							format: {aMethod methodClass.
									aMethod selector});
					confirmationLabel: ('Push up {1}' format: {aMethod selector});
					refactoringWithConfirmation: [ GtPushUpMethodRefactoring pullUp: {aMethod selector} from: aMethod methodClass ];
					afterAppliedBlock: [ BlTaskAction enqueueElement: self action: [ anExplicitMenu hideAll ] ];
					menuModel: anExplicitMenu;
					anchorElement: self.
			GtRefactoringsPreviewWithConfirmationElement new
				refactoringsViewModel: aViewModel;
				beContextMenuElement;
				bePinnable: anExplicitMenu ].

	^ submenu
]

{ #category : #'private - context menu' }
GtCoderMethodsGroupedListElement >> pushUpSeveralMethodsSubmenuFor: aCollectionOfMethods [
	| submenu |
	submenu := BrMenuExplicit new.

	submenu
		stencil: [ :anExplicitMenu | 
			| aViewModel |
			aViewModel := GtRefactoringsWithConfirmationViewModel new
					refactoringTitle: 'Push up';
					targetName: ('{1} methods' format: {aCollectionOfMethods size});
					confirmationLabel: ('Push up {1} methods' format: {aCollectionOfMethods size});
					refactoringsWithConfirmation: [ | aGroupByClass aModel aCollectionOfRefactorings |
						aGroupByClass := aCollectionOfMethods groupedBy: #methodClass.
						aModel := Smalltalk createRbNamespace
								onEnvironment: GtPushUpMethodRefactoring new defaultEnvironment.
						aCollectionOfRefactorings := aGroupByClass
								collect: [ :someMethods | 
									GtPushUpMethodRefactoring new
										model: aModel;
										pullUp: (someMethods collect: #selector)
											from: someMethods anyOne methodClass ]
								as: Array.
						aModel name: ('Push up {1} methods' format: {aCollectionOfMethods size}).
						aCollectionOfRefactorings ];
					afterAppliedBlock: [ BlTaskAction enqueueElement: self action: [ anExplicitMenu hideAll ] ];
					menuModel: anExplicitMenu;
					anchorElement: self.
			GtRefactoringsPreviewWithConfirmationElement new
				refactoringsViewModel: aViewModel;
				beContextMenuElement;
				bePinnable: anExplicitMenu ].

	^ submenu
]

{ #category : #'private - context menu' }
GtCoderMethodsGroupedListElement >> removeMethodSubmenuFor: aMethod [
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
						text: ('Remove ' , aMethod selector) asRopedText).
			element
				addChild: (BrAsyncWidget new
						fitContent;
						stencil: [ | pane references |
							pane := BrVerticalPane new.
							pane fitContent.
							references := (GtPharoIndex current sendersOf: aMethod selector) size.
							references > 0
								ifTrue: [ pane
										addChild: (BrLabel new
												margin: (BlInsets left: 10 right: 10);
												aptitude: BrGlamorousLabelAptitude new glamorousRegularFont thin;
												text: (references printString , ' reference'
														, (references > 1 ifTrue: [ 's' ] ifFalse: [ '' ])) asRopedText) ].
							pane ]).
			change := RBRemoveMethodChange
					remove: aMethod selector
					from: aMethod methodClass.
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
GtCoderMethodsGroupedListElement >> removeSeveralMethodsSubmenuFor: aCollectionOfMethods [
	| submenu |
	submenu := BrMenuExplicit new.
	^ submenu
		stencil: [ | element changes change button |
			element := BrVerticalPane new fitContent.
			element
				addChild: (BrLabel new
						margin: (BlInsets
								top: 10
								bottom: 0
								left: 10
								right: 10);
						aptitude: BrGlamorousLabelAptitude new glamorousRegularFont;
						text: ('Remove {1} methods' format: {aCollectionOfMethods size}) asRopedText).
			element
				addChild: (BrAsyncWidget new
						fitContent;
						stencil: [ | pane references |
							pane := BrVerticalPane new.
							pane fitContent.
							references := aCollectionOfMethods
									inject: 0
									into: [ :sum :method | sum + (GtPharoIndex current sendersOf: method selector) size ].
							references > 0
								ifTrue: [ pane
										addChild: (BrLabel new
												margin: (BlInsets left: 10 right: 10);
												aptitude: BrGlamorousLabelAptitude new glamorousRegularFont thin;
												text: (references printString , ' reference'
														, (references > 1 ifTrue: [ 's' ] ifFalse: [ '' ])) asRopedText) ].
							pane ]).
		
							
			changes := aCollectionOfMethods collect: [ :eachMethod | 
				RBRemoveMethodChange
					remove: eachMethod selector
					from: eachMethod methodClass ].
					
			change := RBCompositeRefactoryChange new
				name: ('Remove {1} methods' format: { aCollectionOfMethods size });
				changes: changes;
				yourself.
					
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
GtCoderMethodsGroupedListElement >> renameMethodSubmenuFor: aMethod [
	| submenu |
	submenu := BrMenuExplicit new.

	submenu
		stencil: [ :anExplicitMenu | 
			| aViewModel |
			aViewModel := GtRefactoringsWithInputViewModel new
					refactoringTitle: 'Rename method';
					targetName: ('{1}>>#{2}'
							format: {aMethod methodClass.
									aMethod selector});
					inputLabel: 'New method name:';
					initialText: aMethod selector;
					refactoringWithInput: [ :anInput | 
						GtRBRenameMethodRefactoring
							renameMethod: aMethod selector
							in: aMethod methodClass
							to: anInput
							permutation: (1 to: aMethod selector numArgs) ];
					afterAppliedBlock: [ BlTaskAction enqueueElement: self action: [ anExplicitMenu hideAll ] ];
					menuModel: anExplicitMenu;
					anchorElement: self.
			GtRefactoringsPreviewWithInputElement new
				refactoringsViewModel: aViewModel;
				beContextMenuElement;
				bePinnable: anExplicitMenu ].

	^ submenu
]

{ #category : #accessing }
GtCoderMethodsGroupedListElement >> selectedClass [
	^ navigationModel selectedClass
]

{ #category : #'private - context menu' }
GtCoderMethodsGroupedListElement >> selectedMethod [
	^ navigationModel selectedMethod
]

{ #category : #'private - subscriptions' }
GtCoderMethodsGroupedListElement >> subscribeToNavigationModel [
	| subscriptions |

	subscriptions := {
		GtCoderNavigationMethodsToShowChanged -> #onMethodsToShowChanged:.
		GtCoderNavigationMethodSelected -> #onMethodSelected:.
		GtCoderNavigationMethodsSelected -> #onMethodsSelected:.
	}.

	subscriptions
		do: [ :sub | 
			navigationModel weak
				when: sub key
				send: sub value
				to: self ]
]

{ #category : #'private - subscriptions' }
GtCoderMethodsGroupedListElement >> unsubscribeFromNavigationModel [
	navigationModel ifNotNil: [ :aModel | aModel unsubscribe: self ]
]

{ #category : #'updating lists' }
GtCoderMethodsGroupedListElement >> updateMethodList [
	self
		inUIProcessDo: [ self navigationModel
				ifNotNil: [ self updateMethodListWith: self navigationModel methodsToShow ] ]
]

{ #category : #'updating lists' }
GtCoderMethodsGroupedListElement >> updateMethodListWith: aCollectionOfCompiledMethods [
	| instMethStream classMethStream instanceMethods classMethods |
	self deselectAll.

	instanceMethods := aCollectionOfCompiledMethods
			select: [ :each | each methodClass isInstanceSide ].

	classMethods := aCollectionOfCompiledMethods
			select: [ :each | each methodClass isClassSide ].

	instMethStream := instanceMethods asSortedCollection: GtMethodsSortFunction new.

	classMethStream := classMethods asSortedCollection: GtMethodsSortFunction new.

	methodGroups
		with: {instMethStream.
				classMethStream}
		do: [ :grp :str | grp items: str ].

	self groups: methodGroups
]
