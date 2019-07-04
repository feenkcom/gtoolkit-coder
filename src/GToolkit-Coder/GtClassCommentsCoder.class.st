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

{ #category : #elements }
GtClassCommentsCoder >> elementClass [
	^ GtMethodsCoderElement
]

{ #category : #'instance creation' }
GtClassCommentsCoder >> forClass: aBehavior [
	self flag: 'FIXME should listen class definition change'.
	class := aBehavior.
	self forItems: {class}
]

{ #category : #'instance creation' }
GtClassCommentsCoder >> newCoderFor: aBehavior [
	self flag: 'FIXME use other element'.
	^ GtMethodCoder forMethod: ProtoObject >> #initialize
]
