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

{ #category : #elements }
GtClassCommentCoder >> breadcrumbItemElements [
	<return: #Collection of: #BrButton>
	| theNamedActions |
	"Array (name -> action)"
	theNamedActions := Array
		streamContents: [ :aStream | 
			| aPackage aPackageName aClass |
			aPackage := class package.
			aPackageName := aPackage ifNil: [ '' ] ifNotNil: #name.
			aClass := class.
			aStream
				nextPut: aPackageName -> [ :aButton | aButton phlow spawnObject: aPackage ];
				nextPut:
					aClass name
						->
							[ :aButton | aButton phlow spawnObject: (GtClassCoder forClass: aClass) ] ].
	^ theNamedActions
		collect: [ :eachNamedAction | 
			BrButton new
				look:
					(BrGlamorousLabelLook new
						foreground: BrGlamorousColors defaultButtonTextColor;
						fontSize: 12);
				label: eachNamedAction key;
				action: eachNamedAction value ]
]

{ #category : #accessing }
GtClassCommentCoder >> collapsedEditor [
	^ collapsedEditor ifNil: [ collapsedEditor := BrTextEditor new ]
]

{ #category : #ui }
GtClassCommentCoder >> collapsedEditorElement [
	^ BrEditorElement new
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ];
		editor: self collapsedEditor;
		yourself
]

{ #category : #ui }
GtClassCommentCoder >> expandedEditorElement [
	^ document asElement
		constraintsDo: [ :c | 
			c vertical matchParent.
			c horizontal matchParent ];
		in: [ :e | self addShortcutsTo: e ];
		yourself
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
