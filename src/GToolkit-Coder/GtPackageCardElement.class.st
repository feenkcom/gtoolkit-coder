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
	| extensionMethodsCount |
	self removeChildren.
	self addChild: (BlShrinkingTextElement new
			 text: packageCoder name asRopedText bold;
			 constraintsDo: [ :c | 
				 c vertical fitContent.
				 c horizontal matchParent ]).
	extensionMethodsCount := self extensionMethodsCount.
	self addChild: (BrLabel new
			 look: (BrGlamorousLabelLook new foreground:
						  BrGlamorousColors defaultButtonTextColor);
			 text:
				 packageCoder package definedClasses size printString , ' Classes'
				 , (extensionMethodsCount > 0
						  ifTrue: [ 
							  ', ' , extensionMethodsCount printString
							  , ' Extension methods' ]
						  ifFalse: [ '' ]))
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
	self layout: (BlLinearLayout vertical cellSpacing: 2).
	self constraintsDo: [:c | c horizontal matchParent.
				c vertical matchParent ].
	self padding: (BlInsets top: 5 left: 10 bottom: 5 right: 10).
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

{ #category : #private }
GtPackageCardElement >> selectCoder [
	self
		allParentsDetect: [ :each | each isKindOf: GtPackagesCoderElement ]
		ifFound: [ :element | element updateSelection: packageCoder ]
		ifNone: [ self phlow spawnObject: packageCoder ]
]
