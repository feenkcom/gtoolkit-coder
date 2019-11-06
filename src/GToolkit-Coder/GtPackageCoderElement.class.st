Class {
	#name : #GtPackageCoderElement,
	#superclass : #BlElement,
	#instVars : [
		'packageCoder',
		'packagesLabel',
		'packagesInfoLabel'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #'building ui' }
GtPackageCoderElement >> buildContentPane [
	self removeChildren.
	self addChild: self buildPackageLabel.
	self addChild: self buildPackageInformationLabel.
	self addChild: packageCoder classesCoder asElement
]

{ #category : #'building ui' }
GtPackageCoderElement >> buildPackageInformationLabel [
	^ BrLabel new
		margin: (BlInsets left: 10);
		look: BrGlamorousLabelLook new glamorousCodeFontAndSize;
		text: packageCoder package definedClasses size printString , ' Classes'
]

{ #category : #'building ui' }
GtPackageCoderElement >> buildPackageLabel [
	^ BrLabel new
		margin: (BlInsets left: 10);
		look: (BrGlamorousLabelLook new bold glamorousCodeFontAndSize fontSize: 20);
		text: packageCoder package name
]

{ #category : #initialization }
GtPackageCoderElement >> initialize [
	super initialize.
	self layout: BlLinearLayout vertical.
	self
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ]
]

{ #category : #accessing }
GtPackageCoderElement >> packageCoder [
	^ packageCoder
]

{ #category : #accessing }
GtPackageCoderElement >> packageCoder: anObject [
	packageCoder := anObject.
	self buildContentPane
]
