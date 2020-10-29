Class {
	#name : #GtSourceCoderLook,
	#superclass : #BrLook,
	#category : #'GToolkit-Coder-UI-Coder - Source Look'
}

{ #category : #'private - accessing' }
GtSourceCoderLook >> coder [
	<return: #GtCoderModel>
	^ self widget ifNotNil: #coder
]

{ #category : #initialization }
GtSourceCoderLook >> initializeListeners [
	super initializeListeners.
	
	self when: GtSourceCoderContentCoderChanged do: [ :anEvent |
		anEvent sourceCoder
			ifNotNil: [ :aSourceCoder | self onCoderChanged: aSourceCoder ] ]
]

{ #category : #initialization }
GtSourceCoderLook >> initializeRequests [
	super initializeRequests.
	
	self request: GtSourceCoderContentCoderRequest new
]

{ #category : #hooks }
GtSourceCoderLook >> onCoderChanged: aGtSourceCoder [
]
