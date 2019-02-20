Class {
	#name : #GtSearchReferencesFilter,
	#superclass : #GtSearchMethodsFilter,
	#instVars : [
		'object',
		'specialSelectorIndex'
	],
	#category : #'GToolkit-Coder-Filters2'
}

{ #category : #'instance creation' }
GtSearchReferencesFilter class >> literal: anObject [
	^ self new
		object: anObject;
		yourself
]

{ #category : #testing }
GtSearchReferencesFilter >> checkForArrayReference: anObject [
	anObject isArray
		ifFalse: [ ^ false ].
	^ anObject
		anySatisfy:
			[ :each | each == object or: [ self checkForArrayReference: each ] ]
]

{ #category : #testing }
GtSearchReferencesFilter >> checkMethodSource: aCompiledMethod [
	| ast |
	ast := aCompiledMethod ast.
	ast
		nodesDo: [ :each | 
			(each isLiteralNode and: [ each value == object ])
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
GtSearchReferencesFilter >> gtDisplayOn: stream [
	self object gtDisplayOn: stream.
	stream nextPutAll: ' references'.
]

{ #category : #accessing }
GtSearchReferencesFilter >> highlighter [
	((object isKindOf: Association) and: [ object key isSymbol ])
				ifTrue: [ ^ GtVariableReferenceHighlighter forVariableName: object key ].
	object isLiteral ifTrue: [ ^ GtSelectorReferenceAndLiteralHighlighter forSelector: object ].
	^ nil
]

{ #category : #testing }
GtSearchReferencesFilter >> includeMethod: aCompiledMethod [
	(aCompiledMethod encoderClass specialLiterals includes: object)
		ifTrue: [ ^ self doesMethodIncludeBytecodeLiteral: aCompiledMethod ].
	^ aCompiledMethod
		hasSelector: object
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
