Class {
	#name : #GtSearchASTFilter,
	#superclass : #GtSearchMethodsFilter,
	#instVars : [
		'ast',
		'sentMessagesFilter'
	],
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #'instance creation' }
GtSearchASTFilter class >> ast: aRBProgramNode [
	^ self new
		ast: aRBProgramNode;
		yourself
]

{ #category : #accessing }
GtSearchASTFilter class >> filterDescriptorFor: aMethodsCoder [
	^ GtFilterDescriptor
		forClass: self
		named: 'AST'
		order: 100
		getter: #source
		setter: #sourceExpression:
		completion: nil
]

{ #category : #'instance creation' }
GtSearchASTFilter class >> sourceExpression: aString [
	^ self new sourceExpression: aString
]

{ #category : #'instance creation' }
GtSearchASTFilter class >> sourceMethod: aString [
	^ self new sourceMethod: aString
]

{ #category : #comparing }
GtSearchASTFilter >> = anObject [
	^ self class = anObject class and: [ self ast = anObject ast ]
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
	filters := messages collect: [ :each | GtSearchReferencesFilter literal: each ].
	sentMessagesFilter := filters reduce: [ :a :b | a & b ]
]

{ #category : #ui }
GtSearchASTFilter >> gtDisplayOn: stream [
	self ast gtDisplayOn: stream
]

{ #category : #comparing }
GtSearchASTFilter >> hash [
	^ self class hash bitXor: self ast hash
]

{ #category : #accessing }
GtSearchASTFilter >> highlighter [
	^ GtASTPatternHighlighter ast: ast
]

{ #category : #testing }
GtSearchASTFilter >> includesMethod: aCompiledMethod [
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
GtSearchASTFilter >> source [
	^ ast source ifNil: [ ast formattedCode ]
]

{ #category : #accessing }
GtSearchASTFilter >> sourceExpression: aString [
	self ast: (RBParser parseRewriteExpression: aString)
]

{ #category : #accessing }
GtSearchASTFilter >> sourceMethod: aString [
	self ast: (RBParser parseRewriteMethod: aString)
]
