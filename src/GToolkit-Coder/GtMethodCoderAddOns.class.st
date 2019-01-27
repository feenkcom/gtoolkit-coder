Class {
	#name : #GtMethodCoderAddOns,
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
GtMethodCoderAddOns >> addContextAction: aString icon: anIcon action: aBlock [
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
GtMethodCoderAddOns >> addMainAction: aString icon: anIcon action: aBlock [
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
GtMethodCoderAddOns >> addShortcut: aBlShortcut [
	modified add: #shortcuts.
	1 to: shortcuts size do: [ :i | 
		(shortcuts at: i) combination = aBlShortcut combination
			ifTrue: [ ^ shortcuts at: i put: aBlShortcut ] ].
	shortcuts add: aBlShortcut
]

{ #category : #stylers }
GtMethodCoderAddOns >> addStyler: aStyler [
	(stylers anySatisfy: [ :each | each class = aStyler class ])
		ifTrue: [ ^ self ].
	stylers add: aStyler.
	modified add: #stylers
]

{ #category : #changes }
GtMethodCoderAddOns >> changesDo: aBlock [
	modified do: aBlock
]

{ #category : #changes }
GtMethodCoderAddOns >> clearChanges [
	modified := Set new
]

{ #category : #accessing }
GtMethodCoderAddOns >> contextActions [
	^ contextActions
]

{ #category : #ui }
GtMethodCoderAddOns >> gtViewContextActionsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Context actions' translated;
		priority: 25;
		items: [ self contextActions ];
		column: 'Title' item: [ :anAction | anAction title ] format: [ :title | title ifNil: [''] ];
		column: 'Action' item: [ :anAction | anAction action ]
]

{ #category : #ui }
GtMethodCoderAddOns >> gtViewKeybindingsFor: aView [
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
GtMethodCoderAddOns >> gtViewMainActionsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Main actions' translated;
		priority: 20;
		items: [ self mainActions ];
		column: 'Title' item: [ :anAction | anAction title ] format: [ :title | title ifNil: [''] ];
		column: 'Action' item: [ :anAction | anAction action ]
]

{ #category : #ui }
GtMethodCoderAddOns >> gtViewStylersFor: aView [
	<gtView>
	^ aView list
		title: 'Stylers' translated;
		priority: 30;
		items: [ self stylers ]
]

{ #category : #'initialize-release' }
GtMethodCoderAddOns >> initialize [
	super initialize.
	contextActions := OrderedCollection new.
	mainActions := OrderedCollection new.
	stylers := OrderedCollection new.
	shortcuts := OrderedCollection new.
	modified := Set new
]

{ #category : #accessing }
GtMethodCoderAddOns >> mainActions [
	^ mainActions
]

{ #category : #actions }
GtMethodCoderAddOns >> removeContextAction: aString [
	| index |
	index := (1 to: contextActions size) detect: [ :i | (contextActions at: i) title = aString ] ifNone: [ 0 ].
	index = 0
		ifTrue: [ ^ self ].
	contextActions removeAt: index.
	modified add: #contextActions
]

{ #category : #actions }
GtMethodCoderAddOns >> removeMainAction: aString [
	| index |
	index := (1 to: mainActions size) detect: [ :i | (mainActions at: i) title = aString ] ifNone: [ 0 ].
	index = 0
		ifTrue: [ ^ self ].
	mainActions removeAt: index.
	modified add: #mainActions
]

{ #category : #shortcuts }
GtMethodCoderAddOns >> removeShortcut: aBlShortcut [
	1 to: shortcuts size do: [ :i | 
		(shortcuts at: i) combination = aBlShortcut combination
			ifTrue: [ shortcuts removeAt: i.
				modified add: #shortcuts ] ]
]

{ #category : #shortcuts }
GtMethodCoderAddOns >> removeShortcutsMatching: aBlock [
	shortcuts removeAllSuchThat: aBlock
]

{ #category : #stylers }
GtMethodCoderAddOns >> removeStylerOfType: aClass [
	| styler |
	styler := stylers detect: [ :each | each isKindOf: aClass ] ifNone: [  ].
	styler isNil
		ifTrue: [ ^ self ].
	stylers remove: styler.
	modified add: #stylers
]

{ #category : #shortcuts }
GtMethodCoderAddOns >> shortcuts [
	^ shortcuts
]

{ #category : #accessing }
GtMethodCoderAddOns >> stylers [
	^ stylers
]
