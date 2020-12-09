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
	#category : #'GToolkit-Coder-UI-Filters'
}

{ #category : #'private - updating' }
GtFilterRunExampleButtonLook >> beUpdateRequestedIfDoneEarlierDo: aBlock [
	mutex critical: [ 
		self isUpdateRequested ifTrue: aBlock.
		isUpdateRequested := true. ]
]

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
	self widgetAndCoderDo: [ :aWidget :aCoder | 
		aWidget enqueueTask: (BlTaskAction new action: [
			self updateNow ]) ].
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

{ #category : #'private - testing' }
GtFilterRunExampleButtonLook >> isUpdateRequested [
	<return: #Boolean>
	^ isUpdateRequested
]

{ #category : #'api - hooks' }
GtFilterRunExampleButtonLook >> onAttachedTo: anElement [
	super onAttachedTo: anElement.

	self postponeUpdate.
]

{ #category : #'private - hooks' }
GtFilterRunExampleButtonLook >> onCoderChanged [
	"We expect that the Coder is changed just once before the look is attached."
	self beUpdateRequestedIfDoneEarlierDo: [ ^ self ].
	self updateNow.
]

{ #category : #'private - announcement handling' }
GtFilterRunExampleButtonLook >> onCoderChanged: aGtCodersCodersChanged [
	self postponeUpdate.
]

{ #category : #'private - announcement handling' }
GtFilterRunExampleButtonLook >> onExampleExecuted: aGtCoderExampleExecuted [
	self postponeUpdate.
]

{ #category : #'api - hooks' }
GtFilterRunExampleButtonLook >> onUninstalledIn: anElement [
	super onUninstalledIn: anElement.
	self resetUpdateRequested.
]

{ #category : #'private - updating' }
GtFilterRunExampleButtonLook >> postponeUpdate [
	self widgetAndCoderDo: [ :aWidget :aCoder | 
		self beUpdateRequestedIfDoneEarlierDo: [ ^ self ].
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

{ #category : #'private - updating' }
GtFilterRunExampleButtonLook >> resetUpdateRequested [
	mutex critical: [ 
		isUpdateRequested := false ].
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
	self coderDo: [ :aCoder |
		aCoder unsubscribe: self ].
]

{ #category : #'private - updating' }
GtFilterRunExampleButtonLook >> updateNow [
	self resetUpdateRequested.
	self updateWidget.
]

{ #category : #'private - updating' }
GtFilterRunExampleButtonLook >> updateWidget [
	"Subclasses may perform update actions.
	I should be called from a UI process."
]

{ #category : #'private - accessing' }
GtFilterRunExampleButtonLook >> widgetAndCoderDo: aTwoArgBlock [
	self widgetDo: [ :aWidget | 
		self coderDo: [ :aCoder |
			aTwoArgBlock cull: aWidget cull: aCoder ] ]
]
