Class {
	#name : #GtSearchMethodsInClassFilter,
	#superclass : #GtSearchMethodsContainedInClassFilter,
	#instVars : [
		'includeSubclasses',
		'includeSuperclass'
	],
	#category : #'GToolkit-Coder-Filters'
}

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
GtSearchMethodsInClassFilter >> methodsDo: aBlock [
	class methods do: aBlock.
]
