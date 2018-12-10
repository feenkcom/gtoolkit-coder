Class {
	#name : #GtCoderImplementorPatternFilter,
	#superclass : #GtCoderMethodsFilter,
	#instVars : [
		'pattern'
	],
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #'instance creation' }
GtCoderImplementorPatternFilter class >> pattern: aString [
	^ self new
		pattern: aString;
		yourself
]

{ #category : #testing }
GtCoderImplementorPatternFilter >> includeMethod: aCompiledMethod [
	^ pattern isEmpty or: [ (aCompiledMethod selector asLowercase indexOfSubCollection: pattern asLowercase) > 0 ]
]

{ #category : #accessing }
GtCoderImplementorPatternFilter >> pattern: aString [
	pattern := aString
]
