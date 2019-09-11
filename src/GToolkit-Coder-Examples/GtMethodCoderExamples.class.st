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
	| method methodCoder |
	method := self class >> #?.
	methodCoder := GtMethodCoder forMethod: method.
	methodCoder ensureBuilt.
	self assert: methodCoder collapsedSource = '? anObject'.
	self assert: methodCoder source = method sourceCode.
	^ methodCoder
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
	| element |
	element := self thisMethod asElement.
	self assert: (element isKindOf: GtCoderElement).
	self assert: element isExpanded not.
	element expand.
	self assert: element isExpanded.
	^ element
]

{ #category : #'sample methods' }
GtMethodCoderExamples >> emptyBody [
]

{ #category : #model }
GtMethodCoderExamples >> emptyBodyCoder [
	<gtExample>
	| method methodCoder |
	method := self class >> #emptyBody.
	methodCoder := GtMethodCoder forMethod: method.
	methodCoder ensureBuilt.
	self assert: methodCoder collapsedSource = 'emptyBody'.
	self assert: methodCoder source = 'emptyBody'.
	^ methodCoder
]

{ #category : #model }
GtMethodCoderExamples >> emptyCoder [
	<gtExample>
	| coder |
	coder := GtMethodCoder new.
	coder classOrMetaClass: Object.
	coder object: nil.
	^ coder asElement
]

{ #category : #'sample methods' }
GtMethodCoderExamples >> emptyLines [



"Some empty lines"
]

{ #category : #model }
GtMethodCoderExamples >> emptyLinesCoder [
	<gtExample>
	| method methodCoder |
	method := self class >> #emptyLines.
	methodCoder := GtMethodCoder forMethod: method.
	methodCoder ensureBuilt.
	self assert: methodCoder collapsedSource = 'emptyLines'.
	self assert: methodCoder source = method sourceCode.
	^ methodCoder
]

{ #category : #'sample methods' }
GtMethodCoderExamples >> keyword: a selector: b [
	^ a + b
]

{ #category : #model }
GtMethodCoderExamples >> keywordSelectorCoder [
	<gtExample>
	| method methodCoder |
	method := self class >> #keyword:selector:.
	methodCoder := GtMethodCoder forMethod: method.
	methodCoder ensureBuilt.
	self assert: methodCoder collapsedSource = 'keyword: a selector: b'.
	self assert: methodCoder source = method sourceCode.
	^ methodCoder
]

{ #category : #model }
GtMethodCoderExamples >> noSpacesCoder [
	<gtExample>
	| method methodCoder |
	method := self class >> #noSpacesCoder.
	methodCoder := GtMethodCoder forMethod: method.
	methodCoder ensureBuilt.
	self assert: methodCoder collapsedSource = 'noSpacesCoder'.
	self assert: methodCoder source = method sourceCode.
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
	methodCoder ensureBuilt.
	self assert: methodCoder collapsedSource = 'returnSelf'.
	self assert: methodCoder source = method sourceCode.
	^ methodCoder
]

{ #category : #model }
GtMethodCoderExamples >> thisMethod [
	<gtExample>
	| method methodCoder source |
	method := self class >> #thisMethod.
	methodCoder := GtMethodCoder forMethod: method.
	methodCoder ensureBuilt.
	source := method sourceCode.
	self assert: methodCoder collapsedSource = (source first: (source indexOf: Character cr) - 1).
	self assert: methodCoder source = method sourceCode.
	^ methodCoder
]
