Class {
	#name : #GtCoderAddOns,
	#superclass : #Object,
	#instVars : [
		'contextActions',
		'mainActions',
		'contextMenuActions',
		'shortcuts',
		'updateRequested'
	],
	#category : #'GToolkit-Coder-Coders - Addons'
}

{ #category : #actions }
GtCoderAddOns >> addContextAction: aTitleString icon: anIcon action: aBlock [
	self
		addContextAction: aTitleString
		icon: anIcon
		action: aBlock
		id: nil
]

{ #category : #actions }
GtCoderAddOns >> addContextAction: aTitleString icon: anIcon action: aBlock id: aBlElementId [
	self
		updateActionList: #contextActions
		withAction: (GtCoderAction new
			title: aTitleString;
			icon: anIcon;
			action: aBlock;
			id: aBlElementId)
		onlyNew: true
]

{ #category : #actions }
GtCoderAddOns >> addContextMenuItem: aString action: aBlock [
	^ self
		addContextMenuItem: aString
		hover: nil
		leave: nil
		action: aBlock
]

{ #category : #actions }
GtCoderAddOns >> addContextMenuItem: aString hover: hoverBlock leave: leaveBlock action: aBlock [
	self
		addContextMenuItem: aString
		hover: hoverBlock
		leave: leaveBlock
		action: aBlock
		id: nil
]

{ #category : #actions }
GtCoderAddOns >> addContextMenuItem: aString hover: hoverBlock leave: leaveBlock action: aBlock id: aSymbol [
	| newAction |
	newAction := GtCoderContextMenuAction new
		title: aString;
		action: aBlock;
		hoverAction: hoverBlock;
		leaveAction: leaveBlock;
		name: aSymbol.
	contextMenuActions add: newAction.
	modified add: #contextMenuActions
]

{ #category : #actions }
GtCoderAddOns >> addDropDownAction: aString icon: anIcon stencil: aBlock [
	| newAction |
	newAction := GtCoderDropDownAction new
		title: aString;
		icon: anIcon;
		action: aBlock.
	mainActions add: newAction.
	modified add: #mainActions
]

{ #category : #actions }
GtCoderAddOns >> addDropDownWithPreviewAction: aString icon: anIcon action: actionBlock stencil: stencilBlock [
	| newAction |
	newAction := GtCoderDropDownWithPreviewAction new
		title: aString;
		icon: anIcon;
		changeAction: actionBlock;
		changeStencil: stencilBlock.
	mainActions add: newAction.
	modified add: #mainActions
]

{ #category : #actions }
GtCoderAddOns >> addMainAction: aGtCoderAction [
	self
		updateActionList: #mainActions
		withAction: aGtCoderAction
		onlyNew: true
]

{ #category : #actions }
GtCoderAddOns >> addMainAction: aString icon: anIcon action: aBlock [
	self
		updateActionList: #mainActions
		title: aString
		icon: anIcon
		action: aBlock
		onlyNew: true
]

{ #category : #actions }
GtCoderAddOns >> addMainAction: aTitleString icon: anIcon action: aBlock id: aNameSymbol [
	self
		updateActionList: #mainActions
		withAction: (GtCoderAction new
			title: aTitleString;
			icon: anIcon;
			action: aBlock;
			id: aNameSymbol)
		onlyNew: true
]

{ #category : #actions }
GtCoderAddOns >> addOrUpdateContextAction: aString icon: anIcon action: aBlock [
	self
		updateActionList: #contextActions
		title: aString
		icon: anIcon
		action: aBlock
		onlyNew: false
]

{ #category : #actions }
GtCoderAddOns >> addOrUpdateMainAction: aString icon: anIcon action: aBlock [
	self
		updateActionList: #mainActions
		title: aString
		icon: anIcon
		action: aBlock
		onlyNew: false
]

{ #category : #private }
GtCoderAddOns >> addOrUpdateShortcut: aBlShortcut to: aCollection [
	1 to: aCollection size do: [ :i | 
		(aCollection at: i) combination = aBlShortcut combination
			ifTrue: [ ^ aCollection at: i put: aBlShortcut ] ].
	aCollection add: aBlShortcut
]

{ #category : #shortcuts }
GtCoderAddOns >> addShortcut: aBlShortcut [
	modified add: #shortcuts.
	self addOrUpdateShortcut: aBlShortcut to: shortcuts
]

{ #category : #changes }
GtCoderAddOns >> changesDo: aBlock [
	modified do: aBlock
]

{ #category : #changes }
GtCoderAddOns >> clearChanges [
	modified := Set new
]

{ #category : #accessing }
GtCoderAddOns >> contextActions [
	^ contextActions
]

{ #category : #accessing }
GtCoderAddOns >> contextActions: anObject [
	contextActions := anObject
]

{ #category : #accessing }
GtCoderAddOns >> contextMenuActions [
	^ contextMenuActions
]

{ #category : #accessing }
GtCoderAddOns >> contextMenuActions: anObject [
	contextMenuActions := anObject
]

{ #category : #changes }
GtCoderAddOns >> differenceWith: aGtCoderAddOns [
	^ Array streamContents: [ :aStream | self differenceWith: aGtCoderAddOns on: aStream ]
]

{ #category : #changes }
GtCoderAddOns >> differenceWith: aGtCoderAddOns on: aStream [
	self
		assert: [ self class = aGtCoderAddOns class ]
		description: [ 'Coder AddOns type must be identical to compute the difference' ].
		
	self mainActions = aGtCoderAddOns mainActions
		ifFalse: [ aStream nextPut: GtCoderAddOnsMainActionsDifference new ].
		
	self contextActions = aGtCoderAddOns contextActions
		ifFalse: [ aStream nextPut: GtCoderAddOnsContextActionsDifference new ].
		
	self contextMenuActions = aGtCoderAddOns contextMenuActions
		ifFalse: [ aStream nextPut: GtCoderAddOnsContextMenuDifference new ].
		
	self shortcuts = aGtCoderAddOns shortcuts
		ifFalse: [ aStream nextPut: GtCoderAddOnsShortcutsDifference new ].
]

{ #category : #ui }
GtCoderAddOns >> gtViewContextActionsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Context actions' translated;
		priority: 25;
		items: [ self contextActions ];
		column: 'Title'
			item: [ :anAction | anAction title ]
			text: [ :title | title ifNil: [ '' ] ];
		column: 'Action' item: [ :anAction | anAction action ]
]

{ #category : #ui }
GtCoderAddOns >> gtViewKeybindingsFor: aView [
	<gtView>
	self shortcuts ifEmpty: [ ^ aView empty ].
	^ aView columnedList
		title: 'Shortcuts' translated;
		priority: 10;
		items: [ self shortcuts asArray ];
		column: 'Name' item: [ :each | each name ifNil: [ each gtDisplayString ] ];
		column: 'Combination' item: [ :each | each combination gtDisplayString ]
]

{ #category : #ui }
GtCoderAddOns >> gtViewMainActionsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Main actions' translated;
		priority: 20;
		items: [ self mainActions ];
		column: 'Title'
			item: [ :anAction | anAction title ]
			text: [ :title | title ifNil: [ '' ] ];
		column: 'Action' 
			item: [ :anAction | anAction action ]
			weight: 3
]

{ #category : #'initialize-release' }
GtCoderAddOns >> initialize [
	super initialize.
	contextActions := OrderedCollection new.
	mainActions := OrderedCollection new.
	contextMenuActions := OrderedCollection new.
	shortcuts := OrderedCollection new.
	modified := Set new.
	updateRequested := true
]

{ #category : #accessing }
GtCoderAddOns >> mainActions [
	^ mainActions
]

{ #category : #accessing }
GtCoderAddOns >> mainActions: anObject [
	mainActions := anObject
]

{ #category : #changes }
GtCoderAddOns >> markAsUpdated [
	updateRequested := false
]

{ #category : #copying }
GtCoderAddOns >> postCopy [
	super postCopy.
	contextActions := contextActions copy.
	mainActions := mainActions copy.
	contextMenuActions := contextMenuActions copy.
	modified := modified copy.
	shortcuts := shortcuts copy
]

{ #category : #actions }
GtCoderAddOns >> removeContextAction: aString [
	| index |
	index := (1 to: contextActions size) detect: [ :i | (contextActions at: i) title = aString ] ifNone: [ 0 ].
	index = 0
		ifTrue: [ ^ self ].
	contextActions removeAt: index.
	modified add: #contextActions
]

{ #category : #actions }
GtCoderAddOns >> removeMainAction: aString [
	| index |
	index := (1 to: mainActions size) detect: [ :i | (mainActions at: i) title = aString ] ifNone: [ 0 ].
	index = 0
		ifTrue: [ ^ self ].
	mainActions removeAt: index.
	modified add: #mainActions
]

{ #category : #changes }
GtCoderAddOns >> requestUpdate [
	"Mark coder addons as potentially needed to be updated"
	
	updateRequested := true
]

{ #category : #shortcuts }
GtCoderAddOns >> shortcuts [
	^ shortcuts
]

{ #category : #accessing }
GtCoderAddOns >> shortcuts: anObject [
	shortcuts := anObject
]

{ #category : #testing }
GtCoderAddOns >> shouldBeUpdated [
	"Return true if addons should be updated, false otherwise"
	<return: #Boolean>

	^ updateRequested
]

{ #category : #private }
GtCoderAddOns >> updateActionList: listSymbol title: aString icon: anIcon action: aBlock onlyNew: aBoolean [
	self
		updateActionList: listSymbol
		withAction: (GtCoderAction new
			title: aString;
			icon: anIcon;
			action: aBlock)
		onlyNew: aBoolean
]

{ #category : #private }
GtCoderAddOns >> updateActionList: listSymbol withAction: aGtCoderAction onlyNew: aBoolean [
	| index actions |

	actions := self perform: listSymbol.
	index := (1 to: actions size)
		detect: [ :i | (actions at: i) title = aGtCoderAction title ]
		ifNone: [ 0 ].

	(aBoolean and: [ index > 0 ])
		ifTrue: [ ^ self ].

	index = 0
		ifTrue: [ actions add: aGtCoderAction ]
		ifFalse: [ actions at: index put: aGtCoderAction ].
	modified add: listSymbol
]
