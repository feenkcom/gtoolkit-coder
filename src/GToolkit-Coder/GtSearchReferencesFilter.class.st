Class {
	#name : #GtSearchReferencesFilter,
	#superclass : #GtSearchMethodsFilter,
	#instVars : [
		'object',
		'specialSelectorIndex'
	],
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #'instance creation' }
GtSearchReferencesFilter class >> literal: anObject [
	^ self new
		object: anObject;
		yourself
]

{ #category : #comparing }
GtSearchReferencesFilter >> = anObject [
	^ self class = anObject class and: [ self object = anObject object ]
]

{ #category : #testing }
GtSearchReferencesFilter >> checkForArrayReference: anObject [
	anObject isArray
		ifFalse: [ ^ false ].
	^ anObject
		anySatisfy:
			[ :each | each == self object or: [ self checkForArrayReference: each ] ]
]

{ #category : #testing }
GtSearchReferencesFilter >> checkMethodSource: aCompiledMethod [
	| ast |
	ast := aCompiledMethod ast.
	ast
		nodesDo: [ :each | 
			(each isLiteralNode and: [ each value == self object ])
				ifTrue: [ ^ true ] ].
	^ false
]

{ #category : #testing }
GtSearchReferencesFilter >> doesMethodIncludeBytecodeLiteral: aCompiledMethod [
	| stream |
	stream := InstructionStream on: aCompiledMethod.
	[ stream atEnd ]
		whileFalse: [ | instruction |
			instruction := stream nextInstruction.
			(#methodReturnConstant: = instruction selector
				and: [ instruction arguments first == self object ])
				ifTrue: [ ^ true ].
			(#pushConstant: = instruction selector
				and: [ instruction arguments first == self object ])
				ifTrue: [ ^ self checkMethodSource: aCompiledMethod ] ].
	aCompiledMethod
		literalsDo: [ :each | 
			each == self object
				ifTrue: [ ^ self checkMethodSource: aCompiledMethod ].
			(self checkForArrayReference: each)
				ifTrue: [ ^ true ] ].
	^ false
]

{ #category : #ui }
GtSearchReferencesFilter >> gtDisplayOn: stream [
	self object gtDisplayOn: stream.
	stream nextPutAll: ' references'.
]

{ #category : #comparing }
GtSearchReferencesFilter >> hash [
	^ self class hash bitXor: self object hash
]

{ #category : #accessing }
GtSearchReferencesFilter >> highlighter [
	((self object isKindOf: Association) and: [ self object key isSymbol ])
				ifTrue: [ ^ GtVariableReferenceHighlighter forVariableName: self object key ].
	self object isLiteral ifTrue: [ ^ GtSelectorReferenceAndLiteralHighlighter forSelector: self object ].
	^ nil
]

{ #category : #testing }
GtSearchReferencesFilter >> includesMethod: aCompiledMethod [
	(aCompiledMethod encoderClass specialLiterals includes: self object)
		ifTrue: [ ^ self doesMethodIncludeBytecodeLiteral: aCompiledMethod ].
	^ aCompiledMethod
		hasSelector: self object
		specialSelectorIndex: specialSelectorIndex
]

{ #category : #accessing }
GtSearchReferencesFilter >> object [
	^ object
]

{ #category : #accessing }
GtSearchReferencesFilter >> object: anObject [
	object := anObject.
	specialSelectorIndex := Smalltalk specialSelectorIndexOrNil: anObject
]

{ #category : #ui }
GtSearchReferencesFilter >> printOn: stream [
	self object gtDisplayOn: stream.
	stream nextPutAll: ' gtReferences'.
]
