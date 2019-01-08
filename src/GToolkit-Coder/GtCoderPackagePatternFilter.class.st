Class {
	#name : #GtCoderPackagePatternFilter,
	#superclass : #GtCoderMethodsFilter,
	#instVars : [
		'pattern'
	],
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #'instance creation' }
GtCoderPackagePatternFilter class >> pattern: aString [
	^ self new
		pattern: aString;
		yourself
]

{ #category : #printing }
GtCoderPackagePatternFilter >> gtDisplayOn: stream [
	stream
		nextPutAll: self pattern printString;
		nextPutAll: ' packages matching'
]

{ #category : #testing }
GtCoderPackagePatternFilter >> includeMethod: aCompiledMethod [
	| package |
	package := aCompiledMethod package.
	^ pattern isEmpty or: [ (package name asLowercase indexOfSubCollection: pattern asLowercase) > 0 ]
]

{ #category : #accessing }
GtCoderPackagePatternFilter >> pattern [
	^ pattern
]

{ #category : #accessing }
GtCoderPackagePatternFilter >> pattern: aString [
	pattern := aString
]
