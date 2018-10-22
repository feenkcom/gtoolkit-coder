Class {
	#name : #GtCoderInstanceVariableReferenceFilter,
	#superclass : #GtCoderMethodsFilter,
	#instVars : [
		'class',
		'variableName'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #'instance creation' }
GtCoderInstanceVariableReferenceFilter class >> forClass: aClass andVariable: aString [
	^ self new
		forClass: aClass andVariable: aString;
		yourself
]

{ #category : #'initialize-release' }
GtCoderInstanceVariableReferenceFilter >> forClass: aClass andVariable: aString [
	class := aClass.
	variableName := aString
]

{ #category : #accessing }
GtCoderInstanceVariableReferenceFilter >> highlighter [
	^ GtVariableReferenceHighlighter forVariableName: variableName
]

{ #category : #testing }
GtCoderInstanceVariableReferenceFilter >> includeMethod: aCompiledMethod [
	| index |
	(aCompiledMethod methodClass includesBehavior: class)
		ifFalse: [ ^ false ].
	index := class instVarIndexFor: variableName ifAbsent: [ ^ false ].
	^ (aCompiledMethod readsField: index) or: [ aCompiledMethod writesField: index ]
]
