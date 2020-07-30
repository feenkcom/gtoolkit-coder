Class {
	#name : #GtTaggerChangeTagType,
	#superclass : #BrTaggerRequest,
	#instVars : [
		'tag'
	],
	#category : #'GToolkit-Coder-Filters - UI'
}

{ #category : #accessing }
GtTaggerChangeTagType >> tag [
	^ tag
]

{ #category : #accessing }
GtTaggerChangeTagType >> tag: anObject [
	tag := anObject
]
