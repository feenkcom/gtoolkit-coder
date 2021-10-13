Class {
	#name : #GtSearchBlockFilter,
	#superclass : #GtSearchFilter,
	#instVars : [
		'block'
	],
	#category : 'GToolkit-Coder-Filters'
}

{ #category : #'instance creation' }
GtSearchBlockFilter class >> forBlock: aBlock [
	^ self new
		block: aBlock;
		yourself
]

{ #category : #accessing }
GtSearchBlockFilter >> block [
	^ block
]

{ #category : #accessing }
GtSearchBlockFilter >> block: aBlock [
	block := aBlock
]

{ #category : #testing }
GtSearchBlockFilter >> matches: anObject [
	^ block value: anObject
]
