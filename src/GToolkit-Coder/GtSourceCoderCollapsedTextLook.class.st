Class {
	#name : #GtSourceCoderCollapsedTextLook,
	#superclass : #GtSourceCoderLook,
	#instVars : [
		'label'
	],
	#category : #'GToolkit-Coder-UI - Source Coder Look'
}

{ #category : #initialization }
GtSourceCoderCollapsedTextLook >> initialize [
	super initialize.
	
	label := self newLabel.

	self addChangeAddChildAs: #(content label) with: [ label ].
]

{ #category : #'instance creation' }
GtSourceCoderCollapsedTextLook >> newLabel [
	^ BrLabel new
		look: BrGlamorousLabelLook new editorMeasurement "bold glamorousCodeFont"
]

{ #category : #initialization }
GtSourceCoderCollapsedTextLook >> onCoderChanged: aSourceCoder [
	self widget coder ifNotNil: [ :aPreviousCoder | aPreviousCoder announcer unsubscribe: self ].
	
	self updateLabelFor: aSourceCoder.

	aSourceCoder announcer weak
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
	label text: aSourceCoder collapsedText copy bold glamorousCodeFont
]
