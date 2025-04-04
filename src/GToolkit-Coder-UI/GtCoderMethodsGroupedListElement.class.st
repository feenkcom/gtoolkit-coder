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
	self phlow
		spawnObject: (GtSearchMethodsInClassFilter forClass: self selectedClass) withSuperclasses
				withSubclasses & aSymbol gtImplementors
]

{ #category : #'private - actions' }
GtCoderMethodsGroupedListElement >> browseHierarchyReferencesOf: aSymbol [
	self phlow
		spawnObject: (GtSearchMethodsInClassFilter forClass: self selectedClass) withSuperclasses
				withSubclasses & aSymbol gtSenders
]

{ #category : #'private - actions' }
GtCoderMethodsGroupedListElement >> browseImplementorsOf: aSymbol [
	self phlow spawnObject: (GtSearchImplementorsFilter selector: aSymbol)
]

{ #category : #'private - actions' }
GtCoderMethodsGroupedListElement >> browseReferencesOf: aSymbol [
	self phlow spawnObject: (GtSearchReferencesFilter literal: aSymbol) 
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
		aptitude: BrGlamorousLabelAptitude + BrGlamorousListItemAptitude
				+ (BrGlamorousWithExplicitContextMenuAptitude
						menu: [ self contextMenuFor: (aLabel userData at: #method) in: aLabel ]).

	aLabel addEventHandler: self createMethodDragHandler.

	^ aLabel
]

{ #category : #'private - context menu' }
GtCoderMethodsGroupedListElement >> contextMenuFor: item in: anElement [
	| menu |
	menu := BrMenuItems new.
	menu
		addItemLabel: (self createLabel: 'Browse implementors' description: item selector)
		action: [ self browseImplementorsOf: item selector ].
	menu
		addItemLabel: (self createLabel: 'Browse hierarachy implementors' description: item selector)
		action: [ self browseHierarchyImplementorsOf: item selector ].
	menu
		addItemLabel: (self createLabel: 'Browse references' description: item selector)
		action: [ self browseReferencesOf: item selector ].
	menu
		addItemLabel: (self createLabel: 'Browse hierarchy references' description: item selector)
		action: [ self browseHierarchyReferencesOf: item selector ].
	menu
		addItemLabel: (self createLabel: 'Push up method' description: item selector)
		action: [ self pushUpMethod: item selector inElement: anElement ].
	menu
		addItemLabel: (self createLabel: 'Push down method' description: item selector)
		action: [ self pushDownMethod: item selector inElement: anElement ].
	menu
		addItemLabel: (self createLabel: 'Rename message' description: item selector)
		action: [ self renameMethod: item selector inElement: anElement ].
	menu
		addItem: (BrMenuSubmenuItem new
				label: (self createLabel: 'Remove method' description: item selector);
				submenu: (self removeMethodSubmenuFor: item selector)).
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
			BlDragItem new
				sourceElement: aLabelElement;
				domainObject: (aLabelElement userData at: #method);
				stencil: [ :aDragItem | self createDraggedMethodItem: aDragItem ] ]
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
	| theIndices anIndex aSelectedItem |

	theIndices := self selectedIndices ifEmpty: [ ^ self ].
	anIndex := theIndices first.
	(anIndex between: 1 and: self viewModel entityCount)
		ifFalse: [ ^ self ].
	aSelectedItem := (self viewModel entityAt: anIndex) value object.
	self navigationModel selectMethod: aSelectedItem
]

{ #category : #'event handling' }
GtCoderMethodsGroupedListElement >> onMethodsToShowChanged: anAnnouncement [
	self updateMethodList
]

{ #category : #'private - actions' }
GtCoderMethodsGroupedListElement >> pushDownMethod: aSelector inElement: elem [
	| refactoring |
	refactoring := RBPushDownMethodRefactoring
			pushDown: {aSelector}
			from: self selectedClass.
	^ self
		addPreviewButtonFor: refactoring
		to: elem
		cancelSelector: #updateMethodList
]

{ #category : #'private - actions' }
GtCoderMethodsGroupedListElement >> pushUpMethod: aSelector inElement: elem [
	| refactoring |
	refactoring := RBPullUpMethodRefactoring
			pullUp: {aSelector}
			from: self selectedClass.
	^ self
		addPreviewButtonFor: refactoring
		to: elem
		cancelSelector: #updateMethodList
]

{ #category : #'private - context menu' }
GtCoderMethodsGroupedListElement >> removeMethodSubmenuFor: aSelector [
	^ BrMenuExplicit new
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
						text: ('Remove ' , aSelector) asRopedText).
			element
				addChild: (BrAsyncWidget new
						fitContent;
						stencil: [ | pane references |
							pane := BrVerticalPane new.
							pane fitContent.
							references := (GtPharoIndex current sendersOf: aSelector) size.
							references > 0
								ifTrue: [ pane
										addChild: (BrLabel new
												margin: (BlInsets left: 10 right: 10);
												aptitude: BrGlamorousLabelAptitude new glamorousRegularFont thin;
												text: (references printString , ' reference'
														, (references > 1 ifTrue: [ 's' ] ifFalse: [ '' ])) asRopedText) ].
							pane ]).
			change := RBRemoveMethodChange remove: aSelector from: self selectedClass.
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
					action: [ change execute ].
			element addChild: button as: #removeButton.
			element ]
]

{ #category : #'private - actions' }
GtCoderMethodsGroupedListElement >> renameMethod: aSelector inElement: elem [
	| refactoring edit |
	edit := BrEditableLabel new.
	edit
		aptitude: (BrGlamorousEditableLabelAptitude new
				fontSize: 11.9;   "Force the font to match the label font"
				background: Color transparent);
		text: aSelector;
		when: BrEditorAcceptWish
			do: [ :aWish | 
				refactoring := GtRBRenameMethodRefactoring
						renameMethod: aSelector
						in: self selectedClass
						to: aWish text asString
						permutation: (1 to: aSelector numArgs).
				edit switchToLabel.
				self
					addPreviewButtonFor: refactoring
					to: elem
					cancelSelector: #updateMethodList ];
		switchToEditor.
	edit requestFocus.
	elem removeChildren.
	elem addChild: edit
]

{ #category : #accessing }
GtCoderMethodsGroupedListElement >> selectedClass [
	^ navigationModel selectedClass
]

{ #category : #'private - subscriptions' }
GtCoderMethodsGroupedListElement >> subscribeToNavigationModel [
	| subscriptions |

	subscriptions := {
		GtCoderNavigationMethodsToShowChanged -> #onMethodsToShowChanged:.
		GtCoderNavigationMethodSelected -> #onMethodSelected:.
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
