Class {
	#name : #GtContextCoderVariableLook,
	#superclass : #BrLook,
	#instVars : [
		'methodCoder'
	],
	#category : #'GToolkit-Coder-UI-Looks'
}

{ #category : #initialization }
GtContextCoderVariableLook >> initialize [
	super initialize.
	self
		addChange:
			(BrLookChange new
				up: [ :e | 
					self widget
						childNamed: #bodyElement
						ifFound: [ :element | element addChild: self variablesElement ]
						ifNone: [  ] ];
				down: [ :e |  ];
				yourself)
]

{ #category : #accessing }
GtContextCoderVariableLook >> methodCoder [
	^ methodCoder
]

{ #category : #accessing }
GtContextCoderVariableLook >> methodCoder: contextCoder [
	methodCoder := contextCoder
]

{ #category : #private }
GtContextCoderVariableLook >> variables [
	| vars |
	vars := OrderedCollection new.
	methodCoder tempNamesAndValuesDo: [ :name :value | vars add: {name. 'temporary'. value} ].
	methodCoder instanceVariableNamesAndValuesDo: [ :name :value | vars add: {name. 'instance'. value} ].
	vars sort: [ :a :b | a first < b first ].
	vars addFirst: {'self'. 'self'. methodCoder receiver}.
	methodCoder stackVariableNamesAndValuesDo: [ :name :value | vars add: {name. 'stack'. value} ].
	^ vars
]

{ #category : #initialization }
GtContextCoderVariableLook >> variablesElement [
	| variablesElement |
	variablesElement := BrColumnedList new.
	variablesElement
		addEventHandler:
			(GtPhlowListToSelectHandler new
				transformation: [ :each | each last ]).
	variablesElement column
		title: 'Variable';
		stencil: [ :each | 
			BrLabel new
				look: (BrGlamorousLabelLook new foreground: Color black);
				text: each first asString;
				hMatchParent;
				vMatchParent ].
	variablesElement column
		title: 'Value';
		stencil: [ :each | 
			BrLabel new
				look: (BrGlamorousLabelLook new foreground: Color black);
				text: (each last printStringLimitedTo: 50);
				hMatchParent;
				vMatchParent ].
	variablesElement display: self variables.
	^ variablesElement
]
