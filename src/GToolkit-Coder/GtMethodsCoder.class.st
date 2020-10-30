Class {
	#name : #GtMethodsCoder,
	#superclass : #GtCodersModel,
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #accessing }
GtMethodsCoder >> exampler [
	^ GtMethodsCoderExampler new
		coder: self
]

{ #category : #accessing }
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
	| aCoder |
	(self coders
		anySatisfy: [ :eachCoder | eachCoder isForMethod: aValueAdded newValue ])
		ifTrue: [ ^ self ].
	aCoder := self newCoderFor: aValueAdded newValue.
	self addCoder: aCoder.
]

{ #category : #'event handling' }
GtMethodsCoder >> methodChanged: aValueChanged [
	coders
		do: [ :each | 
			(each isForMethod: aValueChanged newValue)
				ifTrue: [ each forMethod: aValueChanged newValue ] ]
]

{ #category : #'event handling' }
GtMethodsCoder >> methodRemoved: aValueRemoved [
	| toRemove |
	toRemove := coders
		select: [ :each | each isForMethod: aValueRemoved oldValue ].
	toRemove
		do: [ :each | 
			self removeCoder: each ]
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
