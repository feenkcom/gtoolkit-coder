Class {
	#name : #GtCoderBodyStyler,
	#superclass : #Object,
	#traits : 'TRBProgramNodeVisitor',
	#classTraits : 'TRBProgramNodeVisitor classTrait',
	#instVars : [
		'text'
	],
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #styling }
GtCoderBodyStyler >> extraStyle: aText ast: ast [
	
]

{ #category : #styling }
GtCoderBodyStyler >> style: aText ast: ast [
	text := aText.
	self visitNode: ast
]

{ #category : #private }
GtCoderBodyStyler >> styleFrom: from to: to with: attributes [
	(text from: from to: to) attributes: attributes
]
