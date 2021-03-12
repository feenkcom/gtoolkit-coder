Class {
	#name : #GtStylerExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-By scripter'
}

{ #category : #examples }
GtStylerExamples >> expanderAttribute [
	<gtExample>
	| text source ast index |
	source := 'foo self do: [:each | Transcript print: each]'.
	ast := RBParser parseMethod: source.
	ast methodNode
		compilationContext: (CompilationContext new class: Collection).
	ast doSemanticAnalysis.
	text := source asRopedText.
	GtCoderExpandableMethodStyler new style: text ast: ast.
	index := source indexOfSubCollection: 'do:'.
	self assert: (self indexOfExpanderIn: text) = (index + 2).
	^ text
]

{ #category : #private }
GtStylerExamples >> indexOfExpanderIn: ropedText [
	1 to: ropedText size do: [ :i | 
		((ropedText attributesAt: i)
			anySatisfy: [ :attr | attr isKindOf: GtPharoMethodExpanderAttribute ])
			ifTrue: [ ^ i ] ].
	^ -1
]

{ #category : #accessing }
GtStylerExamples >> messageToGlobal [
	<gtExample>
	| text source ast |
	source := 'foo Transcript print: each'.
	ast := RBParser parseMethod: source.
	ast methodNode
		compilationContext: (CompilationContext new class: Collection).
	ast doSemanticAnalysis.
	text := source asRopedText.
	GtCoderExpandableMethodStyler new style: text ast: ast.
	self
		assert:
			((self methodExpanderAttributesIn: text)
				anySatisfy: [ :each | each selector = #print: ]).
	^ text
]

{ #category : #accessing }
GtStylerExamples >> messageToLiteral [
	<gtExample>
	| text source ast |
	source := 'foo ^42 odd'.
	ast := RBParser parseMethod: source.
	ast methodNode
		compilationContext: (CompilationContext new class: Collection).
	ast doSemanticAnalysis.
	text := source asRopedText.
	GtCoderExpandableMethodStyler new style: text ast: ast.
	self
		assert:
			((self methodExpanderAttributesIn: text)
				anySatisfy: [ :each | each selector = #odd ]).
	^ text
]

{ #category : #examples }
GtStylerExamples >> methodExpanderAttributesIn: ropedText [
	| attributes |
	attributes := OrderedCollection new.
	1 to: ropedText size do: [ :i | 
		(ropedText attributesAt: i)
			do: [ :attr | 
				(attr isKindOf: GtPharoMethodExpanderAttribute)
					ifTrue: [ attributes add: attr ] ] ].
	^ attributes
]

{ #category : #examples }
GtStylerExamples >> missingSelfSend [
	<gtExample>
	| text source ast |
	source := 'foo self nonExistentMethod: [:each | Transcript print: each]'.
	ast := RBParser parseMethod: source.
	ast methodNode
		compilationContext: (CompilationContext new class: Collection).
	ast doSemanticAnalysis.
	text := source asRopedText.
	GtCoderExpandableMethodStyler new style: text ast: ast.
	self
		assert:
			((self methodExpanderAttributesIn: text)
				allSatisfy: [ :each | each selector ~= #nonExistentMethod ]).
	^ text
]

{ #category : #examples }
GtStylerExamples >> missingSuperSend [
	<gtExample>
	| text source ast |
	source := 'foo super do: [:each | Transcript print: each]'.
	ast := RBParser parseMethod: source.
	ast methodNode
		compilationContext: (CompilationContext new class: Collection).
	ast doSemanticAnalysis.
	text := source asRopedText.
	GtCoderExpandableMethodStyler new style: text ast: ast.
	self
		assert:
			((self methodExpanderAttributesIn: text)
				allSatisfy: [ :each | each selector ~= #do: ]).
	^ text
]

{ #category : #examples }
GtStylerExamples >> superExpanderAttribute [
	<gtExample>
	| text source ast index |
	source := 'foo super do: [:each | Transcript print: each]'.
	ast := RBParser parseMethod: source.
	ast methodNode
		compilationContext: (CompilationContext new class: SequenceableCollection).
	ast doSemanticAnalysis.
	text := source asRopedText.
	GtCoderExpandableMethodStyler new style: text ast: ast.
	index := source indexOfSubCollection: 'do:'.
	self assert: (self indexOfExpanderIn: text) = (index + 2).
	^ text
]
