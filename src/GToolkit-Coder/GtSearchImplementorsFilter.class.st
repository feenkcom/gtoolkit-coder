Class {
	#name : #GtSearchImplementorsFilter,
	#superclass : #GtSearchMethodsFilter,
	#instVars : [
		'selector'
	],
	#category : #'GToolkit-Coder-Filters2'
}

{ #category : #'instance creation' }
GtSearchImplementorsFilter class >> selector: aSymbol [
	^ self new
		selector: aSymbol;
		yourself
]

{ #category : #ui }
GtSearchImplementorsFilter >> gtDisplayOn: stream [
	stream
		nextPutAll: self selector printString;
		nextPutAll: ' implementors'
]

{ #category : #accessing }
GtSearchImplementorsFilter >> highlighter [
	^ GtImplementorHighlighter forSelector: selector
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
