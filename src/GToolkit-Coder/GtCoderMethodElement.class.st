Class {
	#name : #GtCoderMethodElement,
	#superclass : #BrAccordion,
	#instVars : [
		'methodCoder'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #initialization }
GtCoderMethodElement >> initialize [
	super initialize.

	self look: BrGlamorousAccordionLook new
]

{ #category : #accessing }
GtCoderMethodElement >> methodCoder [
	^ methodCoder
]

{ #category : #accessing }
GtCoderMethodElement >> methodCoder: aGtMethodCoder [
	methodCoder := aGtMethodCoder.

	self header: [
		(GtCoderMethodPatternStencil new methodCoder: self methodCoder) asElement
			when: BlClickEvent do: [ :anEvent |
				anEvent consumed: true.
				self toggle.
				methodCoder expanded: self isExpanded ];
			yourself ].
	self content: [ GtCoderMethodBodyStencil new methodCoder: self methodCoder ].

	methodCoder expanded
		ifTrue: [ self expand ]
]
