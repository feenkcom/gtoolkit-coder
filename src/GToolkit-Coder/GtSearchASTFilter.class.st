Class {
	#name : #GtSearchASTFilter,
	#superclass : #GtSearchMethodsFilter,
	#instVars : [
		'ast',
		'sentMessagesFilter'
	],
	#category : #'GToolkit-Coder-Filters2'
}

{ #category : #'instance creation' }
GtSearchASTFilter class >> ast: aRBProgramNode [
	^ self new
		ast: aRBProgramNode;
		yourself
]

{ #category : #'instance creation' }
GtSearchASTFilter class >> sourceExpression: aString [
	^ self ast: (RBParser parseRewriteExpression: aString)
]

{ #category : #accessing }
GtSearchASTFilter >> ast [
	^ ast
]

{ #category : #accessing }
GtSearchASTFilter >> ast: aRBProgramNode [
	ast := aRBProgramNode.
	self computeMessagesFilter
]

{ #category : #private }
GtSearchASTFilter >> computeMessagesFilter [
	| messages filters |
	messages := ast sentMessages.
	messages isEmpty
		ifTrue: [ ^ sentMessagesFilter := nil ].
	filters := messages collect: [ :each | GtCoderReferencesFilter literal: each ].
	sentMessagesFilter := filters reduce: [ :a :b | a & b ]
]

{ #category : #ui }
GtSearchASTFilter >> gtDisplayOn: stream [
	self ast gtDisplayOn: stream
]

{ #category : #accessing }
GtSearchASTFilter >> highlighter [
	^ GtASTPatternHighlighter ast: ast
]

{ #category : #testing }
GtSearchASTFilter >> includesMethod: aCompiledMethod [
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
