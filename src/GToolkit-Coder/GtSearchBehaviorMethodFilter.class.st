Class {
	#name : #GtSearchBehaviorMethodFilter,
	#superclass : #GtSearchMethodsFilter,
	#instVars : [
		'class',
		'includeSubclasses',
		'includeSuperclass'
	],
	#category : #'GToolkit-Coder-Filters2'
}

{ #category : #'instance creation' }
GtSearchBehaviorMethodFilter class >> forClass: aClass [
	^ self new
		forClass: aClass;
		yourself
]

{ #category : #'initialize-release' }
GtSearchBehaviorMethodFilter >> forClass: aClass [
	class := aClass
]

{ #category : #testing }
GtSearchBehaviorMethodFilter >> includeMethod: aCompiledMethod [
	| methodClass |
	methodClass := aCompiledMethod methodClass.
	methodClass = class
		ifTrue: [ ^ true ].
	^ (includeSubclasses and: [ methodClass includesBehavior: class ])
		or: [ includeSuperclass and: [ class includesBehavior: methodClass ] ]
]

{ #category : #testing }
GtSearchBehaviorMethodFilter >> includeSubclasses [
	^ includeSubclasses
]

{ #category : #'initialize-release' }
GtSearchBehaviorMethodFilter >> includeSubclasses: anObject [
	includeSubclasses := anObject
]

{ #category : #testing }
GtSearchBehaviorMethodFilter >> includeSuperclass [
	^ includeSuperclass
]

{ #category : #'initialize-release' }
GtSearchBehaviorMethodFilter >> includeSuperclass: anObject [
	includeSuperclass := anObject
]

{ #category : #'initialize-release' }
GtSearchBehaviorMethodFilter >> initialize [
	super initialize.
	includeSubclasses := false.
	includeSuperclass := false
]

{ #category : #enumerating }
GtSearchBehaviorMethodFilter >> methodsDo: aBlock [
	class instanceSide methods do: aBlock.
	class classSide methods do: aBlock.
]
