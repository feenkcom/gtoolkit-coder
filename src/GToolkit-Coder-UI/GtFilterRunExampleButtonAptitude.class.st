"
I am an abstract class.
I am a {{gtClass:BrLook}}.
I provide common behavior to update a {{gtClass:BrButton}} visual apperance based on {{gtClass:GtMethodsCoder}} and {{gtClass:GtExampleWithResult}} changes. See my {{gtMethod:GtFilterRunExampleButtonLook>>#subscribeToCoder|label=subscriptions}} for more details.
Look at my {{gtClass:GtFilterRunExampleButtonLook|show=#gtSubclassesFor:|expanded=true|height=150}} for more details and examples:


"
Class {
	#name : #GtFilterRunExampleButtonAptitude,
	#superclass : #BrAptitude,
	#instVars : [
		'coder',
		'mutex',
		'isUpdateRequested'
	],
	#category : #'GToolkit-Coder-UI-Filters'
}

{ #category : #'private - updating' }
GtFilterRunExampleButtonAptitude >> beUpdateRequestedIfDoneEarlierDo: aBlock [
	mutex critical: [ 
		self isUpdateRequested ifTrue: aBlock.
		isUpdateRequested := true. ]
]

{ #category : #'api - accessing' }
GtFilterRunExampleButtonAptitude >> coder [
	<return: #GtPharoMethodsCoder>
	^ coder
]

{ #category : #'api - accessing' }
GtFilterRunExampleButtonAptitude >> coder: aGtFilteredMethodsCoder [
	coder = aGtFilteredMethodsCoder ifTrue: [ ^ self ].
	self unsubscribeFromCoder.
	coder := aGtFilteredMethodsCoder.
	self subscribeToCoder.
	self onCoderChanged.
]

{ #category : #'private - accessing' }
GtFilterRunExampleButtonAptitude >> coderDo: aBlock [
	self coder ifNotNil: aBlock
]

{ #category : #'private - updating' }
GtFilterRunExampleButtonAptitude >> enqueueUpdate [
	self widgetAndCoderDo: [ :aWidget :aCoder | 
		aWidget enqueueTask: (BlTaskAction new action: [
			self updateNow ]) ].
]

{ #category : #'private - accessing' }
GtFilterRunExampleButtonAptitude >> exampler [
	<return: #GtCoderExampler>
	^ self coder exampler
]

{ #category : #'private - accessing' }
GtFilterRunExampleButtonAptitude >> examplerDo: aBlock [
	self coderDo: [ :aCoder |
		aBlock cull: aCoder exampler ]
]

{ #category : #initialization }
GtFilterRunExampleButtonAptitude >> initialize [
	super initialize.
	isUpdateRequested := false.
	mutex := Mutex new.
]

{ #category : #initialization }
GtFilterRunExampleButtonAptitude >> initializeIconElement: anElement [
	anElement
		geometry: BlCircle new;
		margin: (BlInsets all: 1);
		size: 8 @ 8.
]

{ #category : #'private - testing' }
GtFilterRunExampleButtonAptitude >> isUpdateRequested [
	<return: #Boolean>
	^ isUpdateRequested
]

{ #category : #'api - hooks' }
GtFilterRunExampleButtonAptitude >> onAttachedTo: anElement [
	super onAttachedTo: anElement.

	self postponeUpdate.
]

{ #category : #'private - hooks' }
GtFilterRunExampleButtonAptitude >> onCoderChanged [
	"We expect that the Coder is changed just once before the look is attached."
	self beUpdateRequestedIfDoneEarlierDo: [ ^ self ].
	self updateNow.
]

{ #category : #'private - announcement handling' }
GtFilterRunExampleButtonAptitude >> onCoderChanged: aGtCodersCodersChanged [
	self postponeUpdate.
]

{ #category : #'private - announcement handling' }
GtFilterRunExampleButtonAptitude >> onExampleExecuted: aGtCoderExampleExecuted [
	self postponeUpdate.
]

{ #category : #'api - hooks' }
GtFilterRunExampleButtonAptitude >> onUninstalledIn: anElement [
	super onUninstalledIn: anElement.
	self resetUpdateRequested.
]

{ #category : #'private - updating' }
GtFilterRunExampleButtonAptitude >> postponeUpdate [
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
GtFilterRunExampleButtonAptitude >> postponedTime [
	| aNow |
	self widgetDo: [ :aWidget | 
		aNow := aWidget space 
			ifNotNil: [ :aSpace | aSpace time now ] 
			ifNil: [ BlTime real now ] ].
	aNow ifNil: [ aNow := BlTime real now ].
	^ aNow + 300 milliSeconds.
]

{ #category : #'private - updating' }
GtFilterRunExampleButtonAptitude >> resetUpdateRequested [
	mutex critical: [ 
		isUpdateRequested := false ].
]

{ #category : #'private - subscriptions' }
GtFilterRunExampleButtonAptitude >> subscribeToCoder [
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
GtFilterRunExampleButtonAptitude >> unsubscribeFromCoder [
	self coderDo: [ :aCoder |
		aCoder unsubscribe: self ].
]

{ #category : #'private - updating' }
GtFilterRunExampleButtonAptitude >> updateNow [
	self resetUpdateRequested.
	self updateWidget.
]

{ #category : #'private - updating' }
GtFilterRunExampleButtonAptitude >> updateWidget [
	"Subclasses may perform update actions.
	I should be called from a UI process."
]

{ #category : #'private - accessing' }
GtFilterRunExampleButtonAptitude >> widgetAndCoderDo: aTwoArgBlock [
	self widgetDo: [ :aWidget | 
		self coderDo: [ :aCoder |
			aTwoArgBlock cull: aWidget cull: aCoder ] ]
]
