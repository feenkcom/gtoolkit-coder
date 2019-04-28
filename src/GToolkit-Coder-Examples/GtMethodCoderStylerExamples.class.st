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
GtMethodCoderStylerExamples >> a: arg1 a: arg2 a: arg3 a: arg4 [
	"test method for highlighting implementors"
]

{ #category : #accessing }
GtMethodCoderStylerExamples >> acrossKeywordImplementorPatternHighlighting [
	<gtExample>
	| coder element |
	coder := GtMethodCoder forMethod: self class >> #a:a:a:a:.
	coder highlighter: (GtImplementorPatternHighlighter forPattern: ':a:').
	element := coder asElement.
	coder styleText.
	self assert: (self hasUnderlineAttributeIn: coder).
	self assert: (self attributeCountOfType: self unlineAttributeClass in: coder sourceEditor) = 6.
	^ coder
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

{ #category : #accessing }
GtMethodCoderStylerExamples >> attributeCountOfType: aClass in: aTextEditor [
	| text iterator count |
	count := 0.
	text := aTextEditor text.
	iterator := text iterator.
	[ iterator hasNext ]
		whileTrue: [ (iterator attributes anySatisfy: [ :each | each isKindOf: aClass ])
				ifTrue: [ count := count + 1 ].
			iterator next ].
	^ count
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
	^ (self attributeCountOfType: aClass in: aTextEditor) > 0
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

{ #category : #accessing }
GtMethodCoderStylerExamples >> hasUnderlineAttributeIn: coder [
	^ self hasAttributeOfType: self unlineAttributeClass in: coder sourceEditor
]

{ #category : #accessing }
GtMethodCoderStylerExamples >> insideMultipleKeywordImplementorPatternHighlighting [
	<gtExample>
	| coder element |
	coder := GtMethodCoder forMethod: self class >> #a:a:a:a:.
	coder highlighter: (GtImplementorPatternHighlighter forPattern: 'a:').
	element := coder asElement.
	coder styleText.
	self assert: (self hasUnderlineAttributeIn: coder).
	self assert: (self attributeCountOfType: self unlineAttributeClass in: coder sourceEditor) = 8.
	^ coder
]

{ #category : #dummies }
GtMethodCoderStylerExamples >> notAnExample [
	^ 42
]

{ #category : #accessing }
GtMethodCoderStylerExamples >> printStringImplementorPatternHighlighting [
	<gtExample>
	| coder element |
	coder := GtMethodCoder forMethod: self class >> #printStringReference.
	coder highlighter: (GtImplementorPatternHighlighter forPattern: 'print').
	element := coder asElement.
	coder sourceEditor styleText.
	self assert: (self hasUnderlineAttributeIn: coder).
	self assert: (self attributeCountOfType: self unlineAttributeClass in: coder sourceEditor) = 5.
	^ coder
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
	coder highlighter: (GtSelectorReferenceAndLiteralHighlighter forSelector: #printString).
	element := coder asElement.
	coder sourceEditor styleText.
	self assert: (self hasUnderlineAttributeIn: coder).
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
	self assert: (self hasExampleExpandAttributeIn: coder).
	self assert: (self hasExampleStatusIn: coder) not.
	^ coder
]

{ #category : #accessing }
GtMethodCoderStylerExamples >> unlineAttributeClass [
	^ BlTextUnderlineAttribute
]
