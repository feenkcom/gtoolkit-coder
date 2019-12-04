Class {
	#name : #GtMethodCoderActionExamples,
	#superclass : #GtMethodCoderTaskExamples,
	#category : #'GToolkit-Coder-Examples'
}

{ #category : #examples }
GtMethodCoderActionExamples >> addExampleTag [
	<gtExample>
	| coder |
	coder := self noExampleTag.
	coder sourceEditor inserter
		at: 16;
		string: '<gtExample>' , String cr;
		insert.
	self waitForTasks.
	self assert: (self hasRunExampleActionIn: coder).
	^ coder
]

{ #category : #testing }
GtMethodCoderActionExamples >> hasRunExampleActionIn: aCoder [
	^ aCoder contextActions anySatisfy: [ :each | 
			each title = 'Play' translated and: [ 
				each action method = (GtMethodCoder>>#exampleAstFor:into:) ] ]
]

{ #category : #examples }
GtMethodCoderActionExamples >> noExampleTag [
	<gtExample>
	| coder |
	coder := GtMethodCoder forMethod: self class >> #nonTaggedMethod.
	coder asElement.
	self waitForTasks.
	self assert: (self hasRunExampleActionIn: coder) not.
	^ coder
]

{ #category : #dummies }
GtMethodCoderActionExamples >> nonTaggedMethod [
	^ 42
]

{ #category : #examples }
GtMethodCoderActionExamples >> removeExampleTag [
	<gtExample>
	| coder |
	coder := self addExampleTag.
	coder sourceEditor deleter
		from: 17 to: 18;
		delete.
	self waitForTasks.
	self assert: (self hasRunExampleActionIn: coder) not.
	^ coder
]
