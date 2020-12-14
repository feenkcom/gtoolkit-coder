"
I am sent by a ${class:GtSourceCoder}$ when the text should be restyled due to potential environmental changes (not due to text changes).
One of the usecases is to restyle the text after execution of a ==gtExample==
"
Class {
	#name : #GtCoderStyleTextRequest,
	#superclass : #GtSourceCoderAnnouncement,
	#instVars : [
		'afterAction'
	],
	#category : #'GToolkit-Coder-Event'
}

{ #category : #accessing }
GtCoderStyleTextRequest >> afterAction [
	^ afterAction ifNil: [ [  ] ]
]

{ #category : #accessing }
GtCoderStyleTextRequest >> afterAction: aBlock [
	afterAction := aBlock
]
