Class {
	#name : #GtSourceCoderAptitude,
	#superclass : #BrAptitude,
	#category : #'GToolkit-Coder-UI-Coder - Source Look'
}

{ #category : #'private - accessing' }
GtSourceCoderAptitude >> coder [
	self
		deprecated: 'Please use #sourceCoderUIModel instead'
		transformWith: '`@receiver coder' -> '`@receiver sourceCoderUIModel'.
		
	^ self sourceCoderUIModel
]

{ #category : #initialization }
GtSourceCoderAptitude >> initializeListeners [
	super initializeListeners.
	
	self when: GtSourceCoderContentCoderChanged do: [ :anEvent |
		anEvent sourceCoder
			ifNotNil: [ :aSourceCoder | self onCoderChanged: aSourceCoder ] ]
]

{ #category : #initialization }
GtSourceCoderAptitude >> initializeRequests [
	super initializeRequests.
	
	self request: GtSourceCoderContentCoderRequest new
]

{ #category : #hooks }
GtSourceCoderAptitude >> onCoderChanged: aGtSourceCoder [
]

{ #category : #'private - accessing' }
GtSourceCoderAptitude >> sourceCoderUIModel [
	<return: #GtSourceCoderViewModel>

	^ (self request: GtSourceCoderContentCoderRequest oneWay) sourceCoder
]
