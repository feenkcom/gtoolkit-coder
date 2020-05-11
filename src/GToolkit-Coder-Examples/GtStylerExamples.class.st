Class {
	#name : #GtStylerExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples'
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
			anySatisfy: [ :attr | attr isKindOf: BrTextExpandButtonAttribute ])
			ifTrue: [ ^ i ] ].
	^ -1
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
	self assert: (self indexOfExpanderIn: text) = -1.
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
	self assert: (self indexOfExpanderIn: text) = -1.
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
