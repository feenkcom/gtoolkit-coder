Class {
	#name : #GtCoderASTFilter,
	#superclass : #GtCoderMethodsFilter,
	#instVars : [
		'ast',
		'sentMessagesFilter'
	],
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #'instance creation' }
GtCoderASTFilter class >> ast: aRBProgramNode [
	^ self new
		ast: aRBProgramNode;
		yourself
]

{ #category : #'instance creation' }
GtCoderASTFilter class >> sourceExpression: aString [
	^ self ast: (RBParser parseRewriteExpression: aString)
]

{ #category : #accessing }
GtCoderASTFilter >> ast [
	^ ast
]

{ #category : #accessing }
GtCoderASTFilter >> ast: aRBProgramNode [
	ast := aRBProgramNode.
	self computeMessagesFilter
]

{ #category : #private }
GtCoderASTFilter >> computeMessagesFilter [
	| messages filters |
	messages := ast sentMessages.
	messages isEmpty
		ifTrue: [ ^ sentMessagesFilter := nil ].
	filters := messages collect: [ :each | GtCoderReferencesFilter literal: each ].
	sentMessagesFilter := filters reduce: [ :a :b | a & b ]
]

{ #category : #accessing }
GtCoderASTFilter >> highlighter [
	^ GtASTPatternHighlighter ast: ast
]

{ #category : #testing }
GtCoderASTFilter >> includeMethod: aCompiledMethod [
	| methodAst |
	(sentMessagesFilter isNil or: [ sentMessagesFilter includeMethod: aCompiledMethod ])
		ifFalse: [ ^ false ].
	methodAst := aCompiledMethod ast.
	methodAst
		nodesDo: [ :each | 
			(ast match: each inContext: Dictionary new)
				ifTrue: [ ^ true ] ].
	^ false
]
