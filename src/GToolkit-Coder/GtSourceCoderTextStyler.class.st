Class {
	#name : #GtSourceCoderTextStyler,
	#superclass : #BlTextStyler,
	#instVars : [
		'coder'
	],
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #'instance creation' }
GtSourceCoderTextStyler class >> forCoder: aMethodCoder [
	^ self new
		coder: aMethodCoder;
		yourself
]

{ #category : #accessing }
GtSourceCoderTextStyler >> coder [
	^ coder
]

{ #category : #accessing }
GtSourceCoderTextStyler >> coder: aMethodCoder [
	coder := aMethodCoder
]

{ #category : #private }
GtSourceCoderTextStyler >> extraStyle: aText ast: ast [
	coder stylers do: [ :each | each extraStyle: aText ast: ast ]
]

{ #category : #private }
GtSourceCoderTextStyler >> privateStyle: aText [
	| ast |
	(aText asString = coder source
		or: [ aText asString = coder collapsedSource ])
		ifFalse: [ self
				flag:
					'TODO how can it be something else? there is some synchronization missing'.
			^ aText ].
	aText asString = coder source
		ifTrue: [ ast := coder rbAST ]
		ifFalse: [ self flag: 'FIXME maybe use explicit collapsed AST?'.
			ast := coder rbAST copy.
			(ast isNotNil and: [ ast isMethod and: [ ast isParseError not ] ])
				ifTrue: [ ast
						body: (RBSequenceNode statements: #());
						pragmas: #();
						yourself.
					ast
						instVarNamed: #properties
						put: (ast instVarNamed: #properties) copy.
					ast comments: #().
					ast arguments do: [ :e | e parent: ast ] ] ].
	[ self style: aText ast: ast.
	self extraStyle: aText ast: ast ]
		on: Error
		do: [ :e | e return ].
	^ aText
]

{ #category : #private }
GtSourceCoderTextStyler >> style: aText ast: ast [
	coder stylers do: [ :each | each style: aText ast: ast ]
]
