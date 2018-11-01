Class {
	#name : #GtCoderInstanceVariableReferenceFilter,
	#superclass : #GtCoderBehaviorMethodFilter,
	#instVars : [
		'variableName'
	],
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #'instance creation' }
GtCoderInstanceVariableReferenceFilter class >> forClass: aClass andVariable: aString [
	^ self new
		forClass: aClass andVariable: aString;
		yourself
]

{ #category : #'initialize-release' }
GtCoderInstanceVariableReferenceFilter >> forClass: aClass andVariable: aString [
	self forClass: aClass.
	variableName := aString
]

{ #category : #accessing }
GtCoderInstanceVariableReferenceFilter >> highlighter [
	^ GtVariableReferenceHighlighter forVariableName: variableName
]

{ #category : #testing }
GtCoderInstanceVariableReferenceFilter >> includeMethod: aCompiledMethod [
	| index |
	(super includeMethod: aCompiledMethod)
		ifFalse: [ ^ false ].
	index := class instVarIndexFor: variableName ifAbsent: [ ^ false ].
	^ (aCompiledMethod readsField: index) or: [ aCompiledMethod writesField: index ]
]

{ #category : #'initialize-release' }
GtCoderInstanceVariableReferenceFilter >> initialize [
	super initialize.
	includeSubclasses := true
]
