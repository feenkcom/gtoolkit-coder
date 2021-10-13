Class {
	#name : #GtCoderRenameMethodChange,
	#superclass : #RBRefactoryChange,
	#instVars : [
		'methodCoder',
		'newSelector',
		'oldSelector'
	],
	#category : 'GToolkit-Coder-Refactoring'
}

{ #category : #private }
GtCoderRenameMethodChange >> executeNotifying: aBlock [ 
	| undo |
	undo := self class new
		methodCoder: self methodCoder;
		newSelector: self oldSelector;
		oldSelector: self newSelector.

	undo name: self name.

	self primitiveExecute.

	aBlock value.
	^ undo
]

{ #category : #accessing }
GtCoderRenameMethodChange >> methodCoder [
	^ methodCoder
]

{ #category : #accessing }
GtCoderRenameMethodChange >> methodCoder: anObject [
	methodCoder := anObject
]

{ #category : #accessing }
GtCoderRenameMethodChange >> newSelector [
	^ newSelector
]

{ #category : #accessing }
GtCoderRenameMethodChange >> newSelector: anObject [
	newSelector := anObject
]

{ #category : #accessing }
GtCoderRenameMethodChange >> oldSelector [
	^ oldSelector
]

{ #category : #accessing }
GtCoderRenameMethodChange >> oldSelector: anObject [
	oldSelector := anObject
]

{ #category : #private }
GtCoderRenameMethodChange >> primitiveExecute [
	methodCoder selector: self newSelector
]

{ #category : #accessing }
GtCoderRenameMethodChange >> renameChangesForClass: oldClassName to: newClassName [
	
]
