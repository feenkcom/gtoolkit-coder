Class {
	#name : #GtFiltersDummyObjectWithExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Filters - UI'
}

{ #category : #accessing }
GtFiltersDummyObjectWithExamples >> foo [
	^ 42
]

{ #category : #examples }
GtFiltersDummyObjectWithExamples >> one [
	<gtExample>
	^ 42
]

{ #category : #examples }
GtFiltersDummyObjectWithExamples >> three [
	<gtExample>
	self assert: false
]

{ #category : #examples }
GtFiltersDummyObjectWithExamples >> two [
	<gtExample>
	^ 1/0
]
