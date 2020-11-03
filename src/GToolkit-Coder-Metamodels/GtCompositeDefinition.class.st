Class {
	#name : #GtCompositeDefinition,
	#superclass : #GtCodeDefinition,
	#instVars : [
		'definitions'
	],
	#category : #'GToolkit-Coder-Metamodels-Behavior - Definitions'
}

{ #category : #'instance creation' }
GtCompositeDefinition class >> empty [
	^ self new
]

{ #category : #accessing }
GtCompositeDefinition >> all [
	<return: #Collection of: #GtCodeDefinition>

	^ definitions
]

{ #category : #accessing }
GtCompositeDefinition >> at: anIndex [
	<return: #GtCodeDefinition>

	^ definitions at: anIndex
]

{ #category : #enumerating }
GtCompositeDefinition >> collect: aBlock [
	^ definitions collect: aBlock
]

{ #category : #'private - accessing' }
GtCompositeDefinition >> definitionNamed: aSymbol ifNone: anExceptionBlock [
	<return: #GtCodeDefinition>
	
	^ definitions
		detect: [ :eachDefinition | eachDefinition name = aSymbol asSymbol ]
		ifNone: anExceptionBlock
]

{ #category : #enumerating }
GtCompositeDefinition >> do: aBlock [
	definitions do: aBlock
]

{ #category : #'private - testing' }
GtCompositeDefinition >> hasDefinitionNamed: aSymbol [
	<return: #Boolean>

	^ definitions
		detect: [ :eachDefinition | eachDefinition name = aSymbol ]
		ifFound: [ true ]
		ifNone: [ false ]
]

{ #category : #initialization }
GtCompositeDefinition >> initialize [
	super initialize.
	
	definitions := #()
]

{ #category : #accessing }
GtCompositeDefinition >> isEmpty [
	<return: #Boolean>

	^ self size isZero
]

{ #category : #accessing }
GtCompositeDefinition >> names [
	<return: #Collection of: #Symbol>
	
	^ definitions collect: [ :eachDefinition | eachDefinition name ]
]

{ #category : #accessing }
GtCompositeDefinition >> parent: aParent [
	super parent: aParent.
	
	definitions do: [ :eachDefinition | eachDefinition parent: aParent ]
]

{ #category : #accessing }
GtCompositeDefinition >> size [
	<return: #Number>

	^ definitions size
]
