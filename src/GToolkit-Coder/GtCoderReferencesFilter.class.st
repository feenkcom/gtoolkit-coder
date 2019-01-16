Class {
	#name : #GtCoderReferencesFilter,
	#superclass : #GtCoderMethodsFilter,
	#instVars : [
		'object',
		'specialSelectorIndex'
	],
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #'instance creation' }
GtCoderReferencesFilter class >> literal: anObject [
	^ self new
		object: anObject;
		yourself
]

{ #category : #testing }
GtCoderReferencesFilter >> checkForArrayReference: anObject [
	anObject isArray
		ifFalse: [ ^ false ].
	^ anObject
		anySatisfy:
			[ :each | each == anObject or: [ self checkForArrayReference: each ] ]
]

{ #category : #testing }
GtCoderReferencesFilter >> checkMethodSource: aCompiledMethod [
	| ast |
	ast := aCompiledMethod ast.
	ast
		nodesDo: [ :each | 
			(each isLiteralNode and: [ each value == object ])
				ifTrue: [ ^ true ] ].
	^ false
]

{ #category : #testing }
GtCoderReferencesFilter >> doesMethodIncludeBytecodeLiteral: aCompiledMethod [
	| stream |
	stream := InstructionStream on: aCompiledMethod.
	[ stream atEnd ]
		whileFalse: [ | instruction |
			instruction := stream nextInstruction.
			(#methodReturnConstant: = instruction selector
				and: [ instruction arguments first == object ])
				ifTrue: [ ^ true ].
			(#pushConstant: = instruction selector
				and: [ instruction arguments first == object ])
				ifTrue: [ ^ self checkMethodSource: aCompiledMethod ] ].
	aCompiledMethod
		literalsDo: [ :each | 
			each == object
				ifTrue: [ ^ self checkMethodSource: aCompiledMethod ].
			(self checkForArrayReference: each)
				ifTrue: [ ^ true ] ].
	^ false
]

{ #category : #ui }
GtCoderReferencesFilter >> gtDisplayOn: stream [
	self object gtDisplayOn: stream.
	stream nextPutAll: ' references'.
]

{ #category : #accessing }
GtCoderReferencesFilter >> highlighter [
	((object isKindOf: Association) and: [ object key isSymbol ])
				ifTrue: [ ^ GtVariableReferenceHighlighter forVariableName: object key ].
	object isLiteral ifTrue: [ ^ GtSelectorReferenceAndLiteralHighlighter forSelector: object ].
	^ nil
]

{ #category : #testing }
GtCoderReferencesFilter >> includeMethod: aCompiledMethod [
	(#(true false nil) includes: object)
		ifTrue: [ ^ self doesMethodIncludeBytecodeLiteral: aCompiledMethod ].
	^ aCompiledMethod
		hasSelector: object
		specialSelectorIndex: specialSelectorIndex
]

{ #category : #accessing }
GtCoderReferencesFilter >> object [
	^ object
]

{ #category : #accessing }
GtCoderReferencesFilter >> object: anObject [
	object := anObject.
	specialSelectorIndex := Smalltalk specialSelectorIndexOrNil: anObject
]

{ #category : #ui }
GtCoderReferencesFilter >> printOn: stream [
	self object gtDisplayOn: stream.
	stream nextPutAll: ' gtReferences'.
]
