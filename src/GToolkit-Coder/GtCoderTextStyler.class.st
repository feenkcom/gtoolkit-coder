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
				or: [ aText asString = coder collapsedEditor text asString ] ].
	ast := aText asString = coder source
		ifTrue: [ coder rbAST ]
		ifFalse: [ coder newRbAST: aText asString ].
	[ self style: aText ast: ast.
	self extraStyle: aText ast: ast ]
		on: Error
		do: [ :e | e return ].
	^ aText
]

{ #category : #private }
GtCoderTextStyler >> style: aText ast: ast [
	coder stylers do: [ :each | each style: aText ast: ast ]
]
