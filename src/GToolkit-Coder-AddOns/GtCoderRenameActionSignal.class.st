Class {
	#name : #GtCoderRenameActionSignal,
	#superclass : #ContextStackSignal,
	#instVars : [
		'action'
	],
	#category : #'GToolkit-Coder-AddOns-Signals'
}

{ #category : #accessing }
GtCoderRenameActionSignal >> action [
	^ action
]

{ #category : #accessing }
GtCoderRenameActionSignal >> action: anObject [
	action := anObject
]
