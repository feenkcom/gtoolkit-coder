Class {
	#name : #GtCoderPatternTextStyler,
	#superclass : #BlTextStyler,
	#instVars : [
		'coder'
	],
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #accessing }
GtCoderPatternTextStyler >> coder [
	^ coder
]

{ #category : #accessing }
GtCoderPatternTextStyler >> coder: aMethodCoder [
	coder := aMethodCoder
]

{ #category : #private }
GtCoderPatternTextStyler >> extraStyle: aText ast: ast [
	coder patternStylers do: [ :each | each extraStyle: aText ast: ast ]
]

{ #category : #private }
GtCoderPatternTextStyler >> privateStyle: aText [
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
	"coder updateAddOnsForAST: ast."
	self style: aText ast: ast.
	self extraStyle: aText ast: ast ]
		on: Error
		do: [ :ex | ex return ].
	^ aText
]

{ #category : #private }
GtCoderPatternTextStyler >> style: aText ast: ast [
	coder patternStylers do: [ :each | each style: aText ast: ast ]
]
