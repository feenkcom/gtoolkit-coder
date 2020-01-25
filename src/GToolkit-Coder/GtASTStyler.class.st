Class {
	#name : #GtASTStyler,
	#superclass : #BlTextStyler,
	#traits : 'TRBProgramNodeVisitor',
	#classTraits : 'TRBProgramNodeVisitor classTrait',
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #styling }
GtASTStyler >> extraStyle: aText ast: ast [
	
]

{ #category : #ui }
GtASTStyler >> gtViewTextFor: aView [
	<gtView>
	text  ifNil: [ ^ aView ].
	^ aView textEditor
		title: 'Last styled text';
		priority: 105;
		text: [ text ]
]

{ #category : #private }
GtASTStyler >> parse: aText [
	| code |
	code := aText asString.
	^ RBParser parseFaultyMethod: code
]

{ #category : #private }
GtASTStyler >> privateStyle: aText [
	| ast |
	ast := self parse: aText.
	ast isNil
		ifTrue: [ ^ aText ].
	[ self style: aText ast: ast.
	self extraStyle: aText ast: ast ]
		on: Error
		do: [ :e | e return ].
	^ aText
]

{ #category : #styling }
GtASTStyler >> style: aText ast: ast [
	text := aText.
	self visitNode: ast
]

{ #category : #private }
GtASTStyler >> styleFrom: from to: to with: attributes [
	(text from: from to: to) attributes: attributes
]
