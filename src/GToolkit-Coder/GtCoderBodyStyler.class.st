Class {
	#name : #GtCoderBodyStyler,
	#superclass : #Object,
	#traits : 'TRBProgramNodeVisitor',
	#classTraits : 'TRBProgramNodeVisitor classTrait',
	#instVars : [
		'text',
		'patternSource'
	],
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #styling }
GtCoderBodyStyler >> extraStyle: aText ast: ast [
	
]

{ #category : #accessing }
GtCoderBodyStyler >> methodPatternSource: aString [
	patternSource := aString
]

{ #category : #styling }
GtCoderBodyStyler >> style: aText ast: ast [
	text := aText.
	self visitNode: ast
]

{ #category : #private }
GtCoderBodyStyler >> styleFrom: from to: to with: attributes [
	(text from: from - patternSource size - 1 to: to - patternSource size - 1) attributes: attributes
]
