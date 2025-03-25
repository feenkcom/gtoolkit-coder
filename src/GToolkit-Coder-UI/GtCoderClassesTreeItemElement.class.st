Class {
	#name : #GtCoderClassesTreeItemElement,
	#superclass : #BrHorizontalPane,
	#instVars : [
		'theClass',
		'classNameLabel',
		'classIconContainer',
		'currentIconName'
	],
	#category : #'GToolkit-Coder-UI-Navigation - Helpers'
}

{ #category : #accessing }
GtCoderClassesTreeItemElement >> classHierarchyTree: aClassHierarchyTree [
	| aNewIconName anIcon anIconForm |
	(self children size = 2
		and: [ self children first = classIconContainer
				and: [ self children last = classNameLabel ] ])
		ifFalse: [ self removeChildren.
			self
				addChildren: {classIconContainer.
						classNameLabel} ].

	theClass := aClassHierarchyTree ifNotNil: #rootClass.

	theClass
		ifNil: [ classNameLabel text: '' asRopedText ]
		ifNotNil: [ | aText |
			aText := theClass gtDisplayText asRopedText.
			(theClass isAbstract or: [ theClass hasAbstractMethods ])
				ifTrue: [ aText italic ].
			theClass isDeprecated
				ifTrue: [ aText append: ' (deprecated)' asRopedText italic.
					aText lineThrough ].
			classNameLabel text: aText ].

	aNewIconName := theClass gtSystemIconName.
	aNewIconName = currentIconName ifTrue: [ ^ self ].

	aNewIconName ifNil: [ classIconContainer visibility: BlVisibility hidden ].
	anIconForm := theClass gtSafeIconNamed: aNewIconName.
	anIcon := anIconForm asElement.

	classIconContainer removeChildren.
	classIconContainer addChild: anIcon.
	currentIconName := aNewIconName
]

{ #category : #initialization }
GtCoderClassesTreeItemElement >> createClassNameLabel [
	^ BrLabel new
		hMatchParent;
		vFitContent;
		beSmallSize;
		aptitude: BrGlamorousLabelAptitude
]

{ #category : #initialization }
GtCoderClassesTreeItemElement >> initialize [
	super initialize.
	
	self hMatchParent.
	self vFitContent.
	self alignCenterLeft.
	
	classIconContainer := BrFrame new
		fitContent;
		margin: (BlInsets right: 2).
	classNameLabel := self createClassNameLabel.
	self addChildren: { classIconContainer . classNameLabel }
]

{ #category : #accessing }
GtCoderClassesTreeItemElement >> theClass [
	^ theClass
]
