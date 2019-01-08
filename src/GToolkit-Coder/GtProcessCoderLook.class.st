Class {
	#name : #GtProcessCoderLook,
	#superclass : #BrLook,
	#instVars : [
		'methodsCoder'
	],
	#category : #'GToolkit-Coder-Looks'
}

{ #category : #initialization }
GtProcessCoderLook >> initializeLook [
	super initializeLook.
	self widget layout: BlLinearLayout horizontal
]

{ #category : #accessing }
GtProcessCoderLook >> methodsCoder [
	^ methodsCoder
]

{ #category : #accessing }
GtProcessCoderLook >> methodsCoder: processCoder [
	methodsCoder := processCoder
]
