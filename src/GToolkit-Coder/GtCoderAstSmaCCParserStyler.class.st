Class {
	#name : #GtCoderAstSmaCCParserStyler,
	#superclass : #GtCoderAstStyler,
	#instVars : [
		'smaccStyler'
	],
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #accessing }
GtCoderAstSmaCCParserStyler >> smaccStyler [
	^ smaccStyler
]

{ #category : #accessing }
GtCoderAstSmaCCParserStyler >> smaccStyler: anObject [
	smaccStyler := anObject
]

{ #category : #'api - styling' }
GtCoderAstSmaCCParserStyler >> style: aText ast: theAst [
	self smaccStyler style: aText using: theAst
]
