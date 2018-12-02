Class {
	#name : #GtMethodCoderStylerExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples'
}

{ #category : #dummies }
GtMethodCoderStylerExamples >> a [
	<gtExample>
	^ 42
]

{ #category : #accessing }
GtMethodCoderStylerExamples >> addPragmaMethodStyling [
	<gtExample>
	| coder |
	coder := self renamePragmaMethodStyling.
	coder sourceEditor inserter
		at: 7;
		string: 'x';
		insert.
	coder sourceEditor styleText.
	self assert: (self hasExampleExpandAttributeIn: coder).
	self assert: (self hasExampleStatusIn: coder).
	^ coder
]

{ #category : #dummies }
GtMethodCoderStylerExamples >> b [
	<gtExample>
	^ self a * self notAnExample
]

{ #category : #accessing }
GtMethodCoderStylerExamples >> exampleMethodStyling [
	<gtExample>
	| coder element |
	coder := GtMethodCoder forMethod: self class >> #b.
	element := coder asElement.
	coder sourceEditor styleText.
	self assert: (self hasExampleExpandAttributeIn: coder).
	self assert: (self hasExampleStatusIn: coder).
	^ coder
]

{ #category : #accessing }
GtMethodCoderStylerExamples >> hasAttributeOfType: aClass in: aTextEditor [
	| text found iterator |
	text := aTextEditor text.
	iterator := text iterator.
	[ iterator hasNext ]
		whileTrue: [ (iterator attributes anySatisfy: [ :each | each isKindOf: aClass ])
				ifTrue: [ ^ true ].
			iterator next ].
	^ false
]

{ #category : #accessing }
GtMethodCoderStylerExamples >> hasCodeReferenceAttributeIn: coder [
	^ self hasAttributeOfType: BlTextUnderlineAttribute in: coder sourceEditor
]

{ #category : #accessing }
GtMethodCoderStylerExamples >> hasExampleExpandAttributeIn: coder [
	^ self hasAttributeOfType: BrTextExpandButtonAttribute in: coder sourceEditor
]

{ #category : #accessing }
GtMethodCoderStylerExamples >> hasExampleStatusIn: coder [
	| collapsedAttribute sourceAttribute |
	sourceAttribute := self hasAttributeOfType: GtExampleStatusAttribute in: coder sourceEditor.
	collapsedAttribute := self hasAttributeOfType: GtExampleStatusAttribute in: coder collapsedEditor.
	self assert: sourceAttribute = collapsedAttribute.
	^ sourceAttribute
]

{ #category : #dummies }
GtMethodCoderStylerExamples >> notAnExample [
	^ 42
]

{ #category : #dummies }
GtMethodCoderStylerExamples >> printStringReference [
	^ self printString
]

{ #category : #accessing }
GtMethodCoderStylerExamples >> printStringReferenceHighlighting [
	<gtExample>
	| coder element |
	coder := GtMethodCoder forMethod: self class >> #printStringReference.
	coder highlighter: (GtSelectorReferenceHighlighter forSelector: #printString).
	element := coder asElement.
	coder sourceEditor styleText.
	self assert: (self hasCodeReferenceAttributeIn: coder).
	^ coder
]

{ #category : #accessing }
GtMethodCoderStylerExamples >> renamePragmaMethodStyling [
	<gtExample>
	| coder |
	coder := self exampleMethodStyling.
	coder sourceEditor deleter
		from: 7 to: 8;
		delete.
	coder styleText.
	self assert: (self hasExampleExpandAttributeIn: coder) not.
	self assert: (self hasExampleStatusIn: coder) not.
	^ coder
]
