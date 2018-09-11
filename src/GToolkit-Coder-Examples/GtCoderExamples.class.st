Class {
	#name : #GtCoderExamples,
	#superclass : #Object,
	#category : 'GToolkit-Coder-Examples'
}

{ #category : #'sample methods' }
GtCoderExamples >> ? anObject [
	"Test binary method"
]

{ #category : #model }
GtCoderExamples >> binaryMethodCoder [
	<gtExample>
	| method methodCoder source |
	method := self class >> #?.
	methodCoder := GtMethodCoder forMethod: method.
	source := method sourceCode.
	self assert: methodCoder patternSource = '? anObject'.
	self assert: methodCoder bodySource = '	"Test binary method"'.
	^ methodCoder
]

{ #category : #ui }
GtCoderExamples >> bodyElementForThisMethod [
	<gtExample>
	^ self thisMethod bodyElement
]

{ #category : #ui }
GtCoderExamples >> elementForOrderedCollectionMethods [
	<gtExample>
	| container |
	container := BlElement new.
	container layout: BlLinearLayout vertical.
	container padding: (BlInsets all: 10).
	container
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	container addChildren: (self orderedCollectionMethods collect: [ :each | each asElement ]).
	^ container
]

{ #category : #ui }
GtCoderExamples >> elementForThisMethod [
	<gtExample>
	^ self thisMethod asElement
]

{ #category : #'sample methods' }
GtCoderExamples >> emptyBody [
]

{ #category : #model }
GtCoderExamples >> emptyBodyCoder [
	<gtExample>
	| method methodCoder source |
	method := self class >> #emptyBody.
	methodCoder := GtMethodCoder forMethod: method.
	source := method sourceCode.
	self assert: methodCoder patternSource = 'emptyBody'.
	self assert: methodCoder bodySource = ''.
	^ methodCoder
]

{ #category : #'sample methods' }
GtCoderExamples >> emptyLines [



"Some empty lines"
]

{ #category : #model }
GtCoderExamples >> emptyLinesCoder [
	<gtExample>
	| method methodCoder source |
	method := self class >> #emptyLines.
	methodCoder := GtMethodCoder forMethod: method.
	source := method sourceCode.
	self assert: methodCoder patternSource = 'emptyLines'.
	self assert: methodCoder bodySource = '"Some empty lines"'.
	^ methodCoder
]

{ #category : #'sample methods' }
GtCoderExamples >> keyword: a selector: b [
	^ a + b
]

{ #category : #model }
GtCoderExamples >> keywordSelectorCoder [
	<gtExample>
	| method methodCoder source |
	method := self class >> #keyword:selector:.
	methodCoder := GtMethodCoder forMethod: method.
	source := method sourceCode.
	self assert: methodCoder patternSource = 'keyword: a selector: b'.
	self assert: methodCoder bodySource = '	^ a + b'.
	^ methodCoder
]

{ #category : #'sample methods' }
GtCoderExamples >> noSpaces|a|a:=3.^a*a [
]

{ #category : #model }
GtCoderExamples >> noSpacesCoder [
	<gtExample>
	| method methodCoder source |
	method := self class >> #noSpaces.
	methodCoder := GtMethodCoder forMethod: method.
	source := method sourceCode.
	self assert: methodCoder patternSource = 'noSpaces'.
	self assert: methodCoder bodySource = '|a|a:=3.^a*a'.
	^ methodCoder
]

{ #category : #model }
GtCoderExamples >> orderedCollectionMethods [
	<gtExample>
	| class |
	class := OrderedCollection.
	^ class selectors asSortedCollection collect: [ :each | GtMethodCoder forMethod: class >> each ]
]

{ #category : #'sample methods' }
GtCoderExamples >> returnSelf [ ^self
]

{ #category : #model }
GtCoderExamples >> selfReturnCoder [
	<gtExample>
	| method methodCoder |
	method := self class >> #returnSelf.
	methodCoder := GtMethodCoder forMethod: method.
	self assert: methodCoder patternSource = 'returnSelf '.
	self assert: methodCoder bodySource = '^self'.
	^ methodCoder
]

{ #category : #model }
GtCoderExamples >> thisMethod [
	<gtExample>
	| method methodCoder source |
	method := self class >> #thisMethod.
	methodCoder := GtMethodCoder forMethod: method.
	source := method sourceCode.
	self assert: methodCoder patternSource = (source first: (source indexOf: Character cr) - 1).
	self assert: methodCoder bodySource = (source allButFirst: (source indexOf: Character cr)).
	^ methodCoder
]
