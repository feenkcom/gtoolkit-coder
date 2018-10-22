Class {
	#name : #GtMethodCoderExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples'
}

{ #category : #'sample methods' }
GtMethodCoderExamples >> ? anObject [
	"Test binary method"
]

{ #category : #model }
GtMethodCoderExamples >> binaryMethodCoder [
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
GtMethodCoderExamples >> bodyElementForThisMethod [
	<gtExample>

	^ GtCoderMethodBodyStencil new
		methodCoder: self thisMethod;
		asElement
]

{ #category : #ui }
GtMethodCoderExamples >> elementForOrderedCollectionMethods [
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
GtMethodCoderExamples >> elementForThisMethod [
	<gtExample>
	^ self thisMethod asElement
]

{ #category : #'sample methods' }
GtMethodCoderExamples >> emptyBody [
]

{ #category : #model }
GtMethodCoderExamples >> emptyBodyCoder [
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
GtMethodCoderExamples >> emptyLines [



"Some empty lines"
]

{ #category : #model }
GtMethodCoderExamples >> emptyLinesCoder [
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
GtMethodCoderExamples >> keyword: a selector: b [
	^ a + b
]

{ #category : #model }
GtMethodCoderExamples >> keywordSelectorCoder [
	<gtExample>
	| method methodCoder source |
	method := self class >> #keyword:selector:.
	methodCoder := GtMethodCoder forMethod: method.
	source := method sourceCode.
	self assert: methodCoder patternSource = 'keyword: a selector: b'.
	self assert: methodCoder bodySource = '	^ a + b'.
	^ methodCoder
]

{ #category : #model }
GtMethodCoderExamples >> noSpacesCoder [
	<gtExample>
	| method methodCoder source |
	method := self class >> #noSpacesCoder.
	methodCoder := GtMethodCoder forMethod: method.
	source := method sourceCode.
	self assert: methodCoder patternSource = 'noSpacesCoder'.
	self assert: (methodCoder bodySource beginsWith: String tab, '<gtExample').
	^ methodCoder
]

{ #category : #model }
GtMethodCoderExamples >> orderedCollectionMethods [
	<gtExample>
	| class |
	class := OrderedCollection.
	^ class selectors asSortedCollection collect: [ :each | GtMethodCoder forMethod: class >> each ]
]

{ #category : #'sample methods' }
GtMethodCoderExamples >> returnSelf [ ^self
]

{ #category : #model }
GtMethodCoderExamples >> selfReturnCoder [
	<gtExample>
	| method methodCoder |
	method := self class >> #returnSelf.
	methodCoder := GtMethodCoder forMethod: method.
	self assert: methodCoder patternSource = 'returnSelf '.
	self assert: methodCoder bodySource = '^self'.
	^ methodCoder
]

{ #category : #model }
GtMethodCoderExamples >> thisMethod [
	<gtExample>
	| method methodCoder source |
	method := self class >> #thisMethod.
	methodCoder := GtMethodCoder forMethod: method.
	source := method sourceCode.
	self assert: methodCoder patternSource = (source first: (source indexOf: Character cr) - 1).
	self assert: methodCoder bodySource = (source allButFirst: (source indexOf: Character cr)).
	^ methodCoder
]
