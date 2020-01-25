Class {
	#name : #GtMethodCoderStylerExamples,
	#superclass : #GtMethodCoderTaskExamples,
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
GtMethodCoderStylerExamples >> addPragmaMethodStyling [
	<gtExample>
	<noTest>
	| coder |
	coder := self renamePragmaMethodStyling.
	coder sourceEditor useSyncStylerStrategy.
	coder collapsedEditor useSyncStylerStrategy.
	coder sourceEditor inserter
		at: 7;
		string: 'x';
		insert.
	self waitForTasks.
	coder styleText.
	self assert: (self hasExampleExpandAttributeIn: coder).
	self assert: (self hasExampleStatusIn: coder).
	coder sourceEditor useDefaultStylerStrategy.
	coder collapsedEditor useDefaultStylerStrategy.
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
	<noTest>
	| coder |
	coder := GtMethodCoder forMethod: self class >> #b.
	coder sourceEditor useSyncStylerStrategy.
	coder collapsedEditor useSyncStylerStrategy.
	coder expanded: true.
	coder asElement.
	self waitForTasks.
	coder styleText.
	self assert: (self hasExampleExpandAttributeIn: coder).
	self assert: (self hasExampleStatusIn: coder).
	coder sourceEditor useDefaultStylerStrategy.
	coder collapsedEditor useDefaultStylerStrategy.
	^ coder
]

{ #category : #'as yet unclassified' }
GtMethodCoderStylerExamples >> explanationLinkExample [
	<gtExample>
	| container inspectorContainer editor coder coderElement selectors variables |
	
	inspectorContainer := BlElement new
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ];
		layout: BlLinearLayout horizontal;
		background: Color white;
		margin: (BlInsets all: 10);
		look: BrShadowLook.
	container := BlElement new
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ];
		layout: BlLinearLayout horizontal.
	container explainer isExplanationHolder: true.
	
	selectors := GtSelectorExplanationLinkStyler new.
	selectors addSelectors: {#syntaxOn:. #not. #+. #size. #<. #do:. #show: }.

	variables := GtVariableExplanationLinkStyler new.
	variables addVariables: {'self'. 'y' }.
	
	coder := GtMethodCoder forMethod: (GtPharoMethodExample>>#exampleWithNumber:).
	coder explanationLink: (GtCompositeExplanationLinkStyler forLinks: { variables. selectors }).
	coderElement := (coder expanded: true) asElement.
	coderElement forceLayout.
	inspectorContainer addChild: coderElement.
	
	editor := BrEditor new
		look: BrGlamorousRegularEditorLook;
		text: self explanationLinkExampleText;
		margin: (BlInsets all: 10);
		constraintsDo: [ :c | 
			c vertical matchParent.
			c horizontal matchParent.
			c linear weight: 0.3 ].
	
	container addChild: editor.
	container addChild: inspectorContainer.
	^ container.
]

{ #category : #'as yet unclassified' }
GtMethodCoderStylerExamples >> explanationLinkExampleText [
	| text |
	
	text := ('pragma' asRopedText glamorousExplanationFor: #syntaxOn:),
	'
' asRopedText,
	('not' asRopedText glamorousExplanationFor: #not),
	'
' asRopedText,
	('addition' asRopedText glamorousExplanationFor: #+),
	'
' asRopedText,
	('size' asRopedText glamorousExplanationFor: #size),
	'
' asRopedText,
	('comparison' asRopedText glamorousExplanationFor: #<),
	'
' asRopedText,
	('do' asRopedText glamorousExplanationFor: #do:),
	'
' asRopedText,
	('show' asRopedText glamorousExplanationFor: #show:),
	'
' asRopedText,
	('self' asRopedText glamorousExplanationFor: #self),
	'
' asRopedText,
	('variable y' asRopedText glamorousExplanationFor: #y).
	
	^text
		glamorousRegularFont;
		foreground: Color black.
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
	sourceAttribute := self
		hasAttributeOfType: GtExampleStatusAttribute
		in: coder sourceEditor.
	coder
		expanded: false;
		expanded: true.	"need to collapse to compute collapsed text style"
	collapsedAttribute := self
		hasAttributeOfType: GtExampleStatusAttribute
		in: coder collapsedEditor.
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
	<noTest>
	| coder |
	coder := GtMethodCoder forMethod: self class >> #a:a:a:a:.
	coder expanded: true.
	coder highlighter: (GtImplementorPatternHighlighter forPattern: 'a:').
	coder asElement.
	self waitForTasks.
	coder sourceEditor useSyncStylerStrategy.
	coder styleText.
	self assert: (self hasUnderlineAttributeIn: coder).
	self
		assert:
			(self
				attributeCountOfType: self unlineAttributeClass
				in: coder sourceEditor) = 8.
	coder sourceEditor useDefaultStylerStrategy.
	^ coder
]

{ #category : #dummies }
GtMethodCoderStylerExamples >> notAnExample [
	^ 42
]

{ #category : #accessing }
GtMethodCoderStylerExamples >> printStringImplementorPatternHighlighting [
	<gtExample>
	<noTest>
	| coder |
	coder := GtMethodCoder forMethod: self class >> #printStringReference.
	coder
		highlighter: (GtImplementorPatternHighlighter forPattern: 'print').
	coder sourceEditor useSyncStylerStrategy.
	coder expanded: true.
	coder asElement.
	self waitForTasks.
	coder styleText.
	self assert: (self hasUnderlineAttributeIn: coder).
	self
		assert:
			(self
				attributeCountOfType: self unlineAttributeClass
				in: coder sourceEditor) = 5.
	coder sourceEditor useDefaultStylerStrategy.
	^ coder
]

{ #category : #dummies }
GtMethodCoderStylerExamples >> printStringReference [
	^ self printString
]

{ #category : #accessing }
GtMethodCoderStylerExamples >> printStringReferenceHighlighting [
	<gtExample>
	<noTest>
	| coder |
	coder := GtMethodCoder forMethod: self class >> #printStringReference.
	coder
		highlighter: (GtSelectorReferenceAndLiteralHighlighter forSelector: #printString).
	coder sourceEditor useSyncStylerStrategy.
	coder expanded: true.
	coder asElement.
	self waitForTasks.
	coder styleText.
	self assert: (self hasUnderlineAttributeIn: coder).
	coder sourceEditor useDefaultStylerStrategy.
	^ coder
]

{ #category : #accessing }
GtMethodCoderStylerExamples >> renamePragmaMethodStyling [
	<gtExample>
	<noTest>
	| coder |
	coder := self exampleMethodStyling.
	coder sourceEditor useSyncStylerStrategy.
	coder collapsedEditor useSyncStylerStrategy.
	coder sourceEditor deleter
		from: 7 to: 8;
		delete.
	coder styleText.
	self waitForTasks.
	self assert: (self hasExampleExpandAttributeIn: coder).
	self assert: (self hasExampleStatusIn: coder) not.
	coder sourceEditor useDefaultStylerStrategy.
	coder collapsedEditor useDefaultStylerStrategy.
	^ coder
]

{ #category : #accessing }
GtMethodCoderStylerExamples >> unlineAttributeClass [
	^ BlTextUnderlineAttribute
]

{ #category : #'as yet unclassified' }
GtMethodCoderStylerExamples >> viewsExplanationWithLinks [
	<gtExample>
	| container inspectorContainer editor coder coderElement selectors variables |
	inspectorContainer := BlElement new
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ];
		layout: BlLinearLayout horizontal.
	container := BlElement new
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent];
		layout: BlLinearLayout horizontal alignCenter.
	container explainer isExplanationHolder: true.
	
	selectors := GtSelectorExplanationLinkStyler new.
	selectors addSelectors: {#gtView . #columnedList . #title: . #items: . #column:format: .#contacts . #fullName . #telephone }.
	
	variables := GtVariableExplanationLinkStyler new.
	variables addVariables: {'aView' . 'aContact' . 'contacts'}.
	
	coder := GtMethodCoder forMethod: (GtABAddressBook>>#gtViewContactsOn:).
	coder explanationLink: (GtCompositeExplanationLinkStyler forLinks: { selectors. variables }).
	coderElement := (coder expanded: true) asElement margin: (BlInsets all: 10).
	coderElement forceLayout.
	
	inspectorContainer addChild: coderElement.
	
	editor := BrEditor new
		look: (BrGlamorousRegularEditorLook new fontSize: 16);
		text: self viewsExplanationWithLinksText;
		margin: (BlInsets all: 10);
		constraintsDo: [ :c | 
			c vertical fitContent.
			c horizontal matchParent.
			c linear weight: 0.5 ].
	container addChild: editor.
	container addChild: inspectorContainer.
	^ container
]

{ #category : #'as yet unclassified' }
GtMethodCoderStylerExamples >> viewsExplanationWithLinksText [
	| text |
	
	text := 'A custom view is defined by a method in the class of the object we want to view. You can think of it as a print string method only that instead of returning a string, it returns an element.

As we can have many such representations for every single object, we have to identify the method. To this end, use the ' asRopedText,
('gtView' asRopedText glamorousExplanationFor: #gtView),
' pragma.
Then, make it so that it gets an empty ' asRopedText,
('view' asRopedText glamorousExplanationFor: #aView),
' parameter that you can customize.

In our case the view has a ' asRopedText,
('title' asRopedText glamorousExplanationFor: #title:),
'. The view consists of a ' asRopedText,
('columned list' asRopedText glamorousExplanationFor: #columnedList),
' with ' asRopedText,
('two columns' asRopedText glamorousExplanationFor: #column:format:),
'

The columned list has as many rows as the collection returned by the ' asRopedText,
('items: block' asRopedText glamorousExplanationFor: #items:),
'. In this case, this means it shows all the ' asRopedText,
('contacts list' asRopedText glamorousExplanationFor: #contacts),

'For each ' asRopedText, 
('contact' asRopedText glamorousExplanationFor: #aContact),
' we show the ' asRopedText,
('full name' asRopedText glamorousExplanationFor: #fullName),
' in the first column, and the ' asRopedText,
('telephone' asRopedText glamorousExplanationFor: #telephone),
' in the second column' asRopedText.
	^ text
		glamorousRegularFont;
		fontSize: 20;
		foreground: Color black.
]
