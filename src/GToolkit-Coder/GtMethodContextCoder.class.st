Class {
	#name : #GtMethodContextCoder,
	#superclass : #GtMethodCoder,
	#instVars : [
		'context'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #'instance creation' }
GtMethodContextCoder class >> forContext: aContext [
	^ (self forMethod: aContext method)
		context: aContext;
		object: aContext receiver;
		yourself
]

{ #category : #accessing }
GtMethodContextCoder >> context [
	^ context
]

{ #category : #accessing }
GtMethodContextCoder >> context: aContext [
	context := aContext
]
