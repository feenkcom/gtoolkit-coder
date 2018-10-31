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
	| shadowLook resizer |
	super initialize.

	resizer := BrResizer new
		beBottom;
		look: BrGlamorousResizerLook new;
		constraintsDo: [ :c | c ignoreByLayout ];
		yourself.

	shadowLook := BrShadowLook new.
	
	self look: (BrGlamorousAccordionLook + (BrInteractiveLook new style: [ :aStyler |
		aStyler default: [
			resizer removeFromParent.
			self background: Color transparent.
			self look remove: shadowLook.
			self assert: shadowLook isAttachedToWidget not  ].
		aStyler expanded: [
			self addChild: resizer.
			self enqueueTask: (BlTaskAction new action: [
				self
					childNamed: #bodyEditor
					ifFound: [ :anEditor | resizer target: anEditor ]
					ifNone: [ resizer target: nil ] ]).
			self background: Color white.
			self look add: shadowLook ] ])).

	self addShortcut: (BlShortcut new
		combination: (BlKeyCombination builder primary; return; build);
		action: [ self toggle ])
]

{ #category : #accessing }
GtCoderMethodElement >> methodCoder [
	^ methodCoder
]

{ #category : #accessing }
GtCoderMethodElement >> methodCoder: aGtMethodCoder [
	methodCoder := aGtMethodCoder.

	self header: [ GtCoderMethodPatternStencil new methodCoder: self methodCoder ].
	self content: [ GtCoderMethodBodyStencil new methodCoder: self methodCoder ].

	self lookDo: [ :aLook | aLook headerBar
		when: BlClickEvent
		do: [ :anEvent |
			anEvent consumed: true.
			self toggle.
			methodCoder expanded: self isExpanded ] ].

	methodCoder expanded
		ifTrue: [ self expand ]
]
