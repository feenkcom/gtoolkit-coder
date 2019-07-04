Class {
	#name : #GtClassCommentsCoder,
	#superclass : #GtCoders,
	#instVars : [
		'class'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #'instance creation' }
GtClassCommentsCoder class >> forClass: aClass [
	^ self new
		forClass: aClass instanceSide;
		yourself
]

{ #category : #'instance creation' }
GtClassCommentsCoder >> newCoderFor: aBehavior [
	self flag: 'FIXME use other element'.
	^ GtMethodCoder
		forMethod: (aBehavior instanceSide lookupSelector: #initialize)
]
