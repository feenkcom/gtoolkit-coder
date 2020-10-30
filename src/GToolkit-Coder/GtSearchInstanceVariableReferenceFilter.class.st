Class {
	#name : #GtSearchInstanceVariableReferenceFilter,
	#superclass : #GtSearchMethodsInClassFilter,
	#instVars : [
		'variableName'
	],
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #'instance creation' }
GtSearchInstanceVariableReferenceFilter class >> forClass: aClass andVariable: aString [
	^ self new
		forClass: aClass andVariable: aString;
		yourself
]

{ #category : #'instance creation' }
GtSearchInstanceVariableReferenceFilter class >> forClassAndSubclasses: aClass andVariable: aString [
	^ aClass withAllSubclasses
		inject: GtSearchNullFilter new
		into: [ :sum :each | sum | (self forClass: each andVariable: aString) ]
]

{ #category : #comparing }
GtSearchInstanceVariableReferenceFilter >> = anObject [
	^ super = anObject and: [ self variableName = anObject variableName ]
]

{ #category : #accessing }
GtSearchInstanceVariableReferenceFilter >> filterValueString [
	^ self variableName
]

{ #category : #'initialize-release' }
GtSearchInstanceVariableReferenceFilter >> forClass: aClass andVariable: aString [
	self forClass: aClass.
	variableName := aString
]

{ #category : #comparing }
GtSearchInstanceVariableReferenceFilter >> hash [
	^ super hash bitXor: self variableName
]

{ #category : #testing }
GtSearchInstanceVariableReferenceFilter >> includesMethod: aCompiledMethod [
	| index |
	(super includesMethod: aCompiledMethod)
		ifFalse: [ ^ false ].
	index := class instVarIndexFor: variableName ifAbsent: [ ^ false ].
	^ (aCompiledMethod readsField: index) or: [ aCompiledMethod writesField: index ]
]

{ #category : #'initialize-release' }
GtSearchInstanceVariableReferenceFilter >> initialize [
	super initialize.
	includeSubclasses := true
]

{ #category : #accessing }
GtSearchInstanceVariableReferenceFilter >> variableName [
	^ variableName
]

{ #category : #accessing }
GtSearchInstanceVariableReferenceFilter >> variableName: aString [
	variableName := aString
]
