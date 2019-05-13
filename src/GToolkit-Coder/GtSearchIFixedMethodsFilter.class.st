Class {
	#name : #GtSearchIFixedMethodsFilter,
	#superclass : #GtSearchMethodsFilter,
	#instVars : [
		'methods'
	],
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #accessing }
GtSearchIFixedMethodsFilter >> defaultFilterScope [
	^ self
]

{ #category : #testing }
GtSearchIFixedMethodsFilter >> includesMethod: aCompiledMethod [
	^ self methods includes: aCompiledMethod
]

{ #category : #enumerating }
GtSearchIFixedMethodsFilter >> itemsDo: aBlock [
	^ self methodsDo: aBlock
]

{ #category : #accessing }
GtSearchIFixedMethodsFilter >> methods [
	^ methods ifNil: [ methods := OrderedCollection new ]
]

{ #category : #accessing }
GtSearchIFixedMethodsFilter >> methods: anOrderedCollection [
	methods := anOrderedCollection
]

{ #category : #enumerating }
GtSearchIFixedMethodsFilter >> methodsDo: aBlock [
	self methods do: aBlock.
]
