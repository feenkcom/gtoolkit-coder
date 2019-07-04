Class {
	#name : #GtSourceCoderAddOns,
	#superclass : #Object,
	#instVars : [
		'contextActions',
		'mainActions',
		'modified',
		'shortcuts',
		'stylers'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #actions }
GtSourceCoderAddOns >> addContextAction: aString icon: anIcon action: aBlock [
	| newAction index |
	newAction := GtCoderAction new
		title: aString;
		icon: anIcon;
		action: aBlock.
	index := (1 to: contextActions size) detect: [ :i | (contextActions at: i) title = aString ] ifNone: [ 0 ].
	index = 0
		ifTrue: [ contextActions add: newAction ]
		ifFalse: [ contextActions at: index put: newAction ].
	modified add: #contextActions
]

{ #category : #actions }
GtSourceCoderAddOns >> addDropDownAction: aString icon: anIcon stencil: aBlock [
	| newAction |
	newAction := GtCoderDropDownAction new
		title: aString;
		icon: anIcon;
		action: aBlock.
	mainActions add: newAction.
	modified add: #mainActions
]

{ #category : #actions }
GtSourceCoderAddOns >> addMainAction: aString icon: anIcon action: aBlock [
	| newAction index |
	newAction := GtCoderAction new
		title: aString;
		icon: anIcon;
		action: aBlock.
	index := (1 to: mainActions size) detect: [ :i | (mainActions at: i) title = aString ] ifNone: [ 0 ].
	index = 0
		ifTrue: [ mainActions add: newAction ]
		ifFalse: [ mainActions at: index put: newAction ].
	modified add: #mainActions
]

{ #category : #shortcuts }
GtSourceCoderAddOns >> addShortcut: aBlShortcut [
	modified add: #shortcuts.
	1 to: shortcuts size do: [ :i | 
		(shortcuts at: i) combination = aBlShortcut combination
			ifTrue: [ ^ shortcuts at: i put: aBlShortcut ] ].
	shortcuts add: aBlShortcut
]

{ #category : #stylers }
GtSourceCoderAddOns >> addStyler: aStyler [
	(stylers anySatisfy: [ :each | each class = aStyler class ])
		ifTrue: [ ^ self ].
	stylers add: aStyler.
	modified add: #stylers
]

{ #category : #changes }
GtSourceCoderAddOns >> changesDo: aBlock [
	modified do: aBlock
]

{ #category : #changes }
GtSourceCoderAddOns >> clearChanges [
	modified := Set new
]

{ #category : #accessing }
GtSourceCoderAddOns >> contextActions [
	^ contextActions
]

{ #category : #ui }
GtSourceCoderAddOns >> gtViewContextActionsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Context actions' translated;
		priority: 25;
		items: [ self contextActions ];
		column: 'Title' item: [ :anAction | anAction title ] format: [ :title | title ifNil: [''] ];
		column: 'Action' item: [ :anAction | anAction action ]
]

{ #category : #ui }
GtSourceCoderAddOns >> gtViewKeybindingsFor: aView [
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
GtSourceCoderAddOns >> gtViewMainActionsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Main actions' translated;
		priority: 20;
		items: [ self mainActions ];
		column: 'Title' item: [ :anAction | anAction title ] format: [ :title | title ifNil: [''] ];
		column: 'Action' item: [ :anAction | anAction action ]
]

{ #category : #ui }
GtSourceCoderAddOns >> gtViewStylersFor: aView [
	<gtView>
	^ aView list
		title: 'Stylers' translated;
		priority: 30;
		items: [ self stylers ]
]

{ #category : #'initialize-release' }
GtSourceCoderAddOns >> initialize [
	super initialize.
	contextActions := OrderedCollection new.
	mainActions := OrderedCollection new.
	stylers := OrderedCollection new.
	shortcuts := OrderedCollection new.
	modified := Set new
]

{ #category : #accessing }
GtSourceCoderAddOns >> mainActions [
	^ mainActions
]

{ #category : #actions }
GtSourceCoderAddOns >> removeContextAction: aString [
	| index |
	index := (1 to: contextActions size) detect: [ :i | (contextActions at: i) title = aString ] ifNone: [ 0 ].
	index = 0
		ifTrue: [ ^ self ].
	contextActions removeAt: index.
	modified add: #contextActions
]

{ #category : #actions }
GtSourceCoderAddOns >> removeMainAction: aString [
	| index |
	index := (1 to: mainActions size) detect: [ :i | (mainActions at: i) title = aString ] ifNone: [ 0 ].
	index = 0
		ifTrue: [ ^ self ].
	mainActions removeAt: index.
	modified add: #mainActions
]

{ #category : #shortcuts }
GtSourceCoderAddOns >> removeShortcut: aBlShortcut [
	1 to: shortcuts size do: [ :i | 
		(shortcuts at: i) combination = aBlShortcut combination
			ifTrue: [ shortcuts removeAt: i.
				modified add: #shortcuts ] ]
]

{ #category : #shortcuts }
GtSourceCoderAddOns >> removeShortcutsMatching: aBlock [
	shortcuts removeAllSuchThat: aBlock
]

{ #category : #stylers }
GtSourceCoderAddOns >> removeStylerOfType: aClass [
	| styler |
	styler := stylers detect: [ :each | each isKindOf: aClass ] ifNone: [  ].
	styler isNil
		ifTrue: [ ^ self ].
	stylers remove: styler.
	modified add: #stylers
]

{ #category : #shortcuts }
GtSourceCoderAddOns >> shortcuts [
	^ shortcuts
]

{ #category : #accessing }
GtSourceCoderAddOns >> stylers [
	^ stylers
]
