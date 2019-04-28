Class {
	#name : #GtSystemS1SubclassC2,
	#superclass : #GtSystemS1RootClassC1,
	#instVars : [
		'attributeInC2'
	],
	#classInstVars : [
		'aClassSideInstanceVariable'
	],
	#category : #'GToolkit-Coder-Examples-SystemS1'
}

{ #category : #accessing }
GtSystemS1SubclassC2 class >> methodAccessingVariableClassSideOfC2S1 [
	^ aClassSideInstanceVariable
]

{ #category : #accessing }
GtSystemS1SubclassC2 class >> methodWrittingVariableClassSideOfC2S1 [
	aClassSideInstanceVariable := 'new value'
]

{ #category : #actions }
GtSystemS1SubclassC2 class >> stubMethodOnClassSideOfC2S1 [
]

{ #category : #actions }
GtSystemS1SubclassC2 >> methodOverridenInSubclass [
	
]

{ #category : #actions }
GtSystemS1SubclassC2 >> stubMethodInClassC2S1 [
]
