Class {
	#name : #GtDropDownPopupElement,
	#superclass : #BlElement,
	#instVars : [
		'referenceElement',
		'overlayListener'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #'api - attaching / detaching' }
GtDropDownPopupElement >> attachTo: anElement [
	
	referenceElement = anElement
		ifTrue: [ ^ self ].
	
	self isAttached 
		ifTrue: [ self detach ].
	
	referenceElement := anElement.
	anElement addEventHandler: overlayListener
]

{ #category : #'api - attaching / detaching' }
GtDropDownPopupElement >> detach [
	
	self isAttached
		ifFalse: [ ^ self ].
	
	referenceElement removeEventHandler: overlayListener.
	referenceElement := nil
]

{ #category : #initialization }
GtDropDownPopupElement >> initialize [
	super initialize.

	self constraintsDo: [ :c | c ignoreByLayout ].
	self preventMouseEvents.

	overlayListener := GtDropDownPopupListener for: self
]

{ #category : #'api - testing' }
GtDropDownPopupElement >> isAttached [
	"Return true if I am attached to any element, false otherwise"
	<return: #Boolean>

	^ referenceElement isNotNil
]

{ #category : #layout }
GtDropDownPopupElement >> measureMyBounds [
	"I compute by position and size in relation to the reference element"
	self
		assert: [ self isAttached ]
		description: [ 'I must be attached to the reference element to measure myself' ].

	self relocate: (overlayListener positionFor: referenceElement)
]

{ #category : #layout }
GtDropDownPopupElement >> onMeasure: anExtentMeasurementSpec [

	self isAttached
		ifTrue: [ self measureMyBounds ].

	super onMeasure: anExtentMeasurementSpec
]
