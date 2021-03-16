Class {
	#name : #GtPharoMethodExpanderStyler,
	#superclass : #GtGenericPharoStyler,
	#category : #'GToolkit-Coder-Pharo-AddOns-Expander'
}

{ #category : #visiting }
GtPharoMethodExpanderStyler >> visitMessageSend: aMessageNode [
	| aMethodClass |
	
	self visitValue: aMessageNode.

	aMethodClass := GtPharoProgramNode
		typeOf: aMessageNode receiver
		in: self coderViewModel coderModel behavior.
	
	aMethodClass
		ifNil: [ ^ self ].

	(aMethodClass canUnderstand: aMessageNode selector)
		ifFalse: [ ^ self ].
		
	text
		attribute: (GtPharoMethodExpanderAttribute
			forClass: aMethodClass
			andSelector: aMessageNode selector)
		from: aMessageNode selectorParts last stopPosition
		to: aMessageNode selectorParts last stopPosition
]
