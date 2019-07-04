Class {
	#name : #GtMethodsCoder,
	#superclass : #GtCoders,
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #elements }
GtMethodsCoder >> elementClass [
	^ GtMethodsCoderElement
]

{ #category : #'as yet unclassified' }
GtMethodsCoder >> forItems: aCollection [
	super forItems: aCollection.
	(items isKindOf: GtSearchMethodGroupResult)
		ifTrue: [ items announcer weak
				when: ValueAdded send: #methodAdded: to: self;
				when: ValueChanged send: #methodChanged: to: self;
				when: ValueRemoved send: #methodRemoved: to: self.
			coders do: [ :each | each highlighter: items highlighter ] ]
]

{ #category : #'event handling' }
GtMethodsCoder >> methodAdded: aValueAdded [
	| coder |
	coder := GtMethodCoder forMethod: aValueAdded newValue.
	coders add: coder.
	self
		announce:
			(GtCodersCoderAdded new
				coders: self;
				coder: coder;
				yourself)
]

{ #category : #'event handling' }
GtMethodsCoder >> methodChanged: aValueChanged [
	coders
		do: [ :each | 
			(each isForMethod: aValueChanged newValue)
				ifTrue: [ each updateMethod: aValueChanged newValue ] ]
]

{ #category : #elements }
GtMethodsCoder >> methodCoderLook [
	^ nil
]

{ #category : #'event handling' }
GtMethodsCoder >> methodRemoved: aValueRemoved [
	| toRemove |
	toRemove := coders
		select: [ :each | each isForMethod: aValueRemoved oldValue ].
	toRemove
		do: [ :each | 
			coders remove: each.
			self
				announce:
					(GtCodersCoderRemoved new
						coders: self;
						coder: each;
						yourself) ]
]

{ #category : #private }
GtMethodsCoder >> newCoderFor: aMethod [
	| coder |
	coder := GtMethodCoder forMethod: aMethod.
	coder methodsCoder: self.
	^ coder
]
