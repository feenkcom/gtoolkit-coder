Class {
	#name : #GtSearchImplementorsFilter,
	#superclass : #GtSearchMethodsFilter,
	#instVars : [
		'selector'
	],
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #'instance creation' }
GtSearchImplementorsFilter class >> selector: aSymbol [
	^ self new
		selector: aSymbol;
		yourself
]

{ #category : #comparing }
GtSearchImplementorsFilter >> = anObject [
	^ self class = anObject class
		and: [ self selector = anObject selector ]
]

{ #category : #ui }
GtSearchImplementorsFilter >> gtDisplayOn: stream [
	stream
		nextPutAll: self selector printString;
		nextPutAll: ' implementors'
]

{ #category : #comparing }
GtSearchImplementorsFilter >> hash [
	^ self class hash bitXor: self selector hash
]

{ #category : #testing }
GtSearchImplementorsFilter >> includesMethod: aCompiledMethod [
	^ aCompiledMethod selector = selector
]

{ #category : #ui }
GtSearchImplementorsFilter >> printOn: stream [
	stream 
		nextPutAll: self selector printString; 
		nextPutAll: ' gtImplementors'
]

{ #category : #accessing }
GtSearchImplementorsFilter >> selector [
	^ selector
]

{ #category : #accessing }
GtSearchImplementorsFilter >> selector: aSymbol [
	selector := aSymbol
]
