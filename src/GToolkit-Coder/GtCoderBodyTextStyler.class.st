Class {
	#name : #GtCoderBodyTextStyler,
	#superclass : #BlTextStyler,
	#instVars : [
		'coder'
	],
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #'instance creation' }
GtCoderBodyTextStyler class >> forCoder: aMethodCoder [
	^ self new
		coder: aMethodCoder;
		yourself
]

{ #category : #accessing }
GtCoderBodyTextStyler >> coder [
	^ coder
]

{ #category : #accessing }
GtCoderBodyTextStyler >> coder: aMethodCoder [
	coder := aMethodCoder
]

{ #category : #private }
GtCoderBodyTextStyler >> extraStyle: aText ast: ast [
	coder bodyStylers do: [ :each | each extraStyle: aText ast: ast ]
]

{ #category : #private }
GtCoderBodyTextStyler >> patternSource [
	^ coder patternSource
]

{ #category : #private }
GtCoderBodyTextStyler >> privateStyle: aText [
	[ | ast source |
	source := self patternSource , ' ' , aText asString.
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
GtCoderBodyTextStyler >> style: aText ast: ast [
	| patternSource |
	patternSource := coder patternSource.
	coder bodyStylers
		do: [ :each | 
			each methodPatternSource: patternSource.
			each style: aText ast: ast ]
]
