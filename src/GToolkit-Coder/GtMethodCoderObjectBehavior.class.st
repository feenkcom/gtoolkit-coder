Class {
	#name : #GtMethodCoderObjectBehavior,
	#superclass : #GtMethodCoderBehavior,
	#instVars : [
		'object',
		'customBehavior'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #accessing }
GtMethodCoderObjectBehavior >> customBehavior [
	^ customBehavior
]

{ #category : #accessing }
GtMethodCoderObjectBehavior >> customBehavior: anObject [
	customBehavior := anObject
]

{ #category : #testing }
GtMethodCoderObjectBehavior >> exists [
	"Return true if there is a real Behavior in the system corresponding to my definition"
	<return: #Boolean>
	
	(self hasCustomBehavior and: [ self customBehavior isObsolete ])
		ifTrue: [ ^ false ].

	self object class isObsolete
		ifTrue: [ ^ false ].

	^ true
]

{ #category : #testing }
GtMethodCoderObjectBehavior >> hasCustomBehavior [
	^ customBehavior notNil
]

{ #category : #accessing }
GtMethodCoderObjectBehavior >> object [
	^ object
]

{ #category : #accessing }
GtMethodCoderObjectBehavior >> object: anObject [
	self
		assert: [ object isNil ]
		description: [ 'I am immutable and can not be changed' ].

	object := anObject
]
