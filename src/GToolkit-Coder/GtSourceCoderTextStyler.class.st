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
	| aString aCoderSource isCoderSourceSame |
	
	"see https://github.com/feenkcom/gtoolkit/issues/593"
	aString := aText asString.
	aCoderSource := coder currentSourceString.
	
	isCoderSourceSame := aString = aCoderSource.
	
	"on Windows these may be different due to cr/lf"
	isCoderSourceSame 
		ifFalse: [ ^ coder newRbAST: aString ].

	^ coder rbAST
]
