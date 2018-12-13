Class {
	#name : #GtCoderImplementorsFilter,
	#superclass : #GtCoderMethodsFilter,
	#instVars : [
		'selector'
	],
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #'instance creation' }
GtCoderImplementorsFilter class >> selector: aSymbol [
	^ self new
		selector: aSymbol;
		yourself
]

{ #category : #ui }
GtCoderImplementorsFilter >> gtDisplayOn: stream [
	stream
		nextPutAll: self selector printString;
		nextPutAll: ' implementors'
]

{ #category : #accessing }
GtCoderImplementorsFilter >> highlighter [
	^ GtImplementorHighlighter forSelector: selector
]

{ #category : #testing }
GtCoderImplementorsFilter >> includeMethod: aCompiledMethod [
	^ aCompiledMethod selector = selector
]

{ #category : #ui }
GtCoderImplementorsFilter >> printOn: stream [
	stream 
		nextPutAll: self selector printString; 
		nextPutAll: ' gtImplementors'
]

{ #category : #accessing }
GtCoderImplementorsFilter >> selector [
	^ selector
]

{ #category : #accessing }
GtCoderImplementorsFilter >> selector: aSymbol [
	selector := aSymbol
]
