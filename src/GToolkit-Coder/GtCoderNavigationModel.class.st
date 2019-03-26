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
GtCoderNavigationModel >> selectInCoderCategory: categoryToSelect [
	self flag: 'Remove combine the two class coders into one'.
	self coderModel classCoder methodsCoder categoryFilterString: categoryToSelect
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
