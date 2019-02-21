Class {
	#name : #GtSearchInstanceVariableReferenceFilter,
	#superclass : #GtSearchMethodsInClassFilter,
	#instVars : [
		'variableName'
	],
	#category : #'GToolkit-Coder-Filters2'
}

{ #category : #'instance creation' }
GtSearchInstanceVariableReferenceFilter class >> forClass: aClass andVariable: aString [
	^ self new
		forClass: aClass andVariable: aString;
		yourself
]

{ #category : #'initialize-release' }
GtSearchInstanceVariableReferenceFilter >> forClass: aClass andVariable: aString [
	self forClass: aClass.
	variableName := aString
]

{ #category : #accessing }
GtSearchInstanceVariableReferenceFilter >> highlighter [
	^ GtVariableReferenceHighlighter forVariableName: variableName
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
