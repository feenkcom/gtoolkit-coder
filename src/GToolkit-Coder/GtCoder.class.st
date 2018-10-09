Class {
	#name : #GtCoder,
	#superclass : #Object,
	#instVars : [
		'searchFilter',
		'classCoder'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #elements }
GtCoder >> addNewCoderFor: event to: pager [
	| coderElement |
	coderElement := event coder asElement.
	coderElement viewModel: (BrPagerPageModel new model: event coder).
	event coder when: GtCoderDrillDownAnnouncement do: [ :evt | self addNewCoderFor: evt to: pager ].
	^ pager addPage: coderElement
]

{ #category : #elements }
GtCoder >> asElement [
	| element |
	element := BlElement new.
	element layout: BlLinearLayout vertical.
	element
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	element addChild: searchFilter asElement.
	searchFilter
		when: GtClassFilterAnnouncement
		do: [ :ann | 
			classCoder := GtClassCoder forClass: ann classOrMetaClass.
			[ element childrenCount > 1 ] whileTrue: [ element removeChildAt: 2 ].
			element addChild: classCoder asElement ].
	^ element asScrollableElement
]

{ #category : #'initialize-release' }
GtCoder >> initialize [
	super initialize.
	searchFilter := GtClassFilter new
]
