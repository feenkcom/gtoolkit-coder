Class {
	#name : #GtCoderMethodPatternElement,
	#superclass : #BlElement,
	#instVars : [
		'methodCoder',
		'toolbar',
		'label',
		'breadcrumb'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #initialization }
GtCoderMethodPatternElement >> initialize [
	super initialize.
	
	self layout: BlLinearLayout vertical.

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

	breadcrumb := BrBreadcrumb new.
	breadcrumb look: (BrGlamorousBreadcrumbLook new separator: [
		BrLabel new
			look: (BrGlamorousLabelLook new thin foreground: BrGlamorousColors defaultButtonTextColor);
			text: '>';
			margin: (BlInsets left: 5 right: 5) ]).

	label := BrEditorElement new.
	label constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent ].
	
	self addChild: breadcrumb.
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

	label editor: aMethodCoder patternEditor.
	methodCoder addPatternShortcutsTo: label.
	
	{ aMethodCoder classOrMetaClass package name . aMethodCoder classOrMetaClass name }
		do: [ :aLocationStepName |
			breadcrumb addItem: (BrLabel new
				look: (BrGlamorousLabelLook new foreground: BrGlamorousColors defaultButtonTextColor; fontSize: 12);
				text: aLocationStepName) ]
]
