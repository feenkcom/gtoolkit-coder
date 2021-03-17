Class {
	#name : #GtSearchAstFilter,
	#superclass : #GtSearchMethodsFilter,
	#instVars : [
		'ast',
		'sentMessagesFilter'
	],
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #'instance creation' }
GtSearchAstFilter class >> ast: aRBProgramNode [
	^ self new
		ast: aRBProgramNode;
		yourself
]

{ #category : #'instance creation' }
GtSearchAstFilter class >> sourceExpression: aString [
	^ self new sourceExpression: aString
]

{ #category : #'instance creation' }
GtSearchAstFilter class >> sourceMethod: aString [
	^ self new sourceMethod: aString
]

{ #category : #comparing }
GtSearchAstFilter >> = anObject [
	^ self class = anObject class and: [ self ast = anObject ast ]
]

{ #category : #accessing }
GtSearchAstFilter >> ast [
	<return: #GtPharoProgramNode>
	^ ast
]

{ #category : #accessing }
GtSearchAstFilter >> ast: aGtPharoProgramNode [
	ast := aGtPharoProgramNode.
	self computeMessagesFilter
]

{ #category : #private }
GtSearchAstFilter >> computeMessagesFilter [
	| messages filters |
	messages := ast sentMessages.
	messages isEmpty
		ifTrue: [ ^ sentMessagesFilter := nil ].
	filters := messages collect: [ :each | GtSearchReferencesFilter literal: each ].
	sentMessagesFilter := filters reduce: [ :a :b | a & b ]
]

{ #category : #accessing }
GtSearchAstFilter >> filterValueString [
	^ self source
]

{ #category : #ui }
GtSearchAstFilter >> gtDisplayOn: stream [
	self ast gtDisplayOn: stream
]

{ #category : #comparing }
GtSearchAstFilter >> hash [
	^ self class hash bitXor: self ast hash
]

{ #category : #testing }
GtSearchAstFilter >> includesMethod: aCompiledMethod [
	| methodAst |
	(sentMessagesFilter isNil or: [ sentMessagesFilter matches: aCompiledMethod ])
		ifFalse: [ ^ false ].
	methodAst := aCompiledMethod ast.
	methodAst
		nodesDo: [ :each | 
			(ast match: each inContext: Dictionary new)
				ifTrue: [ ^ true ] ].
	^ false
]

{ #category : #accessing }
GtSearchAstFilter >> source [
	^ ast source ifNil: [ ast formattedCode ]
]

{ #category : #accessing }
GtSearchAstFilter >> sourceExpression: aString [
	self ast: (RBParser parseRewriteExpression: aString)
]

{ #category : #accessing }
GtSearchAstFilter >> sourceMethod: aString [
	self ast: (RBParser parseRewriteMethod: aString)
]
