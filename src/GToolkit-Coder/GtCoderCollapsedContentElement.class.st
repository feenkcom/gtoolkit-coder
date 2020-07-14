Class {
	#name : #GtCoderCollapsedContentElement,
	#superclass : #GtCoderContentElement,
	#instVars : [
		'label'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #'initialize-release' }
GtCoderCollapsedContentElement >> coder: aCoder [
	coder ifNotNil: [ :aPreviousCoder | aPreviousCoder announcer unsubscribe: self ].

	coder := aCoder.

	breadcrumb ifNotNil: [ :aBreadcrumb | aBreadcrumb coder: aCoder ].

	label text: aCoder collapsedText.

	coder announcer
		when: GtCoderCollapsedLabelChanged
		send: #updateLabel:
		to: self
]

{ #category : #initialization }
GtCoderCollapsedContentElement >> initialize [
	super initialize.
	
	label := BrLabel new
		look: BrGlamorousLabelLook new.
	
	self addChild: label as: #label.
	
	self look: BrLayoutResizerLook inherit
]

{ #category : #private }
GtCoderCollapsedContentElement >> updateLabel: anAnnouncement [
	label text: anAnnouncement coder collapsedText
]
