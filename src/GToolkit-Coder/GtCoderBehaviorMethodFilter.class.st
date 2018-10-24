Class {
	#name : #GtCoderBehaviorMethodFilter,
	#superclass : #GtCoderMethodsFilter,
	#instVars : [
		'class',
		'includeSubclasses',
		'includeSuperclass'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #'instance creation' }
GtCoderBehaviorMethodFilter class >> forClass: aClass [
	^ self new
		forClass: aClass;
		yourself
]

{ #category : #'initialize-release' }
GtCoderBehaviorMethodFilter >> forClass: aClass [
	class := aClass
]

{ #category : #testing }
GtCoderBehaviorMethodFilter >> includeMethod: aCompiledMethod [
	| methodClass |
	methodClass := aCompiledMethod methodClass.
	methodClass = class
		ifTrue: [ ^ true ].
	^ (includeSubclasses and: [ methodClass includesBehavior: class ])
		or: [ includeSuperclass and: [ class includesBehavior: methodClass ] ]
]

{ #category : #testing }
GtCoderBehaviorMethodFilter >> includeSubclasses [
	^ includeSubclasses
]

{ #category : #'initialize-release' }
GtCoderBehaviorMethodFilter >> includeSubclasses: anObject [
	includeSubclasses := anObject
]

{ #category : #testing }
GtCoderBehaviorMethodFilter >> includeSuperclass [
	^ includeSuperclass
]

{ #category : #'initialize-release' }
GtCoderBehaviorMethodFilter >> includeSuperclass: anObject [
	includeSuperclass := anObject
]

{ #category : #'initialize-release' }
GtCoderBehaviorMethodFilter >> initialize [
	super initialize.
	includeSubclasses := false.
	includeSuperclass := false
]
