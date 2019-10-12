Class {
	#name : #GtCoderAddOns,
	#superclass : #Object,
	#instVars : [
		'contextActions',
		'mainActions',
		'modified',
		'shortcuts',
		'collapsedShortcuts'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #shortcuts }
GtCoderAddOns >> addCollapsedShortcut: aBlShortcut [
	modified add: #collapsedShortcuts.
	self addOrUpdateShortcut: aBlShortcut to: collapsedShortcuts
]

{ #category : #actions }
GtCoderAddOns >> addContextAction: aString icon: anIcon action: aBlock [
	self
		updateActionList: #contextActions
		title: aString
		icon: anIcon
		action: aBlock
		onlyNew: true
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
GtCoderAddOns >> addMainAction: aString icon: anIcon action: aBlock [
	self
		updateActionList: #mainActions
		title: aString
		icon: anIcon
		action: aBlock
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

{ #category : #shortcuts }
GtCoderAddOns >> collapsedShortcuts [
	^ collapsedShortcuts
]

{ #category : #accessing }
GtCoderAddOns >> contextActions [
	^ contextActions
]

{ #category : #ui }
GtCoderAddOns >> gtViewContextActionsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Context actions' translated;
		priority: 25;
		items: [ self contextActions ];
		column: 'Title' item: [ :anAction | anAction title ] format: [ :title | title ifNil: [''] ];
		column: 'Action' item: [ :anAction | anAction action ]
]

{ #category : #ui }
GtCoderAddOns >> gtViewKeybindingsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Key bindings' translated;
		priority: 15;
		items: [ self shortcuts ];
		column: 'Shortcut' item: [ :aShortcut | aShortcut combination ] width: 200;
		column: 'Name' item: [ :aShortcut | aShortcut name ifNil: [ '' ] ];
		column: 'Action' item: [ :aShortcut | aShortcut action ];
		column: 'Description' item: [ :aShortcut | aShortcut description ifNil: [ '' ] ]
]

{ #category : #ui }
GtCoderAddOns >> gtViewMainActionsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Main actions' translated;
		priority: 20;
		items: [ self mainActions ];
		column: 'Title' item: [ :anAction | anAction title ] format: [ :title | title ifNil: [''] ];
		column: 'Action' item: [ :anAction | anAction action ]
]

{ #category : #'initialize-release' }
GtCoderAddOns >> initialize [
	super initialize.
	contextActions := OrderedCollection new.
	mainActions := OrderedCollection new.
	shortcuts := OrderedCollection new.
	collapsedShortcuts := OrderedCollection new.
	modified := Set new
]

{ #category : #accessing }
GtCoderAddOns >> mainActions [
	^ mainActions
]

{ #category : #copying }
GtCoderAddOns >> postCopy [
	super postCopy.
	contextActions := contextActions copy.
	mainActions := mainActions copy.
	modified := modified copy.
	shortcuts := shortcuts copy.
	collapsedShortcuts := collapsedShortcuts copy
]

{ #category : #shortcuts }
GtCoderAddOns >> removeCollapsedShortcut: aBlShortcut [
	(self removeShortcut: aBlShortcut from: collapsedShortcuts)
		ifTrue: [ modified add: #collapsedShortcuts ]
]

{ #category : #shortcuts }
GtCoderAddOns >> removeCollapsedShortcutsMatching: aBlock [
	| originalSize |
	originalSize := collapsedShortcuts size.
	collapsedShortcuts removeAllSuchThat: aBlock.
	originalSize > collapsedShortcuts size
		ifTrue: [ modified add: #collapsedShortcuts ]
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

{ #category : #shortcuts }
GtCoderAddOns >> removeShortcut: aBlShortcut [
	(self removeShortcut: aBlShortcut from: shortcuts)
		ifTrue: [ modified add: #shortcuts ]
]

{ #category : #private }
GtCoderAddOns >> removeShortcut: aBlShortcut from: aCollection [
	| changed |
	changed := false.
	shortcuts size to: 1 by: -1 do: [ :i | 
		(shortcuts at: i) combination = aBlShortcut combination
			ifTrue: [ shortcuts removeAt: i.
				changed := true ] ].
	^ changed
]

{ #category : #shortcuts }
GtCoderAddOns >> removeShortcutsMatching: aBlock [
	| originalSize |
	originalSize := shortcuts size.
	shortcuts removeAllSuchThat: aBlock.
	originalSize > shortcuts size
		ifTrue: [ modified add: #shortcuts ]
]

{ #category : #shortcuts }
GtCoderAddOns >> shortcuts [
	^ shortcuts
]

{ #category : #private }
GtCoderAddOns >> updateActionList: listSymbol title: aString icon: anIcon action: aBlock onlyNew: aBoolean [
	| newAction index actions |
	actions := self perform: listSymbol.
	index := (1 to: actions size)
		detect: [ :i | (actions at: i) title = aString ]
		ifNone: [ 0 ].
	(aBoolean and: [ index > 0 ])
		ifTrue: [ ^ self ].
	newAction := GtCoderAction new
		title: aString;
		icon: anIcon;
		action: aBlock.
	index = 0
		ifTrue: [ actions add: newAction ]
		ifFalse: [ actions at: index put: newAction ].
	modified add: listSymbol
]
