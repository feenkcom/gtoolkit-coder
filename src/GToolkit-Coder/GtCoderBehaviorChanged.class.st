Class {
	#name : #GtCoderBehaviorChanged,
	#superclass : #GtSourceCoderAnnouncement,
	#instVars : [
		'newBehavior'
	],
	#category : #'GToolkit-Coder-Event'
}

{ #category : #accessing }
GtCoderBehaviorChanged >> newBehavior [
	^ newBehavior
]

{ #category : #accessing }
GtCoderBehaviorChanged >> newBehavior: aBehavior [
	newBehavior := aBehavior
]
