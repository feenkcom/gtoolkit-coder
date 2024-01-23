Class {
	#name : #GtCoderNavigationPackagesTreeItemElement,
	#superclass : #BrHorizontalPane,
	#instVars : [
		'packageOrTag',
		'label'
	],
	#category : #'GToolkit-Coder-UI-Navigation'
}

{ #category : #initialization }
GtCoderNavigationPackagesTreeItemElement >> initialize [
	super initialize.
	
	self addAptitude: BrGlamorousListItemAptitude new.
	
	label := BrLabel new
		matchParent;
		text: '';
		beSmallSize;
		aptitude: BrGlamorousLabelAptitude.

	self addChild: label
]

{ #category : #accessing }
GtCoderNavigationPackagesTreeItemElement >> packageOrTag [
	^ packageOrTag
]

{ #category : #accessing }
GtCoderNavigationPackagesTreeItemElement >> packageOrTag: aPackageOrTag [
	packageOrTag = aPackageOrTag
		ifTrue: [ ^ self ].

	packageOrTag := aPackageOrTag.
	
	packageOrTag
		ifNil: [ label text: '' ]
		ifNotNil: [ label text: packageOrTag name ]
]
