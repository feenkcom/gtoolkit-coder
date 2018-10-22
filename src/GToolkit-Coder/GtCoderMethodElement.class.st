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
		methodCoder patternButtonElement action: [ 
			self toggle.
			methodCoder expanded: self isExpanded ] ].

	self content: [ GtCoderMethodBodyStencil new methodCoder: self methodCoder ].

	methodCoder expanded
		ifTrue: [ self expand ]
]
