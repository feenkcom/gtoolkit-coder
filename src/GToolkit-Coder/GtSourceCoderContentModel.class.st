Class {
	#name : #GtSourceCoderContentModel,
	#superclass : #BrWidgetModel,
	#instVars : [
		'sourceCoder'
	],
	#category : #'GToolkit-Coder-UI - Source Coder'
}

{ #category : #initialization }
GtSourceCoderContentModel >> initializeListeners [
	super initializeListeners.
	
	self when: GtSourceCoderContentCoderRequest reply: [ :aResponse | aResponse sourceCoder: self sourceCoder ]
]

{ #category : #'private - notifying' }
GtSourceCoderContentModel >> notifySourceCoderChanged: aGtSourceCoder [
	self dispatchEvent: (GtSourceCoderContentCoderChanged new sourceCoder: aGtSourceCoder)
]

{ #category : #accessing }
GtSourceCoderContentModel >> sourceCoder [
	^ sourceCoder
]

{ #category : #accessing }
GtSourceCoderContentModel >> sourceCoder: aGtSourceCoder [
	sourceCoder := aGtSourceCoder.
	self notifySourceCoderChanged: aGtSourceCoder
]
