Class {
	#name : #GtClassCommentCoder,
	#superclass : #GtCoderModel,
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
GtClassCommentCoder >> breadcrumbNamedActions [
	^ Array
		streamContents: [ :aStream | 
			| aPackage aPackageName aClass |
			aPackage := class package.
			aPackageName := aPackage ifNil: [ '' ] ifNotNil: #name.
			aClass := class.
			aStream
				nextPut: aPackageName -> [ :aButton | aButton phlow spawnTool: (GtPackageCoderTool package: aPackage) ];
				nextPut:
					aClass name
						->
							[ :aButton | aButton phlow spawnTool: (GtClassCoderTool observedClass: aClass) ] ]
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

{ #category : #'as yet unclassified' }
GtClassCommentCoder >> commentChanged: anAnnouncement [
	anAnnouncement classAffected == class
		ifFalse: [ ^ self ].
	document text: class comment.
	self updateCollapsedText
]

{ #category : #ui }
GtClassCommentCoder >> expandedEditorElement [
	^ document asElement
		hMatchParent;
		vFitContent;
		in: [ :e | self addShortcutsTo: e ];
		yourself
]

{ #category : #testing }
GtClassCommentCoder >> isModified [
	^ class comment ~= document string
]

{ #category : #subscriptions }
GtClassCommentCoder >> subscribeToSystem [
	SystemAnnouncer uniqueInstance weak
		when: ClassCommented
		send: #commentChanged:
		to: self
]

{ #category : #accessing }
GtClassCommentCoder >> theClass [
	^ class
]

{ #category : #accessing }
GtClassCommentCoder >> theClass: anObject [
	class := anObject.
	document := GtDocumenter forClass: class.
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
	self collapsedEditor text: firstLine readonly
]
