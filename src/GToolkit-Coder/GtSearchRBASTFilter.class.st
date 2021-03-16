Class {
	#name : #GtSearchRBASTFilter,
	#superclass : #GtSearchMethodsFilter,
	#instVars : [
		'ast',
		'sentMessagesFilter'
	],
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #'instance creation' }
GtSearchRBASTFilter class >> ast: aRBProgramNode [
	^ self new
		ast: aRBProgramNode;
		yourself
]

{ #category : #'instance creation' }
GtSearchRBASTFilter class >> sourceExpression: aString [
	^ self new sourceExpression: aString
]

{ #category : #'instance creation' }
GtSearchRBASTFilter class >> sourceMethod: aString [
	^ self new sourceMethod: aString
]

{ #category : #comparing }
GtSearchRBASTFilter >> = anObject [
	^ self class = anObject class and: [ self ast = anObject ast ]
]

{ #category : #accessing }
GtSearchRBASTFilter >> ast [
	^ ast
]

{ #category : #accessing }
GtSearchRBASTFilter >> ast: aRBProgramNode [
	ast := aRBProgramNode.
	self computeMessagesFilter
]

{ #category : #private }
GtSearchRBASTFilter >> computeMessagesFilter [
	| messages filters |
	messages := ast sentMessages.
	messages isEmpty
		ifTrue: [ ^ sentMessagesFilter := nil ].
	filters := messages collect: [ :each | GtSearchReferencesFilter literal: each ].
	sentMessagesFilter := filters reduce: [ :a :b | a & b ]
]

{ #category : #accessing }
GtSearchRBASTFilter >> filterValueString [
	^ self source
]

{ #category : #ui }
GtSearchRBASTFilter >> gtDisplayOn: stream [
	self ast gtDisplayOn: stream
]

{ #category : #comparing }
GtSearchRBASTFilter >> hash [
	^ self class hash bitXor: self ast hash
]

{ #category : #testing }
GtSearchRBASTFilter >> includesMethod: aCompiledMethod [
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
GtSearchRBASTFilter >> source [
	^ ast source ifNil: [ ast formattedCode ]
]

{ #category : #accessing }
GtSearchRBASTFilter >> sourceExpression: aString [
	self ast: (RBParser parseRewriteExpression: aString)
]

{ #category : #accessing }
GtSearchRBASTFilter >> sourceMethod: aString [
	self ast: (RBParser parseRewriteMethod: aString)
]
