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
	[ | ast source |
	source := aText asString.
	ast := RBParser parseFaultyMethod: source.
	ast methodNode
		compilationContext:
			(CompilationContext new
				class: (coder classOrMetaClass ifNil: [ UndefinedObject ]);
				forSyntaxHighlighting: true;
				bindings: Dictionary new;
				requestor: nil).
	ast doSemanticAnalysis.
	self style: aText ast: ast.
	self extraStyle: aText ast: ast ]
		on: Error
		do: [ :ex | ex return ].
	^ aText
]

{ #category : #private }
GtCoderTextStyler >> style: aText ast: ast [
	coder stylers do: [ :each | each style: aText ast: ast ]
]
