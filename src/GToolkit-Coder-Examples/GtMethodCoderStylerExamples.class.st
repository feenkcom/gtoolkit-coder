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
		at: 5;
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
	found := false.
	[ found not and: [ iterator hasNext ] ]
		whileTrue: [ iterator next.
			found := iterator attributes anySatisfy: [ :each | each isKindOf: aClass ] ].
	^ found
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
	^ self hasAttributeOfType: GtExampleStatusAttribute in: coder patternEditor
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
		from: 5 to: 6;
		delete.
	coder sourceEditor styleText.
	self assert: (self hasExampleExpandAttributeIn: coder) not.
	self assert: (self hasExampleStatusIn: coder) not.
	^ coder
]
