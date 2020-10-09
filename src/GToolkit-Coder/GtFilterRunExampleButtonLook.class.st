"
I am an abstract class.
I am a ${class:BrLook}$.
I provide common behavior to update a ${class:BrButton}$ visual apperance based on ${class:GtMethodsCoder}$ and ${class:GtExampleWithResult}$ changes. See my ${method:GtFilterRunExampleButtonLook>>#subscribeToCoder|label=subscriptions}$ for more details.
Look at my ${class:GtFilterRunExampleButtonLook|show=#gtSubclassesFor:|expanded=true|height=150}$ for more details and examples:
"
Class {
	#name : #GtFilterRunExampleButtonLook,
	#superclass : #BrLook,
	#instVars : [
		'coder',
		'mutex',
		'isUpdateRequested'
	],
	#category : #'GToolkit-Coder-Filters - UI'
}

{ #category : #'api - accessing' }
GtFilterRunExampleButtonLook >> coder [
	<return: #GtMethodsCoder>
	^ coder
]

{ #category : #'api - accessing' }
GtFilterRunExampleButtonLook >> coder: aGtFilteredMethodsCoder [
	coder = aGtFilteredMethodsCoder ifTrue: [ ^ self ].
	self unsubscribeFromCoder.
	coder := aGtFilteredMethodsCoder.
	self subscribeToCoder.
	self onCoderChanged.
]

{ #category : #'private - accessing' }
GtFilterRunExampleButtonLook >> coderDo: aBlock [
	self coder ifNotNil: aBlock
]

{ #category : #'private - updating' }
GtFilterRunExampleButtonLook >> enqueueUpdate [
	self widgetDo: [ :aWidget | 
		aWidget enqueueTask: (BlTaskAction new action: [
			self updateWidget ]) ].
]

{ #category : #'private - accessing' }
GtFilterRunExampleButtonLook >> exampler [
	<return: #GtCoderExampler>
	^ self coder exampler
]

{ #category : #'private - accessing' }
GtFilterRunExampleButtonLook >> examplerDo: aBlock [
	self coderDo: [ :aCoder |
		aBlock cull: aCoder exampler ]
]

{ #category : #initialization }
GtFilterRunExampleButtonLook >> initialize [
	super initialize.
	isUpdateRequested := false.
	mutex := Mutex new.
]

{ #category : #initialization }
GtFilterRunExampleButtonLook >> initializeIconElement: anElement [
	anElement
		geometry: BlCircle new;
		margin: (BlInsets all: 1);
		size: 8 @ 8.
]

{ #category : #'private - hooks' }
GtFilterRunExampleButtonLook >> onCoderChanged [
]

{ #category : #'private - announcement handling' }
GtFilterRunExampleButtonLook >> onCoderChanged: aGtCodersCodersChanged [
]

{ #category : #'private - announcement handling' }
GtFilterRunExampleButtonLook >> onExampleExecuted: aGtCoderExampleExecuted [
]

{ #category : #'api - hooks' }
GtFilterRunExampleButtonLook >> onUninstalledIn: anElement [
	super onUninstalledIn: anElement.
	mutex critical: [ 
		isUpdateRequested := false ].
]

{ #category : #'private - updating' }
GtFilterRunExampleButtonLook >> postponeUpdate [
	self widgetDo: [ :aWidget | 
		mutex critical: [ 
			isUpdateRequested ifTrue: [ ^ self ].
			isUpdateRequested := true ].
		BlUseAsyncFeatures 
			ifEnabledDo: [ 
				BlTaskAtQueue default
					schedule: [ self enqueueUpdate ]
					at: self postponedTime ]
			otherwise: [ 
				self updateNow ] ]
]

{ #category : #'private - updating' }
GtFilterRunExampleButtonLook >> postponedTime [
	| aNow |
	self widgetDo: [ :aWidget | 
		aNow := aWidget space 
			ifNotNil: [ :aSpace | aSpace time now ] 
			ifNil: [ BlTime real now ] ].
	aNow ifNil: [ aNow := BlTime real now ].
	^ aNow + 300 milliSeconds.
]

{ #category : #'private - subscriptions' }
GtFilterRunExampleButtonLook >> subscribeToCoder [
	self coder weak
		when: GtCoderExampleExecuted
		send: #onExampleExecuted:
		to: self.
	self coder weak
		when: GtCodersCoderAdded , GtCodersCoderRemoved , GtCodersCodersChanged, GtCoderSourceCodeChanged
		send: #onCoderChanged: 
		to: self
]

{ #category : #'private - subscriptions' }
GtFilterRunExampleButtonLook >> unsubscribeFromCoder [
	self coder ifNil: [ ^ self ].
	self coder unsubscribe: self.
]

{ #category : #'private - updating' }
GtFilterRunExampleButtonLook >> updateNow [
	mutex critical: [ 
		isUpdateRequested := false ].
	self updateWidget.
]

{ #category : #'private - updating' }
GtFilterRunExampleButtonLook >> updateWidget [
	"Subclasses may perform update actions.
	I should be called from a UI process."
]
