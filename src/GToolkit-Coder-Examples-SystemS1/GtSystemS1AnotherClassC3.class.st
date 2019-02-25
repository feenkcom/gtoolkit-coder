Class {
	#name : #GtSystemS1AnotherClassC3,
	#superclass : #Object,
	#instVars : [
		'anAttributeInS1C3'
	],
	#category : #'GToolkit-Coder-Examples-SystemS1'
}

{ #category : #deprecation }
GtSystemS1AnotherClassC3 class >> isDeprecated [
	^ true
]

{ #category : #example }
GtSystemS1AnotherClassC3 >> methodWithExample [
	<gtExample>
	^ self class new
]

{ #category : #'access options' }
GtSystemS1AnotherClassC3 >> oneMethodOnS1C3 [
	^ #one
]

{ #category : #'access options' }
GtSystemS1AnotherClassC3 >> secondMethodOnS1C3 [
	^ #second
]

{ #category : #'access options' }
GtSystemS1AnotherClassC3 >> thirdMethodOnS1C3 [
	^ anAttributeInS1C3
]

{ #category : #'as yet unclassified' }
GtSystemS1AnotherClassC3 >> unclassifiedMethodS1C3 [
]
