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
	^ aCompiledMethod hasSelector: object specialSelectorIndex: specialSelectorIndex
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
