Class {
	#name : #GtCoderNavigationModel,
	#superclass : #Object,
	#instVars : [
		'coderModel'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #accessing }
GtCoderNavigationModel >> coderModel [
	^ coderModel
]

{ #category : #accessing }
GtCoderNavigationModel >> coderModel: aCoderModel [
	coderModel := aCoderModel
]

{ #category : #accessing }
GtCoderNavigationModel >> displayPosition [
	self subclassResponsibility
]

{ #category : #actions }
GtCoderNavigationModel >> selectInCoderClass: classToSelect [
	classToSelect ~= self theClass ifTrue: [ 
		self coderModel selectClass: classToSelect ]
]

{ #category : #accessing }
GtCoderNavigationModel >> theClass [ 
	^ coderModel theClass
]
