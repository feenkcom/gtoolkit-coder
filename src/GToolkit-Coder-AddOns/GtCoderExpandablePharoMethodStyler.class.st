Class {
	#name : #GtCoderExpandablePharoMethodStyler,
	#superclass : #GtCoderAstStyler,
	#traits : 'TGtPharoProgramNodeVisitor',
	#classTraits : 'TGtPharoProgramNodeVisitor classTrait',
	#category : #'GToolkit-Coder-AddOns-Expandable method'
}

{ #category : #'api - styling' }
GtCoderExpandablePharoMethodStyler >> style: aText ast: theAst [
	text := aText.
	[ self accept: theAst ]
		ensure: [ text := nil ]
]

{ #category : #visiting }
GtCoderExpandablePharoMethodStyler >> visitMessage: aMessageNode [
	| aMethodClass |
	
	aMethodClass := GtPharoProgramNode
		typeOf: aMessageNode messageReceiver
		in: self coderViewModel coderModel behavior.
	
	NonInteractiveTranscript stdout
		print: aMessageNode selector;
		space;
		nextPutAll: aMethodClass asString;
		cr.

	aMethodClass isNil
		ifTrue: [ ^ self ].

	(aMethodClass canUnderstand: aMessageNode selector)
		ifFalse: [ ^ self ].
		
	text
		attribute: (GtPharoMethodExpanderAttribute
			forClass: aMethodClass
			andSelector: aMessageNode selector)
		from: aMessageNode selectorParts last stopPosition
		to: aMessageNode selectorParts last stopPosition
]
