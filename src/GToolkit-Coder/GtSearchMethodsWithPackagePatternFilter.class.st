Class {
	#name : #GtSearchMethodsWithPackagePatternFilter,
	#superclass : #GtSearchMethodsFilter,
	#instVars : [
		'pattern'
	],
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #accessing }
GtSearchMethodsWithPackagePatternFilter class >> filterDescriptorFor: aMethodsCoder [
	^ GtFilterDescriptor
		forClass: self
		named: 'Package'
		order: 30
		getter: #pattern
		setter: #pattern:
		completion:
			(GtStringsCompletionStrategy new
				completions: aMethodsCoder packageNames)
]

{ #category : #'instance creation' }
GtSearchMethodsWithPackagePatternFilter class >> pattern: aString [
	^ self new
		pattern: aString;
		yourself
]

{ #category : #comparing }
GtSearchMethodsWithPackagePatternFilter >> = anObject [
	^ self class = anObject class
		and: [ self pattern asLowercase = anObject pattern asLowercase ]
]

{ #category : #printing }
GtSearchMethodsWithPackagePatternFilter >> gtDisplayOn: stream [
	stream
		nextPutAll: self pattern printString;
		nextPutAll: ' packages matching'
]

{ #category : #comparing }
GtSearchMethodsWithPackagePatternFilter >> hash [
	^ self class hash bitXor: self pattern asLowercase hash
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
