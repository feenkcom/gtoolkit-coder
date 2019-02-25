Class {
	#name : #GtSystemS1RootClassC1,
	#superclass : #Object,
	#instVars : [
		'attributeInSuperclass'
	],
	#category : #'GToolkit-Coder-Examples-SystemS1'
}

{ #category : #accessing }
GtSystemS1RootClassC1 >> methodAccessingAttributeInS1C1 [
	^ attributeInSuperclass
]

{ #category : #accessing }
GtSystemS1RootClassC1 >> methodAccessingNilAnd42: aParameter [
	aParameter = 42 
		ifTrue: [ ^ nil ]
]

{ #category : #actions }
GtSystemS1RootClassC1 >> methodOverridenInSubclass [
]

{ #category : #accessing }
GtSystemS1RootClassC1 >> methodWritingAttributeInS1C1 [
	attributeInSuperclass := 42
]
