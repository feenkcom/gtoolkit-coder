Class {
	#name : 'GtSearchNegationFilter',
	#superclass : 'GtSearchFilter',
	#instVars : [
		'originalFilter'
	],
	#category : 'GToolkit-Coder-Filters'
}

{ #category : 'accessing' }
GtSearchNegationFilter >> defaultFilterScope [
	^ originalFilter defaultFilterScope
]

{ #category : 'printing' }
GtSearchNegationFilter >> gtDisplayOn: stream [
	self originalFilter gtDisplayOn: stream.
	stream nextPutAll: ' not'
]

{ #category : 'testing' }
GtSearchNegationFilter >> matches: anObject [
	^ (self originalFilter matches: anObject) not
]

{ #category : 'accessing' }
GtSearchNegationFilter >> originalFilter [
	^ originalFilter
]

{ #category : 'accessing' }
GtSearchNegationFilter >> originalFilter: anObject [
	originalFilter := anObject
]

{ #category : 'printing' }
GtSearchNegationFilter >> printOn: stream [
	self originalFilter printOn: stream.
	stream nextPutAll: ' not'
]

{ #category : 'accessing' }
GtSearchNegationFilter >> resultType [
	^ originalFilter resultType
]
