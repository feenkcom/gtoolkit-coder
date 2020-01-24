Class {
	#name : #GtSourceCoderTextStyler,
	#superclass : #GtASTCompositeStyler,
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
GtSourceCoderTextStyler >> parse: aText [
	| ast aString aCoderSource aHeaderSource isCoderSourceSame isHeaderSourceSame |
	
	"see https://github.com/feenkcom/gtoolkit/issues/593"
	aString := aText asString.
	aCoderSource := coder newSourceText characters asString.
	aHeaderSource := coder newCollapsedText characters asString.
	
	isCoderSourceSame := aString = aCoderSource.
	isHeaderSourceSame := aString = aHeaderSource.
	
	"a given text is neither coder source nor header, let's ignore it"
	(isCoderSourceSame or: [ isHeaderSourceSame ])
		ifFalse: [ ^ nil ].

	isCoderSourceSame
		ifTrue: [ ast := coder rbAST ]
		ifFalse: [ ast := coder rbAST copy.
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
	^ ast
]
