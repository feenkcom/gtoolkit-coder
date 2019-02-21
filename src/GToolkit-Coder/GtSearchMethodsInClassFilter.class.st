Class {
	#name : #GtSearchMethodsInClassFilter,
	#superclass : #GtSearchMethodsFilter,
	#instVars : [
		'class',
		'includeSubclasses',
		'includeSuperclass'
	],
	#category : #'GToolkit-Coder-Filters2'
}

{ #category : #'instance creation' }
GtSearchMethodsInClassFilter class >> forClass: aClass [
	^ self new
		forClass: aClass;
		yourself
]

{ #category : #comparing }
GtSearchMethodsInClassFilter >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ class = anObject filterClass
]

{ #category : #accessing }
GtSearchMethodsInClassFilter >> defaultFilterScope [
	^ self
]

{ #category : #accessing }
GtSearchMethodsInClassFilter >> filterClass [
	^ class
]

{ #category : #'initialize-release' }
GtSearchMethodsInClassFilter >> forClass: aClass [
	class := aClass
]

{ #category : #testing }
GtSearchMethodsInClassFilter >> includeSubclasses [
	^ includeSubclasses
]

{ #category : #'initialize-release' }
GtSearchMethodsInClassFilter >> includeSubclasses: anObject [
	includeSubclasses := anObject
]

{ #category : #testing }
GtSearchMethodsInClassFilter >> includeSuperclass [
	^ includeSuperclass
]

{ #category : #'initialize-release' }
GtSearchMethodsInClassFilter >> includeSuperclass: anObject [
	includeSuperclass := anObject
]

{ #category : #testing }
GtSearchMethodsInClassFilter >> includesMethod: aCompiledMethod [
	| methodClass |
	methodClass := aCompiledMethod methodClass.
	methodClass = class
		ifTrue: [ ^ true ].
	^ (includeSubclasses and: [ methodClass includesBehavior: class ])
		or: [ includeSuperclass and: [ class includesBehavior: methodClass ] ]
]

{ #category : #'initialize-release' }
GtSearchMethodsInClassFilter >> initialize [
	super initialize.
	includeSubclasses := false.
	includeSuperclass := false
]

{ #category : #enumerating }
GtSearchMethodsInClassFilter >> itemsDo: aBlock [
	^ self methodsDo: aBlock
]

{ #category : #enumerating }
GtSearchMethodsInClassFilter >> methodsDo: aBlock [
	class instanceSide methods do: aBlock.
	class classSide methods do: aBlock.
]
