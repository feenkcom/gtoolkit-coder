Class {
	#name : #GtSourceCoderContentModel,
	#superclass : #BrWidgetModel,
	#instVars : [
		'sourceCoder'
	],
	#category : #'GToolkit-Coder-UI-Coder - Source'
}

{ #category : #initialization }
GtSourceCoderContentModel >> initializeListeners [
	super initializeListeners.
	
	self when: GtSourceCoderContentCoderRequest reply: [ :aResponse | aResponse sourceCoder: self sourceCoder ]
]

{ #category : #'private - notifying' }
GtSourceCoderContentModel >> notifySourceCoderChanged: aGtSourceCoderUIModel [
	self dispatchEvent: (GtSourceCoderContentCoderChanged new sourceCoder: aGtSourceCoderUIModel)
]

{ #category : #accessing }
GtSourceCoderContentModel >> sourceCoder [
	<return: #GtSourceCoderUIModel>

	^ sourceCoder
]

{ #category : #accessing }
GtSourceCoderContentModel >> sourceCoder: aGtSourceCoderUIModel [
	self
		assert: [ aGtSourceCoderUIModel isKindOf: GtSourceCoderUIModel ]
		description: [ 'Should be a Source Coder UI Model' ].

	sourceCoder := aGtSourceCoderUIModel.
	self notifySourceCoderChanged: aGtSourceCoderUIModel
]
