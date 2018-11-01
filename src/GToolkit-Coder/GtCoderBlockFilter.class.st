Class {
	#name : #GtCoderBlockFilter,
	#superclass : #GtCoderMethodsFilter,
	#instVars : [
		'block'
	],
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #'instance creation' }
GtCoderBlockFilter class >> forBlock: aBlock [
	^ self new
		block: aBlock;
		yourself
]

{ #category : #accessing }
GtCoderBlockFilter >> block [
	^ block
]

{ #category : #accessing }
GtCoderBlockFilter >> block: aBlock [
	block := aBlock
]

{ #category : #testing }
GtCoderBlockFilter >> includeMethod: aCompiledMethod [
	^ block value: aCompiledMethod
]
