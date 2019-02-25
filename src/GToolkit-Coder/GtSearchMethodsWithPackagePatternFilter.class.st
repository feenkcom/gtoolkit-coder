Class {
	#name : #GtSearchMethodsWithPackagePatternFilter,
	#superclass : #GtSearchMethodsFilter,
	#instVars : [
		'pattern'
	],
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #'instance creation' }
GtSearchMethodsWithPackagePatternFilter class >> pattern: aString [
	^ self new
		pattern: aString;
		yourself
]

{ #category : #printing }
GtSearchMethodsWithPackagePatternFilter >> gtDisplayOn: stream [
	stream
		nextPutAll: self pattern printString;
		nextPutAll: ' packages matching'
]

{ #category : #testing }
GtSearchMethodsWithPackagePatternFilter >> includesMethod: aCompiledMethod [
	| package |
	package := aCompiledMethod package.
	^ pattern isEmpty or: [ (package name asLowercase indexOfSubCollection: pattern asLowercase) > 0 ]
]

{ #category : #accessing }
GtSearchMethodsWithPackagePatternFilter >> pattern [
	^ pattern
]

{ #category : #accessing }
GtSearchMethodsWithPackagePatternFilter >> pattern: aString [
	pattern := aString
]
