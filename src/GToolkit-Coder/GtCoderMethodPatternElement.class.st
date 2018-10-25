Class {
	#name : #GtCoderMethodPatternElement,
	#superclass : #BlElement,
	#instVars : [
		'methodCoder',
		'toolbar',
		'label'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #initialization }
GtCoderMethodPatternElement >> initialize [
	super initialize.
	
	self layout: BlLinearLayout horizontal.

	toolbar := BrToolbar new.
	toolbar look: BrToolbarLook new.
	toolbar layout: BlLinearLayout horizontal.
	toolbar constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent ].
	toolbar addItem: (BrButton new
		look: BrGlamorousButtonWithIconLook;
		label: 'Accept';
		icon: BrGlamorousIcons accept asElement).

	"self addChild: toolbar."

	label := BrEditorElement new.
	label constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent ].
	self addChild: label.
]

{ #category : #accessing }
GtCoderMethodPatternElement >> methodCoder [
	<return: #GtMethodCoder>

	^ methodCoder
]

{ #category : #accessing }
GtCoderMethodPatternElement >> methodCoder: aMethodCoder [
	methodCoder := aMethodCoder.

	label editor: (BrTextEditor new text: aMethodCoder styledPatternText monospace)
]
