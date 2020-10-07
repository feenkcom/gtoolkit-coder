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
	<return: #GtSearchMethodsFilter>
	^ coder
]

{ #category : #'api - accessing' }
GtFilterRunExampleButtonLook >> coder: aGtSearchMethodsFilter [
	coder = aGtSearchMethodsFilter ifTrue: [ ^ self ].
	self unsubscribeFromCoder.
	coder := aGtSearchMethodsFilter.
	self subscribeToCoder.
	self onCoderChanged.
]

{ #category : #'private - updating' }
GtFilterRunExampleButtonLook >> enqueueUpdate [
	self widgetDo: [ :aWidget | 
		aWidget enqueueTask: (BlTaskAction new action: [
			mutex critical: [ 
				isUpdateRequested := false ].
			self updateWidget ]) ].
]

{ #category : #initialization }
GtFilterRunExampleButtonLook >> initialize [
	super initialize.
	isUpdateRequested := false.
	mutex := Mutex new.
]

{ #category : #'private - hooks' }
GtFilterRunExampleButtonLook >> onCoderChanged [
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
		BlTaskAtQueue default
			schedule: [ self enqueueUpdate ]
			at: self postponedTime ]
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
		to: self
]

{ #category : #'private - subscriptions' }
GtFilterRunExampleButtonLook >> unsubscribeFromCoder [
	self coder ifNil: [ ^ self ].
	self coder unsubscribe: self.
]

{ #category : #'private - updating' }
GtFilterRunExampleButtonLook >> updateWidget [
	"Subclasses may perform update actions.
	I should be called from a UI process."
]
