Class {
	#name : #GtMethodsCoder,
	#superclass : #GtCodersModel,
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #elements }
GtMethodsCoder >> elementClass [
	^ GtCodersElement
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
	(self coders
		anySatisfy: [ :each | each isForMethod: aValueAdded newValue ])
		ifTrue: [ ^ self ].
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
	coder coders: self.
	^ coder
]

{ #category : #scripting }
GtMethodsCoder >> selectAndScrollTo: aMethodCoder [
	aMethodCoder expanded: true.
	self
		announce:
			(GtCodersScrollToCoder new
				coders: self;
				sourceCoder: aMethodCoder).
	BlUseAsyncFeatures 
		ifEnabledDo: [ 
			| aCommand |
			"Wait for scrolling to create the element"
			aCommand := BlTaskAtPostponedTerminableTask new
				command: [ aMethodCoder requestFocus ];
				pool: BlTktWorkerProvider highUICPUBoundPool;
				scheduledTime: BlTime real now + 100 milliSeconds.
			BlTaskAtQueue default schedule: aCommand ]
		otherwise: [ aMethodCoder requestFocus ]
]

{ #category : #scripting }
GtMethodsCoder >> selectAndScrollToMethod: aCompiledMethod [
	| methodCoder |
	methodCoder := self coders
		detect: [ :each | each isForMethod: aCompiledMethod ]
		ifNone: [ ^ self ].
	self selectAndScrollTo: methodCoder
]
