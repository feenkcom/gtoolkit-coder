Class {
	#name : #GtSearchMethodsContainedInClassFilter,
	#superclass : #GtSearchMethodsFilter,
	#instVars : [
		'class'
	],
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #'instance creation' }
GtSearchMethodsContainedInClassFilter class >> forClass: aClass [
	^ self new
		forClass: aClass;
		yourself
]

{ #category : #comparing }
GtSearchMethodsContainedInClassFilter >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ class = anObject filterClass
]

{ #category : #accessing }
GtSearchMethodsContainedInClassFilter >> defaultFilterScope [
	^ self
]

{ #category : #accessing }
GtSearchMethodsContainedInClassFilter >> filterClass [
	^ class
]

{ #category : #'initialize-release' }
GtSearchMethodsContainedInClassFilter >> forClass: aClass [
	class := aClass
]

{ #category : #enumerating }
GtSearchMethodsContainedInClassFilter >> itemsDo: aBlock [
	^ self methodsDo: aBlock
]

{ #category : #enumerating }
GtSearchMethodsContainedInClassFilter >> methodsDo: aBlock [
	self subclassResponsibility
]
