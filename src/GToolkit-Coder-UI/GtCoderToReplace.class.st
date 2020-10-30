"
I am fired by inner coders to tell ${class:GtCoder}$ to replace its current coder with the one requested by me
"
Class {
	#name : #GtCoderToReplace,
	#superclass : #BlEvent,
	#instVars : [
		'coder'
	],
	#category : #'GToolkit-Coder-UI-! Core'
}

{ #category : #accessing }
GtCoderToReplace >> coder [
	<return: #GtCoderModel>

	^ coder
]

{ #category : #accessing }
GtCoderToReplace >> coder: aGtCoderModel [
	coder := aGtCoderModel
]
