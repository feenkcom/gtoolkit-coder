Class {
	#name : #GtFilterVirtualExceptionModel,
	#superclass : #GtFilterModel,
	#instVars : [
		'exception'
	],
	#category : #'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #accessing }
GtFilterVirtualExceptionModel >> exception [
	^ exception
]

{ #category : #accessing }
GtFilterVirtualExceptionModel >> exception: anException [
	| anExceptionCopy |
	anExceptionCopy := GtSystemUtility freeze: anException.

	exception := anExceptionCopy
]

{ #category : #testing }
GtFilterVirtualExceptionModel >> isExceptionFilterModel [
	^ true
]

{ #category : #testing }
GtFilterVirtualExceptionModel >> isVirtualFilterModel [
	^ true
]

{ #category : #accessing }
GtFilterVirtualExceptionModel >> name [
	^ 'exception'
]
