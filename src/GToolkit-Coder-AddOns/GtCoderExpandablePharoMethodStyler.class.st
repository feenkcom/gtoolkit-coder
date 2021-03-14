Class {
	#name : #GtCoderExpandablePharoMethodStyler,
	#superclass : #GtAstStyler,
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

{ #category : #private }
GtCoderExpandablePharoMethodStyler >> typeOf: aGtPharoProgramNode in: aClass [
	(aGtPharoProgramNode isVariable and: [ aGtPharoProgramNode isSelf ]) 
		ifTrue: [ ^ aClass ].
	
	(aGtPharoProgramNode isVariable and: [ aGtPharoProgramNode isSuper ]) 
		ifTrue: [ ^ aClass ifNotNil: [ :class | class superclass ] ].
	
	aGtPharoProgramNode isLiteral
		ifTrue: [ ^ aGtPharoProgramNode value class ].

	(aGtPharoProgramNode isKindOf: GtPharoArrayNode)
		ifTrue: [ ^ {} class ].

	aGtPharoProgramNode isMessage
		ifTrue: [ aGtPharoProgramNode selector = #class
				ifTrue: [ ^ (self typeOf: aGtPharoProgramNode messageReceiver in: aClass)
						ifNotNil: [ :class | class class ] ].
			(#(new new:) includes: aGtPharoProgramNode selector)
				ifTrue: [ ^ (self typeOf: aGtPharoProgramNode messageReceiver in: aClass)
						ifNotNil: [ :class | class instanceSide ] ] ].

	aGtPharoProgramNode isVariable
		ifTrue: [ aGtPharoProgramNode binding
				ifNotNil: [ :binding | 
					binding isLiteralVariable
						ifTrue: [ binding value ifNotNil: [ :object | ^ object class ] ].
					(binding isSpecialVariable and: [ binding isThisContext ])
						ifTrue: [ ^ Context ] ] ].
	^ nil
]

{ #category : #visiting }
GtCoderExpandablePharoMethodStyler >> visitMessage: aMessageNode [
	| aMethodClass |
	
	aMethodClass := self
		typeOf: aMessageNode messageReceiver
		in: self coder behavior.

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
