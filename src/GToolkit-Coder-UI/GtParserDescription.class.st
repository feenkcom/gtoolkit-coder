Class {
	#name : #GtParserDescription,
	#superclass : #Object,
	#instVars : [
		'parser',
		'scanner'
	],
	#category : #'GToolkit-Coder-UI-Forms - Models'
}

{ #category : #accessing }
GtParserDescription >> defaultParser [
	^ 'SomeParser'
]

{ #category : #accessing }
GtParserDescription >> defaultScanner [
	^ 'SomeScanner'
]

{ #category : #initialization }
GtParserDescription >> initialize [
	parser := self defaultParser.
	scanner := self defaultScanner
]

{ #category : #accessing }
GtParserDescription >> parser [

	^ parser
]

{ #category : #accessing }
GtParserDescription >> parser: anObject [

	parser := anObject
]

{ #category : #magritte }
GtParserDescription >> parserDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Parser';
		priority: 1;
		accessor: #parser;
		blocCompletion: [ GtStringsCompletionStrategy new
				completions: (GtPrefixTree withAll: (Smalltalk allClasses collect: #name)) ];
		addCondition: [ :aValue | (Smalltalk classNamed: aValue trim) isNil ]
			labelled: 'Class name is already taken';
		addCondition: [ :aValue | aValue first isUppercase ]
			labelled: 'First character must be uppercase';
		addCondition: [ :aValue | aValue isAllAlphaNumerics ]
			labelled: 'Class name must be alphanumeric'
]

{ #category : #accessing }
GtParserDescription >> scanner [

	^ scanner
]

{ #category : #accessing }
GtParserDescription >> scanner: anObject [

	scanner := anObject
]

{ #category : #magritte }
GtParserDescription >> scannerDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Scanner';
		priority: 2;
		accessor: #scanner;
		blocCompletion: [ GtStringsCompletionStrategy new
				completions: (GtPrefixTree withAll: (Smalltalk allClasses collect: #name)) ];
		addCondition: [ :aValue | (Smalltalk classNamed: aValue trim) isNil ]
			labelled: 'Class name is already taken';
		addCondition: [ :aValue | aValue first isUppercase ]
			labelled: 'First character must be uppercase';
		addCondition: [ :aValue | aValue isAllAlphaNumerics ]
			labelled: 'Class name must be alphanumeric'
]
