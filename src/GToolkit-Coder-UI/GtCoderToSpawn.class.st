"
I am fired by inner coders to tell ${class:GtCoder}$ to spawn a new coder using ${class:GtPhlowObjectToSpawn}$
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
