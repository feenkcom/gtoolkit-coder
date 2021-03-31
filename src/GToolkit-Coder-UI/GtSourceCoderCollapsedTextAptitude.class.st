Class {
	#name : #GtSourceCoderCollapsedTextAptitude,
	#superclass : #GtSourceCoderAptitude,
	#instVars : [
		'label'
	],
	#category : #'GToolkit-Coder-UI-Coder - Source Look'
}

{ #category : #initialization }
GtSourceCoderCollapsedTextAptitude >> initialize [
	super initialize.
	
	label := self newLabel.
	self addChangeAddChildAs: { #content . GtSourceCoderCollapsedTextId } with: [ label ].
]

{ #category : #accessing }
GtSourceCoderCollapsedTextAptitude >> initializeListeners [
	super initializeListeners.
	
	self when: BlClickEvent do: [ :anEvent |
		anEvent consumed: true.
		self sourceCoderUIModel
			expanded: true;
			focused: true ]
]

{ #category : #'instance creation' }
GtSourceCoderCollapsedTextAptitude >> newLabel [
	^ BrLabel new
		aptitude: BrGlamorousLabelAptitude new editorMeasurement bold glamorousCodeFont
]

{ #category : #initialization }
GtSourceCoderCollapsedTextAptitude >> onCoderChanged: aGtSourceCoderUIModel [
	self widget coderUIModel
		ifNotNil: [ :aPreviousCoder | aPreviousCoder coder announcer unsubscribe: self ].
	self updateLabelFor: aGtSourceCoderUIModel coder.
	aGtSourceCoderUIModel coder announcer weak
		when: GtCoderCollapsedLabelChanged
		send: #updateLabel:
		to: self
]

{ #category : #private }
GtSourceCoderCollapsedTextAptitude >> updateLabel: anAnnouncement [
	self updateLabelFor: anAnnouncement coder
]

{ #category : #private }
GtSourceCoderCollapsedTextAptitude >> updateLabelFor: aSourceCoder [
	label text: aSourceCoder collapsedText
]
