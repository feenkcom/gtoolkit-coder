"
I am a ${class:GtFiltersDummyObjectWithExampleStates}$.
I am used for testing purposes, see my ${class:GtFiltersDummyObjectWithFailureExampleStates|label=references|show=#gtAllReferencesFor:|expanded=true}$:
"
Class {
	#name : #GtFiltersDummyObjectWithFailureExampleStates,
	#superclass : #GtFiltersDummyObjectWithExampleStates,
	#category : #'GToolkit-Coder-Examples-Filters - UI'
}

{ #category : #examples }
GtFiltersDummyObjectWithFailureExampleStates >> three [
	<gtExample>
	<noTest>
	self assert: false
]
