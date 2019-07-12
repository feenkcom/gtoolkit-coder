Class {
	#name : #GtCoderAddOns,
	#superclass : #Object,
	#instVars : [
		'contextActions',
		'mainActions',
		'modified',
		'shortcuts'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #actions }
GtCoderAddOns >> addContextAction: aString icon: anIcon action: aBlock [
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
GtCoderAddOns >> addShortcut: aBlShortcut [
	modified add: #shortcuts.
	1 to: shortcuts size do: [ :i | 
		(shortcuts at: i) combination = aBlShortcut combination
			ifTrue: [ ^ shortcuts at: i put: aBlShortcut ] ].
	shortcuts add: aBlShortcut
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
	modified := Set new
]

{ #category : #accessing }
GtCoderAddOns >> mainActions [
	^ mainActions
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
	1 to: shortcuts size do: [ :i | 
		(shortcuts at: i) combination = aBlShortcut combination
			ifTrue: [ shortcuts removeAt: i.
				modified add: #shortcuts ] ]
]

{ #category : #shortcuts }
GtCoderAddOns >> removeShortcutsMatching: aBlock [
	shortcuts removeAllSuchThat: aBlock
]

{ #category : #shortcuts }
GtCoderAddOns >> shortcuts [
	^ shortcuts
]
