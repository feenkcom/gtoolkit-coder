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
				+ (BrGlamorousWithContextMenuAptitude
						content: [ GtCoderNavigationContextMenuContent new
								items: (self methodListContextMenuItemsFor: (aLabel userData at: #method)) ]).

	aLabel addEventHandler: self createMethodDragHandler.

	^ aLabel
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

{ #category : #'private - context menu' }
GtCoderMethodsGroupedListElement >> methodListContextMenuItemsFor: item [
	^ {(self createLabel: 'Browse implementors' description: item selector)
			-> [ :elem | self browseImplementorsOf: item selector ].
		(self createLabel: 'Browse hierarachy implementors' description: item selector)
			-> [ :elem | self browseHierarchyImplementorsOf: item selector ].
		(self createLabel: 'Browse references' description: item selector)
			-> [ :elem | self browseReferencesOf: item selector ].
		(self createLabel: 'Browse hierarchy references' description: item selector)
			-> [ :elem | self browseHierarchyReferencesOf: item selector ].
		(self createLabel: 'Push up method' description: item selector)
			-> [ :elem | self pushUpMethod: item selector inElement: elem ].
		(self createLabel: 'Push down method' description: item selector)
			-> [ :elem | self pushDownMethod: item selector inElement: elem ].
		(self createLabel: 'Rename message' description: item selector)
			-> [ :elem | self renameMethod: item selector inElement: elem ].
		(self createLabel: 'Remove method' description: item selector)
			-> [ :elem | self removeMethod: item selector inElement: elem ]}
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
		cancelSelector: #updateProtocolsList
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
		cancelSelector: #updateProtocolsList
]

{ #category : #'private - actions' }
GtCoderMethodsGroupedListElement >> removeMethod: aSelector inElement: elem [
	| change button |
	change := RBRemoveMethodChange remove: aSelector from: self selectedClass.
	button := GtPreviewChangeButton new
			icon: BrGlamorousVectorIcons remove;
			label: 'Remove';
			changeAction: [ change gtExecuteWithUndo ];
			changeStencil: [ GtPharoRemoveMethodPreviewStencil new
					selectorToRemove: aSelector;
					isEmptyMethod: false;
					anElement: self;
					create ].
	button
		when: GtRefactoringsAppliedEvent
		do: [ :anEvent | elem removeChild: anEvent currentTarget ].
	^ elem addChild: button as: #preview
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
					cancelSelector: #updateProtocolsList ];
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
	self navigationModel ifNil: [ ^ self ].
	self updateMethodListWith: self navigationModel methodsToShow
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
