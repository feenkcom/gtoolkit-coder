Class {
	#name : #GtClassCommentCoder,
	#superclass : #GtSourceCoder,
	#instVars : [
		'class'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #'as yet unclassified' }
GtClassCommentCoder class >> forClass: aClass [
	^ self new
		theClass: aClass;
		yourself
]

{ #category : #'initialize-release' }
GtClassCommentCoder >> initializeAddOns [
	super initializeAddOns.
	addOns
		addMainAction: 'Save' translated
		icon: BrGlamorousIcons accept
		action: [ class comment: self source  ].
	addOns clearChanges
]

{ #category : #testing }
GtClassCommentCoder >> isModified [
	^ class comment ~= self source
]

{ #category : #updating }
GtClassCommentCoder >> newRbAST: aString [
	self
		flag:
			'FIXME well, a comment is not source code, should just be expander with coder look'.
	^ nil
]

{ #category : #accessing }
GtClassCommentCoder >> theClass [
	^ class
]

{ #category : #accessing }
GtClassCommentCoder >> theClass: anObject [
	class := anObject.
	self source: class comment
]
