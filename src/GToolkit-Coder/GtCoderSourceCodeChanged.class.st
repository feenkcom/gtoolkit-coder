"
Is sent when a coder is rebuilt with a completely new source code it is not when user types
"
Class {
	#name : #GtCoderSourceCodeChanged,
	#superclass : #GtCoderAnnouncement,
	#instVars : [
		'updateStragegy'
	],
	#category : #'GToolkit-Coder-Event'
}

{ #category : #accessing }
GtCoderSourceCodeChanged >> updateStragegy [
	^ updateStragegy
]

{ #category : #accessing }
GtCoderSourceCodeChanged >> updateStragegy: anUpdateStragegy [
	updateStragegy := anUpdateStragegy
]
