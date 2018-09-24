Class {
	#name : #GtDropDownPopupListener,
	#superclass : #BlElementEventListener,
	#instVars : [
		'overlayElement',
		'attachmentsCount'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #'instance creation' }
GtDropDownPopupListener class >> for: anOverlayElement [
	^ self basicNew
		initialize;
		overlayElement: anOverlayElement
]

{ #category : #'instance creation' }
GtDropDownPopupListener class >> new [
	self error: 'Do not create an instance of ', self name, ' using new. Please use #for: instead'
]

{ #category : #'element handlers' }
GtDropDownPopupListener >> elementPositionInSpaceChanged: anEvent [
	self relocateTo: anEvent currentTarget
]

{ #category : #initialization }
GtDropDownPopupListener >> initialize [
	super initialize.
	
	attachmentsCount := 0
]

{ #category : #'api - hooks' }
GtDropDownPopupListener >> onInstalledIn: anElement [
	self
		assert: [ attachmentsCount isZero ]
		description: [ 'I must be attached to at most one element' ].
		
	attachmentsCount := attachmentsCount + 1.
	
	self relocateTo: anElement
]

{ #category : #'api - hooks' }
GtDropDownPopupListener >> onUninstalledIn: anObject [
	
	self
		assert: [ attachmentsCount = 1 ]
		description: [ 'I must be attached to at most one element' ].
	
	attachmentsCount := attachmentsCount - 1
]

{ #category : #accessing }
GtDropDownPopupListener >> overlayElement [
	<return: #BlOverlayElement>

	^ overlayElement
]

{ #category : #accessing }
GtDropDownPopupListener >> overlayElement: anOverlayElement [

	self
		assert: [ anOverlayElement isNotNil ]
		description: [ 'Overlay element must not be nil' ].

	overlayElement := anOverlayElement
]

{ #category : #geometry }
GtDropDownPopupListener >> positionFor: anElement [
	<return: #Point>
	| boundsInSpace |
	self
		assert: [ anElement isNotNil ]
		description: [ 'Reference element must not be nil' ].
	
	boundsInSpace := anElement bounds inSpace.
	
	^ (self overlayElement globalPointToParent: boundsInSpace position + (0 @ boundsInSpace extent y))
]

{ #category : #'api - updating' }
GtDropDownPopupListener >> relocateTo: anElement [
	self overlayElement width: anElement width.
	self overlayElement relocate: (self positionFor: anElement)
]
