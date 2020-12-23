Class {
	#name : #GtSourceCoderCollapsedTextLook,
	#superclass : #GtSourceCoderLook,
	#instVars : [
		'label'
	],
	#category : #'GToolkit-Coder-UI-Coder - Source Look'
}

{ #category : #initialization }
GtSourceCoderCollapsedTextLook >> initialize [
	super initialize.
	
	label := self newLabel.
	self addChangeAddChildAs: { #content . GtSourceCoderCollapsedTextId } with: [ label ].
]

{ #category : #'instance creation' }
GtSourceCoderCollapsedTextLook >> newLabel [
	^ BrLabel new
		look: BrGlamorousLabelLook new editorMeasurement bold glamorousCodeFont
]

{ #category : #initialization }
GtSourceCoderCollapsedTextLook >> onCoderChanged: aGtSourceCoderUIModel [
	self widget coderUIModel
		ifNotNil: [ :aPreviousCoder | aPreviousCoder coder announcer unsubscribe: self ].
	self updateLabelFor: aGtSourceCoderUIModel coder.
	aGtSourceCoderUIModel coder announcer weak
		when: GtCoderCollapsedLabelChanged
		send: #updateLabel:
		to: self
]

{ #category : #private }
GtSourceCoderCollapsedTextLook >> updateLabel: anAnnouncement [
	self updateLabelFor: anAnnouncement coder
]

{ #category : #private }
GtSourceCoderCollapsedTextLook >> updateLabelFor: aSourceCoder [
	label text: aSourceCoder collapsedText
]
