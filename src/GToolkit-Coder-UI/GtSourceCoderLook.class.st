Class {
	#name : #GtSourceCoderLook,
	#superclass : #BrLook,
	#category : #'GToolkit-Coder-UI-Coder - Source Look'
}

{ #category : #'private - accessing' }
GtSourceCoderLook >> coder [
	self
		deprecated: 'Please use #sourceCoderUIModel instead'
		transformWith: '`@receiver coder' -> '`@receiver sourceCoderUIModel'.
		
	^ self sourceCoderUIModel
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

{ #category : #'private - accessing' }
GtSourceCoderLook >> sourceCoderUIModel [
	<return: #GtSourceCoderUIModel>

	^ (self request: GtSourceCoderContentCoderRequest oneWay) sourceCoder
]
