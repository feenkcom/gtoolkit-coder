Class {
	#name : #GtProcessCoderElement,
	#superclass : #GtMethodsCoderElement,
	#instVars : [
		'activeCoder',
		'contextVariablesElement',
		'watchVariablesElement',
		'watchExpressions'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #private }
GtProcessCoderElement >> addMethodWatchExpressionFrom: aMethodCoder [
	GtWatchExpression addExpression: aMethodCoder selectedSource for: aMethodCoder compiledMethod.
	self updateWatchExpressions
]

{ #category : #private }
GtProcessCoderElement >> addWatchExpressionFrom: aMethodCoder [
	(watchExpressions at: aMethodCoder ifAbsentPut: [ OrderedCollection new ])
		add: (GtWatchExpression new expression: aMethodCoder selectedSource).
	self updateWatchExpressions
]

{ #category : #ui }
GtProcessCoderElement >> buildElement [
	super buildElement.
	self layout: BlLinearLayout horizontal.
	self addChild: self variablesElement
]

{ #category : #ui }
GtProcessCoderElement >> buildElementForCoder: aMethodCoder [
	| element |
	aMethodCoder addOns
		addShortcut:
			(BlShortcut new
				combination:
					(BlKeyCombination builder
						primary;
						w;
						build);
				action: [ self addWatchExpressionFrom: aMethodCoder ]);
		addShortcut:
			(BlShortcut new
				combination:
					(BlKeyCombination builder
						primary;
						shift;
						w;
						build);
				action: [ self addMethodWatchExpressionFrom: aMethodCoder ]).
	element := super buildElementForCoder: aMethodCoder.
	element when: BlFocusInEvent do: [ :event | self focusedCoder: aMethodCoder in: element ].
	^ element
]

{ #category : #private }
GtProcessCoderElement >> contextVariables [
	| vars |
	(activeCoder isNil or: [ activeCoder isDead ])
		ifTrue: [ ^ #() ].
	vars := OrderedCollection new.
	activeCoder tempNamesAndValuesDo: [ :name :value | vars add: {name. 'temporary'. value} ].
	activeCoder instanceVariableNamesAndValuesDo: [ :name :value | vars add: {name. 'instance'. value} ].
	vars sort: [ :a :b | a first < b first ].
	vars addFirst: {'self'. 'self'. activeCoder receiver}.
	activeCoder stackVariableNamesAndValuesDo: [ :name :value | vars add: {name. 'stack'. value} ].
	^ vars
]

{ #category : #ui }
GtProcessCoderElement >> contextVariablesElement [
	contextVariablesElement := self variablesListElement.
	contextVariablesElement display: self contextVariables.
	^ contextVariablesElement
]

{ #category : #private }
GtProcessCoderElement >> focusedCoder: aCoder in: anElement [
	activeCoder := aCoder.
	self updateVariables
]

{ #category : #'initialize-release' }
GtProcessCoderElement >> initialize [
	super initialize.
	watchExpressions := WeakKeyDictionary new
]

{ #category : #private }
GtProcessCoderElement >> updateList [
	super updateList.
	self updateVariables
]

{ #category : #private }
GtProcessCoderElement >> updateVariables [
	contextVariablesElement notNil
		ifTrue: [ contextVariablesElement display: self contextVariables ].
	self updateWatchExpressions
]

{ #category : #private }
GtProcessCoderElement >> updateWatchExpressions [
	watchVariablesElement notNil
		ifTrue: [ watchVariablesElement display: self watchVariables ]
]

{ #category : #ui }
GtProcessCoderElement >> variablesElement [
	| tab1 tab2 tabGroup |
	tab1 := BrTabModel new
		add: (BrLabelModel text: 'Variables');
		stencil: [ self contextVariablesElement ].
	tab2 := BrTabModel new
		add: (BrLabelModel text: 'Watches');
		stencil: [ self watchVariablesElement ].
	tabGroup := BrTabGroupModel
		with:
			{tab1.
			tab2}.
	tabGroup tabs
		do: [ :aTab | 
			BlElement new
				look: BrMaterialTabLabelledLook;
				viewModel: aTab ].
	^ BlElement new
		look: BrMaterialTabGroupLook;
		viewModel: tabGroup
]

{ #category : #ui }
GtProcessCoderElement >> variablesListElement [
	| list |
	list := BrColumnedList new.
	list margin: (BlInsets all: 10).
	list addEventHandler: (GtInspectorListToSelectHandler new transformation: [ :each | each last ]).
	list column
		title: 'Icon';
		stencil: [ :each | 
			| icon |
			icon := [ each last gtInspectorIcon ifNil: [ each last class systemIcon ] ]
				on: Error
				do: [ :error | self iconNamed: #smallWarningIcon ].
			icon asElement
				margin:
					(BlInsets
						top: 3
						left: 10
						bottom: 3
						right: 0) ].
	list column
		title: 'Variable';
		stencil: [ :each | 
			BrLabel new
				look: (BrGlamorousLabelLook new foreground: Color black);
				text: each first asString;
				hMatchParent;
				vMatchParent;
				margin:
					(BlInsets
						top: 3
						left: 10
						bottom: 3
						right: 0) ].
	list column
		title: 'Value';
		stencil: [ :each | 
			BrLabel new
				look: (BrGlamorousLabelLook new foreground: Color black);
				text: (each last printStringLimitedTo: 50);
				hMatchParent;
				vMatchParent;
				margin:
					(BlInsets
						top: 3
						left: 10
						bottom: 3
						right: 0) ].
	^ list
]

{ #category : #private }
GtProcessCoderElement >> watchExpressionsFor: aMethodCoder [
	^ (watchExpressions at: aMethodCoder ifAbsent: [ #() ]) , (GtWatchExpression expressionsFor: aMethodCoder compiledMethod) asArray
]

{ #category : #private }
GtProcessCoderElement >> watchVariables [
	| variables |
	variables := OrderedCollection new.
	methodsCoder coders do: [ :each | variables addAll: (self watchVariablesFor: each) ].
	^ variables
]

{ #category : #ui }
GtProcessCoderElement >> watchVariablesElement [
	watchVariablesElement := self variablesListElement.
	watchVariablesElement display: self watchVariables.
	^ watchVariablesElement
]

{ #category : #private }
GtProcessCoderElement >> watchVariablesFor: aMethodCoder [
	^ (self watchExpressionsFor: aMethodCoder)
		collect: [ :each | 
			{each expression.
			'Watch Expression'.
			(each valueIn: aMethodCoder context)} ]
]
