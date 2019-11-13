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
	self
		addChild:
			(BlShrinkingTextElement new
				text: packageCoder name asRopedText bold;
				constraintsDo: [ :c | 
					c vertical fitContent.
					c horizontal matchParent ]).
	self
		addChild:
			(BrLabel new
				look:
					(BrGlamorousLabelLook new
						foreground: BrGlamorousColors defaultButtonTextColor);
				text: packageCoder package definedClasses size printString , ' Classes').
	extensionMethodsCount := self extensionMethodsCount.
	extensionMethodsCount > 0
		ifTrue: [ self
				addChild:
					(BrLabel new
						look:
							(BrGlamorousLabelLook new
								foreground: BrGlamorousColors defaultButtonTextColor);
						text: extensionMethodsCount printString , ' Extension methods') ]
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
	self layout: (BlLinearLayout vertical cellSpacing: 3).
	self
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	self padding: (BlInsets all: 10).
	self
		when: BlClickEvent
		do: [ :event | self phlow spawnObject: packageCoder ]
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
