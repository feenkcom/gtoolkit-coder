"
I am fired by inner coders to tell {{gtClass:GtCoder}} to spawn a new coder using {{gtClass:GtPhlowObjectToSpawn}}


"
Class {
	#name : #GtCoderToSpawn,
	#superclass : #BlEvent,
	#instVars : [
		'coder'
	],
	#category : #'GToolkit-Coder-UI-! Core'
}

{ #category : #accessing }
GtCoderToSpawn >> coder [
	<return: #GtCoderModel>

	^ coder
]

{ #category : #accessing }
GtCoderToSpawn >> coder: aGtCoderModel [
	coder := aGtCoderModel
]
