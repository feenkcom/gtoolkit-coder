Class {
	#name : #GtMethodCoderExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Model'
}

{ #category : #'sample methods' }
GtMethodCoderExamples >> ? anObject [
	"Test binary method"
]

{ #category : #'examples - model' }
GtMethodCoderExamples >> binaryMethodCoder [
	<gtExample>
	| method methodCoder |
	method := self class >> #?.

	BlUseAsyncFeatures disableDuring: [ 
		methodCoder := GtMethodCoder forMethod: method.
	].
	
	self assert: (methodCoder sourceCode isKindOf: GtCoderCompiledMethodSourceCode).
	self assert: methodCoder sourceCode compiledMethod equals: method.

	self assert: methodCoder sourceCode hasSourceText not.
	self assert: methodCoder sourceCode hasCollapsedText not.

	self assert: methodCoder selector equals: #?.
	self assert: methodCoder currentSelector equals: #?.
	self assert: methodCoder classOrMetaClass equals: self class.
	self assert: methodCoder compiledMethod equals: method.
	
	self assert: methodCoder collapsedText asString equals: '?'.
	self assert: methodCoder sourceCode hasCollapsedText.
	
	self assert: methodCoder sourceText asString equals: method sourceCode.
	self assert: methodCoder sourceCode hasSourceText.

	self assert: methodCoder currentSourceString equals: method sourceCode.

	self assert: methodCoder isModified not.
	self assert: methodCoder shouldAddOnsBeUpdated.

	^ methodCoder
]

{ #category : #'sample methods' }
GtMethodCoderExamples >> brokenExampleRemoveMeWhenFinished [
	<gtExample>
	
	^ 1/0
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
	self assert: (element isKindOf: GtExpandableCoderElement).
	self assert: element isExpanded not.
	element expand.
	self assert: element isExpanded.
	^ element
]

{ #category : #'sample methods' }
GtMethodCoderExamples >> emptyBody [
]

{ #category : #'examples - model' }
GtMethodCoderExamples >> emptyBodyCoder [
	<gtExample>
	| method methodCoder |
	method := self class >> #emptyBody.
	methodCoder := GtMethodCoder forMethod: method.
	self assert: methodCoder collapsedSource = 'emptyBody'.
	self assert: methodCoder source = 'emptyBody'.
	^ methodCoder
]

{ #category : #'examples - model' }
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

{ #category : #'examples - model' }
GtMethodCoderExamples >> emptyLinesCoder [
	<gtExample>
	| method methodCoder |
	method := self class >> #emptyLines.
	methodCoder := GtMethodCoder forMethod: method.
	self assert: methodCoder collapsedSource = 'emptyLines'.
	self assert: methodCoder source = method sourceCode.
	^ methodCoder
]

{ #category : #'sample methods' }
GtMethodCoderExamples >> example [
	<gtExample>
	
	^ 42
]

{ #category : #'examples - model' }
GtMethodCoderExamples >> exampleMethodCoder [
	<gtExample>
	| method methodCoder |

	method := self class >> #example.
	methodCoder := GtMethodCoder forMethod: method.
	
	"self assert: methodCoder selector equals: #?.
	self assert: methodCoder currentSelector equals: #?.

	self assert: methodCoder classOrMetaClass equals: self class.
	self assert: methodCoder compiledMethod equals: method.
	
	self assert: methodCoder collapsedSource equals: '?'.
	
	self assert: methodCoder source equals: method sourceCode.
	self assert: methodCoder sourceText asString equals: method sourceCode.

	self assert: methodCoder isModified not."

	^ methodCoder
]

{ #category : #'sample methods' }
GtMethodCoderExamples >> keyword: a selector: b [
	^ a + b
]

{ #category : #'examples - model' }
GtMethodCoderExamples >> keywordSelectorCoder [
	<gtExample>
	| method methodCoder |
	method := self class >> #keyword:selector:.
	methodCoder := GtMethodCoder forMethod: method.
	self assert: methodCoder collapsedSource = 'keyword:selector:'.
	self assert: methodCoder source = method sourceCode.
	^ methodCoder
]

{ #category : #'examples - model' }
GtMethodCoderExamples >> noSpacesCoder [
	<gtExample>
	| method methodCoder |
	method := self class >> #noSpacesCoder.
	methodCoder := GtMethodCoder forMethod: method.
	self assert: methodCoder collapsedSource = 'noSpacesCoder'.
	self assert: methodCoder source = method sourceCode.
	^ methodCoder
]

{ #category : #'examples - model' }
GtMethodCoderExamples >> orderedCollectionMethods [
	<gtExample>
	| class |
	class := OrderedCollection.
	^ class selectors asSortedCollection collect: [ :each | GtMethodCoder forMethod: class >> each ]
]

{ #category : #'sample methods' }
GtMethodCoderExamples >> returnSelf [ ^self
]

{ #category : #'examples - model' }
GtMethodCoderExamples >> selfReturnCoder [
	<gtExample>
	| method methodCoder |
	method := self class >> #returnSelf.
	methodCoder := GtMethodCoder forMethod: method.
	self assert: methodCoder collapsedSource = 'returnSelf'.
	self assert: methodCoder source = method sourceCode.
	^ methodCoder
]

{ #category : #'examples - model' }
GtMethodCoderExamples >> thisMethod [
	<gtExample>
	| method methodCoder source |
	method := self class >> #thisMethod.
	methodCoder := GtMethodCoder forMethod: method.
	
	source := method sourceCode.
	self assert: methodCoder collapsedSource = (source first: (source indexOf: Character cr) - 1).
	self assert: methodCoder source = method sourceCode.
	^ methodCoder
]
