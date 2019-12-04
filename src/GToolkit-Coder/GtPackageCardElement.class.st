Class {
	#name : #GtPackageCardElement,
	#superclass : #BlElement,
	#instVars : [
		'packageCoder'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #'building ui' }
GtPackageCardElement >> buildContainer [
	self removeChildren.
	self addChild: (BlShrinkingTextElement new
			 text: packageCoder name asRopedText bold;
			 constraintsDo: [ :c | 
				 c vertical fitContent.
				 c horizontal matchParent ]).
	self addChild: (BlShrinkingTextElement new
			 text:
				 (self packageDetailsString asRopedText glamorousRegularFont thin 
					  foreground: BrGlamorousColors defaultButtonTextColor);
			 constraintsDo: [ :c | 
				 c vertical fitContent.
				 c horizontal matchParent ])
]

{ #category : #private }
GtPackageCardElement >> extensionMethodsCount [
	| count |
	count := 0.
	packageCoder package extendedClasses
		do: [ :each | 
			count := count
				+ (packageCoder package extensionSelectorsForClass: each) size ].
	^ count
]

{ #category : #'initialize-release' }
GtPackageCardElement >> initialize [
	super initialize.
	self viewModel: (BrInteractiveModel new
			addStates: {
				BrActivationModel new.
				BrPressModel new.
				BrHoverModel new.
			}).
	self look: (BrGlamorousButtonExteriorLook new borderPaint: Color transparent).
	self layout: (BlLinearLayout vertical cellSpacing: 2).
	self constraintsDo: [:c | c horizontal matchParent.
				c vertical matchParent ].
	self margin: (BlInsets top: 5 left: 10 bottom: 5 right: 10).
	self padding: (BlInsets all: 5).
	self when: BlClickEvent do: [:event | self selectCoder ]
]

{ #category : #accessing }
GtPackageCardElement >> packageCoder [
	^ packageCoder
]

{ #category : #accessing }
GtPackageCardElement >> packageCoder: anObject [
	packageCoder := anObject.
	self buildContainer
]

{ #category : #'building ui' }
GtPackageCardElement >> packageDetailsString [
	| extensionMethodsCount |
	extensionMethodsCount := self extensionMethodsCount.
	^ packageCoder package definedClasses size printString , ' Classes'
	  , (extensionMethodsCount > 0
			   ifTrue: [ 
			   ', ' , extensionMethodsCount printString , ' Extension methods' ]
			   ifFalse: [ '' ])
]

{ #category : #private }
GtPackageCardElement >> selectCoder [
	self
		allParentsDetect: [ :each | each isKindOf: GtPackagesCoderElement ]
		ifFound: [ :element | element updateSelection: packageCoder ]
		ifNone: [ self phlow spawnObject: packageCoder ]
]
