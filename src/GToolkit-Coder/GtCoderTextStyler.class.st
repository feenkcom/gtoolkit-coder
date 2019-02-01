Class {
	#name : #GtCoderTextStyler,
	#superclass : #BlTextStyler,
	#instVars : [
		'coder'
	],
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #'instance creation' }
GtCoderTextStyler class >> forCoder: aMethodCoder [
	^ self new
		coder: aMethodCoder;
		yourself
]

{ #category : #accessing }
GtCoderTextStyler >> coder [
	^ coder
]

{ #category : #accessing }
GtCoderTextStyler >> coder: aMethodCoder [
	coder := aMethodCoder
]

{ #category : #private }
GtCoderTextStyler >> extraStyle: aText ast: ast [
	coder stylers do: [ :each | each extraStyle: aText ast: ast ]
]

{ #category : #private }
GtCoderTextStyler >> privateStyle: aText [
	| ast |
	self
		assert: [ aText asString = coder source
				or: [ aText asString = coder collapsedSource ] ].
	ast := aText asString = coder source
		ifTrue: [ coder rbAST ]
		ifFalse: [ ast := coder rbAST copy
				body: (RBSequenceNode statements: #());
				pragmas: #();
				yourself.
			ast
				instVarNamed: #properties
				put: (ast instVarNamed: #properties) copy.
			ast comments: #().
			ast arguments do: [ :e | e parent: ast ].
			ast ].
	[ self style: aText ast: ast.
	self extraStyle: aText ast: ast ]
		on: Error
		do: [ :e | e debug ].
	^ aText
]

{ #category : #private }
GtCoderTextStyler >> style: aText ast: ast [
	coder stylers do: [ :each | each style: aText ast: ast ]
]
