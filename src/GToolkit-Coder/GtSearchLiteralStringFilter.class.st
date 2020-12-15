Class {
	#name : #GtSearchLiteralStringFilter,
	#superclass : #GtSearchMethodsFilter,
	#instVars : [
		'substring',
		'caseSensitive'
	],
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #'api - instance creation' }
GtSearchLiteralStringFilter class >> substring: aString [
	^ self new substring: aString
]

{ #category : #'api - instance creation' }
GtSearchLiteralStringFilter class >> substring: aString caseSensitive: aBoolean [
	^ self new substring: aString; caseSensitive: aBoolean
]

{ #category : #comparing }
GtSearchLiteralStringFilter >> = anObject [
	^ self class = anObject class
		and: [ self substring asLowercase = anObject substring asLowercase ]
]

{ #category : #accessing }
GtSearchLiteralStringFilter >> beCaseInsensitive [
	self caseSensitive: false
]

{ #category : #'api - accessing' }
GtSearchLiteralStringFilter >> beCaseSensitive [
	self caseSensitive: true
]

{ #category : #'api - accessing' }
GtSearchLiteralStringFilter >> caseSensitive [
	<return: #Boolean>
	^ caseSensitive
]

{ #category : #accessing }
GtSearchLiteralStringFilter >> caseSensitive: aBoolean [
	self 
		assert: [ aBoolean isBoolean ] 
		description: [ 'Case sensitive must be a boolean value' ].
	caseSensitive := aBoolean.
]

{ #category : #accessing }
GtSearchLiteralStringFilter >> filterValueString [
	^ self substring
]

{ #category : #printing }
GtSearchLiteralStringFilter >> gtDisplayOn: stream [
	stream
		print: self substring;
		nextPutAll: ' substringLiteralMatch'
]

{ #category : #comparing }
GtSearchLiteralStringFilter >> hash [
	^ self class hash bitXor: self substring asLowercase hash
]

{ #category : #testing }
GtSearchLiteralStringFilter >> includesMethod: aCompiledMethod [
	^ aCompiledMethod hasLiteralSuchThat: [ :aLiteralNode |
		aLiteralNode isString 
		and: [ aLiteralNode isSymbol not 
		and: [ aLiteralNode 
			includesSubstring: self substring 
			caseSensitive: self caseSensitive] ] ]
]

{ #category : #initialization }
GtSearchLiteralStringFilter >> initialize [
	super initialize.
	caseSensitive := false.
]

{ #category : #'api - accessing' }
GtSearchLiteralStringFilter >> substring [
	^ substring
]

{ #category : #accessing }
GtSearchLiteralStringFilter >> substring: aString [
	substring := aString
]
