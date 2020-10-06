Class {
	#name : #GtFilterRunExampleButtonLook,
	#superclass : #BrLook,
	#instVars : [
		'coder'
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

{ #category : #'private - hooks' }
GtFilterRunExampleButtonLook >> onCoderChanged [
]

{ #category : #'private - announcement handling' }
GtFilterRunExampleButtonLook >> onExampleExecuted: aGtCoderExampleExecuted [
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
