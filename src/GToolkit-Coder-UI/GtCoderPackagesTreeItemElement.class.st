Class {
	#name : #GtCoderPackagesTreeItemElement,
	#superclass : #BrHorizontalPane,
	#instVars : [
		'packageOrTag',
		'label'
	],
	#category : #'GToolkit-Coder-UI-Navigation - Helpers'
}

{ #category : #initialization }
GtCoderPackagesTreeItemElement >> initialize [
	super initialize.
	
	label := BrLabel new
		matchParent;
		text: '';
		beSmallSize;
		aptitude: (BrGlamorousLabelAptitude new padding: (BlInsets
					top: 2
					bottom: 2
					left: 1
					right: 1)).

	self addChild: label
]

{ #category : #accessing }
GtCoderPackagesTreeItemElement >> packageOrTag [
	^ packageOrTag
]

{ #category : #accessing }
GtCoderPackagesTreeItemElement >> packageOrTag: aPackageOrTag [
	packageOrTag = aPackageOrTag
		ifTrue: [ ^ self ].

	packageOrTag := aPackageOrTag.
	
	packageOrTag
		ifNil: [ label text: '' ]
		ifNotNil: [ label text: packageOrTag name ]
]
