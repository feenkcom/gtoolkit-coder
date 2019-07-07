Class {
	#name : #GtClassCommentCoder,
	#superclass : #GtCoder,
	#instVars : [
		'class',
		'document',
		'collapsedEditor'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #'as yet unclassified' }
GtClassCommentCoder class >> forClass: aClass [
	^ self new
		theClass: aClass;
		yourself
]

{ #category : #accessing }
GtClassCommentCoder >> collapsedEditor [
	^ collapsedEditor ifNil: [ collapsedEditor := BrTextEditor new ]
]

{ #category : #ui }
GtClassCommentCoder >> collapsedElement [
	| element |
	element := BrEditorElement new.
	element editor: self collapsedEditor.
	^ element
]

{ #category : #ui }
GtClassCommentCoder >> expandedElement [
	| container element toolbar |
	container := BlElement new
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c vertical matchParent.
			c horizontal matchParent ].
	element := document asElement.
	addOns shortcuts
		do:
			[ :each | element addShortcut: (each copy action: [ each action cull: element ]) ].
	element
		constraintsDo: [ :c | 
			c vertical matchParent.
			c horizontal matchParent ].
	toolbar := GtCoderActionsElement new
		coder: self;
		padding:
			(BlInsets
				top: 0
				left: -3
				bottom: -3
				right: 0);
		margin: (BlInsets top: 5).
	container addChild: element.
	container addChild: toolbar.
	^ container
]

{ #category : #testing }
GtClassCommentCoder >> isModified [
	^ class comment ~= document string
]

{ #category : #accessing }
GtClassCommentCoder >> theClass [
	^ class
]

{ #category : #accessing }
GtClassCommentCoder >> theClass: anObject [
	class := anObject.
	document := GtDocument forClass: class.
	self updateCollapsedText
]

{ #category : #private }
GtClassCommentCoder >> updateCollapsedText [
	| firstLine |
	firstLine := (document string lines detect: #notEmpty ifNone: [ '' ])
		asRopedText.
	firstLine
		attributes:
			{(BlTextForegroundAttribute
				paint: BrGlamorousColors disabledButtonTextColor).
			(BlFontFamilyAttribute named: 'Source Sans Pro')
				beNotOverwritableByStyler.
			BlFontGenericFamilyAttribute monospace beNotOverwritableByStyler.
			(BlFontSizeAttribute size: 12) beNotOverwritableByStyler}.
	self collapsedEditor text: firstLine
]
