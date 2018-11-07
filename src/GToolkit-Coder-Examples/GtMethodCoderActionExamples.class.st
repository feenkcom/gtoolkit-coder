Class {
	#name : #GtMethodCoderActionExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples'
}

{ #category : #examples }
GtMethodCoderActionExamples >> addExampleTag [
	<gtExample>
	| coder |
	coder := self noExampleTag.
	coder sourceEditor inserter
		at: 0;
		string: '<gtExample>' , String cr;
		insert.
	self assert: (self hasRunExampleActionIn: coder).
	^ coder
]

{ #category : #testing }
GtMethodCoderActionExamples >> hasRunExampleActionIn: aCoder [
	^ aCoder contextActions anySatisfy: [ :each | each title = 'Run' translated ]
]

{ #category : #examples }
GtMethodCoderActionExamples >> noExampleTag [
	<gtExample>
	| coder |
	coder := GtMethodCoder forMethod: self class >> #nonTaggedMethod.
	coder asElement.
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
		from: 2 to: 3;
		delete.
	self assert: (self hasRunExampleActionIn: coder) not.
	^ coder
]
