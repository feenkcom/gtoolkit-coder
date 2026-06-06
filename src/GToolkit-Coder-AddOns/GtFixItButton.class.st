Class {
	#name : #GtFixItButton,
	#superclass : #BrButton,
	#instVars : [
		'fixItModel'
	],
	#category : #'GToolkit-Coder-AddOns-FixIt'
}

{ #category : #accessing }
GtFixItButton >> fixItModel [
	^ fixItModel
]

{ #category : #accessing }
GtFixItButton >> fixItModel: anObject [
	self
		assert: [ anObject isNotNil ]
		description: [ 'FixIt model must be non-nil' ].

	fixItModel = anObject ifTrue: [ ^ self ].

	fixItModel := anObject.
	self onFixItModelChanged
]

{ #category : #hooks }
GtFixItButton >> onFixItModelChanged [
	fixItModel
		when: GtFixItAdviceModelShowDropdownAnnouncement
		send: #onGtFixItAdviceModelShowDropdownAnnouncement:
		to: self
]

{ #category : #'private - event handling' }
GtFixItButton >> onGtFixItAdviceModelShowDropdownAnnouncement: anAnnouncement [
	self fixItModel = anAnnouncement model ifFalse: [ ^ self ].

	BlTaskAction enqueueElement: self action: [ self updateShowFixItDropdown ]
]

{ #category : #'private - updating' }
GtFixItButton >> updateShowFixItDropdown [
	self dispatchEvent: (BrDropdownShowWish new anchor: self)
]
