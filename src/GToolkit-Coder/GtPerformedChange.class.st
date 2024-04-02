Class {
	#name : #GtPerformedChange,
	#superclass : #RBRefactoryChange,
	#instVars : [
		'change',
		'timestamp'
	],
	#category : #'GToolkit-Coder-Refactoring'
}

{ #category : #executing }
GtPerformedChange class >> onChange: aChange [
	^ self new
		timestamp: DateAndTime now;
		change: aChange;
		yourself
]

{ #category : #accessing }
GtPerformedChange >> change [
	^ change
]

{ #category : #accessing }
GtPerformedChange >> change: anObject [
	change := anObject
]

{ #category : #accessing }
GtPerformedChange >> executeNotifying: aBlock [
	^ change executeNotifying: aBlock
]

{ #category : #accessing }
GtPerformedChange >> gtChangesFor: aView [
	<gtView>
	(change respondsTo: #gtChangesFor:) ifFalse: [ ^ aView empty ].
	^ aView forward
		title: 'Changes';
		object: [ change ];
		view: #gtChangesFor:
]

{ #category : #accessing }
GtPerformedChange >> gtViewDefinitionFor: aView [
	<gtView>
	(change respondsTo: #gtViewDefinitionFor:) ifFalse: [ ^ aView empty ].
	^ aView forward
		title: 'Definition';
		object: [ change ];
		view: #gtViewDefinitionFor:
]

{ #category : #accessing }
GtPerformedChange >> renameChangesForClass: oldClassName to: newClassName [
	^ change renameChangesForClass: oldClassName to: newClassName
]

{ #category : #accessing }
GtPerformedChange >> timestamp [
	^ timestamp
]

{ #category : #accessing }
GtPerformedChange >> timestamp: anObject [
	timestamp := anObject
]
