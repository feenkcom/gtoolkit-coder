Class {
	#name : #GtCoderRenameMethodRefactoring,
	#superclass : #GtRBRenameMethodRefactoring,
	#instVars : [
		'methodCoder'
	],
	#category : #'GToolkit-Coder-Refactoring'
}

{ #category : #accessing }
GtCoderRenameMethodRefactoring >> methodCoder [
	^ methodCoder
]

{ #category : #accessing }
GtCoderRenameMethodRefactoring >> methodCoder: anObject [
	methodCoder := anObject
]

{ #category : #transforming }
GtCoderRenameMethodRefactoring >> transform [
	self changes addChange: (GtCoderRenameMethodChange new
		methodCoder: self methodCoder;
		newSelector: newSelector;
		oldSelector: oldSelector).
	super transform.
]
