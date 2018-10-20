Class {
	#name : #BrMethodCoderElement,
	#superclass : #BlElement,
	#instVars : [
		'coder'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #accessing }
BrMethodCoderElement >> coder [
	^ coder
]

{ #category : #initialization }
BrMethodCoderElement >> initialize [
	super initialize.
	
	"self look: BrGlamorousAccordionLook new.
	self margin: (BlInsets all: 5).
	self stencil: [ self bodyElement ]."
	
	"header := self patternButtonElement.
	header
		action: [
			self toggle.
			self expanded: self isExpanded ].
	self addChildFirst: header.
	expanded
		ifTrue: [ self toggle ].
	self userData at: #coder put: self."
]

{ #category : #initialization }
BrMethodCoderElement >> initializeWith: aGtMethodCoder [

	coder := aGtMethodCoder.

	"super initialize.
	
	self look: BrGlamorousAccordionLook new.
	self margin: (BlInsets all: 5).
	self stencil: [ self bodyElement ]."
	
	"header := self patternButtonElement.
	header
		action: [
			self toggle.
			self expanded: self isExpanded ].
	self addChildFirst: header.
	expanded
		ifTrue: [ self toggle ].
	self userData at: #coder put: self."
]
