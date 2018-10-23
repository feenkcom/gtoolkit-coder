Class {
	#name : #GtCoderBehaviorMethodFilter,
	#superclass : #GtCoderMethodsFilter,
	#instVars : [
		'class'
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
	^ aCompiledMethod methodClass includesBehavior: class
]
