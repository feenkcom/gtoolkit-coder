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

{ #category : #testing }
GtCoderImplementorsFilter >> includeMethod: aCompiledMethod [
	^ aCompiledMethod selector = selector
]

{ #category : #accessing }
GtCoderImplementorsFilter >> selector [
	^ selector
]

{ #category : #accessing }
GtCoderImplementorsFilter >> selector: aSymbol [
	selector := aSymbol
]
